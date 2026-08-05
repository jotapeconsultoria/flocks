import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import 'flocks_states_controller.dart';

/// Assinatura do builder visual de [FlocksInteraction]: recebe o conjunto
/// atual de [WidgetState]s e devolve a aparência do componente.
typedef FlocksInteractionBuilder =
    Widget Function(BuildContext context, Set<WidgetState> states);

/// Primitivo de interação compartilhado do Flocks.
///
/// Centraliza foco (teclado), hover, pressed, disabled e selected sobre a
/// camada `widgets` (sem Material/Cupertino), alinhado à direção "RawButton"
/// do Flutter. Todo componente interativo do design system embrulha a sua
/// aparência com [FlocksInteraction] em vez de reimplementar
/// `bool _isHovered/_isPressed/_isFocused` na mão.
///
/// - **Teclado:** Enter/Space acionam [onPressed] quando o componente está
///   focado (atalhos próprios, independentes de `WidgetsApp`); Tab/Shift+Tab
///   navegam.
/// - **Focus ring:** [WidgetState.focused] entra apenas quando o modo de
///   highlight é `traditional` (teclado/mouse no desktop) e some em toque
///   (`FocusHighlightMode.touch`), via [FocusableActionDetector].
///
/// Exemplo:
/// ```dart
/// FlocksInteraction(
///   onPressed: onPressed,
///   builder: (context, states) {
///     final pressed = states.contains(WidgetState.pressed);
///     return AnimatedContainer(/* pinta a partir de `states` */);
///   },
/// )
/// ```
class FlocksInteraction extends StatefulWidget {
  /// Cria um [FlocksInteraction].
  const FlocksInteraction({
    required this.builder,
    this.onPressed,
    this.onDoubleTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    super.key,
  });

  /// Builder da aparência a partir do conjunto de [WidgetState]s.
  final FlocksInteractionBuilder builder;

  /// Acionado por tap/click e por Enter/Space quando focado.
  final VoidCallback? onPressed;

  /// Acionado por double-tap/duplo-clique (opcional). Quando presente, o
  /// [onPressed] de tap único é levemente adiado pelo framework para
  /// desambiguar do duplo.
  final VoidCallback? onDoubleTap;

  /// Acionado por long-press (opcional).
  final VoidCallback? onLongPress;

  /// Se o componente está habilitado. Quando `false` (ou sem handler), entra em
  /// [WidgetState.disabled] e ignora hover/pressed/focus.
  final bool enabled;

  /// Reporta [WidgetState.selected] (checkbox/radio/switch/tab ativos).
  final bool selected;

  /// Cursor do mouse. Default: [SystemMouseCursors.click] quando interativo,
  /// [SystemMouseCursors.forbidden] quando desabilitado (`enabled: false`) e
  /// [SystemMouseCursors.basic] quando apenas decorativo (habilitado, sem
  /// handler).
  final MouseCursor? mouseCursor;

  /// Nó de foco externo (opcional).
  final FocusNode? focusNode;

  /// Se deve receber foco automaticamente ao montar.
  final bool autofocus;

  /// Controlador de estados externo (opcional). Se ausente, um interno é criado
  /// e descartado com o widget.
  final FlocksStatesController? statesController;

  @override
  State<FlocksInteraction> createState() => _FlocksInteractionState();
}

class _FlocksInteractionState extends State<FlocksInteraction> {
  static const Map<ShortcutActivator, Intent> _activationShortcuts =
      <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      };

  FlocksStatesController? _internalController;
  FocusNode? _internalFocusNode;

  late final Map<Type, Action<Intent>> _actions = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _onActivate),
    ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
      onInvoke: _onActivate,
    ),
  };

  FlocksStatesController get _controller =>
      widget.statesController ??
      (_internalController ??= FlocksStatesController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  bool get _isInteractive =>
      widget.enabled &&
      (widget.onPressed != null ||
          widget.onDoubleTap != null ||
          widget.onLongPress != null);

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(FlocksInteraction oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    _internalController?.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  Object? _onActivate(Intent intent) {
    if (_isInteractive) widget.onPressed?.call();
    return null;
  }

  void _set(WidgetState state, bool present) =>
      _controller.update(state, present && _isInteractive);

  void _sync() {
    _controller
      ..update(WidgetState.disabled, !_isInteractive)
      ..update(WidgetState.selected, widget.selected);
    if (!_isInteractive) {
      _controller
        ..update(WidgetState.hovered, false)
        ..update(WidgetState.pressed, false)
        ..update(WidgetState.focused, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Desabilitado (`enabled: false`) mostra o cursor "proibido"; sem handler
    // mas habilitado é só decorativo e mantém o `basic`.
    final MouseCursor cursor =
        widget.mouseCursor ??
        (_isInteractive
            ? SystemMouseCursors.click
            : widget.enabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.forbidden);

    return FocusableActionDetector(
      enabled: _isInteractive,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      mouseCursor: cursor,
      shortcuts: _activationShortcuts,
      actions: _actions,
      onShowFocusHighlight: (bool value) => _set(WidgetState.focused, value),
      onShowHoverHighlight: (bool value) => _set(WidgetState.hovered, value),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _isInteractive ? widget.onPressed : null,
        onDoubleTap: _isInteractive ? widget.onDoubleTap : null,
        onLongPress: _isInteractive ? widget.onLongPress : null,
        onTapDown: _isInteractive
            ? (TapDownDetails _) => _set(WidgetState.pressed, true)
            : null,
        onTapUp: _isInteractive
            ? (TapUpDetails _) => _set(WidgetState.pressed, false)
            : null,
        onTapCancel: _isInteractive
            ? () => _set(WidgetState.pressed, false)
            : null,
        child: ValueListenableBuilder<Set<WidgetState>>(
          valueListenable: _controller,
          builder: (BuildContext context, Set<WidgetState> states, Widget? _) =>
              widget.builder(context, states),
        ),
      ),
    );
  }
}
