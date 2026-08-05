# AppCard

Generic **structured** card — a bordered surface that organizes content into
optional slots (header, body, footer). It is also the base for popovers and
floating panels.

## When to use

- A structured content panel (title, body, actions).
- A generic popover or floating panel over the UI (pin `style: elevated`).

## When NOT to use

- An alert with a title + a semantic icon → `AppAlert`.
- A full-page modal → `AppDialog` (organism).
- Just a surface box with no structure → `AppSurface` (atom).

## Anatomy

- **Optional slots** (all combinable; at least one is required):
  - **Header** (`Padding` + `Row`): `headerLeading` · `headerTitle` ·
    `headerTrailing`. It appears if any of the three is non-null. `headerTitle`
    is `titleMedium`/`onSurface` (1 line, ellipsized).
  - **Content**: a free `child`.
  - **Footer**: a free `footer` (action buttons, say).
- **showDividers**: when `true`, a full-bleed `AppDivider` separates the sections
  present (header ↔ content ↔ footer). Default `false` (spacing only).
- **Background**: `surfaceContainer` (elevation by tone).
- **style** (the `AppStyle` axis): `filled` = a flat background; `outlined` = a
  background + an `outline` border; `elevated` = a background + a symmetric
  shadow (theme-aware). Like the design system's other containers, the default
  **follows the global** `styleTheme`; floating panels pin `elevated`.
- **Border** (the `outlined` style): the `outline` token by default (≥ 3:1
  against the surface); pass `accentColor` to emphasize it.
- **Radius**: it follows the global radius (`radiusMode`/`radius` override it);
  the container clips the content (`Clip.antiAlias`).
- **Padding**: defaults to `EdgeInsets.all(AppSpacings.s16)`, applied per
  section; the dividers are full-bleed.

## Pointer interception

It does not embed a `PointerInterceptor`. If the card floats over a *platform
view* (a map on the web, say) and clicks must not leak, the **caller** wraps it
in the interceptor — that is not a design primitive's job (it keeps `flocks` free
of the web dependency).

## Accessibility (Rule 8)

- A visual container: the semantics come from `headerTitle`/`child`/`footer`.
- The `outline` border and the content (`onSurface` over `surfaceContainer`) meet
  the contract's targets in light and dark across both brands.

## Do / Don't

- ✅ Use the slots to structure it; turn `showDividers` on to separate sections.
- ✅ Pin `style: elevated` on floating panels (menu/dropdown).
- ❌ Do not count on built-in pointer interception over maps.

## Example

```dart
AppCard(
  headerTitle: 'Location',
  headerTrailing: someAction,
  child: mapPreview,
)
```
