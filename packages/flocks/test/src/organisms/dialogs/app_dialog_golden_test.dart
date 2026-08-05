@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack} — conteúdo textual determinístico
// (sem ilustração de rede). Gerar:
//   flutter test --update-goldens --tags golden
void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  Widget body(AppThemeData data, {bool withHeading = false}) => Padding(
    padding: const EdgeInsets.all(AppSpacings.s24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (withHeading) ...<Widget>[
          AppText('Excluir veículo?', style: data.textTheme.titleLarge),
          const SizedBox(height: AppSpacings.s8),
        ],
        AppText(
          'Esta ação não pode ser desfeita.',
          style: data.textTheme.bodyMedium,
        ),
      ],
    ),
  );

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppDialog golden · $label', (tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);
        // A superfície padrão (800×600) não comporta a pilha de estados.
        await tester.binding.setSurfaceSize(const Size(480, 1400));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        Widget footer() => Padding(
          padding: const EdgeInsets.all(AppSpacings.s16),
          child: AppText('Ok', style: data.textTheme.titleMedium),
        );

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: AppTheme(
                data: data,
                child: Container(
                  key: const Key('golden'),
                  color: data.colorTheme.surface,
                  width: 480,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 24,
                    children: <Widget>[
                      // elevated (default), outlined e filled lado a lado — os
                      // três COM a barra de topo, que é o render padrão. O
                      // `outlined` é o que prova que a barra não apaga a borda
                      // de cima (ela é desenhada ATRÁS do filho).
                      for (final AppStyle? style in <AppStyle?>[
                        null,
                        AppStyle.outlined,
                        AppStyle.filled,
                      ])
                        AppDialog(
                          style: style,
                          title: 'Excluir veículo?',
                          footer: footer(),
                          child: body(data),
                        ),
                      // "X" do outro lado: o título não pode se mexer.
                      AppDialog(
                        title: 'Excluir veículo?',
                        closeSide: AppSheetCloseSide.start,
                        footer: footer(),
                        child: body(data),
                      ),
                      // Só o "X", sem título — o caso dos dialogs que ainda
                      // desenham o próprio cabeçalho no corpo.
                      AppDialog(
                        footer: footer(),
                        child: body(data, withHeading: true),
                      ),
                      // Sem barra nenhuma: o card volta a abraçar o conteúdo.
                      AppDialog(
                        showCloseButton: false,
                        footer: footer(),
                        child: body(data, withHeading: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_dialog_$label.png'),
        );
      });
    }
  }
}
