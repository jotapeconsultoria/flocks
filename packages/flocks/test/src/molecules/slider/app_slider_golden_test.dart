@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

import '../../../support/golden_matrix.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} via goldenMatrixTest. Prancheta:
// rest a 50% · at-min · at-max · por passo com rótulo · desabilitado.
// (dragging/focused são interativos — fora de golden.) Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  goldenMatrixTest(
    'app_slider',
    builder: (AppThemeData theme) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppSlider(value: 0.5, onChanged: (_) {}),
        AppSlider(value: 0, onChanged: (_) {}),
        AppSlider(value: 1, onChanged: (_) {}),
        AppSlider(
          value: 42,
          min: 1,
          max: 60,
          step: 1,
          showValue: true,
          formatValue: (double v) => '${v.round()}/min',
          onChanged: (_) {},
        ),
        const AppSlider(value: 0.35, onChanged: null),
      ],
    ),
  );
}
