import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/theme.dart';
import 'app_illustration_color_mapper.dart';

Future<Object> getCachedIllustrationSource(String url) =>
    DefaultCacheManager().getSingleFile(url);

Widget buildIllustrationSvg(
  BuildContext context,
  Object data,
  String illustration,
  Color accentColor,
  Color baseColor,
  double size,
  AppThemeData theme,
) {
  final file = data as File;
  if (!file.existsSync()) {
    return _buildErrorWidget(theme, size);
  }
  try {
    return SvgPicture.file(
      file,
      colorMapper: AppIllustrationColorMapper(
        accentColor: accentColor,
        baseColor: baseColor,
      ),
      width: size,
      height: size,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stackTrace) {
        if (kDebugMode) {
          debugPrint(
            'Unable to load the illustration: $illustration\nError: $error',
          );
        }
        return _buildErrorWidget(theme, size);
      },
    );
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint(
        'Unable to load the illustration: $illustration\nError: $e\n$stackTrace',
      );
    }
    return _buildErrorWidget(theme, size);
  }
}

Widget _buildErrorWidget(AppThemeData theme, double size) {
  return SizedBox(
    width: size,
    height: size,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorTheme.danger,
        borderRadius: BorderRadius.circular(size),
      ),
    ),
  );
}
