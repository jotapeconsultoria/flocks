import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_spacings.dart';

/// Disposição de um [AppTileInfo].
enum AppTileInfoLayout {
  /// Rótulo em cima, valor embaixo — o par empilhado de sempre. Default.
  vertical,

  /// Linha de ficha: rótulo à esquerda, valor à direita (o valor ocupa a
  /// sobra) — o desenho de "ficha" sem larguras mágicas no call site.
  horizontal,
}

/// Par rótulo/valor — não clicável.
///
/// Rótulo em neutro legível, valor em `onSurface`. Cores do tema (contraste
/// AA). [layout] vertical (default) empilha; horizontal vira a linha de ficha.
/// [icon] opcional acompanha o rótulo, na mesma cor muted dele.
///
/// ```dart
/// AppTileInfo(title: 'Identificador', text: 'TTS4G47')
///
/// AppTileInfo(
///   title: 'Telefone',
///   text: '+55 11 91234-5678',
///   icon: AppIconToken.phone,
///   layout: AppTileInfoLayout.horizontal,
/// )
/// ```
final class AppTileInfo extends StatelessWidget {
  /// Cria um [AppTileInfo].
  const AppTileInfo({
    required this.text,
    required this.title,
    this.textAlign = TextAlign.start,
    this.layout = AppTileInfoLayout.vertical,
    this.icon,
    super.key,
  });

  /// Alinhamento do texto.
  final TextAlign textAlign;

  /// Valor (ex.: "TTS4G47").
  final String text;

  /// Rótulo (ex.: "Identificador").
  final String title;

  /// Disposição do par. Default [AppTileInfoLayout.vertical] — o de sempre.
  final AppTileInfoLayout layout;

  /// Slug de ícone opcional junto ao rótulo, na MESMA cor muted dele
  /// (`AppIconSize.s`). `null` = sem ícone, a árvore de sempre.
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final Color mutedColor = colors.neutralPrimary.s700;
    // Ênfase de DADO (inversa da list tile): rótulo muted, valor forte.
    final Widget titleText = AppText(
      title,
      semanticLabel: title,
      textAlign: textAlign,
      style: theme.textTheme.titleSmall.copyWith(color: mutedColor),
    );
    final Widget valueText = AppText(
      text,
      semanticLabel: text,
      textAlign: textAlign,
      style: theme.textTheme.bodyLarge.copyWith(color: colors.onSurface),
    );
    // Com ícone, a linha do rótulo vira Row (ícone + texto), sem esticar.
    final Widget titleLine = icon == null
        ? titleText
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AppIcon(icon!, color: mutedColor, size: AppIconSize.s),
              const SizedBox(width: AppSpacings.s4),
              Flexible(child: titleText),
            ],
          );

    if (layout == AppTileInfoLayout.horizontal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          titleLine,
          const SizedBox(width: AppSpacings.s8),
          Expanded(child: valueText),
        ],
      );
    }

    // Sem ícone, o vertical é NÓ A NÓ a árvore de sempre (Column stretch dos
    // dois AppText) — o stretch é o que faz o textAlign valer.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacings.s2,
      children: <Widget>[titleLine, valueText],
    );
  }
}
