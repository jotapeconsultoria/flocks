import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../tokens/tokens.dart';
import '../popover/popover.dart';

/// Ícone de informação clicável de um campo do design system: abre um
/// [AppPopover] (no clique) com o [info] livre do dev. Único ponto que constrói
/// o ícone de info — o clique/interação já vêm do [AppPopover]. Use o
/// [iconSize] do campo (`size.iconSize`) para casar com prefixo/sufixo.
Widget appFieldInfo({
  required Widget info,
  required Color? color,
  required double iconSize,
  String? semanticLabel,
}) {
  return AppPopover(
    trigger: AppIcon(
      AppIconToken.infoCircle,
      customSize: iconSize,
      color: color,
      semanticLabel: semanticLabel,
    ),
    child: info,
  );
}

/// Label de um campo do design system (compartilhado por [AppInput] e pelos
/// triggers de dropdown/picker).
///
/// Renderiza o rótulo com o [style] já colorido por estado (repouso/foco/erro/
/// desabilitado). Quando [info] é passado, adiciona um ícone de informação
/// (via [appFieldInfo]) **alinhado à direita** da mesma row do label — no
/// mesmo tamanho do sufixo ([infoIconSize]) e herdando a cor do label.
Widget appFieldLabel({
  required String label,
  required TextStyle style,
  required double infoIconSize,
  Widget? info,
}) {
  final Widget text = AppText(
    label,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: style,
  );
  if (info == null) return text;
  return Row(
    children: <Widget>[
      Expanded(child: text),
      const SizedBox(width: AppSpacings.s8),
      appFieldInfo(
        info: info,
        color: style.color,
        iconSize: infoIconSize,
        semanticLabel: label,
      ),
    ],
  );
}
