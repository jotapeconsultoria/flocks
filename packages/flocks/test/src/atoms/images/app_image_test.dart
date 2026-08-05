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

void main() {
  testWidgets('recorta ao radius do tema', (tester) async {
    await tester.pumpWidget(
      _host(const AppImage.network('x', width: 20, height: 20)),
    );
    final ClipRRect clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(
      clip.borderRadius,
      AppThemeData.light.radiusTheme.resolve(size: const Size(20, 20)),
    );
  });

  testWidgets('cai no fallback custom em erro de rede', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppImage.network(
          'https://invalid.invalid/x.png',
          width: 60,
          height: 60,
          fallback: SizedBox(
            key: ValueKey<String>('fb'),
            width: 60,
            height: 60,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('fb')), findsOneWidget);
  });

  testWidgets('semanticLabel expõe imagem rotulada', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppImage.network(
          'x',
          width: 10,
          height: 10,
          semanticLabel: 'Foto',
        ),
      ),
    );
    final s = tester.getSemantics(find.byType(AppImage));
    expect(s.label, 'Foto');
    expect(s.flagsCollection.isImage, isTrue);
  });

  testWidgets('sem semanticLabel → decorativo', (tester) async {
    await tester.pumpWidget(
      _host(const AppImage.network('x', width: 10, height: 10)),
    );
    expect(find.byType(ExcludeSemantics), findsWidgets);
  });

  testWidgets('está no catálogo como migrado', (tester) async {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_image' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
