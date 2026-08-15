# Extração para repositório público — o que foi decidido, e por quê

Este documento era uma lista de decisões adiadas. Elas foram tomadas e
executadas em **2026-08-05**: o pacote saiu de `tracked-app/packages/flocks`, no
monorepo da Tracked, para o repositório próprio
[`jotapeconsultoria/flocks`](https://github.com/jotapeconsultoria/flocks), junto
com `flocks_phosphor` e `flocks_material`.

Faltava um passo, e ele aconteceu em **2026-08-10**: os três estão publicados no
pub.dev, na `0.1.0`, sob o publisher verificado `jotapeconsultoria.com.br` — e o
`flocks_mcp`, que nasceu neste repo, no mesmo dia. Era irreversível — lá só
existe `retract`, não delete — e por isso foi passo separado, depois que o repo
novo estabilizou.

## O estado de hoje

| | |
|---|---|
| Repositório | Próprio, público; sete pacotes em `packages/`: os três da extração, o `flocks_mcp`, os dois providers de ícone da Fase F e a demo da Fase D |
| Resolução | Pub workspace, com o `pubspec.yaml` da raiz |
| Versão | `0.1.2` nos quatro que estrearam em 2026-08-10, em lockstep; `flocks_cupertino` e `flocks_lucide` em `0.1.0`, que é a versão com que estrearam em 2026-08-12 |
| `publish_to` | Fora dos seis publicáveis; `none` só na raiz (workspace) e no `flocks_demo` (permanente — é vitrine). Saiu dos dois providers em 2026-08-11, um dia antes de eles publicarem, e não no commit do publish |
| Publicação | pub.dev, tag `v0.1.2`; os seis sob o publisher verificado `jotapeconsultoria.com.br`, e os seis em 160/160 na pana. A linha pública abriu na `0.1.0` de 2026-08-10, ganhou a `0.1.1` no fim do mesmo dia com o que a pana cobrou, e a `0.1.2` em 2026-08-12 |
| Consumo pelo monorepo | Hospedado, `^0.1.0` — a dependência `git:` e o override saíram em 2026-08-10 |
| Licença | MIT em cada pacote, e na raiz |
| CI | `.github/workflows/ci.yml`: gates (Linux), goldens (macOS pinado) e os deploys de site, Widgetbook e demo |

## As decisões

### 1. Um repositório para os três pacotes

O contrato (`AppIconProvider`) mora no core e os adaptadores versionam em
lockstep. O argumento decisivo foi o **teste de contrato cruzado** — "todo
`AppIconToken` tem mapeamento em todo adaptador" — que só roda em cada PR se
estiverem no mesmo repo; separados, dependeria de publicar primeiro.

Publicar é independente da topologia: cada pacote publica sozinho, com
`repository:` apontando para o seu subdiretório.

### 2. Sem histórico

`git subtree split` carregaria os commits do monorepo, auditados e limpos. O que
decidiu foi simplicidade — o histórico não valia a complexidade. O custo
aceito: um repo com um commit inicial lê como "despejado aqui", e quem avalia
design system olha profundidade de histórico. O `CHANGELOG.md` cobre parte
disso, e commits novos acumulam.

### 3. `resolution: workspace` **fica** — e a razão anterior estava errada

Este documento e o `install_docs_test.dart` afirmavam que a linha teria de sair
para publicar, porque "um checkout avulso vindo do pub.dev não resolve com ela".
Medido em 2026-08-05, o que o `pub` faz de fato:

| Cenário | Resultado |
|---|---|
| `dart pub publish --dry-run` com a linha | **passa**, sem aviso sobre ela |
| Consumidor depende do pacote (`path:` ou hospedado) | **resolve** — o campo é *ignorado* em dependência |
| `pub get` **dentro** do pacote, sem workspace acima | **falha** |
| Membro de `workspace:` **sem** a linha | **falha** |

Ou seja: ela só atrapalha `pub get` rodado dentro do pacote quando não há raiz
de workspace acima — e aqui há. É justamente ela que faz os adaptadores
resolverem `flocks` no membro local, e não na versão publicada, enquanto se
trabalha neles. Tirá-la quebra o `pub get` da raiz; publicar não depende dela
em nada.

Consequência: o quarto caso do `install_docs_test.dart`, que exigia
`resolution: workspace` e `publish_to: none` andando juntos, **foi apagado**. A
premissa só valia enquanto o pacote morava no workspace de outro projeto, e ele
reprovaria o estado intermediário — extraído, não publicado, consumido por
`git:` — que foi exatamente o plano entre 05/08 e 10/08. Os outros três casos continuam de pé e
guardam o risco real: README e pubspec não podem se contradizer sobre como
instalar.

### 4. Versão `0.1.0`, não `1.0.0`

`1.0.0` no pub.dev é promessa sobre o **futuro**, não atestado sobre o passado. O
pacote tem 131 componentes testados e documentados — e nunca encarou um
consumidor externo, levou um `refactor(flocks)!` no dia da extração e roda a ~65
commits por quinzena. Em `0.x` o SemVer trata o *minor* como slot de quebra,
então `^0.1.0` resolve para `>=0.1.0 <0.2.0` e todo adotante já sai pinado
contra o churn.

`0.x → 1.0.0` é formatura que se anuncia. `1.0.0 → 2.0.0 → 3.0.0` num trimestre
é instabilidade, e não se retrata.

Os `since: 'flocks@x.y.z'` que o catálogo carregava eram marcos **internos** de
migração, anteriores a qualquer publicação. A régua deles ia de `0.1.0` a
`1.5.0` enquanto o pubspec dizia `1.0.0` — já não concordavam antes da
extração. O campo saiu (ver a dívida abaixo).

### 5. Transição por dependência `git:` — encerrada em 2026-08-10

Enquanto durou, os 5 consumidores do monorepo (`tracked_shared_pkg` e os 4 apps)
apontaram para o repo novo por `git:`. Hoje resolvem `^0.1.0` do pub.dev, e o
`dependency_overrides` da raiz de lá foi apagado — publicar era, por definição,
apagar o override.

Isto substituiu o plano anterior de `pubspec_overrides.yaml` apontando para um
checkout local, que exigiria de cada máquina e de cada runner de CI ter o repo
clonado ao lado, no caminho certo. A dependência `git:` não exigia nada disso.

**A fricção era o que dava prazo à publicação:** `git:` fixa um commit no
`pubspec.lock`, então atualizar o Flocks passava a exigir bump de ref no
monorepo. Tolerável como transição, ruim como permanente — e foi por isso que a
transição teve prazo.

## CI

Dois jobs, em `.github/workflows/ci.yml`:

- **`checks`** (ubuntu): `dart format --set-exit-if-changed`, `dart analyze`,
  `flutter test --exclude-tags golden`, `dart run tool/validate_components.dart`,
  e os testes dos dois adaptadores;
- **`goldens`** (macOS, **pinado**): `flutter test --tags golden`, com upload de
  `test/**/failures/**` — sem o artefato, golden vermelho na CI é
  indiagnosticável.

O pin do runner é `macos-26`/arm64, que é onde as 302 baselines são geradas. No
monorepo ele esteve em `macos-15` e o job nunca passou verde, com a causa
invisível: 302 imagens vermelhas sem nada dizendo "a imagem não é a mesma". Um
passo antes de tudo confere `sw_vers`/`uname -m` e falha com a causa escrita.

Ao subir o pin no futuro, regere as baselines na imagem nova
(`flutter test --tags golden --update-goldens`) **no mesmo commit**.

### Analyzer

O flocks está fora do `tool/analyzer_gate.py` do monorepo de propósito — usa
`dart analyze` cru, sem baseline, porque nasce limpo. Fora do monorepo isso
continua valendo; se um dia deixar de nascer limpo, não há baseline segurando.

## Ilustrações e licenças de asset

A `empty` — a única `AppIllustration` que o `lib/src` usa em runtime — vem
embutida, do [Open Peeps](https://www.openpeeps.com) sob **CC0 1.0 Universal**.
As outras seguem no CDN, apontadas pelos apps: uso interno, não redistribuição.

**A armadilha, registrada para não se repetir:** unDraw, ManyPixels e Storyset
parecem a escolha óbvia e proíbem, com a mesma frase, *"distribute the assets in
packs or otherwise"* — que é exatamente embutir num pacote. Sobram CC0 e CC BY.
Antes de trazer qualquer ilustração nova, leia a licença na fonte: foi assim que
Neutrek e Streamline entraram. Pelo mesmo motivo a Neutrek saiu: "Personal Use
Only" tornava o pacote impublicável.

## Dívida conhecida

- ✅ **`docs/` virou `doc/`** — resolvido em 2026-08-05. Era o último aviso do
  `pub publish --dry-run`: a convenção de layout do pub é singular, e nomes
  plurais não são reconhecidos por ele nem pelas ferramentas. Os três arquivos
  foram mesclados no `doc/` que já existia.

  **O que quase escapou:** `test/src/theme/contrast_report_test.dart` não só
  *cita* o caminho — ele **escreve** o `COLOR_ACCESSIBILITY_REPORT.md` e faz
  `Directory('docs').createSync()`. Sem trocar essa linha, o `docs/`
  reapareceria sozinho no `flutter test` seguinte, e o aviso do pub junto.
  Numa renomeação de diretório, procure o gravador, não só os leitores.
- ✅ **As referências a `docs/FLOCKS_MIGRATION_PLAN.md` saíram da prosa** —
  resolvido em 2026-08-05. Eram 12 (não ~10): 7 doc comments `///`, 3
  comentários de código e 2 em markdown. O arquivo **nunca veio para o pacote**
  — mora em `tracked-app/docs/` no monorepo de origem, e é documento interno de
  migração. Das duas saídas ("ou o documento vem, ou o caminho sai da prosa"),
  saiu o caminho, porque as regras que ele definia hoje são **executáveis**:
  vivem em `tool/component_conformance.dart` e nas suítes de
  `test/architecture/`. Cada referência passou a apontar para o que existe no
  repo, ou virou a regra dita inline.

  **O que a reescrita revelou:** a numeração das regras nunca dependeu do
  documento. `conformanceErrors()` já cita "Regra 6", "Regra 8", "Regra 9" e
  "Regra 10" nominalmente nas próprias mensagens de erro — então os dartdocs
  que citavam uma regra numerada só precisaram trocar o destino do "ver". Quem
  apontava para o plano genérico (`flocks.dart`, `organisms.dart`) é que teve
  de virar frase. Prioridade foram os `///`: são a cara do pacote no pub.dev.
- ✅ **O `since:` saiu do catálogo** — resolvido em 2026-08-05. Referenciava
  marcos internos que não correspondiam a release nenhuma (ver §4). Das duas
  saídas ("ou viram a versão publicada, ou saem"), saíram: os 131 componentes
  nascem juntos na `0.1.0`, então o campo carregaria valor idêntico em 131 de
  131 entradas — zero informação —, e `flocks@0.1.0` já era marco *interno* de
  2 componentes, de modo que depois de publicar a `0.1.0` real o mesmo valor
  significaria duas coisas. O campo volta com significado quando o primeiro
  componente pós-`0.1.0` nascer.

  **O que a remoção ensinou sobre a superfície:** não eram só os `*.meta.dart`.
  O `tool/serialize_meta.dart` não precisou de uma linha — ele delega tudo ao
  `toJson()` do meta —, mas o campo também vivia no fixture de
  `test/src/meta/app_component_meta_test.dart` e em
  `tool/flocks_component.schema.json`, um schema que nenhum código lê e que por
  isso envelheceria em silêncio.

## O que o pub.dev cobrou no dia seguinte

A publicação não termina no `dart pub publish`: a análise da pana volta cerca de
uma hora depois, e ela mede coisas que nenhum gate deste repositório media. O
`flocks_phosphor` voltou com **140/160**, e as três causas eram do core.

| Cobrança | Causa | O que passou a valer |
| --- | --- | --- |
| `0/10` "No license was recognized" | O `LICENSE` trazia o MIT verbatim **seguido** de um bloco `---` de notas sobre assets de terceiros. O `license_detector` casa o arquivo INTEIRO contra o corpus SPDX: qualquer texto apensado derruba a confiança abaixo do limiar | Os cinco `LICENSE` do repo voltaram a ser exatamente o texto SPDX. As notas vivem no README — e as obrigações legais sempre estiveram cumpridas pelos textos que viajam ao lado do asset (`OFL.txt`, `assets/icons/LICENSE`) |
| `10/20` "Supports 2 of 6 platforms" | `pointer_interceptor`, plugin federado que endossa só `web` e `ios`. A pana **intersecta** as plataformas de todo o fecho de dependências, então uma aresta rebaixava o core e os dois adaptadores | A interceptação virou ~20 linhas em `src/foundation/pointer/`, sobre `dart:js_interop` + `package:web`, e a dependência saiu. Web idêntico; **iOS perdido**, porque lá ela exigia `UIView` nativo — isto é, um plugin, que é o problema que se estava resolvendo |
| "Not compatible with runtime wasm" | `if (dart.library.html)` no import condicional do loader de ícones. `dart:html` **não existe** no dart2wasm, então todo build `--wasm` caía no ramo default e arrastava `dart:io` | A condição virou `if (dart.library.io)`. Não era só nota: um app em wasm quebrava |

Três lições que valem mais que a nota:

- **Import condicional não esconde dependência.** A tentação era manter o
  `pointer_interceptor` atrás de um `if`. Não funciona: a pana lê o
  `pubspec.yaml`, não o grafo de imports. Só sair do pubspec conta.
- **`dart.library.html` é um predicado morto.** Ele e `dart.library.js_interop`
  são ambos verdadeiros no dart2js, o que faz o erro passar despercebido; só o
  segundo vale também no dart2wasm. Virou gate em `architecture_test.dart`,
  porque nenhum teste deste repositório roda num browser e a regressão seria
  invisível.
- **A ordem de publicação é carga estrutural.** A pana resolve as dependências
  do pub.dev, não do workspace: rodada localmente, a do `flocks_phosphor` 0.1.1
  ainda mediu contra o `flocks` **0.1.0** publicado e repetiu os dois defeitos
  herdados. Os adaptadores só medem certo depois que o core está no ar — o que
  a ordem `flocks` → adaptadores já garantia por outro motivo.

A mesma análise expôs uma quarta coisa, anterior às três e de outra natureza: o
`flocks` e o `flocks_material` não tinham `example/`, e isso são 10 pontos cada
(`0/10 Package has an example`). Não era defeito, era ausência — mas com a
versão sendo imutável, adiar significaria publicar duas vezes. Os dois exemplos
entraram junto, como membros do workspace, pelo mesmo motivo que o do
`flocks_phosphor` é membro: precisam compilar contra este checkout.

Com eles, a medição local do `flocks` fecha em **150/150** (`--no-dartdoc`), ou
seja 160/160 na escala do pub.dev.

## O passo que faltava — e o corte de 2026-08-12

✅ **Publicado** — resolvido em 2026-08-10, na ordem que estava planejada:

1. `[Unreleased]` virou `[0.1.0] - 2026-08-05` no `CHANGELOG.md`;
2. `publish_to: none` saiu dos três pubspecs junto com o aviso de "not yet
   published" do README, no mesmo commit — que é o que o `install_docs_test.dart`
   cobra;
3. `dart pub publish` em cada pacote, o `flocks` primeiro (os adaptadores
   dependem dele por versão). Os três foram para o publisher verificado
   `jotapeconsultoria.com.br` no primeiro publish, de modo que nunca existiu
   versão sob uploader pessoal. O corte é a tag `v0.1.0`;
4. ✅ os consumidores do monorepo migraram de `git:` para dependência hospedada,
   e o `dependency_overrides` da raiz de lá foi apagado — publicar era, por
   definição, apagar o override. Aconteceu no repositório da Tracked, não neste.

**O que quase escapou:** o passo 1 fala do `CHANGELOG.md` no singular porque foi
escrito quando só o core tinha um. `flocks_phosphor` e `flocks_material` ganharam
os seus na higiene pré-publicação, e ganharam abrindo em `## [Unreleased]` — o
mesmo padrão do core. Publicar sem cortá-los teria posto "Unreleased" como
primeira seção da página dos dois adaptadores no pub.dev, num lançamento cuja
versão é justamente `0.1.0`. Quando um plano cita um arquivo no singular,
confira se ele ainda é único na hora de executar.

**A superfície era maior que os READMEs:** o aviso de "não publicado" também
estava em `site/index.html` e `site/pt/index.html`, que nasceram depois deste
plano. O `install_docs_test.dart` fiscaliza o README e o pubspec por XOR, então
ele teria passado verde com o site mentindo. Teste não cobre superfície que não
existia quando o teste foi escrito.

**Nota sobre o `flocks_mcp`:** ele ficou de fora deste corte de propósito e
publicou depois, quando a 0.1.0 do core já tinha estabilizado o schema do
catálogo que ele embarca. E o pub.dev não é o único canal dele: o `.mcpb`
anexado ao GitHub Release é a outra via, armada pela tag — outro canal, outra
decisão, registrada fora deste documento.

**A `0.1.2` saiu em 2026-08-12**, e com ela o repositório deixou de ter pacote
publicável inédito: `flocks`, `flocks_phosphor`, `flocks_material` e
`flocks_mcp` subiram para a `0.1.2`, e `flocks_cupertino` e `flocks_lucide`
estrearam na `0.1.0`, os seis sob o mesmo publisher verificado e os seis
medindo **160/160** na pana. O corte é a tag `v0.1.2`.

**A ordem se manteve, e agora tem carimbo:** os horários de publicação que a
API do pub.dev devolve põem o `flocks` às 20:22Z e os cinco outros entre 20:27Z
e 20:28Z. É a mesma carga estrutural da lição acima — a pana dos adaptadores
resolve o `flocks` do pub.dev, não o do workspace, então o core tem de estar no
ar antes.

**O que o plural cobrou:** o passo 2 desta seção fala de "três pubspecs" porque
foi escrito para um corte de três pacotes. O de 2026-08-12 foram seis, em duas
linhas de versão ao mesmo tempo — quatro subindo um patch e dois nascendo. O
`publish_to: none` dos dois novos não saiu no commit do corte: saiu em
2026-08-11, no dia anterior, junto com o aviso de "não publicado" do README de
cada um — o par que o `install_docs_test.dart` **de cada provider** cobra por
XOR, e não o do core, que não conhece os dois. A regra da nota acima vale um
degrau acima do arquivo: quando um plano cita um número de pacotes, confira
quantos são na hora de executar.
