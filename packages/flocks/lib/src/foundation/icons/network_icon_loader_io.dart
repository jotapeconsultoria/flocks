import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/theme.dart';
import 'icon_error_placeholder.dart';

/// Baixa e cacheia em disco (`flutter_cache_manager`). Devolve `null` quando a
/// busca falha — o chamador pinta o placeholder, sem propagar a exceção para a
/// árvore de widgets.
Future<Object?> fetchIconSource(String url) async {
  try {
    return await DefaultCacheManager().getSingleFile(url);
  } catch (error, stackTrace) {
    if (kDebugMode) {
      debugPrint('Não foi possível baixar o ícone: $url\n$error\n$stackTrace');
    }
    return null;
  }
}

/// Renderiza o arquivo já em disco.
Widget buildIconSvg(
  Object data, {
  required Color? color,
  required double size,
  required AppThemeData theme,
  required String url,
}) {
  final File file = data as File;
  if (!file.existsSync()) {
    return iconErrorPlaceholder(theme, size, color);
  }
  return SvgPicture.file(
    file,
    alignment: Alignment.center,
    colorFilter: color != null
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
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
}
