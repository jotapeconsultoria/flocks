import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_style.dart';
import 'app_button_color.dart';
import 'app_button_size.dart';
import 'button_core.dart';

/// Botão do Flocks — a ação com rótulo e/ou ícone, variando pelo eixo global
/// [AppStyle]: `filled` (primária preenchida), `outlined` (secundária
/// contornada) e `elevated` (preenchida com sombra simétrica, sem borda).
///
/// Fundo/realce por estado herdam o modelo de cor do DS (contraste AA garantido
/// em hover/press/disabled). Sobre [FlocksInteraction] (foco-Tab/anel,
/// Enter/Space), com press-scale via AppMotion e loading. Substitui os antigos
/// `AppFillButton` (→ [AppStyle.filled]) e `AppLineButton` (→ [AppStyle.outlined]).
///
/// ```dart
/// AppButton(label: 'Salvar', onPressed: save)                            // filled
/// AppButton(style: AppStyle.outlined, label: 'Cancelar', onPressed: cancel)
/// AppButton(style: AppStyle.elevated, label: 'Publicar', onPressed: publish)
/// ```
final class AppButton extends StatelessWidget {
  /// Cria um [AppButton]. Exige [label] ou [icon].
  const AppButton({
    required this.onPressed,
    this.style,
    this.color = AppButtonColor.primary,
    this.label,
    this.icon,
    this.trailing,
    this.size = AppButtonSize.l,
    this.enabled = true,
    this.loading = false,
    this.expandedWidth,
    this.fixedWidth,
    this.radiusMode,
    this.radius,
    this.semanticsLabel,
    super.key,
  }) : assert(
         (label != null && label.length > 0) ||
             (icon != null && icon.length > 0),
         'Either label or icon must be provided',
       );

  /// Tratamento de container do eixo global [AppStyle]. `null` (default) segue
  /// `theme.styleTheme.style`. `filled`=preenchido, `outlined`=contornado,
  /// `elevated`=preenchido + sombra.
  final AppStyle? style;

  /// Papel de cor. Default [AppButtonColor.primary].
  final AppButtonColor color;

  /// Rótulo textual.
  final String? label;

  /// URL do ícone (à esquerda do rótulo, ou só-ícone).
  final String? icon;

  /// Acessório à direita do rótulo, DENTRO do botão — tipicamente um
  /// [AppShortcutHint]. O selo de atalho é decorativo e não recebe toque, então
  /// é aqui que ele vira descoberto sem virar um segundo alvo de clique.
  ///
  /// ```dart
  /// AppButton(
  ///   label: 'Salvar',
  ///   trailing: const AppShortcutHint(AppShortcut('Enter')),
  ///   onPressed: save,
  /// )
  /// ```
  final Widget? trailing;

  /// Tamanho (altura). Default [AppButtonSize.l].
  final AppButtonSize size;

  /// Se está habilitado.
  final bool enabled;

  /// Se está em loading.
  final bool loading;

  /// Ocupa toda a largura disponível.
  final bool? expandedWidth;

  /// Largura fixa.
  final double? fixedWidth;

  /// Sobrescreve o modo de forma só deste botão (vence o global).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (vence [radiusMode] e o global).
  final BorderRadius? radius;

  /// Ação de clique. `null` desabilita.
  final VoidCallback? onPressed;

  /// Rótulo de acessibilidade. Default: [label].
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final AppStyle style = this.style ?? AppTheme.of(context).styleTheme.style;
    return ButtonCore(
      variant: switch (style) {
        AppStyle.filled => ButtonVariant.fill,
        AppStyle.outlined => ButtonVariant.line,
        AppStyle.elevated => ButtonVariant.elevated,
      },
      color: color,
      onPressed: onPressed,
      label: label,
      icon: icon,
      trailing: trailing,
      size: size,
      enabled: enabled,
      loading: loading,
      expandedWidth: expandedWidth,
      fixedWidth: fixedWidth,
      radiusMode: radiusMode,
      radius: radius,
      semanticsLabel: semanticsLabel,
    );
  }
}
