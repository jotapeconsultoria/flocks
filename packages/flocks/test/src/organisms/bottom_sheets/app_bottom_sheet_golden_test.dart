@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
// Importa a superfície interna (não exportada no baril) para golden dos estados
// discretos do morph em `pageProgress` fixo (determinístico, sem animação).
import 'package:flocks/src/organisms/bottom_sheets/bottom_sheet_surface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} × estados do morph. Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];
  const Size screen = Size(400, 800);

  Widget content(AppThemeData data) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppText(
          'Refine a busca pelos veículos.',
          style: data.textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacings.s16),
        AppText(
          'Selecione conta, grupo e período para filtrar os resultados '
          'exibidos no mapa e nos relatórios.',
          style: data.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacings.s24),
      ],
    ),
  );

  Widget surface(
    AppThemeData data, {
    required double p,
    AppStyle? style,
    bool handle = false,
    AppSheetCloseSide side = AppSheetCloseSide.end,
    bool footer = true,
  }) => BottomSheetSurface(
    pageProgress: p,
    style: style,
    showHandle: handle,
    closeSide: side,
    title: 'Filtros',
    footer: footer
        ? Padding(
            padding: const EdgeInsets.all(AppSpacings.s16),
            child: AppText('Aplicar', style: data.textTheme.titleMedium),
          )
        : null,
    child: content(data),
  );

  // O widget PÚBLICO, e não a superfície interna: é ele que ganhou
  // `showHandle` no conserto do DS-A2.
  Widget publicSheet(AppThemeData data, {required bool handle}) =>
      AppBottomSheet(
        title: 'Filtros',
        showHandle: handle,
        footer: Padding(
          padding: const EdgeInsets.all(AppSpacings.s16),
          child: AppText('Aplicar', style: data.textTheme.titleMedium),
        ),
        child: content(data),
      );

  final Map<String, Widget Function(AppThemeData)> states =
      <String, Widget Function(AppThemeData)>{
        'rest': (AppThemeData d) => surface(d, p: 0),
        'mid': (AppThemeData d) => surface(d, p: 0.5),
        'page': (AppThemeData d) => surface(d, p: 1),
        'outlined': (AppThemeData d) =>
            surface(d, p: 0, style: AppStyle.outlined),
        'handle': (AppThemeData d) => surface(d, p: 0, handle: true),
        'close_start': (AppThemeData d) =>
            surface(d, p: 0, side: AppSheetCloseSide.start),
        // O par que faltava. Os seis casos acima montam `BottomSheetSurface`
        // DIRETO — e a superfície já aceitava `showHandle` antes do conserto,
        // então nenhum deles cobre o caminho que quebrava: o `AppBottomSheet`
        // público, cujo construtor NÃO tinha o parâmetro e o descartava em
        // silêncio no ramo não-arrastável. Só um par prova: com a grabber e
        // sem ela, no widget público, para a diferença aparecer no pixel.
        'public_handle': (AppThemeData d) => publicSheet(d, handle: true),
        'public_no_handle': (AppThemeData d) => publicSheet(d, handle: false),
      };

  for (final MapEntry<String, Widget Function(AppThemeData)> state
      in states.entries) {
    for (final AppBrandConfig brand in brands) {
      for (final bool dark in <bool>[false, true]) {
        final String label =
            '${state.key}_${brand.clientSlug}_${dark ? 'dark' : 'light'}';

        testWidgets('AppBottomSheet golden · $label', (tester) async {
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
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: state.value(data),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          await expectLater(
            find.byKey(const Key('golden')),
            matchesGoldenFile('goldens/app_bottom_sheet_$label.png'),
          );
        });
      }
    }
  }
}
