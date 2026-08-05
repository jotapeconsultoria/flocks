import 'package:flutter/widgets.dart';

import '../../atoms/icons/app_icon_size.dart';
import '../../theme/theme.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_style.dart';
import 'app_button_color.dart';
import 'app_button_size.dart';
import 'button_core.dart';

/// FAB (_floating action button_) do Flocks — uma ação flutuante que **sempre**
/// carrega sombra (ela paira sobre o conteúdo), mesmo quando o [AppStyle] não é
/// `elevated`. Aceita [icon] e/ou [label]: só-ícone (círculo), só-texto ou
/// ícone+texto (estendido, formato stadium).
///
/// Varia pelo eixo global [AppStyle]: `filled` (preenchida), `outlined`
/// (contornada) e `elevated` (preenchida+sombra). Como superfície flutuante, o
/// FAB também participa do **eixo glass** ([AppGlassTheme]): quando o glass está
/// ligado (global ou via [glass]), vira vidro real (blur via `AppGlassSurface`,
/// degradando para opaco quando a transparência é reduzida). Por forma, o padrão
/// é **circular** (`radiusMode` nulo herda o global, que para o FAB resolve em
/// `circular`); `reto`/`redondo`/`circular` locais continuam honrados. Cor
/// [AppButtonColor.primary] por padrão.
///
/// Delega a `ButtonCore`, então herda estados ([FlocksInteraction]), cores AA por
/// estado, anel de foco, press-scale (`AppMotion`), loading e acessibilidade.
/// Para uma ação inline no fluxo (com rótulo, na linha do conteúdo), use
/// `AppButton`.
///
/// ```dart
/// AppFloatingButton(icon: AppIconToken.add, onPressed: create)                 // círculo
/// AppFloatingButton(icon: AppIconToken.add, label: 'Novo', onPressed: create)  // estendido
/// AppFloatingButton(glass: true, icon: AppIconToken.add, onPressed: create)     // vidro
/// ```
final class AppFloatingButton extends StatelessWidget {
  /// Cria um [AppFloatingButton]. Exige [label] ou [icon].
  const AppFloatingButton({
    required this.onPressed,
    this.style,
    this.glass,
    this.color = AppButtonColor.primary,
    this.label,
    this.icon,
    this.size = AppButtonSize.l,
    this.enabled = true,
    this.loading = false,
    this.radiusMode,
    this.radius,
    this.onLongPress,
    this.semanticsLabel,
    super.key,
  }) : assert(
         (label != null && label.length > 0) ||
             (icon != null && icon.length > 0),
         'Either label or icon must be provided',
       );

  /// Tratamento de container do eixo global [AppStyle] no render **não-glass**.
  /// `null` (default) segue `theme.styleTheme.style`. `filled`=preenchido,
  /// `outlined`=contornado, `elevated`=preenchido + sombra. Independente do
  /// estilo, o FAB **sempre** tem sombra.
  final AppStyle? style;

  /// Override do eixo glass só deste FAB. `null` segue o global
  /// (`theme.glassTheme.enabled`); `true`/`false` força ligado/desligado.
  final bool? glass;

  /// Papel de cor. Default [AppButtonColor.primary].
  final AppButtonColor color;

  /// Rótulo textual (opcional; só-ícone é válido).
  final String? label;

  /// URL do ícone (opcional; só-texto é válido).
  final String? icon;

  /// Tamanho (altura/lado). Default [AppButtonSize.l] (56 — FAB padrão);
  /// [AppButtonSize.s] (40) é o FAB pequeno. Também **define o tamanho do
  /// glifo** só-ícone: `s`→16, `m`→24, `l`→32 (ver [_glyphSize]).
  final AppButtonSize size;

  /// Se está habilitado.
  final bool enabled;

  /// Se está em loading (mostra spinner, bloqueia interação).
  final bool loading;

  /// Modo de forma do FAB. `null` (default) = **circular** (a forma natural do
  /// FAB: círculo quando só-ícone, stadium quando estendido). Passe
  /// `reto`/`redondo`/`circular` para forçar outra forma, ou `padrao` para a
  /// forma natural do componente (também circular). Vence o global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (vence [radiusMode] e o global).
  final BorderRadius? radius;

  /// Ação de clique. `null` desabilita.
  final VoidCallback? onPressed;

  /// Ação de long-press (opcional).
  final VoidCallback? onLongPress;

  /// Rótulo de acessibilidade. Default: [label] ou o nome do [icon].
  final String? semanticsLabel;

  /// Glifo só-ícone derivado de [size]: s→16, m→24, l→32.
  AppIconSize get _glyphSize => switch (size) {
    AppButtonSize.s => AppIconSize.s,
    AppButtonSize.m => AppIconSize.m,
    AppButtonSize.l => AppIconSize.l,
  };

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    // O `style` governa o render não-glass (variant). Quando o eixo glass está
    // ligado, a superfície frosted (`ButtonCore.glass`) sobrepõe esse variant.
    final AppStyle style = this.style ?? theme.styleTheme.style;
    final bool glassOn = glass ?? theme.glassTheme.enabled;
    return ButtonCore(
      variant: switch (style) {
        AppStyle.filled => ButtonVariant.fill,
        AppStyle.outlined => ButtonVariant.line,
        AppStyle.elevated => ButtonVariant.elevated,
      },
      glass: glassOn,
      // FAB paira → sempre com sombra, independente do estilo.
      elevate: true,
      // Forma natural do FAB: círculo (só-ícone) / stadium (estendido). `null`
      // vira `circular` (a marca global costuma ser `redondo`, que não é a cara
      // de um FAB); `padrao` também resolve em circular via componentDefault.
      componentDefaultRadius: AppRadiusMode.circular,
      iconOnlyGlyphSize: _glyphSize,
      color: color,
      onPressed: onPressed,
      onLongPress: onLongPress,
      label: label,
      icon: icon,
      size: size,
      enabled: enabled,
      loading: loading,
      radiusMode: radiusMode ?? AppRadiusMode.circular,
      radius: radius,
      semanticsLabel: semanticsLabel,
    );
  }
}
