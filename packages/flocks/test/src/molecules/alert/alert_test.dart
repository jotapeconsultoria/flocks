import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

Widget _overlayHost(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (BuildContext context) => Center(child: child)),
        ],
      ),
    ),
  ),
);

// A caixa PRÓPRIA do card é o primeiro DecoratedBox da subárvore (varredura em
// pré-ordem). Um `.any(...)` sobre todos os descendentes leria também o
// AnimatedContainer do AppInteraction do "×" (que tem SEMPRE Border.all — o
// anel de foco transparente) e atribuiria ao alerta uma borda que não é dele.
BoxDecoration _alertDecoration(WidgetTester tester) =>
    tester
            .widgetList<DecoratedBox>(
              find.descendant(
                of: find.byType(AppAlert),
                matching: find.byType(DecoratedBox),
              ),
            )
            .first
            .decoration
        as BoxDecoration;

bool _alertHasBorder(WidgetTester tester) =>
    _alertDecoration(tester).border != null;

bool _alertHasShadow(WidgetTester tester) {
  final BoxDecoration d = _alertDecoration(tester);
  return d.boxShadow != null && d.boxShadow!.isNotEmpty;
}

void main() {
  testWidgets('AppAlert renderiza título/descrição e é liveRegion', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 320,
          child: AppAlert(title: 'Título', description: 'Descrição'),
        ),
      ),
    );
    expect(find.text('Título'), findsOneWidget);
    expect(find.text('Descrição'), findsOneWidget);
    final s = tester.getSemantics(find.byType(AppAlert));
    expect(s.flagsCollection.isLiveRegion, isTrue);
  });

  // O eixo AppStyle global: outlined desenha a borda semântica, filled deixa só
  // o tom tingido (sem borda), elevated troca a borda por sombra.
  testWidgets('style: outlined desenha borda; filled não', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 320,
          child: AppAlert(
            title: 'T',
            description: 'D',
            style: AppStyle.outlined,
          ),
        ),
      ),
    );
    expect(_alertHasBorder(tester), isTrue);
    expect(_alertHasShadow(tester), isFalse);

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 320,
          child: AppAlert(title: 'T', description: 'D', style: AppStyle.filled),
        ),
      ),
    );
    expect(_alertHasBorder(tester), isFalse);
    expect(_alertHasShadow(tester), isFalse);
  });

  testWidgets('style: elevated aplica sombra, sem borda', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 320,
          child: AppAlert(
            title: 'T',
            description: 'D',
            style: AppStyle.elevated,
          ),
        ),
      ),
    );
    expect(_alertHasShadow(tester), isTrue);
    expect(_alertHasBorder(tester), isFalse);
  });

  testWidgets('showAppOverlay exibe e some após duration', (tester) async {
    await tester.pumpWidget(
      _overlayHost(
        Builder(
          builder: (BuildContext context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showAppOverlay(
              context: context,
              position: AppOverlayPosition.topRight,
              duration: const Duration(milliseconds: 100),
              child: const AppAlert(title: 'Oi', description: 'msg'),
            ),
            child: const SizedBox(width: 200, height: 200),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    expect(find.byType(AppAlert), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();
    expect(find.byType(AppAlert), findsNothing);
  });

  testWidgets('showAppOverlay: dismiss() retornado remove', (tester) async {
    VoidCallback? dismiss;
    await tester.pumpWidget(
      _overlayHost(
        Builder(
          builder: (BuildContext context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => dismiss = showAppOverlay(
              context: context,
              duration: null, // persistente até dispensar
              child: const AppAlert(title: 'P', description: 'persistente'),
            ),
            child: const SizedBox(width: 200, height: 200),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    expect(find.byType(AppAlert), findsOneWidget);
    dismiss!.call();
    await tester.pumpAndSettle();
    expect(find.byType(AppAlert), findsNothing);
  });

  testWidgets('showAppOverlay reprovê DefaultTextStyle (sem fallback amarelo)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _overlayHost(
        Builder(
          builder: (BuildContext context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showAppOverlay(
              context: context,
              duration: null,
              child: const AppAlert(title: 'T', description: 'D'),
            ),
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    // Sem o DefaultTextStyle reprovido, o Overlay cairia no fallback do Flutter
    // (texto vermelho + sublinhado amarelo duplo "faltou Material").
    final TextStyle style = DefaultTextStyle.of(
      tester.element(find.text('T')),
    ).style;
    expect(style.decoration, isNot(TextDecoration.underline));
  });

  testWidgets('showAppOverlay reflete o text scale', (tester) async {
    await tester.pumpWidget(
      _overlayHost(
        MediaQuery(
          // Text scale só no contexto do trigger; a entry do overlay (irmã) só
          // o reflete porque o showAppOverlay o reprovê (via AppOverlayScope).
          data: const MediaQueryData(
            disableAnimations: true,
            textScaler: TextScaler.linear(2.0),
          ),
          child: Builder(
            builder: (BuildContext context) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showAppOverlay(
                context: context,
                duration: null,
                child: const AppAlert(title: 'T', description: 'D'),
              ),
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    expect(
      MediaQuery.textScalerOf(tester.element(find.text('T'))),
      const TextScaler.linear(2.0),
    );
  });

  // Contraste dos 4 papéis nas 2 marcas × 2 brilhos (sem renderizar).
  group('contraste (papéis × jotape/zxtrack × claro/escuro)', () {
    final List<AppBrandConfig> brands = <AppBrandConfig>[
      jotapeBrand,
      zxtrackBrand,
    ];
    for (final AppBrandConfig brand in brands) {
      for (final bool dark in <bool>[false, true]) {
        final String bl = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';
        final AppColorTheme c = dark
            ? brand.toDarkColorTheme()
            : brand.toLightColorTheme();
        for (final AppAlertColor role in AppAlertColor.values) {
          final ColorSwatch<int> swatch = role.resolve(c);
          final Color fill = Color.alphaBlend(
            swatch.withValues(alpha: 0.08),
            c.surfaceContainer,
          );
          test('${role.name} · $bl', () {
            expect(
              meetsWcag(c.onSurface, fill),
              isTrue,
              reason: 'título < 4.5 em $bl',
            );
            expect(
              meetsWcag(c.neutralPrimary.s700, fill),
              isTrue,
              reason: 'descrição < 4.5 em $bl',
            );
            expect(
              contrastRatio(readableStopOn(swatch, c.surface), c.surface) >=
                  kUi,
              isTrue,
              reason: 'borda < 3:1 em $bl',
            );
            expect(
              contrastRatio(readableStopOn(swatch, fill), fill) >= kUi,
              isTrue,
              reason: 'ícone < 3:1 em $bl',
            );
          });
        }
      }
    }
  });

  group('slots (action/onDismiss/child) e liveRegion', () {
    testWidgets('sem os params novos a árvore é a de sempre', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 320,
            child: AppAlert(title: 'T', description: 'D'),
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AppAlert),
          matching: find.byType(AppInteraction),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(AppAlert),
          matching: find.byType(Align),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(AppAlert),
          matching: find.byType(AppText),
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('action no footer fica numa linha própria, ao fim', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 320,
            child: AppAlert(
              title: 'T',
              description: 'D',
              action: SizedBox(
                key: ValueKey<String>('acao'),
                width: 80,
                height: 24,
              ),
            ),
          ),
        ),
      );
      final Rect action = tester.getRect(
        find.byKey(const ValueKey<String>('acao')),
      );
      final Rect desc = tester.getRect(find.text('D'));
      final Rect card = tester.getRect(find.byType(AppAlert));
      expect(action.top, greaterThanOrEqualTo(desc.bottom));
      expect((card.right - 16) - action.right, lessThanOrEqualTo(1));
    });

    testWidgets('action em trailing fica na linha do título', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 360,
            child: AppAlert(
              title: 'T',
              description: 'D',
              actionPlacement: AppAlertActionPlacement.trailing,
              action: SizedBox(
                key: ValueKey<String>('acao'),
                width: 60,
                height: 20,
              ),
            ),
          ),
        ),
      );
      final Rect action = tester.getRect(
        find.byKey(const ValueKey<String>('acao')),
      );
      final Rect title = tester.getRect(find.text('T'));
      expect(action.center.dy, greaterThanOrEqualTo(title.top));
      expect(action.center.dy, lessThanOrEqualTo(title.bottom));
      final AppText titleText = tester.widget<AppText>(
        find.widgetWithText(AppText, 'T'),
      );
      expect(titleText.maxLines, 1);
      expect(titleText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('actionPlacement sem action é inerte', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 320,
            child: AppAlert(
              title: 'T',
              description: 'D',
              actionPlacement: AppAlertActionPlacement.trailing,
            ),
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AppAlert),
          matching: find.byType(Align),
        ),
        findsNothing,
      );
    });

    testWidgets('onDismiss desenha o × nomeado e dispara uma vez', (
      tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 320,
            child: AppAlert(
              title: 'T',
              description: 'D',
              onDismiss: () => taps++,
            ),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Dispensar'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Dispensar'));
      expect(taps, 1);
    });

    testWidgets('dismissSemanticLabel sobrescreve o rótulo', (tester) async {
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 320,
            child: AppAlert(
              title: 'T',
              description: 'D',
              onDismiss: () {},
              dismissSemanticLabel: 'Fechar aviso',
            ),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Fechar aviso'), findsOneWidget);
      expect(find.bySemanticsLabel('Dispensar'), findsNothing);
    });

    testWidgets('sem onDismiss não há ícone de close', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 320,
            child: AppAlert(title: 'T', description: 'D'),
          ),
        ),
      );
      final Iterable<AppIcon> icons = tester.widgetList<AppIcon>(
        find.descendant(
          of: find.byType(AppAlert),
          matching: find.byType(AppIcon),
        ),
      );
      expect(
        icons.map((AppIcon i) => i.icon),
        isNot(contains(AppIconToken.close)),
      );
    });

    testWidgets('com onDismiss e action em trailing, a ordem é '
        'título → ícone → ação → ×', (tester) async {
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 400,
            child: AppAlert(
              title: 'T',
              description: 'D',
              actionPlacement: AppAlertActionPlacement.trailing,
              action: const SizedBox(
                key: ValueKey<String>('acao'),
                width: 40,
                height: 20,
              ),
              onDismiss: () {},
            ),
          ),
        ),
      );
      final double title = tester.getRect(find.text('T')).left;
      final Iterable<AppIcon> icons = tester.widgetList<AppIcon>(
        find.descendant(
          of: find.byType(AppAlert),
          matching: find.byType(AppIcon),
        ),
      );
      final double semanticIcon = tester
          .getRect(
            find.byWidget(
              icons.firstWhere((AppIcon i) => i.icon != AppIconToken.close),
            ),
          )
          .left;
      final double action = tester
          .getRect(find.byKey(const ValueKey<String>('acao')))
          .left;
      final double close = tester
          .getRect(
            find.byWidget(
              icons.firstWhere((AppIcon i) => i.icon == AppIconToken.close),
            ),
          )
          .left;
      expect(title, lessThan(semanticIcon));
      expect(semanticIcon, lessThan(action));
      expect(action, lessThan(close));
    });

    testWidgets('child fica entre a descrição e o rodapé, e é clicável', (
      tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 320,
            child: AppAlert(
              title: 'T',
              description: 'D',
              action: const SizedBox(
                key: ValueKey<String>('acao'),
                width: 80,
                height: 24,
              ),
              child: GestureDetector(
                key: const ValueKey<String>('filho'),
                behavior: HitTestBehavior.opaque,
                onTap: () => taps++,
                child: const SizedBox(width: 100, height: 30),
              ),
            ),
          ),
        ),
      );
      final Rect child = tester.getRect(
        find.byKey(const ValueKey<String>('filho')),
      );
      final Rect desc = tester.getRect(find.text('D'));
      final Rect action = tester.getRect(
        find.byKey(const ValueKey<String>('acao')),
      );
      expect(child.top, greaterThanOrEqualTo(desc.bottom));
      expect(child.bottom, lessThanOrEqualTo(action.top));
      await tester.tap(find.byKey(const ValueKey<String>('filho')));
      expect(taps, 1);
    });

    testWidgets(
      'liveRegion: true por padrão; false desliga sem calar o texto',
      (tester) async {
        await tester.pumpWidget(
          _host(
            const SizedBox(
              width: 320,
              child: AppAlert(title: 'T', description: 'D', liveRegion: false),
            ),
          ),
        );
        final s = tester.getSemantics(find.byType(AppAlert));
        expect(s.flagsCollection.isLiveRegion, isFalse);
        expect(find.text('T'), findsOneWidget);
        final handle = tester.ensureSemantics();
        expect(find.bySemanticsLabel('T'), findsOneWidget);
        expect(find.bySemanticsLabel('D'), findsOneWidget);
        handle.dispose();
      },
    );

    testWidgets(
      'o eixo AppStyle segue medido na caixa PRÓPRIA com o × presente',
      (tester) async {
        await tester.pumpWidget(
          _host(
            SizedBox(
              width: 320,
              child: AppAlert(
                title: 'T',
                description: 'D',
                style: AppStyle.filled,
                onDismiss: () {},
              ),
            ),
          ),
        );
        expect(_alertHasBorder(tester), isFalse);
        expect(_alertHasShadow(tester), isFalse);

        await tester.pumpWidget(
          _host(
            SizedBox(
              width: 320,
              child: AppAlert(
                title: 'T',
                description: 'D',
                style: AppStyle.outlined,
                onDismiss: () {},
              ),
            ),
          ),
        );
        expect(_alertHasBorder(tester), isTrue);

        await tester.pumpWidget(
          _host(
            SizedBox(
              width: 320,
              child: AppAlert(
                title: 'T',
                description: 'D',
                style: AppStyle.elevated,
                onDismiss: () {},
              ),
            ),
          ),
        );
        expect(_alertHasShadow(tester), isTrue);
        expect(_alertHasBorder(tester), isFalse);
      },
    );
  });

  group('maxLines', () {
    const String longo =
        'Uma política de uso longa o bastante para não caber em três linhas '
        'de card estreito, repetida para garantir: uma política de uso longa '
        'o bastante para não caber em três linhas de card estreito, e mais '
        'uma volta inteira do mesmo texto para transbordar qualquer teto.';

    testWidgets('default trunca em 3 linhas com ellipsis', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 280,
            child: AppAlert(title: 'T', description: longo),
          ),
        ),
      );
      final AppText desc = tester.widget<AppText>(
        find.widgetWithText(AppText, longo),
      );
      expect(desc.maxLines, 3);
      expect(desc.overflow, TextOverflow.ellipsis);
    });

    testWidgets('null remove o teto e o card cresce', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 280,
            child: AppAlert(title: 'T', description: longo),
          ),
        ),
      );
      final double truncado = tester.getSize(find.byType(AppAlert)).height;

      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 280,
            child: AppAlert(title: 'T', description: longo, maxLines: null),
          ),
        ),
      );
      final AppText desc = tester.widget<AppText>(
        find.widgetWithText(AppText, longo),
      );
      expect(desc.maxLines, isNull);
      expect(
        tester.getSize(find.byType(AppAlert)).height,
        greaterThan(truncado),
      );
    });
  });

  // O × precisa ser legível sobre o fill tingido dos 5 papéis.
  group('contraste do × (marca × brilho)', () {
    for (final AppBrandConfig brand in <AppBrandConfig>[
      jotapeBrand,
      zxtrackBrand,
    ]) {
      for (final bool dark in <bool>[false, true]) {
        final String bl = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';
        final AppColorTheme c = dark
            ? brand.toDarkColorTheme()
            : brand.toLightColorTheme();
        for (final AppAlertColor role in AppAlertColor.values) {
          final ColorSwatch<int> swatch = role.resolve(c);
          final Color fill = Color.alphaBlend(
            swatch.withValues(alpha: 0.08),
            c.surfaceContainer,
          );
          test('× sobre ${role.name} · $bl', () {
            final Color close = Color.alphaBlend(
              c.onSurface.withValues(alpha: 0.72),
              fill,
            );
            expect(
              contrastRatio(close, fill) >= kUi,
              isTrue,
              reason: 'o × compôs < 3:1 sobre o fill em $bl',
            );
          });
        }
      }
    }
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_alert' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
