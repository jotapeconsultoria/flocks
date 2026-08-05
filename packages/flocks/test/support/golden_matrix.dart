// A matriz golden marca × brilho, num lugar só.
//
// Antes cada um dos 51 arquivos de golden repetia o mesmo andaime de ~25 linhas
// e trocava a marca pelo singleton `AppBrand.setBrand`. Dois problemas: qualquer
// ajuste no host tinha de ser reaplicado 51 vezes, e o singleton é estado de
// processo — a suíte só era determinística porque ninguém a rodava em paralelo.
//
// Aqui a marca entra por `AppThemeData.forBrand`, então cada caso é
// independente e o `-j 1` deixa de ser requisito escondido.
import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

// Reexportado para o arquivo de golden precisar de UM import só: `@Tags`,
// `testWidgets` e os matchers vêm daqui junto com a matriz.
export 'package:flutter_test/flutter_test.dart';

/// As marcas cobertas por toda matriz golden.
const List<AppBrandConfig> kGoldenBrands = <AppBrandConfig>[
  jotapeBrand,
  zxtrackBrand,
];

/// A chave do recorte comparado — sempre a mesma, para o finder ser trivial.
const Key kGoldenKey = Key('golden');

/// Rótulo do arquivo: `jotape_light`, `zxtrack_dark`…
String goldenLabel(AppBrandConfig brand, {required bool dark}) =>
    '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

/// Monta [child] no host padrão dos goldens e compara com
/// `goldens/<name>_<marca>_<brilho>.png`, para as 2 marcas × 2 brilhos.
///
/// [builder] recebe o tema já resolvido — vários casos precisam dele para
/// pintar o fundo do recorte ou escolher uma cor de exemplo.
///
/// [width] é a largura do recorte; [padding] o respiro em volta. `disableAnimations`
/// entra por padrão: golden com animação em voo é golden instável.
@isTest
void goldenMatrixTest(
  String name, {
  required Widget Function(AppThemeData theme) builder,
  double width = 360,
  EdgeInsets padding = const EdgeInsets.all(24),
  Size? surfaceSize,
  bool disableAnimations = true,
}) {
  for (final AppBrandConfig brand in kGoldenBrands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = goldenLabel(brand, dark: dark);
      testWidgets('$name golden · $label', (WidgetTester tester) async {
        if (surfaceSize != null) {
          await tester.binding.setSurfaceSize(surfaceSize);
          addTearDown(() => tester.binding.setSurfaceSize(null));
        }
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          goldenHost(
            data,
            width: width,
            padding: padding,
            disableAnimations: disableAnimations,
            child: builder(data),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(kGoldenKey),
          matchesGoldenFile('goldens/${name}_$label.png'),
        );
      });
    }
  }
}

/// O host sozinho, para o caso que precisa de um pump customizado (abrir um
/// overlay, semear um controller) antes de comparar.
Widget goldenHost(
  AppThemeData data, {
  required Widget child,
  double width = 360,
  EdgeInsets padding = const EdgeInsets.all(24),
  bool disableAnimations = true,
}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: AppTheme(
      data: data,
      child: Container(
        key: kGoldenKey,
        color: data.colorTheme.surface,
        width: width,
        padding: padding,
        child: child,
      ),
    ),
  ),
);
