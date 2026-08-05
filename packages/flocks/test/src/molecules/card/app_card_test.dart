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

BoxDecoration _cardDeco(WidgetTester tester) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(AppCard),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );
  return box.decoration as BoxDecoration;
}

void main() {
  testWidgets('renderiza o child', (tester) async {
    await tester.pumpWidget(_host(const AppCard(child: AppText('conteúdo'))));
    expect(find.text('conteúdo'), findsOneWidget);
  });

  testWidgets('exige ao menos uma seção (assert)', (tester) async {
    expect(AppCard.new, throwsA(isA<AssertionError>()));
  });

  group('slots', () {
    testWidgets('header renderiza título/leading/trailing', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppCard(
            headerTitle: 'Localização',
            headerLeading: SizedBox(key: Key('lead'), width: 20, height: 20),
            headerTrailing: AppText('Ver no mapa'),
            child: AppText('corpo'),
          ),
        ),
      );
      expect(find.text('Localização'), findsOneWidget);
      expect(find.byKey(const Key('lead')), findsOneWidget);
      expect(find.text('Ver no mapa'), findsOneWidget);
      expect(find.text('corpo'), findsOneWidget);
    });

    testWidgets('card só com header (sem child) é válido', (tester) async {
      await tester.pumpWidget(_host(const AppCard(headerTitle: 'Só header')));
      expect(find.text('Só header'), findsOneWidget);
    });

    testWidgets('footer renderiza', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppCard(footer: AppText('rodapé'), child: AppText('corpo')),
        ),
      );
      expect(find.text('rodapé'), findsOneWidget);
    });
  });

  group('showDividers', () {
    testWidgets('false (default) = sem AppDivider', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppCard(
            headerTitle: 'H',
            footer: AppText('rodapé'),
            child: AppText('corpo'),
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AppCard),
          matching: find.byType(AppDivider),
        ),
        findsNothing,
      );
    });

    testWidgets('true com header+child+footer = 2 divisórias', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppCard(
            showDividers: true,
            headerTitle: 'H',
            footer: AppText('rodapé'),
            child: AppText('corpo'),
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AppCard),
          matching: find.byType(AppDivider),
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('true com só child = nenhuma divisória', (tester) async {
      await tester.pumpWidget(
        _host(const AppCard(showDividers: true, child: AppText('corpo'))),
      );
      expect(
        find.descendant(
          of: find.byType(AppCard),
          matching: find.byType(AppDivider),
        ),
        findsNothing,
      );
    });
  });

  testWidgets('accentColor aplica na borda (estilo outlined)', (tester) async {
    const Color accent = Color(0xFF00FF00);
    await tester.pumpWidget(
      _host(
        const AppCard(
          style: AppStyle.outlined,
          accentColor: accent,
          child: AppText('x'),
        ),
      ),
    );
    final BoxDecoration deco = _cardDeco(tester);
    expect((deco.border! as Border).top.color, accent);
    expect(deco.boxShadow, isNull); // outlined não tem sombra
  });

  testWidgets('style: elevated = só sombra, sem borda', (tester) async {
    await tester.pumpWidget(
      _host(const AppCard(style: AppStyle.elevated, child: AppText('x'))),
    );
    final BoxDecoration deco = _cardDeco(tester);
    expect(deco.border, isNull);
    expect(deco.boxShadow, isNotNull);
  });

  // Contraste do default nas 2 marcas × 2 brilhos (sem renderizar).
  group('contraste (jotape/zxtrack × claro/escuro)', () {
    final List<AppBrandConfig> brands = <AppBrandConfig>[
      jotapeBrand,
      zxtrackBrand,
    ];
    for (final AppBrandConfig brand in brands) {
      for (final bool dark in <bool>[false, true]) {
        final String bl = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';
        final AppColorTheme c = dark
            ? brand.toDarkColorTheme()
            : brand.toLightColorTheme();
        test('borda outline ≥ 3:1 e conteúdo ≥ AA · $bl', () {
          expect(
            contrastRatio(c.outline, c.surface) >= kUi,
            isTrue,
            reason: 'borda outline sobre surface < 3:1 em $bl',
          );
          expect(
            meetsWcag(c.onSurface, c.surfaceContainer),
            isTrue,
            reason: 'conteúdo onSurface sobre surfaceContainer < 4.5 em $bl',
          );
        });
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_card' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
