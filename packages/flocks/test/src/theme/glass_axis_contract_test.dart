import 'package:flocks/flocks.dart';
import 'package:flocks/src/molecules/card/app_overlay_panel.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Contrato de RENDER do eixo glass, parametrizado por superfície.
//
// O `card_glass_test.dart` já prova o contrato numa superfície só
// (`AppOverlayCard`). Aqui a mesma bateria roda em TODA superfície que deve
// aplicar vidro — em especial as que só chegam ao painel depois de uma
// interação (menu, dropdown, picker), justamente as que ficaram opacas sem
// ninguém notar.
//
// Para cada caso, sob `glassTheme: enabled`:
//   1. renderiza um `BackdropFilter` com o filtro do token;
//   2. `transparencyTheme: false`      → nenhum;
//   3. `MediaQueryData(highContrast)`  → nenhum;
//   4. `MediaQueryData(invertColors)`  → nenhum.
//
// Os três últimos são o gate de acessibilidade: vidro é opt-in estético, mas
// "reduzir transparência" sempre vence.

const List<AppDropdownOption<String>> _opts = <AppDropdownOption<String>>[
  AppDropdownOption<String>(value: 'banana', label: 'Banana'),
  AppDropdownOption<String>(value: 'manga', label: 'Manga'),
];

/// Host com o Overlay do root ACIMA do tema (cenário real do app), com um fundo
/// pintado atrás para o backdrop ter o que amostrar.
Widget _host(
  AppThemeData data,
  Widget child, {
  required MediaQueryData media,
}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: media,
    child: TapRegionSurface(
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (BuildContext context) => Stack(
              children: <Widget>[
                const Positioned.fill(
                  child: ColoredBox(color: Color(0xFF3366CC)),
                ),
                AppTheme(
                  data: data,
                  child: Center(child: SizedBox(width: 300, child: child)),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);

/// Um caso do contrato: como montar a superfície e como chegar até o painel.
typedef _GlassCase = ({
  String name,
  Widget Function() build,
  Future<void> Function(WidgetTester)? open,
});

Future<void> _tapType<T extends Widget>(WidgetTester tester) async {
  await tester.tap(find.byType(T));
  await tester.pumpAndSettle();
}

final List<_GlassCase> _cases = <_GlassCase>[
  (
    name: 'AppOverlayPanel',
    build: () => const AppOverlayPanel(child: Text('x')),
    open: null,
  ),
  (
    name: 'AppOverlayCard',
    build: () => const AppOverlayCard(child: Text('x')),
    open: null,
  ),
  (
    name: 'AppMenu',
    build: () => const AppMenu(
      trigger: Text('abrir'),
      entries: <AppMenuEntry>[AppMenuItem(label: 'Editar')],
    ),
    open: _tapType<AppMenu>,
  ),
  (
    name: 'AppDropdown',
    build: () => AppDropdown<String>(
      options: _opts,
      hintText: 'Selecione',
      onChanged: (_) {},
    ),
    open: _tapType<AppDropdown<String>>,
  ),
  (
    name: 'AppMultiSelect',
    build: () => AppMultiSelect<String>(
      options: _opts,
      hintText: 'Selecione',
      onChanged: (_) {},
    ),
    open: _tapType<AppMultiSelect<String>>,
  ),
  (
    name: 'AppPickerAnchor',
    build: () => AppPickerAnchor(
      trigger: (BuildContext context, AppPickerHandle handle) =>
          GestureDetector(
            onTap: handle.toggle,
            child: const SizedBox(height: 40, width: 200, child: Text('abrir')),
          ),
      panel: (BuildContext context, AppPickerHandle handle) =>
          const SizedBox(height: 50, child: Text('painel')),
    ),
    open: (WidgetTester tester) async {
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
    },
  ),
];

Finder _backdrop() => find.byType(BackdropFilter);

/// Tema com o eixo glass LIGADO (o default do DS é off, opt-in por marca).
AppThemeData _glassOn({AppTransparencyTheme? transparency}) =>
    AppThemeData.light.copyWith(
      glassTheme: const AppGlassTheme(enabled: true),
      transparencyTheme: transparency,
    );

void main() {
  for (final _GlassCase c in _cases) {
    group('${c.name} · eixo glass', () {
      Future<void> pump(
        WidgetTester tester,
        AppThemeData data, {
        MediaQueryData media = const MediaQueryData(disableAnimations: true),
      }) async {
        await tester.pumpWidget(_host(data, c.build(), media: media));
        await c.open?.call(tester);
      }

      testWidgets('glass ligado → BackdropFilter com o filtro do token', (
        tester,
      ) async {
        await pump(tester, _glassOn());

        expect(
          _backdrop(),
          findsOneWidget,
          reason:
              '${c.name} não aplicou vidro com o eixo glass ligado. Painéis '
              'flutuantes devem usar AppOverlayPanel (ver app_glass_axis.dart).',
        );
        expect(
          tester.widget<BackdropFilter>(_backdrop()).filter,
          AppGlass.backdropFilter(),
        );
      });

      testWidgets('transparencyTheme=false → opaco', (tester) async {
        await pump(
          tester,
          _glassOn(transparency: const AppTransparencyTheme(enabled: false)),
        );
        expect(_backdrop(), findsNothing);
      });

      testWidgets('MediaQuery.highContrast → opaco', (tester) async {
        await pump(
          tester,
          _glassOn(),
          media: const MediaQueryData(
            disableAnimations: true,
            highContrast: true,
          ),
        );
        expect(_backdrop(), findsNothing);
      });

      testWidgets('MediaQuery.invertColors → opaco', (tester) async {
        await pump(
          tester,
          _glassOn(),
          media: const MediaQueryData(
            disableAnimations: true,
            invertColors: true,
          ),
        );
        expect(_backdrop(), findsNothing);
      });
    });
  }

  // Atenção: `AppThemeData.light` NÃO tem o eixo desligado — deriva de
  // `AppBrand.current`, que cai no `jotapeBrand` (glass on). Para exercitar o
  // render opaco é preciso desligar explicitamente.
  testWidgets('glass desligado → painel opaco delega ao AppCard', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppThemeData.light.copyWith(
          glassTheme: const AppGlassTheme(enabled: false),
        ),
        const AppOverlayPanel(child: Text('x')),
        media: const MediaQueryData(disableAnimations: true),
      ),
    );
    expect(_backdrop(), findsNothing);
    expect(
      find.byType(AppCard),
      findsOneWidget,
      reason:
          'Sem glass o AppOverlayPanel delega ao AppCard — é o que garante que '
          'o render opaco dos painéis não mudou.',
    );
  });
}
