import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flocks/src/molecules/card/app_overlay_panel.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Host com o Overlay do root ACIMA do tema/text-scale (cenário real do app),
/// para exercitar o re-provimento do `AppOverlayScope` dentro da entry.
Widget _host(Widget child, {double textScale = 1.0}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(
      disableAnimations: true,
      textScaler: TextScaler.linear(textScale),
    ),
    // TapRegionSurface: no app real vem do WidgetsApp; aqui é necessário para
    // o `onTapOutside` do overlay funcionar.
    child: TapRegionSurface(
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (BuildContext context) => AppTheme(
              data: AppThemeData.light,
              child: Center(child: SizedBox(width: 200, child: child)),
            ),
          ),
        ],
      ),
    ),
  ),
);

Widget _trigger(BuildContext context, AppPickerHandle handle) =>
    GestureDetector(
      onTap: handle.toggle,
      child: const SizedBox(height: 40, width: 200, child: Text('trigger')),
    );

const Key _panelKey = Key('picker-panel');

void main() {
  testWidgets('abre/fecha via handle e reflete isOpen', (tester) async {
    late AppPickerHandle handle;
    await tester.pumpWidget(
      _host(
        AppPickerAnchor(
          trigger: (context, h) {
            handle = h;
            return _trigger(context, h);
          },
          panel: (context, h) =>
              const SizedBox(key: _panelKey, width: 100, height: 100),
        ),
      ),
    );

    expect(find.byKey(_panelKey), findsNothing);
    expect(handle.isOpen, isFalse);

    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byKey(_panelKey), findsOneWidget);
    expect(handle.isOpen, isTrue);

    // Fecha programaticamente (o fechar-ao-clicar-fora vem do AnchoredOverlay,
    // já coberto por popover/menu).
    handle.close();
    await tester.pumpAndSettle();
    expect(find.byKey(_panelKey), findsNothing);
    expect(handle.isOpen, isFalse);
  });

  testWidgets('rebuild() atualiza o painel aberto', (tester) async {
    String value = 'A';
    late AppPickerHandle handle;
    await tester.pumpWidget(
      _host(
        AppPickerAnchor(
          trigger: (context, h) {
            handle = h;
            return _trigger(context, h);
          },
          panel: (context, h) => Text(value),
        ),
      ),
    );
    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();
    expect(find.text('A'), findsOneWidget);

    value = 'B';
    handle.rebuild();
    await tester.pump();
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets(
    'overlay: sem crash, sem sublinhado amarelo, reflete text scale',
    (tester) async {
      TextScaler? panelScaler;
      await tester.pumpWidget(
        _host(
          AppPickerAnchor(
            trigger: _trigger,
            panel: (context, h) => Builder(
              builder: (BuildContext c) {
                panelScaler = MediaQuery.textScalerOf(c);
                return const SizedBox(key: _panelKey, child: Text('p'));
              },
            ),
          ),
          textScale: 2.0,
        ),
      );
      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // O text scale do host chega ao overlay (via AppOverlayScope).
      expect(panelScaler, const TextScaler.linear(2.0));
      // DefaultTextStyle concreto → sem o fallback amarelo do Flutter.
      final TextStyle ds = DefaultTextStyle.of(
        tester.element(find.byKey(_panelKey)),
      ).style;
      expect(ds.decoration, isNot(TextDecoration.underline));
    },
  );

  testWidgets('width.fixed fixa a largura do painel', (tester) async {
    await tester.pumpWidget(
      _host(
        AppPickerAnchor(
          width: const AppPickerWidth.fixed(180),
          trigger: _trigger,
          panel: (context, h) => const SizedBox(key: _panelKey, height: 50),
        ),
      ),
    );
    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();
    // O painel preenche o SizedBox de largura da âncora. Mira no
    // AppOverlayPanel (identidade estável do painel) e não no AppCard: sob o
    // eixo glass ligado — o default das marcas — quem pinta é o AppGlassSurface.
    expect(tester.getSize(find.byType(AppOverlayPanel)).width, 180);
  });

  testWidgets('width.matchTrigger casa com a largura do trigger', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppPickerAnchor(
          width: const AppPickerWidth.matchTrigger(),
          trigger: _trigger, // SizedBox width 200
          panel: (context, h) => const SizedBox(key: _panelKey, height: 50),
        ),
      ),
    );
    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(AppOverlayPanel)).width, 200);
  });

  test('AppPickerAnchor está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) =>
            m.id == 'app_picker_anchor' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
