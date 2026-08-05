import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// `medium` abre no degrau do MEIO — nem a coluna estreita do `rest`, nem o
/// `full` que cobre a lista de trás (revisão P1r10).
void main() {
  Future<double> widthOf(WidgetTester tester, AppSideSheetSnap snap) async {
    await tester.binding.setSurfaceSize(const Size(1600, 900));
    late BuildContext trigger;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(1600, 900)),
          child: AppTheme(
            data: AppThemeData.light,
            child: Navigator(
              key: ValueKey<AppSideSheetSnap>(snap),
              onGenerateRoute: (_) => PageRouteBuilder<void>(
                pageBuilder: (BuildContext c, _, _) {
                  trigger = c;
                  return const SizedBox.expand();
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // ignore: unawaited_futures
    showAppSideSheet<void>(
      context: trigger,
      draggable: true,
      initialSnap: snap,
      child: const SizedBox.expand(key: ValueKey<String>('corpo')),
    );
    await tester.pumpAndSettle();
    return tester.getSize(find.byKey(const ValueKey<String>('corpo'))).width;
  }

  testWidgets('medium fica entre rest e full', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final double rest = await widthOf(tester, AppSideSheetSnap.rest);
    final double medium = await widthOf(tester, AppSideSheetSnap.medium);
    final double full = await widthOf(tester, AppSideSheetSnap.full);
    expect(medium, greaterThan(rest));
    expect(medium, lessThan(full));
  });
}
