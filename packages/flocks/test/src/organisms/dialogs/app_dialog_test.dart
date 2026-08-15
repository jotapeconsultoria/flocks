import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light.copyWith(
        glassTheme: const AppGlassTheme(enabled: false),
      ),
      child: Center(child: child),
    ),
  ),
);

BoxDecoration _dialogDecoration(WidgetTester tester) =>
    tester
            .widgetList<DecoratedBox>(
              find.descendant(
                of: find.byType(AppDialog),
                matching: find.byType(DecoratedBox),
              ),
            )
            .first
            .decoration
        as BoxDecoration;

void main() {
  testWidgets('AppDialog renderiza o child e o footer', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialog(footer: Text('Rodapé'), child: Text('Corpo')),
        ),
      ),
    );
    expect(find.text('Corpo'), findsOneWidget);
    expect(find.text('Rodapé'), findsOneWidget);
  });

  // Eixo AppStyle: default próprio `elevated` (sombra, sem borda); `outlined`
  // troca a sombra por borda; `filled` deixa chapado.
  testWidgets('style: default elevated tem sombra e não borda', (tester) async {
    await tester.pumpWidget(
      _host(const SizedBox(width: 440, child: AppDialog(child: Text('x')))),
    );
    final BoxDecoration d = _dialogDecoration(tester);
    expect(d.boxShadow, isNotNull);
    expect(d.boxShadow, isNotEmpty);
    expect(d.border, isNull);
  });

  testWidgets('style: outlined desenha borda e não sombra', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialog(style: AppStyle.outlined, child: Text('x')),
        ),
      ),
    );
    final BoxDecoration d = _dialogDecoration(tester);
    expect(d.border, isNotNull);
    expect(d.boxShadow, anyOf(isNull, isEmpty));
  });

  testWidgets('style: filled sem borda e sem sombra', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialog(style: AppStyle.filled, child: Text('x')),
        ),
      ),
    );
    final BoxDecoration d = _dialogDecoration(tester);
    expect(d.border, isNull);
    expect(d.boxShadow, anyOf(isNull, isEmpty));
  });

  testWidgets('AppDialogContent mostra título e mensagem', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialogContent(
            title: 'Título',
            message: 'Mensagem',
            illustration: 'x.svg',
          ),
        ),
      ),
    );
    expect(find.text('Título'), findsOneWidget);
    expect(find.text('Mensagem'), findsOneWidget);
  });

  testWidgets('showAppDialog abre o modal e o barrier fecha', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: AppTheme(
            data: AppThemeData.light.copyWith(
              glassTheme: const AppGlassTheme(enabled: false),
            ),
            child: Navigator(
              onGenerateRoute: (_) => PageRouteBuilder<void>(
                pageBuilder: (BuildContext context, _, _) => Center(
                  child: GestureDetector(
                    onTap: () => showAppDialog<void>(
                      context: context,
                      child: const Text('CorpoModal'),
                    ),
                    child: const Text('Abrir'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('CorpoModal'), findsOneWidget);

    // Toca no barrier (canto superior-esquerdo, fora do card central).
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.text('CorpoModal'), findsNothing);
  });

  // ---------------------------------------------------------------------
  // Barra de topo — a mesma das sheets, com o título alinhado ao início.
  // ---------------------------------------------------------------------

  testWidgets('header: mostra o título', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialog(title: 'Corrigir', child: Text('Corpo')),
        ),
      ),
    );
    expect(find.text('Corrigir'), findsOneWidget);
  });

  testWidgets('header: o botão de fechar vem ligado por padrão', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const SizedBox(width: 440, child: AppDialog(child: Text('x')))),
    );
    expect(find.bySemanticsLabel('Fechar'), findsOneWidget);
  });

  testWidgets('header: showCloseButton false esconde o botão', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialog(
            title: 'T',
            showCloseButton: false,
            child: Text('x'),
          ),
        ),
      ),
    );
    expect(find.text('T'), findsOneWidget);
    expect(find.bySemanticsLabel('Fechar'), findsNothing);
  });

  // Sem título e sem botão a barra não existe — não pode sobrar um vão de 64px.
  testWidgets('header: sem título e sem botão não ocupa altura', (
    tester,
  ) async {
    Future<double> heightOf(Widget dialog) async {
      await tester.pumpWidget(_host(SizedBox(width: 440, child: dialog)));
      return tester.getSize(find.byType(AppDialog)).height;
    }

    final double comBarra = await heightOf(
      const AppDialog(child: SizedBox(height: 100)),
    );
    final double semBarra = await heightOf(
      const AppDialog(showCloseButton: false, child: SizedBox(height: 100)),
    );
    expect(comBarra - semBarra, 64.0);
  });

  testWidgets('header: onCloseButton sobrescreve o pop', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 440,
          child: AppDialog(onCloseButton: () => taps++, child: const Text('x')),
        ),
      ),
    );
    await tester.tap(find.bySemanticsLabel('Fechar'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('header: o "X" fecha a rota do showAppDialog', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: AppTheme(
            data: AppThemeData.light.copyWith(
              glassTheme: const AppGlassTheme(enabled: false),
            ),
            child: Navigator(
              onGenerateRoute: (_) => PageRouteBuilder<void>(
                pageBuilder: (BuildContext context, _, _) => Center(
                  child: GestureDetector(
                    onTap: () => showAppDialog<void>(
                      context: context,
                      title: 'Título',
                      child: const Text('CorpoModal'),
                    ),
                    child: const Text('Abrir'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('CorpoModal'), findsOneWidget);

    // O barrier da rota TAMBÉM se chama "Fechar" — daí o escopo no card.
    await tester.tap(
      find.descendant(
        of: find.byType(AppDialog),
        matching: find.bySemanticsLabel('Fechar'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('CorpoModal'), findsNothing);
  });

  // `end` é o default do dialog (≠ side sheet, que resolve pelo canto interno).
  testWidgets('closeSide: default end põe o "X" à direita', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialog(title: 'T', child: Text('x')),
        ),
      ),
    );
    expect(
      tester.getCenter(find.bySemanticsLabel('Fechar')).dx,
      greaterThan(tester.getCenter(find.byType(AppDialog)).dx),
    );
  });

  testWidgets('closeSide: start põe o "X" à esquerda', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialog(
            title: 'T',
            closeSide: AppSheetCloseSide.start,
            child: Text('x'),
          ),
        ),
      ),
    );
    expect(
      tester.getCenter(find.bySemanticsLabel('Fechar')).dx,
      lessThan(tester.getCenter(find.byType(AppDialog)).dx),
    );
  });

  // `start`/`end` são relativos à direção do texto: em RTL o `end` é a ESQUERDA
  // física. Se algum dia isto virar `left`/`right`, este teste acusa.
  testWidgets('closeSide: em RTL o end vai para a esquerda física', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.rtl,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: AppTheme(
            data: AppThemeData.light.copyWith(
              glassTheme: const AppGlassTheme(enabled: false),
            ),
            child: const Center(
              child: SizedBox(
                width: 440,
                child: AppDialog(title: 'T', child: Text('x')),
              ),
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getCenter(find.bySemanticsLabel('Fechar')).dx,
      lessThan(tester.getCenter(find.byType(AppDialog)).dx),
    );
  });

  // O título do dialog é alinhado ao INÍCIO (≠ sheets, que centralizam).
  testWidgets('header: o título nasce colado no início, não centralizado', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialog(title: 'Título', child: Text('x')),
        ),
      ),
    );
    final double titleLeft = tester.getTopLeft(find.text('Título')).dx;
    final double dialogLeft = tester.getTopLeft(find.byType(AppDialog)).dx;
    // Só o inset da barra (s16) separa o título da borda do card.
    expect(titleLeft - dialogLeft, AppSpacings.s16);
  });

  // A razão de a barra existir: fora da rolagem, como o rodapé. Dentro do
  // `SingleChildScrollView` ela sairia de vista junto com o conteúdo.
  testWidgets('header: não rola com o conteúdo', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          height: 300,
          child: AppDialog(
            title: 'Fixo',
            child: SizedBox(height: 2000, child: Text('Longo')),
          ),
        ),
      ),
    );
    final double antes = tester.getTopLeft(find.text('Fixo')).dy;
    await tester.drag(find.text('Longo'), const Offset(0, -400));
    await tester.pump();
    expect(tester.getTopLeft(find.text('Fixo')).dy, antes);
  });

  testWidgets('AppDialogContent sem título não desenha o cabeçalho do corpo', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialogContent(message: 'Mensagem', illustration: 'x.svg'),
        ),
      ),
    );
    expect(find.text('Mensagem'), findsOneWidget);
    expect(find.byType(AppText), findsOneWidget);
  });

  // `illustration` é opcional: sem ela o bloco da arte (respiro 64 + arte +
  // respiro 64) sai inteiro e o corpo fecha com um respiro de 32.
  testWidgets('AppDialogContent sem illustration não monta AppIllustration', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialogContent(message: 'Mensagem'),
        ),
      ),
    );
    expect(find.text('Mensagem'), findsOneWidget);
    expect(find.byType(AppIllustration), findsNothing);
  });

  testWidgets('AppDialogContent: a variante sem arte é 64+h+64-32 mais baixa', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialogContent(message: 'Mensagem', illustration: 'x.svg'),
        ),
      ),
    );
    final double comArte = tester.getSize(find.byType(AppDialogContent)).height;
    final double alturaDaArte = tester
        .getSize(find.byType(AppIllustration))
        .height;

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialogContent(message: 'Mensagem'),
        ),
      ),
    );
    final double semArte = tester.getSize(find.byType(AppDialogContent)).height;

    expect(comArte - semArte, 64 + alturaDaArte + 64 - 32);
  });

  testWidgets('AppDialogContent: illustration null explícito = omitir', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialogContent(message: 'Mensagem', illustration: null),
        ),
      ),
    );
    final double explicito = tester
        .getSize(find.byType(AppDialogContent))
        .height;
    expect(find.byType(AppIllustration), findsNothing);

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 440,
          child: AppDialogContent(message: 'Mensagem'),
        ),
      ),
    );
    expect(tester.getSize(find.byType(AppDialogContent)).height, explicito);
  });

  test('AppDialog e AppDialogContent estão no catálogo como migrated', () {
    for (final String id in <String>['app_dialog', 'app_dialog_content']) {
      expect(
        flocksCatalog.any(
          (AppComponentMeta m) =>
              m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id deve estar migrated no catálogo',
      );
    }
  });
}
