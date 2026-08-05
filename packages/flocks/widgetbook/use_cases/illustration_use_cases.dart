import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppIllustration — Catalog (searchable value collection) + Playground (one
// illustration). The catalog is full-surface (panel:false); the search filter
// lives in the Knobs panel via [wbSearch].
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Catalog', type: AppIllustration)
Widget appIllustrationCatalog(BuildContext context) {
  final search = wbSearch(context);
  final size = context.knobs.object.dropdown<AppIllustrationSize>(
    label: 'size',
    options: AppIllustrationSize.values,
    initialOption: AppIllustrationSize.values.first,
    labelBuilder: (s) => 'AppIllustrationSize.${s.name}',
  );
  final accentColor = wbSemanticColorKnob(context, label: 'accentColor');
  return wbUseCase(
    context,
    name: 'AppIllustration',
    description:
        'Search and browse every illustration; control size and accent.',
    panel: false,
    maxWidth: 1100,
    child: wbCatalog<String>(
      context,
      items: AppIllustrations.allIllustrations,
      search: search,
      nameOf: wbAssetName,
      tileBuilder: (context, url) => wbTile(
        context,
        name: wbAssetName(url),
        token: 'AppIllustrations.${_camel(wbAssetName(url))}',
        width: 160,
        child: AppIllustration(
          url,
          size: size,
          accentColor: accentColor,
          semanticLabel: wbAssetName(url),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppIllustration)
Widget appIllustrationPlayground(BuildContext context) {
  final illustration = context.knobs.object.dropdown<String>(
    label: 'illustration',
    options: AppIllustrations.allIllustrations,
    initialOption: AppIllustrations.support,
    labelBuilder: wbAssetName,
  );
  final size = context.knobs.object.dropdown<AppIllustrationSize>(
    label: 'size',
    options: AppIllustrationSize.values,
    initialOption: AppIllustrationSize.l,
    labelBuilder: (s) => 'AppIllustrationSize.${s.name}',
  );
  final accentColor = wbSemanticColorKnob(context, label: 'accentColor');
  final baseColor = wbSemanticColorKnob(context, label: 'baseColor');
  final semanticLabel = context.knobs.string(
    label: 'semanticLabel',
    initialValue: '',
  );
  return wbUseCase(
    context,
    name: 'AppIllustration',
    description: 'One illustration with base/accent color control.',
    child: AppIllustration(
      illustration,
      size: size,
      accentColor: accentColor,
      baseColor: baseColor,
      semanticLabel: semanticLabel.isEmpty ? null : semanticLabel,
    ),
  );
}

/// 'error-connection' -> 'errorConnection' (rebuilds `AppIllustrations.<member>`).
String _camel(String kebab) {
  final parts = kebab.split('-');
  return parts.first +
      parts
          .skip(1)
          .map((p) => p.isEmpty ? p : '${p[0].toUpperCase()}${p.substring(1)}')
          .join();
}
