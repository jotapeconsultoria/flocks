import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// Cartesian charts + gauge + shell. Hover/tap on the plot IS the interaction,
// so no CTA. None of these has a size of its own: they fill the box they get,
// which is why every case sizes the box explicitly.
// ---------------------------------------------------------------------------

const List<AppCartesianChartPoint> _pointsA = <AppCartesianChartPoint>[
  AppCartesianChartPoint(x: 0, y: 12),
  AppCartesianChartPoint(x: 1, y: 18),
  AppCartesianChartPoint(x: 2, y: 9),
  AppCartesianChartPoint(x: 3, y: 22),
  AppCartesianChartPoint(x: 4, y: 16),
];

const List<AppCartesianChartPoint> _pointsB = <AppCartesianChartPoint>[
  AppCartesianChartPoint(x: 0, y: 6),
  AppCartesianChartPoint(x: 1, y: 11),
  AppCartesianChartPoint(x: 2, y: 15),
  AppCartesianChartPoint(x: 3, y: 8),
  AppCartesianChartPoint(x: 4, y: 20),
];

const AppCartesianChartSeries _seriesA = AppCartesianChartSeries(
  id: 'fleet_a',
  label: 'Fleet A',
  points: _pointsA,
);

const AppCartesianChartSeries _seriesB = AppCartesianChartSeries(
  id: 'fleet_b',
  label: 'Fleet B',
  points: _pointsB,
);

const List<String> _labels = <String>['Jan', 'Feb', 'Mar', 'Apr'];

const List<AppBarChartSeries> _bars = <AppBarChartSeries>[
  AppBarChartSeries(
    id: 'a',
    label: 'Fleet A',
    values: <double>[10, 14, 12, 18],
  ),
  AppBarChartSeries(id: 'b', label: 'Fleet B', values: <double>[6, 9, 15, 11]),
];

const List<AppBubbleChartNode> _nodes = <AppBubbleChartNode>[
  AppBubbleChartNode(label: 'North', value: 40),
  AppBubbleChartNode(label: 'South', value: 25),
  AppBubbleChartNode(label: 'East', value: 15),
  AppBubbleChartNode(label: 'West', value: 8),
];

const List<AppGaugeChartSegment> _gauge = <AppGaugeChartSegment>[
  AppGaugeChartSegment(label: 'Used', value: 72),
  AppGaugeChartSegment(label: 'Free', value: 28),
];

String _percent(double value) => '${value.toStringAsFixed(0)}%';

// ---------------------------------------------------------------------------
// AppLineChart
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppLineChart)
Widget lineChartPlayground(BuildContext context) {
  final bool twoSeries = context.knobs.boolean(
    label: 'series: two',
    initialValue: true,
  );
  final bool showGrid = context.knobs.boolean(
    label: 'showGrid',
    initialValue: true,
  );
  final double minY = context.knobs.double.slider(
    label: 'minY',
    initialValue: 0,
    max: 10,
  );
  final bool clampMax = context.knobs.boolean(label: 'maxY: 30');
  final bool percent = context.knobs.boolean(label: 'valueFormatter: percent');
  final double box = wbSizeKnob(context, label: 'box', initial: AppSizes.s192);

  return wbUseCase(
    context,
    name: 'AppLineChart',
    description:
        'Trend over time. The chart fills the box it is given, so the "box" '
        'knob sizes the box, not the chart.',
    child: SizedBox(
      width: box,
      height: box * 0.7,
      child: AppLineChart(
        maxY: clampMax ? 30 : null,
        minY: minY,
        series: twoSeries
            ? const <AppCartesianChartSeries>[_seriesA, _seriesB]
            : const <AppCartesianChartSeries>[_seriesA],
        showGrid: showGrid,
        valueFormatter: percent ? _percent : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppLineChart)
Widget lineChartStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppLineChart',
  description: 'One series, two series, and the grid turned off.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Single series',
        when: 'One metric over time',
        width: 220,
        child: const SizedBox(
          width: 200,
          height: 140,
          child: AppLineChart(series: <AppCartesianChartSeries>[_seriesA]),
        ),
      ),
      wbState(
        context,
        name: 'Two series',
        when: 'Comparing two fleets',
        width: 220,
        child: const SizedBox(
          width: 200,
          height: 140,
          child: AppLineChart(
            series: <AppCartesianChartSeries>[_seriesA, _seriesB],
          ),
        ),
      ),
      wbState(
        context,
        name: 'No grid',
        when: 'Sparkline-like, inside a dense card',
        width: 220,
        child: const SizedBox(
          width: 200,
          height: 140,
          child: AppLineChart(
            series: <AppCartesianChartSeries>[_seriesA],
            showGrid: false,
          ),
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppAreaChart
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppAreaChart)
Widget areaChartPlayground(BuildContext context) {
  final bool twoSeries = context.knobs.boolean(label: 'series: two');
  final double areaOpacity = context.knobs.double.slider(
    label: 'areaOpacity',
    initialValue: 0.18,
    max: 1,
  );
  final bool showGrid = context.knobs.boolean(
    label: 'showGrid',
    initialValue: true,
  );
  final double minY = context.knobs.double.slider(
    label: 'minY',
    initialValue: 0,
    max: 10,
  );
  final bool clampMax = context.knobs.boolean(label: 'maxY: 30');
  final bool percent = context.knobs.boolean(label: 'valueFormatter: percent');
  final double box = wbSizeKnob(context, label: 'box', initial: AppSizes.s192);

  return wbUseCase(
    context,
    name: 'AppAreaChart',
    description:
        'Accumulated volume plus trend. Raise areaOpacity to see why two '
        'stacked areas stop being readable.',
    child: SizedBox(
      width: box,
      height: box * 0.7,
      child: AppAreaChart(
        areaOpacity: areaOpacity,
        maxY: clampMax ? 30 : null,
        minY: minY,
        series: twoSeries
            ? const <AppCartesianChartSeries>[_seriesA, _seriesB]
            : const <AppCartesianChartSeries>[_seriesA],
        showGrid: showGrid,
        valueFormatter: percent ? _percent : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppAreaChart)
Widget areaChartStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppAreaChart',
  description: 'The fill from subtle to solid, and two series overlapping.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Subtle fill',
        when: 'Default (0.18)',
        width: 220,
        child: const SizedBox(
          width: 200,
          height: 140,
          child: AppAreaChart(series: <AppCartesianChartSeries>[_seriesA]),
        ),
      ),
      wbState(
        context,
        name: 'Solid fill',
        when: 'Single series, no overlap to worry about',
        width: 220,
        child: const SizedBox(
          width: 200,
          height: 140,
          child: AppAreaChart(
            areaOpacity: 0.8,
            series: <AppCartesianChartSeries>[_seriesA],
          ),
        ),
      ),
      wbState(
        context,
        name: 'Two series',
        when: 'Overlapping fills — prefer AppLineChart',
        width: 220,
        child: const SizedBox(
          width: 200,
          height: 140,
          child: AppAreaChart(
            series: <AppCartesianChartSeries>[_seriesA, _seriesB],
          ),
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppBarChart
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppBarChart)
Widget barChartPlayground(BuildContext context) {
  final AppBarChartLayout layout = context.knobs.object.dropdown(
    label: 'layout',
    options: AppBarChartLayout.values,
    initialOption: AppBarChartLayout.grouped,
  );
  final AppBarChartOrientation orientation = context.knobs.object.dropdown(
    label: 'orientation',
    options: AppBarChartOrientation.values,
    initialOption: AppBarChartOrientation.vertical,
  );
  final bool twoSeries = context.knobs.boolean(
    label: 'series: two',
    initialValue: true,
  );
  final bool showGrid = context.knobs.boolean(
    label: 'showGrid',
    initialValue: true,
  );
  final bool enableInternalScroll = context.knobs.boolean(
    label: 'enableInternalScroll',
    initialValue: true,
  );
  final bool thickBars = context.knobs.boolean(label: 'barThickness: 24');
  final bool wideGap = context.knobs.boolean(label: 'categorySpacing: 40');
  final bool clampMax = context.knobs.boolean(label: 'maxValue: 30');
  final bool percent = context.knobs.boolean(label: 'valueFormatter: percent');
  final double box = wbSizeKnob(context, label: 'box', initial: AppSizes.s192);

  return wbUseCase(
    context,
    name: 'AppBarChart',
    description:
        'Comparison over a shared baseline. Switch layout to stacked to see '
        'the joints go square and only the outer end keep the corner.',
    child: SizedBox(
      width: box,
      height: box * 0.7,
      child: AppBarChart(
        barThickness: thickBars ? 24 : null,
        categorySpacing: wideGap ? 40 : null,
        enableInternalScroll: enableInternalScroll,
        labels: _labels,
        layout: layout,
        maxValue: clampMax ? 30 : null,
        orientation: orientation,
        series: twoSeries
            ? _bars
            : const <AppBarChartSeries>[
                AppBarChartSeries(
                  id: 'a',
                  label: 'Fleet A',
                  values: <double>[10, 14, 12, 18],
                ),
              ],
        showGrid: showGrid,
        valueFormatter: percent ? _percent : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppBarChart)
Widget barChartStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppBarChart',
  description: 'Grouped, stacked and horizontal — the three real layouts.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Grouped',
        when: 'Comparing series inside each category',
        width: 220,
        child: SizedBox(
          width: 200,
          height: 140,
          child: AppBarChart(labels: _labels, series: _bars),
        ),
      ),
      wbState(
        context,
        name: 'Stacked',
        when: 'Composition inside each category',
        width: 220,
        child: SizedBox(
          width: 200,
          height: 140,
          child: AppBarChart(
            labels: _labels,
            layout: AppBarChartLayout.stacked,
            series: _bars,
          ),
        ),
      ),
      wbState(
        context,
        name: 'Horizontal',
        when: 'Long category labels',
        width: 220,
        child: SizedBox(
          width: 200,
          height: 140,
          child: AppBarChart(
            labels: _labels,
            orientation: AppBarChartOrientation.horizontal,
            series: _bars,
          ),
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppBubbleChart
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppBubbleChart)
Widget bubbleChartPlayground(BuildContext context) {
  final int nodes = context.knobs.int.slider(
    label: 'nodes',
    initialValue: 4,
    min: 1,
    max: 4,
    divisions: 3,
  );
  final bool percent = context.knobs.boolean(label: 'valueFormatter: percent');
  final double box = wbSizeKnob(context, label: 'box', initial: AppSizes.s192);

  return wbUseCase(
    context,
    name: 'AppBubbleChart',
    description:
        'Order of magnitude, not precise comparison — area is hard to read by '
        'eye. Hover a bubble for the tooltip.',
    child: SizedBox(
      width: box,
      height: box * 0.7,
      child: AppBubbleChart(
        nodes: _nodes.take(nodes).toList(growable: false),
        valueFormatter: percent ? _percent : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppBubbleChart)
Widget bubbleChartStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppBubbleChart',
  description: 'From a single bubble to a four-way spread.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Single',
        when: 'One category',
        width: 220,
        child: SizedBox(
          width: 200,
          height: 140,
          child: AppBubbleChart(nodes: _nodes.take(1).toList()),
        ),
      ),
      wbState(
        context,
        name: 'Two',
        when: 'Binary split',
        width: 220,
        child: SizedBox(
          width: 200,
          height: 140,
          child: AppBubbleChart(nodes: _nodes.take(2).toList()),
        ),
      ),
      wbState(
        context,
        name: 'Four',
        when: 'Full spread',
        width: 220,
        child: SizedBox(
          width: 200,
          height: 140,
          child: AppBubbleChart(nodes: _nodes),
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppGaugeChart
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppGaugeChart)
Widget gaugeChartPlayground(BuildContext context) {
  final AppGaugeChartVariant variant = context.knobs.object.dropdown(
    label: 'variant',
    options: AppGaugeChartVariant.values,
    initialOption: AppGaugeChartVariant.half,
  );
  final bool showCenter = context.knobs.boolean(
    label: 'centerLabel / centerValueLabel',
    initialValue: true,
  );
  final bool percent = context.knobs.boolean(label: 'valueFormatter: percent');
  final double box = wbSizeKnob(context, label: 'box', initial: AppSizes.s192);

  return wbUseCase(
    context,
    name: 'AppGaugeChart',
    description:
        'One indicator against a scale. The center label carries the number '
        'that matters — the arc only gives it context.',
    child: SizedBox(
      width: box,
      height: box,
      child: AppGaugeChart(
        centerLabel: showCenter ? 'Occupancy' : null,
        centerValueLabel: showCenter ? '72%' : null,
        segments: _gauge,
        valueFormatter: percent ? _percent : null,
        variant: variant,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppGaugeChart)
Widget gaugeChartStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppGaugeChart',
  description: 'Half arc and full radial, with and without the center label.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Half',
        when: 'Default — reads as a dial',
        width: 200,
        child: SizedBox(
          width: 160,
          height: 160,
          child: AppGaugeChart(
            centerLabel: 'Occupancy',
            centerValueLabel: '72%',
            segments: _gauge,
          ),
        ),
      ),
      wbState(
        context,
        name: 'Radial',
        when: 'Full circle',
        width: 200,
        child: SizedBox(
          width: 160,
          height: 160,
          child: AppGaugeChart(
            centerLabel: 'Occupancy',
            centerValueLabel: '72%',
            segments: _gauge,
            variant: AppGaugeChartVariant.radial,
          ),
        ),
      ),
      wbState(
        context,
        name: 'No center label',
        when: 'The number lives outside the chart',
        width: 200,
        child: SizedBox(
          width: 160,
          height: 160,
          child: AppGaugeChart(segments: _gauge),
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppChartShell
// ---------------------------------------------------------------------------

List<AppChartLegendItem> _legend(BuildContext context) {
  final List<Color> palette = AppTheme.of(context).colorTheme.chartCategorical;
  return <AppChartLegendItem>[
    AppChartLegendItem(color: palette.first, label: 'Fleet A'),
    AppChartLegendItem(color: palette[1], label: 'Fleet B'),
  ];
}

@widgetbook.UseCase(name: 'Playground', type: AppChartShell)
Widget chartShellPlayground(BuildContext context) {
  final AppStyle style = context.knobs.object.dropdown(
    label: 'style',
    options: AppStyle.values,
    initialOption: AppStyle.filled,
  );
  final bool showTitle = context.knobs.boolean(
    label: 'title / subtitle',
    initialValue: true,
  );
  final bool showSummary = context.knobs.boolean(label: 'summary');
  final bool showLegend = context.knobs.boolean(
    label: 'legendItems',
    initialValue: true,
  );
  final bool tappableLegend = context.knobs.boolean(
    label: 'onLegendTap',
    initialValue: true,
  );
  final bool isLoading = context.knobs.boolean(label: 'isLoading');
  final bool isEmpty = context.knobs.boolean(label: 'isEmpty');
  final bool expandChart = context.knobs.boolean(label: 'expandChart');
  final double box = wbSizeKnob(context, label: 'box', initial: AppSizes.s192);

  return wbUseCase(
    context,
    name: 'AppChartShell',
    description:
        'The chrome around a chart. It is a content card: the style knob is '
        'the global AppStyle axis, same as AppCard.',
    maxWidth: 560,
    child: SizedBox(
      width: box,
      child: AppChartShell(
        chartConstraints: const BoxConstraints.tightFor(height: 160),
        expandChart: expandChart,
        isEmpty: isEmpty,
        isLoading: isLoading,
        legendItems: showLegend
            ? _legend(context)
            : const <AppChartLegendItem>[],
        onLegendTap: tappableLegend ? (AppChartLegendItem _) {} : null,
        style: style,
        subtitle: showTitle ? 'Last 4 months' : null,
        summary: showSummary ? const AppText('+12%') : null,
        title: showTitle ? 'Consumption' : null,
        child: AppBarChart(labels: _labels, series: _bars),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppChartShell)
Widget chartShellStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppChartShell',
  description: 'Data, loading and empty — the three states a chart card has.',
  maxWidth: 900,
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'With data',
        when: 'The normal case',
        width: 260,
        child: SizedBox(
          width: 240,
          child: AppChartShell(
            chartConstraints: const BoxConstraints.tightFor(height: 120),
            legendItems: _legend(context),
            title: 'Consumption',
            child: AppBarChart(labels: _labels, series: _bars),
          ),
        ),
      ),
      wbState(
        context,
        name: 'Loading',
        when: 'Fetching — the plot area is veiled, the chrome stays',
        width: 260,
        child: SizedBox(
          width: 240,
          child: AppChartShell(
            chartConstraints: const BoxConstraints.tightFor(height: 120),
            isLoading: true,
            title: 'Consumption',
            child: AppBarChart(labels: _labels, series: _bars),
          ),
        ),
      ),
      wbState(
        context,
        name: 'Empty',
        when: 'Query returned nothing',
        width: 260,
        child: SizedBox(
          width: 240,
          child: AppChartShell(
            chartConstraints: const BoxConstraints.tightFor(height: 120),
            isEmpty: true,
            title: 'Consumption',
            child: AppBarChart(labels: _labels, series: _bars),
          ),
        ),
      ),
    ],
  ),
);
