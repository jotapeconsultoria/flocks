import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_spacings.dart';

/// Par rótulo/valor (título à esquerda, valor abaixo) — não clicável.
///
/// Rótulo em neutro legível, valor em `onSurface`. Cores do tema (contraste AA).
///
/// ```dart
/// AppTileInfo(title: 'Identificador', text: 'TTS4G47')
/// ```
final class AppTileInfo extends StatelessWidget {
  /// Cria um [AppTileInfo].
  const AppTileInfo({
    required this.text,
    required this.title,
    this.textAlign = TextAlign.start,
    super.key,
  });

  /// Alinhamento do texto.
  final TextAlign textAlign;

  /// Valor (ex.: "TTS4G47").
  final String text;

  /// Rótulo (ex.: "Identificador").
  final String title;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    // Ênfase de DADO (inversa da list tile): rótulo muted, valor forte.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacings.s2,
      children: <Widget>[
        AppText(
          title,
          semanticLabel: title,
          textAlign: textAlign,
          style: theme.textTheme.titleSmall.copyWith(
            color: colors.neutralPrimary.s700,
          ),
        ),
        AppText(
          text,
          semanticLabel: text,
          textAlign: textAlign,
          style: theme.textTheme.bodyLarge.copyWith(color: colors.onSurface),
        ),
      ],
    );
  }
}
