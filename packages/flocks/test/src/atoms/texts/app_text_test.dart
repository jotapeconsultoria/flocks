import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {bool dark = false}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: dark ? AppThemeData.dark : AppThemeData.light,
      child: child,
    ),
  ),
);

void main() {
  testWidgets('renderiza o texto', (tester) async {
    await tester.pumpWidget(_host(const AppText('Olá')));
    expect(find.text('Olá'), findsOneWidget);
  });

  testWidgets('usa data como semanticsLabel por padrão', (tester) async {
    await tester.pumpWidget(_host(const AppText('Placa')));
    final text = tester.widget<Text>(find.byType(Text));
    expect(text.semanticsLabel, 'Placa');
  });

  testWidgets('cor default (sem style) vem do onSurface do tema', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const AppText('X')));
    final text = tester.widget<Text>(find.byType(Text));
    expect(text.style?.color, AppThemeData.light.colorTheme.onSurface);
  });

  testWidgets('adapta a cor ao dark (e dark difere do claro)', (tester) async {
    await tester.pumpWidget(_host(const AppText('X'), dark: true));
    final text = tester.widget<Text>(find.byType(Text));
    expect(text.style?.color, AppThemeData.dark.colorTheme.onSurface);
    expect(
      AppThemeData.dark.colorTheme.onSurface,
      isNot(AppThemeData.light.colorTheme.onSurface),
    );
  });

  testWidgets('é selecionável (envolve AppSelectionRegion)', (tester) async {
    await tester.pumpWidget(_host(const AppText('sel')));
    expect(find.byType(AppSelectionRegion), findsOneWidget);
  });

  testWidgets('está no catálogo como migrado', (tester) async {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_text' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
