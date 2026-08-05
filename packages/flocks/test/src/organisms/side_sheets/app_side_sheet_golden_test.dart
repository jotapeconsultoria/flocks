@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
// Importa a superfície interna (não exportada no baril) para golden dos estados
// discretos do morph (determinístico, sem animação).
import 'package:flocks/src/organisms/side_sheets/side_sheet_surface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} × estados do morph (lado end/start,
// progresso rest/mid/full, style, handle). Host largo (1000×700); o painel é
// ancorado ao lado por um `Row` com espaçador. Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];
  const Size screen = Size(1000, 700);
  // full = (largura - peek) / largura (sem safe-area no golden).
  final double fullFraction =
      (screen.width - kSideSheetEdgePeek) / screen.width;

  Widget content(AppThemeData data) => Padding(
    padding: const EdgeInsets.all(AppSpacings.s24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppText('Detalhes do veículo', style: data.textTheme.titleLarge),
        const SizedBox(height: AppSpacings.s16),
        AppText(
          'Placa, modelo, motorista e último evento. Arraste a borda para '
          'expandir ou recolher este painel.',
          style: data.textTheme.bodyMedium,
        ),
      ],
    ),
  );

  Widget panel(
    AppThemeData data, {
    required AppSheetSide side,
    required double p,
    required double fraction,
    AppStyle? style,
    bool handle = false,
  }) {
    final Widget sheet = SizedBox(
      width: fraction * screen.width,
      child: SideSheetSurface(
        fullProgress: p,
        side: side,
        style: style,
        showHandle: handle,
        title: 'Veículo',
        footer: Padding(
          padding: const EdgeInsets.all(AppSpacings.s16),
          child: AppText('Editar', style: data.textTheme.titleMedium),
        ),
        child: content(data),
      ),
    );
    return Row(
      children: side == AppSheetSide.end
          ? <Widget>[const Expanded(child: SizedBox()), sheet]
          : <Widget>[sheet, const Expanded(child: SizedBox())],
    );
  }

  final Map<String, Widget Function(AppThemeData)> states =
      <String, Widget Function(AppThemeData)>{
        'rest_end': (AppThemeData d) =>
            panel(d, side: AppSheetSide.end, p: 0, fraction: 0.40),
        'mid_end': (AppThemeData d) =>
            panel(d, side: AppSheetSide.end, p: 0.5, fraction: 0.55),
        'full_end': (AppThemeData d) =>
            panel(d, side: AppSheetSide.end, p: 1, fraction: fullFraction),
        'rest_start': (AppThemeData d) =>
            panel(d, side: AppSheetSide.start, p: 0, fraction: 0.40),
        'outlined_end': (AppThemeData d) => panel(
          d,
          side: AppSheetSide.end,
          p: 0,
          fraction: 0.40,
          style: AppStyle.outlined,
        ),
        'handle_end': (AppThemeData d) => panel(
          d,
          side: AppSheetSide.end,
          p: 0,
          fraction: 0.40,
          handle: true,
        ),
      };

  for (final MapEntry<String, Widget Function(AppThemeData)> state
      in states.entries) {
    for (final AppBrandConfig brand in brands) {
      for (final bool dark in <bool>[false, true]) {
        final String label =
            '${state.key}_${brand.clientSlug}_${dark ? 'dark' : 'light'}';

        testWidgets('AppSideSheet golden · $label', (tester) async {
          await tester.binding.setSurfaceSize(screen);
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: const MediaQueryData(size: screen),
                child: AppTheme(
                  data: data,
                  child: SizedBox(
                    key: const Key('golden'),
                    width: screen.width,
                    height: screen.height,
                    child: ColoredBox(
                      color: data.colorTheme.neutralPrimary.barrier(),
                      child: state.value(data),
                    ),
                  ),
                ),
              ),
            ),
          );

          await expectLater(
            find.byKey(const Key('golden')),
            matchesGoldenFile('goldens/app_side_sheet_$label.png'),
          );
        });
      }
    }
  }
}
