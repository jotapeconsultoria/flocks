# Rich content — `AppMarkdown`, `AppHtml` and `AppCodeBlock`

Two organisms that render rich documents with Flocks' tokens, over plain
`package:flutter/widgets.dart` — **no Material, no Cupertino, no
`flutter_html`**.

## Why they exist

The previous implementation lived in `tracked_shared_pkg` and depended on
`flutter_html`, which requires a `Material` ancestor to render. That blocked the
migration into Flocks, whose hard rule is to be design-system-agnostic. There was
also a structural detour: Markdown was converted to an HTML *string* only so the
HTML renderer could re-parse it.

Here Markdown is read straight from `package:markdown`'s **AST**, and HTML from
`package:html`'s DOM. Both parsers are pure Dart (they draw nothing), so the
render is 100% ours.

## Architecture

```
AppMarkdown ─► markdown AST ─┐
                              ├─► List<ContentNode> ─► ContentBlockBuilder ─► Widget
AppHtml     ─► html DOM ──────┘        (a normalized tree)   + ContentInlineBuilder
                (+ allow-list)
```

The two ASTs have the same shape — a tree of tags, and GFM already emits tags
with HTML names (`p`, `strong`, `ul`…). Normalizing them into `ContentNode`
allows **a single renderer**, which guarantees that the same document looks
identical whether it came from Markdown or from HTML.

The render has two phases: **blocks** become widgets in a `Column`; each block's
**inline** content becomes a single `Text.rich`, so the text engine wraps
correctly between fragments of differing styles.

## Style

Everything comes from `AppTheme.of(context)` through
`AppContentStyle.resolve(context)`:

| Element | Token |
| --- | --- |
| body | `textTheme.bodyLarge` |
| `h1`–`h3` | `headlineLarge/Medium/Small` |
| `h4`–`h6` | `titleLarge/Medium/Small` |
| link | `primaryAccent` + an underline |
| code | the system mono over `surfaceContainer` |
| quote | the body at 78% + an `outline` bar |
| rule | an `AppDivider` with `divider` |

`style`/`textColor` still work (for backward compatibility); `styleSheet` beats
both when given.

## Security

`AppMarkdown` receives content from our own AI; `AppHtml` receives content from
the **backend** and treats it as untrusted:

- `script`, `style`, `iframe`, `object`, `form`, `input`… are dropped **along
  with their subtree** — they never become visible text;
- `href`/`src` go through scheme validation: only `http`, `https`, `mailto`,
  `tel`, `sms` and relative URLs. `javascript:` and `data:` are removed, but the
  **link's text remains**;
- an unknown tag degrades to its own children: the formatting is lost, **never
  the text**.

Raw HTML embedded in Markdown is rendered as literal text, never interpreted.

## Known caveats

- **Horizontal scrolling belongs to the call site.** Wide tables and code blocks
  do not scroll on their own; wrap them in a horizontal `SingleChildScrollView`
  when needed.
- **No bundled monospaced font.** Flocks bundles only Poppins and Space Grotesk,
  and the code depends on the OS's mono (`kAppContentMonoFamily` +
  `kAppContentMonoFallback`). In the test sandbox neither exists, so
  `test/flutter_test_config.dart` registers Poppins under the mono family's name
  as a legible stand-in. Bundling a mono in Flocks would settle both points.
- **Links are not Tab-focusable.** Touch works (through a `TapGestureRecognizer`
  on the leaf spans), but keyboard traversal is Gate 7 debt.
- **Streaming.** The parse is memoized in `didUpdateWidget` and only redone when
  `data` changes — the chat rebuilds every frame. Partial input (an unclosed
  fence or table) never throws.
- **Superscript and subscript** are approximated with a smaller body: `TextSpan`
  exposes no baseline offset.

## Validation against the backend

The real payloads from `GET /support` (the `privacy_policy`/`service_terms`
columns of the `accounts` table) are pinned in
`test/src/organisms/content/fixtures/` and exercised by
`legal_fixtures_test.dart` — including a coverage test that **fails if the
backend starts emitting a tag outside the allow-list**, signalling that the
supported subset has to grow.

A real detail captured there: the backend emits attributes **without quotes**
(`href=mailto:privacidade@tracked.local`). It is valid HTML and the parser
handles it fine, but there is an explicit test for it.

To recapture with the local environment up:

```sh
docker exec tracked-api-postgres-1 psql -U tracked -d tracked -t -A \
  -c "SELECT privacy_policy FROM accounts WHERE privacy_policy IS NOT NULL LIMIT 1;" \
  > test/src/organisms/content/fixtures/privacy_policy.html
```

## Examples

```dart
// The AI chat
AppMarkdown(data: message.text, textColor: theme.colorTheme.onSurface)

// A legal document, with internal link routing
AppHtml(data: state.privacyPolicy, onTapLink: (String href) => context.go(href))
```

## `AppCodeBlock`

A standalone code block, for when the snippet does **not** come inside a
document: a request/response payload, a cURL command, a configuration excerpt. It
reads the same `AppContentStyle` as both renderers, so a loose JSON looks
identical to the same JSON inside a Markdown document — the mono, the background,
the padding and the radius are the same.

Two deliberate differences from `AppMarkdown`'s internal `pre > code` block:

- **It does not wrap by default** (`wrap: false`): it scrolls horizontally. A
  JSON's indentation and a shell command's line breaks are information; a reflow
  destroys both.
- **It has a copy action.** The use case is pasting elsewhere — in the terminal,
  in Insomnia, in a ticket. It is an `AppCopyButton`: the icon becomes a check and
  the tooltip becomes "Copied!" for `kAppCopiedFeedback`, returning on its own.

The header (the language label + the button) sits outside the selection region,
so selecting and copying by hand picks up only the code.

It takes part in the global style and shape axes. Since the background already
comes from the content stylesheet, `outlined` only adds the border and `elevated`
only the shadow — neither of them swaps the background.

```dart
AppCodeBlock(code: requestJson, language: 'json')
AppCodeBlock(code: curl, language: 'bash', wrap: true)
```

> `AppMarkdown`'s private `_codeBlock` does **not** delegate to this component:
> giving a copy button to every code fence in the chat and in the legal pages is a
> change of behavior (and of goldens) that deserves a decision of its own.
