import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'chart_models.dart';

/// Moldura padrão de um gráfico: título, subtítulo, resumo, legenda e os
/// estados de carregando/vazio em volta da área de plotagem.
///
/// A caixa segue o eixo global de estilo ([AppStyle]) e o de forma
/// (`theme.radiusTheme`), como o `AppCard` — é o mesmo papel: um cartão de
/// conteúdo.
///
/// ```dart
/// AppChartShell(
///   title: 'Consumo por veículo',
///   child: AppBarChart(series: series),
/// )
/// ```
final class AppChartShell extends StatelessWidget {
  /// Cria um [AppChartShell].
  const AppChartShell({
    required this.child,
    this.chartConstraints = const BoxConstraints.tightFor(height: 240),
    this.constraints,
    this.emptyChild,
    this.expandChart = false,
    this.isEmpty = false,
    this.isLoading = false,
    this.legendItems = const <AppChartLegendItem>[],
    this.onLegendTap,
    this.summary,
    this.subtitle,
    this.title,
    this.style,
    super.key,
  });

  /// Conteúdo da área de plotagem (o gráfico em si).
  final Widget child;
  final BoxConstraints chartConstraints;
  final BoxConstraints? constraints;
  final Widget? emptyChild;
  final bool expandChart;
  final bool isEmpty;
  final bool isLoading;
  final List<AppChartLegendItem> legendItems;
  final void Function(AppChartLegendItem item)? onLegendTap;
  final Widget? summary;
  final String? subtitle;
  final String? title;

  /// Tratamento de container do eixo global [AppStyle]. `null` (default) segue
  /// `theme.styleTheme.style`.
  final AppStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final chartChild = isEmpty
        ? (emptyChild ?? const _AppChartShellEmptyState())
        : child;
    final chartWidget = expandChart
        ? Expanded(child: chartChild)
        : ConstrainedBox(constraints: chartConstraints, child: chartChild);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: expandChart ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (title != null || subtitle != null || summary != null) ...[
          _AppChartShellHeader(
            subtitle: subtitle,
            summary: summary,
            title: title,
          ),
          const SizedBox(height: AppSpacings.s16),
        ],
        chartWidget,
        if (legendItems.isNotEmpty) ...[
          const SizedBox(height: AppSpacings.s16),
          _AppChartLegend(items: legendItems, onTap: onLegendTap),
        ],
      ],
    );
    final decoratedShell = DecoratedBox(
      // Era `neutralWhite` + borda `tertiary.s200` fixos. `neutralWhite` é
      // branco puro NOS DOIS temas (é o papel "branco", não uma superfície):
      // no escuro isto pintava um cartão branco no meio da tela — a mesma bug
      // de que o AppDataTable já tinha saído. Agora é o eixo de estilo sobre
      // `surfaceContainer`, como o AppCard; no claro o tom é praticamente o
      // mesmo (0,976 contra 1,0), no escuro passa a existir.
      decoration: styleBoxDecoration(
        style: style ?? theme.styleTheme.style,
        isDark: theme.brightness == AppBrightness.dark,
        radius: theme.radiusTheme.resolve(),
        outline: theme.colorTheme.outline,
        surfaceContainer: theme.colorTheme.surfaceContainer,
        ownFill: theme.colorTheme.surfaceContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.s16),
        child: AppOverlayLoading(
          isLoading: isLoading,
          overlay: const Center(child: AppCircularLoading()),
          child: content,
        ),
      ),
    );

    if (constraints == null) {
      return decoratedShell;
    }

    return ConstrainedBox(constraints: constraints!, child: decoratedShell);
  }
}

final class _AppChartLegend extends StatelessWidget {
  const _AppChartLegend({required this.items, required this.onTap});

  final List<AppChartLegendItem> items;
  final void Function(AppChartLegendItem item)? onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: AppSpacings.s8,
      spacing: AppSpacings.s16,
      children: items
          .map((item) => _AppChartLegendItemButton(item: item, onTap: onTap))
          .toList(growable: false),
    );
  }
}

final class _AppChartLegendItemButton extends StatelessWidget {
  const _AppChartLegendItemButton({required this.item, required this.onTap});

  final AppChartLegendItem item;
  final void Function(AppChartLegendItem item)? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final button = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            // Chip da legenda: marca de data-viz (a COR é o conteúdo), então
            // o raio acompanha o tamanho dele, não o eixo de container.
            borderRadius: theme.radiusTheme.resolve(
              size: const Size.square(AppSizes.s8 + AppSizes.s4),
            ),
            color: item.isActive ? item.color : item.color.disabled(),
          ),
          height: AppSizes.s8 + AppSizes.s4,
          width: AppSizes.s8 + AppSizes.s4,
        ),
        const SizedBox(width: AppSpacings.s8),
        AppText(
          item.label,
          style: theme.textTheme.bodyMedium.withColor(
            item.isActive
                ? theme.colorTheme.onSurface
                : theme.colorTheme.onSurface.disabled(),
          ),
        ),
        if (item.valueLabel != null) ...[
          const SizedBox(width: AppSpacings.s4),
          AppText(
            item.valueLabel!,
            style: theme.textTheme.labelMedium.withColor(
              theme.colorTheme.neutralPrimary.s500,
            ),
          ),
        ],
      ],
    );

    final String label = item.semanticLabel ?? item.label;
    if (onTap == null) {
      return AppSemantics.label(label: label, child: button);
    }

    // Alternar uma série é um CONTROLE, não um rótulo colorido: era
    // `GestureDetector` cru, alcançável só por mouse. Pelo primitivo vem foco
    // por Tab e ativação por Enter/Space junto.
    return AppSemantics.toggle(
      value: item.isActive,
      label: label,
      onTap: () => onTap!(item),
      child: FlocksInteraction(
        onPressed: () => onTap!(item),
        builder: (BuildContext context, Set<WidgetState> states) =>
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: theme.radiusTheme.resolve(),
                border: Border.all(
                  color: states.contains(WidgetState.focused)
                      ? theme.colorTheme.focusRing
                      : theme.colorTheme.transparent,
                  width: AppStrokes.m,
                ),
              ),
              child: button,
            ),
      ),
    );
  }
}

final class _AppChartShellEmptyState extends StatelessWidget {
  const _AppChartShellEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Center(
      child: AppText(
        'Sem dados',
        style: theme.textTheme.bodyMedium.withColor(
          theme.colorTheme.neutralPrimary.s500,
        ),
      ),
    );
  }
}

final class _AppChartShellHeader extends StatelessWidget {
  const _AppChartShellHeader({
    required this.subtitle,
    required this.summary,
    required this.title,
  });

  final String? subtitle;
  final Widget? summary;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                AppText(
                  title!,
                  style: theme.textTheme.titleLarge.withColor(
                    theme.colorTheme.onSurface,
                  ),
                ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacings.s4),
                AppText(
                  subtitle!,
                  style: theme.textTheme.bodySmall.withColor(
                    theme.colorTheme.neutralPrimary.s500,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (summary != null) ...[
          const SizedBox(width: AppSpacings.s16),
          Flexible(child: summary!),
        ],
      ],
    );
  }
}
