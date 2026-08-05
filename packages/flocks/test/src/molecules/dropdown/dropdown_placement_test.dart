import 'package:flocks/flocks.dart';
import 'package:flocks/src/molecules/card/app_overlay_panel.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const List<AppDropdownOption<String>> _opts = <AppDropdownOption<String>>[
  AppDropdownOption<String>(value: 'a', label: 'Alpha'),
  AppDropdownOption<String>(value: 'b', label: 'Bravo'),
  AppDropdownOption<String>(value: 'c', label: 'Charlie'),
  AppDropdownOption<String>(value: 'd', label: 'Delta'),
  AppDropdownOption<String>(value: 'e', label: 'Echo'),
  AppDropdownOption<String>(value: 'f', label: 'Foxtrot'),
  AppDropdownOption<String>(value: 'g', label: 'Golf'),
  AppDropdownOption<String>(value: 'h', label: 'Hotel'),
];

/// Coloca o dropdown numa posição vertical arbitrária da tela — é a distância
/// até o rodapé que decide para que lado o painel abre.
Widget _hostAt(double top) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(600, 600), disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (BuildContext context) => Stack(
              children: <Widget>[
                Positioned(
                  left: 24,
                  top: top,
                  width: 300,
                  child: AppDropdown<String>(
                    options: _opts,
                    hintText: 'Selecione',
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);

/// Retângulo global do painel de opções (o cartão flutuante do overlay).
Rect _panelRect(WidgetTester tester) {
  final RenderBox box = tester.renderObject<RenderBox>(
    find.byType(AppOverlayPanel).first,
  );
  final Offset topLeft = box.localToGlobal(Offset.zero);
  return topLeft & box.size;
}

Rect _triggerRect(WidgetTester tester) {
  final RenderBox box = tester.renderObject<RenderBox>(
    find.byType(CompositedTransformTarget).first,
  );
  return box.localToGlobal(Offset.zero) & box.size;
}

void main() {
  testWidgets('com espaço embaixo, o painel abre PARA BAIXO', (tester) async {
    await tester.binding.setSurfaceSize(const Size(600, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_hostAt(40));
    await tester.tap(find.text('Selecione'));
    await tester.pumpAndSettle();

    final Rect panel = _panelRect(tester);
    final Rect trigger = _triggerRect(tester);
    expect(
      panel.top,
      greaterThanOrEqualTo(trigger.bottom),
      reason: 'o comportamento normal continua sendo abrir abaixo do campo',
    );
    expect(panel.bottom, lessThanOrEqualTo(600));
    // A opção continua clicável no arranjo normal.
    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();
    expect(find.byType(AppOverlayPanel), findsNothing);
  });

  testWidgets('sem espaço embaixo, o painel abre PARA CIMA e cabe na tela', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(600, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // Campo colado no rodapé: abrir para baixo jogaria a lista para fora da
    // tela e não haveria como escolher opção nenhuma (revisão P1r9).
    await tester.pumpWidget(_hostAt(520));
    await tester.tap(find.text('Selecione'));
    await tester.pumpAndSettle();

    final Rect panel = _panelRect(tester);
    final Rect trigger = _triggerRect(tester);
    expect(
      panel.bottom,
      lessThanOrEqualTo(trigger.top + 0.5),
      reason: 'o painel tem de ficar ACIMA do campo',
    );
    expect(
      panel.top,
      greaterThanOrEqualTo(0),
      reason: 'e inteiro dentro da tela',
    );

    // E a lista continua UTILIZÁVEL: tocar a opção seleciona e fecha. Não
    // basta o painel aparecer no lugar certo — ele precisa receber o toque, e
    // era exatamente isso que uma primeira tentativa (deslocar por
    // `Transform`) deixava de fazer.
    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();
    expect(find.byType(AppOverlayPanel), findsNothing);
  });
}
