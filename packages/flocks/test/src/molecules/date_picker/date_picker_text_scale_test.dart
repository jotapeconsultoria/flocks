import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Os pickers densos refletem o text scale **até 1.5×** e clampam além disso
/// (`withClampedTextScaling`). No date picker as colunas escalam com o texto
/// (largura fixa por célula) e o grid cresce, cabendo sem quebrar.

Widget _host(Widget child, double textScale) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

double _effectiveScale(WidgetTester tester, Type pickerType) {
  final Element el = tester.element(
    find
        .descendant(of: find.byType(pickerType), matching: find.byType(AppText))
        .first,
  );
  return MediaQuery.textScalerOf(el).scale(10) / 10;
}

AppDatePicker _datePicker() =>
    AppDatePicker(initialDate: DateTime(2026, 7, 14), onDateSelected: (_) {});

void main() {
  testWidgets('AppDatePicker reflete 1.5× (sem clampar em 1.5)', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_datePicker(), 1.5));
    expect(_effectiveScale(tester, AppDatePicker), closeTo(1.5, 0.001));
  });

  testWidgets('AppDatePicker clampa acima de 1.5× (2.0 → 1.5)', (tester) async {
    await tester.pumpWidget(_host(_datePicker(), 2.0));
    expect(_effectiveScale(tester, AppDatePicker), closeTo(1.5, 0.001));
  });

  testWidgets('AppDatePicker cresce com o text scale, sem overflow', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_datePicker(), 1.0));
    final double w1 = tester.getSize(find.byType(AppDatePicker)).width;

    await tester.pumpWidget(_host(_datePicker(), 1.5));
    final double w2 = tester.getSize(find.byType(AppDatePicker)).width;

    expect(tester.takeException(), isNull); // sem RenderFlex overflow
    expect(w2, greaterThan(w1)); // o grid alargou p/ caber o texto maior
  });

  testWidgets('AppTimePicker clampa acima de 1.5× (2.0 → 1.5)', (tester) async {
    await tester.pumpWidget(_host(AppTimePicker(onTimeSelected: (_) {}), 2.0));
    expect(_effectiveScale(tester, AppTimePicker), closeTo(1.5, 0.001));
  });
}
