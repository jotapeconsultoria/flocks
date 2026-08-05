# AppSideInset

Applies — and **consumes** — the side breathing room the host surface published
in `MediaQuery.padding`.

## Why the surface publishes instead of insetting

A side sheet reserves a lateral strip: the drag gutter lives there, and without
the reservation it steals the content's clicks.

The obvious way to reserve it would be wrapping everything in a `Padding`.
Except that also insets the **viewport** of any scroll inside it — and the
scrollbar, which lives at the viewport's edge, ends up floating far from the
sheet's side, as if there were leftover margin to its right.

By publishing the inset, each side solves it as it needs to:

| Content | What it does |
| --- | --- |
| **scrolls** | adds `MediaQuery.paddingOf(context)` to its own scrollable's `padding` — the content breathes, the viewport reaches the edge, the scrollbar sits against it |
| **does not scroll** | wraps itself in `AppSideInset` |

## When to use

- **Non-scrollable** content inside a side sheet: a header, a footer, a short
  form.

## When NOT to use

- Content that **scrolls** — add the padding in the scrollable, as above.
- Fixed layout breathing room → a `Padding` with an `AppSpacings` token.

## It consumes what it applies

After applying the inset, the widget **removes** it from the subtree's
`MediaQuery`. Without that, a scrollable further down would add the same value
again and the content would appear doubly inset. As a useful side effect,
nesting two `AppSideInset`s is harmless: the inner one becomes a no-op.

With no published inset, the widget is a pass-through — it does not even mount
the `Padding`.

## Accessibility

It does not change the semantics tree: it is only padding. Consuming the value
avoids the doubled inset, which would push touch targets outside the comfortable
band.

## Example

```dart
AppSideInset(child: AppButtonsFooter(primary: saveButton));
```
