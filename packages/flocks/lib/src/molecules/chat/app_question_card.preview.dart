import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_question_card.dart';

// Previews nativos (Regra 5) — os três tipos de card de pergunta.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 380,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppQuestionCard.confirmation(
          title: 'Confirmação necessária — risco alto',
          subtitle: 'criar_geocerca',
          onConfirm: () {},
          onCancel: () {},
        ),
        const SizedBox(height: AppSpacings.s16),
        AppQuestionCard.singleChoice(
          title: 'Qual relatório você quer?',
          options: const <String>[
            'Resumo do dia',
            'Veículos parados',
            'Alertas',
          ],
          onSingleSelected: (_) {},
        ),
      ],
    ),
  ),
);

@Preview(name: 'AppQuestionCard • claro')
Widget appQuestionCardLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppQuestionCard • escuro')
Widget appQuestionCardDarkPreview() => _sample(AppThemeData.dark);
