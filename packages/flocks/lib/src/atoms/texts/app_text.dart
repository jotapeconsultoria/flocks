import 'package:flutter/widgets.dart';

import '../../foundation/selection/app_selection_region.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// The class that defines the AppText widget.
///
/// The AppText widget is a text that follows the App.
final class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.semanticLabel,
    this.softWrap = true,
    this.style,
    this.textAlign = TextAlign.start,
    super.key,
  });

  /// The data to be displayed.
  final String data;

  /// The maximum number of lines to be displayed.
  final int? maxLines;

  /// The type of overflow to be used.
  ///
  /// The default value is [TextOverflow.clip].
  final TextOverflow overflow;

  /// The semantic label of the text.
  ///
  /// The default value is [data].
  final String? semanticLabel;

  /// The flag to enable the soft wrap of the text.
  ///
  /// The default value is [true].
  final bool softWrap;

  /// The style of the text.
  ///
  /// Quando `null`, usa `theme.textTheme.bodyMedium` com a cor `onSurface` do
  /// tema.
  final TextStyle? style;

  /// The alignment of the text.
  ///
  /// The default value is [TextAlign.start].
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppSelectionRegion(
      child: Text(
        data,
        maxLines: maxLines,
        overflow: overflow,
        semanticsLabel: semanticLabel ?? data,
        softWrap: softWrap,
        style:
            style ??
            theme.textTheme.bodyMedium.withColor(theme.colorTheme.onSurface),
        textAlign: textAlign,
      ),
    );
  }
}
