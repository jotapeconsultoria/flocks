import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// Design tokens — searchable catalogs of the raw scales (AppSpacings /
// AppSizes / AppRadius / AppStrokes). Value collections, so each case is a
// full-surface (panel:false) catalog with a search filter, mirroring the icon
// exemplar. Very large values have their drawn size capped while the label
// always shows the true token value.
// ---------------------------------------------------------------------------

/// Marker so every token catalog groups under this node in the Widgetbook tree.
class DesignTokens extends StatelessWidget {
  const DesignTokens({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// (name, value) pairs of the spacing scale.
const List<(String, double)> _spacings = [
  ('s0', AppSpacings.s0),
  ('s1', AppSpacings.s1),
  ('s2', AppSpacings.s2),
  ('s4', AppSpacings.s4),
  ('s8', AppSpacings.s8),
  ('s12', AppSpacings.s12),
  ('s16', AppSpacings.s16),
  ('s24', AppSpacings.s24),
  ('s32', AppSpacings.s32),
  ('s48', AppSpacings.s48),
  ('s64', AppSpacings.s64),
  ('s128', AppSpacings.s128),
  ('s192', AppSpacings.s192),
];

/// (name, value) pairs of the size scale (mirrors spacing).
const List<(String, double)> _sizes = [
  ('s0', AppSizes.s0),
  ('s1', AppSizes.s1),
  ('s2', AppSizes.s2),
  ('s4', AppSizes.s4),
  ('s8', AppSizes.s8),
  ('s12', AppSizes.s12),
  ('s16', AppSizes.s16),
  ('s24', AppSizes.s24),
  ('s32', AppSizes.s32),
  ('s48', AppSizes.s48),
  ('s64', AppSizes.s64),
  ('s128', AppSizes.s128),
  ('s192', AppSizes.s192),
];

/// (name, value) pairs of the corner-radius scale.
const List<(String, double)> _radii = [
  ('none', AppRadius.none),
  ('xs', AppRadius.xs),
  ('s', AppRadius.s),
  ('m', AppRadius.m),
  ('l', AppRadius.l),
  ('xl', AppRadius.xl),
];

/// (name, value) pairs of the stroke-width scale.
const List<(String, double)> _strokes = [
  ('none', AppStrokes.none),
  ('xs', AppStrokes.xs),
  ('s', AppStrokes.s),
  ('m', AppStrokes.m),
  ('l', AppStrokes.l),
  ('xl', AppStrokes.xl),
];

/// Shared bar tile for the spacing / size scales (a primary bar of `value`
/// width, capped so 192 stays readable in the grid).
Widget _barTile(BuildContext context, (String, double) r) {
  final theme = AppTheme.of(context);
  return wbTile(
    context,
    name: r.$1,
    token: '${r.$2}px',
    width: 140,
    child: Container(
      width: r.$2.clamp(1, 120),
      height: AppSizes.s16,
      decoration: BoxDecoration(
        color: theme.colorTheme.primary,
        borderRadius: theme.radiusTheme.resolve(),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Spacing', type: DesignTokens)
Widget spacingTokens(BuildContext context) => wbUseCase(
  context,
  name: 'Design tokens',
  description: 'Spacing scale (AppSpacings).',
  panel: false,
  maxWidth: 1100,
  child: wbCatalog<(String, double)>(
    context,
    items: _spacings,
    search: wbSearch(context),
    nameOf: (r) => r.$1,
    tileBuilder: _barTile,
  ),
);

@widgetbook.UseCase(name: 'Sizes', type: DesignTokens)
Widget sizeTokens(BuildContext context) => wbUseCase(
  context,
  name: 'Design tokens',
  description: 'Size scale (AppSizes) — mirrors the spacing scale.',
  panel: false,
  maxWidth: 1100,
  child: wbCatalog<(String, double)>(
    context,
    items: _sizes,
    search: wbSearch(context),
    nameOf: (r) => r.$1,
    tileBuilder: _barTile,
  ),
);

@widgetbook.UseCase(name: 'Radius', type: DesignTokens)
Widget radiusTokens(BuildContext context) {
  final theme = AppTheme.of(context);
  return wbUseCase(
    context,
    name: 'Design tokens',
    description: 'Corner radius scale (AppRadius).',
    panel: false,
    maxWidth: 1100,
    child: wbCatalog<(String, double)>(
      context,
      items: _radii,
      search: wbSearch(context),
      nameOf: (r) => r.$1,
      tileBuilder: (context, r) => wbTile(
        context,
        name: r.$1,
        token: '${r.$2}px',
        width: 120,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorTheme.surfaceContainer,
            borderRadius: BorderRadius.circular(r.$2),
            border: Border.all(
              color: theme.colorTheme.neutralPrimary.s600,
              width: AppStrokes.xs,
            ),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Strokes', type: DesignTokens)
Widget strokeTokens(BuildContext context) {
  final theme = AppTheme.of(context);
  return wbUseCase(
    context,
    name: 'Design tokens',
    description: 'Stroke width scale (AppStrokes).',
    panel: false,
    maxWidth: 1100,
    child: wbCatalog<(String, double)>(
      context,
      items: _strokes,
      search: wbSearch(context),
      nameOf: (r) => r.$1,
      tileBuilder: (context, r) => wbTile(
        context,
        name: r.$1,
        token: '${r.$2}px',
        width: 120,
        child: SizedBox(
          height: AppStrokes.xl,
          child: Center(
            child: Container(
              width: 64,
              height: r.$2,
              color: theme.colorTheme.onSurface,
            ),
          ),
        ),
      ),
    ),
  );
}
