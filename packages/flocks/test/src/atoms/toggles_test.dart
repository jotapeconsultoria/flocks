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
  group('AppCheckbox', () {
    testWidgets('tap alterna (onChanged(!checked))', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        _host(AppCheckbox(checked: false, onChanged: (v) => changed = v)),
      );
      await tester.tap(find.byType(AppCheckbox));
      expect(changed, isTrue);
    });

    testWidgets('disabled: tap não altera', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        _host(
          AppCheckbox(
            checked: false,
            enabled: false,
            onChanged: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.byType(AppCheckbox), warnIfMissed: false);
      expect(changed, isNull);
    });

    testWidgets('checked expõe semântica checked', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(AppCheckbox(checked: true, onChanged: (_) {})),
      );
      expect(
        tester.getSemantics(find.byType(AppCheckbox)),
        isSemantics(hasCheckedState: true, isChecked: true),
      );
      handle.dispose();
    });
  });

  group('AppSwitch', () {
    testWidgets('tap alterna (onChanged(!value))', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        _host(AppSwitch(value: false, onChanged: (v) => changed = v)),
      );
      await tester.tap(find.byType(AppSwitch));
      expect(changed, isTrue);
    });

    testWidgets('on expõe semântica toggled', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_host(AppSwitch(value: true, onChanged: (_) {})));
      expect(
        tester.getSemantics(find.byType(AppSwitch)),
        isSemantics(hasCheckedState: true, isChecked: true),
      );
      handle.dispose();
    });
  });

  test('checkbox e switch no catálogo como migrados', () {
    for (final id in <String>['app_checkbox', 'app_switch']) {
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
