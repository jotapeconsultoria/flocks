import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: SizedBox(width: 380, child: child)),
    ),
  ),
);

const AppBottomSheetContent _content = AppBottomSheetContent(
  title: 'Atenção',
  message: 'Confira os dados antes de continuar.',
  illustration: 'assets/illustrations/warning.svg',
);

void main() {
  testWidgets('mostra título, mensagem e ilustração', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_host(_content));

    expect(find.text('Atenção'), findsOneWidget);
    expect(find.text('Confira os dados antes de continuar.'), findsOneWidget);
    expect(find.byType(AppIllustration), findsOneWidget);
  });

  testWidgets('o corpo é agnóstico da sheet — renderiza fora dela', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_host(_content));

    // É o que permite reusá-lo num dialog, num estado vazio ou num preview:
    // ele não procura ancestral de sheet nenhum.
    expect(tester.takeException(), isNull);
    expect(find.byType(AppBottomSheet), findsNothing);
  });

  testWidgets('accentRole tinge a ilustração sem mexer no texto', (
    WidgetTester tester,
  ) async {
    final AppColorTheme colors = AppThemeData.light.colorTheme;

    await tester.pumpWidget(_host(_content));
    final Color titleDefault = tester
        .widget<AppText>(
          find.byWidgetPredicate(
            (Widget w) => w is AppText && w.data == 'Atenção',
          ),
        )
        .style!
        .color!;

    await tester.pumpWidget(
      _host(
        AppBottomSheetContent(
          title: 'Atenção',
          message: 'Confira os dados antes de continuar.',
          illustration: 'assets/illustrations/warning.svg',
          accentRole: colors.warning,
        ),
      ),
    );
    final Color titleAccented = tester
        .widget<AppText>(
          find.byWidgetPredicate(
            (Widget w) => w is AppText && w.data == 'Atenção',
          ),
        )
        .style!
        .color!;

    // O acento é da ilustração; o texto continua legível pelo token de
    // conteúdo, senão um accentRole claro apagaria o título.
    expect(titleAccented, titleDefault);
  });

  testWidgets('sem título renderiza só mensagem + ilustração', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppBottomSheetContent(
          title: '',
          message: 'Só a mensagem.',
          illustration: 'assets/illustrations/warning.svg',
        ),
      ),
    );

    expect(find.text('Só a mensagem.'), findsOneWidget);
  });

  test('AppBottomSheetContent no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_bottom_sheet_content' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
