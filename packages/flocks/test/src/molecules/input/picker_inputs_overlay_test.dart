import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reproduz o cenário real (app/WB): o `Overlay` do root fica ACIMA do provider
/// de tema. Sem reprovê o `AppTheme` na entry, abrir o overlay dos pickers
/// lançava "No AppTheme found in context".
Widget _hostThemeBelowOverlay(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext context) => AppTheme(
            data: AppThemeData.light,
            child: Center(child: SizedBox(width: 320, child: child)),
          ),
        ),
      ],
    ),
  ),
);

void main() {
  testWidgets('AppDatePickerInput: abre o calendário sem crash', (
    tester,
  ) async {
    await tester.pumpWidget(
      _hostThemeBelowOverlay(
        AppDatePickerInput(hintText: 'DD/MM/AAAA', onDateSelected: (_) {}),
      ),
    );
    await tester.tap(find.byType(AppIcon)); // sufixo (calendário)
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(AppDatePicker), findsOneWidget);
    _expectNoYellowUnderline(tester, find.byType(AppDatePicker));
  });

  testWidgets('AppTimePickerInput: abre as rodas sem crash', (tester) async {
    await tester.pumpWidget(
      _hostThemeBelowOverlay(
        AppTimePickerInput(hintText: 'HH:mm', onTimeSelected: (_) {}),
      ),
    );
    await tester.tap(find.byType(AppIcon)); // sufixo (relógio)
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(AppTimePicker), findsOneWidget);
    _expectNoYellowUnderline(tester, find.byType(AppTimePicker));
  });

  testWidgets('AppColorPickerInput: abre o painel HSV sem crash', (
    tester,
  ) async {
    await tester.pumpWidget(
      _hostThemeBelowOverlay(
        AppColorPickerInput(value: '#FF5B04', onChanged: (_) {}),
      ),
    );
    await tester.tap(find.byType(AppIcon).first); // chevron
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(AppColorPickerPanel), findsOneWidget);
    _expectNoYellowUnderline(tester, find.byType(AppColorPickerPanel));
  });

  testWidgets('AppColorPickerPanel: lápis ativa a edição do hex com foco', (
    tester,
  ) async {
    await tester.pumpWidget(
      _hostThemeBelowOverlay(
        AppColorPickerPanel(
          color: const Color(0xFFFF5B04),
          onColorChanged: (_) {},
        ),
      ),
    );
    // Não há editor antes de clicar no lápis.
    expect(find.byType(EditableText), findsNothing);

    await tester.tap(_pencilFinder);
    await tester.pumpAndSettle();

    expect(find.byType(EditableText), findsOneWidget);
    final EditableTextState state = tester.state(find.byType(EditableText));
    expect(state.widget.focusNode.hasFocus, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AppColorPickerPanel: digitar hex válido emite a cor', (
    tester,
  ) async {
    Color? emitted;
    await tester.pumpWidget(
      _hostThemeBelowOverlay(
        AppColorPickerPanel(
          color: const Color(0xFFFF5B04),
          onColorChanged: (c) => emitted = c,
        ),
      ),
    );
    await tester.tap(_pencilFinder);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText), '1E88E5');
    await tester.pump();

    expect(emitted, isNotNull);
    expect(colorToHex(emitted!), '#1E88E5');
  });

  testWidgets(
    'AppColorPickerPanel: showSuggestedColors false esconde os presets',
    (tester) async {
      await tester.pumpWidget(
        _hostThemeBelowOverlay(
          AppColorPickerPanel(
            color: const Color(0xFFFF5B04),
            showSuggestedColors: false,
            onColorChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Cores sugeridas'), findsNothing);
    },
  );
  testWidgets(
    'AppDateTimePickerInput: abre calendário E rodas no MESMO painel',
    (tester) async {
      await tester.pumpWidget(
        _hostThemeBelowOverlay(
          AppDateTimePickerInput(
            hintText: 'DD/MM/AAAA HH:mm',
            onDateTimeSelected: (_) {},
          ),
        ),
      );
      await tester.tap(find.byType(AppIcon)); // sufixo (calendário)
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // O componente existe porque data e hora aqui são UM dado só: se o painel
      // trouxesse só o calendário, o formulário voltaria a aceitar data sem
      // hora e alguém escolheria meia-noite por ninguém.
      expect(find.byType(AppDatePicker), findsOneWidget);
      expect(find.byType(AppTimePicker), findsOneWidget);
      _expectNoYellowUnderline(tester, find.byType(AppDatePicker));
    },
  );
  // O ✕ dos três pickers limpa por dentro (estado interno + texto) e AVISA o
  // chamador por onCleared — o callback de seleção só anuncia valores válidos,
  // então sem onCleared o form nunca ficaria sabendo que o valor se foi.

  testWidgets('AppDatePickerInput: ✕ dispara onCleared e não a seleção', (
    tester,
  ) async {
    int cleared = 0;
    int selected = 0;
    await tester.pumpWidget(
      _hostThemeBelowOverlay(
        AppDatePickerInput(
          initialDate: DateTime(2030, 2, 1),
          hasError: true, // condição do ✕ no AppInput
          onCleared: () => cleared++,
          onDateSelected: (_) => selected++,
        ),
      ),
    );
    expect(find.text('01/02/2030'), findsOneWidget);

    await tester.tap(_clearFinder);
    await tester.pumpAndSettle();

    expect(cleared, 1);
    expect(selected, 0);
    expect(find.text('01/02/2030'), findsNothing);
  });

  testWidgets('AppTimePickerInput: ✕ dispara onCleared e não a seleção', (
    tester,
  ) async {
    int cleared = 0;
    int selected = 0;
    await tester.pumpWidget(
      _hostThemeBelowOverlay(
        AppTimePickerInput(
          initialHour: 10,
          initialMinute: 30,
          hasError: true,
          onCleared: () => cleared++,
          onTimeSelected: (_) => selected++,
        ),
      ),
    );
    expect(find.text('10:30'), findsOneWidget);

    await tester.tap(_clearFinder);
    await tester.pumpAndSettle();

    expect(cleared, 1);
    expect(selected, 0);
    expect(find.text('10:30'), findsNothing);
  });

  testWidgets('AppDateTimePickerInput: ✕ dispara onCleared e não a seleção', (
    tester,
  ) async {
    int cleared = 0;
    int selected = 0;
    await tester.pumpWidget(
      _hostThemeBelowOverlay(
        AppDateTimePickerInput(
          initialDateTime: DateTime(2030, 2, 1, 10, 30),
          hasError: true,
          onCleared: () => cleared++,
          onDateTimeSelected: (_) => selected++,
        ),
      ),
    );
    expect(find.text('01/02/2030 10:30'), findsOneWidget);

    await tester.tap(_clearFinder);
    await tester.pumpAndSettle();

    expect(cleared, 1);
    expect(selected, 0);
    expect(find.text('01/02/2030 10:30'), findsNothing);
  });

  testWidgets('pickers: ✕ sem onCleared segue limpando sem lançar (os 3)', (
    tester,
  ) async {
    // Os três têm call sites INDEPENDENTES de onCleared — um `!()` num deles
    // passaria com o teste cobrindo só o primeiro.
    final Map<String, Widget> pickers = <String, Widget>{
      '01/02/2030': AppDatePickerInput(
        initialDate: DateTime(2030, 2, 1),
        hasError: true,
        onDateSelected: (_) {},
      ),
      '10:30': AppTimePickerInput(
        initialHour: 10,
        initialMinute: 30,
        hasError: true,
        onTimeSelected: (_) {},
      ),
      '01/02/2030 10:30': AppDateTimePickerInput(
        initialDateTime: DateTime(2030, 2, 1, 10, 30),
        hasError: true,
        onDateTimeSelected: (_) {},
      ),
    };
    for (final MapEntry<String, Widget> entry in pickers.entries) {
      await tester.pumpWidget(_hostThemeBelowOverlay(entry.value));
      await tester.tap(_clearFinder);
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: '${entry.value.runtimeType} lançou ao limpar sem onCleared',
      );
      expect(find.text(entry.key), findsNothing);
      // Fecha o painel que o clear abre antes do próximo picker.
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    }
  });
}

/// Localiza o ✕ de limpar (o sufixo em erro + preenchido) do `AppInput`.
final Finder _clearFinder = find.byWidgetPredicate(
  (Widget w) => w is AppIcon && w.icon == AppIconToken.close,
);

/// Localiza o ícone de lápis (edição) da linha de preview do painel.
final Finder _pencilFinder = find.byWidgetPredicate(
  (Widget w) => w is AppIcon && w.icon == AppIcons.pencil,
);

/// O overlay reprovê um `DefaultTextStyle` concreto → o texto não cai no
/// fallback do Flutter (sublinhado amarelo duplo "faltou Material").
void _expectNoYellowUnderline(WidgetTester tester, Finder overlayContent) {
  final TextStyle ds = DefaultTextStyle.of(
    tester.element(overlayContent),
  ).style;
  expect(ds.decoration, isNot(TextDecoration.underline));
}
