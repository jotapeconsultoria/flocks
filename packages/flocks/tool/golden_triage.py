#!/usr/bin/env python3
"""Prepara a revisão de falhas de golden: monta contact sheets e ordena por
magnitude. **Não julga.**

## Por que não julga

A primeira versão deste script tentava separar automaticamente "mudou porque a
fonte mudou" de "mudou porque o layout quebrou", classificando pixel em texto vs
cromo e vigiando a caixa envolvente do cromo. O canário derrubou a ideia: um
deslocamento sintético de 3px em METADE da imagem passou como "só texto mudou",
porque caixa envolvente global é cega a deslocamento interno.

E o problema é mais fundo que o bug. Trocar família tipográfica muda a LARGURA
do texto, e todo cromo dimensionado por texto (pílula de badge, chip, cabeçalho
de tabela) se move junto — legitimamente. Não existe métrica de posição que
separe esse movimento legítimo de um deslocamento por regressão, porque são o
mesmo sinal.

Então o script faz o que dá para fazer com honestidade: junta master, novo e
diferença lado a lado, agrupa por família e ordena pelo tamanho da mudança. Quem
julga é o olho. O precedente do repositório é claro — um `--update-goldens` em
massa já escondeu um bug de layout de verdade.

## Uso

    python3 tool/golden_triage.py                    # tabela + monta as folhas
    python3 tool/golden_triage.py --no-sheets        # só a tabela

As folhas saem em `test/_triage/<família>.png`, uma por família, cada linha um
golden: `master | novo | diferença amplificada`. Esse diretório é descartável —
apague depois de revisar.
"""

from __future__ import annotations

import argparse
import shutil
import sys
from collections import defaultdict
from pathlib import Path

try:
    import numpy as np
    from PIL import Image, ImageDraw
except ImportError:  # pragma: no cover - erro de ambiente, não de lógica
    sys.exit('Faltam dependências: pip3 install numpy pillow')

# Diferença por canal (0..255) a partir da qual dois pixels contam como
# distintos: acima do ruído de rasterização, abaixo de qualquer mudança visível.
DELTA_FLOOR = 24

# Sufixo de marca/brilho que o `goldenMatrixTest` acrescenta ao nome. Tirar isso
# dá a família, que é a unidade de revisão.
VARIANTS = (
    '_jotape_light', '_jotape_dark', '_zxtrack_light', '_zxtrack_dark',
    '_light', '_dark',
)

GUTTER = 8
LABEL_H = 14


def _rgb(path: Path) -> np.ndarray:
    """Carrega em RGB, compondo sobre branco se houver alfa."""
    img = Image.open(path)
    if img.mode in ('RGBA', 'LA', 'P'):
        img = img.convert('RGBA')
        flat = Image.new('RGB', img.size, (255, 255, 255))
        flat.paste(img, mask=img.split()[-1])
        img = flat
    return np.asarray(img.convert('RGB'), dtype=np.int16)


def _family(name: str) -> str:
    for suffix in VARIANTS:
        if name.endswith(suffix):
            return name[: -len(suffix)]
    return name


def _diff_image(a: np.ndarray, b: np.ndarray) -> Image.Image:
    """Mapa de diferença: o que mudou fica vermelho sobre o master esmaecido."""
    if a.shape != b.shape:
        h = max(a.shape[0], b.shape[0])
        w = max(a.shape[1], b.shape[1])
        canvas = Image.new('RGB', (w, h), (255, 0, 255))  # magenta = incomparável
        return canvas
    changed = np.abs(a - b).max(axis=2) > DELTA_FLOOR
    out = (a * 0.25 + 191).astype(np.uint8)
    out[changed] = (220, 0, 60)
    return Image.fromarray(out, 'RGB')


def _crop_box(a: np.ndarray, b: np.ndarray, pad: int = 24) -> tuple:
    """Caixa da região que mudou, com respiro — é onde o olho tem de ir.

    Os goldens saem em alta densidade (7000px de largura numa folha de 4). Sem
    recortar, a folha é reduzida a ponto de nada ser legível, e uma revisão que
    não enxerga é pior que nenhuma: dá a sensação de ter conferido.
    """
    if a.shape != b.shape:
        return (0, 0, a.shape[1], a.shape[0])
    changed = np.abs(a - b).max(axis=2) > DELTA_FLOOR
    if not changed.any():
        return (0, 0, a.shape[1], a.shape[0])
    rows = np.where(changed.any(axis=1))[0]
    cols = np.where(changed.any(axis=0))[0]
    return (
        max(0, int(cols[0]) - pad), max(0, int(rows[0]) - pad),
        min(a.shape[1], int(cols[-1]) + pad),
        min(a.shape[0], int(rows[-1]) + pad),
    )


def _sheet(family: str, entries: list[dict], out_dir: Path,
           max_width: int = 1500) -> Path:
    """Uma folha por família: cada linha é `master | novo | diferença`,
    recortada na região que mudou."""
    rows = []
    for e in entries:
        a, b = _rgb(e['master']), _rgb(e['test'])
        box = _crop_box(a, b)
        trio = [
            Image.fromarray(a.astype('uint8')).crop(box),
            Image.fromarray(b.astype('uint8')).crop(box),
            _diff_image(a, b).crop(box),
        ]
        # Cabe três lado a lado dentro de `max_width`?
        each = (max_width - 2 * GUTTER) // 3
        if trio[0].width > each:
            scale = each / trio[0].width
            size = (each, max(1, int(trio[0].height * scale)))
            trio = [i.resize(size, Image.LANCZOS) for i in trio]
        rows.append((e['golden'], trio))

    width = max(sum(i.width for i in t) + 2 * GUTTER for _, t in rows)
    height = sum(max(i.height for i in t) + GUTTER + LABEL_H for _, t in rows)
    sheet = Image.new('RGB', (width, height + LABEL_H), (250, 250, 250))
    draw = ImageDraw.Draw(sheet)

    y = 0
    for label, trio in rows:
        draw.text((2, y + 2), f'{label}   master | novo | diff', fill=(20, 20, 20))
        y += LABEL_H
        x = 0
        for img in trio:
            sheet.paste(img, (x, y))
            x += img.width + GUTTER
        y += max(i.height for i in trio) + GUTTER

    out_dir.mkdir(parents=True, exist_ok=True)
    path = out_dir / f'{family}.png'
    sheet.save(path)
    return path


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', default='test', help='raiz da varredura')
    parser.add_argument('--out', default='test/_triage',
                        help='onde gravar as folhas')
    parser.add_argument('--no-sheets', action='store_true',
                        help='só a tabela, sem montar as folhas')
    args = parser.parse_args()

    entries = []
    for master in sorted(Path(args.root).rglob('*_masterImage.png')):
        test = master.with_name(
            master.name.replace('_masterImage.png', '_testImage.png'))
        if not test.exists():
            continue
        golden = master.name.replace('_masterImage.png', '')
        a, b = _rgb(master), _rgb(test)
        if a.shape != b.shape:
            pct, note = 100.0, f'TAMANHO MUDOU {a.shape[:2]} -> {b.shape[:2]}'
        else:
            pct = 100.0 * float((np.abs(a - b).max(axis=2) > DELTA_FLOOR).mean())
            note = ''
        entries.append({'golden': golden, 'family': _family(golden),
                        'master': master, 'test': test, 'pct': pct,
                        'note': note})

    if not entries:
        print(f'Nenhum par em {args.root}/**/failures — rode '
              '`flutter test --tags golden` primeiro.')
        return 0

    families: dict[str, list[dict]] = defaultdict(list)
    for e in entries:
        families[e['family']].append(e)

    ordered = sorted(families.items(),
                     key=lambda kv: -max(e['pct'] for e in kv[1]))

    print(f'{len(entries)} goldens falhando · {len(families)} famílias')
    print()
    print(f'{"família":40} {"n":>3} {"maior Δ":>8}  observação')
    for family, es in ordered:
        notes = '; '.join(sorted({e['note'] for e in es if e['note']}))
        print(f'{family[:40]:40} {len(es):3} '
              f'{max(e["pct"] for e in es):7.2f}%  {notes}')

    if not args.no_sheets:
        out_dir = Path(args.out)
        if out_dir.exists():
            shutil.rmtree(out_dir)
        for family, es in ordered:
            _sheet(family, sorted(es, key=lambda e: e['golden']), out_dir)
        print()
        print(f'{len(families)} folhas em {out_dir}/ — revise TODAS antes de '
              'rebaselinar.')
        print('O script mede a mudança; ele não diz se ela está certa.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
