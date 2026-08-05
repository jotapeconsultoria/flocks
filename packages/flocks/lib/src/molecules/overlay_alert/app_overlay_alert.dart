import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Card elevado de alerta com título, descrição e ícone semântico.
///
/// Variante do alerta que recebe a cor semântica como um `ColorSwatch` ([color])
/// em vez de um enum. Superfície `surfaceContainer` tingida pela cor semântica,
/// com o container seguindo o eixo [AppStyle] (default próprio `elevated`) e a
/// forma pelo eixo de raio. Todas as cores vêm do tema → contraste AA em claro/
/// escuro. É anunciado por leitores de tela (`liveRegion`).
///
/// Prefira [AppAlert] quando puder usar o enum de papéis (info/success/warning/
/// danger); use este quando já tiver o swatch semântico em mãos.
final class AppOverlayAlert extends StatelessWidget {
  /// Cria um [AppOverlayAlert].
  const AppOverlayAlert({
    required this.description,
    required this.title,
    this.color,
    this.icon,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Cor semântica (swatch). Se `null`, usa `info` do tema.
  final ColorSwatch<int>? color;

  /// Ícone à direita do título. Default: ícone de informação.
  final String? icon;

  /// Descrição (até 3 linhas, `bodyMedium`, neutro legível).
  final String description;

  /// Título (1 linha, `titleMedium`, `onSurface`).
  final String title;

  /// Tratamento de container ([AppStyle]). `null` resolve para `elevated`.
  final AppStyle? style;

  /// Override do modo de forma. `null` segue o global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio. Vence [radiusMode] e o global.
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final ColorSwatch<int> role = color ?? colors.info;
    final AppStyle s = style ?? AppStyle.elevated;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final BorderRadius br =
        radius ?? theme.radiusTheme.resolve(override: radiusMode);
    final Color fill = Color.alphaBlend(
      role.withValues(alpha: 0.10),
      colors.surfaceContainer,
    );
    final Color borderColor = readableStopOn(role, colors.surface);
    final Color iconColor = readableStopOn(role, fill);

    return AppSemantics.liveRegion(
      DecoratedBox(
        decoration: styleBoxDecoration(
          style: s,
          isDark: isDark,
          radius: br,
          outline: borderColor,
          surfaceContainer: colors.surfaceContainer,
          ownFill: fill,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacings.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppText(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacings.s16),
                  AppIcon(
                    icon ?? AppIconToken.infoCircle,
                    color: iconColor,
                    size: AppIconSize.m,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacings.s8),
              AppText(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium.copyWith(
                  color: colors.neutralPrimary.s700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
