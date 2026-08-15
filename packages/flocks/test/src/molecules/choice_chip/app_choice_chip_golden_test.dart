@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

import '../../../support/golden_matrix.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} via goldenMatrixTest. Prancheta:
// selecionado/não-selecionado nos TRÊS AppStyle (o Risco 2 do outlined — a
// borda do selecionado é a cor do próprio fill), com contador, com ícone e
// desabilitado. Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  goldenMatrixTest(
    'app_choice_chip',
    builder: (AppThemeData theme) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final AppStyle style in AppStyle.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacings.s8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacings.s8,
              children: <Widget>[
                AppChoiceChip(
                  label: 'Novos',
                  count: 8,
                  selected: true,
                  style: style,
                  onChanged: (_) {},
                ),
                AppChoiceChip(
                  label: 'Abertas',
                  count: 3,
                  selected: false,
                  style: style,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacings.s8,
          children: <Widget>[
            AppChoiceChip(
              label: 'Favoritas',
              icon: AppIconToken.check,
              selected: true,
              onChanged: (_) {},
            ),
            const AppChoiceChip(
              label: 'Arquivadas',
              selected: false,
              onChanged: null,
            ),
          ],
        ),
      ],
    ),
  );
}
