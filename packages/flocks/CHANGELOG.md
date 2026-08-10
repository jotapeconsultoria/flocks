# Changelog

Every relevant change to this package. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the numbering
follows [SemVer](https://semver.org/).

> **On the numbering.** Nothing below `[0.1.0]` was ever published. Those
> versions are *internal* migration milestones from the monorepo — they ran
> from `0.1.0` to `1.5.0` while the pubspec still said `1.0.0`, so they never
> agreed with it in the first place. The component catalog used to carry the
> same milestones in a `since:` field; it was dropped for that reason.
>
> The **public** line starts at `0.1.0`, on purpose. `1.0.0` on pub.dev is a
> promise about the future, and this package has not yet met an external
> consumer. In `0.x`, SemVer makes the minor the breaking slot, so `^0.1.0`
> pins adopters to `>=0.1.0 <0.2.0` and the churn cannot reach them by
> surprise. It graduates to `1.0.0` once the API holds still through a few
> outside adopters.

## [Unreleased]

A marca aprende a se escrever. É a única feature de pacote que o ROADMAP prevê,
e ela existe para a demo do site: sem isto o visitante vê a marca dele nos 131
componentes e vai embora; com isto ele leva o arquivo que reproduz o que viu.

E a demo já pagou o primeiro dividendo: montar duas telas inteiras sobre o eixo
de forma revelou que uma superfície grande em `circular` cortava o próprio
conteúdo — um defeito que nenhum use case isolado tinha exercitado.

### Added

- **`toDartSnippet` escreve uma `AppBrandConfig` como código Dart colável.** É
  uma extension, não um método: a classe documenta no próprio dartdoc o que ela
  deliberadamente não guarda, e gerar código não é responsabilidade de uma
  configuração. Também não é um `Codec` — o nome vem de `dart:convert` e promete
  um `decode` simétrico que não existe aqui, porque o decode desta serialização
  é o compilador Dart.

  A saída traz **só o que difere do padrão**: eixo em `standard` não aparece,
  papel de cor ausente também não. Cada swatch sai pela função que o reconstrói
  (`swatchFromSeed`, `neutralSwatchFromSeed`, `flippedSwatch`) sempre que a
  semente o reconstrói **de fato** — o gerador confere antes de escolher a forma
  curta, e um swatch escrito à mão, que não tem semente que o descreva, cai no
  literal de 11 stops. Serialização que não faz ida e volta é serialização
  errada, e a alternativa (assumir a semente) devolveria uma paleta diferente da
  que entrou.

  O gate mora em `test/architecture/brand_snippet_freshness_test.dart` e o
  artefato em `test/support/exported_brand_snippet.dart` — um `.dart` de
  verdade, e não um `.txt`, para que o `dart analyze` da raiz prove de graça
  aquilo que um teste de string não alcança: que o snippet **compila**.

- **`flippedSwatch` espelha um swatch**, que é como a rampa neutra escura de uma
  marca se obtém da clara. A função já existia, privada, dentro da `flocksBrand`;
  virou pública porque um snippet que a usasse sem poder nomeá-la teria de
  despejar os 11 stops justamente no papel onde a saída precisa continuar
  legível. `kSwatchStops` veio junto, pelo mesmo motivo de quem percorre um
  swatch: um `ColorSwatch` não expõe as próprias chaves.

### Fixed

- **Uma superfície grande em `circular` parou de cortar o próprio conteúdo.**
  `AppCard` e o cartão de conteúdo do `AppShell` resolviam a forma pela escada
  GERAL, em que `circular` significa "metade do lado menor". Num chip isso é a
  pílula que se espera; num cartão de gráfico de 400 px é uma elipse de 180 px de
  raio cujo canto passa por cima do header — o título "Recurring revenue"
  aparecia como "urring revenue". Os dois passaram a usar `contentSurfaceRadius`,
  uma escada nova que fica ENTRE `resolve` e `surfaceCornerRadius`: idêntica à
  geral em `reto`/`redondo`/`padrao` (um cartão pequeno não deve herdar o canto
  de um bottom sheet) e com teto em `circular`.

  O gate é `test/architecture/surface_clip_test.dart`, e ele é geométrico em vez
  de tipográfico: pinta a área de conteúdo e exige que os quatro cantos dela
  continuem pintados. Não depende de fonte, tema nem baseline — só do clip.

  Descoberto pela demo da Fase D, que é a primeira coisa a exercitar o eixo de
  forma inteiro com conteúdo real em cima.

## [0.1.1] - 2026-08-10

Três defeitos que só a análise do pub.dev revelou, no dia seguinte à
publicação. Nenhum deles se conserta na `0.1.0`: lá o tarball é imutável.

### Fixed

- **A licença volta a ser reconhecida.** O `LICENSE` trazia o MIT verbatim
  seguido de um bloco de notas sobre assets de terceiros, e o
  `license_detector` casa o arquivo INTEIRO contra o corpus SPDX — o texto
  apensado derrubava a confiança abaixo do limiar e o pub.dev reportava "No
  license was recognized", 0 de 10 pontos. O arquivo passa a ser exatamente o
  texto SPDX. As notas de terceiros continuam no README, e as obrigações
  legais sempre estiveram cumpridas pelos textos que viajam ao lado de cada
  asset (`OFL.txt`, `assets/icons/LICENSE`).
- **O pacote compila em WebAssembly.** `app_network_icon_provider.dart`
  escolhia o ramo do loader de ícones com `if (dart.library.html)`, e
  `dart:html` não existe no dart2wasm: todo build `--wasm` caía no ramo
  default e arrastava `dart:io` (via `flutter_cache_manager`) para um alvo que
  não o tem. A condição virou `if (dart.library.io)`, que é verdadeira na VM e
  falsa nos dois backends web. Não era só nota: um app em wasm quebrava.
- **Suporte de plataforma volta a 6 de 6.** Ver abaixo.

### Changed

- **A interceptação de ponteiro passou a morar no pacote**, em
  `src/foundation/pointer/`, e a dependência `pointer_interceptor` saiu. Ela
  era um plugin federado que endossa só `web` e `ios`, e o pana intersecta as
  plataformas de todo o fecho de dependências: aquela única linha rebaixava o
  `flocks` — e por herança o `flocks_phosphor` e o `flocks_material` — a
  "Supports 2 of 6 platforms (iOS, Web)" na página do pub.dev, num design
  system que roda em toda parte. Import condicional não resolveria: o pana lê
  o pubspec, não o grafo de imports.

  No web o comportamento é o mesmo, pelo mesmo mecanismo (um `<div>` vazio
  montado atrás do conteúdo, agora sobre `dart:js_interop` + `package:web`, e
  portanto wasm-compatível). **O que se perdeu foi a interceptação no iOS**:
  ela dependia de um `UIView` nativo, e código nativo é justamente o que um
  pacote Dart puro não pode carregar sem virar plugin — que é o problema que
  se estava resolvendo. Um app iOS que precise disso pode declarar
  `pointer_interceptor` por conta própria e embrulhar o `AppOverlayCard`.

  A API pública de `AppOverlayCard` não mudou: mesmos parâmetros, mesmo nome,
  mesmos pixels (os 4 goldens não se mexeram).

### Added

- **`example/`** — a tese do pacote numa tela só: uma semente de cor e os eixos
  globais alternáveis ao vivo, com o card e os botões restilizando juntos. O
  pacote não tinha exemplo, o que custava 10 pontos na análise do pub.dev
  (`0/10 Package has an example`) e, pior, obrigava quem chegava a montar o
  primeiro `runApp` por tentativa.

### Removed

- `lib/src/atoms/illustrations/app_illustration_{io,web}.dart` — código morto
  desde que os providers de ilustração foram para `foundation/illustrations/`:
  nada os importava e o barril não os exportava. O `_io` carregava o segundo
  `dart:io` do pacote.

## [0.1.0] - 2026-08-05

### Added

- `AppBrandTypography` — a brand now picks its display and body families. It
  closes the last white-label gap: color, radius, motion, style, glass and icon
  already belonged to the brand; typography was pinned in the package.
- `AppIconToken` — the contract of 55 icons the components use, and that every
  provider has to know how to serve. It is an `extension type` over `String`, so
  it is accepted anywhere a `String` already is.
- `AppIconProvider` as a theme axis, with two implementations:
  `AppAssetIconProvider` (the default, bundled SVGs, no network) and
  `AppNetworkIconProvider` (a CDN, with the base URL injected).
- `AppIllustrationToken`, `AppIllustrationProvider` and the
  `AppIllustrationTheme` axis — the last corner where the package took a
  third-party licensed asset. The bundled `empty` comes from
  [Open Peeps](https://www.openpeeps.com) under **CC0**, which (unlike
  unDraw/ManyPixels/Storyset) does not forbid redistributing it in a package.
- `AppThemeScope(iconProvider:, illustrationProvider:)` — the seam through which
  the APP picks the icon set. The brand cannot declare it: a large set lives in a
  sibling package, and the core does not depend on those.
- Sibling packages `flocks_phosphor` (1,512 icons × 6 weights, with
  `PhosphorWeight` as an axis) and `flocks_material` (the reference
  implementation, which proves the zero-Material thesis from outside).
- The `flocks` brand — the whole palette derived from a seed through
  `swatchFromSeed`, with Space Grotesk on display. It is the living proof of the
  white-label. (It used to be the only brand that worked with no network at all;
  since `cdnBaseUrl` left `AppBrandConfig`, every brand does.)
- `neutralSwatchFromSeed` — the neutral ramp needs a tone ladder of its own: the
  theme uses stop 300 as `surface` and 600 as `outline`, and on the chromatic
  ladder those two sit 30 tones apart (a ratio of 2.79, below the 3.0 floor).
  Without it, **every** seed-generated brand would fail the contrast gate, in the
  same place.
- `AppTextTheme.copyWith` and `AppBrandConfig.copyWith`, which did not exist.
- `LICENSE` (MIT), this `CHANGELOG` and a real `README`.
- `tool/golden_triage.py` — it builds contact sheets per family for reviewing
  golden failures.
- The catalog freshness gate (`test/architecture/catalog_freshness_test.dart`).
  `doc/mcp/catalog.json` drifted twice in three days because regenerating it was
  a manual step, and the site reads that file to publish the component count —
  each drift became a false number in the wild. The test runs in every PR's
  `flutter test` and also requires that the hand-written numbers in the README
  match the code.

### Changed

- **The catalog's prose is bilingual.** `summary`, `description`, `whenToUse`,
  `whenNotToUse`, `props[].description`, `examples[].title/description`, `do`,
  `dont` and `a11y` now carry `LocalizedText`/`LocalizedList` (`en` + `pt`), and
  `doc/mcp/catalog.json` emits `{"en": …, "pt": …}` for each of them. Both
  languages are required by the constructor, so no component can ship
  half-translated; `test/architecture/catalog_language_test.dart` also fails when
  an `en` field is left carrying Portuguese. **Breaking** for anyone reading
  `AppComponentMeta` or the JSON.
- **`states` and `variants` are a closed English vocabulary.** They name API
  surface (an enum's value, an interaction state), so they are not localized;
  they are checked against the allow-list in
  `test/architecture/catalog_vocabulary.dart`.
- **The `.doc.md` files and this README are in English.** The package is
  international from publication onward. The Portuguese lives on in the catalog's
  `pt` side, which is what the site publishes on its PT routes.
- **`Poppins-SemiBold` enters, and the `title*` styles now render at the weight
  they ask for.** They had declared `w600` all along and fell back to 500 because
  there was no 600 file on disk — the design system's "semibold" never existed.
  161 goldens rebaselined.
- **The whole type scale is Poppins.** The `display*` and `label*` styles were
  Neutrek. The `label*` ones move up to weight 500: Neutrek's regular read much
  heavier than Poppins', and keeping them at 400 erased the separation between
  label and body.
- **`AppIcons` stores slugs, not URLs.** Translating a name into an address is
  the brand's provider's job. The `jotape` and `zxtrack` brands point at the CDN;
  the package's default resolves from the bundled assets.
- **The illustration's default accent became neutral** (it was `secondary`). An
  illustration's fill is the AREA — skin, clothing, surface — not a detail:
  painting it with the brand color left the whole figure monochrome in that
  color. It changes how the illustrations look in all 4 apps.
- `AppIllustrations` stores slugs, not URLs, and `AppIllustration` lost its own
  loading — the provider is what loads.
- `AppIcon` became a `StatelessWidget`. The loading moved inside the provider,
  which also resolved a trap: the download was born in `initState`, where reading
  the theme is unsafe — and the provider comes from the theme.
- `swatchFromSeed` now generates 11 stops (50–950), like the hand-written brands.
- `AppBrand` builds the registry as `final`, not `const`, because the `flocks`
  brand derives its palette at runtime.
- **`AppAuthSplitLayout` takes `websiteUrl` as a parameter.** It used to read
  `AppBrand.current.websiteUrl` — the one place in `lib/src` that reached for the
  global brand singleton, for a string that already had sibling parameters
  (`brandTitle`, `brandSubtitle`, `logoUrl`) right next to it. A component that
  reads a static registry cannot be tested without it, cannot render two brands
  on one screen, and forces the package to have an opinion about where the data
  lives. `null` keeps the logo and drops only the link. **Breaking** only in the
  sense that the link now needs to be asked for.

### Removed

- **`AppBrandConfig` is theme configuration, and nothing else.** Gone:
  `appName`, `brandSubtitle`, `websiteUrl`, `cdnBaseUrl` (with its seven derived
  asset getters and `precacheUrls`), `videoBasePath`, `playStoreUrl` and
  `poweredByLabel`. What stays is `clientSlug`, the palette, the six theme axes
  and `typography`.

  None of the removed fields were read by `lib/src` — the package carried them
  only so the app could read them back. The cost was never their weight: the
  derived getters (`splashLogoUrl`, `otpLogoUrl`, `railExpandedUrl` and company)
  **asserted an app architecture** — that there is a splash screen, an OTP flow,
  a profile page, a nav rail, an auth background, and a Play Store listing. A
  design system that asserts that has an opinion about someone else's product,
  which is the same coupling this package refuses when it declines to reuse
  `Card` and `Scaffold`.

  `clientSlug` stayed: with the asset path gone it is pure identity — the
  registry key, and the label that names the goldens and scopes the contrast
  reports. **Breaking** for anyone constructing an `AppBrandConfig`; the fix is
  to delete the arguments and keep that identity wherever your app already keeps
  its own.


- **The Neutrek font.** It is licensed "Personal Use Only"; in an MIT repository,
  using it would amount to redistribution. It was what blocked publishing the
  package.

### Fixed

- The OFL fonts were being redistributed **without the license text**, which the
  SIL Open Font License requires. There is now an `OFL.txt` beside each family.
- `AppIcons.mail`, `.plus` and `.refresh` were cited in dartdoc but did not
  exist. They exist now, as part of the contract.

### Security

- The package's default path no longer depends on a private CDN or on a licensed
  icon set (Streamline Ultimate). The default is offline and MIT.
- **A brand can no longer point anywhere.** `cdnBaseUrl` was first made optional,
  so that an adopter with nowhere to host was not pushed into copying
  `flocksBrand`'s value — which pointed at the site's own CDN, putting our infra
  and our logo inside their product. Removing the field settles it by absence:
  there is no URL to copy and no network for the package to reach.

## [1.0.0]

The first consolidated version of the design system inside the monorepo: tokens,
theme, per-brand white-label, the global axes (`AppStyle`, `AppRadiusMode`,
glass, motion, transparency) and 131 components across atoms/molecules/organisms,
each with a `.doc.md`, a preview, a Widgetbook case and a test.
