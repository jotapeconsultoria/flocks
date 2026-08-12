# flocks_demo

A demo de white-label do Flocks — o que roda em
[flocks.live/demo/](https://flocks.live/demo/).

O visitante informa a cor da marca dele, envia o logo, e vê um dashboard e um
CRUD inteiros vestidos com a identidade dele. Depois copia o Dart que reproduz o
que viu.

Não é publicável (`publish_to: none`): o que se publica no pub.dev é o `flocks`,
e isto existe para vendê-lo.

```bash
flutter run -d chrome
```

## O que ela prova

**Duas telas, e não uma vitrine de componentes.** Para vitrine existe o
[Widgetbook](https://widgetbook.flocks.live). O que uma vitrine não responde é se
doze números, dois gráficos e uma tabela paginada continuam legíveis *juntos*
(dashboard), e se validação, erro, vazio e carregando se comportam *dentro* de
uma tela em vez de num use case isolado (CRUD). São as duas coisas que um design
system precisa provar.

**Uma semente, e o sistema inteiro responde.** Nenhum widget aqui recebe cor,
raio ou sombra por parâmetro. O que muda quando o visitante mexe no painel muda
porque os componentes leem o tema sozinhos.

**Nem um `MaterialApp`.** A árvore é `AppTheme` + `Directionality`, e o
`test/architecture_test.dart` mantém assim.

## O contrato de estado

```
/demo/?seed=4F46E5&style=outlined&radius=redondo&font=Poppins&dark=1&screen=crud
```

| Parâmetro | Valores | Padrão |
| --- | --- | --- |
| `seed` | hex sem `#` | `4F46E5` |
| `style` | `filled` · `outlined` · `elevated` | `filled` |
| `radius` | `reto` · `redondo` · `circular` · `padrao` | `padrao` |
| `font` | `Poppins` · `SpaceGrotesk` | `Poppins` |
| `dark` | `0` · `1` | `0` |
| `screen` | `dashboard` · `crud` | `dashboard` |

Os três eixos do meio são, letra por letra, os `.name` dos enums que o `flocks`
já tem — não existe tabela de tradução para sair de sincronia.

**Parâmetro inválido cai no padrão, em silêncio.** Um link de demo é copiado,
truncado por aplicativo de mensagem e editado à mão; a demo que responde a isso
com tela de erro é a demo que ninguém chega a ver.
`test/demo_config_test.dart` corrompe cada parâmetro de quinze jeitos.

## O logo não sobe. E isso é um teste, não uma promessa

Os bytes do logo moram num `Uint8List` no estado da tela e são desenhados por
`Image.memory` / `SvgPicture.memory`. **Nenhuma URL é criada** — nem remota, nem
`blob:`, nem `data:`. O nome do arquivo nunca chega ao estado da demo: o formato
sai da assinatura binária, não da extensão.

Como o código da aplicação não tem caminho de rede nenhum — os providers padrão
de ícone e ilustração do `flocks` leem assets locais, e as fontes vêm
empacotadas — o gate pode ser absoluto:

| Gate | O que ele prende |
| --- | --- |
| `test/no_network_test.dart` | monta a demo com um logo carregado, mexe em todos os eixos e nas duas telas, e exige **zero** requisições HTTP |
| `test/architecture_test.dart` | reprova qualquer import de cliente HTTP, `createObjectURL`, provider de rede ou Material — e o `pubspec.yaml` que declarar uma dependência de rede |
| `test/demo_config_test.dart` | prova que a URL compartilhável carrega os seis campos do contrato e nada mais |

Consequência para quem usa: **o link compartilhável leva cor, fonte e eixos, mas
não leva o logo.** A demo diz isso na tela, e não só aqui.

### O que os gates NÃO alcançam, e por quê

Três requisições saíam do **runtime do Flutter Web**, e não do código da demo —
nenhum teste em VM as enxerga, porque acontecem no bootstrap JavaScript e na
fila de fontes do engine, antes e fora de qualquer Dart nosso. Duas já foram
corrigidas; sobra uma. Só se vê abrindo a demo num navegador, e só com uma
medição que inclua terceiros:
`performance.getEntriesByType('resource')` no console da página (a aba de rede
filtrada por origem esconde exatamente estas):

1. **CanvasKit do `www.gstatic.com`** — o default do `flutter build web` é
   `--web-resources-cdn`. **Corrigido**: o CI passa `--no-web-resources-cdn`, e
   `test/architecture_test.dart` confere que a flag continua no workflow. A
   medição de 2026-08-11 confirma: zero requisições a `www.gstatic.com`.
2. **Roboto do `fonts.gstatic.com`** (63.464 B) — o CanvasKit exige uma fonte de
   fallback registrada, e baixa a Roboto quando nenhuma família do
   `FontManifest.json` se chama `Roboto`. A nossa não se chama, então isto sai a
   cada carga fria, aguardado antes do primeiro frame, independentemente de a
   aplicação usá-la (a demo não usa: tudo é Poppins ou Space Grotesk).
   **Não corrigido.**
3. **Noto Sans Symbols do `fonts.gstatic.com`** (69.116 B) — a fila de fallback
   do engine baixa uma Noto por codepoint que as famílias *daquele span* não
   cobrem. O bloco de código do painel pedia uma pilha mono do sistema que o
   CanvasKit não conhece, e cada acento do comentário em português do snippet
   virava codepoint órfão. **Corrigido na raiz**: o `flocks` empacota a IBM Plex
   Mono, a família está registrada e a fila nunca abre. Medido nos dois builds
   servidos lado a lado — `origin/main` faz 20 requisições, 2 delas de terceiro;
   com a mono são 21, 1 de terceiro. Em troca, a demo baixa 275.796 B de mono da
   própria origem. A medição de produção acima é anterior: em `flocks.live` isto
   só vale no próximo deploy.

A de fonte que sobra não desmente o que a demo promete ao visitante — o logo
continua sem sair da aba, porque isso é *download* de fonte e não upload, e o
gate de rede continua provando que nenhum byte do logo vai a lugar nenhum. Mas
"esta página não contacta host nenhum" é falso hoje, e por isso não está escrito
na tela nem aqui. [`TODO.md`](TODO.md) tem a medição, a citação do engine, o
caminho de conserto que resta e os lugares onde a frase falsa ainda está
escrita.

## Estrutura

```
lib/src/state/     DemoConfig <-> Uri (Dart puro), a marca, o logo, a ponte com o navegador
lib/src/screens/   dashboard e CRUD
lib/src/panel/     o painel de marca, feito dos próprios componentes que ele controla
lib/src/data/      dados sintéticos e determinísticos
```

`state/browser.dart` é a única porta para o navegador — reescrever a query e
abrir o seletor de arquivo — atrás de um import condicional por
`dart.library.io`, com stub para a VM. Nunca `dart.library.html`: ela é falsa no
dart2wasm, e o `flocks` já levou esse bug uma vez.

Analytics: ver [`TODO.md`](TODO.md). Os nomes estão fixados; nada está
implementado.
