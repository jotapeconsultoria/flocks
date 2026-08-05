import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({required double contentHeight, ScrollController? controller}) =>
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(
          size: Size(400, 300),
          disableAnimations: true,
        ),
        child: AppTheme(
          data: AppThemeData.light,
          child: Center(
            child: SizedBox(
              height: 300,
              width: 400,
              child: AppScrollEdgeFade(
                child: SingleChildScrollView(
                  controller: controller,
                  child: SizedBox(height: contentHeight),
                ),
              ),
            ),
          ),
        ),
      ),
    );

/// Quantos véus estão pintados agora.
int _veils(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(AppScrollEdgeFade),
        matching: find.byType(DecoratedBox),
      ),
    )
    .where(
      (DecoratedBox box) => (box.decoration as BoxDecoration).gradient != null,
    )
    .length;

void main() {
  testWidgets('sem rolagem possível, nenhum véu é pintado', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 300));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_host(contentHeight: 100));
    await tester.pumpAndSettle();

    // Um degradê permanente sugeriria conteúdo escondido que não existe.
    expect(_veils(tester), 0);
  });

  testWidgets('com conteúdo abaixo, o véu de baixo aparece; ao rolar até o '
      'fim, o de cima', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 300));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(contentHeight: 900, controller: controller));
    await tester.pumpAndSettle();

    // No topo: só há conteúdo ADIANTE.
    expect(_veils(tester), 1);

    controller.jumpTo(300);
    await tester.pumpAndSettle();
    // No meio: conteúdo dos dois lados.
    expect(_veils(tester), 2);

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();
    // No fim: só há conteúdo ATRÁS.
    expect(_veils(tester), 1);
  });

  testWidgets('um descendente que assume o véu desliga o do ancestral', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 300));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);

    Widget host({required bool owned}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(400, 300)),
        child: AppTheme(
          data: AppThemeData.light,
          child: Center(
            child: SizedBox(
              height: 300,
              width: 400,
              child: AppScrollEdgeFade(
                child: Builder(
                  builder: (BuildContext context) {
                    final Widget body = SingleChildScrollView(
                      controller: controller,
                      child: const SizedBox(height: 900),
                    );
                    return owned ? AppScrollEdgeFadeOwner(child: body) : body;
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(host(owned: false));
    await tester.pumpAndSettle();
    expect(_veils(tester), 1, reason: 'sem dono, o ancestral pinta');

    // O ancestral continua OUVINDO a rolagem (é o mesmo scrollable), mas quem
    // manda no véu agora é o descendente — e ele não pinta nenhum aqui.
    await tester.pumpWidget(host(owned: true));
    await tester.pumpAndSettle();
    expect(_veils(tester), 0);

    // Ao sair, o ancestral reassume — senão a área ficaria sem véu para sempre.
    await tester.pumpWidget(host(owned: false));
    await tester.pumpAndSettle();
    expect(_veils(tester), 1);
  });
}
