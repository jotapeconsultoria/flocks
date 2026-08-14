import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {bool dark = false}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: dark ? AppThemeData.dark : AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

// Espelha a fórmula do build: caixa do label (TextPainter com o mesmo estilo
// e scaler) + padding do passo — a PROVA de que a pílula sem ícone é a de
// sempre, e a régua do que o ícone soma.
Size _expectedPillSize(
  AppBadgeSize size, {
  required String text,
  double scale = 1.0,
  bool withIcon = false,
}) {
  final TextStyle style = size.labelStyle(AppThemeData.light.textTheme);
  final TextPainter painter = TextPainter(
    text: TextSpan(text: text.toUpperCase(), style: style),
    textDirection: TextDirection.ltr,
    textScaler: TextScaler.linear(scale),
    maxLines: 1,
  )..layout();
  final double iconSize = painter.height;
  final Size s = Size(
    painter.width + (withIcon ? 4 + iconSize : 0) + size.padding.horizontal,
    painter.height + size.padding.vertical,
  );
  painter.dispose();
  return s;
}

void main() {
  group('geometria por passo (a prova de identidade)', () {
    for (final AppBadgeSize step in AppBadgeSize.values) {
      testWidgets('sem ícone, ${step.name} mede caixa do label + padding', (
        tester,
      ) async {
        await tester.pumpWidget(_host(AppBadge('Pendente', size: step)));
        expect(
          tester.getSize(find.byType(AppBadge)),
          _expectedPillSize(step, text: 'Pendente'),
        );
      });
    }
  });

  group('icon', () {
    testWidgets('default → nenhum AppIcon na árvore', (tester) async {
      await tester.pumpWidget(_host(const AppBadge('Pendente')));
      expect(find.byType(AppIcon), findsNothing);
    });

    testWidgets('renderiza à esquerda do label, na cor do papel', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppBadge(
            'Janela',
            icon: AppIconToken.clock,
            color: AppBadgeColor.danger,
          ),
        ),
      );
      final AppIcon icon = tester.widget<AppIcon>(find.byType(AppIcon));
      expect(
        icon.color,
        AppBadgeColor.danger.resolve(AppThemeData.light.colorTheme),
      );
      expect(
        tester.getTopLeft(find.byType(AppIcon)).dx,
        lessThan(tester.getTopLeft(find.byType(AppText)).dx),
      );
    });

    testWidgets('casa com a caixa de linha e NÃO muda a altura da pílula', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const AppBadge('Janela')));
      final double sem = tester.getSize(find.byType(AppBadge)).height;

      await tester.pumpWidget(
        _host(const AppBadge('Janela', icon: AppIconToken.clock)),
      );
      final AppIcon icon = tester.widget<AppIcon>(find.byType(AppIcon));
      expect(icon.customSize, 16); // labelSmall: caixa de linha 16 a escala 1
      expect(tester.getSize(find.byType(AppBadge)).height, sem);
      expect(
        tester.getSize(find.byType(AppBadge)),
        _expectedPillSize(AppBadgeSize.m, text: 'Janela', withIcon: true),
      );

      await tester.pumpWidget(
        _host(
          const AppBadge(
            'Janela',
            icon: AppIconToken.clock,
            size: AppBadgeSize.xl,
          ),
        ),
      );
      expect(
        tester.widget<AppIcon>(find.byType(AppIcon)).customSize,
        20, // labelLarge: caixa de linha 20
      );
    });

    testWidgets('escala com o text scale', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: AppTheme(
              data: AppThemeData.light,
              child: const Center(
                child: AppBadge('Janela', icon: AppIconToken.clock),
              ),
            ),
          ),
        ),
      );
      expect(tester.widget<AppIcon>(find.byType(AppIcon)).customSize, 32);
    });

    testWidgets('o raio redondo não se mexe com o ícone', (tester) async {
      await tester.pumpWidget(_host(const AppBadge('Janela')));
      Container pill() => tester.widget<Container>(
        find.descendant(
          of: find.byType(AppBadge),
          matching: find.byType(Container),
        ),
      );
      final BorderRadius sem =
          (pill().decoration! as BoxDecoration).borderRadius! as BorderRadius;

      await tester.pumpWidget(
        _host(const AppBadge('Janela', icon: AppIconToken.clock)),
      );
      final BorderRadius com =
          (pill().decoration! as BoxDecoration).borderRadius! as BorderRadius;
      expect(com, sem);
    });

    testWidgets('a semântica continua um nó rotulado único', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(const AppBadge('Janela', icon: AppIconToken.clock)),
      );
      // O rótulo semântico é o label ORIGINAL (não o caixa-alta pintado).
      expect(find.bySemanticsLabel('Janela'), findsOneWidget);
      handle.dispose();
    });
  });

  testWidgets('renderiza o label', (tester) async {
    await tester.pumpWidget(_host(const AppBadge('Pendente')));
    // O badge PINTA em caixa-alta: é rótulo de estado, e a caixa é o que o
    // separa do texto corrido ao lado.
    expect(find.text('PENDENTE'), findsOneWidget);
    expect(find.text('Pendente'), findsNothing);
  });

  testWidgets('preserveCase mantém a caixa de quem a carrega como informação', (
    tester,
  ) async {
    await tester.pumpWidget(_host(const AppBadge('pt-BR', preserveCase: true)));
    expect(find.text('pt-BR'), findsOneWidget);
  });

  testWidgets('cor default é neutral (neutralPrimary do tema)', (tester) async {
    await tester.pumpWidget(_host(const AppBadge('X')));
    final AppText text = tester.widget<AppText>(find.byType(AppText));
    expect(
      text.style?.color,
      AppBadgeColor.neutral.resolve(AppThemeData.light.colorTheme),
    );
  });

  testWidgets('papel semântico define a cor do texto', (tester) async {
    await tester.pumpWidget(
      _host(const AppBadge('Erro', color: AppBadgeColor.danger)),
    );
    final AppText text = tester.widget<AppText>(find.byType(AppText));
    expect(
      text.style?.color,
      AppBadgeColor.danger.resolve(AppThemeData.light.colorTheme),
    );
  });

  testWidgets('fundo (filled) é a cor do papel a 10%', (tester) async {
    await tester.pumpWidget(
      _host(const AppBadge('Ok', color: AppBadgeColor.success)),
    );
    final Container c = tester.widget<Container>(find.byType(Container));
    final BoxDecoration decoration = c.decoration! as BoxDecoration;
    final Color expected = AppBadgeColor.success
        .resolve(AppThemeData.light.colorTheme)
        .withValues(alpha: 0.1);
    expect(decoration.color, expected);
  });

  testWidgets('expõe label na semântica (AppSemantics.label)', (tester) async {
    await tester.pumpWidget(_host(const AppBadge('Status')));
    expect(tester.getSemantics(find.byType(AppBadge)).label, 'Status');
  });

  testWidgets('está no catálogo como migrado', (tester) async {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_badge' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });

  group('AppBadgeSize', () {
    test('padding por passo', () {
      expect(
        AppBadgeSize.s.padding,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      );
      expect(
        AppBadgeSize.m.padding,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );
      expect(
        AppBadgeSize.l.padding,
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );
      expect(
        AppBadgeSize.xl.padding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
    });

    test('papel de texto por passo', () {
      final AppTextTheme t = AppThemeData.light.textTheme;
      expect(AppBadgeSize.s.labelStyle(t), t.labelSmall);
      expect(AppBadgeSize.m.labelStyle(t), t.labelSmall);
      expect(AppBadgeSize.l.labelStyle(t), t.labelMedium);
      expect(AppBadgeSize.xl.labelStyle(t), t.labelLarge);
    });
  });

  group('AppBadge · sizing', () {
    testWidgets('default m == labelSmall + padding h8/v4', (tester) async {
      await tester.pumpWidget(_host(const AppBadge('X')));
      final Container c = tester.widget<Container>(find.byType(Container));
      expect(c.padding, AppBadgeSize.m.padding);
      final AppText text = tester.widget<AppText>(find.byType(AppText));
      expect(
        text.style?.fontSize,
        AppThemeData.light.textTheme.labelSmall.fontSize,
      );
    });

    testWidgets('size l → labelMedium + padding h12/v8', (tester) async {
      await tester.pumpWidget(_host(const AppBadge('X', size: AppBadgeSize.l)));
      final Container c = tester.widget<Container>(find.byType(Container));
      expect(c.padding, AppBadgeSize.l.padding);
      final AppText text = tester.widget<AppText>(find.byType(AppText));
      expect(
        text.style?.fontSize,
        AppThemeData.light.textTheme.labelMedium.fontSize,
      );
    });

    testWidgets('raio é proporcional à altura (redondo: s < xl)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBadge('T', size: AppBadgeSize.s),
              AppBadge('T', size: AppBadgeSize.xl),
            ],
          ),
        ),
      );
      double radiusOf(int i) {
        final Container c = tester.widget<Container>(
          find.descendant(
            of: find.byType(AppBadge).at(i),
            matching: find.byType(Container),
          ),
        );
        return ((c.decoration! as BoxDecoration).borderRadius! as BorderRadius)
            .topLeft
            .x;
      }

      // Modo Redondo = fração da altura → o badge maior tem raio maior.
      expect(radiusOf(0), lessThan(radiusOf(1)));
    });
  });

  group('AppBadge · styles', () {
    testWidgets('outlined: borda não insere conteúdo nem muda o tamanho', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBadge('Tag', style: AppStyle.filled),
              AppBadge('Tag', style: AppStyle.outlined),
            ],
          ),
        ),
      );
      // A borda não aumenta o tamanho: filled e outlined têm a mesma largura.
      final double filledW = tester.getSize(find.byType(AppBadge).at(0)).width;
      final double outlinedW = tester
          .getSize(find.byType(AppBadge).at(1))
          .width;
      expect(outlinedW, filledW);
      // O Container (fill) NÃO tem borda; ela é desenhada por cima
      // (DecoratedBox foreground).
      final Container container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppBadge).at(1),
          matching: find.byType(Container),
        ),
      );
      expect((container.decoration! as BoxDecoration).border, isNull);
      final Iterable<DecoratedBox> foregroundBorders = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(AppBadge).at(1),
              matching: find.byType(DecoratedBox),
            ),
          )
          .where(
            (d) =>
                d.position == DecorationPosition.foreground &&
                (d.decoration as BoxDecoration).border != null,
          );
      expect(foregroundBorders, isNotEmpty);
      // A cor da borda é a mesma cor do papel (== cor do texto).
      final Color roleColor = AppBadgeColor.neutral.resolve(
        AppThemeData.light.colorTheme,
      );
      final BoxBorder border =
          (foregroundBorders.first.decoration as BoxDecoration).border!;
      expect((border as Border).top.color, roleColor);
    });

    testWidgets('elevated: fundo opaco + sombra', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppBadge(
            'Tag',
            color: AppBadgeColor.info,
            style: AppStyle.elevated,
          ),
        ),
      );
      final Container c = tester.widget<Container>(find.byType(Container));
      final BoxDecoration deco = c.decoration! as BoxDecoration;
      expect(deco.color!.a, 1.0);
      expect(deco.boxShadow, isNotNull);
    });
  });

  group('AppBadge · interatividade', () {
    testWidgets('somente-leitura (onTap null) → sem FlocksInteraction', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const AppBadge('Status')));
      expect(find.byType(FlocksInteraction), findsNothing);
    });

    testWidgets('onTap → FlocksInteraction + role de botão', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_host(AppBadge('Filtro', onTap: () {})));
      expect(find.byType(FlocksInteraction), findsOneWidget);
      final SemanticsNode node = tester.getSemantics(find.byType(AppBadge));
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.label, 'Filtro');
      handle.dispose();
    });

    testWidgets('onTap dispara o callback', (tester) async {
      int taps = 0;
      await tester.pumpWidget(_host(AppBadge('Filtro', onTap: () => taps++)));
      await tester.tap(find.byType(AppBadge));
      expect(taps, 1);
    });

    testWidgets('clicável desabilita a seleção do label (conteúdo passivo)', (
      tester,
    ) async {
      await tester.pumpWidget(_host(AppBadge('Filtro', onTap: () {})));
      expect(
        find.descendant(
          of: find.byType(AppBadge),
          matching: find.byType(SelectionContainer),
        ),
        findsOneWidget,
      );
    });

    testWidgets('somente-leitura mantém o label selecionável', (tester) async {
      await tester.pumpWidget(_host(const AppBadge('Status')));
      expect(
        find.descendant(
          of: find.byType(AppBadge),
          matching: find.byType(SelectionContainer),
        ),
        findsNothing,
      );
    });
  });

  group('AppBadge · estados (statesController)', () {
    // O realce é uma DecoratedBox com a cor translúcida do overlay (onSurface).
    Finder highlight(double alpha) {
      final Color c = AppThemeData.light.colorTheme.onSurface.withValues(
        alpha: alpha,
      );
      return find.byWidgetPredicate(
        (w) => w is DecoratedBox && (w.decoration as BoxDecoration).color == c,
      );
    }

    testWidgets('neutral clicável → sem realce e sem sombra', (tester) async {
      final controller = FlocksStatesController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          AppBadge(
            'Filtro',
            size: AppBadgeSize.l,
            onTap: () {},
            statesController: controller,
          ),
        ),
      );
      expect(highlight(0.08), findsNothing);
      expect(highlight(0.12), findsNothing);
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect((container.decoration! as BoxDecoration).boxShadow, isNull);
    });

    testWidgets('pressed → realce cobre a pílula inteira (não só o texto)', (
      tester,
    ) async {
      final controller = FlocksStatesController(<WidgetState>{
        WidgetState.pressed,
      });
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          AppBadge(
            'Filtro',
            size: AppBadgeSize.l,
            onTap: () {},
            statesController: controller,
          ),
        ),
      );
      final Finder overlay = highlight(0.12);
      expect(overlay, findsOneWidget);
      // Cobre a PÍLULA inteira (padding incluído), não apenas o texto.
      expect(tester.getSize(overlay), tester.getSize(find.byType(AppBadge)));
    });

    testWidgets('dragged → sombra de lift + escala 1.08', (tester) async {
      final controller = FlocksStatesController(<WidgetState>{
        WidgetState.dragged,
      });
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          AppBadge(
            'Filtro',
            size: AppBadgeSize.l,
            onTap: () {},
            statesController: controller,
          ),
        ),
      );
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect((container.decoration! as BoxDecoration).boxShadow, isNotNull);
      final scaled = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(scaled.scale, 1.08);
    });
  });
}
