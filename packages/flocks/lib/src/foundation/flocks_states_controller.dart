import 'package:flutter/widgets.dart';

/// Controlador de estados de interação do Flocks.
///
/// Fino wrapper sobre [WidgetStatesController] (camada `widgets`, sem
/// Material/Cupertino) com getters de conveniência. Usado internamente por
/// [FlocksInteraction] e exposto para componentes que precisem dirigir os
/// estados manualmente.
class FlocksStatesController extends WidgetStatesController {
  /// Cria o controlador, opcionalmente com um conjunto inicial de estados.
  FlocksStatesController([super.value]);

  /// Se [WidgetState.hovered] está presente.
  bool get isHovered => value.contains(WidgetState.hovered);

  /// Se [WidgetState.focused] está presente.
  bool get isFocused => value.contains(WidgetState.focused);

  /// Se [WidgetState.pressed] está presente.
  bool get isPressed => value.contains(WidgetState.pressed);

  /// Se [WidgetState.selected] está presente.
  bool get isSelected => value.contains(WidgetState.selected);

  /// Se [WidgetState.disabled] está presente.
  bool get isDisabled => value.contains(WidgetState.disabled);
}
