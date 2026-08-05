import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Precedência (`style:` do widget > global `styleTheme` > default filled) e o
// mapeamento filled/outlined/elevated dos selectors sobre o fill semântico do
// estado. Lê a decoração-alvo do AnimatedContainer (o valor que passamos, não a
// interpolação), então não precisa assentar animação.

Widget _host(AppThemeData data, Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: data,
      child: Center(child: child),
    ),
  ),
);

BoxDecoration _animatedDecoration(WidgetTester tester, Type owner) {
  final AnimatedContainer c = tester.widget<AnimatedContainer>(
    find.descendant(
      of: find.byType(owner),
      matching: find.byType(AnimatedContainer),
    ),
  );
  return c.decoration! as BoxDecoration;
}

AppThemeData _lightWithStyle(AppStyle style) =>
    AppThemeData.light.copyWith(styleTheme: AppStyleTheme(style: style));

void main() {
  group('AppCheckbox · eixo AppStyle', () {
    testWidgets('sem style → herda o global (elevated ⇒ sombra, sem borda)', (
      tester,
    ) async {
      final AppThemeData data = _lightWithStyle(AppStyle.elevated);
      await tester.pumpWidget(
        _host(data, AppCheckbox(checked: false, onChanged: (_) {})),
      );
      final BoxDecoration deco = _animatedDecoration(tester, AppCheckbox);
      expect(deco.boxShadow, isNotNull);
      expect(deco.border, isNull);
      // Vazio em filled/elevated = poço neutro (s200), distinto da superfície.
      expect(deco.color, data.colorTheme.neutralPrimary.s200);
    });

    testWidgets(
      'style explícito vence o global (outlined sob global elevated)',
      (tester) async {
        final AppThemeData data = _lightWithStyle(AppStyle.elevated);
        await tester.pumpWidget(
          _host(
            data,
            AppCheckbox(
              checked: false,
              style: AppStyle.outlined,
              onChanged: (_) {},
            ),
          ),
        );
        final BoxDecoration deco = _animatedDecoration(tester, AppCheckbox);
        expect(deco.border, isNotNull);
        expect(deco.boxShadow, isNull);
      },
    );

    testWidgets('filled vazio = poço surfaceContainer sem borda', (
      tester,
    ) async {
      final AppThemeData data = AppThemeData.light;
      await tester.pumpWidget(
        _host(
          data,
          AppCheckbox(
            checked: false,
            style: AppStyle.filled,
            onChanged: (_) {},
          ),
        ),
      );
      final BoxDecoration deco = _animatedDecoration(tester, AppCheckbox);
      expect(deco.border, isNull);
      expect(deco.boxShadow, isNull);
      expect(deco.color, data.colorTheme.neutralPrimary.s200);
    });

    testWidgets('outlined vazio = ghost transparente + borda', (tester) async {
      await tester.pumpWidget(
        _host(
          AppThemeData.light,
          AppCheckbox(
            checked: false,
            style: AppStyle.outlined,
            onChanged: (_) {},
          ),
        ),
      );
      final BoxDecoration deco = _animatedDecoration(tester, AppCheckbox);
      expect(deco.border, isNotNull);
      // Vazio outlined: sem fill próprio → cor nula (transparente).
      expect(deco.color, isNull);
    });
  });

  group('AppSwitch · eixo AppStyle', () {
    testWidgets('sem style → herda o global (elevated ⇒ trilho com sombra)', (
      tester,
    ) async {
      final AppThemeData data = _lightWithStyle(AppStyle.elevated);
      await tester.pumpWidget(
        _host(data, AppSwitch(value: true, onChanged: (_) {})),
      );
      final BoxDecoration deco = _animatedDecoration(tester, AppSwitch);
      expect(deco.boxShadow, isNotNull);
      // Ligado = trilho primary (fill semântico preservado).
      expect(deco.color, data.colorTheme.primary);
    });

    testWidgets('outlined desligado = trilho vazado + borda em foreground', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          AppThemeData.light,
          AppSwitch(value: false, style: AppStyle.outlined, onChanged: (_) {}),
        ),
      );
      final BoxDecoration deco = _animatedDecoration(tester, AppSwitch);
      // Trilho transparente (vazado): sem fill próprio no off.
      expect(deco.color, isNull);
      expect(deco.boxShadow, isNull);
      // A borda do outlined vai numa DecoratedBox de primeiro plano (não no
      // AnimatedContainer, p/ não estreitar a faixa e cortar o thumb).
      final Iterable<DecoratedBox> withBorder = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(AppSwitch),
              matching: find.byType(DecoratedBox),
            ),
          )
          .where(
            (DecoratedBox d) => (d.decoration as BoxDecoration).border != null,
          );
      expect(withBorder, isNotEmpty);
    });
  });
}
