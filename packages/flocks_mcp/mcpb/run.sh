#!/bin/sh
# O launcher do bundle .mcpb para macOS e Linux. Existe por duas razões,
# nenhuma cosmética:
#
# 1. O Claude Desktop extrai o zip descartando os modos Unix (mcpb#294): todo
#    arquivo chega como 0600, sem bit de execução, e chamar o binário direto
#    falha com EACCES em toda instalação. O `/bin/sh` só precisa de LEITURA
#    neste script, e o dono pode devolver o `+x` aos próprios arquivos.
# 2. O manifesto só seleciona por OS (`darwin`/`win32`/`linux`) — arquitetura
#    não existe no formato. O `uname -m` daqui é a seleção que falta.
#
# A regra do entrypoint em `bin/flocks_mcp.dart` vale aqui também: NADA no
# stdout, que é o canal JSON-RPC do cliente. Diagnóstico vai para o stderr.
set -eu

dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

case "$(uname -s)" in
  Darwin) os=darwin ;;
  *) os=linux ;;
esac

case "$(uname -m)" in
  arm64 | aarch64) arch=arm64 ;;
  *) arch=x64 ;;
esac

bin="$dir/flocks_mcp-$os-$arch"

if [ ! -f "$bin" ]; then
  echo "flocks_mcp: this bundle carries no binary for $os-$arch ($bin)." >&2
  exit 1
fi

# Devolve o que a extração tirou (o `+x`, mcpb#294) e, no macOS, remove a
# quarentena que o Gatekeeper aplicaria a um bundle baixado — o binário é
# ad-hoc-signed pelo linker do Dart, não notarizado. Best-effort: se já está
# tudo certo, os dois comandos são no-op.
chmod +x "$bin" 2>/dev/null || true
xattr -d com.apple.quarantine "$bin" 2>/dev/null || true

exec "$bin" "$@"
