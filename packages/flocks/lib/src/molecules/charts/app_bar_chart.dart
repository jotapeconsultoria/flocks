import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'chart_foundation.dart';
import 'chart_models.dart';
import 'chart_tooltip.dart';

/// Gráfico de **barras**, vertical ou horizontal, agrupado ou empilhado.
///
/// É o gráfico de COMPARAÇÃO: valores lado a lado sobre uma linha de base
/// comum, que é o que o olho compara com precisão. Para composição de um todo,
/// prefira `AppPieChart`/`AppDonutChart`; para tendência, `AppLineChart`.
///
/// Empilhado, a junta entre segmentos fica reta e só a ponta de fora arredonda
/// — o canto sai do eixo de forma da marca.
///
/// ```dart
/// AppBarChart(
///   labels: <String>['Jan', 'Fev'],
///   series: <AppBarChartSeries>[
///     AppBarChartSeries(id: 'a', label: 'Frota A', values: <double>[10, 14]),
///   ],
/// )
/// ```
final class AppBarChart extends StatefulWidget {
  const AppBarChart({
    required this.labels,
    required this.series,
    this.barThickness,
    this.categorySpacing,
    this.enableInternalScroll = true,
    this.layout = AppBarChartLayout.grouped,
    this.maxValue,
    this.onSelectionChanged,
    this.orientation = AppBarChartOrientation.vertical,
    this.showGrid = true,
    this.valueFormatter,
    super.key,
  }) : assert(labels.length > 0, 'labels must not be empty'),
       assert(
         barThickness == null || barThickness > 0,
         'barThickness must be greater than zero',
       ),
       assert(
         categorySpacing == null || categorySpacing >= 0,
         'categorySpacing must be zero or greater',
       ),
       assert(series.length > 0, 'series must not be empty');

  final double? barThickness;
  final double? categorySpacing;
  final bool enableInternalScroll;
  final AppBarChartLayout layout;
  final List<String> labels;
  final double? maxValue;
  final void Function(AppBarChartSelection selection)? onSelectionChanged;
  final AppBarChartOrientation orientation;
  final List<AppBarChartSeries> series;
  final bool showGrid;
  final AppChartValueFormatter? valueFormatter;

  @override
  State<AppBarChart> createState() => _AppBarChartState();
}

class _AppBarChartState extends State<AppBarChart> {
  AppBarChartSelection? _selection;
  AppChartTooltipData? _tooltipData;

  void _clearSelection() {
    if (_selection == null && _tooltipData == null) {
      return;
    }

    setState(() {
      _selection = null;
      _tooltipData = null;
    });
  }

  void _handleSelection(_AppBarChartGeometry geometry, Offset position) {
    final selection = geometry.nearestSelection(position);

    if (selection == null) {
      _clearSelection();
      return;
    }

    final tooltipData = geometry.tooltipData(selection, widget.valueFormatter);

    setState(() {
      _selection = selection;
      _tooltipData = tooltipData;
    });

    widget.onSelectionChanged?.call(selection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportSize = Size(
          constraints.hasBoundedWidth ? constraints.maxWidth : 320,
          constraints.hasBoundedHeight ? constraints.maxHeight : 180,
        );
        final contentSize = _AppBarChartGeometry.contentSize(
          barThickness: widget.barThickness,
          categorySpacing: widget.categorySpacing,
          labels: widget.labels,
          layout: widget.layout,
          orientation: widget.orientation,
          series: widget.series,
          viewportSize: viewportSize,
        );
        final geometry = _AppBarChartGeometry.fromData(
          barThickness: widget.barThickness,
          categorySpacing: widget.categorySpacing,
          labels: widget.labels,
          layout: widget.layout,
          maxValue: widget.maxValue,
          orientation: widget.orientation,
          series: widget.series,
          size: contentSize,
          theme: theme,
        );
        final shouldScrollHorizontally =
            widget.enableInternalScroll &&
            widget.orientation == AppBarChartOrientation.vertical &&
            contentSize.width > viewportSize.width;
        final shouldScrollVertically =
            widget.enableInternalScroll &&
            widget.orientation == AppBarChartOrientation.horizontal &&
            contentSize.height > viewportSize.height;
        final shouldUseFixedAxisLabels =
            shouldScrollHorizontally || shouldScrollVertically;
        final chartContent = SizedBox(
          height: contentSize.height,
          width: contentSize.width,
          child: MouseRegion(
            onExit: (_) => _clearSelection(),
            onHover: (event) => _handleSelection(geometry, event.localPosition),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (event) =>
                  _handleSelection(geometry, event.localPosition),
              child: Semantics(
                label: geometry.semanticLabel,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _AppBarChartPainter(
                          geometry: geometry,
                          selectedCategoryIndex: _selection?.categoryIndex,
                        ),
                      ),
                    ),
                    ...geometry.categoryLabels,
                    if (!shouldUseFixedAxisLabels) ...geometry.valueLabels,
                    if (_tooltipData != null)
                      Positioned(
                        left: geometry.tooltipLeft(_tooltipData!),
                        top: geometry.tooltipTop(_tooltipData!),
                        child: IgnorePointer(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: ChartTooltip(data: _tooltipData!),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
        final chartWithScroll = shouldScrollHorizontally
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: chartContent,
              )
            : shouldScrollVertically
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: chartContent,
              )
            : chartContent;

        if (!shouldUseFixedAxisLabels) {
          return chartWithScroll;
        }

        final fixedAxisInsets =
            widget.orientation == AppBarChartOrientation.horizontal
            ? const EdgeInsets.only(bottom: 28)
            : EdgeInsets.zero;

        return SizedBox(
          height: viewportSize.height,
          width: viewportSize.width,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: fixedAxisInsets,
                  child: ClipRect(child: chartWithScroll),
                ),
              ),
              ...geometry.valueLabels,
            ],
          ),
        );
      },
    );
  }
}

final class _AppBarChartGeometry {
  const _AppBarChartGeometry({
    required this.barRects,
    required this.labels,
    required this.layout,
    required this.orientation,
    required this.plotRect,
    required this.semanticLabel,
    required this.series,
    required this.size,
    required this.theme,
    required this.tickValues,
  });

  final List<_AppBarRect> barRects;
  final List<String> labels;
  final AppBarChartLayout layout;
  final AppBarChartOrientation orientation;
  final Rect plotRect;
  final String semanticLabel;
  final List<AppBarChartSeries> series;
  final Size size;
  final AppThemeData theme;
  final List<double> tickValues;

  static _AppBarChartGeometry fromData({
    required double? barThickness,
    required double? categorySpacing,
    required List<String> labels,
    required AppBarChartLayout layout,
    required double? maxValue,
    required AppBarChartOrientation orientation,
    required List<AppBarChartSeries> series,
    required Size size,
    required AppThemeData theme,
  }) {
    final height = math.max(size.height, 180.0);
    final width = math.max(size.width, 180.0);
    final plotRect = orientation == AppBarChartOrientation.vertical
        ? Rect.fromLTWH(
            44,
            12,
            math.max(width - 56, 1),
            math.max(height - 44, 1),
          )
        : Rect.fromLTWH(
            64,
            barThickness == null ? 12 : AppSpacings.s4,
            math.max(width - 76, 1),
            math.max(height - (barThickness == null ? 24 : AppSpacings.s8), 1),
          );
    final inferredMaxValue = _resolvedMaxValue(labels, layout, series);
    final resolvedMaxValue = maxValue == null
        ? inferredMaxValue
        : math.max(maxValue, inferredMaxValue);
    final normalizedMaxValue = math.max(resolvedMaxValue, 1.0);
    final barRects = _buildRects(
      // O canto da barra sai do eixo de forma da marca: era a const
      // `AppRadius.l` fixa. Com a marca em `reto` a barra fica de topo reto.
      barRadius: Radius.circular(theme.radiusTheme.resolveRadius()),
      barThickness: barThickness,
      categorySpacing: categorySpacing,
      labels: labels,
      layout: layout,
      maxValue: normalizedMaxValue,
      orientation: orientation,
      plotRect: plotRect,
      series: series,
    );
    const tickCount = 5;
    final tickValues = List<double>.generate(
      tickCount,
      (index) => (normalizedMaxValue / (tickCount - 1)) * index,
    );
    final semanticLabel = ChartFoundation.describeValues(
      series.expand(
        (item) => item.values.asMap().entries.map(
          (entry) => '${item.label} ${labels[entry.key]}: ${entry.value}',
        ),
      ),
    );

    return _AppBarChartGeometry(
      barRects: barRects,
      labels: labels,
      layout: layout,
      orientation: orientation,
      plotRect: plotRect,
      semanticLabel: semanticLabel,
      series: series,
      size: Size(width, height),
      theme: theme,
      tickValues: tickValues,
    );
  }

  static Size contentSize({
    required double? barThickness,
    required double? categorySpacing,
    required List<String> labels,
    required AppBarChartLayout layout,
    required AppBarChartOrientation orientation,
    required List<AppBarChartSeries> series,
    required Size viewportSize,
  }) {
    final hasFixedDistribution =
        barThickness != null || categorySpacing != null;
    final minHeight = math.max(viewportSize.height, 180.0);
    final minWidth = math.max(viewportSize.width, 180.0);

    if (!hasFixedDistribution) {
      return Size(minWidth, minHeight);
    }

    final groupedSpacing = barThickness == null
        ? AppSpacings.s4
        : AppSpacings.s2;
    final resolvedBarExtent = barThickness ?? AppSizes.s32;
    final resolvedCategorySpacing = categorySpacing ?? AppSpacings.s8;
    final seriesCount = series.length;
    final groupExtent = layout == AppBarChartLayout.grouped
        ? (resolvedBarExtent * seriesCount) +
              (groupedSpacing * math.max(seriesCount - 1, 0))
        : resolvedBarExtent;
    final leadingInset = orientation == AppBarChartOrientation.vertical
        ? 44.0
        : 64.0;
    const trailingInset = 12.0;
    final topInset = orientation == AppBarChartOrientation.vertical
        ? 12.0
        : (barThickness == null ? 12.0 : AppSpacings.s4);
    final bottomInset = orientation == AppBarChartOrientation.vertical
        ? 32.0
        : (barThickness == null ? 12.0 : AppSpacings.s4);

    if (orientation == AppBarChartOrientation.vertical) {
      final plotWidth =
          (groupExtent * labels.length) +
          (resolvedCategorySpacing * math.max(labels.length + 1, 1));
      return Size(
        math.max(minWidth, leadingInset + plotWidth + trailingInset),
        minHeight,
      );
    }

    final plotHeight =
        (groupExtent * labels.length) +
        (resolvedCategorySpacing * math.max(labels.length + 1, 1));
    return Size(
      minWidth,
      math.max(minHeight, topInset + plotHeight + bottomInset),
    );
  }

  List<Widget> get categoryLabels {
    if (orientation == AppBarChartOrientation.vertical) {
      return labels
          .asMap()
          .entries
          .map((entry) {
            final groupRects = barRects
                .where((rect) => rect.categoryIndex == entry.key)
                .toList();
            final center = groupRects
                .map((item) => item.rect.center.dx)
                .reduce((left, right) => (left + right) / 2);

            return Positioned(
              bottom: 0,
              left: center - 24,
              width: 48,
              child: IgnorePointer(
                child: AppText(
                  entry.value.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium.withColor(
                    theme.colorTheme.neutralPrimary.s500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          })
          .toList(growable: false);
    }

    return labels
        .asMap()
        .entries
        .map((entry) {
          final groupRects = barRects
              .where((rect) => rect.categoryIndex == entry.key)
              .toList();
          final center = groupRects
              .map((item) => item.rect.center.dy)
              .reduce((left, right) => (left + right) / 2);

          return Positioned(
            left: 0,
            top: center - 8,
            width: 56,
            child: IgnorePointer(
              child: AppText(
                entry.value.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium.withColor(
                  theme.colorTheme.neutralPrimary.s500,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          );
        })
        .toList(growable: false);
  }

  AppBarChartSelection? nearestSelection(Offset position) {
    _AppBarRect? nearestBarRect;
    var minDistance = double.infinity;

    for (final barRect in barRects) {
      if (barRect.rect.inflate(AppSpacings.s4).contains(position)) {
        return AppBarChartSelection(
          categoryIndex: barRect.categoryIndex,
          categoryLabel: labels[barRect.categoryIndex],
          series: series[barRect.seriesIndex],
          seriesIndex: barRect.seriesIndex,
          value: series[barRect.seriesIndex].values[barRect.categoryIndex],
        );
      }

      final distance = (barRect.rect.center - position).distanceSquared;

      if (distance < minDistance) {
        minDistance = distance;
        nearestBarRect = barRect;
      }
    }

    if (nearestBarRect != null) {
      return AppBarChartSelection(
        categoryIndex: nearestBarRect.categoryIndex,
        categoryLabel: labels[nearestBarRect.categoryIndex],
        series: series[nearestBarRect.seriesIndex],
        seriesIndex: nearestBarRect.seriesIndex,
        value: series[nearestBarRect.seriesIndex]
            .values[nearestBarRect.categoryIndex],
      );
    }

    return null;
  }

  AppChartTooltipData tooltipData(
    AppBarChartSelection selection,
    AppChartValueFormatter? valueFormatter,
  ) {
    final items = List<AppChartTooltipItem>.generate(series.length, (index) {
      final value = series[index].values[selection.categoryIndex];
      return AppChartTooltipItem(
        color: ChartFoundation.resolveColor(
          theme,
          index,
          color: series[index].color,
        ),
        label: series[index].label,
        value: valueFormatter?.call(value) ?? ChartFoundation.valueLabel(value),
      );
    });
    final anchor = barRects
        .where((item) => item.categoryIndex == selection.categoryIndex)
        .map((item) => item.anchor)
        .reduce(
          (left, right) =>
              Offset((left.dx + right.dx) / 2, math.min(left.dy, right.dy)),
        );

    return AppChartTooltipData(
      items: items,
      label: selection.categoryLabel,
      offset: anchor,
    );
  }

  double tooltipLeft(AppChartTooltipData tooltipData) {
    return (tooltipData.offset.dx - 72).clamp(8, math.max(size.width - 152, 8));
  }

  double tooltipTop(AppChartTooltipData tooltipData) {
    final preferred = tooltipData.offset.dy - 72;

    if (preferred >= 8) {
      return preferred;
    }

    return (tooltipData.offset.dy + 12).clamp(8, math.max(size.height - 72, 8));
  }

  List<Widget> get valueLabels {
    if (orientation == AppBarChartOrientation.vertical) {
      return List<Widget>.generate(tickValues.length, (index) {
        final ratio = index / (math.max(tickValues.length - 1, 1));
        final dy = plotRect.bottom - (plotRect.height * ratio) - 8;

        return Positioned(
          left: 0,
          top: dy,
          width: 36,
          child: IgnorePointer(
            child: AppText(
              ChartFoundation.valueLabel(tickValues[index]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium.withColor(
                theme.colorTheme.neutralPrimary.s500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        );
      });
    }

    return List<Widget>.generate(tickValues.length, (index) {
      final ratio = index / (math.max(tickValues.length - 1, 1));
      final dx = plotRect.left + (plotRect.width * ratio) - 24;

      return Positioned(
        bottom: 0,
        left: dx,
        width: 48,
        child: IgnorePointer(
          child: AppText(
            ChartFoundation.valueLabel(tickValues[index]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium.withColor(
              theme.colorTheme.neutralPrimary.s500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }

  static List<_AppBarRect> _buildRects({
    required Radius barRadius,
    required double? barThickness,
    required double? categorySpacing,
    required List<String> labels,
    required AppBarChartLayout layout,
    required double maxValue,
    required AppBarChartOrientation orientation,
    required Rect plotRect,
    required List<AppBarChartSeries> series,
  }) {
    final rects = <_AppBarRect>[];
    final groupCount = labels.length;
    final hasFixedDistribution =
        barThickness != null || categorySpacing != null;
    final groupedSpacing = barThickness == null
        ? AppSpacings.s4
        : AppSpacings.s2;
    final resolvedCategorySpacing = categorySpacing ?? AppSpacings.s8;
    final resolvedFixedBarExtent = _resolvedThickness(
      availableThickness: double.infinity,
      barThickness: barThickness ?? AppSizes.s32,
    );

    if (orientation == AppBarChartOrientation.vertical) {
      final groupWidth = hasFixedDistribution
          ? (layout == AppBarChartLayout.grouped
                ? (resolvedFixedBarExtent * series.length) +
                      (groupedSpacing * math.max(series.length - 1, 0))
                : resolvedFixedBarExtent)
          : plotRect.width / groupCount;
      final bandFactor = hasFixedDistribution ? 1.0 : 0.7;

      for (var categoryIndex = 0; categoryIndex < groupCount; categoryIndex++) {
        final bandLeft = hasFixedDistribution
            ? plotRect.left +
                  resolvedCategorySpacing +
                  (categoryIndex * (groupWidth + resolvedCategorySpacing))
            : plotRect.left + (groupWidth * categoryIndex);
        final bandWidth = groupWidth * bandFactor;
        final lastVisibleSeriesIndex = _lastVisibleSeriesIndex(
          categoryIndex,
          series,
        );

        if (layout == AppBarChartLayout.grouped) {
          final gapCount = series.length > 1 ? series.length - 1 : 0;
          final availableBarWidth =
              (bandWidth - (gapCount * groupedSpacing)) / series.length;
          final resolvedBarWidth = _resolvedThickness(
            availableThickness: availableBarWidth,
            barThickness: barThickness,
          );
          final occupiedWidth =
              (resolvedBarWidth * series.length) + (gapCount * groupedSpacing);
          final offsetLeft = hasFixedDistribution
              ? bandLeft
              : bandLeft + ((groupWidth - occupiedWidth) / 2);

          for (
            var seriesIndex = 0;
            seriesIndex < series.length;
            seriesIndex++
          ) {
            final value = series[seriesIndex].values[categoryIndex];
            final height = (value / maxValue).clamp(0, 1) * plotRect.height;
            final rect = Rect.fromLTWH(
              offsetLeft + (seriesIndex * (resolvedBarWidth + groupedSpacing)),
              plotRect.bottom - height,
              resolvedBarWidth,
              height,
            );
            rects.add(
              _AppBarRect(
                anchor: Offset(rect.center.dx, rect.top),
                borderRadius: _resolvedBorderRadius(
                  radius: barRadius,
                  isLastVisibleInStack: true,
                  layout: layout,
                  orientation: orientation,
                ),
                categoryIndex: categoryIndex,
                rect: rect,
                seriesIndex: seriesIndex,
              ),
            );
          }
        } else {
          final resolvedBandWidth = _resolvedThickness(
            availableThickness: bandWidth,
            barThickness: barThickness,
          );
          final offsetLeft = hasFixedDistribution
              ? bandLeft
              : bandLeft + ((groupWidth - resolvedBandWidth) / 2);
          var currentTop = plotRect.bottom;

          for (
            var seriesIndex = 0;
            seriesIndex < series.length;
            seriesIndex++
          ) {
            final value = series[seriesIndex].values[categoryIndex];
            final height = (value / maxValue).clamp(0, 1) * plotRect.height;
            final rect = Rect.fromLTWH(
              offsetLeft,
              currentTop - height,
              resolvedBandWidth,
              height,
            );
            currentTop -= height;
            rects.add(
              _AppBarRect(
                anchor: Offset(rect.center.dx, rect.top),
                borderRadius: _resolvedBorderRadius(
                  radius: barRadius,
                  isLastVisibleInStack: seriesIndex == lastVisibleSeriesIndex,
                  layout: layout,
                  orientation: orientation,
                ),
                categoryIndex: categoryIndex,
                rect: rect,
                seriesIndex: seriesIndex,
              ),
            );
          }
        }
      }

      return rects;
    }

    final groupHeight = hasFixedDistribution
        ? (layout == AppBarChartLayout.grouped
              ? (resolvedFixedBarExtent * series.length) +
                    (groupedSpacing * math.max(series.length - 1, 0))
              : resolvedFixedBarExtent)
        : plotRect.height / groupCount;
    final bandFactor = hasFixedDistribution ? 1.0 : 0.7;

    for (var categoryIndex = 0; categoryIndex < groupCount; categoryIndex++) {
      final top = hasFixedDistribution
          ? plotRect.top +
                resolvedCategorySpacing +
                (categoryIndex * (groupHeight + resolvedCategorySpacing))
          : plotRect.top + (groupHeight * categoryIndex);
      final bandHeight = groupHeight * bandFactor;
      final lastVisibleSeriesIndex = _lastVisibleSeriesIndex(
        categoryIndex,
        series,
      );

      if (layout == AppBarChartLayout.grouped) {
        final gapCount = series.length > 1 ? series.length - 1 : 0;
        final availableBarHeight =
            (bandHeight - (gapCount * groupedSpacing)) / series.length;
        final resolvedBarHeight = _resolvedThickness(
          availableThickness: availableBarHeight,
          barThickness: barThickness,
        );
        final occupiedHeight =
            (resolvedBarHeight * series.length) + (gapCount * groupedSpacing);
        final bandTop = hasFixedDistribution
            ? top
            : top + ((groupHeight - occupiedHeight) / 2);

        for (var seriesIndex = 0; seriesIndex < series.length; seriesIndex++) {
          final value = series[seriesIndex].values[categoryIndex];
          final width = (value / maxValue).clamp(0, 1) * plotRect.width;
          final rect = Rect.fromLTWH(
            plotRect.left,
            bandTop + (seriesIndex * (resolvedBarHeight + groupedSpacing)),
            width,
            resolvedBarHeight,
          );
          rects.add(
            _AppBarRect(
              anchor: Offset(rect.right, rect.center.dy),
              borderRadius: _resolvedBorderRadius(
                radius: barRadius,
                isLastVisibleInStack: true,
                layout: layout,
                orientation: orientation,
              ),
              categoryIndex: categoryIndex,
              rect: rect,
              seriesIndex: seriesIndex,
            ),
          );
        }
      } else {
        final resolvedBandHeight = _resolvedThickness(
          availableThickness: bandHeight,
          barThickness: barThickness,
        );
        final bandTop = hasFixedDistribution
            ? top
            : top + ((groupHeight - resolvedBandHeight) / 2);
        var currentLeft = plotRect.left;

        for (var seriesIndex = 0; seriesIndex < series.length; seriesIndex++) {
          final value = series[seriesIndex].values[categoryIndex];
          final width = (value / maxValue).clamp(0, 1) * plotRect.width;
          final rect = Rect.fromLTWH(
            currentLeft,
            bandTop,
            width,
            resolvedBandHeight,
          );
          currentLeft += width;
          rects.add(
            _AppBarRect(
              anchor: Offset(rect.right, rect.center.dy),
              borderRadius: _resolvedBorderRadius(
                radius: barRadius,
                isLastVisibleInStack: seriesIndex == lastVisibleSeriesIndex,
                layout: layout,
                orientation: orientation,
              ),
              categoryIndex: categoryIndex,
              rect: rect,
              seriesIndex: seriesIndex,
            ),
          );
        }
      }
    }

    return rects;
  }

  static int _lastVisibleSeriesIndex(
    int categoryIndex,
    List<AppBarChartSeries> series,
  ) {
    for (var seriesIndex = series.length - 1; seriesIndex >= 0; seriesIndex--) {
      if (series[seriesIndex].values[categoryIndex] > 0) {
        return seriesIndex;
      }
    }

    return series.length - 1;
  }

  static BorderRadius _resolvedBorderRadius({
    required Radius radius,
    required bool isLastVisibleInStack,
    required AppBarChartLayout layout,
    required AppBarChartOrientation orientation,
  }) {
    // Barras empilhadas mantêm a junta reta; só a ponta de fora arredonda.
    if (layout == AppBarChartLayout.stacked && !isLastVisibleInStack) {
      return BorderRadius.zero;
    }

    if (orientation == AppBarChartOrientation.vertical) {
      return BorderRadius.only(topLeft: radius, topRight: radius);
    }

    return BorderRadius.only(bottomRight: radius, topRight: radius);
  }

  static double _resolvedThickness({
    required double availableThickness,
    required double? barThickness,
  }) {
    final resolvedAvailableThickness = math.max(
      availableThickness,
      AppSizes.s4,
    );
    final resolvedThickness = barThickness ?? resolvedAvailableThickness;

    return resolvedThickness
        .clamp(AppSizes.s4, resolvedAvailableThickness)
        .toDouble();
  }

  static double _resolvedMaxValue(
    List<String> labels,
    AppBarChartLayout layout,
    List<AppBarChartSeries> series,
  ) {
    if (layout == AppBarChartLayout.grouped) {
      return series.expand((item) => item.values).fold<double>(0, math.max);
    }

    return List<double>.generate(
      labels.length,
      (index) =>
          series.fold<double>(0, (sum, item) => sum + item.values[index]),
    ).fold<double>(0, math.max);
  }
}

final class _AppBarChartPainter extends CustomPainter {
  const _AppBarChartPainter({
    required this.geometry,
    required this.selectedCategoryIndex,
  });

  final _AppBarChartGeometry geometry;
  final int? selectedCategoryIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = geometry.theme.colorTheme.neutralPrimary.s100
      ..strokeWidth = AppStrokes.m;

    for (var index = 0; index < geometry.tickValues.length; index++) {
      final ratio = index / (math.max(geometry.tickValues.length - 1, 1));

      if (geometry.orientation == AppBarChartOrientation.vertical) {
        final y = geometry.plotRect.bottom - (geometry.plotRect.height * ratio);
        canvas.drawLine(
          Offset(geometry.plotRect.left, y),
          Offset(geometry.plotRect.right, y),
          gridPaint,
        );
      } else {
        final x = geometry.plotRect.left + (geometry.plotRect.width * ratio);
        canvas.drawLine(
          Offset(x, geometry.plotRect.top),
          Offset(x, geometry.plotRect.bottom),
          gridPaint,
        );
      }
    }

    for (final barRect in geometry.barRects) {
      final color = ChartFoundation.resolveColor(
        geometry.theme,
        barRect.seriesIndex,
        color: geometry.series[barRect.seriesIndex].color,
      );
      final paint = Paint()..color = color;

      if (geometry.series[barRect.seriesIndex].gradient case final gradient?) {
        paint.shader = gradient.createShader(barRect.rect);
      }

      if (selectedCategoryIndex == barRect.categoryIndex) {
        paint.color = paint.color.withValues(alpha: 0.9);
      }

      canvas.drawRRect(barRect.borderRadius.toRRect(barRect.rect), paint);
    }
  }

  @override
  bool shouldRepaint(_AppBarChartPainter oldDelegate) {
    return geometry != oldDelegate.geometry ||
        selectedCategoryIndex != oldDelegate.selectedCategoryIndex;
  }
}

final class _AppBarRect {
  const _AppBarRect({
    required this.anchor,
    required this.borderRadius,
    required this.categoryIndex,
    required this.rect,
    required this.seriesIndex,
  });

  final Offset anchor;
  final BorderRadius borderRadius;
  final int categoryIndex;
  final Rect rect;
  final int seriesIndex;
}
