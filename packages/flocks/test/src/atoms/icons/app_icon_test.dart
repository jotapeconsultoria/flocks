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

/// Como [_host], mas com folga em volta.
///
/// A raiz do `pumpWidget` impõe constraints APERTADAS de 800x600, e sob elas até
/// um `SizedBox.shrink` ocupa a tela inteira. Os call sites reais põem o ícone
/// dentro de Center/Align/FittedBox — o `Center` aqui reproduz essa folga, senão
/// o teste de tamanho mediria o harness em vez do widget.
Widget _loose(Widget child) => _host(Center(child: child));

void main() {
  const url = 'https://cdn.example.com/i.svg';

  testWidgets('sem semanticLabel → decorativo (ExcludeSemantics)', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const AppIcon(url)));
    expect(find.byType(ExcludeSemantics), findsOneWidget);
  });

  testWidgets('com semanticLabel → nó de semântica com o rótulo', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_host(const AppIcon(url, semanticLabel: 'Alerta')));
    expect(find.bySemanticsLabel('Alerta'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('placeholder respeita customSize enquanto carrega', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const AppIcon(url, customSize: 40)));
    final matching = tester
        .widgetList<SizedBox>(find.byType(SizedBox))
        .where((b) => b.width == 40 && b.height == 40);
    expect(matching, isNotEmpty);
  });

  // Ausência de asset é estado desenhável, não exceção. Um app cuja ficha de
  // identidade não declara base de assets passa `null` aqui — sem isto, cada
  // call site teria de escrever a mesma guarda, e o primeiro a esquecer volta
  // para o `?? ''`, que é a URL quebrada de novo.
  testWidgets('null não desenha nada', (tester) async {
    await tester.pumpWidget(_loose(const AppIcon(null)));
    expect(tester.getSize(find.byType(AppIcon)), Size.zero);
  });

  testWidgets('com slug OCUPA espaço — o par que prova o contraste', (
    tester,
  ) async {
    // Sem este, o teste acima ficaria verde se o AppIcon parasse de desenhar por
    // qualquer motivo. Zero tem de ser consequência do `null`, não o estado
    // normal do widget.
    await tester.pumpWidget(_loose(const AppIcon(AppIconToken.check)));
    expect(tester.getSize(find.byType(AppIcon)), isNot(Size.zero));
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_icon' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
