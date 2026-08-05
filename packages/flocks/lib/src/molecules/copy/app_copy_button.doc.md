# AppCopyButton

Copy button that confirms **in the button itself**: the icon becomes a check in
the success color and the tooltip changes from `Copy` to `Copied!`, both with a
smooth transition. After `kAppCopiedFeedback` (1.6 s) it returns to rest on its
own.

## When to use

- Copying an identifier next to its value (an ID, a tax number, an integration
  code, an endpoint path) — the feedback appears under the cursor, where the eye
  already is.
- Whenever there are **several** copy buttons on the same screen: five copies in
  a row do not stack five snackbars.

## When NOT to use

- Copy as a secondary action in a menu or list → use an `AppMenuItem` or an
  `AppButton` with a label.
- You need a trigger that is not an icon (a chip with text + icon, say) →
  assemble it with `AppInteraction` + `Clipboard`.

## Anatomy

- **Target**: `AppInteraction` (hover/focus/press/keyboard) with symmetric
  `padding`. The target's side is `iconSize + padding · 2`; with the defaults,
  28 px.
- **Glyph**: the `copy` icon (`AppIcon`, in `color`, defaulting to `onSurface`)
  fades out over the first 45% of the transition; then the tick is **drawn**
  stroke by stroke by `AppCheckmarkPainter` in `success`. The two never overlap.
- **Tooltip**: `copyTooltip` ⇄ `copiedTooltip`, cross-fading through
  `AppTooltip`'s own machinery.
- **Reset**: a `Timer(copiedDuration)`, cancelled in `dispose`.
- **`onCopied`**: a hook for telemetry or extra feedback at the call site.
- **`onCopyFailed`**: writing to the clipboard can fail — in the browser,
  `navigator.clipboard.writeText` rejects without a user gesture, outside a
  secure context, or with the permission denied, and Flutter turns that into a
  `PlatformException`. When it fails the button does **not** confirm (showing the
  check without having copied would lie to whoever is about to paste elsewhere)
  and the error goes to this callback instead of becoming a stray exception in
  the zone.

> The tick is drawn rather than fetched from the CDN for a concrete reason: with
> `AppIconToken.check` the confirmation depended on a download fired at that very
> instant, and an `SvgPicture` that fails **never tries again**. A momentary
> network failure became a permanent visual error — and `AppIcon`'s fallback is a
> filled circle in the icon's color, that is, a green dot that looked like a
> success seal. Drawing the stroke removes the network from the critical path and
> lets it be animated as well.

## Accessibility (Rule 8)

- A button role through `AppSemantics.button` (inside the `AppInteraction`), with
  the `semanticLabel` following the tooltip — the reader announces "Copied!"
  after the action.
- The inner `AppIcon`s are decorative (a null `semanticLabel`), otherwise the
  reader would announce "Copy, Copied!" in one breath.
- Enter/Space activate it when focused; a focus ring on the highlight.
- Under reduce-motion the swap is instant (`AppFadeThroughStack` degrades to an
  `IndexedStack`).

## Do / Don't

- ✅ Keep the spacing to its neighbours **outside** the button — the highlight
  wraps the whole child, and asymmetric padding comes out as a crooked target.
- ✅ Use `onCopied` to instrument.
- ❌ Do not stack a snackbar on top: the inline feedback is already the
  confirmation.
- ❌ Do not swap `AppCheckmarkPainter` for `AppIconToken.check` — that puts the
  network back in the exact moment of confirmation (see Anatomy).

## Examples

```dart
// A copyable identifier next to its value.
AppCopyButton(value: account.integrationId)

// Its own label, a role color and telemetry.
AppCopyButton(
  value: endpoint.path,
  copyTooltip: 'Copy path',
  color: theme.colorTheme.secondary.s500,
  onCopied: () => analytics.track('endpoint_path_copied'),
)
```
