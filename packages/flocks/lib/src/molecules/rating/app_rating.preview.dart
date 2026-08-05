import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_rating.dart';

// Previews nativos (Regra 5).

@Preview(name: 'AppRating • claro (somente-leitura, meia)')
Widget appRatingLight() => AppTheme(
  data: AppThemeData.light,
  child: const Center(child: AppRating(value: 3.5, allowHalf: true)),
);

@Preview(name: 'AppRating • escuro (input)')
Widget appRatingDark() => AppTheme(
  data: AppThemeData.dark,
  child: Center(child: AppRating(value: 4, iconSize: 32, onChanged: (_) {})),
);
