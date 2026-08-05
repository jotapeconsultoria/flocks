import 'package:flutter/widgets.dart';

/// Liga um [EditableText] cru aos gestos NATIVOS de seleção do Flutter
/// (tap = posiciona o caret, arrastar = seleciona, double-tap = palavra,
/// triple-tap = linha/parágrafo, botão direito = menu de contexto) — a mesma
/// máquina que o [TextField] usa internamente via
/// [TextSelectionGestureDetectorBuilder].
///
/// Os campos do design system constroem [EditableText] diretamente, que NÃO
/// possui gestos de seleção próprios; sem este mixin, apenas atalhos de teclado
/// (ex.: Ctrl+A) funcionam — não dá para selecionar com o mouse.
///
/// Uso:
/// ```dart
/// class _MyFieldState extends State<MyField>
///     with AppTextSelectionGestures<MyField> {
///   @override
///   bool get selectionEnabled => widget.enabled;
///
///   @override
///   Widget build(BuildContext context) {
///     return buildTextSelectionGestures(
///       child: EditableText(key: editableTextKey, /* ... */),
///     );
///   }
/// }
/// ```
mixin AppTextSelectionGestures<T extends StatefulWidget> on State<T>
    implements TextSelectionGestureDetectorBuilderDelegate {
  final GlobalKey<EditableTextState> _editableTextKey =
      GlobalKey<EditableTextState>();

  late final TextSelectionGestureDetectorBuilder _selectionGestureBuilder =
      TextSelectionGestureDetectorBuilder(delegate: this);

  /// Chave que deve ser passada ao [EditableText] embrulhado, para que o
  /// detector de gestos encontre o [RenderEditable] alvo.
  @override
  GlobalKey<EditableTextState> get editableTextKey => _editableTextKey;

  /// Force-press é um recurso de toque exclusivo do iOS; desligado para
  /// web/desktop.
  @override
  bool get forcePressEnabled => false;

  /// Se os gestos de seleção estão ativos. Sobrescreva para condicionar a
  /// estados como `enabled`/`readOnly`/campo de ação.
  @override
  bool get selectionEnabled => true;

  /// Embrulha [child] (que DEVE conter o [EditableText] com
  /// `key: editableTextKey`) com o detector nativo de gestos de seleção.
  Widget buildTextSelectionGestures({
    required Widget child,
    HitTestBehavior behavior = HitTestBehavior.translucent,
  }) => _selectionGestureBuilder.buildGestureDetector(
    behavior: behavior,
    child: child,
  );
}
