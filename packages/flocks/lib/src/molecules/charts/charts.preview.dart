import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_area_chart.dart';
import 'app_bar_chart.dart';
import 'app_bubble_chart.dart';
import 'app_chart_shell.dart';
import 'app_gauge_chart.dart';
import 'app_line_chart.dart';
import 'chart_models.dart';

// Previews nativos (Regra 5) dos cartesianos e do indicador — claro e escuro.
// O escuro é o que interessa aqui: a moldura pintava `neutralWhite` (branco
// puro nos dois brilhos) e virava um cartão branco no tema escuro.

const List<AppCartesianChartPoint> _points = <AppCartesianChartPoint>[
  AppCartesianChartPoint(x: 0, y: 12),
  AppCartesianChartPoint(x: 1, y: 18),
  AppCartesianChartPoint(x: 2, y: 9),
  AppCartesianChartPoint(x: 3, y: 22),
];

const List<AppCartesianChartSeries> _series = <AppCartesianChartSeries>[
  AppCartesianChartSeries(id: 'consumo', label: 'Consumo', points: _points),
];

const List<AppBarChartSeries> _bars = <AppBarChartSeries>[
  AppBarChartSeries(id: 'a', label: 'Frota A', values: <double>[10, 14, 12]),
  AppBarChartSeries(id: 'b', label: 'Frota B', values: <double>[6, 9, 15]),
];

const List<AppBubbleChartNode> _nodes = <AppBubbleChartNode>[
  AppBubbleChartNode(label: 'Norte', value: 40),
  AppBubbleChartNode(label: 'Sul', value: 25),
  AppBubbleChartNode(label: 'Leste', value: 15),
];

const List<AppGaugeChartSegment> _segments = <AppGaugeChartSegment>[
  AppGaugeChartSegment(label: 'Usado', value: 72),
  AppGaugeChartSegment(label: 'Livre', value: 28),
];

Widget _scene(AppThemeData data, Widget child) => AppTheme(
  data: data,
  child: SizedBox(width: 360, height: 300, child: child),
);

@Preview(name: 'AppLineChart • claro')
Widget appLineChartLightPreview() =>
    _scene(AppThemeData.light, const AppLineChart(series: _series));

@Preview(name: 'AppAreaChart • escuro')
Widget appAreaChartDarkPreview() =>
    _scene(AppThemeData.dark, const AppAreaChart(series: _series));

@Preview(name: 'AppBarChart • claro')
Widget appBarChartLightPreview() => _scene(
  AppThemeData.light,
  AppBarChart(labels: <String>['Jan', 'Fev', 'Mar'], series: _bars),
);

@Preview(name: 'AppBubbleChart • escuro')
Widget appBubbleChartDarkPreview() =>
    _scene(AppThemeData.dark, AppBubbleChart(nodes: _nodes));

@Preview(name: 'AppGaugeChart • claro')
Widget appGaugeChartLightPreview() => _scene(
  AppThemeData.light,
  AppGaugeChart(
    centerLabel: 'Ocupação',
    centerValueLabel: '72%',
    segments: _segments,
  ),
);

@Preview(name: 'AppChartShell • escuro')
Widget appChartShellDarkPreview() => _scene(
  AppThemeData.dark,
  AppChartShell(
    title: 'Consumo por mês',
    subtitle: 'Últimos 3 meses',
    child: AppBarChart(
      labels: const <String>['Jan', 'Fev', 'Mar'],
      series: _bars,
    ),
  ),
);
