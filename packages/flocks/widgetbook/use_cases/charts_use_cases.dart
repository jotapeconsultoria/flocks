import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// charts — Playgrounds. Hover/tap on the chart IS the interaction, no CTA.
// ---------------------------------------------------------------------------

const List<AppPieChartSegment> _segments = <AppPieChartSegment>[
  AppPieChartSegment(label: 'Ativos', value: 42),
  AppPieChartSegment(label: 'Ociosos', value: 28),
  AppPieChartSegment(label: 'Manutenção', value: 18),
  AppPieChartSegment(label: 'Offline', value: 12),
];

const List<AppPieChartSegment> _twoSegments = <AppPieChartSegment>[
  AppPieChartSegment(label: 'Online', value: 68),
  AppPieChartSegment(label: 'Offline', value: 32),
];

const List<AppPieChartSegment> _singleSegment = <AppPieChartSegment>[
  AppPieChartSegment(label: 'Ativos', value: 100),
];

@widgetbook.UseCase(name: 'Playground', type: AppPieChart)
Widget pieChartPlayground(BuildContext context) {
  final int segments = context.knobs.int.slider(
    label: 'segments',
    initialValue: 4,
    min: 1,
    max: 4,
    divisions: 3,
  );
  final bool percent = context.knobs.boolean(
    label: 'valueFormatter: percent',
    initialValue: false,
  );
  // Não é uma prop do gráfico: ele preenche a caixa que recebe. O knob dimensiona
  // a CAIXA, para dar para ver o comportamento em espaço apertado.
  final double box = wbSizeKnob(context, label: 'box', initial: AppSizes.s192);

  return wbUseCase(
    context,
    name: 'AppPieChart',
    description:
        'Pie chart; hover a slice for the tooltip. The chart has no size of '
        'its own — it fills the box it is given, so the "box" knob sizes the '
        'container, not the component.',
    child: SizedBox(
      width: box,
      height: box,
      child: AppPieChart(
        segments: _segments.take(segments).toList(),
        valueFormatter: percent ? (double v) => '${v.round()}%' : null,
        onSelectionChanged: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppDonutChart)
Widget donutChartPlayground(BuildContext context) {
  final int segments = context.knobs.int.slider(
    label: 'segments',
    initialValue: 4,
    min: 1,
    max: 4,
    divisions: 3,
  );
  final bool percent = context.knobs.boolean(
    label: 'valueFormatter: percent',
    initialValue: false,
  );
  final double box = wbSizeKnob(context, label: 'box', initial: AppSizes.s192);

  return wbUseCase(
    context,
    name: 'AppDonutChart',
    description:
        'Donut chart; hover a slice for the tooltip. Like the pie, it fills '
        'the box it is given — the "box" knob sizes the container.',
    child: SizedBox(
      width: box,
      height: box,
      child: AppDonutChart(
        segments: _segments.take(segments).toList(),
        valueFormatter: percent ? (double v) => '${v.round()}%' : null,
        onSelectionChanged: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppPieChart)
Widget pieChartStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppPieChart',
  description: 'From a single slice to a multi-segment distribution.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Single',
        when: 'One value (100%)',
        width: 180,
        child: const SizedBox(
          width: 160,
          height: 160,
          child: AppPieChart(segments: _singleSegment),
        ),
      ),
      wbState(
        context,
        name: 'Two slices',
        when: 'Binary split',
        width: 180,
        child: const SizedBox(
          width: 160,
          height: 160,
          child: AppPieChart(segments: _twoSegments),
        ),
      ),
      wbState(
        context,
        name: 'Multi-slice',
        when: 'Full distribution',
        width: 180,
        child: const SizedBox(
          width: 160,
          height: 160,
          child: AppPieChart(segments: _segments),
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppDonutChart)
Widget donutChartStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDonutChart',
  description: 'From a single slice to a multi-segment distribution.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Single',
        when: 'One value (100%)',
        width: 180,
        child: const SizedBox(
          width: 160,
          height: 160,
          child: AppDonutChart(segments: _singleSegment),
        ),
      ),
      wbState(
        context,
        name: 'Two slices',
        when: 'Binary split',
        width: 180,
        child: const SizedBox(
          width: 160,
          height: 160,
          child: AppDonutChart(segments: _twoSegments),
        ),
      ),
      wbState(
        context,
        name: 'Multi-slice',
        when: 'Full distribution',
        width: 180,
        child: const SizedBox(
          width: 160,
          height: 160,
          child: AppDonutChart(segments: _segments),
        ),
      ),
    ],
  ),
);
