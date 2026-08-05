@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Popover ABERTO (balão + seta), matriz {filled,outlined,elevated} × {claro,
// escuro} × {jotape,zxtrack}. Sem ícone de rede no painel → determinístico.
// Gerar: flutter test --update-goldens --tags golden
Widget _host(AppThemeData data, AppStyle style) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: data,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (BuildContext context) => ColoredBox(
              color: data.colorTheme.surface,
              child: Center(
                child: AppPopover(
                  style: style,
                  title: 'Detalhes',
                  maxWidth: 240,
                  trigger: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Abrir'),
                  ),
                  child: const Text(
                    'O score combina frenagens, curvas e velocidade média.',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      // Eixo glass (frost via wrapper) fica fora desta matriz de `AppStyle` — é
      // um eixo à parte, coberto por outros testes.
      for (final AppStyle style in AppStyle.values) {
        final String label =
            '${brand.clientSlug}_${dark ? 'dark' : 'light'}_${style.name}';

        testWidgets('AppPopover golden · $label', (tester) async {
          await tester.binding.setSurfaceSize(const Size(420, 380));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await tester.pumpWidget(
            _host(AppThemeData.forBrand(brand, dark: dark), style),
          );
          await tester.tap(find.text('Abrir'));
          await tester.pumpAndSettle();

          await expectLater(
            find.byType(Overlay),
            matchesGoldenFile('goldens/app_popover_$label.png'),
          );
        });
      }
    }
  }
}
