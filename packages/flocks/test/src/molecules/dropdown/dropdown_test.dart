import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const List<AppDropdownOption<String>> _opts = <AppDropdownOption<String>>[
  AppDropdownOption<String>(value: 'banana', label: 'Banana'),
  AppDropdownOption<String>(value: 'manga', label: 'Manga'),
  AppDropdownOption<String>(value: 'melancia', label: 'Melancia'),
];

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (BuildContext context) =>
                Center(child: SizedBox(width: 300, child: child)),
          ),
        ],
      ),
    ),
  ),
);

// Reproduz o cenário real (WB/app): o Overlay fica ACIMA do provider de tema —
// o AppTheme embrulha só o trigger, não o Overlay. A entry aberta é irmã do
// trigger, sem AppTheme no caminho → sem o fix, AppTheme.of lança no overlay.
Widget _hostThemeBelowOverlay(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext context) => AppTheme(
            data: AppThemeData.light,
            child: Center(child: SizedBox(width: 300, child: child)),
          ),
        ),
      ],
    ),
  ),
);

void main() {
  testWidgets('AppDropdown: abre com o Overlay acima do tema (sem crash)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _hostThemeBelowOverlay(
        AppDropdown<String>(
          hintText: 'Selecione',
          options: _opts,
          onChanged: (_) {},
        ),
      ),
    );
    await tester.tap(find.byType(AppDropdown<String>));
    await tester.pump();
    // Sem reprovê AppTheme na entry, isto lançaria "No AppTheme found in context".
    expect(tester.takeException(), isNull);
    expect(find.text('Manga'), findsOneWidget);
    // Sem o DefaultTextStyle reprovido, o texto da opção cairia no fallback do
    // Flutter (sublinhado amarelo duplo "faltou Material").
    final TextStyle optStyle = DefaultTextStyle.of(
      tester.element(find.text('Manga')),
    ).style;
    expect(optStyle.decoration, isNot(TextDecoration.underline));
  });

  testWidgets('AppDropdown: abre e seleciona', (tester) async {
    String? selected;
    await tester.pumpWidget(
      _host(
        AppDropdown<String>(
          hintText: 'Selecione',
          options: _opts,
          onChanged: (v) => selected = v,
        ),
      ),
    );
    await tester.tap(find.byType(AppDropdown<String>));
    await tester.pump();
    expect(find.text('Manga'), findsOneWidget); // opção no overlay
    await tester.tap(find.text('Manga'));
    await tester.pump();
    expect(selected, 'manga');
  });

  testWidgets('AppMultiSelect: seleciona sem fechar', (tester) async {
    List<String>? values;
    await tester.pumpWidget(
      _host(
        AppMultiSelect<String>(
          hintText: 'Selecione',
          options: _opts,
          onChanged: (v) => values = v,
        ),
      ),
    );
    await tester.tap(find.byType(AppMultiSelect<String>));
    await tester.pump();
    await tester.tap(find.text('Banana'));
    await tester.pump();
    expect(values, <String>['banana']);
    // Overlay ainda aberto: outra opção visível.
    expect(find.text('Melancia'), findsOneWidget);
  });

  testWidgets('AppSearchableDropdown: filtra por texto', (tester) async {
    await tester.pumpWidget(
      _host(
        AppSearchableDropdown<String>(
          hintText: 'Selecione',
          searchHintText: 'Buscar',
          options: _opts,
          onChanged: (_) {},
        ),
      ),
    );
    await tester.tap(find.byType(AppSearchableDropdown<String>));
    await tester.pump();
    expect(find.text('Banana'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'man');
    await tester.pump();
    expect(find.text('Manga'), findsOneWidget);
    expect(find.text('Banana'), findsNothing);
  });

  testWidgets(
    'AppSearchableDropdown: cabeçalho de seção aparece e some no filtro',
    (tester) async {
      const List<AppDropdownOption<String>> sectioned =
          <AppDropdownOption<String>>[
            AppDropdownOption<String>(
              value: 'utc',
              label: 'UTC',
              section: 'Recomendados',
            ),
            AppDropdownOption<String>(
              value: 'sp',
              label: 'America/Sao_Paulo · BR',
              section: 'Recomendados',
            ),
            AppDropdownOption<String>(
              value: 'ny',
              label: 'America/New_York · US',
            ),
          ];
      await tester.pumpWidget(
        _host(
          AppSearchableDropdown<String>(
            hintText: 'Selecione',
            searchHintText: 'Buscar',
            options: sectioned,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.tap(find.byType(AppSearchableDropdown<String>));
      await tester.pump();
      // Cabeçalho não-selecionável (caixa alta) antes do bloco recomendado.
      expect(find.text('RECOMENDADOS'), findsOneWidget);
      expect(find.text('UTC'), findsOneWidget);
      // Filtrar por um item fora da seção esconde o cabeçalho vazio.
      await tester.enterText(find.byType(EditableText), 'york');
      await tester.pump();
      expect(find.text('RECOMENDADOS'), findsNothing);
      expect(find.textContaining('New_York'), findsOneWidget);
    },
  );

  testWidgets(
    'AppSearchableMultiSelect: seleção vazia + allOptionLabel mostra "Todos" '
    'no trigger',
    (tester) async {
      await tester.pumpWidget(
        _host(
          AppSearchableMultiSelect<String>(
            allOptionLabel: 'Todos',
            hintText: 'Veículo',
            options: _opts,
            onChanged: (_) {},
          ),
        ),
      );
      // Fechado: o trigger exibe "Todos" (não o hint) e não a lista.
      expect(find.text('Todos'), findsOneWidget);
      expect(find.text('Veículo'), findsNothing);
    },
  );

  testWidgets('AppSearchableMultiSelect: tocar em "Todos" limpa a seleção', (
    tester,
  ) async {
    List<String>? values;
    await tester.pumpWidget(
      _host(
        AppSearchableMultiSelect<String>(
          allOptionLabel: 'Todos',
          options: _opts,
          selectedValues: const <String>['banana'],
          onChanged: (v) => values = v,
        ),
      ),
    );
    await tester.tap(find.byType(AppSearchableMultiSelect<String>));
    await tester.pump();
    // Com seleção não-vazia, "Todos" só aparece como linha do overlay.
    expect(find.text('Todos'), findsOneWidget);
    await tester.tap(find.text('Todos'));
    await tester.pump();
    expect(values, isEmpty);
  });

  testWidgets('AppSearchableMultiSelect: "Todos" some ao buscar', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppSearchableMultiSelect<String>(
          allOptionLabel: 'Todos',
          searchHintText: 'Buscar',
          options: _opts,
          selectedValues: const <String>['banana'],
          onChanged: (_) {},
        ),
      ),
    );
    await tester.tap(find.byType(AppSearchableMultiSelect<String>));
    await tester.pump();
    expect(find.text('Todos'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'man');
    await tester.pump();
    // Busca ativa → a linha "Todos" desaparece; só o filtro resta.
    expect(find.text('Todos'), findsNothing);
    expect(find.text('Manga'), findsOneWidget);
  });

  testWidgets('AppMultiSelect: chip em tom de primary', (tester) async {
    await tester.pumpWidget(
      _host(
        AppMultiSelect<String>(
          options: _opts,
          selectedValues: const <String>['banana'],
          onChanged: (_) {},
        ),
      ),
    );
    final Color primaryS100 = AppThemeData.light.colorTheme.primary.s100;
    final bool chipTinted = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((DecoratedBox d) => d.decoration)
        .whereType<BoxDecoration>()
        .any((BoxDecoration d) => d.color == primaryS100);
    expect(chipTinted, isTrue);
  });

  testWidgets('AppMultiSelect: erro + seleção → ✕ limpa e reabre', (
    tester,
  ) async {
    List<String>? values;
    await tester.pumpWidget(
      _host(
        AppMultiSelect<String>(
          options: _opts,
          selectedValues: const <String>['banana'],
          hasError: true,
          onChanged: (v) => values = v,
        ),
      ),
    );
    // O chevron do trigger virou ✕ (close); o ✕ do chip é `cancel`.
    final closeFinder = find.byWidgetPredicate(
      (Widget w) => w is AppIcon && w.icon == AppIcons.close,
    );
    expect(closeFinder, findsOneWidget);
    await tester.tap(closeFinder, warnIfMissed: false);
    await tester.pump();
    expect(values, isEmpty);
    // Reabriu o overlay: opções visíveis.
    expect(find.text('Manga'), findsOneWidget);
  });

  testWidgets('AppDropdown: erro + valor → ✕ limpa (null) e reabre', (
    tester,
  ) async {
    String? selected = 'banana';
    await tester.pumpWidget(
      _host(
        AppDropdown<String>(
          options: _opts,
          selectedValue: 'banana',
          hasError: true,
          onChanged: (v) => selected = v,
        ),
      ),
    );
    final closeFinder = find.byWidgetPredicate(
      (Widget w) => w is AppIcon && w.icon == AppIcons.close,
    );
    expect(closeFinder, findsOneWidget);
    await tester.tap(closeFinder, warnIfMissed: false);
    await tester.pump();
    expect(selected, isNull);
    expect(find.text('Manga'), findsOneWidget);
  });

  testWidgets('AppDropdown: erro sem valor mantém o chevron', (tester) async {
    await tester.pumpWidget(
      _host(
        AppDropdown<String>(
          hintText: 'Selecione',
          options: _opts,
          hasError: true,
          onChanged: (_) {},
        ),
      ),
    );
    final bool hasClose = tester
        .widgetList<AppIcon>(find.byType(AppIcon))
        .any((AppIcon w) => w.icon == AppIcons.close);
    expect(hasClose, isFalse);
  });

  testWidgets('AppDropdown: info abre popover no clique', (tester) async {
    await tester.pumpWidget(
      _host(
        AppDropdown<String>(
          label: 'Fruta',
          options: _opts,
          onChanged: (_) {},
          info: const Text(
            'Escolha uma fruta',
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
    final infoFinder = find.byWidgetPredicate(
      (Widget w) => w is AppIcon && w.icon == AppIcons.infoCircle,
    );
    expect(infoFinder, findsOneWidget);
    await tester.tap(infoFinder, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('Escolha uma fruta'), findsOneWidget);
  });

  // Contraste das cores do campo/opções nas 2 marcas × 2 brilhos.
  group('contraste (jotape/zxtrack × claro/escuro)', () {
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
        test('borda/label/acento/erro/opção · $bl', () {
          // Fechado: borda outline ≥ 3:1, label onSurface ≥ AA.
          expect(
            contrastRatio(c.outline, c.surface) >= kUi,
            isTrue,
            reason: 'borda fechada < 3:1 em $bl',
          );
          expect(
            meetsWcag(c.onSurface, c.surface),
            isTrue,
            reason: 'label/opção onSurface < 4.5 em $bl',
          );
          // Aberto: borda primary legível ≥ 3:1, acento secondary ≥ AA.
          expect(
            contrastRatio(readableStopOn(c.primary, c.surface), c.surface) >=
                kUi,
            isTrue,
            reason: 'borda aberta < 3:1 em $bl',
          );
          expect(
            meetsWcag(
              readableStopOn(c.secondary, c.surface, minRatio: 4.5),
              c.surface,
            ),
            isTrue,
            reason: 'acento < 4.5 em $bl',
          );
          // Erro: danger legível ≥ AA.
          expect(
            meetsWcag(
              readableStopOn(c.danger, c.surface, minRatio: 4.5),
              c.surface,
            ),
            isTrue,
            reason: 'erro < 4.5 em $bl',
          );
        });
      }
    }
  });

  test('família dropdown no catálogo como migrada', () {
    for (final String id in <String>[
      'app_dropdown',
      'app_multi_select',
      'app_searchable_dropdown',
      'app_searchable_multi_select',
    ]) {
      expect(
        flocksCatalog.any(
          (m) => m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id ausente',
      );
    }
  });
}
