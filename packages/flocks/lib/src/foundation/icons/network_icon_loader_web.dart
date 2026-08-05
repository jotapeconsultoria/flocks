import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/theme.dart';
import 'icon_error_placeholder.dart';

/// Na web não há cache próprio: quem busca e guarda é o browser, e o
/// `SvgPicture.network` já faz a requisição. A URL segue adiante como está.
Future<Object?> fetchIconSource(String url) => Future<Object?>.value(url);

/// Renderiza direto da rede.
Widget buildIconSvg(
  Object data, {
  required Color? color,
  required double size,
  required AppThemeData theme,
  required String url,
}) => SvgPicture.network(
  data as String,
  alignment: Alignment.center,
  colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
    if (kDebugMode) {
      debugPrint('Não foi possível desenhar o ícone: $url\n$error');
    }
    return iconErrorPlaceholder(theme, size, color);
  },
  excludeFromSemantics: true,
  fit: BoxFit.contain,
  height: size,
  width: size,
);
