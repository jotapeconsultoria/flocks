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

/// Card de feedback temporário (sucesso, erro, info, aviso) com descrição,
/// título opcional e ícone semântico.
///
/// É apenas o **card**: para exibi-lo (canto da tela, auto-dismiss) use o helper
/// [showAppSnackbar]. A superfície é `surfaceContainer` levemente tingida pela
/// cor semântica ([type]); o tratamento de container segue o eixo [AppStyle]
/// (default próprio `elevated`), e a forma segue o modo de raio global. Todas as
/// cores vêm do tema → contraste AA em claro/escuro. É anunciado por leitores de
/// tela (`liveRegion`).
///
/// Sem [title] o card é o toast de uma frase só: a linha do título some e o
/// ícone centraliza verticalmente com a mensagem.
///
/// ```dart
/// AppSnackbar(
///   title: 'Salvo',
///   description: 'As alterações foram aplicadas.',
///   type: AppSnackbarType.success,
/// )
///
/// const AppSnackbar(description: 'Link copiado.')
/// ```
final class AppSnackbar extends StatelessWidget {
  /// Cria um [AppSnackbar].
  const AppSnackbar({
    required this.description,
    this.title,
    this.type = AppSnackbarType.info,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  }) : assert(
         description != '',
         'AppSnackbar sem texto não tem o que anunciar',
       );
  // `!= ''` e não `.isNotEmpty`: o construtor é const e os previews/goldens
  // usam `const AppSnackbar(...)` — getter quebra a avaliação constante.

  /// Mensagem (até 3 linhas, `bodyMedium`).
  ///
  /// Sem [title] ela É o conteúdo do card e ganha a cor primária (`onSurface`);
  /// com [title] fica no neutro legível (`neutralPrimary.s700`), como sempre.
  final String description;

  /// Título opcional (1 linha, `titleMedium`, `onSurface`).
  ///
  /// `null` = toast de uma frase só: a linha do título e o respiro somem, e o
  /// ícone centraliza verticalmente com a mensagem.
  final String? title;

  /// Tipo semântico (cor + ícone). Default [AppSnackbarType.info] — o mesmo
  /// padrão do `AppAlert`. Mensagem de erro DEVE passar
  /// [AppSnackbarType.error]: a cor e o ícone são o único sinal da falha.
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

    final String? t = title;
    final bool hasTitle = t != null;

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
              // Com título o bloco de texto é alto e o ícone alinha no topo;
              // numa linha só, topo deixaria o ícone flutuando sobre a frase.
              crossAxisAlignment: hasTitle
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              spacing: AppSpacings.s16,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (hasTitle) ...<Widget>[
                        AppText(
                          t,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacings.s4),
                      ],
                      AppText(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium.copyWith(
                          color: hasTitle
                              ? colors.neutralPrimary.s700
                              : colors.onSurface,
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
