@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Estados de interação do AppAvatar clicável (neutral/hovered/pressed/focused/
// dragged) forçados por um FlocksStatesController semeado. Anel de foco e realce
// são brand-aware → matriz {jotape,zxtrack} × {claro,escuro}. Animações LIGADAS
// (motion on) p/ mostrar a escala do press/dragged; estados semeados já nascem no
// alvo (sem tween inicial), então é determinístico. Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  const List<(String, Set<WidgetState>)> states = <(String, Set<WidgetState>)>[
    ('neutral', <WidgetState>{}),
    ('hovered', <WidgetState>{WidgetState.hovered}),
    ('pressed', <WidgetState>{WidgetState.pressed}),
    ('focused', <WidgetState>{WidgetState.focused}),
    ('dragged', <WidgetState>{WidgetState.dragged}),
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('Avatar states golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        final List<FlocksStatesController> controllers =
            <FlocksStatesController>[
              for (final (_, Set<WidgetState> s) in states)
                FlocksStatesController(s),
            ];
        for (final FlocksStatesController c in controllers) {
          addTearDown(c.dispose);
        }

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: data.colorTheme.surface,
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 24,
                    children: <Widget>[
                      for (int i = 0; i < states.length; i++)
                        AppAvatar(
                          size: AppAvatarSize.l,
                          fallback: 'JP',
                          onTap: () {},
                          statesController: controllers[i],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/avatar_states_$label.png'),
        );
      });
    }
  }
}
