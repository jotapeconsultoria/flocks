@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Menu ABERTO (painel de ações), matriz {filled,outlined,elevated} × {claro,
// escuro} × {jotape,zxtrack}. Sem ícones (de rede) → determinístico; prova o
// eixo AppStyle do painel (default próprio elevated).
// Gerar: flutter test --update-goldens --tags golden
void _noop() {}

Widget _host(AppThemeData data, AppStyle style) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      // As duas marcas da matriz têm o eixo glass LIGADO, e `AppThemeData.light`
      // herda isso de `AppBrand.current` — sem desligar aqui, o painel renderiza
      // vidro e esta matriz deixaria de medir o que diz medir (o eixo AppStyle).
      data: data.copyWith(glassTheme: const AppGlassTheme(enabled: false)),
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (BuildContext context) => ColoredBox(
              color: data.colorTheme.surface,
              child: Center(
                child: AppMenu(
                  style: style,
                  trigger: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Abrir'),
                  ),
                  entries: const <AppMenuEntry>[
                    AppMenuItem(label: 'Editar', onPressed: _noop),
                    AppMenuItem(label: 'Duplicar', onPressed: _noop),
                    AppMenuDivider(),
                    AppMenuSection(
                      title: 'Exportar',
                      items: <AppMenuItem>[
                        AppMenuItem(label: 'CSV', onPressed: _noop),
                        AppMenuItem(label: 'PDF', onPressed: _noop),
                      ],
                    ),
                    AppMenuItem(
                      label: 'Excluir',
                      danger: true,
                      onPressed: _noop,
                    ),
                  ],
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

        testWidgets('AppMenu golden · $label', (tester) async {
          await tester.binding.setSurfaceSize(const Size(360, 440));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await tester.pumpWidget(
            _host(AppThemeData.forBrand(brand, dark: dark), style),
          );
          await tester.tap(find.text('Abrir'));
          await tester.pumpAndSettle();

          await expectLater(
            find.byType(Overlay),
            matchesGoldenFile('goldens/app_menu_$label.png'),
          );
        });
      }
    }
  }
}
