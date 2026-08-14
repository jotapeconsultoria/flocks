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

  testWidgets('sem título renderiza uma linha só, em onSurface', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const AppSnackbar(description: 'Salvo')));
    expect(find.text('Salvo'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AppSnackbar),
        matching: find.byType(AppText),
      ),
      findsOneWidget,
    );
    // Nenhum respiro de título na subárvore.
    final Iterable<SizedBox> gaps = tester.widgetList<SizedBox>(
      find.descendant(
        of: find.byType(AppSnackbar),
        matching: find.byType(SizedBox),
      ),
    );
    expect(gaps.map((SizedBox b) => b.height), isNot(contains(AppSpacings.s4)));
    // A mensagem única leva a cor primária do card.
    final AppText msg = tester.widget<AppText>(
      find.widgetWithText(AppText, 'Salvo'),
    );
    expect(msg.style?.color, AppThemeData.light.colorTheme.onSurface);
  });

  testWidgets('com título a descrição segue no neutro s700', (tester) async {
    await tester.pumpWidget(
      _host(const AppSnackbar(title: 'T', description: 'D')),
    );
    expect(
      find.descendant(
        of: find.byType(AppSnackbar),
        matching: find.byType(AppText),
      ),
      findsNWidgets(2),
    );
    final AppText msg = tester.widget<AppText>(
      find.widgetWithText(AppText, 'D'),
    );
    expect(msg.style?.color, AppThemeData.light.colorTheme.neutralPrimary.s700);
  });

  testWidgets('sem título o ícone centraliza; com título alinha ao topo', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const AppSnackbar(description: 'Salvo')));
    Row row = tester.widget<Row>(
      find.descendant(of: find.byType(AppSnackbar), matching: find.byType(Row)),
    );
    expect(row.crossAxisAlignment, CrossAxisAlignment.center);

    await tester.pumpWidget(
      _host(const AppSnackbar(title: 'T', description: 'Salvo')),
    );
    row = tester.widget<Row>(
      find.descendant(of: find.byType(AppSnackbar), matching: find.byType(Row)),
    );
    expect(row.crossAxisAlignment, CrossAxisAlignment.start);
  });

  testWidgets('type omitido resolve para info', (tester) async {
    await tester.pumpWidget(_host(const AppSnackbar(description: 'Salvo')));
    final AppIcon icon = tester.widget<AppIcon>(
      find.descendant(
        of: find.byType(AppSnackbar),
        matching: find.byType(AppIcon),
      ),
    );
    expect(icon.icon, AppIconToken.infoCircle);
  });

  testWidgets('warning resolve o swatch e o ícone do papel de aviso', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppSnackbar(description: 'Prazo', type: AppSnackbarType.warning),
      ),
    );
    final AppIcon icon = tester.widget<AppIcon>(
      find.descendant(
        of: find.byType(AppSnackbar),
        matching: find.byType(AppIcon),
      ),
    );
    expect(icon.icon, AppIconToken.alert);
    expect(
      AppSnackbarType.warning.resolve(AppThemeData.light.colorTheme),
      AppThemeData.light.colorTheme.warning,
    );
  });

  testWidgets('liveRegion vale também sem título', (tester) async {
    await tester.pumpWidget(_host(const AppSnackbar(description: 'Salvo')));
    final s = tester.getSemantics(find.byType(AppSnackbar));
    expect(s.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('descrição vazia dispara o assert', (tester) async {
    expect(() => AppSnackbar(description: ''), throwsAssertionError);
  });

  testWidgets('showAppSnackbar aceita só description e respeita position', (
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
                        description: 'Uma frase',
                        position: AppOverlayPosition.topLeft,
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
    await tester.pumpAndSettle();
    expect(find.text('Uma frase'), findsOneWidget);

    // topLeft: o card encosta no canto superior esquerdo (margem do overlay).
    final Rect card = tester.getRect(find.byType(AppSnackbar));
    final Size screen = tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(card.top, lessThan(screen.height / 4));
    expect(card.left, lessThan(screen.width / 4));
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
