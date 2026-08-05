import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

BoxDecoration _decoration(WidgetTester tester) =>
    tester
            .widgetList<DecoratedBox>(
              find.descendant(
                of: find.byType(AppSnackbar),
                matching: find.byType(DecoratedBox),
              ),
            )
            .first
            .decoration
        as BoxDecoration;

void main() {
  testWidgets('AppSnackbar renderiza título/descrição e é liveRegion', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppSnackbar(
          title: 'Salvo',
          description: 'Tudo certo.',
          type: AppSnackbarType.success,
        ),
      ),
    );
    expect(find.text('Salvo'), findsOneWidget);
    expect(find.text('Tudo certo.'), findsOneWidget);
    final s = tester.getSemantics(find.byType(AppSnackbar));
    expect(s.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('style: default elevated tem sombra; outlined tem borda', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppSnackbar(
          title: 'T',
          description: 'D',
          type: AppSnackbarType.info,
        ),
      ),
    );
    expect(_decoration(tester).boxShadow, isNotEmpty);

    await tester.pumpWidget(
      _host(
        const AppSnackbar(
          title: 'T',
          description: 'D',
          type: AppSnackbarType.info,
          style: AppStyle.outlined,
        ),
      ),
    );
    expect(_decoration(tester).border, isNotNull);
  });

  testWidgets('showAppSnackbar insere e substitui a instância anterior', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: AppTheme(
            data: AppThemeData.light,
            child: Overlay(
              initialEntries: <OverlayEntry>[
                OverlayEntry(
                  builder: (BuildContext context) => Center(
                    child: GestureDetector(
                      onTap: () => showAppSnackbar(
                        context: context,
                        title: 'Primeira',
                        description: 'msg',
                        type: AppSnackbarType.info,
                        duration: const Duration(seconds: 30),
                      ),
                      child: const Text('Mostrar'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mostrar'));
    await tester.pump();
    expect(find.text('Primeira'), findsOneWidget);

    // Segunda substitui a primeira.
    await tester.tap(find.text('Mostrar'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Primeira'), findsOneWidget); // única instância
  });

  test('AppSnackbar está no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_snackbar' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
