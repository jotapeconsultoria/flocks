import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regra 10 — o calendário respeita *reduce motion*.
///
/// A duração das células vinha de um helper que consultava **só** o
/// `animationTheme.enabled` do design system. Faltavam as duas fontes do
/// sistema operacional (`MediaQuery.disableAnimations` e
/// `accessibilityFeatures.reduceMotion`, esta a única que o iOS seta): com
/// "Reduzir movimento" ligado o calendário continuava animando.
///
/// O teste de arquitetura (`motion_axis_test.dart`) trava a FORMA (quem anima
/// consulta `AppMotion`); este trava o COMPORTAMENTO.
Widget _host(
  Widget child, {
  bool disableAnimations = false,
  bool themeAnimations = true,
}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: AppTheme(
      data: AppThemeData.light.copyWith(
        animationTheme: AppAnimationTheme(enabled: themeAnimations),
      ),
      child: Center(child: child),
    ),
  ),
);

/// As durações de todas as células animadas do calendário visível.
Set<Duration> _cellDurations(WidgetTester tester) => tester
    .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
    .map((AnimatedContainer c) => c.duration)
    .toSet();

Widget _picker() => SizedBox(
  width: 320,
  child: AppDatePicker(
    initialDate: DateTime(2027, 9, 10),
    today: DateTime(2027, 9, 23),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    onDateSelected: (_) {},
  ),
);

Widget _rangePicker() => SizedBox(
  width: 320,
  child: AppDateRangePicker(
    initialRange: AppDateRange(DateTime(2027, 9, 10), DateTime(2027, 9, 14)),
    today: DateTime(2027, 9, 23),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    onRangeSelected: (_) {},
  ),
);

void main() {
  for (final (String name, Widget Function() build)
      in <(String, Widget Function())>[
        ('AppDatePicker', _picker),
        ('AppDateRangePicker', _rangePicker),
      ]) {
    group('$name · reduce motion', () {
      testWidgets('anima quando nada pede o contrário', (tester) async {
        await tester.pumpWidget(_host(build()));
        // A guarda contra o remédio degenerar em "sempre zero": se isto passar
        // a falhar, o calendário parou de animar para todo mundo.
        expect(_cellDurations(tester), <Duration>{AppDurations.fast});
      });

      testWidgets('MediaQuery.disableAnimations colapsa a transição', (
        tester,
      ) async {
        await tester.pumpWidget(_host(build(), disableAnimations: true));
        expect(_cellDurations(tester), <Duration>{Duration.zero});
      });

      testWidgets('o liga/desliga do tema continua valendo', (tester) async {
        // O comportamento que já existia antes do conserto — não foi perdido
        // ao trocar a fonte da decisão.
        await tester.pumpWidget(_host(build(), themeAnimations: false));
        expect(_cellDurations(tester), <Duration>{Duration.zero});
      });
    });
  }
}
