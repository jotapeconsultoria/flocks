import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {bool dark = false}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: dark ? AppThemeData.dark : AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

/// Todas as decorações de célula (fill/borda/hover) do calendário visível.
List<BoxDecoration> _cellDecorations(WidgetTester tester) => tester
    .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
    .map((c) => c.decoration)
    .whereType<BoxDecoration>()
    .toList();

void main() {
  group('AppDatePicker · markToday', () {
    testWidgets('sem markToday, nenhuma célula tem borda', (tester) async {
      await tester.pumpWidget(
        _host(
          AppDatePicker(
            initialDate: DateTime(2027, 9, 10),
            today: DateTime(2027, 9, 23),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            onDateSelected: (_) {},
          ),
        ),
      );
      final bordered = _cellDecorations(
        tester,
      ).where((d) => d.border != null).toList();
      expect(bordered, isEmpty);
    });

    testWidgets('com markToday, exatamente uma célula ganha borda', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          AppDatePicker(
            initialDate: DateTime(2027, 9, 10),
            today: DateTime(2027, 9, 23),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            markToday: true,
            onDateSelected: (_) {},
          ),
        ),
      );
      final bordered = _cellDecorations(
        tester,
      ).where((d) => d.border != null).toList();
      expect(bordered, hasLength(1));
    });

    testWidgets('hoje fora do range ainda mostra a borda', (tester) async {
      await tester.pumpWidget(
        _host(
          AppDatePicker(
            initialDate: DateTime(2027, 9, 10),
            today: DateTime(2027, 9, 23),
            // 23 está fora do range → célula desabilitada, mas hoje é visível.
            firstDate: DateTime(2027, 9),
            lastDate: DateTime(2027, 9, 20),
            markToday: true,
            onDateSelected: (_) {},
          ),
        ),
      );
      final bordered = _cellDecorations(
        tester,
      ).where((d) => d.border != null).toList();
      expect(bordered, hasLength(1));
    });
  });

  group('AppDatePicker · desabilitado sensível ao brilho', () {
    testWidgets('cor de desabilitado difere entre light e dark', (
      tester,
    ) async {
      Color disabledColorOf(WidgetTester t) {
        // O dia 25 está fora do range → desabilitado.
        final text = t.widget<AppText>(
          find.byWidgetPredicate((w) => w is AppText && w.data == '25'),
        );
        return text.style!.color!;
      }

      final picker = AppDatePicker(
        initialDate: DateTime(2027, 9, 10),
        firstDate: DateTime(2027, 9),
        lastDate: DateTime(2027, 9, 20),
        onDateSelected: (_) {},
      );

      await tester.pumpWidget(_host(picker));
      final light = disabledColorOf(tester);

      await tester.pumpWidget(_host(picker, dark: true));
      final dark = disabledColorOf(tester);

      // Cada tema usa seu próprio stop.
      expect(light, AppThemeData.light.colorTheme.neutralPrimary.s200);
      expect(dark, AppThemeData.dark.colorTheme.neutralPrimary.s400);

      // O ponto do bug: no dark, o antigo s200 quase some sobre a superfície;
      // o novo stop tem luminância (logo, contraste) maior.
      final darkS200 = AppThemeData.dark.colorTheme.neutralPrimary.s200;
      expect(dark.computeLuminance(), greaterThan(darkS200.computeLuminance()));
    });
  });

  group('AppDateRangePicker · fluxo de seleção', () {
    testWidgets('dois toques emitem um intervalo completo', (tester) async {
      AppDateRange? emitted;
      await tester.pumpWidget(
        _host(
          AppDateRangePicker(
            firstDate: DateTime(2027, 9),
            lastDate: DateTime(2027, 9, 30),
            today: DateTime(2027, 9, 1),
            onRangeSelected: (r) => emitted = r,
          ),
        ),
      );

      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();
      expect(emitted, isNull, reason: 'só o início não emite');

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();

      expect(emitted, isNotNull);
      expect(emitted!.start, DateTime(2027, 9, 10));
      expect(emitted!.end, DateTime(2027, 9, 15));
    });

    testWidgets('tocar antes do início reinicia a seleção', (tester) async {
      AppDateRange? emitted;
      await tester.pumpWidget(
        _host(
          AppDateRangePicker(
            firstDate: DateTime(2027, 9),
            lastDate: DateTime(2027, 9, 30),
            today: DateTime(2027, 9, 1),
            onRangeSelected: (r) => emitted = r,
          ),
        ),
      );

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10')); // antes do início → recomeça
      await tester.pumpAndSettle();
      expect(emitted, isNull);

      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();
      expect(emitted!.start, DateTime(2027, 9, 10));
      expect(emitted!.end, DateTime(2027, 9, 20));
    });

    testWidgets('terceiro toque começa um novo intervalo', (tester) async {
      final emitted = <AppDateRange>[];
      await tester.pumpWidget(
        _host(
          AppDateRangePicker(
            firstDate: DateTime(2027, 9),
            lastDate: DateTime(2027, 9, 30),
            today: DateTime(2027, 9, 1),
            onRangeSelected: emitted.add,
          ),
        ),
      );

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('9'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('12')); // 3º toque → recomeça
      await tester.pumpAndSettle();
      await tester.tap(find.text('14'));
      await tester.pumpAndSettle();

      expect(emitted, hasLength(2));
      expect(emitted.last.start, DateTime(2027, 9, 12));
      expect(emitted.last.end, DateTime(2027, 9, 14));
    });

    testWidgets('extremos iguais formam intervalo de um dia', (tester) async {
      AppDateRange? emitted;
      await tester.pumpWidget(
        _host(
          AppDateRangePicker(
            firstDate: DateTime(2027, 9),
            lastDate: DateTime(2027, 9, 30),
            today: DateTime(2027, 9, 1),
            onRangeSelected: (r) => emitted = r,
          ),
        ),
      );

      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();

      expect(emitted!.start, DateTime(2027, 9, 10));
      expect(emitted!.end, DateTime(2027, 9, 10));
    });

    testWidgets('intervalo cross-month via navegação', (tester) async {
      AppDateRange? emitted;
      await tester.pumpWidget(
        _host(
          AppDateRangePicker(
            initialRange: AppDateRange(DateTime(2027, 9, 25)),
            firstDate: DateTime(2027, 9),
            lastDate: DateTime(2027, 10, 31),
            today: DateTime(2027, 9, 1),
            onRangeSelected: (r) => emitted = r,
          ),
        ),
      );

      // Avança para outubro e toca no dia 5.
      final forwardChevron = find.byWidgetPredicate(
        (w) => w is AppIcon && w.icon == AppIcons.chevronRight,
      );
      await tester.tap(forwardChevron);
      await tester.pumpAndSettle();
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      expect(emitted!.start, DateTime(2027, 9, 25));
      expect(emitted!.end, DateTime(2027, 10, 5));
    });
  });

  group('AppDateRange', () {
    test('contains respeita as pontas e o estado incompleto', () {
      final open = AppDateRange(DateTime(2027, 9, 10));
      expect(open.contains(DateTime(2027, 9, 10)), isFalse);

      final range = AppDateRange(DateTime(2027, 9, 10), DateTime(2027, 9, 15));
      expect(range.contains(DateTime(2027, 9, 10)), isTrue);
      expect(range.contains(DateTime(2027, 9, 15)), isTrue);
      expect(range.contains(DateTime(2027, 9, 12)), isTrue);
      expect(range.contains(DateTime(2027, 9, 9)), isFalse);
      expect(range.contains(DateTime(2027, 9, 16)), isFalse);
    });
  });
}
