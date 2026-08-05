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
  testWidgets('tap chama onChanged(value)', (tester) async {
    int? changed;
    await tester.pumpWidget(
      _host(
        AppRadio<int>(value: 1, groupValue: 2, onChanged: (v) => changed = v),
      ),
    );
    await tester.tap(find.byType(AppRadio<int>));
    expect(changed, 1);
  });

  testWidgets('disabled: tap não chama onChanged', (tester) async {
    int? changed;
    await tester.pumpWidget(
      _host(
        AppRadio<int>(
          value: 1,
          groupValue: 2,
          enabled: false,
          onChanged: (v) => changed = v,
        ),
      ),
    );
    await tester.tap(find.byType(AppRadio<int>), warnIfMissed: false);
    expect(changed, isNull);
  });

  testWidgets('selecionado expõe checked em grupo mutuamente exclusivo', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(AppRadio<int>(value: 1, groupValue: 1, onChanged: (_) {})),
    );
    expect(
      tester.getSemantics(find.byType(AppRadio<int>)),
      isSemantics(
        hasCheckedState: true,
        isChecked: true,
        isInMutuallyExclusiveGroup: true,
      ),
    );
    handle.dispose();
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_radio' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
