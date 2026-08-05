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

Iterable<BoxDecoration> _alertDecorations(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(AppAlert),
        matching: find.byType(DecoratedBox),
      ),
    )
    .map((DecoratedBox d) => d.decoration)
    .whereType<BoxDecoration>();

bool _alertHasBorder(WidgetTester tester) =>
    _alertDecorations(tester).any((BoxDecoration d) => d.border != null);

bool _alertHasShadow(WidgetTester tester) => _alertDecorations(
  tester,
).any((BoxDecoration d) => d.boxShadow != null && d.boxShadow!.isNotEmpty);

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

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_alert' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
