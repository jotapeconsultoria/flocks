@Tags(<String>['contrast'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Valida o contraste dos DEFAULTS dos indicadores de progresso (AppLinear /
// AppCircular / AppBorderProgress — todos compartilham o mesmo par) em cada
// marca × brilho — o cenário que o `primary` base quebrava no dark.
// Fill = `focusRing`, trilho = `surfaceContainer`.
//
// Requisitos (tier componente de UI = 3:1):
//  1. Preenchimento visível sobre a `surface`.
//  2. Preenchimento distinto do trilho (modo determinado, onde coexistem).
//  3. Trilho perceptível sobre a `surface` (ΔT de tom).
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}/${dark ? 'dark' : 'light'}';

      test('loadings default contrast · $label', () {
        final AppColorTheme t = AppThemeData.forBrand(
          brand,
          dark: dark,
        ).colorTheme;
        final Color fill = t.focusRing; // default de AppLinear/CircularLoading
        final Color track = t.surfaceContainer; // default do trilho

        expect(
          contrastRatio(fill, t.surface),
          greaterThanOrEqualTo(kUi),
          reason: '$label preenchimento vs surface < 3:1',
        );
        expect(
          contrastRatio(fill, track),
          greaterThanOrEqualTo(kUi),
          reason: '$label preenchimento vs trilho < 3:1',
        );
        expect(
          toneDelta(track, t.surface),
          greaterThanOrEqualTo(kMinSeparationLight),
          reason: '$label trilho imperceptível sobre a surface',
        );
      });
    }
  }
}
