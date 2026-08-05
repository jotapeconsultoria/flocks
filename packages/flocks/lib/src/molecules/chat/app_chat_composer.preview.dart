import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import 'app_chat_composer.dart';

// Previews nativos (Regra 5) — o composer com texto, botão de anexo e enviar.
// O controlador é efêmero (previews não têm ciclo de vida de estado).

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 380,
    child: AppChatComposer(
      controller: TextEditingController(text: 'Quais veículos estão parados?'),
      hintText: 'Pergunte o que quiser…',
      onSend: () {},
      onAttach: () {},
      modelLabel: 'Atlas',
      onModelTap: () {},
      info: const AppText('Shift+Enter quebra a linha.'),
      contextProgress: 0.35,
    ),
  ),
);

@Preview(name: 'AppChatComposer • claro')
Widget appChatComposerLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppChatComposer • escuro')
Widget appChatComposerDarkPreview() => _sample(AppThemeData.dark);
