import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(data: AppThemeData.light, child: child),
  ),
);

void main() {
  testWidgets('AppSimpleHeader renderiza o child e é header', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(width: 380, child: AppSimpleHeader(child: AppText('T'))),
      ),
    );
    expect(find.text('T'), findsOneWidget);
    final s = tester.getSemantics(find.byType(AppSimpleHeader));
    expect(s.flagsCollection.isHeader, isTrue);
  });

  testWidgets('AppPrimaryHeader mostra leading/child/trailing', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 380,
          child: AppPrimaryHeader(
            leading: AppText('L'),
            trailing: AppText('R'),
            child: AppText('C'),
          ),
        ),
      ),
    );
    expect(find.text('L'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('R'), findsOneWidget);
    final s = tester.getSemantics(find.byType(AppPrimaryHeader));
    expect(s.flagsCollection.isHeader, isTrue);
  });

  group('AppPrimaryHeader.bottom', () {
    testWidgets('resolveBarExtent sem bottom = inset + 56 (o valor de hoje)', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(viewPadding: EdgeInsets.only(top: 20)),
            child: AppTheme(
              data: AppThemeData.light,
              child: const SizedBox(
                width: 380,
                child: AppPrimaryHeader(child: AppText('C')),
              ),
            ),
          ),
        ),
      );
      final AppPrimaryHeader header = tester.widget<AppPrimaryHeader>(
        find.byType(AppPrimaryHeader),
      );
      final BuildContext context = tester.element(
        find.byType(AppPrimaryHeader),
      );
      expect(header.resolveBarExtent(context), 76);
    });

    testWidgets('com bottom a extensão soma bottomHeight', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(viewPadding: EdgeInsets.only(top: 20)),
            child: AppTheme(
              data: AppThemeData.light,
              child: const SizedBox(
                width: 380,
                child: AppPrimaryHeader(
                  bottom: SizedBox.shrink(),
                  bottomHeight: 40,
                  child: AppText('C'),
                ),
              ),
            ),
          ),
        ),
      );
      final AppPrimaryHeader header = tester.widget<AppPrimaryHeader>(
        find.byType(AppPrimaryHeader),
      );
      final BuildContext context = tester.element(
        find.byType(AppPrimaryHeader),
      );
      expect(header.resolveBarExtent(context), 116);
    });

    testWidgets('bottom renderiza dentro da barra, na altura declarada', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 380,
              child: AppPrimaryHeader(
                bottom: AppText('B'),
                bottomHeight: 40,
                child: AppText('C'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('B'), findsOneWidget);
      expect(tester.getSize(find.byType(AppPrimaryHeader)).height, 96);
      final Rect content = tester.getRect(find.text('C'));
      final Rect bottom = tester.getRect(find.text('B'));
      expect(bottom.top, greaterThanOrEqualTo(content.bottom));
    });

    testWidgets('asserts: bottom e bottomHeight andam juntos', (tester) async {
      expect(
        () => AppPrimaryHeader(
          bottom: const SizedBox.shrink(),
          child: const AppText('C'),
        ),
        throwsAssertionError,
      );
      expect(
        () => AppPrimaryHeader(bottomHeight: 8, child: const AppText('C')),
        throwsAssertionError,
      );
      expect(
        () => AppPrimaryHeader(
          bottom: const SizedBox.shrink(),
          bottomHeight: -1,
          child: const AppText('C'),
        ),
        throwsAssertionError,
      );
    });
  });

  test('headers no catálogo como migrados', () {
    for (final String id in <String>[
      'app_simple_header',
      'app_primary_header',
    ]) {
      expect(
        flocksCatalog.any(
          (m) => m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id ausente',
      );
    }
  });
}
