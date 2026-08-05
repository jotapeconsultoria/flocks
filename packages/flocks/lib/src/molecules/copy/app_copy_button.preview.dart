import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_copy_button.dart';

// Previews nativos (Regra 5). O estado copiado (check + "Copiado!") só existe
// após o clique, em runtime; aqui mostramos o repouso, claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const AppCopyButton(value: '860123456789012'),
);

@Preview(name: 'AppCopyButton • claro')
Widget appCopyButtonLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppCopyButton • escuro')
Widget appCopyButtonDarkPreview() => _sample(AppThemeData.dark);
