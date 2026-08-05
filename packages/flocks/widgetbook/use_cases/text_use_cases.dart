import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppText — Type scale (every token) + Playground (all knobs).
// AppRichText — Playground (mixed inline styles).
// Text renders values; there is no interactive transition, so NO CTA.
// ---------------------------------------------------------------------------

/// One named style from the type scale, paired with its token label.
class _ScaleEntry {
  const _ScaleEntry(this.name, this.style);

  final String name;
  final TextStyle style;
}

/// The 15 typography tokens, top of the scale to the bottom.
const List<_ScaleEntry> _typeScale = [
  _ScaleEntry('displayLarge', AppTextStyles.displayLarge),
  _ScaleEntry('displayMedium', AppTextStyles.displayMedium),
  _ScaleEntry('displaySmall', AppTextStyles.displaySmall),
  _ScaleEntry('headlineLarge', AppTextStyles.headlineLarge),
  _ScaleEntry('headlineMedium', AppTextStyles.headlineMedium),
  _ScaleEntry('headlineSmall', AppTextStyles.headlineSmall),
  _ScaleEntry('titleLarge', AppTextStyles.titleLarge),
  _ScaleEntry('titleMedium', AppTextStyles.titleMedium),
  _ScaleEntry('titleSmall', AppTextStyles.titleSmall),
  _ScaleEntry('bodyLarge', AppTextStyles.bodyLarge),
  _ScaleEntry('bodyMedium', AppTextStyles.bodyMedium),
  _ScaleEntry('bodySmall', AppTextStyles.bodySmall),
  _ScaleEntry('labelLarge', AppTextStyles.labelLarge),
  _ScaleEntry('labelMedium', AppTextStyles.labelMedium),
  _ScaleEntry('labelSmall', AppTextStyles.labelSmall),
];

@widgetbook.UseCase(name: 'Type scale', type: AppText)
Widget appTextTypeScale(BuildContext context) {
  final theme = AppTheme.of(context);
  final color = wbSemanticColorKnob(context) ?? theme.colorTheme.onSurface;
  return wbUseCase(
    context,
    name: 'AppText',
    description: 'Every typography token in the scale.',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in _typeScale) ...[
          AppText(entry.name, style: entry.style.withColor(color)),
          const SizedBox(height: AppSpacings.s16),
        ],
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppText)
Widget appTextPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final data = context.knobs.string(
    label: 'data',
    initialValue: 'The quick brown fox jumps over the lazy dog.',
  );
  final entry = context.knobs.object.dropdown<_ScaleEntry>(
    label: 'style',
    options: _typeScale,
    initialOption: _typeScale[10], // bodyMedium
    labelBuilder: (e) => 'AppTextStyles.${e.name}',
  );
  final color = wbSemanticColorKnob(context);
  final maxLines = context.knobs.int.slider(
    label: 'maxLines',
    initialValue: 2,
    min: 1,
    max: 5,
    divisions: 4,
  );
  final overflow = context.knobs.object.dropdown<TextOverflow>(
    label: 'overflow',
    options: TextOverflow.values,
    initialOption: TextOverflow.ellipsis,
    labelBuilder: (o) => 'TextOverflow.${o.name}',
  );
  final textAlign = context.knobs.object.dropdown<TextAlign>(
    label: 'textAlign',
    options: TextAlign.values,
    initialOption: TextAlign.start,
    labelBuilder: (a) => 'TextAlign.${a.name}',
  );
  final softWrap = context.knobs.boolean(label: 'softWrap', initialValue: true);

  // 'Default' → the component's real default color (onSurface), so the text
  // inverts with the theme. The raw AppTextStyles consts bake in a dark color.
  final style = entry.style.withColor(color ?? theme.colorTheme.onSurface);
  return wbUseCase(
    context,
    name: 'AppText',
    description: 'Control text, style, wrapping and overflow.',
    child: SizedBox(
      width: 240,
      child: AppText(
        data,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
        softWrap: softWrap,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppRichText)
Widget appRichTextPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final boldWord = context.knobs.string(
    label: 'boldWord',
    initialValue: 'important',
  );
  final maxLines = context.knobs.int.slider(
    label: 'maxLines',
    initialValue: 2,
    min: 1,
    max: 5,
    divisions: 4,
  );
  final overflow = context.knobs.object.dropdown<TextOverflow>(
    label: 'overflow',
    options: TextOverflow.values,
    initialOption: TextOverflow.ellipsis,
    labelBuilder: (o) => 'TextOverflow.${o.name}',
  );
  final softWrap = context.knobs.boolean(label: 'softWrap', initialValue: true);
  final textAlign = context.knobs.object.dropdown<TextAlign>(
    label: 'textAlign',
    options: TextAlign.values,
    initialOption: TextAlign.start,
    labelBuilder: (a) => 'TextAlign.${a.name}',
  );

  final base = theme.textTheme.bodyMedium.withColor(theme.colorTheme.onSurface);
  final span = AppTextSpan(
    style: base,
    children: [
      const TextSpan(text: 'This is an '),
      TextSpan(
        text: boldWord,
        style: base.bold.withColor(theme.colorTheme.primary),
      ),
      const TextSpan(text: ' inline highlight inside a normal sentence.'),
    ],
  );

  return wbUseCase(
    context,
    name: 'AppRichText',
    description: 'Rich text with mixed inline styles.',
    child: SizedBox(
      width: 240,
      child: AppRichText(
        span,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textAlign: textAlign,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppRichText)
Widget appRichTextStates(BuildContext context) {
  final theme = AppTheme.of(context);
  final base = theme.textTheme.bodyMedium.withColor(theme.colorTheme.onSurface);

  AppTextSpan span(List<InlineSpan> children) =>
      AppTextSpan(style: base, children: children);

  return wbUseCase(
    context,
    name: 'AppRichText',
    description:
        'Mixed inline styles in one paragraph. AppRichText exists because '
        'stitching several AppText side by side breaks the line box: the '
        'words stop wrapping as one sentence.',
    maxWidth: 720,
    panelPadding: AppSpacings.s32,
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacings.s32,
      runSpacing: AppSpacings.s24,
      children: [
        wbState(
          context,
          name: 'inline emphasis',
          width: 260,
          child: AppRichText(
            span([
              const TextSpan(text: 'The vehicle is '),
              TextSpan(
                text: 'offline',
                style: base.bold.withColor(theme.colorTheme.danger),
              ),
              const TextSpan(text: ' since 08:12.'),
            ]),
          ),
        ),
        wbState(
          context,
          name: 'truncates (maxLines: 1)',
          width: 260,
          child: AppRichText(
            span([
              const TextSpan(text: 'A long sentence that '),
              TextSpan(text: 'does not fit', style: base.bold),
              const TextSpan(text: ' on a single line of this narrow box.'),
            ]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        wbState(
          context,
          name: 'centered',
          width: 260,
          child: AppRichText(
            span([
              const TextSpan(text: 'Centred '),
              TextSpan(text: 'rich', style: base.bold),
              const TextSpan(text: ' text.'),
            ]),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
