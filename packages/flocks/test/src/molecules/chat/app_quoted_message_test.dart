import 'dart:typed_data';

import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Host no molde do chat_test.dart (Directionality + MediaQuery + AppTheme).
Widget _host(Widget child, {bool dark = false}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: dark ? AppThemeData.dark : AppThemeData.light,
      child: Center(child: SizedBox(width: 320, child: child)),
    ),
  ),
);

AppColorTheme get _colors => AppThemeData.light.colorTheme;

// PNG 1×1 transparente — miniatura determinística sem rede.
final Uint8List _png = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
  0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x62, 0x00, 0x01, 0x00, 0x00, //
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, //
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82, //
]);

void main() {
  testWidgets('renderiza autor e prévia', (tester) async {
    await tester.pumpWidget(
      _host(const AppQuotedMessage(author: 'Ana', excerpt: 'Oi!')),
    );
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Oi!'), findsOneWidget);
  });

  testWidgets('author null oculta a linha do autor', (tester) async {
    await tester.pumpWidget(
      _host(const AppQuotedMessage(excerpt: 'Encaminhada')),
    );
    expect(find.text('Encaminhada'), findsOneWidget);
    // Só um AppText na árvore: o da prévia.
    expect(find.byType(AppText), findsOneWidget);
  });

  testWidgets('prévia trunca com elipse em maxLines', (tester) async {
    await tester.pumpWidget(
      _host(AppQuotedMessage(excerpt: 'palavra ' * 60, maxLines: 2)),
    );
    final AppText excerpt = tester.widget<AppText>(find.byType(AppText));
    expect(excerpt.maxLines, 2);
    expect(excerpt.overflow, TextOverflow.ellipsis);
    expect(tester.takeException(), isNull);
  });

  testWidgets('onTap dispara pelo corpo; onRemove pelo "×", sem vazar', (
    tester,
  ) async {
    int taps = 0;
    int removes = 0;
    await tester.pumpWidget(
      _host(
        AppQuotedMessage(
          author: 'Ana',
          excerpt: 'Oi!',
          onTap: () => taps++,
          onRemove: () => removes++,
        ),
      ),
    );

    await tester.tap(find.text('Oi!'));
    await tester.pump();
    expect(taps, 1);
    expect(removes, 0);

    await tester.tap(find.bySemanticsLabel('Remover citação'));
    await tester.pump();
    expect(removes, 1);
    expect(taps, 1, reason: 'alvos disjuntos: o × não dispara o corpo');
  });

  testWidgets('semântica: dois nós nomeados com onTap + onRemove', (
    tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppQuotedMessage(
          author: 'Ana',
          excerpt: 'Oi!',
          onTap: () {},
          onRemove: () {},
        ),
      ),
    );
    expect(find.bySemanticsLabel('Mensagem citada de Ana'), findsOneWidget);
    expect(find.bySemanticsLabel('Remover citação'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('sem autor o rótulo default é "Ver mensagem citada"', (
    tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(AppQuotedMessage(excerpt: 'Oi!', onTap: () {})),
    );
    expect(find.bySemanticsLabel('Ver mensagem citada'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('semanticLabel substitui o rótulo do corpo', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppQuotedMessage(
          author: 'Ana',
          excerpt: 'Oi!',
          onTap: () {},
          semanticLabel: 'Ir para a mensagem da Ana',
        ),
      ),
    );
    expect(find.bySemanticsLabel('Ir para a mensagem da Ana'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('cor: barra e autor usam accentOn; fundo é o tint do resolve', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const AppQuotedMessage(author: 'Ana', excerpt: 'Oi!')),
    );
    final Color accent = AppChatBubbleColor.primary.accentOn(_colors);

    final ColoredBox bar = tester.widget<ColoredBox>(find.byType(ColoredBox));
    expect(bar.color, accent);

    final AppText author = tester.widget<AppText>(
      find.widgetWithText(AppText, 'Ana'),
    );
    expect(author.style?.color, accent);

    final Container box = tester.widget<Container>(
      find.byWidgetPredicate(
        (Widget w) => w is Container && w.decoration is BoxDecoration,
      ),
    );
    final BoxDecoration deco = box.decoration! as BoxDecoration;
    expect(
      deco.color,
      AppChatBubbleColor.primary.resolve(_colors).customOpacity(0.10),
    );
  });

  testWidgets('outlined põe a borda no acento; elevated tem fundo sólido', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const AppQuotedMessage(excerpt: 'Oi!', style: AppStyle.outlined)),
    );
    Container box() => tester.widget<Container>(
      find.byWidgetPredicate(
        (Widget w) => w is Container && w.decoration is BoxDecoration,
      ),
    );
    final BoxDecoration outlined = box().decoration! as BoxDecoration;
    expect(outlined.border, isNotNull);
    expect(
      (outlined.border! as Border).top.color,
      AppChatBubbleColor.primary.accentOn(_colors),
    );

    await tester.pumpWidget(
      _host(const AppQuotedMessage(excerpt: 'Oi!', style: AppStyle.elevated)),
    );
    final BoxDecoration elevated = box().decoration! as BoxDecoration;
    expect(elevated.boxShadow, isNotEmpty);
    // Sólido: alphaBlend do tint sobre surfaceContainer (a sombra não vaza).
    expect(elevated.color!.a, 1.0);
  });

  testWidgets('miniatura renderiza em cover na borda', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        _host(
          AppQuotedMessage(
            author: 'Ana',
            excerpt: 'Foto',
            thumbnail: MemoryImage(_png),
          ),
        ),
      );
      await tester.pump();
    });
    final Image img = tester.widget<Image>(find.byType(Image));
    expect(img.fit, BoxFit.cover);
    expect(tester.getSize(find.byType(Image)).width, AppSizes.s48);
  });

  testWidgets('radius cru vence o modo global', (tester) async {
    await tester.pumpWidget(
      _host(const AppQuotedMessage(excerpt: 'Oi!', radius: 2)),
    );
    final Container box = tester.widget<Container>(
      find.byWidgetPredicate(
        (Widget w) => w is Container && w.decoration is BoxDecoration,
      ),
    );
    expect(
      (box.decoration! as BoxDecoration).borderRadius,
      BorderRadius.circular(2),
    );
  });

  test('AppQuotedMessage está no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_quoted_message' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
