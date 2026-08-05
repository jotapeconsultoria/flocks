import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/bars/bar_preview_scene.dart';
import '../../theme/theme.dart';
import 'app_chat_footer.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: barPreviewScene(
    footer: AppChatFooter(
      controller: _previewController,
      hintText: 'Pergunte alguma coisa…',
      onSend: _noop,
      onStop: _noop,
      onAttach: _noop,
    ),
  ),
);

void _noop() {}
final TextEditingController _previewController = TextEditingController();

@Preview(name: 'AppChatFooter • claro')
Widget appChatFooterLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppChatFooter • escuro')
Widget appChatFooterDarkPreview() => _sample(AppThemeData.dark);
