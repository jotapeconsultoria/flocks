# Roadmap — distribuição e adoção

O pacote está maduro: 131 componentes migrados, 21 suítes de arquitetura, 1593
testes passando sem os goldens, catálogo bilíngue com gate de frescor. Um
roadmap que listasse "mais componentes" estaria lendo o problema errado. O que
falta é **distribuição** (publicar, hospedar, servir) e **adoção** (demo, guia
de migração, MCP) — e é isso que este documento ordena, por dependência real,
com o que cada fase destrava dito ao lado.

## Estado

Atualizado em 2026-08-10 — o que cada fase mediu está na seção dela.

| Fase | Estado |
| --- | --- |
| A0 — higiene pré-publicação | ✅ concluída (refs, `since:`, CHANGELOGs, `.pubignore`, contagem) |
| A1 — o corte e o publish | ✅ **publicado em 2026-08-10**: `flocks`, `flocks_phosphor` e `flocks_material` em 0.1.0 no pub.dev, sob exceção de nome concedida pelo suporte (caso `flock`), os três no publisher verificado `jotapeconsultoria.com.br` desde o primeiro publish. Tag `v0.1.0` na main |
| A1.1 — o que a pana cobrou | 🔶 **corrigido, a publicar**: a análise do pub.dev voltou com 140/160 e apontou três defeitos — `LICENSE` com texto apensado (licença não reconhecida), `pointer_interceptor` derrubando o suporte de plataforma para 2 de 6, e `if (dart.library.html)` tornando o pacote incompatível com wasm. Os três estão consertados e, junto, os `example/` que faltavam ao `flocks` e ao `flocks_material` (10 pontos cada). Medido localmente com a pana: `flocks` em **150/150** (`--no-dartdoc`), licença 10/10, plataformas 6/6, wasm limpo. Falta publicar a `0.1.1` e cortar a tag `v0.1.1`. Detalhe e lições em [`EXTRACAO.md`](packages/flocks/doc/EXTRACAO.md) |
| A2 — consumidores `git:` → hosted | ✅ concluída (2026-08-10): consumidores de origem resolvem do pub.dev, override de git removido |
| B — Widgetbook hospedado | ✅ no ar em `widgetbook.flocks.live` (2026-08-06): release de 43 MB com `main.dart.js` de 4,2 MB contra 58 MB do debug; deploy no CI com `needs` nos dois gates e purge; contagem de use cases virou artefato gerado com gate (`doc/widgetbook_use_cases.json`, 295) |
| Site — landing | ✅ no ar em `flocks.live` com a copy pós-publicação nos dois idiomas (2026-08-10), `/mcp` bilíngue no ar, tudo fiscalizado pelo `install_docs_test`; `/componentes` ainda não existe |
| C1 — contrato MCP | ✅ definido e documentado no README do `flocks_mcp`: três tools, `lang: en\|pt`, erros como `isError` dentro do resultado |
| C2 — `flocks_mcp` | ✅ **publicado em 2026-08-10**: 0.1.0 no pub.dev, no publisher verificado `jotapeconsultoria.com.br`, verificado em sessão real de agente. O aviso de não-publicado saiu no mesmo commit que o `publish_to: none`, nas quatro superfícies que o XOR do teste próprio fiscaliza |
| C3 — distribuição MCP | ✅ **concluída em 2026-08-10**: Release `flocks_mcp v0.1.0` (4 binários + `.mcpb`, disparado pela tag) e listagem no MCP Registry sob `io.github.jotapeconsultoria/flocks-mcp`, com o `server.json` gerado apontando para o `.mcpb` daquele Release. A `description` teve de cair para 92 caracteres: o registry recusa acima de 100 e o pub.dev não tem esse teto — gate novo em `server_json_test.dart` |
| D — demo | ⬜ **desbloqueada** — o site está no ar em `flocks.live`, a demo pode nascer a qualquer momento. As obrigações do pacote (dashboard + CRUD só de Flocks, `swatchFromSeed` real, export do `AppBrandConfig` — helper novo) valem como spec; o padrão de hospedagem do Widgetbook (app próprio, deployado deste repo) serve de molde |
| E — guia de migração | ⬜ **desbloqueada** — a instalação real que o guia instrui existe desde 2026-08-10 |
| F — providers de ícone (`flocks_cupertino`, `flocks_lucide`) | ⬜ aprovada em 2026-08-10, licenças verificadas (MIT / ISC); paralela, não fura a fila de D e E |

Os números daqui foram medidos em 2026-08-05, não supostos:

| Medição | Comando | Resultado |
| --- | --- | --- |
| Testes (sem golden) | `flutter test --exclude-tags golden` | 1585, todos verdes |
| Validador | `dart run tool/validate_components.dart` | 131 migrados + 7 internos |
| Dry-run `flocks` | `dart pub publish --dry-run` | 0 avisos, tarball de 16 MB |
| Dry-run adaptadores | idem | 1 aviso cada: falta `CHANGELOG.md` |
| Use cases do Widgetbook | `grep -rc '@widgetbook.UseCase' widgetbook/use_cases/` | 295 |
| Referências penduradas | `grep -rn FLOCKS_MIGRATION_PLAN packages/` | 12 |

## Fase A — publicar no pub.dev

É o único item que destrava todos os outros: a instalação hosted de verdade, a
migração dos consumidores de `git:` para versão, as instruções de instalação do
futuro MCP e do guia de migração. E é irreversível — no pub.dev só existe
`retract`, não delete. Por isso a higiene vem antes do corte.

### A0 — higiene pré-publicação, nesta ordem

**1. As referências penduradas saem da prosa.** O `FLOCKS_MIGRATION_PLAN.md`
citado em 12 pontos do código é documento interno da migração e não vem para
cá. A decisão registrada no [`EXTRACAO.md`](packages/flocks/doc/EXTRACAO.md)
era "ou o documento vem, ou o caminho sai da prosa" — sai da prosa, porque as
regras que ele definia ("Definition of Migrated", "Rule 6") hoje são
**executáveis**: vivem em `tool/component_conformance.dart` e nos gates de
`test/architecture/`. Cada referência passa a apontar para o que existe no
repo, ou vira a regra dita inline numa frase. A prioridade são os 7 doc
comments `///` — incluindo o de `lib/flocks.dart`, o entrypoint — porque são a
cara do pacote renderizada no pub.dev no dia 1. Nenhuma das 12 é link markdown,
então nenhum verificador de link as pegaria; é trabalho de leitura, não de
ferramenta.

**2. O `since:` sai do catálogo.** Das duas opções do EXTRACAO ("ou viram a
versão publicada, ou saem"), sai. Dois motivos: os 131 componentes nascem
juntos na 0.1.0, então o campo carregaria valor idêntico em 131 de 131
entradas — zero informação; e `flocks@0.1.0` já é usado como marco *interno*
por 2 componentes, então depois de publicar a 0.1.0 real o mesmo valor
significaria duas coisas diferentes. Remover de `AppComponentMeta` e do
serializer, regenerar o `catalog.json`. O campo volta com significado real
quando o primeiro componente pós-0.1.0 nascer.

**3. `CHANGELOG.md` para `flocks_phosphor` e `flocks_material`.** É o único
aviso do dry-run dos dois. Curtos e honestos, no padrão do principal — a nota
do phosphor sobre o "2.0.0 interno" (a reescrita SVG→fonte que nenhum
consumidor externo viu) já existe como comentário no pubspec e vira prosa.

**4. Higiene do tarball e de marca.** Não há `.pubignore`, então os 16 MB do
tarball do `flocks` levam junto `widgetbook/` (~1,3 MB de fonte + gerado),
`web/` (scaffolding intocado do `flutter create`) e `doc/icon-mapping.csv`
(70 KB de artefato de trabalho da migração, sem consumidor). Criar
`.pubignore` excluindo os três. O `doc/mcp/catalog.json` **fica** — é o dado do
MCP e parte da proposta do pacote. Fora do tarball, higiene de repo:
`jotape-design-tokens.md` sai (dump de tokens de uma marca cliente, sem link e
sem consumidor). Em aberto: `doc/COLOR_ACCESSIBILITY_REPORT.md` reporta marcas
cliente — ou regenera com `flocksBrand`, ou fica como prova de multi-marca.

**5. A contagem do `CHANGELOG.md` do `flocks`.** A seção `[1.0.0]` diz "129
components"; são 131. O `catalog_freshness_test` fiscaliza o README, não o
CHANGELOG — corrigir à mão.

### A1 — o corte

Num único movimento: cortar `[Unreleased]` numa seção `[0.1.0]`; tirar
`publish_to: none` dos três pubspecs **e** o aviso de "not yet published" dos
dois READMEs — o do pacote, que o `install_docs_test` fiscaliza por XOR
estrito, e o da raiz, que nenhum teste fiscaliza mas mentiria igual. Então
`dart pub publish` na ordem `flocks` → `flocks_phosphor` → `flocks_material`
(os adaptadores dependem de `flocks: ^0.1.0` por versão), e tag `v0.1.0`.

Os três pacotes entram no **publisher verificado da JotaPe** no pub.dev —
conta criada e domínio verificado — espelhando a organization
`jotapeconsultoria` do GitHub. A transferência para o publisher acontece no
primeiro publish, para nunca existir versão sob uploader pessoal.

### A2 — pós-publicação

Os consumidores de origem migram de dependência `git:` para hosted. O EXTRACAO
já registra por que isso dá prazo à fase inteira: `git:` fixa commit no lock, e
cada atualização do Flocks passa a exigir bump de ref — tolerável como
transição, ruim como permanente.

## Fase B — Widgetbook hospedado (paralela à A)

**Decisão: hospedado separado, buildado e deployado deste repo, em
`widgetbook.flocks.live`. Não vira parte do site.**

A dúvida legítima era sobreposição: o site (flocks.live) terá uma galeria de
componentes gerada do mesmo `catalog.json`, e o Widgetbook é Flutter Web com o
mesmo problema de SEO que o site resolve com casca semântica. A resposta, em
três partes:

- **Empregos distintos, uma fonte só.** A galeria do site é documentação —
  HTML semântico, indexável, gerado de `*.meta.dart` → `catalog.json`. O
  Widgetbook é prova interativa: knobs, e os eixos globais como addons — a
  demonstração viva de que três eixos restilizam 131 componentes. Nada é
  escrito duas vezes: a documentação deriva do meta; os use cases são escritos
  uma vez em `widgetbook/` e fiscalizados pelo `widgetbook_conventions_test`.
  Duplicação só existiria se o site construísse um playground próprio — e não
  vai construir.
- **O problema de SEO não se aplica.** Casca semântica existe para rankear e
  para crawler que não executa JavaScript. O Widgetbook não tem emprego de
  SEO: quem chega nele já foi convencido em outro lugar. Canvas-only é
  aceitável ali, e só ali.
- **Acoplamento de build.** O Widgetbook builda da fonte,
  `packages/flocks/widgetbook/`, no repo onde os gates o mantêm honesto.
  Deployado do CI daqui, sai em lockstep com o código; buildado de fora,
  derivaria a cada commit.

Itens, em ordem:

- **B1 — build release e medição.** `dart run build_runner build` +
  `flutter build web --release -t widgetbook/main.dart`. O build de referência
  que existia tinha 58 MB — era debug, e serve como anti-referência. Medir o
  release; o tree-shake de fonte já provou o que consegue (91 KB com ~20
  ícones no exemplo do phosphor, contra 35,4 MB da era SVG). Junto: o shell
  passa a abrir em `flocksBrand` — hoje pré-computa duas marcas cliente como
  únicos temas, o que não representa o pacote; mantê-las como opções
  secundárias de multi-marca fica em aberto.
- **B2 — deploy no CI.** Job novo no `ci.yml`: push em `main`, depois dos
  gates verdes, publica o build. Nav do site aponta para cá como link externo.
- **B3 — a contagem vira fato derivado.** "295 use cases" já circulou como 293
  e 297 porque não há gate — o mesmo modo de falha que o `catalog.json` tinha
  antes do `catalog_freshness_test`. Mesmo remédio: a contagem passa a ser
  gerada e fiscalizada, e quem cita, deriva.

## Fase C — servidor MCP (contrato primeiro, servidor depois)

O dado está pronto: `doc/mcp/catalog.json`, 131 componentes, bilíngue na
fonte. O que não existe é o servidor — e, antes dele, o contrato.

**C1 — o contrato** (barato, e destrava qualquer consumidor de escrever
integração antes do servidor existir):

| Tool | Entrada | Devolve |
| --- | --- | --- |
| `list_components` | `category?` (`atom`·`molecule`·`organism`) | id, nome e summary de cada componente |
| `get_component` | `id` | a ficha completa: props, whenToUse/whenNotToUse, do/dont, a11y, examples, related |
| `search_components` | `query` | busca em nome, summary e descrição |

Todas aceitam `lang: en | pt` — o catálogo é bilíngue por tipo, não por
tradução, então não há fallback a inventar. Transporte stdio. Instalação
documentada para Claude Code, Claude Desktop e Cursor.

**C2 — a implementação.** Pacote novo `flocks_mcp`, membro do workspace, em
Dart — a audiência é dev Flutter, que já tem o SDK na máquina; distribuição
por `dart pub global activate flocks_mcp`, coerente com o ecossistema. Lê o
catálogo embarcado. Publica depois do `flocks`, porque a 0.1.0 estabiliza o
schema do catálogo — inclusive a remoção do `since:` (A0.2), que é melhor
acontecer antes de o MCP nascer do que depois.

## Fase D — demo (flocks.live/demo)

A demo aplica a marca do visitante — semente hex e logo, processados
client-side — a um dashboard e um CRUD completos. A implementação mora no app
do site; o que é **obrigação deste repo**:

- as duas telas compostas exclusivamente de componentes Flocks — leitura densa
  e escrita com formulário, as duas coisas que um design system precisa provar;
- `swatchFromSeed` de verdade, não uma aproximação — a paleta da demo é o
  mecanismo real do pacote;
- os três eixos globais alternáveis, claro e escuro derivados da mesma semente;
- **exportar o `AppBrandConfig`**: o visitante leva o código pronto. Isso exige
  um helper de serialização para snippet Dart que hoje não existe no pacote —
  a única feature nova de pacote prevista neste roadmap.

## Fase E — guia de migração Material→Flocks

Baseado em quatro migrações reais de apps Material para Flocks — conhecimento
que não existe em outro lugar e é caro de escrever. Formato: mapa componente a
componente, o que não tem equivalente e por quê, as armadilhas que mordem, e
estimativa de esforço por app. Acompanhante forte: um conjunto inicial de
gates de arquitetura que o adotante cola no repo dele — a parte que nenhum
outro design system entrega. Depende da publicação, porque o guia instrui
instalação real.

## Fase F — mais dois providers de ícone

O contrato `AppIconProvider` foi desenhado para pluralidade, e o teste de
contrato cruzado absorve adaptadores novos de graça. Dois entram na fila,
cada um copiando um molde que já existe no repo:

- **`flocks_cupertino`** (molde `flocks_material`): adapter fino sobre o
  pacote `cupertino_icons` — **MIT, verificado em 2026-08-10**. Precisão
  obrigatória na prosa: são os ícones do pacote MIT, **não** os SF Symbols
  da Apple, que não podem ser redistribuídos.
- **`flocks_lucide`** (molde `flocks_phosphor`): release pinada do Lucide
  vendorada SVG→fonte — **ISC, verificado em 2026-08-10**, sem cláusula
  contra redistribuição em pacote (a armadilha que eliminou unDraw e
  Streamline). Um peso só (stroke), sem a matrix de 6 do phosphor.

Um `flocks_cupertino` ao lado do `flocks_material` não contradiz a tese do
zero-Material/Cupertino **no core** — ele a prova: o eixo de ícone é plural
de verdade. E cada adaptador é uma porta de descoberta no pub.dev. Restrição
de fila: trabalho paralelo e barato, mas **não fura a prioridade de D e E**,
que são os motores de adoção.

## Ordem e dependências

```
A (publicar)  ──destrava──▶  C2 (servidor MCP), E (guia), consumo hosted
B (widgetbook)               paralela à A, independente
C1 (contrato MCP)            paralelo, barato, antes de C2
D (demo)                     desbloqueada — o site está no ar; o helper de
                             export do AppBrandConfig entra junto
E (guia)                     depende de A
F (icon providers)           paralela e barata; atrás de D e E em prioridade
```

## O que este roadmap não cobre

O site flocks.live em si, a identidade visual (logo, wordmark, ilustrações) e
qualquer decisão de negócio. O passo a passo operacional da publicação
continua no [`EXTRACAO.md`](packages/flocks/doc/EXTRACAO.md), que é atualizado
quando cada dívida for executada — este documento diz a ordem e o porquê.
