// O ramo web desta fachada é compilado por NADA nesta suíte — `flutter test`
// roda na VM, e o `<div>` de interceptação só existe no browser. O que dá para
// fiscalizar aqui é o outro lado do contrato, que é onde os goldens apostam: o
// ramo default tem de ser passa-direto de verdade.
import 'package:flocks/flocks.dart';
import 'package:flocks/src/foundation/pointer/pointer_interceptor_stub.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('o stub devolve a MESMA instância, não um wrapper', () {
    const Widget child = SizedBox.shrink();
    // `identical`, e não `equals`: um wrapper que renderizasse igual passaria
    // num teste de igualdade e ainda assim mudaria a árvore de elementos que
    // `app_overlay_card_test.dart` percorre.
    expect(identical(interceptPointer(child), child), isTrue);
  });

  testWidgets('fora do web o AppOverlayCard não ganha Stack nenhum', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: AppTheme(
            data: AppThemeData.light.copyWith(
              glassTheme: const AppGlassTheme(enabled: false),
            ),
            child: const Center(child: AppOverlayCard(child: Text('c'))),
          ),
        ),
      ),
    );

    expect(find.text('c'), findsOneWidget);
    // O `Stack` é a assinatura do ramo web (`Positioned.fill` + `child`). Vê-lo
    // aqui significaria que a condição do import condicional passou a escolher
    // o ramo errado na VM — e os 4 goldens do card iriam junto.
    expect(
      find.descendant(
        of: find.byType(AppOverlayCard),
        matching: find.byType(Stack),
      ),
      findsNothing,
    );
  });
}
