import 'package:flocks/flocks.dart';
// A largura da gutter é interna (não vai ao baril) e é a medida que o "X" tem de
// vencer para escapar da faixa.
import 'package:flocks/src/organisms/side_sheets/side_sheet_surface.dart'
    show kSideSheetHandleHitWidth;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// O respiro lateral da sheet é PUBLICADO ao conteúdo em vez de recuar a faixa.
///
/// Recuando a faixa, recuava junto o viewport da rolagem — e a barra de rolagem,
/// que mora na borda do viewport, aparecia flutuando longe da lateral da sheet
/// (revisão P1r10).
void main() {
  testWidgets('a faixa do corpo vai até a borda e o recuo vem no MediaQuery', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    late EdgeInsets published;
    late BuildContext trigger;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(1200, 800)),
          child: AppTheme(
            data: AppThemeData.light,
            child: Navigator(
              onGenerateRoute: (_) => PageRouteBuilder<void>(
                pageBuilder: (BuildContext c, _, _) {
                  trigger = c;
                  return const SizedBox.expand();
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // ignore: unawaited_futures
    showAppSideSheet<void>(
      context: trigger,
      draggable: true,
      showHandle: true,
      child: Builder(
        builder: (BuildContext c) {
          published = MediaQuery.paddingOf(c);
          return const SizedBox.expand(key: ValueKey<String>('corpo'));
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(
      published.left,
      greaterThan(0),
      reason:
          'o recuo precisa CHEGAR ao conteúdo — é ele que tira o texto de baixo '
          'da gutter de arraste',
    );
    expect(published.right, greaterThan(0));

    // A faixa do corpo tem a largura inteira da superfície: nada de `Padding`
    // horizontal em volta dela.
    final double bodyWidth = tester
        .getSize(find.byKey(const ValueKey<String>('corpo')))
        .width;
    final double surfaceWidth = tester
        .getSize(find.byType(AppScrollEdgeFade))
        .width;
    expect(bodyWidth, surfaceWidth);
  });

  // O respiro é do CONTEÚDO. Somado ao recuo próprio da barra de topo e do
  // rodapé, o "X" e os botões afundavam para dentro como se a sheet tivesse duas
  // margens (revisão P1r11).
  testWidgets('a barra de topo e o rodapé vão de borda a borda', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpSheet(
      tester,
      closeSide: AppSheetCloseSide.end,
      footer: const SizedBox(key: ValueKey<String>('rodape'), height: 48),
    );

    final Rect band = tester.getRect(find.byType(AppScrollEdgeFade));
    final Rect footer = tester.getRect(
      find.byKey(const ValueKey<String>('rodape')),
    );
    expect(footer.left, band.left);
    expect(footer.right, band.right);

    // Fechar na borda EXTERNA: só o recuo próprio da barra.
    final Rect close = tester.getRect(find.byType(AppButton));
    expect(band.right - close.right, AppSpacings.s16);
  });

  // A gutter é opaca ao ponteiro: com o "X" do lado dela, ele nascia embaixo da
  // faixa e perdia parte do alvo de clique.
  testWidgets('o botão de fechar escapa da gutter quando fica do lado dela', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpSheet(tester, closeSide: AppSheetCloseSide.start);

    final Rect band = tester.getRect(find.byType(AppScrollEdgeFade));
    final Rect close = tester.getRect(find.byType(AppButton));
    expect(close.left - band.left, kSideSheetHandleHitWidth);
  });
}

/// Abre uma sheet ARRASTÁVEL (a que tem gutter) ancorada à direita.
Future<void> _pumpSheet(
  WidgetTester tester, {
  required AppSheetCloseSide closeSide,
  Widget? footer,
}) async {
  late BuildContext trigger;

  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(1200, 800)),
        child: AppTheme(
          data: AppThemeData.light,
          child: Navigator(
            onGenerateRoute: (_) => PageRouteBuilder<void>(
              pageBuilder: (BuildContext c, _, _) {
                trigger = c;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  // ignore: unawaited_futures
  showAppSideSheet<void>(
    context: trigger,
    draggable: true,
    showHandle: true,
    closeSide: closeSide,
    title: 'Título',
    footer: footer,
    child: const SizedBox.expand(),
  );
  await tester.pumpAndSettle();
}
