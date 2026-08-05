import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../../tokens/swatch_generator.dart';

/// Papel de cor semântica de um [AppAlert].
enum AppAlertColor {
  /// Erro (vermelho).
  danger,

  /// Informativo (azul) — padrão.
  info,

  /// Ação genérica da marca.
  primary,

  /// Sucesso (verde).
  success,

  /// Atenção (âmbar).
  warning;

  /// Resolve o papel para o seu swatch semântico em [t].
  ColorSwatch<int> resolve(AppColorTheme t) => switch (this) {
    AppAlertColor.danger => t.danger,
    AppAlertColor.info => t.info,
    AppAlertColor.primary => t.primary,
    AppAlertColor.success => t.success,
    AppAlertColor.warning => t.warning,
  };

  /// Ícone default do papel.
  String get icon => switch (this) {
    AppAlertColor.danger => AppIconToken.errorCircle,
    AppAlertColor.info => AppIconToken.infoCircle,
    AppAlertColor.primary => AppIconToken.infoCircle,
    AppAlertColor.success => AppIconToken.checkCircle,
    AppAlertColor.warning => AppIconToken.alert,
  };
}

/// Card de alerta com título, descrição e ícone semântico.
///
/// Mostra um título (1 linha) e descrição (até 3 linhas) num card sobre
/// `surfaceContainer` levemente tingido pela cor semântica ([color]), com o
/// ícone na mesma cor. O tratamento de container (borda/fill/sombra) segue o
/// eixo [AppStyle] global (`theme.styleTheme`): `outlined` desenha a borda
/// semântica, `elevated` troca a borda por uma sombra, `filled` deixa só o tom
/// tingido — sobrescrevível por instância via [style]. A forma dos cantos segue
/// o modo de raio global ([AppRadiusMode]), com override via [radiusMode]/
/// [radius]. Todas as cores vêm do tema → contraste AA em claro/escuro nas duas
/// marcas. É anunciado por leitores de tela (`liveRegion`).
///
/// ```dart
/// AppAlert(
///   title: 'Sem conexão',
///   description: 'Verifique sua internet e tente novamente.',
///   color: AppAlertColor.danger,
/// )
/// ```
final class AppAlert extends StatelessWidget {
  /// Cria um [AppAlert].
  const AppAlert({
    required this.title,
    required this.description,
    this.color = AppAlertColor.info,
    this.icon,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Título (1 linha, `titleMedium`, `onSurface`).
  final String title;

  /// Descrição (até 3 linhas, `bodyMedium`, neutro legível).
  final String description;

  /// Papel de cor semântica. Default [AppAlertColor.info].
  final AppAlertColor color;

  /// Ícone à direita do título. Default: o ícone do [color].
  final String? icon;

  /// Tratamento de container (borda/fill/sombra). Default: o eixo global
  /// `theme.styleTheme.style`. Aditivo sobre o fill tingido do papel.
  final AppStyle? style;

  /// Override do modo de forma (raio) só deste alerta. `null` = segue o modo
  /// global (`theme.radiusTheme`).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio. Vence [radiusMode] e o modo global.
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final ColorSwatch<int> role = color.resolve(colors);
    final AppStyle s = style ?? theme.styleTheme.style;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final BorderRadius br =
        radius ?? theme.radiusTheme.resolve(override: radiusMode);
    // Tinge a superfície elevada com um sussurro da cor semântica (mantém o
    // texto legível: o tom fica quase o de `surfaceContainer`). O fill já é
    // OPACO (alphaBlend sobre `surfaceContainer`), então em `elevated` a sombra
    // não vaza por baixo — dispensa o achatamento condicional do AppBadge.
    final Color fill = Color.alphaBlend(
      role.withValues(alpha: 0.08),
      colors.surfaceContainer,
    );
    // Acento (borda/ícone) resolvido para um stop legível (≥ 3:1) sobre o fundo
    // onde repousa — a base do swatch não garante contraste (RULES §5).
    final Color borderColor = readableStopOn(role, colors.surface);
    final Color iconColor = readableStopOn(role, fill);

    return AppSemantics.liveRegion(
      DecoratedBox(
        // O container segue o eixo AppStyle global: filled = só o tom tingido;
        // outlined = tom + borda semântica (o visual histórico); elevated = tom
        // + sombra, sem borda. Como o alerta pinta com DecoratedBox (só-pintura),
        // a borda não desloca o conteúdo — dispensa o truque de borda em
        // foreground que badge/switch usam por desenharem com Container.
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
                    icon ?? color.icon,
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
