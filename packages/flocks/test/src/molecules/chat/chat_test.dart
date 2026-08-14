import 'dart:convert';

import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(
  Widget child, {
  bool dark = false,
  bool reduceMotion = false,
}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(disableAnimations: reduceMotion),
    child: AppTheme(
      data: dark ? AppThemeData.dark : AppThemeData.light,
      // Overlay: o AppInput (EditableText) exige um Overlay ancestral para a
      // seleção nativa.
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (BuildContext context) => Center(child: child)),
        ],
      ),
    ),
  ),
);

AppColorTheme get _colors => AppThemeData.light.colorTheme;

bool _inCatalog(String id) => flocksCatalog.any(
  (m) => m.id == id && m.status == ComponentStatus.migrated,
);

void main() {
  group('AppChatBubble', () {
    testWidgets('renderiza o child', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(width: 300, child: AppChatBubble(child: Text('oi'))),
        ),
      );
      expect(find.text('oi'), findsOneWidget);
    });

    testWidgets('me → alinha à direita e tinge pelo papel (14%)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 300,
            child: AppChatBubble(author: AppChatAuthor.me, child: Text('eu')),
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Align && w.alignment == Alignment.centerRight,
        ),
        findsOneWidget,
      );
      final Container c = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppChatBubble),
          matching: find.byType(Container),
        ),
      );
      expect(
        (c.decoration! as BoxDecoration).color,
        _colors.primary.customOpacity(0.14),
      );
    });

    testWidgets('other → superfície (surfaceContainer) e alinha à esquerda', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(width: 300, child: AppChatBubble(child: Text('x'))),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Align && w.alignment == Alignment.centerLeft,
        ),
        findsOneWidget,
      );
      final Container c = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppChatBubble),
          matching: find.byType(Container),
        ),
      );
      expect((c.decoration! as BoxDecoration).color, _colors.surfaceContainer);
    });

    testWidgets('tail top (me) → canto superior direito reto', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 300,
            child: AppChatBubble(author: AppChatAuthor.me, child: Text('t')),
          ),
        ),
      );
      final Container c = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppChatBubble),
          matching: find.byType(Container),
        ),
      );
      final BorderRadius br =
          (c.decoration! as BoxDecoration).borderRadius! as BorderRadius;
      expect(br.topRight, Radius.zero);
      expect(br.topLeft.x, greaterThan(0));
    });

    testWidgets('semanticLabel agrupa a mensagem', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 300,
            child: AppChatBubble(semanticLabel: 'Você: oi', child: Text('oi')),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Você: oi'), findsOneWidget);
    });

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_chat_bubble'), isTrue);
    });
  });

  group('AppMessageMeta', () {
    testWidgets('renderiza o horário', (tester) async {
      await tester.pumpWidget(_host(const AppMessageMeta(time: '10:32')));
      expect(find.text('10:32'), findsOneWidget);
    });

    testWidgets('status none → sem ícone', (tester) async {
      await tester.pumpWidget(_host(const AppMessageMeta(time: '10:32')));
      expect(find.byType(AppIcon), findsNothing);
    });

    testWidgets('read → dois tiques tingidos por info', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppMessageMeta(time: '10:32', status: AppMessageStatus.read),
        ),
      );
      final Iterable<AppIcon> icons = tester.widgetList<AppIcon>(
        find.byType(AppIcon),
      );
      expect(icons.length, 2);
      expect(icons.every((i) => i.color == _colors.info), isTrue);
    });

    testWidgets('failed → ícone de erro em danger', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppMessageMeta(time: '10:32', status: AppMessageStatus.failed),
        ),
      );
      final AppIcon icon = tester.widget<AppIcon>(find.byType(AppIcon));
      expect(icon.color, _colors.danger);
    });

    testWidgets('edited → mostra "editada"', (tester) async {
      await tester.pumpWidget(
        _host(const AppMessageMeta(time: '10:32', edited: true)),
      );
      expect(find.text('editada'), findsOneWidget);
    });

    testWidgets('edited + time + status → dois gaps de s4, na ordem', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppMessageMeta(
            time: '10:32',
            edited: true,
            status: AppMessageStatus.sent,
          ),
        ),
      );
      final Iterable<SizedBox> gaps = tester
          .widgetList<SizedBox>(
            find.descendant(
              of: find.byType(AppMessageMeta),
              matching: find.byType(SizedBox),
            ),
          )
          .where((SizedBox b) => b.width == 4);
      expect(gaps.length, 2);
      final double edited = tester.getRect(find.text('editada')).left;
      final double time = tester.getRect(find.text('10:32')).left;
      final double tick = tester.getRect(find.byType(AppIcon)).left;
      expect(edited, lessThan(time));
      expect(time, lessThan(tick));
    });

    testWidgets('time null + status → só o tique, sem gaps', (tester) async {
      await tester.pumpWidget(
        _host(const AppMessageMeta(status: AppMessageStatus.sent)),
      );
      expect(find.byType(AppText), findsNothing);
      expect(find.byType(AppIcon), findsOneWidget);
      final Iterable<SizedBox> gaps = tester
          .widgetList<SizedBox>(
            find.descendant(
              of: find.byType(AppMessageMeta),
              matching: find.byType(SizedBox),
            ),
          )
          .where((SizedBox b) => b.width == 4);
      expect(gaps, isEmpty);
    });

    testWidgets('time null + edited + status → um único gap', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppMessageMeta(edited: true, status: AppMessageStatus.sent),
        ),
      );
      expect(find.text('editada'), findsOneWidget);
      final Iterable<SizedBox> gaps = tester
          .widgetList<SizedBox>(
            find.descendant(
              of: find.byType(AppMessageMeta),
              matching: find.byType(SizedBox),
            ),
          )
          .where((SizedBox b) => b.width == 4);
      expect(gaps.length, 1);
    });

    testWidgets('assert: sem time e sem status reprova', (tester) async {
      expect(() => AppMessageMeta(), throwsAssertionError);
      expect(() => AppMessageMeta(edited: true), throwsAssertionError);
    });

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_message_meta'), isTrue);
    });
  });

  group('AppChatComposer', () {
    testWidgets('renderiza um AppInput (sem TextField do Material)', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          SizedBox(width: 400, child: AppChatComposer(controller: controller)),
        ),
      );
      expect(find.byType(AppInput), findsOneWidget);
    });

    testWidgets('botão de enviar dispara onSend quando há texto', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'oi');
      addTearDown(controller.dispose);
      int sent = 0;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppChatComposer(
              controller: controller,
              onSend: () => sent++,
            ),
          ),
        ),
      );
      await tester.tap(find.bySemanticsLabel('Enviar mensagem'));
      expect(sent, 1);
    });

    testWidgets('shortcut ocupa o lugar da seta enquanto não há o que enviar', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppChatComposer(
              controller: controller,
              shortcut: const AppShortcut.primary('J'),
              onSend: () {},
            ),
          ),
        ),
      );

      // Vazio: o selo do atalho no lugar da seta apagada.
      expect(find.byType(AppShortcutHint), findsOneWidget);
      expect(find.bySemanticsLabel('Enviar mensagem'), findsNothing);

      controller.text = 'oi';
      await tester.pump();

      // Com texto: a seta ativa toma o lugar do selo.
      expect(find.byType(AppShortcutHint), findsNothing);
      expect(find.bySemanticsLabel('Enviar mensagem'), findsOneWidget);
    });

    testWidgets('sufixo fica no centro vertical do campo de uma linha', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'oi');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppChatComposer(controller: controller, onSend: () {}),
          ),
        ),
      );

      final input = tester.getRect(find.byType(AppInput));
      final send = tester.getRect(find.bySemanticsLabel('Enviar mensagem'));

      // Alinhado ao texto, não ao rodapé da caixa.
      expect((send.center.dy - input.center.dy).abs(), lessThan(1.0));
      // E a barra não estica: o composer é do tamanho do seu conteúdo.
      expect(
        tester.getSize(find.byType(AppChatComposer)).height,
        lessThan(200),
      );
    });

    testWidgets('botão de anexo dispara onAttach', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      int attached = 0;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppChatComposer(
              controller: controller,
              onAttach: () => attached++,
            ),
          ),
        ),
      );
      await tester.tap(find.bySemanticsLabel('Anexar arquivo'));
      expect(attached, 1);
    });

    // A superfície do compose = o DecoratedBox ancestral mais próximo do
    // AppInput (os chips de anexo, acima, também são DecoratedBox — por isso
    // ancoramos no input, não no 1º DecoratedBox do composer).
    BoxDecoration composerDecoration(WidgetTester tester) =>
        tester
                .widget<DecoratedBox>(
                  find
                      .ancestor(
                        of: find.byType(AppInput),
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;

    testWidgets('filled (default) → fundo opaco, sem borda nem sombra', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'oi');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          SizedBox(width: 400, child: AppChatComposer(controller: controller)),
        ),
      );
      final BoxDecoration deco = composerDecoration(tester);
      expect(deco.color, _colors.surfaceContainer);
      expect(deco.border, isNull);
      expect(deco.boxShadow, anyOf(isNull, isEmpty));
    });

    testWidgets('elevated → fundo opaco + sombra (não vaza), sem borda', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'oi');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppChatComposer(
              controller: controller,
              style: AppStyle.elevated,
            ),
          ),
        ),
      );
      final BoxDecoration deco = composerDecoration(tester);
      // Fundo opaco → a sombra fica só por fora (não vaza por baixo).
      expect(deco.color, _colors.surfaceContainer);
      expect(deco.boxShadow, isNotNull);
      expect(deco.boxShadow, isNotEmpty);
      expect(deco.border, isNull);
    });

    testWidgets('outlined → fundo opaco + borda outline', (tester) async {
      final controller = TextEditingController(text: 'oi');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppChatComposer(
              controller: controller,
              style: AppStyle.outlined,
            ),
          ),
        ),
      );
      final BoxDecoration deco = composerDecoration(tester);
      expect(deco.color, _colors.surfaceContainer);
      expect(deco.border, isNotNull);
    });

    testWidgets('circular + anexos → cai para redondo (não corta o conteúdo)', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppChatComposer(
              controller: controller,
              radiusMode: AppRadiusMode.circular,
              attachments: const <Widget>[
                AppChatAttachmentChip(label: 'a.pdf'),
              ],
            ),
          ),
        ),
      );
      final BorderRadius br =
          composerDecoration(tester).borderRadius! as BorderRadius;
      // redondo (com teto ~12), não a pílula-sentinela.
      expect(br.topLeft.x, lessThan(100));
    });

    testWidgets('circular sem anexos → pílula (não clampa)', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppChatComposer(
              controller: controller,
              radiusMode: AppRadiusMode.circular,
            ),
          ),
        ),
      );
      final BorderRadius br =
          composerDecoration(tester).borderRadius! as BorderRadius;
      // Sentinela de pílula (o Flutter satura em metade do lado menor).
      expect(br.topLeft.x, greaterThan(100));
    });

    testWidgets('circular + texto multiline → cai para redondo', (
      tester,
    ) async {
      final controller = TextEditingController(
        text:
            'uma frase bem comprida que definitivamente quebra em varias '
            'linhas quando a largura do compose e pequena o bastante',
      );
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 240,
            child: AppChatComposer(
              controller: controller,
              radiusMode: AppRadiusMode.circular,
            ),
          ),
        ),
      );
      final BorderRadius br =
          composerDecoration(tester).borderRadius! as BorderRadius;
      // Multiline → redondo (com teto ~12), não a pílula-sentinela.
      expect(br.topLeft.x, lessThan(100));
    });

    testWidgets(
      'anexos seguem o style do composer (elevated → sombra no chip)',
      (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          _host(
            SizedBox(
              width: 400,
              child: AppChatComposer(
                controller: controller,
                style: AppStyle.elevated,
                attachments: const <Widget>[
                  AppChatAttachmentChip(label: 'a.pdf'),
                ],
              ),
            ),
          ),
        );
        final BoxDecoration chipDeco =
            tester
                    .widget<DecoratedBox>(
                      find
                          .descendant(
                            of: find.byType(AppChatAttachmentChip),
                            matching: find.byType(DecoratedBox),
                          )
                          .first,
                    )
                    .decoration
                as BoxDecoration;
        // O chip não recebeu `style` explícito → herda o `elevated` do composer.
        expect(chipDeco.boxShadow, isNotNull);
        expect(chipDeco.boxShadow, isNotEmpty);
      },
    );

    testWidgets('busy + onStop → mostra o botão de parar', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      int stopped = 0;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppChatComposer(
              controller: controller,
              busy: true,
              onStop: () => stopped++,
            ),
          ),
        ),
      );
      final input = tester.widget<AppInput>(find.byType(AppInput));
      expect(input.background, _colors.transparent);
      expect(input.enabled, isTrue);
      expect(input.readOnly, isTrue);
      expect(find.bySemanticsLabel('Parar resposta'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Parar resposta'));
      expect(stopped, 1);
    });

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_chat_composer'), isTrue);
    });
  });

  group('AppAttachmentKind', () {
    test('resolve a categoria da extensão', () {
      expect(AppAttachmentKind.fromFileName('a.png'), AppAttachmentKind.image);
      expect(AppAttachmentKind.fromFileName('a.mp4'), AppAttachmentKind.video);
      expect(AppAttachmentKind.fromFileName('a.mp3'), AppAttachmentKind.audio);
      expect(AppAttachmentKind.fromFileName('a.pdf'), AppAttachmentKind.pdf);
      expect(
        AppAttachmentKind.fromFileName('a.xlsx'),
        AppAttachmentKind.spreadsheet,
      );
      expect(
        AppAttachmentKind.fromFileName('a.csv'),
        AppAttachmentKind.spreadsheet,
      );
      expect(
        AppAttachmentKind.fromFileName('a.docx'),
        AppAttachmentKind.document,
      );
      expect(
        AppAttachmentKind.fromFileName('a.zip'),
        AppAttachmentKind.archive,
      );
      expect(AppAttachmentKind.fromFileName('a.xyz'), AppAttachmentKind.file);
      expect(AppAttachmentKind.fromFileName(null), AppAttachmentKind.file);
      expect(
        AppAttachmentKind.fromFileName('semponto'),
        AppAttachmentKind.file,
      );
    });

    test('appAttachmentIcon distingue por extensão', () {
      expect(appAttachmentIcon('a.csv'), AppIcons.csv);
      expect(appAttachmentIcon('a.xls'), AppIcons.fileXls);
      expect(appAttachmentIcon('a.pdf'), AppIcons.filePdf);
      expect(appAttachmentIcon('a.png'), AppIcons.imageLandscape);
    });
  });

  group('AppChatAttachmentChip', () {
    testWidgets('arquivo → label + ícone por tipo + remover', (tester) async {
      int removed = 0;
      await tester.pumpWidget(
        _host(
          AppChatAttachmentChip(
            label: 'relatorio.pdf',
            onRemove: () => removed++,
          ),
        ),
      );
      expect(find.text('relatorio.pdf'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is AppIcon && w.icon == AppIcons.filePdf,
        ),
        findsOneWidget,
      );
      await tester.tap(find.bySemanticsLabel('Remover anexo'));
      expect(removed, 1);
    });

    testWidgets('onTap visualiza o anexo', (tester) async {
      int viewed = 0;
      await tester.pumpWidget(
        _host(
          AppChatAttachmentChip(label: 'planilha.csv', onTap: () => viewed++),
        ),
      );
      await tester.tap(find.text('planilha.csv'));
      expect(viewed, 1);
    });

    testWidgets('imagem → renderiza Image', (tester) async {
      // PNG 1×1 transparente válido (evita erro de decode no image service).
      final bytes = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8z8BQDwAE'
        'hQGAhKmMIQAAAABJRU5ErkJggg==',
      );
      await tester.pumpWidget(
        _host(AppChatAttachmentChip(image: MemoryImage(bytes))),
      );
      await tester.pump();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_chat_attachment_chip'), isTrue);
    });
  });

  group('AppChatAttachmentCard', () {
    testWidgets('arquivo → ícone por tipo + nome + remover + onTap', (
      tester,
    ) async {
      int removed = 0;
      int viewed = 0;
      await tester.pumpWidget(
        _host(
          AppChatAttachmentCard(
            label: 'aula.pptx',
            onRemove: () => removed++,
            onTap: () => viewed++,
          ),
        ),
      );
      expect(find.text('aula.pptx'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is AppIcon && w.icon == AppIcons.filePpt,
        ),
        findsOneWidget,
      );
      await tester.tap(find.bySemanticsLabel('Remover anexo'));
      expect(removed, 1);
      await tester.tap(find.text('aula.pptx'));
      expect(viewed, 1);
    });

    testWidgets('imagem → renderiza thumbnail (Image)', (tester) async {
      final bytes = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8z8BQDwAE'
        'hQGAhKmMIQAAAABJRU5ErkJggg==',
      );
      await tester.pumpWidget(
        _host(AppChatAttachmentCard(image: MemoryImage(bytes), label: 'x.png')),
      );
      await tester.pump();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_chat_attachment_card'), isTrue);
    });
  });

  group('AppTypingIndicator', () {
    testWidgets('renderiza 3 pontos e é rotulado', (tester) async {
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(_host(const AppTypingIndicator()));
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration! as BoxDecoration).shape == BoxShape.circle,
        ),
        findsNWidgets(3),
      );
      expect(find.bySemanticsLabel('Digitando'), findsOneWidget);
      await tester.pumpWidget(const SizedBox()); // encerra a animação
    });

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_typing_indicator'), isTrue);
    });
  });

  group('AppAssistantStatus', () {
    testWidgets('sob reduce-motion mostra o label inteiro na hora', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppAssistantStatus(
            label: 'Buscando dados',
            showIndicator: false,
          ),
          reduceMotion: true,
        ),
      );
      expect(find.text('Buscando dados'), findsOneWidget);
    });

    testWidgets('digita o label caractere a caractere (typewriter)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppAssistantStatus(label: 'Oi', showIndicator: false)),
      );
      // Primeiro frame: ainda digitando, texto incompleto.
      expect(find.text('Oi'), findsNothing);
      await tester.pump(const Duration(milliseconds: 45));
      expect(find.text('Oi'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_assistant_status'), isTrue);
    });
  });

  group('AppChatActionBar', () {
    testWidgets(
      'cada ação dispara o callback; ativa tinge pelo acento legível',
      (tester) async {
        int copied = 0;
        await tester.pumpWidget(
          _host(
            AppChatActionBar(
              actions: <AppChatAction>[
                AppChatAction(
                  icon: AppIcons.copy,
                  label: 'Copiar',
                  onPressed: () => copied++,
                ),
                const AppChatAction(
                  icon: AppIcons.thumbsUp,
                  label: 'Gostei',
                  active: true,
                ),
              ],
            ),
          ),
        );
        await tester.tap(find.bySemanticsLabel('Copiar'));
        expect(copied, 1);
        final AppIcon likeIcon = tester.widget<AppIcon>(
          find.byWidgetPredicate(
            (w) => w is AppIcon && w.icon == AppIcons.thumbsUp,
          ),
        );
        expect(
          likeIcon.color,
          readableStopOn(_colors.secondary, _colors.surface),
        );
      },
    );

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_chat_action_bar'), isTrue);
    });
  });

  group('AppSuggestionChip', () {
    testWidgets('renderiza label e dispara onTap', (tester) async {
      int tapped = 0;
      await tester.pumpWidget(
        _host(AppSuggestionChip(label: 'Resumo do dia', onTap: () => tapped++)),
      );
      expect(find.text('Resumo do dia'), findsOneWidget);
      await tester.tap(find.byType(AppSuggestionChip));
      expect(tapped, 1);
    });

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_suggestion_chip'), isTrue);
    });
  });

  group('AppChatDayDivider', () {
    testWidgets('renderiza o label', (tester) async {
      await tester.pumpWidget(_host(const AppChatDayDivider(label: 'Hoje')));
      expect(find.text('Hoje'), findsOneWidget);
    });

    testWidgets('withRules → desenha filetes (AppDivider)', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 400,
            child: AppChatDayDivider(label: 'Ontem', withRules: true),
          ),
        ),
      );
      expect(find.byType(AppDivider), findsNWidgets(2));
    });

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_chat_day_divider'), isTrue);
    });
  });

  group('AppQuestionCard.confirmation', () {
    testWidgets('título + subtítulo + confirmar/cancelar', (tester) async {
      int confirmed = 0;
      int cancelled = 0;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppQuestionCard.confirmation(
              title: 'Confirmação necessária',
              subtitle: 'criar_geocerca',
              onConfirm: () => confirmed++,
              onCancel: () => cancelled++,
            ),
          ),
        ),
      );
      expect(find.text('Confirmação necessária'), findsOneWidget);
      expect(find.text('criar_geocerca'), findsOneWidget);
      await tester.tap(find.text('Cancelar'));
      await tester.tap(find.text('Confirmar'));
      expect(cancelled, 1);
      expect(confirmed, 1);
    });

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_question_card'), isTrue);
    });
  });

  group('AppQuestionCard.singleChoice', () {
    testWidgets('escolher opção + enviar dispara onSingleSelected', (
      tester,
    ) async {
      String? answer;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppQuestionCard.singleChoice(
              title: 'Qual relatório?',
              options: const <String>['Resumo', 'Parados', 'Alertas'],
              allowCustom: false,
              onSingleSelected: (v) => answer = v,
            ),
          ),
        ),
      );
      // Sem escolha, enviar não dispara.
      await tester.tap(find.text('Enviar'));
      expect(answer, isNull);
      // Escolhe e envia.
      await tester.tap(find.text('Parados'));
      await tester.pump();
      await tester.tap(find.text('Enviar'));
      expect(answer, 'Parados');
    });

    testWidgets('tem Cancelar (text button) que dispara onCancel', (
      tester,
    ) async {
      int cancelled = 0;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppQuestionCard.singleChoice(
              title: 'Qual?',
              options: const <String>['A', 'B'],
              allowCustom: false,
              onSingleSelected: (_) {},
              onCancel: () => cancelled++,
            ),
          ),
        ),
      );
      expect(find.text('Cancelar'), findsOneWidget);
      await tester.tap(find.text('Cancelar'));
      expect(cancelled, 1);
    });

    testWidgets('opção livre → AppInput + texto enviado', (tester) async {
      String? answer;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppQuestionCard.singleChoice(
              title: 'Qual?',
              options: const <String>['A', 'B'],
              customLabel: 'Outra…',
              onSingleSelected: (v) => answer = v,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Outra…'));
      await tester.pump();
      expect(find.byType(AppInput), findsOneWidget);
      await tester.enterText(find.byType(AppInput), 'resposta livre');
      await tester.pump();
      await tester.tap(find.text('Enviar'));
      expect(answer, 'resposta livre');
    });
  });

  group('AppQuestionCard.multipleChoice', () {
    testWidgets('marcar várias + enviar dispara onMultipleSubmit', (
      tester,
    ) async {
      List<String>? answers;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppQuestionCard.multipleChoice(
              title: 'Colunas?',
              options: const <String>['Placa', 'Motorista', 'KM'],
              allowCustom: false,
              onMultipleSubmit: (v) => answers = v,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AppCheckbox).at(0)); // Placa
      await tester.tap(find.byType(AppCheckbox).at(2)); // KM
      await tester.pump();
      await tester.tap(find.text('Enviar'));
      expect(answers, <String>['Placa', 'KM']);
    });
  });

  group('AppChatMessageList', () {
    testWidgets('renderiza os itens', (tester) async {
      await tester.pumpWidget(
        _host(
          SizedBox(
            height: 400,
            width: 300,
            child: AppChatMessageList(
              itemCount: 3,
              itemBuilder: (context, i) => Text('msg $i'),
            ),
          ),
        ),
      );
      expect(find.text('msg 0'), findsOneWidget);
      expect(find.text('msg 2'), findsOneWidget);
    });

    testWidgets('está no catálogo', (tester) async {
      expect(_inCatalog('app_chat_message_list'), isTrue);
    });
  });
}
