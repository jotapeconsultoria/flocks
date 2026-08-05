import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_typing_indicator.dart';

// Previews nativos (Regra 5) — os três pontinhos "digitando…". No previewer a
// animação corre; sob reduce-motion os pontos ficam estáticos.

Widget _sample(AppThemeData data) =>
    AppTheme(data: data, child: const AppTypingIndicator());

@Preview(name: 'AppTypingIndicator • claro')
Widget appTypingIndicatorLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppTypingIndicator • escuro')
Widget appTypingIndicatorDarkPreview() => _sample(AppThemeData.dark);
