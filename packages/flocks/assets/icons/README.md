# Ícones embutidos

O conjunto que o Flocks garante funcionar sem rede: um SVG para cada
`AppIconToken`. É o contrato mínimo que qualquer `AppIconProvider` precisa
satisfazer — e o que o provider padrão (`AppAssetIconProvider`) serve.

Deliberadamente **só os 55**. O Flutter não faz tree-shaking de asset, então
tudo que estiver declarado aqui é pago por todo adotante do core, use ele dez
ícones ou quinhentos — e 55 SVGs é o preço mínimo de o pacote desenhar sozinho,
offline, no primeiro `flutter run`.

A biblioteca inteira do Phosphor (1.512 ícones × 6 pesos) mora no pacote irmão
`flocks_phosphor`, e lá ela é **fonte**, justamente porque a mesma regra vale:
9.072 SVGs pesariam 35 MB no bundle de quem instalasse. Fonte o Flutter sabe
podar, e o `--tree-shake-icons` deixa passar só os glifos citados.

## Procedência

[Phosphor Icons](https://phosphoricons.com), peso `regular`, licença **MIT**
(texto em `LICENSE`, ao lado). Todos com `viewBox="0 0 256 256"` e
`fill="currentColor"`, então a cor vem do `ColorFilter` do `AppIcon`.

O arquivo é nomeado pelo **token do Flocks**, não pelo nome no Phosphor, para
que a resolução seja `assets/icons/<slug>.svg` sem tabela intermediária. A
tradução fica registrada aqui, que é o que permite reimportar depois.

Para atualizar ou acrescentar um ícone:

```bash
curl -sSfL -o assets/icons/<token>.svg \
  https://raw.githubusercontent.com/phosphor-icons/core/main/assets/regular/<nome-phosphor>.svg
```

## Tradução

Quatro pares caem no mesmo desenho por serem sinônimos: `add`/`plus`,
`refresh`/`sync`, `pdf`/`file-pdf` e `info`/`info-circle` (o Phosphor tem um
`info` só, e ele já é circulado). Outros repetem entre os dois conjuntos, como
`xls`/`file-xls`.

| token do Flocks | ícone no Phosphor |
|---|---|
| `add` | `plus` |
| `alert` | `warning` |
| `api-cloud` | `cloud` |
| `arrow-up` | `arrow-up` |
| `attachment` | `paperclip` |
| `audio` | `file-audio` |
| `calendar` | `calendar-blank` |
| `cancel` | `x-circle` |
| `car` | `car` |
| `chat` | `chat` |
| `check` | `check` |
| `check-circle` | `check-circle` |
| `chevron-down` | `caret-down` |
| `chevron-left` | `caret-left` |
| `chevron-right` | `caret-right` |
| `chevron-up` | `caret-up` |
| `clock` | `clock` |
| `close` | `x` |
| `copy` | `copy` |
| `csv` | `file-csv` |
| `dashboard` | `squares-four` |
| `drag-arrow` | `arrows-out-cardinal` |
| `error-circle` | `warning-circle` |
| `external-link` | `arrow-square-out` |
| `file-doc` | `file-doc` |
| `file-pdf` | `file-pdf` |
| `file-ppt` | `file-ppt` |
| `file-text` | `file-text` |
| `file-txt` | `file-txt` |
| `file-xls` | `file-xls` |
| `filter` | `funnel` |
| `group` | `users-three` |
| `hyperlink` | `link` |
| `image-landscape` | `file-image` |
| `info` | `info` |
| `info-circle` | `info` |
| `mail` | `envelope` |
| `map` | `map-trifold` |
| `microphone` | `microphone` |
| `pdf` | `file-pdf` |
| `pencil` | `pencil-simple` |
| `plus` | `plus` |
| `refresh` | `arrows-clockwise` |
| `remove` | `minus` |
| `search` | `magnifying-glass` |
| `settings` | `gear` |
| `stop` | `stop-circle` |
| `support` | `headset` |
| `swap-arrow` | `arrows-left-right` |
| `sync` | `arrows-clockwise` |
| `thumbs-down` | `thumbs-down` |
| `thumbs-up` | `thumbs-up` |
| `user` | `user` |
| `video-play` | `file-video` |
| `zip-file` | `file-zip` |
