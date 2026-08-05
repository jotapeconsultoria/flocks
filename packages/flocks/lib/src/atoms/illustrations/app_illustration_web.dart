import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/theme.dart';
import 'app_illustration_color_mapper.dart';

Future<Object> getCachedIllustrationSource(String url) => Future.value(url);

Widget buildIllustrationSvg(
  BuildContext context,
  Object data,
  String illustration,
  Color accentColor,
  Color baseColor,
  double size,
  AppThemeData theme,
) {
  final url = data as String;
  return SvgPicture.network(
    url,
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
    },
  );
}
