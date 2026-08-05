import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// Foundations · Colors — the theme's color roles (brand × brightness), on the
// standard frame: centered, headed, searchable. Each page is a value
// collection, so it runs through wbUseCase (panel:false) + wbCatalog + wbSearch.
// Switch brand/brightness in the "Theme" addon and compare light × dark.
// ---------------------------------------------------------------------------

/// Marker only to group the color pages in the catalog tree.
class ColorFoundations extends StatelessWidget {
  const ColorFoundations({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// A named color entry: its search [label] and how to draw its swatch.
class _ColorItem {
  const _ColorItem(this.label, this.builder);

  final String label;
  final WidgetBuilder builder;
}

Widget _colorsPage(
  BuildContext context, {
  required String description,
  required List<_ColorItem> items,
}) => wbUseCase(
  context,
  name: 'Colors',
  description: description,
  panel: false,
  maxWidth: 1100,
  child: wbCatalog<_ColorItem>(
    context,
    items: items,
    search: wbSearch(context),
    nameOf: (i) => i.label,
    tileBuilder: (context, i) => i.builder(context),
  ),
);

@widgetbook.UseCase(name: 'Semantic colors', type: ColorFoundations)
Widget semanticColors(BuildContext context) {
  final t = AppTheme.of(context).colorTheme;
  return _colorsPage(
    context,
    description: 'Semantic fills paired with their on-color (AA legibility).',
    items: [
      _ColorItem(
        'primary',
        (c) => _FillChip(label: 'primary', fill: t.primary, on: t.onPrimary),
      ),
      _ColorItem(
        'secondary',
        (c) =>
            _FillChip(label: 'secondary', fill: t.secondary, on: t.onSecondary),
      ),
      _ColorItem(
        'tertiary',
        (c) => _FillChip(label: 'tertiary', fill: t.tertiary, on: t.onTertiary),
      ),
      _ColorItem(
        'danger',
        (c) => _FillChip(label: 'danger', fill: t.danger, on: t.onDanger),
      ),
      _ColorItem(
        'info',
        (c) => _FillChip(label: 'info', fill: t.info, on: t.onInfo),
      ),
      _ColorItem(
        'success',
        (c) => _FillChip(label: 'success', fill: t.success, on: t.onSuccess),
      ),
      _ColorItem(
        'warning',
        (c) => _FillChip(label: 'warning', fill: t.warning, on: t.onWarning),
      ),
    ],
  );
}

@widgetbook.UseCase(name: 'Surface, border & focus', type: ColorFoundations)
Widget surfaceColors(BuildContext context) {
  final t = AppTheme.of(context).colorTheme;
  return _colorsPage(
    context,
    description: 'Surface, elevation, border and focus-ring roles.',
    items: [
      _ColorItem(
        'surface',
        (c) => _SwatchTile(
          label: 'surface',
          token: 'colorTheme.surface',
          color: t.surface,
        ),
      ),
      _ColorItem(
        'surfaceContainer',
        (c) => _SwatchTile(
          label: 'surfaceContainer',
          token: 'elevation',
          color: t.surfaceContainer,
        ),
      ),
      _ColorItem(
        'border',
        (c) => _BorderTile(
          label: 'border',
          token: 'neutral.s500',
          color: t.neutralPrimary.s500,
        ),
      ),
      _ColorItem(
        'focus ring',
        (c) => _BorderTile(
          label: 'focus ring',
          token: 'colorTheme.focusRing',
          color: t.focusRing,
        ),
      ),
      _ColorItem(
        'onSurface',
        (c) => _SwatchTile(
          label: 'onSurface',
          token: 'body text',
          color: t.onSurface,
        ),
      ),
    ],
  );
}

@widgetbook.UseCase(name: 'Data-viz', type: ColorFoundations)
Widget dataVizColors(BuildContext context) {
  final t = AppTheme.of(context).colorTheme;
  return _colorsPage(
    context,
    description: 'Chart and score colors (3:1 over the surface).',
    items: [
      _ColorItem(
        'chartGood',
        (c) => _SwatchTile(
          label: 'chartGood',
          token: 'good band',
          color: t.chartGood,
        ),
      ),
      _ColorItem(
        'chartNeutral',
        (c) => _SwatchTile(
          label: 'chartNeutral',
          token: 'neutral band',
          color: t.chartNeutral,
        ),
      ),
      _ColorItem(
        'chartBad',
        (c) => _SwatchTile(
          label: 'chartBad',
          token: 'bad band',
          color: t.chartBad,
        ),
      ),
      _ColorItem(
        'scoreLow',
        (c) => _SwatchTile(
          label: 'scoreLow',
          token: 'low score',
          color: t.scoreLow,
        ),
      ),
      _ColorItem(
        'scoreMid',
        (c) => _SwatchTile(
          label: 'scoreMid',
          token: 'mid score',
          color: t.scoreMid,
        ),
      ),
      _ColorItem(
        'scoreHigh',
        (c) => _SwatchTile(
          label: 'scoreHigh',
          token: 'high score',
          color: t.scoreHigh,
        ),
      ),
    ],
  );
}

// --- internal tiles ----------------------------------------------------------

/// Colored fill with the on-color on top (shows AA legibility).
class _FillChip extends StatelessWidget {
  const _FillChip({required this.label, required this.fill, required this.on});

  final String label;
  final Color fill;
  final Color on;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return SizedBox(
      width: 132,
      height: 76,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: theme.radiusTheme.resolve(),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                'Aa 123',
                style: theme.textTheme.labelLarge.withColor(on),
              ),
              AppText(label, style: theme.textTheme.bodySmall.withColor(on)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Solid color swatch + label/token underneath.
class _SwatchTile extends StatelessWidget {
  const _SwatchTile({
    required this.label,
    required this.token,
    required this.color,
  });

  final String label;
  final String token;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return SizedBox(
      width: 132,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 56,
            width: 132,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: theme.radiusTheme.resolve(),
                border: Border.all(color: theme.colorTheme.neutralPrimary.s500),
              ),
            ),
          ),
          const SizedBox(height: AppSpacings.s4),
          AppText(label, style: theme.textTheme.labelMedium),
          AppText(
            token,
            style: theme.textTheme.bodySmall.withColor(
              theme.colorTheme.neutralPrimary.s600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Line-color swatch (border/focus): a thick ring over the surface.
class _BorderTile extends StatelessWidget {
  const _BorderTile({
    required this.label,
    required this.token,
    required this.color,
  });

  final String label;
  final String token;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return SizedBox(
      width: 132,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 56,
            width: 132,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorTheme.surface,
                borderRadius: theme.radiusTheme.resolve(),
                border: Border.all(color: color, width: AppStrokes.l),
              ),
            ),
          ),
          const SizedBox(height: AppSpacings.s4),
          AppText(label, style: theme.textTheme.labelMedium),
          AppText(
            token,
            style: theme.textTheme.bodySmall.withColor(
              theme.colorTheme.neutralPrimary.s600,
            ),
          ),
        ],
      ),
    );
  }
}
