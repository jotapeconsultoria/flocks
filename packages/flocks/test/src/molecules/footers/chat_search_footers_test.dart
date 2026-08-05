import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flocks/src/atoms/bars/app_bar_surface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Os dois rodapés de BARRA. A regra que os dois compartilham, e que estes
// testes travam: o controle de dentro (composer / campo de busca) não carrega
// estilo próprio — quem carrega é a barra. Duplo-styling é o bug que aparece
// quando alguém "só" muda o estilo do rodapé e a pílula de dentro muda junto.

/// ⚠️ `Overlay(initialEntries:)` só usa a lista na PRIMEIRA construção: um
/// `pumpWidget` seguinte NÃO troca a entry, e o child fica preso na versão
/// original. Por isso o host recebe uma [key] — quem pumpa duas variações no
/// mesmo teste tem de passar chaves diferentes, senão mede a primeira duas
/// vezes e o teste passa a validar nada.
Widget _host(
  Widget child, {
  EdgeInsets viewPadding = EdgeInsets.zero,
  Key? key,
}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(
      viewPadding: viewPadding,
      padding: viewPadding,
      disableAnimations: true,
    ),
    child: AppTheme(
      data: AppThemeData.light,
      // A seleção nativa do `EditableText` (handles/toolbar) exige um
      // Overlay ancestral — que um MaterialApp daria de graça.
      child: Overlay(
        key: key,
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (_) => Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(width: 420, child: child),
            ),
          ),
        ],
      ),
    ),
  ),
);

void main() {
  group('AppChatFooter', () {
    testWidgets('envolve o composer e força style: filled nele', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _host(
          AppChatFooter(
            controller: controller,
            hintText: 'Pergunte alguma coisa…',
            style: AppStyle.outlined,
            onSend: () {},
          ),
        ),
      );

      expect(find.byType(AppChatComposer), findsOneWidget);
      // A barra é outlined, mas o composer continua filled: o estilo mora na
      // barra, senão a pílula ganha borda junto e o rodapé lê como dois
      // controles empilhados.
      final AppChatComposer composer = tester.widget<AppChatComposer>(
        find.byType(AppChatComposer),
      );
      expect(composer.style, AppStyle.filled);
    });

    testWidgets('reserva a safe-area inferior (o composer não trata)', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      Future<double> heightWith(EdgeInsets viewPadding) async {
        await tester.pumpWidget(
          _host(
            key: ValueKey<double>(viewPadding.bottom),
            AppChatFooter(controller: controller, onSend: () {}),
            viewPadding: viewPadding,
          ),
        );
        return tester.getSize(find.byType(AppChatFooter)).height;
      }

      final double flat = await heightWith(EdgeInsets.zero);
      final double inset = await heightWith(const EdgeInsets.only(bottom: 34));
      expect(inset - flat, 34);
    });

    testWidgets('floating recua a barra das bordas; docked é full-bleed', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      Future<double> barInset({required bool floating}) async {
        await tester.pumpWidget(
          _host(
            key: ValueKey<bool>(floating),
            AppChatFooter(
              controller: controller,
              floating: floating,
              onSend: () {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        final Rect footer = tester.getRect(find.byType(AppChatFooter));
        final Rect bar = tester.getRect(find.byType(AppBarSurface));
        return bar.left - footer.left;
      }

      expect(await barInset(floating: false), 0);
      expect(await barInset(floating: true), greaterThan(0));
    });
  });

  group('AppSearchFooter', () {
    testWidgets('mostra o campo e propaga o texto digitado', (
      WidgetTester tester,
    ) async {
      String? typed;
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _host(
          AppSearchFooter(
            controller: controller,
            hintText: 'Buscar',
            onChanged: (String v) => typed = v,
          ),
        ),
      );

      expect(find.byType(AppInput), findsOneWidget);
      // O campo do DS é um `EditableText` cru (sem Material), então a
      // digitação entra por ele, não pelo wrapper.
      await tester.enterText(find.byType(EditableText), 'ABC1D23');
      await tester.pump();
      expect(typed, 'ABC1D23');
      expect(controller.text, 'ABC1D23');
    });

    testWidgets('o trailing fica FORA da cápsula do campo', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _host(
          AppSearchFooter(
            controller: controller,
            trailing: AppButton(
              icon: AppIcons.add,
              semanticsLabel: 'Compor',
              onPressed: () {},
            ),
          ),
        ),
      );

      // O trailing é um alvo isolado (um FAB de compor), não um sufixo do
      // campo: se caísse dentro, tocar nele posicionaria o caret.
      expect(
        find.descendant(
          of: find.byType(AppInput),
          matching: find.bySemanticsLabel('Compor'),
        ),
        findsNothing,
      );
      expect(find.bySemanticsLabel('Compor'), findsOneWidget);
    });

    testWidgets('reserva a safe-area inferior', (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      Future<double> heightWith(EdgeInsets viewPadding) async {
        await tester.pumpWidget(
          _host(
            key: ValueKey<double>(viewPadding.bottom),
            AppSearchFooter(controller: controller),
            viewPadding: viewPadding,
          ),
        );
        return tester.getSize(find.byType(AppSearchFooter)).height;
      }

      final double flat = await heightWith(EdgeInsets.zero);
      final double inset = await heightWith(const EdgeInsets.only(bottom: 34));
      expect(inset - flat, 34);
    });
  });

  test('os dois rodapés estão no catálogo como migrados', () {
    for (final String id in <String>['app_chat_footer', 'app_search_footer']) {
      expect(
        flocksCatalog.any(
          (AppComponentMeta m) =>
              m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id ausente',
      );
    }
  });
}
