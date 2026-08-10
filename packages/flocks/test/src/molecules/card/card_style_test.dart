import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Eixo de estilo/forma do AppCard. Como os demais containers do DS, o STYLE
// **segue o global** `styleTheme` (default), sobrescrevível por `style`. A FORMA
// segue o global `radiusTheme`, sobrescrevível por `radiusMode`/`radius`. Lê a
// decoração do DecoratedBox raiz sob o AppCard.

Widget _host(AppThemeData data, Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: data,
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
  group('AppCard · eixo AppStyle (segue o global)', () {
    testWidgets('default segue o global filled (sem sombra/borda)', (
      tester,
    ) async {
      // AppThemeData.light tem styleTheme default = filled.
      await tester.pumpWidget(
        _host(AppThemeData.light, const AppCard(child: Text('x'))),
      );
      final BoxDecoration deco = _cardDeco(tester);
      expect(deco.boxShadow, isNull);
      expect(deco.border, isNull);
    });

    testWidgets('default segue o global outlined (borda, sem sombra)', (
      tester,
    ) async {
      final AppThemeData data = AppThemeData.light.copyWith(
        styleTheme: const AppStyleTheme(style: AppStyle.outlined),
      );
      await tester.pumpWidget(_host(data, const AppCard(child: Text('x'))));
      final BoxDecoration deco = _cardDeco(tester);
      expect(deco.border, isNotNull);
      expect(deco.boxShadow, isNull);
    });

    testWidgets('default segue o global elevated (sombra, sem borda)', (
      tester,
    ) async {
      final AppThemeData data = AppThemeData.light.copyWith(
        styleTheme: const AppStyleTheme(style: AppStyle.elevated),
      );
      await tester.pumpWidget(_host(data, const AppCard(child: Text('x'))));
      final BoxDecoration deco = _cardDeco(tester);
      expect(deco.boxShadow, isNotNull);
      expect(deco.border, isNull);
    });

    testWidgets('style: elevated vence o global filled', (tester) async {
      await tester.pumpWidget(
        _host(
          AppThemeData.light, // global filled
          const AppCard(style: AppStyle.elevated, child: Text('x')),
        ),
      );
      final BoxDecoration deco = _cardDeco(tester);
      expect(deco.boxShadow, isNotNull);
      expect(deco.border, isNull);
    });

    testWidgets('style: outlined = borda, sem sombra', (tester) async {
      await tester.pumpWidget(
        _host(
          AppThemeData.light,
          const AppCard(style: AppStyle.outlined, child: Text('x')),
        ),
      );
      final BoxDecoration deco = _cardDeco(tester);
      expect(deco.border, isNotNull);
      expect(deco.boxShadow, isNull);
    });
  });

  group('AppCard · forma segue o radius global', () {
    testWidgets('radiusMode: reto = raio zero', (tester) async {
      await tester.pumpWidget(
        _host(
          AppThemeData.light,
          const AppCard(radiusMode: AppRadiusMode.reto, child: Text('x')),
        ),
      );
      final BorderRadius r = _cardDeco(tester).borderRadius! as BorderRadius;
      expect(r.topLeft.x, 0);
    });

    testWidgets('radiusMode global circular pousa no teto de superfície', (
      tester,
    ) async {
      final AppThemeData data = AppThemeData.light.copyWith(
        radiusTheme: const AppRadiusTheme(mode: AppRadiusMode.circular),
      );
      await tester.pumpWidget(_host(data, const AppCard(child: Text('x'))));
      final BorderRadius r = _cardDeco(tester).borderRadius! as BorderRadius;
      // O card é uma SUPERFÍCIE: `circular` não pode virar "metade do lado
      // menor", senão um card alto (um gráfico) vira elipse e o canto come o
      // próprio header. Pousa em kSurfaceCircularRadius.
      //
      // Isto NÃO tira a pílula do card pequeno: num card de 40px de altura o
      // próprio Flutter reduz o raio para metade do lado menor (20) ao pintar,
      // e a silhueta fica idêntica à da sentinela antiga. O teto só limita o
      // quanto um card GRANDE arredonda.
      expect(r.topLeft.x, kSurfaceCircularRadius);
    });

    testWidgets('radius cru vence radiusMode e o global', (tester) async {
      await tester.pumpWidget(
        _host(
          AppThemeData.light,
          const AppCard(
            radius: BorderRadius.all(Radius.circular(3)),
            radiusMode: AppRadiusMode.circular,
            child: Text('x'),
          ),
        ),
      );
      final BorderRadius r = _cardDeco(tester).borderRadius! as BorderRadius;
      expect(r.topLeft.x, 3);
    });
  });
}
