import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppSegmentedButton — Playground (all knobs). Selecting a segment IS the
// interaction, so there is NO CTA. State is held by a small stateful demo.
// The selected pill SLIDES between equal-width segments.
// ---------------------------------------------------------------------------

const List<String> _labels = <String>['Day', 'Week', 'Month', 'Year'];

@widgetbook.UseCase(name: 'Playground', type: AppSegmentedButton)
Widget segmentedButtonPlayground(BuildContext context) {
  final count = context.knobs.int
      .slider(label: 'segments', initialValue: 3, min: 2, max: 4)
      .round();
  final size = context.knobs.object.dropdown<AppButtonSize>(
    label: 'size',
    options: AppButtonSize.values,
    initialOption: AppButtonSize.m,
    labelBuilder: (s) => 'AppButtonSize.${s.name}',
  );
  final expanded = context.knobs.boolean(
    label: 'expanded',
    initialValue: false,
  );
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final withIcon = context.knobs.boolean(
    label: 'with icon',
    initialValue: false,
  );
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);

  return wbUseCase(
    context,
    name: 'AppSegmentedButton',
    description:
        'Single-select toggle of 2–4 mutually-exclusive options with a '
        'sliding pill. style/radius follow the global addons unless overridden.',
    child: _SegmentedDemo(
      count: count,
      size: size,
      expanded: expanded,
      enabled: enabled,
      withIcon: withIcon,
      style: style,
      radiusMode: radiusMode,
    ),
  );
}

// Estado sem largura fixa: o segmented calcula a própria largura (pílula de
// segmentos iguais), então um `SizedBox` apertado o cortaria.
Widget _segState(
  BuildContext context, {
  required String name,
  required String when,
  required Widget child,
}) {
  final theme = AppTheme.of(context);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      child,
      const SizedBox(height: AppSpacings.s8),
      AppText(
        name,
        textAlign: TextAlign.center,
        style: theme.textTheme.labelMedium,
      ),
      const SizedBox(height: AppSpacings.s2),
      AppText(
        when,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall.withColor(
          theme.colorTheme.neutralPrimary.s700,
        ),
      ),
    ],
  );
}

@widgetbook.UseCase(name: 'States', type: AppSegmentedButton)
Widget appSegmentedButtonStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSegmentedButton',
  description: 'Segment counts, icons and the disabled state at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      _segState(
        context,
        name: 'Two',
        when: 'Binary choice',
        child: AppSegmentedButton<int>(
          value: 0,
          onChanged: (_) {},
          segments: <AppSegment<int>>[
            for (int i = 0; i < 2; i++)
              AppSegment<int>(value: i, label: _labels[i]),
          ],
        ),
      ),
      _segState(
        context,
        name: 'Three',
        when: 'Few options',
        child: AppSegmentedButton<int>(
          value: 1,
          onChanged: (_) {},
          segments: <AppSegment<int>>[
            for (int i = 0; i < 3; i++)
              AppSegment<int>(value: i, label: _labels[i]),
          ],
        ),
      ),
      _segState(
        context,
        name: 'Icon + label',
        when: 'Reinforce meaning',
        child: AppSegmentedButton<int>(
          value: 0,
          onChanged: (_) {},
          segments: <AppSegment<int>>[
            for (int i = 0; i < 3; i++)
              AppSegment<int>(
                value: i,
                label: _labels[i],
                icon: AppIconToken.calendar,
              ),
          ],
        ),
      ),
      _segState(
        context,
        name: 'Outlined',
        when: 'On a busy surface',
        child: AppSegmentedButton<int>(
          value: 2,
          style: AppStyle.outlined,
          onChanged: (_) {},
          segments: <AppSegment<int>>[
            for (int i = 0; i < 3; i++)
              AppSegment<int>(value: i, label: _labels[i]),
          ],
        ),
      ),
      _segState(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        child: AppSegmentedButton<int>(
          value: 0,
          enabled: false,
          onChanged: (_) {},
          segments: <AppSegment<int>>[
            for (int i = 0; i < 3; i++)
              AppSegment<int>(value: i, label: _labels[i]),
          ],
        ),
      ),
    ],
  ),
);

class _SegmentedDemo extends StatefulWidget {
  const _SegmentedDemo({
    required this.count,
    required this.size,
    required this.expanded,
    required this.enabled,
    required this.withIcon,
    required this.style,
    required this.radiusMode,
  });

  final int count;
  final AppButtonSize size;
  final bool expanded;
  final bool enabled;
  final bool withIcon;
  final AppStyle? style;
  final AppRadiusMode? radiusMode;

  @override
  State<_SegmentedDemo> createState() => _SegmentedDemoState();
}

class _SegmentedDemoState extends State<_SegmentedDemo> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    final int value = _value.clamp(0, widget.count - 1);
    return AppSegmentedButton<int>(
      value: value,
      size: widget.size,
      expanded: widget.expanded,
      enabled: widget.enabled,
      style: widget.style,
      radiusMode: widget.radiusMode,
      onChanged: (v) => setState(() => _value = v),
      segments: <AppSegment<int>>[
        for (int i = 0; i < widget.count; i++)
          AppSegment<int>(
            value: i,
            label: _labels[i],
            icon: widget.withIcon ? AppIconToken.calendar : null,
          ),
      ],
    );
  }
}
