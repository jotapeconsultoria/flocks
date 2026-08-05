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

void main() {
  testWidgets('horizontal: preenche a largura e usa thickness na altura', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(width: 200, child: AppDivider(thickness: AppStrokes.m)),
      ),
    );
    final Size size = tester.getSize(find.byType(AppDivider));
    expect(size.width, 200);
    expect(size.height, AppStrokes.m);
  });

  testWidgets('vertical: preenche a altura e usa thickness na largura', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          height: 120,
          child: AppDivider.vertical(thickness: AppStrokes.m),
        ),
      ),
    );
    final Size size = tester.getSize(find.byType(AppDivider));
    expect(size.height, 120);
    expect(size.width, AppStrokes.m);
  });

  testWidgets('cor default vem do divider do tema', (tester) async {
    await tester.pumpWidget(
      _host(const SizedBox(width: 200, child: AppDivider())),
    );
    final Container c = tester.widget<Container>(find.byType(Container));
    final BoxDecoration d = c.decoration! as BoxDecoration;
    expect(d.color, AppThemeData.light.colorTheme.divider);
  });

  testWidgets('cor custom é respeitada', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(width: 200, child: AppDivider(color: Color(0xFF00FF00))),
      ),
    );
    final Container c = tester.widget<Container>(find.byType(Container));
    final BoxDecoration d = c.decoration! as BoxDecoration;
    expect(d.color, const Color(0xFF00FF00));
  });

  testWidgets('aplica o radius global do tema por padrão', (tester) async {
    await tester.pumpWidget(
      _host(const SizedBox(width: 200, child: AppDivider())),
    );
    final Container c = tester.widget<Container>(find.byType(Container));
    final BoxDecoration d = c.decoration! as BoxDecoration;
    expect(
      d.borderRadius,
      BorderRadius.circular(AppThemeData.light.radiusTheme.resolveRadius()),
    );
  });

  testWidgets('é decorativo (ExcludeSemantics)', (tester) async {
    await tester.pumpWidget(
      _host(const SizedBox(width: 200, child: AppDivider())),
    );
    expect(find.byType(ExcludeSemantics), findsOneWidget);
  });

  testWidgets('está no catálogo como migrado', (tester) async {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_divider' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
