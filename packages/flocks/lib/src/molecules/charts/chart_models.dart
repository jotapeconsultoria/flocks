import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

typedef AppChartValueFormatter = String Function(double value);

enum AppBarChartLayout { grouped, stacked }

enum AppBarChartOrientation { horizontal, vertical }

final class AppBarChartSelection extends Equatable {
  const AppBarChartSelection({
    required this.categoryIndex,
    required this.categoryLabel,
    required this.series,
    required this.seriesIndex,
    required this.value,
  });

  final int categoryIndex;
  final String categoryLabel;
  final AppBarChartSeries series;
  final int seriesIndex;
  final double value;

  @override
  List<Object?> get props => [
    categoryIndex,
    categoryLabel,
    series,
    seriesIndex,
    value,
  ];
}

final class AppBarChartSeries extends Equatable {
  const AppBarChartSeries({
    required this.id,
    required this.label,
    required this.values,
    this.color,
    this.gradient,
  });

  final Color? color;
  final Gradient? gradient;
  final String id;
  final String label;
  final List<double> values;

  @override
  List<Object?> get props => [color, gradient, id, label, values];
}

final class AppBubbleChartNode extends Equatable {
  const AppBubbleChartNode({
    required this.label,
    required this.value,
    this.color,
    this.semanticLabel,
    this.subtitle,
  });

  final Color? color;
  final String label;
  final String? semanticLabel;
  final String? subtitle;
  final double value;

  @override
  List<Object?> get props => [color, label, semanticLabel, subtitle, value];
}

final class AppBubbleChartSelection extends Equatable {
  const AppBubbleChartSelection({required this.index, required this.node});

  final int index;
  final AppBubbleChartNode node;

  @override
  List<Object?> get props => [index, node];
}

final class AppCartesianChartPoint extends Equatable {
  const AppCartesianChartPoint({
    required this.x,
    required this.y,
    this.label,
    this.semanticLabel,
  });

  final String? label;
  final String? semanticLabel;
  final double x;
  final double y;

  @override
  List<Object?> get props => [label, semanticLabel, x, y];
}

final class AppCartesianChartSelection extends Equatable {
  const AppCartesianChartSelection({
    required this.point,
    required this.pointIndex,
    required this.series,
    required this.seriesIndex,
  });

  final AppCartesianChartPoint point;
  final int pointIndex;
  final AppCartesianChartSeries series;
  final int seriesIndex;

  @override
  List<Object?> get props => [point, pointIndex, series, seriesIndex];
}

final class AppCartesianChartSeries extends Equatable {
  const AppCartesianChartSeries({
    required this.id,
    required this.label,
    required this.points,
    this.color,
    this.curveStyle = AppLineChartCurveStyle.straight,
    this.gradient,
    this.isDashed = false,
    this.showPoints = true,
  });

  final Color? color;
  final AppLineChartCurveStyle curveStyle;
  final Gradient? gradient;
  final String id;
  final bool isDashed;
  final String label;
  final List<AppCartesianChartPoint> points;
  final bool showPoints;

  @override
  List<Object?> get props => [
    color,
    curveStyle,
    gradient,
    id,
    isDashed,
    label,
    points,
    showPoints,
  ];
}

final class AppChartLegendItem extends Equatable {
  const AppChartLegendItem({
    required this.color,
    required this.label,
    this.isActive = true,
    this.semanticLabel,
    this.valueLabel,
  });

  final Color color;
  final bool isActive;
  final String label;
  final String? semanticLabel;
  final String? valueLabel;

  @override
  List<Object?> get props => [
    color,
    isActive,
    label,
    semanticLabel,
    valueLabel,
  ];
}

final class AppChartTooltipData extends Equatable {
  const AppChartTooltipData({
    required this.items,
    required this.offset,
    this.label,
  });

  final List<AppChartTooltipItem> items;
  final String? label;
  final Offset offset;

  @override
  List<Object?> get props => [items, label, offset];
}

final class AppChartTooltipItem extends Equatable {
  const AppChartTooltipItem({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  List<Object?> get props => [color, label, value];
}

final class AppGaugeChartSegment extends Equatable {
  const AppGaugeChartSegment({
    required this.label,
    required this.value,
    this.color,
    this.maxValue = 100,
    this.semanticLabel,
  });

  final Color? color;
  final String label;
  final double maxValue;
  final String? semanticLabel;
  final double value;

  @override
  List<Object?> get props => [color, label, maxValue, semanticLabel, value];
}

final class AppGaugeChartSelection extends Equatable {
  const AppGaugeChartSelection({required this.index, required this.segment});

  final int index;
  final AppGaugeChartSegment segment;

  @override
  List<Object?> get props => [index, segment];
}

enum AppGaugeChartVariant { half, radial }

enum AppLineChartCurveStyle { smooth, straight }

final class AppPieChartSegment extends Equatable {
  const AppPieChartSegment({
    required this.label,
    required this.value,
    this.color,
    this.semanticLabel,
  });

  final Color? color;
  final String label;
  final String? semanticLabel;
  final double value;

  @override
  List<Object?> get props => [color, label, semanticLabel, value];
}

final class AppPieChartSelection extends Equatable {
  const AppPieChartSelection({required this.index, required this.segment});

  final int index;
  final AppPieChartSegment segment;

  @override
  List<Object?> get props => [index, segment];
}
