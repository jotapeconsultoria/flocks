import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regra 9 — o eixo `AppStyle` **chega** aos componentes que o adotaram.
///
/// `style_axis_test.dart` prova que ninguém pinta caixa fora do eixo; isso é
/// ausência de ofensor, e ausência de ofensor não é presença de efeito. Aqui a
/// prova é o contrário: mudar o global tem de mudar o que a caixa desenha.
///
/// As três cláusulas de `AppStyle`, na ordem em que o usuário as percebe:
/// `filled` = fill próprio e nada mais; `outlined` acrescenta a borda;
/// `elevated` acrescenta a sombra e NÃO tem borda (é a sombra que separa).
Widget _host(Widget child, {required AppStyle style}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(1024, 768)),
    child: AppTheme(
      data: AppThemeData.light.copyWith(
        styleTheme: AppStyleTheme(style: style),
      ),
      child: Center(child: child),
    ),
  ),
);

/// A decoração da caixa identificada por [finder].
BoxDecoration _decoOf(WidgetTester tester, Finder finder) {
  final Iterable<BoxDecoration> boxes = tester
      .widgetList<DecoratedBox>(finder)
      .map((DecoratedBox d) => d.decoration)
      .whereType<BoxDecoration>();
  return boxes.first;
}

void main() {
  /// Roda as três cláusulas sobre a primeira caixa que [build] produz.
  void axisReaches(
    String name,
    Widget Function() build, {
    required Finder Function() finder,
  }) {
    group(name, () {
      testWidgets('filled: fill próprio, sem borda e sem sombra', (
        tester,
      ) async {
        await tester.pumpWidget(_host(build(), style: AppStyle.filled));
        final BoxDecoration d = _decoOf(tester, finder());
        expect(d.color, isNotNull);
        expect(d.border, isNull);
        expect(d.boxShadow, isNull);
      });

      testWidgets('outlined acrescenta a borda', (tester) async {
        await tester.pumpWidget(_host(build(), style: AppStyle.outlined));
        final BoxDecoration d = _decoOf(tester, finder());
        expect(
          d.border,
          isNotNull,
          reason:
              'uma marca em `outlined` não pode deixar esta caixa sem borda',
        );
        expect(d.boxShadow, isNull);
      });

      testWidgets('elevated acrescenta a sombra, e só ela', (tester) async {
        await tester.pumpWidget(_host(build(), style: AppStyle.elevated));
        final BoxDecoration d = _decoOf(tester, finder());
        expect(d.boxShadow, isNotNull);
        expect(
          d.border,
          isNull,
          reason: 'no elevated é a SOMBRA que separa — borda junto seria dobra',
        );
      });
    });
  }

  axisReaches(
    'AppShortcutHint',
    () => const AppShortcutHint(AppShortcut('Enter')),
    finder: () => find.byType(DecoratedBox),
  );

  axisReaches(
    'AppShell · cartão de conteúdo',
    () => const SizedBox(
      width: 900,
      height: 600,
      child: AppShell(content: SizedBox.expand()),
    ),
    finder: () => find.byType(DecoratedBox),
  );

  testWidgets('AppAssistantPanel · decoration explícita vence o eixo', (
    tester,
  ) async {
    // O eixo é o DEFAULT, não uma imposição: quem passa `decoration` está
    // dizendo exatamente o que quer, e o global não pode sobrescrever isso.
    const BoxDecoration custom = BoxDecoration(color: Color(0xFF123456));
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 400,
          height: 600,
          child: AppAssistantPanel(body: SizedBox.expand(), decoration: custom),
        ),
        style: AppStyle.outlined,
      ),
    );

    final Iterable<BoxDecoration> boxes = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((DecoratedBox d) => d.decoration)
        .whereType<BoxDecoration>();
    expect(boxes.where((BoxDecoration d) => d == custom), hasLength(1));
  });
}
