# AppScaffold & AppAuthSplitLayout

The design system's two page layouts.

**`AppScaffold`** — a consistent page layout: **header · content · footer** over
the theme's `surface` color, with an optional `SafeArea`.

**`AppAuthSplitLayout`** — the layout of the entry screens (login, forgot
password, first access): a brand panel on one side, the form on the other. It is
not an `AppScaffold` with two columns: it is responsive on its own and **gives up
the brand panel** below the desktop breakpoint, because on a phone half a screen
spent on a logo is half a screen less for the form.

## When to use

- The base of a page or screen with a fixed header and/or footer.
- The body of an `AppBottomSheet` (content + an action footer).

## When NOT to use

- A floating surface with a fill, border or shadow → `AppCard`/`AppDialog`.

## Anatomy

- **Background**: the theme's `surface`.
- **Header** (`Widget?`): fixed at the top (an `AppSimpleHeader`,
  `AppPrimaryHeader`, say).
- **Content** (`child`): it expands to take the remaining space.
- **Footer** (`Widget?`): fixed at the bottom (an `AppButtonsFooter`, say).
- **FloatingAction** (`Widget?`): a floating action over the content (an
  `AppFloatingButton`, say), aligned by `floatingActionAlignment` (default
  `AlignmentDirectional.bottomEnd`) with an `AppSpacings.s16` inset.
- **SafeArea**: `safeAreaOnTop`/`safeAreaOnBottom` (both `false` by default).

## Global axes

A **structural** organism: it takes no part in the style (`AppStyle`) or shape
(radius) axes — it places regions and paints the background. No animations of its
own.

## Accessibility

It injects no semantics of its own; each region brings its own. A `surface`
background with `onSurface` text passes WCAG AA in light and dark across both
brands.

## AppAuthSplitLayout

- **Brand panel**: `logoUrl` + `brandTitle` + `brandSubtitle`, over
  `backgroundImageUrl` when present. It is the side that disappears on mobile.
- **Content panel** (`child`): the form. It becomes the whole screen once the
  brand panel leaves.
- Because both brand strings are required, an auth screen cannot come into
  existence without an identity — which is the point of having the layout in the
  design system instead of hand-assembling two columns in every app.
- `logoUrl` is **optional**: it comes from wherever your app hosts its art, and
  an app is not required to host any. When it is `null` the logo goes, and the
  link to the site goes with it — a zero-sized tappable target would still be
  announced to a screen reader with nothing behind it.
- `websiteUrl` is **optional too**, and it is what makes the logo a link. It
  arrives as a parameter, like every other piece of identity here: the layout
  used to read a global brand singleton for this one string, which made it
  untestable without that singleton and impossible to render for two brands on
  one screen. `null` keeps the logo and drops only the interaction.

## Example

```dart
AppScaffold(
  header: const AppSimpleHeader(child: AppText('Vehicles')),
  footer: AppButtonsFooter(primary: saveButton),
  floatingAction: AppFloatingButton(icon: AppIconToken.add, onPressed: create),
  child: content,
);

AppAuthSplitLayout(
  brandTitle: 'Welcome back',
  brandSubtitle: 'Sign in to your account to continue.',
  logoUrl: identity.iconUrl,     // String? — null when you host no art
  websiteUrl: identity.website,  // String? — null keeps the logo, drops the link
  child: const LoginForm(),
);
```
