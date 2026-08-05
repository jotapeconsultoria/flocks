@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

import '../../../support/golden_matrix.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — só texto (determinístico). Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  goldenMatrixTest(
    'app_segmented_button',
    builder: (AppThemeData theme) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: <Widget>[
        AppSegmentedButton<int>(
          value: 0,
          onChanged: _noop,
          segments: const <AppSegment<int>>[
            AppSegment<int>(value: 0, label: 'Ruas'),
            AppSegment<int>(value: 1, label: 'Satélite'),
          ],
        ),
        AppSegmentedButton<int>(
          value: 1,
          onChanged: _noop,
          segments: const <AppSegment<int>>[
            AppSegment<int>(value: 0, label: 'Dia'),
            AppSegment<int>(value: 1, label: 'Semana'),
            AppSegment<int>(value: 2, label: 'Mês'),
          ],
        ),
        AppSegmentedButton<int>(
          value: 2,
          expanded: true,
          onChanged: _noop,
          segments: const <AppSegment<int>>[
            AppSegment<int>(value: 0, label: 'A'),
            AppSegment<int>(value: 1, label: 'B'),
            AppSegment<int>(value: 2, label: 'C'),
            AppSegment<int>(value: 3, label: 'D'),
          ],
        ),
      ],
    ),
  );
}

void _noop(int _) {}
