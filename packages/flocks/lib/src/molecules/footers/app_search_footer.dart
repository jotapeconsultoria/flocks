import 'package:flutter/services.dart' show TextInputAction;
import 'package:flutter/widgets.dart';

import '../../atoms/bars/app_bar_surface.dart';
import '../../foundation/app_overlay_bar.dart';
import '../../theme/theme.dart';
import '../../tokens/app_field_size.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../input/app_input.dart';

/// Margem flutuante da cápsula.
const double _kSearchFooterMargin = AppSpacings.s16;

/// Altura nominal da cápsula (para reservar padding sob glass sobreposto).
const double _kSearchFooterContentHeight = 56.0;

/// Rodapé de **busca flutuante** estilo iOS Notes: uma cápsula com um campo de
/// busca sobre o eixo de estilo [AppStyle] (incl. `glass`), com a safe-area
/// inferior e um [trailing] isolado opcional (ex.: um FAB de compor).
///
/// O campo é um [AppInput] "cru" (fundo transparente) — a **cápsula**
/// ([AppBarSurface]) carrega o estilo, evitando duplo-styling.
final class AppSearchFooter extends StatelessWidget with AppOverlayBar {
  /// Cria um [AppSearchFooter].
  const AppSearchFooter({
    this.controller,
    this.focusNode,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon = AppIconToken.search,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.trailing,
    this.style = AppStyle.filled,
    this.glass,
    this.radiusMode,
    this.size = AppFieldSize.m,
    this.enabled = true,
    super.key,
  });

  /// Controller do campo.
  final TextEditingController? controller;

  /// Foco do campo.
  final FocusNode? focusNode;

  /// Placeholder.
  final String? hintText;

  /// Callback de mudança de texto.
  final ValueChanged<String>? onChanged;

  /// Callback de submit (ação de busca).
  final ValueChanged<String>? onSubmitted;

  /// Ícone à esquerda. Default `search`.
  final String prefixIcon;

  /// Ícone à direita (ex.: microfone). `null` = nenhum.
  final String? suffixIcon;

  /// Toque no ícone à direita.
  final VoidCallback? onSuffixIconTap;

  /// Ação isolada à direita da cápsula (ex.: `AppFloatingButton` de compor).
  final Widget? trailing;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. Default
  /// `filled`.
  final AppStyle style;

  /// Override do eixo glass. `null` segue o global (`theme.glassTheme.enabled`).
  @override
  final bool? glass;

  /// Modo de forma da cápsula. Default circular (pílula).
  final AppRadiusMode? radiusMode;

  /// Tamanho do campo.
  final AppFieldSize size;

  /// Se habilitado.
  final bool enabled;

  @override
  AppStyle get barStyle => style;

  @override
  BarEdge get barEdge => BarEdge.top;

  @override
  double resolveBarExtent(BuildContext context) =>
      MediaQuery.viewPaddingOf(context).bottom +
      _kSearchFooterMargin +
      _kSearchFooterContentHeight;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final BorderRadius capsule = theme.radiusTheme.resolve(
      override: radiusMode ?? AppRadiusMode.circular,
    );

    final Widget field = AppInput(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      onSuffixIconTap: onSuffixIconTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      size: size,
      isDense: true,
      // Campo cru: a cápsula (AppBarSurface) carrega o eixo de estilo.
      style: AppStyle.filled,
      background: theme.colorTheme.transparent,
      textInputAction: TextInputAction.search,
    );

    final Widget capsuleBar = AppBarSurface(
      style: style,
      glass: resolveGlassOn(context),
      floating: true,
      contentEdge: BarEdge.top,
      borderRadius: capsule,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s8,
          vertical: AppSpacings.s8,
        ),
        child: field,
      ),
    );

    final Widget row = trailing == null
        ? capsuleBar
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: capsuleBar),
              const SizedBox(width: _kSearchFooterMargin),
              trailing!,
            ],
          );

    return Padding(
      padding: EdgeInsets.only(
        left: _kSearchFooterMargin,
        right: _kSearchFooterMargin,
        bottom: _kSearchFooterMargin + bottomInset,
      ),
      child: row,
    );
  }
}
