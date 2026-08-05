import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => _hostWith(AppThemeData.light, child);

Widget _hostWith(AppThemeData data, Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: data,
      child: Center(child: child),
    ),
  ),
);

// Decoração do envelope: o `Container` mais externo do tile — carrega o eixo
// AppStyle (fundo/borda/sombra) + o raio. O cabeçalho usa um `AnimatedContainer`
// separado (overlay + anel de foco), então filtramos pelo Container externo.
BoxDecoration _envelopeDecoration(WidgetTester tester) {
  final Container c = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(AppExpansionTile),
          matching: find.byType(Container),
        )
        .first,
  );
  return c.decoration! as BoxDecoration;
}

void main() {
  testWidgets('tap expande e revela os filhos', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 320,
          child: AppExpansionTile(
            title: 'Título',
            children: <Widget>[AppText('conteúdo oculto')],
          ),
        ),
      ),
    );
    // Colapsado: AppExpand mantém heightFactor 0, child ainda existe mas medindo 0.
    await tester.tap(find.text('Título'));
    await tester.pumpAndSettle();
    expect(find.text('conteúdo oculto'), findsOneWidget);
  });

  testWidgets('onExpansionChanged dispara com o novo estado', (tester) async {
    bool? last;
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 320,
          child: AppExpansionTile(
            title: 'T',
            onExpansionChanged: (v) => last = v,
            children: const <Widget>[AppText('x')],
          ),
        ),
      ),
    );
    await tester.tap(find.text('T'));
    await tester.pumpAndSettle();
    expect(last, isTrue);
  });

  testWidgets('disabled não expande', (tester) async {
    bool? last;
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 320,
          child: AppExpansionTile(
            title: 'T',
            enabled: false,
            onExpansionChanged: (v) => last = v,
            children: const <Widget>[AppText('x')],
          ),
        ),
      ),
    );
    await tester.tap(find.text('T'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(last, isNull);
  });

  testWidgets('cabeçalho expõe role de botão', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 320,
          child: AppExpansionTile(title: 'T', children: <Widget>[AppText('x')]),
        ),
      ),
    );
    final s = tester.getSemantics(find.byType(FlocksInteraction));
    expect(s.flagsCollection.isButton, isTrue);
  });

  testWidgets('reduce-motion: sem frames pendentes', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: AppTheme(
            data: AppThemeData.light,
            child: const Center(
              child: SizedBox(
                width: 320,
                child: AppExpansionTile(
                  title: 'T',
                  initiallyExpanded: true,
                  children: <Widget>[AppText('x')],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppExpansionTile), findsOneWidget);
  });

  // Eixos globais AppStyle/AppRadius aplicados ao envelope (card inteiro).
  // Lê a decoração-alvo do Container externo (não a interpolação do header).
  group('eixos AppStyle/AppRadius (envelope do card)', () {
    testWidgets('filled → fundo surfaceContainer, sem borda/sombra', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 320,
            child: AppExpansionTile(
              title: 'T',
              style: AppStyle.filled,
              children: <Widget>[AppText('x')],
            ),
          ),
        ),
      );
      final BoxDecoration deco = _envelopeDecoration(tester);
      expect(deco.color, AppThemeData.light.colorTheme.surfaceContainer);
      expect(deco.border, isNull);
      expect(deco.boxShadow, isNull);
    });

    testWidgets('outlined → transparente + borda, sem sombra', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 320,
            child: AppExpansionTile(
              title: 'T',
              style: AppStyle.outlined,
              children: <Widget>[AppText('x')],
            ),
          ),
        ),
      );
      final BoxDecoration deco = _envelopeDecoration(tester);
      expect(deco.color, isNull);
      expect(deco.border, isNotNull);
      expect(deco.boxShadow, isNull);
    });

    testWidgets('elevated → sombra simétrica + fundo surfaceContainer', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 320,
            child: AppExpansionTile(
              title: 'T',
              style: AppStyle.elevated,
              children: <Widget>[AppText('x')],
            ),
          ),
        ),
      );
      final BoxDecoration deco = _envelopeDecoration(tester);
      expect(deco.boxShadow, isNotNull);
      expect(deco.border, isNull);
      expect(deco.color, AppThemeData.light.colorTheme.surfaceContainer);
    });

    testWidgets('style explícito vence o global', (tester) async {
      final AppThemeData data = AppThemeData.light.copyWith(
        styleTheme: const AppStyleTheme(style: AppStyle.elevated),
      );
      await tester.pumpWidget(
        _hostWith(
          data,
          const SizedBox(
            width: 320,
            child: AppExpansionTile(
              title: 'T',
              style: AppStyle.outlined,
              children: <Widget>[AppText('x')],
            ),
          ),
        ),
      );
      final BoxDecoration deco = _envelopeDecoration(tester);
      expect(deco.border, isNotNull);
      expect(deco.boxShadow, isNull);
    });

    testWidgets('radiusMode reto → cantos retos (raio 0)', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 320,
            child: AppExpansionTile(
              title: 'T',
              radiusMode: AppRadiusMode.reto,
              children: <Widget>[AppText('x')],
            ),
          ),
        ),
      );
      expect(_envelopeDecoration(tester).borderRadius, BorderRadius.zero);
    });

    testWidgets('radiusMode circular → raio dedicado (não vira oval)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 320,
            child: AppExpansionTile(
              title: 'T',
              radiusMode: AppRadiusMode.circular,
              children: <Widget>[AppText('x')],
            ),
          ),
        ),
      );
      // `circular` não satura em pílula/oval (que cortaria o conteúdo perto dos
      // cantos): pousa no raio dedicado do tile, pronunciado mas seguro.
      final BorderRadius br =
          _envelopeDecoration(tester).borderRadius! as BorderRadius;
      expect(br.topLeft.x, kTileCircularRadius);
    });
  });

  // Contraste do conteúdo (título/chevron) nas 2 marcas × 2 brilhos.
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
        test('conteúdo habilitado/desabilitado · $bl', () {
          expect(
            meetsWcag(c.onSurface, c.surface),
            isTrue,
            reason: 'título onSurface sobre surface < 4.5 em $bl',
          );
          // Sob filled/elevated o card preenche com surfaceContainer: o título
          // passa a se apoiar nele, então o contraste também precisa valer lá.
          expect(
            meetsWcag(c.onSurface, c.surfaceContainer),
            isTrue,
            reason: 'título onSurface sobre surfaceContainer < 4.5 em $bl',
          );
          final Color disabled = mutedForDisabled(c.onSurface, c.surface);
          expect(
            contrastRatio(disabled, c.surface) >= kDisabledMinRatio,
            isTrue,
            reason: 'desabilitado imperceptível em $bl',
          );
          expect(
            toneDelta(disabled, c.onSurface) >= kDisabledDistinctionTone,
            isTrue,
            reason: 'desabilitado não distinto em $bl',
          );
        });
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) =>
            m.id == 'app_expansion_tile' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
