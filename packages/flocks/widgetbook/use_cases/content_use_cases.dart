import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppMarkdown — GitHub-Flavored Markdown. AppHtml — a safe subset of HTML.
// Both render on widgets.dart only: no Material, no flutter_html.
// ---------------------------------------------------------------------------

const String _markdownSample = '''
# Trip report

Summary with **bold**, _italic_, ~~struck~~ and `inline code`.
See the [full route](https://example.com/route) for detail.

## Findings

- Speeding
    - Urban stretch
    - Highway
- Harsh braking

1. Review telemetry
2. Notify the driver

> The average only considers stretches with a valid GPS fix.

```dart
final average = points
    .where((p) => p.gpsValid)
    .map((p) => p.speedKmh)
    .average;
```

---

| Plate | Model | Events |
| --- | --- | --- |
| ABC-1234 | GV75 | 12 |
| XYZ-9876 | GV55 | 3 |
''';

const String _htmlSample = '''
<h1>Privacy Policy</h1>
<p>This policy describes how we handle <strong>personal data</strong>.</p>
<h2>Collected data</h2>
<ul><li>Device identification</li><li>Geographic position</li></ul>
<blockquote>Data is retained for 12 months.</blockquote>
<p>Questions? Reach the <a href="https://example.com/dpo">data officer</a>.</p>
''';

/// HTML that exercises every rejection path at once.
const String _htmlUnsafeSample = '''
<p>Visible paragraph.</p>
<script>alert("this never renders")</script>
<style>body { display: none }</style>
<iframe src="https://malicious.example"></iframe>
<p><a href="javascript:alert(1)">Text kept, link disarmed</a></p>
<p><a href="https://example.com">Real link, still clickable</a></p>
<custom-tag><p>Unknown tag degrades to its children</p></custom-tag>
''';

@widgetbook.UseCase(name: 'Playground', type: AppMarkdown)
Widget markdownPlayground(BuildContext context) {
  final String data = context.knobs.string(
    label: 'data',
    initialValue: _markdownSample,
  );
  final bool selectable = context.knobs.boolean(
    label: 'selectable',
    initialValue: true,
  );
  final Color? textColor = wbSemanticColorKnob(context, label: 'textColor');

  return wbUseCase(
    context,
    name: 'AppMarkdown',
    description:
        'Renders GitHub-Flavored Markdown straight from the parser AST. '
        'Headings, lists, quotes, code, tables and links all come from theme '
        'tokens. Tapping a link opens the external browser unless onTapLink '
        'is provided.',
    maxWidth: 680,
    child: AppMarkdown(
      data: data,
      textColor: textColor,
      selectable: selectable,
    ),
  );
}

@widgetbook.UseCase(name: 'Catalog', type: AppMarkdown)
Widget markdownCatalog(BuildContext context) => wbUseCase(
  context,
  name: 'AppMarkdown · every block type',
  description:
      'Headings, inline emphasis, nested lists, ordered lists, blockquote, '
      'fenced code, thematic break and a GFM table — the full supported set.',
  maxWidth: 680,
  child: const AppMarkdown(data: _markdownSample),
);

@widgetbook.UseCase(name: 'Scenario', type: AppMarkdown)
Widget markdownStreaming(BuildContext context) {
  final int chars = context.knobs.int.slider(
    label: 'characters received',
    initialValue: _markdownSample.length ~/ 3,
    min: 1,
    max: _markdownSample.length,
  );

  return wbUseCase(
    context,
    name: 'AppMarkdown · partial input',
    description:
        'Simulates the chat receiving a response character by character. '
        'Unterminated fences and half-written tables must never throw — drag '
        'the slider through the whole message to confirm.',
    maxWidth: 680,
    child: AppMarkdown(data: _markdownSample.substring(0, chars)),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppHtml)
Widget htmlPlayground(BuildContext context) {
  final String data = context.knobs.string(
    label: 'data',
    initialValue: _htmlSample,
  );
  final bool selectable = context.knobs.boolean(
    label: 'selectable',
    initialValue: true,
  );
  final Color? textColor = wbSemanticColorKnob(context, label: 'textColor');

  return wbUseCase(
    context,
    name: 'AppHtml',
    description:
        'Renders a deliberate subset of HTML through the same renderer as '
        'AppMarkdown, so both look identical. Accepts a full document or a '
        'fragment. It is not a browser: CSS is not interpreted.',
    maxWidth: 680,
    child: AppHtml(data: data, textColor: textColor, selectable: selectable),
  );
}

@widgetbook.UseCase(name: 'States', type: AppHtml)
Widget htmlSanitization(BuildContext context) => wbUseCase(
  context,
  name: 'AppHtml · untrusted input',
  description:
      'Legal content comes from the backend, so it is treated as untrusted. '
      'script/style/iframe are dropped with their subtree; a javascript: href '
      'loses the gesture but keeps its text; an unknown tag degrades to its '
      'children. Nothing here should render except the paragraphs.',
  maxWidth: 680,
  child: const AppHtml(data: _htmlUnsafeSample),
);

// ---------------------------------------------------------------------------
// AppCodeBlock — a standalone code block: monospaced, copyable, no reflow.
// ---------------------------------------------------------------------------

const String _jsonSample = '''
{
  "device_id": "0f6f1b6a-2f1a-4f0e-9a1b-2c3d4e5f6a7b",
  "imei": "860123456789012",
  "sim_card": { "iccid": "8955170000000000000", "carrier": "Allcom" },
  "active": true
}''';

const String _curlSample =
    "curl -X POST 'https://api.tracked.local/associations/device-sim-card' \\\n"
    "  -H 'Authorization: Bearer <your_token>' \\\n"
    "  -H 'Content-Type: application/json' \\\n"
    '  -d \'{"device_id": "…", "sim_card_id": "…"}\'';

@widgetbook.UseCase(name: 'Playground', type: AppCodeBlock)
Widget codeBlockPlayground(BuildContext context) {
  final String code = context.knobs.string(
    label: 'code',
    initialValue: _jsonSample,
  );
  final String language = context.knobs.string(
    label: 'language',
    initialValue: 'json',
  );
  final bool showCopy = context.knobs.boolean(
    label: 'showCopy',
    initialValue: true,
  );
  final bool wrap = context.knobs.boolean(label: 'wrap', initialValue: false);
  final bool selectable = context.knobs.boolean(
    label: 'selectable',
    initialValue: true,
  );
  final String copyTooltip = context.knobs.string(
    label: 'copyTooltip',
    initialValue: 'Copy',
  );
  final String copiedTooltip = context.knobs.string(
    label: 'copiedTooltip',
    initialValue: 'Copied',
  );

  return wbUseCase(
    context,
    name: 'AppCodeBlock',
    description:
        'Shares AppContentStyle with the two renderers, so a loose payload '
        'looks exactly like the same snippet inside a document. Copy swaps the '
        'icon for a check and reverts on its own.',
    maxWidth: 680,
    panelPadding: AppSpacings.s24,
    child: AppCodeBlock(
      code: code,
      language: language.isEmpty ? null : language,
      showCopy: showCopy,
      wrap: wrap,
      selectable: selectable,
      copyTooltip: copyTooltip,
      copiedTooltip: copiedTooltip,
      style: wbStyleKnob(context),
      radiusMode: wbRadiusModeKnob(context),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppCodeBlock)
Widget codeBlockStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppCodeBlock',
  description:
      'Labelled JSON, a wrapped shell command, and the bare body (no language, '
      'no copy — the header disappears entirely).',
  maxWidth: 680,
  panelPadding: AppSpacings.s24,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      wbState(
        context,
        name: 'JSON · no reflow',
        width: 600,
        child: const AppCodeBlock(code: _jsonSample, language: 'json'),
      ),
      const SizedBox(height: AppSpacings.s24),
      wbState(
        context,
        name: 'Shell · wrapped',
        width: 600,
        child: const AppCodeBlock(
          code: _curlSample,
          language: 'bash',
          wrap: true,
        ),
      ),
      const SizedBox(height: AppSpacings.s24),
      wbState(
        context,
        name: 'Body only',
        width: 600,
        child: const AppCodeBlock(code: 'ENV=prd', showCopy: false),
      ),
    ],
  ),
);
