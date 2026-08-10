# flocks_phosphor

Os 1.512 ícones do [Phosphor](https://phosphoricons.com), nos 6 pesos, como
`AppIconProvider` do [Flocks](../flocks) — **em fonte, e tree-shakeable**.

```yaml
dependencies:
  flocks_phosphor: ^0.1.0
```

```dart
AppThemeScope(
  iconProvider: const PhosphorIconProvider(),
  builder: (context, theme) => MyApp(theme: theme),
)
```

## Por que é fonte, e não SVG

O Flutter **não faz tree-shaking de asset**: o que está declarado no `pubspec`
vai inteiro para o bundle, use o app dez ícones ou mil. Este pacote já foi 9.072
SVGs — 35 MB que todo adotante carregava para usar vinte ícones. Era o mesmo
defeito que o `flocks` evita ao embutir só os 55 do contrato, reproduzido aqui
em escala maior.

Fonte o Flutter sabe podar. O `--tree-shake-icons` lê os `IconData` constantes
do app e remonta cada TTF só com os glifos citados. É por isso que
`flocks_material` nunca teve o problema: ícone do Material é fonte, e vem dentro
do Flutter.

Medido num app de exemplo com ~20 ícones ([`example/`](example)), `flutter build
web --release`:

| | as seis fontes no bundle |
|---|---|
| SVG (v1) | **35,4 MB**, sempre — asset não é podado |
| fonte, `--no-tree-shake-icons` | 3.001 KB |
| fonte, padrão | **91 KB** (−97,0%) |

O tamanho do pacote no repositório caiu de 35 MB / 9.073 arquivos de asset para
3,0 MB / 8 — as seis TTFs e as duas licenças de origem.

## Duas portas, e a diferença entre elas é o ganho

**O provider resolve os 55 `AppIconToken`** — o contrato, o que faz o design
system inteiro desenhar. E só. Não é economia de digitação: tudo que o provider
alcança por slug conta como usado, então um mapa dos 1.512 nomes traria a fonte
inteira de volta.

**Para os outros 1.457, escreva a classe do peso direto.** Aí o custo é de quem
usa, e é só o glifo citado:

```dart
const PhosphorIcon(FlocksPhosphorBold.storefront)
const PhosphorDuotoneIcon(FlocksPhosphorDuotone.acorn)
```

Um seletor em tempo de execução — `phosphorIcon('storefront', weight)` — anularia
tudo isso, porque tornaria os 1.512 alcançáveis de uma vez.

Quando um ícone precisa mesmo chegar por *slug*, porque quem chama é um
componente que recebe `String`, declare-o você:

```dart
const PhosphorIconProvider(
  extraIcons: <String, IconData>{
    'storefront': FlocksPhosphorRegular.storefront,
  },
)
```

O mapa é seu, é `const`, e carrega exatamente os glifos que você listar.

> **Mudou da v1**: `const AppIcon('airplane-tilt')` não desenha mais. Um nome
> fora do contrato agora cai em `question`. Use a classe do peso, ou declare o
> slug em `extraIcons`.

## Peso é eixo

```dart
const PhosphorIconProvider(weight: PhosphorWeight.bold)
```

`thin` · `light` · `regular` · `bold` · `fill` · `duotone`. Um valor restila o
ícone do app inteiro, do mesmo jeito que `AppStyle` restila as caixas.

Os seis mapas do contrato ficam alcançáveis porque o peso é resolvido em
execução — 55 tokens × 6 pesos, e é isso que aparece como ~15 KB por fonte. É
pequeno e é o comportamento certo; o que não caberia é um mapa dos 1.512.

## Duotone são dois glifos

O `duotone` é o único peso que não é 1:1 com um codepoint: cada ícone empilha
uma mancha a 20% e um contorno opaco. Por isso ele tem tipo próprio —
`PhosphorDuotoneIconData` — e widget próprio. Com um `IconData` só, metade do
desenho sumiria, e o compilador não teria como reclamar.

Duas armadilhas, as duas encontradas medindo e as duas cobertas por teste:

- **o segundo glifo não é `codepoint + 1`.** Vale para 1.462 dos 1.512, e é a
  regra que a documentação sugere — mas 48 ícones têm distâncias de 2 a 33, e
  `cell-signal-none` e `wifi-none` não têm segunda camada nenhuma. O par vem
  lido do CSS que o Phosphor publica ao lado da fonte, nunca calculado;
- **o tree-shaker não enxerga `IconData` aninhado** dentro de outro objeto
  constante dentro de um mapa constante. O contrato de duotone chegou a ser um
  `Map<String, PhosphorDuotoneIconData>`: compilava, passava em todo teste, e
  embarcava a fonte com **zero** glifos do contrato — ícones em branco só no
  build de release. Hoje são dois `Map<String, IconData>`, e a fonte sai com os
  106 glifos certos.

## De onde vêm os codepoints

De `phosphor-icons/web`, na tag fixada em `tool/phosphor_catalog.dart` — do
`style.css` que o upstream publica **ao lado de cada fonte**.

Não do campo `codepoint` de `phosphor-icons/core`, embora ele seja anunciado
como estável e destinado a implementações em fonte: em `web v2.1.2` ele diverge
das fontes em 9 nomes (`building-office`, `crane-tower`, `file-ini`, `file-txt`,
`jar-label`, `lego-smiley`, `question-mark`, `solar-roof`, `tip-jar`), aos quais
dá o codepoint do sinônimo canônico. Gerar por ele desenharia o ícone errado
nesses nove, em todos os seis pesos, sem nada ficar vermelho. O `core` continua
sendo lido pelo que só ele tem: quais nomes são apelido de quais.

## Atualizar o Phosphor

```bash
# 1. suba o pin em tool/phosphor_catalog.dart, depois:
dart run tool/vendor_phosphor.dart    # baixa TTFs + catálogo (única etapa com rede)
dart run tool/generate_icons.dart     # regenera as classes
flutter test
```

`test/architecture/` reprova se o gerado divergir do catálogo, se o catálogo
divergir do pin, se um codepoint não tiver glifo na TTF, ou se algum `IconData`
deixar de ser constante — o que faria `flutter build --release` **falhar** em
todo app que dependa deste pacote.

## Licença

Os ícones são do Phosphor Icons, MIT — as licenças dos dois repositórios de
origem estão em [`assets/fonts/`](assets/fonts), como `LICENSE-phosphor-web` e
`LICENSE-phosphor-core`. O catálogo em `vendor/phosphor_icons.json` vem do
`phosphor-icons/core` sob a mesma licença, e fica em árvore para o gerador ser
reproduzível. O código deste pacote segue a licença do Flocks (MIT), em
[LICENSE](LICENSE).
