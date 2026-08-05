# Flocks Widgetbook — use-case conventions

These rules keep the catalog predictable: a user browsing any component finds the same
shape, the same controls, and the same vocabulary. Follow them for every new component.

All helpers live in [`use_cases/wb_helpers.dart`](use_cases/wb_helpers.dart). Read the two
reference files before authoring: [`toggles_use_cases.dart`](use_cases/toggles_use_cases.dart)
(single component — `States` + `Playground`) and [`icon_use_cases.dart`](use_cases/icon_use_cases.dart)
(value collection — `Catalog` + search).

## The rules

1. **Everything English.** `@UseCase` names, header name/description, knob labels — all
   English. So are the `.doc.md` files and the `en` side of every `*.meta.dart`
   (`test/architecture/catalog_language_test.dart` enforces that one). The `///`
   doc-comments inside `lib/` are still Portuguese — this rule does not reach them.
2. **One frame: `wbUseCase`.** Every use case returns
   `wbUseCase(context, name: '<ComponentClass>', description: '<one-liner>', child: …)`.
   It centers the content, renders the header (component name + a one-line English
   description of *what this case shows / when to use it*), and — when `panel: true` — paints
   a rounded `surfaceContainer` panel behind the child.
3. **`panel: true` is mandatory for single-component cases.** Every use case that shows one
   component sits on the surface panel — components sit on an elevated surface in the real app,
   so show that. When a component is wider than the panel's inner width
   (`maxWidth − 2 × panelPadding`), raise `maxWidth` and/or lower `panelPadding` so it fits
   without horizontal overflow. `panel: false` is allowed in exactly two cases:
   - **value-collection catalogs** (`wbCatalog`: icons/illustrations/tokens, which also widen
     `maxWidth`, e.g. `1100`);
   - **bar scenes** (`wbBarScene`, for headers/footers) — the phone frame *is* the panel, and a
     bar cannot be judged sitting on a flat swatch;
   - **glass stages** (`wbGlassStage`, case name `Glass over backdrop`) — glass samples a live
     backdrop, so a flat panel behind it shows nothing at all.
9. **Bars are shown in a scene, not on a swatch.** Every header/footer case renders through
   `wbBarScene(context, header:, footer:)`. The scene gives the three things a bar needs to be
   evaluated: content that **actually scrolls under it** (the glass axis samples a live
   backdrop — a frozen one hides every seam), a **fake safe area** (the widgetbook canvas
   reports zero insets, so the safe-area plateau would never render), and a real `AppScaffold`
   (so the overlay contract runs instead of being faked by a `Positioned`). Mock page content
   comes from `wbMockFeed` — busy on purpose, since a blur over a smooth gradient is
   indistinguishable from no blur at all.
4. **Centered.** Handled by `wbUseCase` — never hand-roll alignment.
5. **A `Playground` for every component.** Exactly one, exposing **every** configurable
   constructor parameter as a knob. Read the source and use the real parameter names as
   knob labels — never invent a param.
6. **CTA only for transitions/advances.** Add a `wbCta(context, label:, onPressed:)` (via
   the `cta:` slot) only when an explicit action is needed to demonstrate the component:
   a stepper advancing, a one-shot motion transition replaying. **No CTA** for selectors
   (checkbox/switch/radio), for hover/focus/press targets (tooltip, interactive motion,
   scale-on-tap), or for cases driven by a value slider (the slider is the control).
7. **Catalog + search for value collections** (icons, illustrations, design tokens). Use
   `wbCatalog` (filters by `wbSearch`, shows an `N of M` count and an empty state) inside a
   `panel: false` `wbUseCase`. See the icon reference.
8. **Playground + States for every component**, except **motion primitives**
   (`AppFade`, `AppSlide`, `AppPop`…): what they show is the transition, and a frozen grid
   removes exactly that. The carve-out is a named list in
   [`tool/widgetbook_conventions.dart`](../tool/widgetbook_conventions.dart) — add to it with a
   reason, don't widen the rule. Besides the `Playground`, every component has a
   `States` case — a static grid (built from `wbState` cards) that shows its visual states at a
   glance (what a single Playground can't show at once). `AppButton` is the reference. Still
   consolidate incidental duplicates into the `Playground` (a value that differs by one knob is
   not a second case); use `Sizes`/`Type scale` in place of `States` only when the whole-set
   view is a size scale or type scale.

## Canonical case names

| Name | Use for |
| --- | --- |
| `Playground` | The dynamic, knob-driven case. Every component has exactly one. |
| `Catalog` | A searchable gallery of a value collection (icons, illustrations, tokens). |
| `States` | A static grid of a component's visual states (checked/disabled/…). |
| `Sizes` | A static grid across a size scale. |
| `Type scale` | The typography-specific catalog (`AppText`). |
| `Scenario` | One realistic screen using the component, for components that live in groups (list tiles, cards) or whose behaviour only shows in context. |
| `Glass over backdrop` | The `wbGlassStage` case of a component on the glass axis. |

Color and token group pages keep descriptive names (`Semantic colors`,
`Surface, border & focus`, `Data-viz`, `Spacing`, `Radius`, `Strokes`).

## Knob cheatsheet

```dart
context.knobs.boolean(label: 'enabled', initialValue: true);              // bool
context.knobs.string(label: 'label', initialValue: '');                  // String
context.knobs.double.slider(label: 'size', initialValue: 24, min: 16, max: 96);
context.knobs.int.slider(label: 'steps', initialValue: 4, min: 2, max: 8, divisions: 6);
context.knobs.object.dropdown<AppTooltipSize>(                           // enum / object
  label: 'size', options: AppTooltipSize.values,
  initialOption: AppTooltipSize.medium, labelBuilder: (s) => s.name);
wbSemanticColorKnob(context, label: 'color');                            // Color? (null = default)
wbSearch(context);                                                       // String, lowercased
```

- **Design tokens** (size, spacing, stroke, radius, duration) → a **token dropdown**, never a
  free slider: `wbSizeKnob` / `wbSpacingKnob` / `wbStrokeKnob` / `wbRadiusKnob` /
  `wbDurationKnob`. The user picks from the real scale (labels show `name (value)`). Enum-token
  sizes keep their own dropdown (`AppIconSize`, `AppIllustrationSize`, `AppTooltipSize`). Only
  genuinely continuous values with no token — scale, opacity, turns, progress, `dx`/`dy`,
  arbitrary widths (`maxWidth`/`minWidth`/`initialWidth`/`panelMaxHeight`), `customSize`, and
  counts (`int.slider`) — stay sliders.
- **Colors** → `wbSemanticColorKnob` (all roles incl. Neutral), or `context.knobs.color` for a raw color.
- **Enums** → `context.knobs.object.dropdown(options: X.values)`.
- **CTA-driven cases** → put the mutable state (e.g. `currentStep`, `visible`) in a small
  `StatefulWidget` that takes the knob values as fields and, in `build()`, returns
  `wbUseCase(…, child: <component>, cta: wbCta(context, label: '…', onPressed: () => setState(…)))`.

## Authoring checklist

1. Add a `Playground` wrapped in `wbUseCase` with an English `name` + `description`.
2. Expose every constructor parameter as a knob (real names; token-backed values→token
   dropdowns `wbSize/Spacing/Stroke/Radius/DurationKnob`, colors→`wbSemanticColorKnob`,
   enums→`object.dropdown`; only tokenless continuous values stay sliders).
3. `panel: true` (mandatory for single-component cases; `panel: false` only for `wbCatalog`
   collections and `wbBarScene` bar scenes). Raise `maxWidth`/lower `panelPadding` for
   components wider than the panel.
4. `wbCta` only for a transition/advance; never for selectors or value-slider cases.
5. For value collections, add a `Catalog` (`wbCatalog` + `wbSearch`).
6. Add a `States` grid — every component has one (or `Sizes`/`Type scale` when the whole-set
   view is a size/type scale).
7. All text English.
8. Regenerate + verify: `dart run build_runner build --delete-conflicting-outputs`, then
   `dart analyze` and `flutter test` must be clean. Use-case bodies import only
   `package:flutter/widgets.dart`, `package:flocks/flocks.dart`, and widgetbook — never
   Material (the architecture test enforces this for the DS). The one exception on record is
   `ReorderableListView` in `list_tile_use_cases.dart`: the `widgets` layer has no reorderable
   list, and `AppListTile.reorderIndex` exists to live inside one. New exceptions go in
   `kMaterialImportAllowlist` **with the reason**, or they fail the test.

## The rules are a test, not a wish

`test/architecture/widgetbook_conventions_test.dart` runs all of the above against
`widgetbook/use_cases/` on every `flutter test`: canonical case names, one `Playground` per
component, a whole-set view, no Material import outside the allow-list, no Portuguese in the
catalog chrome, and no design token on a free slider. If a rule here needs to bend, bend it in
[`tool/widgetbook_conventions.dart`](../tool/widgetbook_conventions.dart) — where the exception
is visible — rather than in silence.
