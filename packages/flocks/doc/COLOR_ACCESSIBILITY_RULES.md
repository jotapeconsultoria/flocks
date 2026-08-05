# Flocks — Regras de Cor & Contraste (Acessibilidade)

Regras de cor para os temas **claro** e **escuro** do Flocks, ancoradas em WCAG 2
e nas boas práticas perceptuais de dark mode. São **verificadas automaticamente**
por marca × brilho — ver [contrato](#o-contrato-de-contraste) e
[testes](#como-validamos). O estado atual das duas marcas está em
[`COLOR_ACCESSIBILITY_REPORT.md`](COLOR_ACCESSIBILITY_REPORT.md).

> **Nível:** WCAG **AA** é piso **obrigatório** (bloqueante). WCAG **AAA** é meta
> **aspiracional** (medida, não bloqueante).

---

## 1. Duas métricas, complementares

Toda regra usa **as duas** medidas (helpers em `lib/src/tokens/contrast.dart`):

| Métrica | O que é | Quando manda |
|---|---|---|
| **Razão WCAG 2** — `contrastRatio(fg, bg)` (1–21) | Piso legal/normativo. `(L↑+0.05)/(L↓+0.05)` sobre a luminância relativa (`Color.computeLuminance`). | Sempre — é o gate AA. |
| **ΔT de tom HCT** — `toneDelta(a, b)` (0–100) | Diferença de **tom** HCT (T = L\* de CIELAB, perceptualmente uniforme). | Guia perceptual amigável ao designer; **decisivo no escuro** (ver §4). |

**A "regra 40/50" do Material 3** liga as duas: **ΔT ≥ 40 ⇒ razão ≥ 3.0**;
**ΔT ≥ 50 ⇒ razão ≥ 4.5**. Ou seja, dá pra raciocinar em "passos de tom" em vez
de razões.

## 2. Alvos WCAG (primeiro plano vs fundo)

| Papel | AA (obrigatório) | AAA (aspiracional) | ΔT alvo |
|---|:--:|:--:|:--:|
| Texto normal (< 18pt / < 14pt bold) | **4.5:1** | 7:1 | ≥ 50 |
| Texto grande (≥ 18pt / ≥ 14pt bold) | **3:1** | 4.5:1 | ≥ 40 |
| Componentes de UI, ícones, **bordas**, anel de **foco**, gráficos | **3:1** | 3:1 | ≥ 40 |
| Conteúdo desabilitado | *isento* (WCAG) | — | — |

Constantes: `kAaNormal=4.5`, `kAaLarge=3.0`, `kUi=3.0`, `kAaaNormal=7.0`,
`kAaaLarge=4.5`, `kToneDeltaText=50`, `kToneDeltaLargeUi=40`.

## 3. Pares cor↔on-color

Preenchimentos de marca/semântica (`primary`, `danger`, …) sempre andam com seu
`on*` (o conteúdo por cima). Como os componentes consomem `theme.colorTheme.X`
**como `Color`** (o valor base do swatch — ex.: `fillColor =
theme.colorTheme.primary` em `app_checkbox.dart`), o par testado é
**`onX(base)` vs `X(base)`**, alvo de texto (4.5 / ΔT 50).

> ✅ **Corrigido:** antes ambas as rampas de on-color tinham valor base branco, e
> `onX` resolvia para branco mesmo quando o legível era preto (`onWarning`/
> `onSuccess`/`onInfo`/`onSecondary`/`onDanger` falhavam AA). Agora
> `AppBrandConfig._on` usa `_bestOnColor(base)`: escolhe **preto ou branco** —
> as rampas `AppColors.onColorLight` (base branca) / `onColorDark` (base preta) —
> pelo que **satisfaz razão AA *e* ΔT de tom**; empate/impasse cai no de maior
> razão (como `onColorFor`). É mais estrito que `onColorFor` porque uma cor de tom
> médio pode ter razão maior no preto mas só o branco atingir o ΔT (e vice-versa).

## 4. Tema escuro: **dobre a separação**

No escuro a luz é "absorvida" pela tela e **o WCAG 2 superestima o contraste
quando as duas cores são escuras** — uma separação que basta no claro fica
imperceptível no escuro (e ainda piora *halation* em quem tem astigmatismo).
Regra prática:

> **Separação de hierarquia/elevação sutil precisa de ~2× o ΔT no escuro.**
> `kMinSeparationLight = 12` (claro) → `kMinSeparationDark = 24` (escuro).

É a intuição de "se no claro 100 de diferença de shade basta, no escuro precisa de
~200", expressa em tom perceptual (não em número de shade).

**Outras regras do escuro:**
- **Sem preto puro.** A superfície base deve ter tom HCT em
  **`[kDarkSurfaceToneMin=6, kDarkSurfaceToneMax=16]`** (~`#0F1419`–`#1E1E1E`).
  Preto puro impede elevação-por-clareamento e agrava halation.
- **Elevação = clarear, não sombra.** Cada nível de container sobe o tom
  (respeitando o ΔT ≥ 24 entre níveis adjacentes).
- **Acentos dessaturados.** Cores muito saturadas "vibram" sobre fundo escuro;
  prefira um stop mais claro e menos croma para acento como primeiro plano.

## 5. Acento como primeiro plano na superfície

- **Preenchimento:** use o par `X` + `onX` (§3).
- **Acento como texto/ícone sobre a `surface`:** escolha um stop com contraste
  suficiente — no **claro**, um stop **escuro** (≈ `s700`+); no **escuro**, um
  stop **claro** (≈ `s300`–`s400`). Nunca use `X.s500`/base como texto direto na
  superfície sem checar a razão.
- **Anel de foco:** use o token resolvido `colorTheme.focusRing` (não `primary`
  direto). Ele já resolve por brilho — `primary.s700` no claro, stop claro
  (`primary.s400`) no escuro — garantindo 3:1 sobre a `surface` nos dois temas.
- **Borda/contorno:** use o token resolvido `colorTheme.outline` (não
  `neutralPrimary.s500` direto). Resolve por brilho — `neutral.s500` no escuro,
  `neutral.s600` no claro (mais escuro, pois a superfície clara é um **cinza
  elevado**, não branco puro) — garantindo 3:1 / ΔT ≥ 40 vs `surface`.
- **Elevação/container:** use `colorTheme.surfaceContainer` (card/sheet/popover).
  No **escuro**, `surface` é o tom mais escuro e o container **clareia**
  (`elevatedSurface`, ΔT ≥ 24). No **claro**, invertemos a convenção: a `surface`
  é um **cinza elevado** e o container é o `neutral.s50` **branco** (página cinza +
  cards brancos), com ΔT ≥ 12. `neutralPrimary.s100` é fill sutil/desabilitado,
  **não** elevação. Consequência: tokens de tom médio (borda, data-viz, foco) são
  resolvidos/calibrados contra o cinza da superfície clara, não contra branco.

---

## O contrato de contraste

Fonte única da verdade em `lib/src/theme/contrast_contract.dart`: os **pares**
(`flocksContrastContract`) + as **regras estruturais** single-color
(`flocksStructuralContract`). Cada entrada é resolvida de um `AppColorTheme`, com
alvos por `ContrastTier` (pares) ou uma checagem própria (estruturais):

| Regra (`id`) | Tier | Alvo |
|---|---|---|
| `onSurface/surface` | text | 4.5 / ΔT 50 |
| `onPrimary/primary`, `onSecondary/secondary`, `onTertiary/tertiary` | onColor | 4.5 / ΔT 50 |
| `onDanger/danger`, `onInfo/info`, `onSuccess/success`, `onWarning/warning` | onColor | 4.5 / ΔT 50 |
| `onNeutralBlack/neutralBlack`, `onNeutralWhite/neutralWhite` | onColor | 4.5 / ΔT 50 |
| `border(outline)/surface` | uiComponent | 3.0 / ΔT 40 |
| `focusRing/surface` | uiComponent | 3.0 / ΔT 40 |
| `chartGood/surface`, `chartNeutral/surface`, `chartBad/surface` | uiComponent | 3.0 / ΔT 40 |
| `scoreLow/surface`, `scoreMid/surface`, `scoreHigh/surface` | uiComponent | 3.0 / ΔT 40 |
| `surfaceContainer/surface` | separation | ΔT ≥ 12 (claro) / 24 (escuro) |
| `surface fora do preto puro` (só escuro, estrutural) | darkSurface | T ∈ [6, 16] |

## 6. Data-viz: séries categóricas (isenção)

As cores **semânticas** de data-viz (`chartGood/Neutral/Bad`, `scoreLow/Mid/High`)
carregam significado (bom/ruim, alto/baixo) e são gated a 3:1 vs `surface` (tabela
acima). Já a paleta **categórica** (`chartCategorical`, 8 cores cíclicas de séries)
é **decorativa**: as séries são distinguidas por **legenda/posição/rótulo**, não
por contraste com o fundo — então está **isenta** da regra vs `surface` (como
permite a WCAG para objetos gráficos não-essenciais). Refinamento futuro possível:
uma checagem de **distinção mútua** (ΔT par-a-par entre categóricas).

## 7. Estados desabilitados e contraste **por estado**

O contrato acima valida **tokens do tema** — um nível acima do componente. Mas um
componente pode combinar tokens de um jeito ilegível num estado específico (ex.: o
radio desabilitado no dark: anel `primary@50%` sobre superfície escura ≈ 1.1:1,
some). Isso **não** era pego por nenhum teste (golden é snapshot visual, não
asserção de contraste).

**Regra — todo átomo interativo (radio/checkbox/switch) valida contraste por
estado** (`componente × on/off × habilitado/desabilitado × marca × brilho`), via
resolvers puros (`appRadioStateColors`, `appCheckboxStateColors`,
`appSwitchStateColors`) que devolvem `(indicator, container, border)`:

1. **Habilitado visível** — o elemento mais saliente vs `surface` ≥ `kUi` (3:1).
2. **Desabilitado perceptível** — ≥ `kDisabledMinRatio` (`1.5`). A WCAG **isenta**
   controles inativos do contraste mínimo, mas isenção ≠ some: o Flocks exige um
   **piso de perceptibilidade** para o disabled não desaparecer.
3. **Desabilitado distinto** — o estado desabilitado difere do habilitado por
   ΔT ≥ `kDisabledDistinctionTone` (`10`) em algum elemento — **dá pra perceber
   que está desabilitado**.
4. **Marca legível no fill** — quando há uma marca (check/ponto/thumb) sobre um
   fill, ela contrasta ≥ `kUi` (3:1) com o **próprio fill** (não só com a
   `surface`). Evita o check sumir dentro do preenchimento apagado.

**Disabled por TOM, não por opacidade.** `Color.disabled()` (50% de opacidade) é
idioma de tema **claro**; no dark, reduzir opacidade aproxima do fundo escuro e
**some**. Os átomos usam `colorTheme.disabledColor(content)` (`mutedForDisabled`)
para **fill/borda**: desloca o **tom** para `tomDaSurface ± kDisabledProminenceTone`
(`22`), dessatura (`kDisabledChromaRetention` `0.4`) e **preserva a matiz**. Já a
**marca** (check/ponto/thumb) usa `disabledIndicatorOn(fill)`: parte da on-color
**do fill** (`onColorFor` — preto ou branco, polaridade correta) e recua só
`kDisabledIndicatorRetention` (`0.25`) — então fica **clara sobre fill escuro** (e
escura sobre fill claro), visível em vez de sumir. Testes:
`component_state_contrast_test.dart`.

## Como validamos

```bash
cd packages/flocks
flutter test test/src/theme/contrast_test.dart      # gate estrito (AA bloqueante)
flutter test --dart-define=CONTRAST_REPORT=true \
  test/src/theme/contrast_report_test.dart          # regenera o relatório
```

Os testes de contraste têm a tag `contrast` e rodam no CI padrão
(`flutter test --exclude-tags golden`) — bloqueantes. **Hoje as duas marcas passam
AA em todas as verificações** (ver relatório: "0 de 78 falham"). O gate segue ligado
para impedir regressões: qualquer novo par/paleta que não conforme reprova o CI.

## Definition of Accessible

Somar às 10 regras de "Definition of Migrated" (`FLOCKS_MIGRATION_PLAN.md`). Todo
componente/marca novo:

1. Usa **apenas** pares de token cobertos pelo contrato (fill+onColor, texto em
   `onSurface`, borda/foco com 3:1). Não inventa par de cor sem entrada no
   contrato.
2. Se introduzir um **papel de cor novo** no `AppColorTheme`, adiciona a
   `ContrastRule` correspondente em `flocksContrastContract` (par) ou uma
   `StructuralRule` em `flocksStructuralContract` (checagem single-color).
3. Passa nos testes de contraste **AA** (verde) para todas as marcas × brilhos.
4. No escuro: respeita a banda de superfície, elevação-por-clareamento e a
   separação dobrada.

## Fontes

- [WebAIM — Contrast and Color](https://webaim.org/articles/contrast/)
- [Material 3 — The science of color & design](https://m3.material.io/blog/science-of-color-design) (regra 40/50 de ΔT)
- [Flutter — `Color.computeLuminance`](https://api.flutter.dev/flutter/dart-ui/Color/computeLuminance.html)
- [APCA vs WCAG 2](https://66colorful.com/blog/apca-contrast/) (por que WCAG 2 erra no escuro)
- [Smashing — Inclusive Dark Mode](https://www.smashingmagazine.com/2025/04/inclusive-dark-mode-designing-accessible-dark-themes/) · [atmos — Dark Mode Best Practices](https://atmos.style/blog/dark-mode-ui-best-practices)
