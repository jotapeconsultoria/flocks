# Extração para repositório público — o que foi decidido, e por quê

Este documento era uma lista de decisões adiadas. Elas foram tomadas e
executadas em **2026-08-05**: o pacote saiu de `tracked-app/packages/flocks`, no
monorepo da Tracked, para o repositório próprio
[`jotapeconsultoria/flocks`](https://github.com/jotapeconsultoria/flocks), junto
com `flocks_phosphor` e `flocks_material`.

Falta um passo: **publicar no pub.dev**. Ele é irreversível — lá só existe
`retract`, não delete — e por isso é passo separado, depois que o repo novo
estabilizar.

## O estado de hoje

| | |
|---|---|
| Repositório | Próprio, público, os três pacotes em `packages/` |
| Resolução | Pub workspace, com o `pubspec.yaml` da raiz |
| Versão | `0.1.0`, os três em lockstep |
| `publish_to` | `none` — ainda não publicado |
| Consumo pelo monorepo | Dependência `git:`, fixada por commit no `pubspec.lock` |
| Licença | MIT em cada pacote, e na raiz |
| CI | `.github/workflows/ci.yml`, dois jobs (Linux e macOS) |

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
resolverem `flocks` no membro local enquanto o pacote não está no pub.dev.
Tirá-la quebra o `pub get` da raiz; publicar não depende dela em nada.

Consequência: o quarto caso do `install_docs_test.dart`, que exigia
`resolution: workspace` e `publish_to: none` andando juntos, **foi apagado**. A
premissa só valia enquanto o pacote morava no workspace de outro projeto, e ele
reprovaria o estado intermediário — extraído, não publicado, consumido por
`git:` — que é exatamente o plano. Os outros três casos continuam de pé e
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

Os `since: 'flocks@x.y.z'` do catálogo são marcos **internos** de migração,
anteriores a qualquer publicação. A régua deles vai de `0.1.0` a `1.5.0`
enquanto o pubspec dizia `1.0.0` — já não concordavam antes da extração.

### 5. Transição por dependência `git:`

Os 5 consumidores do monorepo (`tracked_shared_pkg` e os 4 apps) apontam para o
repo novo por `git:` até a publicação.

Isto substitui o plano anterior de `pubspec_overrides.yaml` apontando para um
checkout local, que exigiria de cada máquina e de cada runner de CI ter o repo
clonado ao lado, no caminho certo. A dependência `git:` não exige nada disso.

**Fricção conhecida, e é o que dá prazo à publicação:** `git:` fixa um commit no
`pubspec.lock`, então atualizar o Flocks passa a exigir bump de ref no monorepo.
Tolerável como transição, ruim como permanente.

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

- **`docs/` deveria ser `doc/`.** O `pub publish --dry-run` avisa: a convenção
  de layout é singular, e nomes plurais não são reconhecidos pelo pub e pelas
  ferramentas. O pacote tem os dois diretórios hoje. Consertar é mesclar
  `docs/*` em `doc/` e atualizar ~15 referências em dartdoc. Não bloqueia nada
  antes de publicar.
- **Os `since:` do catálogo** referenciam marcos internos que não correspondem a
  release nenhuma (ver §4). Ou viram a versão publicada em que o componente
  apareceu, ou saem.

## O passo que falta

Publicar. Na ordem:

1. cortar `[Unreleased]` do `CHANGELOG.md` numa seção `[0.1.0]`;
2. tirar `publish_to: none` dos três pubspecs e o aviso de "not yet published"
   do README — no mesmo commit, que é o que o `install_docs_test.dart` cobra;
3. `dart pub publish` em cada pacote, o `flocks` primeiro (os adaptadores
   dependem dele por versão);
4. migrar os 5 consumidores do monorepo de `git:` para dependência hospedada.
