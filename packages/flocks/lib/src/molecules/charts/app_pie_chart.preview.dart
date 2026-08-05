import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_pie_chart.dart';
import 'chart_models.dart';

// Previews nativos (Regra 5) — claro e escuro.

const List<AppPieChartSegment> _segments = <AppPieChartSegment>[
  AppPieChartSegment(label: 'A', value: 30),
  AppPieChartSegment(label: 'B', value: 45),
  AppPieChartSegment(label: 'C', value: 25),
];

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const SizedBox(
    width: 200,
    height: 200,
    child: AppPieChart(segments: _segments),
  ),
);

@Preview(name: 'AppPieChart • claro')
Widget appPieChartLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppPieChart • escuro')
Widget appPieChartDarkPreview() => _sample(AppThemeData.dark);
