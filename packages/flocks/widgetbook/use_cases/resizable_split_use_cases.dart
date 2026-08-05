import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppResizableSplit — dois painéis com divisor arrastável.
// ---------------------------------------------------------------------------

Widget _panel(BuildContext context, String label) => ColoredBox(
  color: AppTheme.of(context).colorTheme.surfaceContainer,
  child: Center(child: AppText(label)),
);

@widgetbook.UseCase(name: 'Playground', type: AppResizableSplit)
Widget resizableSplitPlayground(BuildContext context) {
  final bool vertical = context.knobs.boolean(label: 'vertical');
  final double fraction = context.knobs.double.slider(
    label: 'initialFirstFraction',
    initialValue: 0.35,
    min: 0.15,
    max: 0.85,
  );
  return wbUseCase(
    context,
    name: 'AppResizableSplit',
    description:
        'Two panels with a draggable divider. Drag it, or double-tap to reset. '
        'Persistence is the caller\'s job (onFractionChanged).',
    maxWidth: 560,
    child: SizedBox(
      height: 280,
      child: AppResizableSplit(
        direction: vertical ? Axis.vertical : Axis.horizontal,
        initialFirstFraction: fraction,
        first: _panel(context, 'Lista'),
        second: _panel(context, 'Mapa'),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppResizableSplit)
Widget resizableSplitStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppResizableSplit',
  description: 'Horizontal and vertical orientations.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Horizontal',
        width: 320,
        child: SizedBox(
          height: 200,
          child: AppResizableSplit(
            initialFirstFraction: 0.35,
            first: _panel(context, 'Lista'),
            second: _panel(context, 'Mapa'),
          ),
        ),
      ),
      wbState(
        context,
        name: 'Vertical',
        width: 260,
        child: SizedBox(
          height: 240,
          child: AppResizableSplit(
            direction: Axis.vertical,
            initialFirstFraction: 0.4,
            first: _panel(context, 'Topo'),
            second: _panel(context, 'Base'),
          ),
        ),
      ),
    ],
  ),
);
