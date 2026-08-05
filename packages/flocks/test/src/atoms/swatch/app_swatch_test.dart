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

BoxDecoration _decoOf(WidgetTester tester) {
  final Container c = tester.widget<Container>(find.byType(Container));
  return c.decoration! as BoxDecoration;
}

void main() {
  testWidgets('pinta com a cor informada', (tester) async {
    await tester.pumpWidget(_host(const AppSwatch(color: Color(0xFF112233))));
    expect(_decoOf(tester).color, const Color(0xFF112233));
  });

  testWidgets('square usa radius global; circle usa BoxShape.circle', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const AppSwatch(color: Color(0xFF112233))));
    final BoxDecoration sq = _decoOf(tester);
    expect(sq.shape, BoxShape.rectangle);
    expect(
      sq.borderRadius,
      AppThemeData.light.radiusTheme.resolve(size: const Size.square(20)),
    );

    await tester.pumpWidget(
      _host(
        const AppSwatch(color: Color(0xFF112233), shape: AppSwatchShape.circle),
      ),
    );
    expect(_decoOf(tester).shape, BoxShape.circle);
  });

  testWidgets('borda default vem do outline do tema', (tester) async {
    await tester.pumpWidget(_host(const AppSwatch(color: Color(0xFF112233))));
    final Border b = _decoOf(tester).border! as Border;
    expect(b.top.color, AppThemeData.light.colorTheme.outline);
  });

  testWidgets('semanticLabel expõe rótulo', (tester) async {
    await tester.pumpWidget(
      _host(const AppSwatch(color: Color(0xFF112233), semanticLabel: 'Azul')),
    );
    expect(tester.getSemantics(find.byType(AppSwatch)).label, 'Azul');
  });

  testWidgets('está no catálogo como migrado', (tester) async {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_swatch' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
