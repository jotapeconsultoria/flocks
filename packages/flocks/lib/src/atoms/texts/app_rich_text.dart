import 'package:flutter/widgets.dart';

import '../../foundation/selection/app_selection_region.dart';
import 'app_text_span.dart';

/// Rich text of the Flocks design system: renders a single line/paragraph that
/// mixes multiple inline styles (bold words, colored highlights, links).
///
/// Wraps `Text.rich` from the `widgets` layer and enables native mouse text
/// selection via [AppSelectionRegion] (web/desktop parity, Regra 7). The styles
/// come from the [AppTextSpan] the caller builds — derive them from
/// `AppTheme.of(context)` so the text stays theme- and brand-aware. For plain,
/// single-style text prefer [AppText].
///
/// ```dart
/// final base = AppTheme.of(context).textTheme.bodyMedium;
/// AppRichText(
///   AppTextSpan(
///     style: base,
///     children: <TextSpan>[
///       const TextSpan(text: 'Speed: '),
///       TextSpan(text: '92 km/h', style: base.bold),
///     ],
///   ),
///   maxLines: 1,
///   overflow: TextOverflow.ellipsis,
/// )
/// ```
final class AppRichText extends StatelessWidget {
  const AppRichText(
    this.data, {
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.semanticLabel,
    this.softWrap = true,
    this.textAlign = TextAlign.start,
    super.key,
  });

  /// The data to be displayed.
  final AppTextSpan data;

  /// The maximum number of lines to be displayed.
  final int? maxLines;

  /// The type of overflow to be used.
  ///
  /// The default value is [TextOverflow.clip].
  final TextOverflow overflow;

  /// The semantic label of the text.
  ///
  /// The default value is [data.text].
  final String? semanticLabel;

  /// The flag to enable the soft wrap of the text.
  ///
  /// The default value is [true].
  final bool softWrap;

  /// The alignment of the text.
  ///
  /// The default value is [TextAlign.start].
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return AppSelectionRegion(
      child: Text.rich(
        data,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textAlign: textAlign,
        semanticsLabel: semanticLabel ?? data.text ?? '',
      ),
    );
  }
}
