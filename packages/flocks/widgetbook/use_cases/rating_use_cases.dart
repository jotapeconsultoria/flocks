import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppRating — Playground (all knobs). Tapping a star IS the interaction, so
// there is NO CTA. State is held by a small stateful demo.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppRating)
Widget ratingPlayground(BuildContext context) {
  final count = context.knobs.int
      .slider(label: 'count', initialValue: 5, min: 1, max: 10)
      .round();
  final allowHalf = context.knobs.boolean(
    label: 'allowHalf',
    initialValue: true,
  );
  final iconSize = wbSizeKnob(context, label: 'iconSize', initial: 32);
  final color = wbSemanticColorKnob(context, initial: WbColorOption.warning);
  final readOnly = context.knobs.boolean(
    label: 'read-only',
    initialValue: false,
  );

  return wbUseCase(
    context,
    name: 'AppRating',
    description:
        'Painted star rating — display and input, optional half steps.',
    child: _RatingDemo(
      count: count,
      allowHalf: allowHalf,
      iconSize: iconSize,
      color: color,
      readOnly: readOnly,
    ),
  );
}

class _RatingDemo extends StatefulWidget {
  const _RatingDemo({
    required this.count,
    required this.allowHalf,
    required this.iconSize,
    required this.color,
    required this.readOnly,
  });

  final int count;
  final bool allowHalf;
  final double iconSize;
  final Color? color;
  final bool readOnly;

  @override
  State<_RatingDemo> createState() => _RatingDemoState();
}

class _RatingDemoState extends State<_RatingDemo> {
  double _value = 3;

  @override
  Widget build(BuildContext context) {
    final double value = _value.clamp(0, widget.count.toDouble());
    return AppRating(
      value: value,
      count: widget.count,
      allowHalf: widget.allowHalf,
      iconSize: widget.iconSize,
      color: widget.color,
      onChanged: widget.readOnly ? null : (v) => setState(() => _value = v),
    );
  }
}

@widgetbook.UseCase(name: 'States', type: AppRating)
Widget ratingStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppRating',
  description: 'Empty, half, full and read-only at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Empty',
        when: 'No rating yet',
        width: 200,
        child: AppRating(value: 0, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'Half',
        when: 'Fractional value',
        width: 200,
        child: AppRating(value: 2.5, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'Full',
        when: 'Max value',
        width: 200,
        child: AppRating(value: 5, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'Read-only',
        when: 'Display only',
        width: 200,
        child: const AppRating(value: 4),
      ),
    ],
  ),
);
