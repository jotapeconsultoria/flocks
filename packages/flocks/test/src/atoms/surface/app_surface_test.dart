import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {bool dark = false}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: dark ? AppThemeData.dark : AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

BoxDecoration _decoOf(WidgetTester tester) {
  final Container c = tester.widget<Container>(find.byType(Container));
  return c.decoration! as BoxDecoration;
}

void main() {
  final AppColorTheme light = AppThemeData.light.colorTheme;

  testWidgets('flat usa surface', (tester) async {
    await tester.pumpWidget(
      _host(const AppSurface(child: SizedBox(width: 40, height: 40))),
    );
    expect(_decoOf(tester).color, light.surface);
  });

  testWidgets('raised usa surfaceContainer', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppSurface(
          variant: AppSurfaceVariant.raised,
          child: SizedBox(width: 40, height: 40),
        ),
      ),
    );
    expect(_decoOf(tester).color, light.surfaceContainer);
  });

  testWidgets('bordered usa surface + borda outline', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppSurface(
          variant: AppSurfaceVariant.bordered,
          child: SizedBox(width: 40, height: 40),
        ),
      ),
    );
    final BoxDecoration d = _decoOf(tester);
    expect(d.color, light.surface);
    expect(d.border, isNotNull);
    expect((d.border! as Border).top.color, light.outline);
  });

  testWidgets('raio default vem do radius global (modo)', (tester) async {
    await tester.pumpWidget(
      _host(const AppSurface(child: SizedBox(width: 40, height: 40))),
    );
    expect(
      _decoOf(tester).borderRadius,
      AppThemeData.light.radiusTheme.resolve(),
    );
  });

  testWidgets('color override é respeitado', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppSurface(
          color: Color(0xFF123456),
          child: SizedBox(width: 40, height: 40),
        ),
      ),
    );
    expect(_decoOf(tester).color, const Color(0xFF123456));
  });

  testWidgets('está no catálogo como migrado', (tester) async {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_surface' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
