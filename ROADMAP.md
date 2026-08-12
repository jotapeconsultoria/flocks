# Roadmap — distribuição e adoção

O pacote está maduro: 131 componentes migrados, 25 suítes de arquitetura, 1658
testes passando sem os goldens, catálogo bilíngue com gate de frescor. Um
roadmap que listasse "mais componentes" estaria lendo o problema errado. O que
falta é **distribuição** (publicar, hospedar, servir) e **adoção** (demo, guia
de migração, MCP) — e é isso que este documento ordena, por dependência real,
com o que cada fase destrava dito ao lado.

## Estado

Atualizado em 2026-08-11 — o que cada fase mediu está na seção dela.

| Fase | Estado |
| --- | --- |
| A0 — higiene pré-publicação | ✅ concluída (refs, `since:`, CHANGELOGs, `.pubignore`, contagem) |
| A1 — o corte e o publish | ✅ **publicado em 2026-08-10**: `flocks`, `flocks_phosphor` e `flocks_material` em 0.1.0 no pub.dev, sob exceção de nome concedida pelo suporte (caso `flock`), os três no publisher verificado `jotapeconsultoria.com.br` desde o primeiro publish. Tag `v0.1.0` na main. No mesmo dia veio a **0.1.1**, com o que a pana cobrou (LICENSE reconhecível, plataformas, `example/`), e a tag `v0.1.1` |
| A1.1 — o que a pana cobrou | ✅ **publicado em 2026-08-10**: a análise da `0.1.0` voltou com 140/160 e apontou três defeitos — `LICENSE` com texto apensado (licença não reconhecida), `pointer_interceptor` derrubando o suporte de plataforma para 2 de 6, e `if (dart.library.html)` tornando o pacote incompatível com wasm. Os três foram consertados e, junto, os `example/` que faltavam ao `flocks` e ao `flocks_material` (10 pontos cada). A `0.1.1` está no ar nos quatro, com a tag `v0.1.1`. A reanálise fechou: **os quatro em 160/160**. A API devolve `0/0` enquanto ela corre — é análise pendente, não nota zero. Detalhe e lições em [`EXTRACAO.md`](packages/flocks/doc/EXTRACAO.md) |
| A2 — consumidores `git:` → hosted | ✅ concluída (2026-08-10): consumidores de origem resolvem do pub.dev, override de git removido |
| B — Widgetbook hospedado | ✅ no ar em `widgetbook.flocks.live` (2026-08-06): release de 43 MB com `main.dart.js` de 4,2 MB contra 58 MB do debug; deploy no CI com `needs` nos dois gates e purge; contagem de use cases virou artefato gerado com gate (`doc/widgetbook_use_cases.json`, 295) |
| Site — landing | ✅ no ar em `flocks.live` com a copy pós-publicação nos dois idiomas (2026-08-10), `/mcp` bilíngue no ar, tudo fiscalizado pelo `install_docs_test`; `/componentes` ainda não existe. **Cicatriz de 2026-08-10**: a home em inglês passou ~3h30 servindo a nav sem o link `/demo/` com o job de deploy VERDE — os 18 PUTs deram 201 e a zone foi purgada 1 s depois do último, mas a Storage Zone é geo-replicada: o `index.html` só materializou nas réplicas 17 min depois, e a que atendia `/` seguiu servindo a versão anterior (com `cdn-cache: MISS`, buscando na origem e recebendo bytes velhos) enquanto `/index.html` já servia a nova. Convergiu sozinho. Purgar 1 s depois do PUT é pior que não purgar — recacheia o velho pelo TTL. O gate novo compara byte a byte o que o edge devolve com o que subiu, repurgando entre tentativas, e o `workflow_dispatch` ganhou `force_site` porque não havia caminho de re-deploy sem commit de mentirinha em `site/` |
| C1 — contrato MCP | ✅ definido e documentado no README do `flocks_mcp`: três tools, `lang: en\|pt`, erros como `isError` dentro do resultado |
| C2 — `flocks_mcp` | ✅ **publicado em 2026-08-10**: no pub.dev sob o publisher verificado `jotapeconsultoria.com.br`, verificado em sessão real de agente, e em **160/160** na pana desde a `0.1.1`. O aviso de não-publicado saiu no mesmo commit que o `publish_to: none`, nas quatro superfícies que o XOR do teste próprio fiscaliza |
| C3 — distribuição MCP | ✅ **concluída em 2026-08-10**: Release do `flocks_mcp` (4 binários + `.mcpb`, disparado pela tag) e listagem no MCP Registry sob `io.github.jotapeconsultoria/flocks-mcp`, com o `server.json` gerado apontando para o `.mcpb` daquele Release. Republicada na `0.1.1` no mesmo dia — confirmada `isLatest` na API do registry. A `description` teve de cair para 92 caracteres: o registry recusa acima de 100 e o pub.dev não tem esse teto — gate novo em `server_json_test.dart`. As armadilhas do `publish` (o `curl -LO` que não sobrescreve, o `latest` que ainda é a release anterior, o 403 de token sem `read:org`) estão no README do pacote |
| D — demo | ✅ **no ar em 2026-08-10** em `flocks.live/demo/`: pacote `flocks_demo` (membro do workspace, `publish_to: none` — é vitrine, não biblioteca), dashboard e CRUD só de componentes Flocks, estado na URL, logo client-side, e o `toDartSnippet` que escreve a marca em Dart colável. Deployada pelo CI deste repo, sob prefixo próprio da zone do site, com casca semântica indexável. **Pendência**: o snippet emite `flippedSwatch`, que só existe na `[Unreleased]` do `flocks` — enquanto a 0.1.2 não sai, o código exportado não compila contra o pub.dev |
| E — guia de migração | ⬜ **desbloqueada** — a instalação real que o guia instrui existe desde 2026-08-10 |
| F — providers de ícone (`flocks_cupertino`, `flocks_lucide`) | ✅ **implementados em 2026-08-10**: `flocks_cupertino` no molde do `flocks_material` (glifos do pacote `cupertino_icons`, MIT — **não** os SF Symbols da Apple) e `flocks_lucide` no molde do `flocks_phosphor` (fonte vendorada, ISC, 853.920 → 19.624 bytes com `--tree-shake-icons`). O teste de contrato cruzado cobre os quatro adaptadores. O `publish_to: none` dos dois saiu junto com o aviso do README de cada um, no mesmo commit que o XOR do `install_docs_test` cobra — os dois entram na linha pública em 0.1.0, contra o `flocks` que já está no ar |

Os números daqui foram medidos em 2026-08-12, não supostos:

| Medição | Comando | Resultado |
| --- | --- | --- |
| Testes do `flocks` (sem golden) | `flutter test --exclude-tags golden` | 1658, todos verdes |
| Testes dos sete pacotes | os sete steps de teste do job `checks`, somados | 1916, todos verdes |
| Validador | `cd packages/flocks && dart run tool/validate_components.dart` | 131 migrados + 7 internos |
| Dry-run `flocks` | `dart pub publish --dry-run` | 0 avisos, tarball de 1 MB — eram 16 MB antes do `.pubignore` da A0, que tirou os 302 goldens (14,7 MB) |
| Dry-run dos 4 adaptadores e do `flocks_mcp` | idem | 0 avisos cada; os seis pacotes publicáveis têm `CHANGELOG.md` |
| Use cases do Widgetbook | `grep -rc '@widgetbook.UseCase' widgetbook/use_cases/` | 295 |
| Referências penduradas | `grep -rn FLOCKS_MIGRATION_PLAN packages/` | 1 — a nota da dívida já resolvida, em [`EXTRACAO.md`](packages/flocks/doc/EXTRACAO.md) |

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
`.pubignore` excluindo os três. O `packages/flocks/doc/mcp/catalog.json`
**fica** — é o dado do MCP e parte da proposta do pacote. Fora do tarball,
higiene de repo: `jotape-design-tokens.md` sai (dump de tokens de uma marca
cliente, sem link e sem consumidor).

**Decidido em 2026-08-11**, o item que ficou em aberto aqui: o
[`COLOR_ACCESSIBILITY_REPORT.md`](packages/flocks/doc/COLOR_ACCESSIBILITY_REPORT.md)
reportava só as duas marcas cliente. Das duas saídas ("ou regenera com
`flocksBrand`, ou fica como prova de multi-marca"), **regenerou** — a
`flocksBrand` entrou na lista do gerador, na frente das outras duas, e o
relatório voltou com 117 verificações e 0 falhas. Perdeu a outra saída porque a
lista do gerador discordava da do gate bloqueante (`contrast_test.dart` cobra as
três marcas desde antes): um relatório que mostra menos marcas do que o gate
mente por omissão, e a marca ausente era justamente a do próprio pacote. A prova
de multi-marca não se perdeu — as duas marcas cliente continuam no relatório,
agora ao lado da terceira.

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

O dado está pronto: `packages/flocks/doc/mcp/catalog.json`, 131 componentes,
bilíngue na fonte. O que não existe é o servidor — e, antes dele, o contrato.

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
client-side — a um dashboard e um CRUD completos. A implementação mora **neste
repo**, no pacote `flocks_demo`, buildada e deployada pelo mesmo CI que serve o
site e o Widgetbook — o site, que é estático, não tinha app Flutter onde
hospedá-la. O que o pacote entrega:

- as duas telas compostas exclusivamente de componentes Flocks — leitura densa
  e escrita com formulário, as duas coisas que um design system precisa provar;
- `swatchFromSeed` de verdade, não uma aproximação — a paleta da demo é o
  mecanismo real do pacote;
- os três eixos globais alternáveis, claro e escuro derivados da mesma semente;
- **exportar o `AppBrandConfig`**: o visitante leva o código pronto. Isso exige
  um helper de serialização para snippet Dart que hoje não existe no pacote —
  a única feature nova de pacote prevista neste roadmap.

### Dívidas abertas da demo

Duas pendências moravam só no
[`TODO.md`](packages/flocks_demo/TODO.md) do pacote, sem aparecer em nenhum
documento de fase. Ficam registradas aqui, sem prazo atribuído:

- **A Roboto que o runtime do Flutter busca no Google.** Medido em
  `https://flocks.live/demo/` em 2026-08-11 (PR #20): a demo fazia **duas**
  requisições a `fonts.gstatic.com` por carga fria, nas duas telas. **Uma delas
  já não existe**; esta é a que sobra. A Roboto (63.464 B) sai porque o
  CanvasKit precisa de uma fonte de fallback registrada e nenhuma família do
  `FontManifest.json` da demo se chama `Roboto` — o download é **aguardado antes
  do primeiro frame**, não é lazy, e não é escolha da demo. Não é alcançável
  pelos gates: acontece no bootstrap JavaScript, fora de qualquer Dart nosso. O
  conserto exige vendorar as fontes de fallback e reproduzir uma estrutura de
  diretórios sem contrato documentado — e, apontando a base para nós, decidir o
  que fazer com a fila de Noto inteira, que é grande e escolhida em tempo de
  execução. O que o gate de rede prova segue valendo: nenhum byte do logo do
  visitante sai da aba dele.
  - **A segunda, a Noto Sans Symbols (69.116 B), foi consertada na raiz.** O
    gatilho era a pilha mono do `flocks`, com nenhuma família registrada no
    CanvasKit: cada acento do comentário em português do snippet virava
    codepoint sem cobertura e o engine baixava uma fonte de símbolos para
    desenhar "ã". Com a IBM Plex Mono empacotada em `assets/fonts/`, a família
    está registrada e a fila nunca abre. Medido local, nos dois builds servidos
    lado a lado, com `performance.getEntriesByType('resource')` e esperando o
    número de recursos estabilizar: `origin/main` 20 recursos e 2 de terceiro;
    com a mono, 21 recursos e 1 de terceiro. A contrapartida é honesta — a demo
    passa a baixar 275.796 B de mono **da própria origem**, cacheados por um ano
    como o resto. A medição de produção acima é anterior a isto e só se
    confirma em `flocks.live` no próximo deploy.
- **Analytics: nomeado, não implementado.** O projeto PostHog não existe e nada
  está no código. O `TODO.md` fixa os sete eventos e as propriedades de cada um
  antes da instrumentação, para que ela não invente vocabulário novo, e fixa
  junto a regra que entra com o primeiro evento: `demo logo uploaded` registra o
  fato e **nada mais** — nunca a imagem, os bytes, o nome do arquivo, o tamanho
  ou o tipo MIME. Ao implementar, o custo cai no `test/architecture_test.dart`
  da demo, que hoje exige ZERO requisições e passaria a ter de distinguir o
  destino de telemetria de todo o resto — que é exatamente onde a fronteira do
  logo se perderia se ninguém estivesse olhando.

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
de verdade. E cada adaptador é uma porta de descoberta no pub.dev. A restrição
de fila era não furar a prioridade de D e E, os motores de adoção — e valeu para
uma das duas: D e F entraram na main no mesmo 2026-08-10, a minutos uma da
outra, enquanto E segue aberta.

## Ordem e dependências

A ordem prevista aqui foi cumprida, e sobrou uma fase. O estado por fase está na
tabela do começo do documento; este bloco diz o que cada uma destravou:

```
A (publicar)        ✅ destravou C2, E e o consumo hosted
B (widgetbook)      ✅ no ar; foi paralela à A, como previsto
C1 (contrato MCP)   ✅ veio antes de C2, barato, e destravou integração
C2/C3 (MCP)         ✅ servidor publicado e distribuído; dependiam de A
D (demo)            ✅ no ar; o helper de export do AppBrandConfig entrou junto
F (icon providers)  ✅ implementados; paralela e barata, como previsto
E (guia)            ⬜ a única aberta. A dependência dela — a instalação real
                       que o guia instrui — existe desde 2026-08-10, então o
                       que falta é escrever, não esperar
```

## O que este roadmap não cobre

O site flocks.live em si, a identidade visual (logo, wordmark, ilustrações) e
qualquer decisão de negócio. O passo a passo operacional da publicação
continua no [`EXTRACAO.md`](packages/flocks/doc/EXTRACAO.md), que é atualizado
quando cada dívida for executada — este documento diz a ordem e o porquê.
