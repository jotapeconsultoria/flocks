import 'package:flocks/flocks.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Barra estreita com abas que NÃO cabem — é o caso em que a rolagem importa.
Widget _host() => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(300, 400), disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(
        child: SizedBox(
          width: 300,
          height: 400,
          child: AppTabView(
            items: <AppTabViewItem>[
              for (final String label in <String>[
                'Cadastro',
                'Dados operacionais',
                'Marca e jurídico',
                'Técnico',
                'Status',
              ])
                AppTabViewItem(
                  label: label,
                  builder: (BuildContext _) => AppText('painel $label'),
                ),
            ],
          ),
        ),
      ),
    ),
  ),
);

double _scrollOffset(WidgetTester tester) => tester
    .state<ScrollableState>(find.byType(Scrollable).first)
    .position
    .pixels;

void main() {
  testWidgets('arrastar com o mouse rola a barra de abas', (tester) async {
    await tester.binding.setSurfaceSize(const Size(300, 400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    final Rect bar = tester.getRect(find.byType(Scrollable).first);
    final Offset barCenter = Offset(bar.center.dx, bar.center.dy);
    // Sem `dragDevices` incluindo o mouse, este gesto não rolava nada e as abas
    // escondidas ficavam inalcançáveis no desktop (revisão P1r9).
    // Com o MOUSE: sem `dragDevices` incluindo o ponteiro, este gesto não
    // rolava nada e as abas escondidas ficavam inalcançáveis no desktop
    // (revisão P1r9).
    await tester.dragFrom(
      barCenter,
      const Offset(-120, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();

    expect(_scrollOffset(tester), greaterThan(0));
  });

  testWidgets('tocar numa aba cortada traz ela para a área visível', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(300, 400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    // Rola até a aba seguinte aparecer PELA METADE.
    await tester.dragFrom(
      tester.getCenter(find.byType(AppTabView)).translate(0, -180),
      const Offset(-60, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();

    final Rect viewport = tester.getRect(find.byType(AppTabView));
    final Finder cut = find.text('Marca e jurídico');
    final Rect before = tester.getRect(cut);
    final double offsetBefore = _scrollOffset(tester);
    expect(
      before.right,
      greaterThan(viewport.right),
      reason: 'a aba precisa estar cortada para o teste valer',
    );

    // Toca no PEDAÇO VISÍVEL da aba: o centro dela está fora da tela, e um
    // toque lá não acerta nada (o teste passaria sem acionar coisa alguma).
    await tester.tapAt(Offset(viewport.right - 4, before.center.dy));
    await tester.pumpAndSettle();

    // A barra ROLOU por causa do toque: a aba cortada foi trazida para dentro.
    final Rect after = tester.getRect(cut);
    expect(
      after.right,
      lessThan(before.right),
      reason: 'o toque numa aba cortada tem de rolar a barra até ela',
    );
    expect(_scrollOffset(tester), greaterThan(offsetBefore));
  });
}
