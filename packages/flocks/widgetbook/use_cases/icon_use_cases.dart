import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppIcon — Catalog (searchable value collection) + Playground (one icon).
// The catalog is full-surface (panel:false); the search filter lives in the
// Knobs panel via [wbSearch].
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Catalog', type: AppIcon)
Widget appIconCatalog(BuildContext context) {
  final theme = AppTheme.of(context);
  final search = wbSearch(context);
  final size = context.knobs.object.dropdown<AppIconSize>(
    label: 'size',
    options: AppIconSize.values,
    initialOption: AppIconSize.l,
    labelBuilder: (s) => 'AppIconSize.${s.name}',
  );
  final color = wbSemanticColorKnob(context);
  return wbUseCase(
    context,
    name: 'AppIcon',
    description: 'Search and browse every icon; control size and color.',
    panel: false,
    maxWidth: 1100,
    child: wbCatalog<String>(
      context,
      items: AppIcons.allIcons,
      search: search,
      nameOf: wbAssetName,
      tileBuilder: (context, url) => wbTile(
        context,
        name: wbAssetName(url),
        token: 'AppIcons.${_camel(wbAssetName(url))}',
        width: 96,
        child: AppIcon(
          url,
          size: size,
          color: color ?? theme.colorTheme.onSurface,
          semanticLabel: wbAssetName(url),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppIcon)
Widget appIconPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final icon = context.knobs.object.dropdown<String>(
    label: 'icon',
    options: AppIcons.allIcons,
    initialOption: AppIconToken.check,
    labelBuilder: wbAssetName,
  );
  final size = context.knobs.object.dropdown<AppIconSize>(
    label: 'size',
    options: AppIconSize.values,
    initialOption: AppIconSize.l,
    labelBuilder: (s) => 'AppIconSize.${s.name}',
  );
  final customSize = context.knobs.double.slider(
    label: 'customSize (0 = use size)',
    initialValue: 0,
    min: 0,
    max: 96,
  );
  final color = wbSemanticColorKnob(context);
  final semanticLabel = context.knobs.string(
    label: 'semanticLabel',
    initialValue: '',
  );
  return wbUseCase(
    context,
    name: 'AppIcon',
    description: 'Render one icon with full control over size and color.',
    child: AppIcon(
      icon,
      size: size,
      customSize: customSize == 0 ? null : customSize,
      color: color ?? theme.colorTheme.onSurface,
      semanticLabel: semanticLabel.isEmpty ? null : semanticLabel,
    ),
  );
}

/// 'battery-charging' -> 'batteryCharging' (rebuilds the `AppIcons.<member>`).
String _camel(String kebab) {
  final parts = kebab.split('-');
  return parts.first +
      parts
          .skip(1)
          .map((p) => p.isEmpty ? p : '${p[0].toUpperCase()}${p.substring(1)}')
          .join();
}
