import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppShortcutHint — the badge that SHOWS a keyboard shortcut. Decorative (no
// pointer), so no CTA: the knobs are the control.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppShortcutHint)
Widget appShortcutHintPlayground(BuildContext context) {
  final String key = context.knobs.string(label: 'key', initialValue: 'K');
  final bool primary = context.knobs.boolean(
    label: 'usesPrimaryModifier',
    initialValue: true,
  );
  final bool shift = context.knobs.boolean(label: 'shift');
  final bool alt = context.knobs.boolean(label: 'alt');
  final AppShortcutHintSize size = context.knobs.object
      .dropdown<AppShortcutHintSize>(
        label: 'size',
        options: AppShortcutHintSize.values,
        initialOption: AppShortcutHintSize.s,
        labelBuilder: (AppShortcutHintSize v) => v.name,
      );
  final Color? color = wbSemanticColorKnob(context, label: 'color');
  final Color? background = wbSemanticColorKnob(context, label: 'background');

  return wbUseCase(
    context,
    name: 'AppShortcutHint',
    description:
        'The badge that makes a shortcut discoverable. The modifier resolves '
        'per platform (⌘ on Apple, Ctrl elsewhere) — never hardcode it. '
        'background is the surface the badge sits on: it picks the readable '
        'stop, so pass the real one when it is not surfaceContainer.',
    child: AppShortcutHint(
      AppShortcut(key, usesPrimaryModifier: primary, shift: shift, alt: alt),
      size: size,
      color: color,
      background: background,
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppShortcutHint)
Widget appShortcutHintStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppShortcutHint',
  description:
      'Sizes and modifier combinations. Note the square floor: "/" is as wide '
      'as "Esc" — without it a row of tabs would show badges of different '
      'widths.',
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s16,
    runSpacing: AppSpacings.s16,
    children: <Widget>[
      wbState(
        context,
        name: 'plain',
        child: const AppShortcutHint(AppShortcut('/')),
      ),
      wbState(
        context,
        name: 'word key',
        child: const AppShortcutHint(AppShortcut('Esc')),
      ),
      wbState(
        context,
        name: 'primary modifier',
        child: const AppShortcutHint(AppShortcut.primary('K')),
      ),
      wbState(
        context,
        name: 'primary + shift',
        child: const AppShortcutHint(AppShortcut.primary('S', shift: true)),
      ),
      wbState(
        context,
        name: 'size m',
        child: const AppShortcutHint(
          AppShortcut.primary('K'),
          size: AppShortcutHintSize.m,
        ),
      ),
    ],
  ),
);
