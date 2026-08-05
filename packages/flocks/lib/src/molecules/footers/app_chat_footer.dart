import 'package:flutter/widgets.dart';

import '../../atoms/bars/app_bar_surface.dart';
import '../../foundation/app_overlay_bar.dart';
import '../../theme/theme.dart';
import '../../tokens/app_field_size.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../chat/app_chat_composer.dart';

/// Margem flutuante (quando [AppChatFooter.floating]).
const double _kChatFooterMargin = AppSpacings.s12;

/// Altura nominal (para reservar padding sob glass sobreposto).
const double _kChatFooterContentHeight = 96.0;

/// Rodapé de **chat**: envolve o [AppChatComposer] adicionando a safe-area
/// inferior (que o composer não trata) e o eixo de estilo de **barra**
/// [AppStyle] (incl. `glass`). Docked (full-bleed) por padrão; [floating]
/// destaca num painel arredondado.
///
/// O composer é forçado a `style: filled` (pílula opaca neutra) — a **barra**
/// ([AppBarSurface]) carrega o estilo, evitando duplo-styling. Para um compose
/// sem barra, use o [AppChatComposer] diretamente.
final class AppChatFooter extends StatelessWidget with AppOverlayBar {
  /// Cria um [AppChatFooter].
  const AppChatFooter({
    required this.controller,
    this.focusNode,
    this.hintText,
    this.enabled = true,
    this.busy = false,
    this.onSend,
    this.onStop,
    this.onChanged,
    this.onAttach,
    this.attachEnabled = true,
    this.attachmentLimit = 2,
    this.attachments = const <Widget>[],
    this.attachmentLayout = AppChatAttachmentLayout.wrap,
    this.modelLabel,
    this.modelOptions = const <String>[],
    this.onModelSelected,
    this.onModelTap,
    this.info,
    this.contextProgress,
    this.contextPopover,
    this.leading = const <Widget>[],
    this.trailing,
    this.maxLines = 5,
    this.size = AppFieldSize.s,
    this.style = AppStyle.filled,
    this.glass,
    this.radiusMode,
    this.floating = false,
    super.key,
  });

  /// Controller do campo de texto.
  final TextEditingController controller;

  /// Foco do campo.
  final FocusNode? focusNode;

  /// Placeholder.
  final String? hintText;

  /// Se habilitado.
  final bool enabled;

  /// Se está processando (mostra stop no lugar de send).
  final bool busy;

  /// Ação de enviar.
  final VoidCallback? onSend;

  /// Ação de parar (durante [busy]).
  final VoidCallback? onStop;

  /// Callback de mudança de texto.
  final ValueChanged<String>? onChanged;

  /// Ação de anexar.
  final VoidCallback? onAttach;

  /// Se pode anexar.
  final bool attachEnabled;

  /// Limite de anexos.
  final int attachmentLimit;

  /// Anexos exibidos acima do compose.
  final List<Widget> attachments;

  /// Layout dos anexos.
  final AppChatAttachmentLayout attachmentLayout;

  /// Rótulo do modelo (toolbar).
  final String? modelLabel;

  /// Opções de modelo.
  final List<String> modelOptions;

  /// Seleção de modelo.
  final ValueChanged<String>? onModelSelected;

  /// Toque no seletor de modelo.
  final VoidCallback? onModelTap;

  /// Widget de info (toolbar).
  final Widget? info;

  /// Progresso de contexto (0..1).
  final double? contextProgress;

  /// Popover de contexto.
  final Widget? contextPopover;

  /// Widgets à esquerda do compose.
  final List<Widget> leading;

  /// Widget à direita do compose.
  final Widget? trailing;

  /// Máx. de linhas do campo.
  final int maxLines;

  /// Tamanho do campo.
  final AppFieldSize size;

  /// Tratamento de container da barra ([AppStyle]) do render **não-glass**.
  /// Default `filled`.
  final AppStyle style;

  /// Override do eixo glass. `null` segue o global (`theme.glassTheme.enabled`).
  @override
  final bool? glass;

  /// Modo de forma (quando [floating]).
  final AppRadiusMode? radiusMode;

  /// Se destaca a barra num painel arredondado flutuante.
  final bool floating;

  @override
  AppStyle get barStyle => style;

  @override
  BarEdge get barEdge => BarEdge.top;

  @override
  double resolveBarExtent(BuildContext context) =>
      MediaQuery.viewPaddingOf(context).bottom +
      (floating ? _kChatFooterMargin : 0) +
      _kChatFooterContentHeight;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    final Widget composer = AppChatComposer(
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      enabled: enabled,
      busy: busy,
      onSend: onSend,
      onStop: onStop,
      onChanged: onChanged,
      onAttach: onAttach,
      attachEnabled: attachEnabled,
      attachmentLimit: attachmentLimit,
      attachments: attachments,
      attachmentLayout: attachmentLayout,
      modelLabel: modelLabel,
      modelOptions: modelOptions,
      onModelSelected: onModelSelected,
      onModelTap: onModelTap,
      info: info,
      contextProgress: contextProgress,
      contextPopover: contextPopover,
      leading: leading,
      trailing: trailing,
      maxLines: maxLines,
      size: size,
      // Forçado: a barra carrega o eixo de estilo (sem duplo-styling).
      style: AppStyle.filled,
    );

    final BorderRadius? barBR = floating
        ? theme.radiusTheme.resolve(
            override: radiusMode ?? AppRadiusMode.redondo,
          )
        : null;

    final Widget bar = AppBarSurface(
      style: style,
      glass: resolveGlassOn(context),
      floating: floating,
      contentEdge: BarEdge.top,
      borderRadius: barBR,
      outerSafeAreaInset: floating ? 0 : bottomInset,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s12,
          vertical: AppSpacings.s8,
        ),
        child: composer,
      ),
    );

    if (!floating) return bar;
    return Padding(
      padding: EdgeInsets.only(
        left: _kChatFooterMargin,
        right: _kChatFooterMargin,
        bottom: _kChatFooterMargin + bottomInset,
      ),
      child: bar,
    );
  }
}
