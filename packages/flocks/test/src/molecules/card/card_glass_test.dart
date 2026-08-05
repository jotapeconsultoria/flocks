import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Contrato do eixo glass (frosted / Liquid Glass nível 1) exercitado por uma
// superfície da allow-list (`AppOverlayCard(glass: true)`, que delega ao
// `AppGlassSurface`). `AppCard` **ignora** o eixo glass de propósito.
// - glass instancia um `BackdropFilter` (o frost) sobre um fundo pintado;
// - quando a transparência é reduzida (flag do DS OU proxy de acessibilidade do
//   `MediaQuery`: highContrast/invertColors), NÃO instancia `BackdropFilter` e
//   cai para uma superfície opaca `elevated` (com sombra).

Widget _host(
  AppThemeData data,
  Widget child, {
  MediaQueryData media = const MediaQueryData(),
}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: media,
    // Um fundo pintado ATRÁS do vidro para o backdrop ter o que amostrar.
    child: Stack(
      children: <Widget>[
        const Positioned.fill(child: ColoredBox(color: Color(0xFF3366CC))),
        Center(
          child: AppTheme(data: data, child: child),
        ),
      ],
    ),
  ),
);

Finder _backdrop() => find.byType(BackdropFilter);

void main() {
  group('AppOverlayCard · eixo glass', () {
    testWidgets('glass instancia BackdropFilter com o sigma do token', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          AppThemeData.light,
          const AppOverlayCard(glass: true, child: Text('x')),
        ),
      );

      expect(_backdrop(), findsOneWidget);
      final BackdropFilter bf = tester.widget<BackdropFilter>(_backdrop());
      // Blur + re-saturação (fonte única do filtro do vidro).
      expect(bf.filter, AppGlass.backdropFilter());
    });

    testWidgets('flag transparencyTheme=false → sem BackdropFilter (opaco)', (
      tester,
    ) async {
      final AppThemeData data = AppThemeData.light.copyWith(
        transparencyTheme: const AppTransparencyTheme(enabled: false),
      );
      await tester.pumpWidget(
        _host(data, const AppOverlayCard(glass: true, child: Text('x'))),
      );

      expect(_backdrop(), findsNothing);
      // Fallback opaco = superfície elevated (tem sombra).
      final DecoratedBox box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(AppOverlayCard),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect((box.decoration as BoxDecoration).boxShadow, isNotNull);
    });

    testWidgets('MediaQuery.highContrast → sem BackdropFilter (opaco)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          AppThemeData.light,
          const AppOverlayCard(glass: true, child: Text('x')),
          media: const MediaQueryData(highContrast: true),
        ),
      );
      expect(_backdrop(), findsNothing);
    });

    testWidgets('MediaQuery.invertColors → sem BackdropFilter (opaco)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          AppThemeData.light,
          const AppOverlayCard(glass: true, child: Text('x')),
          media: const MediaQueryData(invertColors: true),
        ),
      );
      expect(_backdrop(), findsNothing);
    });
  });
}
