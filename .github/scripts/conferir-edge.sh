#!/usr/bin/env bash
# Confere que o edge da Bunny passou a servir o que o deploy acabou de subir —
# BYTE A BYTE, contra o arquivo local, sem cache-buster na URL.
#
# Uso:
#   printf '%s' "$pares" | conferir-edge.sh <base> [zone-id]
#
# Cada par é `caminho-da-URL|arquivo-local`, separado dos outros por espaço ou
# quebra de linha e sem espaço DENTRO de nenhum dos dois lados: o laço abaixo
# separa por word-splitting, e não por array associativo (`declare -A` é bash
# 4+, e assim isto também roda na mão de quem depura no macOS). O `<base>` é a
# origem sem barra final
# (`https://flocks.live`); o `<zone-id>` é a Pull Zone que o laço repurga entre
# tentativas — sem ele, o laço só espera.
#
# POR QUE ISTO EXISTE, e por que nesta forma. 2026-08-10, o dia em que
# `flocks.live/` ficou ~3h30 servindo uma home sem o link "Demo" com o job de
# deploy VERDE. A linha do tempo, medida:
#
#   21:46:29-40  os 18 arquivos de site/ sobem, cada PUT com 201.
#   21:46:41     a Pull Zone é purgada — UM SEGUNDO depois do último PUT.
#   22:03:22     só então o `index.html` materializa nas réplicas.
#   até 00:55    `flocks.live/` ainda servia a versão de 14:08, sem o link,
#                vinda da réplica DE-768 — e com `cdn-cache: MISS`, isto é,
#                buscando na origem e recebendo bytes velhos. No mesmo instante
#                `flocks.live/index.html` já servia a de 22:03, de outra
#                réplica. A mesma zone, duas verdades.
#   ~01:20       convergiu sozinho: `/` passou a vir de DE-634, com 22:03.
#
# Duas lições estão embutidas na forma daqui. A primeira: purgar cedo é PIOR
# que não purgar — limpa o edge enquanto a origem ainda tem os bytes velhos, e
# o edge recacheia o velho pelo TTL inteiro. Daí comparar, repurgar, esperar,
# comparar de novo. A segunda: conferir o código HTTP do PUT não é conferir o
# deploy. O upload estava perfeito; o que estava errado era o que o visitante
# recebia. E a URL conferida tem de ser a que o visitante abre, porque foi
# exatamente entre `/` e `/index.html` que a divergência se esconde.
#
# VERMELHO AQUI NÃO SIGNIFICA "quebrado para sempre": significa que o edge
# ainda não convergiu. O conserto normal é re-rodar o job. Se persistir por
# vários ciclos, então sim é réplica divergente e o lugar de olhar é o painel
# da Bunny. O chamador pode passar a linha de remediação dele em `EDGE_DICA`.
#
# Um script, e não três blocos de `run:`, porque três jobs escrevem em Storage
# Zone e purgam Pull Zone (`site`, `demo`, `widgetbook`) e o gate só vale se
# for o MESMO nos três — Actions não tem anchor de YAML para compartilhá-lo.
set -o pipefail

base=${1:-}
zone=${2:-}
if [ -z "$base" ]; then
  echo "uso: conferir-edge.sh <base> [zone-id] < pares (URL|arquivo)" >&2
  exit 2
fi

# ~22 minutos de orçamento, escalonados. O número vem da medição, não do gosto:
# a replicação levou 17 minutos para fechar na maioria das réplicas, então um
# teto de 10 reprovaria um deploy que ia ficar bom. Não estica até as 3h30 que
# o caso do `/` levou porque ali o que segurava era o edge cacheando bytes
# velhos, e é justamente isso que o repurge deste laço desfaz. `EDGE_DELAYS`
# existe para o ensaio à mão (vazio = uma volta só, veredito imediato).
delays=${EDGE_DELAYS-15 30 60 120 180 300 300 300}

pending=$(cat)
# O word-splitting de `$pending` é o MECANISMO, não descuido: é ele que quebra
# os pares em uma linha cada para o `grep -c` contar. Entre aspas, `printf`
# imprimiria a entrada inteira como uma linha só e o total seria sempre 1.
# shellcheck disable=SC2086
total=$(printf '%s\n' $pending | grep -c .)
if [ "$total" -eq 0 ]; then
  echo "::error::Nenhum par URL|arquivo na entrada — não há o que conferir."
  exit 1
fi
echo "Conferindo ${total} URL(s) em ${base} contra os arquivos que subiram."

# `sha256sum` é coreutils (o runner); `shasum` é o que existe no macOS de quem
# roda isto à mão para depurar uma divergência.
soma() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

corpo=$(mktemp)
trap 'rm -f "$corpo"' EXIT

attempt=0
while : ; do
  still=''
  for pair in $pending; do
    url=${pair%%|*}
    file=${pair##*|}
    want=$(soma "$file")
    if curl -sSf -o "$corpo" "${base}${url}"; then
      got=$(soma "$corpo")
    else
      got='(a busca falhou)'
    fi
    if [ "$got" = "$want" ]; then
      echo "confere: ${url}"
    else
      echo "divergente: ${url} (edge=${got} repo=${want})"
      still="${still}${pair} "
    fi
  done
  pending=$still
  if [ -z "$pending" ]; then
    echo "As ${total} URL(s) conferem byte a byte com o que subiu."
    break
  fi
  # Mesmo caso da linha do `total`: `$delays` é uma lista de segundos separados
  # por espaço, e é o split que a transforma nos parâmetros posicionais que o
  # `$#` conta e o `shift` percorre. Entre aspas viraria um parâmetro só, `$#`
  # seria sempre 1, e o laço desistiria depois da primeira espera.
  # shellcheck disable=SC2086
  set -- $delays
  if [ "$attempt" -ge "$#" ]; then
    echo "::error::O edge não passou a servir o que subiu: ${pending}"
    if [ -n "${EDGE_DICA:-}" ]; then
      echo "::error::${EDGE_DICA}"
    fi
    exit 1
  fi
  shift "$attempt"
  wait_for=$1
  attempt=$((attempt + 1))
  if [ -n "$zone" ]; then
    curl -sS -o /dev/null -X POST -H "AccessKey: ${BUNNY_API_KEY:-}" \
      "https://api.bunny.net/pullzone/${zone}/purgeCache" || true
  fi
  echo "Repurgado; aguardando ${wait_for}s (tentativa ${attempt})."
  sleep "$wait_for"
done
