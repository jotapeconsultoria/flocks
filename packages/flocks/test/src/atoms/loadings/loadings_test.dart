import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

Widget _host(Widget child, {bool reduceMotion = false}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(disableAnimations: reduceMotion),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

void main() {
  testWidgets('AppCircularLoading renderiza e settla sob reduce-motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const AppCircularLoading(size: 40), reduceMotion: true),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppCircularLoading), findsOneWidget);
  });

  testWidgets('AppLinearLoading settla sob reduce-motion', (tester) async {
    await tester.pumpWidget(
      _host(const AppLinearLoading(), reduceMotion: true),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppLinearLoading), findsOneWidget);
  });

  testWidgets('AppShimmerLoading sob reduce-motion não usa Shimmer', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const AppShimmerLoading(height: 24), reduceMotion: true),
    );
    expect(find.byType(Shimmer), findsNothing);
    expect(find.byType(AppShimmerLoading), findsOneWidget);
  });

  testWidgets('AppOverlayLoading mostra o overlay quando isLoading', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppOverlayLoading(
          isLoading: true,
          overlay: Center(child: AppCircularLoading()),
          child: SizedBox(width: 100, height: 60),
        ),
        reduceMotion: true,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppCircularLoading), findsOneWidget);
  });

  testWidgets('AppLinearLoading determinado (value) não anima e settla', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const AppLinearLoading(value: 0.5)));
    await tester.pumpAndSettle(); // sem loop → não trava
    expect(find.byType(AppLinearLoading), findsOneWidget);
  });

  testWidgets('AppCircularLoading determinado (value) não usa AppSpin', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const AppCircularLoading(size: 40, value: 0.7)),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppSpin), findsNothing);
    expect(find.byType(AppCircularLoading), findsOneWidget);
  });

  test('catálogo contém os 5 loadings como migrados', () {
    const ids = <String>[
      'app_circular_loading',
      'app_linear_loading',
      'app_border_progress',
      'app_overlay_loading',
      'app_shimmer_loading',
    ];
    for (final id in ids) {
      expect(
        flocksCatalog.any(
          (m) => m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id ausente/não-migrado',
      );
    }
  });
}
