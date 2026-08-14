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
  group('direction', () {
    Widget host(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: AppTheme(
          data: AppThemeData.light,
          child: Center(child: SizedBox(width: 200, child: child)),
        ),
      ),
    );

    testWidgets('horizontal default: geometria e ordem de sempre', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          AppActionItem(
            icon: AppIconToken.support,
            text: 'Suporte',
            onPressed: () {},
          ),
        ),
      );
      final Size sem = tester.getSize(find.byType(AppActionItem));
      expect(
        tester.getTopLeft(find.byType(AppIcon)).dx,
        lessThan(tester.getTopLeft(find.text('Suporte')).dx),
      );

      await tester.pumpWidget(
        host(
          AppActionItem(
            icon: AppIconToken.support,
            text: 'Suporte',
            direction: Axis.horizontal,
            onPressed: () {},
          ),
        ),
      );
      expect(tester.getSize(find.byType(AppActionItem)), sem);
    });

    testWidgets('vertical: ícone ACIMA do rótulo, mesmo padding, tap ok', (
      tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        host(
          AppActionItem(
            icon: AppIconToken.support,
            text: 'Suporte',
            direction: Axis.vertical,
            onPressed: () => taps++,
          ),
        ),
      );
      final Rect icon = tester.getRect(find.byType(AppIcon));
      final Rect label = tester.getRect(find.text('Suporte'));
      expect(icon.bottom, lessThanOrEqualTo(label.top));
      // Mesmo padding: o ícone começa s16 abaixo do topo do card.
      final Rect card = tester.getRect(find.byType(AppActionItem));
      expect(icon.top - card.top, 16);
      await tester.tap(find.byType(AppActionItem));
      expect(taps, 1);
    });
  });

  testWidgets('AppActionItem mostra texto e dispara onPressed', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(
        AppActionItem(
          icon: AppIcons.infoCircle,
          text: 'Suporte',
          onPressed: () => taps++,
        ),
      ),
    );
    expect(find.text('Suporte'), findsOneWidget);
    await tester.tap(find.text('Suporte'));
    expect(taps, 1);
  });

  test('AppActionItem no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_action_item' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
