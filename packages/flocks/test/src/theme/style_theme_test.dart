import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

AppThemeData _withStyle(AppStyleTheme style) {
  final base = AppThemeData.light;
  return AppThemeData(
    brightness: base.brightness,
    colorTheme: base.colorTheme,
    textTheme: base.textTheme,
    styleTheme: style,
  );
}

void main() {
  test('AppStyleTheme.standard é filled', () {
    expect(AppStyleTheme.standard.style, AppStyle.filled);
  });

  test('copyWith sobrescreve o style', () {
    final t = AppStyleTheme.standard.copyWith(style: AppStyle.elevated);
    expect(t.style, AppStyle.elevated);
    expect(AppStyleTheme.standard.style, AppStyle.filled);
  });

  test('AppThemeData default carrega styleTheme.standard', () {
    expect(AppThemeData.light.styleTheme, AppStyleTheme.standard);
    expect(AppThemeData.dark.styleTheme, AppStyleTheme.standard);
  });

  testWidgets('AppSurface reflete o style do tema (outlined ⇒ borda outline)', (
    tester,
  ) async {
    final theme = _withStyle(const AppStyleTheme(style: AppStyle.outlined));
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AppTheme(
          data: theme,
          child: const Center(
            child: AppSurface(child: SizedBox(width: 40, height: 40)),
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.border, isNotNull);
    final side = (decoration.border! as Border).top;
    expect(side.color, theme.colorTheme.outline);
    expect(decoration.boxShadow, anyOf(isNull, isEmpty));
  });

  testWidgets('AppSurface reflete o style do tema (elevated ⇒ sombra)', (
    tester,
  ) async {
    final theme = _withStyle(const AppStyleTheme(style: AppStyle.elevated));
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AppTheme(
          data: theme,
          child: const Center(
            child: AppSurface(child: SizedBox(width: 40, height: 40)),
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.boxShadow, isNotEmpty);
  });

  testWidgets('o param style do componente sobrescreve o global', (
    tester,
  ) async {
    // Global filled, componente pede elevated.
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AppTheme(
          data: AppThemeData.light, // styleTheme = filled
          child: const Center(
            child: AppSurface(
              style: AppStyle.elevated,
              child: SizedBox(width: 40, height: 40),
            ),
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.boxShadow, isNotEmpty);
  });
}
