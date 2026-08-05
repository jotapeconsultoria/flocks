import 'package:flutter/widgets.dart';

import '../../atoms/badge/app_badge.dart';
import 'app_api_models.dart';

/// Largura reservada para o verbo numa lista de endpoints.
///
/// Cabe `OPTIONS` (o mais largo) no passo `s`. Reservar a coluna é o que faz os
/// paths começarem todos na mesma abscissa — sem isso a lista fica em escada e o
/// olho perde a varredura vertical.
const double kAppApiMethodBadgeWidth = 76.0;

/// Pílula do verbo HTTP, tingida pelo papel semântico do método.
///
/// Casca fina sobre o [AppBadge]: garante o rótulo em caixa alta, o papel de cor
/// certo por verbo ([AppApiMethod.badgeColor]) e — com [width] — uma coluna de
/// largura fixa para alinhar os paths numa lista.
///
/// ```dart
/// AppApiMethodBadge(AppApiMethod.post)
/// AppApiMethodBadge(AppApiMethod.get, width: null) // largura natural
/// ```
final class AppApiMethodBadge extends StatelessWidget {
  /// Cria um [AppApiMethodBadge].
  const AppApiMethodBadge(
    this.method, {
    this.size = AppBadgeSize.s,
    this.width = kAppApiMethodBadgeWidth,
    super.key,
  });

  /// Verbo exibido.
  final AppApiMethod method;

  /// Passo de tamanho da pílula. Default [AppBadgeSize.s] — a lista é densa.
  final AppBadgeSize size;

  /// Largura da coluna reservada. `null` = a pílula ocupa a largura natural.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final Widget badge = AppBadge(
      method.label,
      color: method.badgeColor,
      size: size,
    );
    if (width == null) return badge;
    return SizedBox(
      width: width,
      child: Align(alignment: AlignmentDirectional.centerStart, child: badge),
    );
  }
}
