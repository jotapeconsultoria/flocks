import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../../tokens/swatch_generator.dart';
import 'app_snackbar_type.dart';

/// Card de feedback temporário (sucesso, erro, info) com título, descrição e
/// ícone semântico.
///
/// É apenas o **card**: para exibi-lo (canto da tela, auto-dismiss) use o helper
/// [showAppSnackbar]. A superfície é `surfaceContainer` levemente tingida pela
/// cor semântica ([type]); o tratamento de container segue o eixo [AppStyle]
/// (default próprio `elevated`), e a forma segue o modo de raio global. Todas as
/// cores vêm do tema → contraste AA em claro/escuro. É anunciado por leitores de
/// tela (`liveRegion`).
///
/// ```dart
/// AppSnackbar(
///   title: 'Salvo',
///   description: 'As alterações foram aplicadas.',
///   type: AppSnackbarType.success,
/// )
/// ```
final class AppSnackbar extends StatelessWidget {
  /// Cria um [AppSnackbar].
  const AppSnackbar({
    required this.description,
    required this.title,
    required this.type,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Descrição (até 3 linhas, `bodyMedium`, neutro legível).
  final String description;

  /// Título (1 linha, `titleMedium`, `onSurface`).
  final String title;

  /// Tipo semântico (cor + ícone).
  final AppSnackbarType type;

  /// Tratamento de container ([AppStyle]). `null` resolve para `elevated`.
  final AppStyle? style;

  /// Override do modo de forma. `null` segue o modo global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio. Vence [radiusMode] e o modo global.
  final BorderRadius? radius;

  static const double _maxWidth = 384;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final ColorSwatch<int> role = type.resolve(colors);
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
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: DecoratedBox(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacings.s16,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppText(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacings.s4),
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
                AppIcon(type.icon, color: iconColor, size: AppIconSize.m),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
