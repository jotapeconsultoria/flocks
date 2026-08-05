import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// O eixo de tipografia da marca **chega** ao pixel.
///
/// Que `AppBrandConfig` tenha um campo `typography` não prova nada: o campo
/// podia ficar parado no caminho até o `AppThemeData`, que é justo onde o eixo
/// morria antes (`themeFor` recebia só a cor). Aqui a prova é de EFEITO —
/// trocar a marca tem de trocar a família que o texto realmente renderiza.
///
/// Par do censo: nenhum componente lê `AppTextStyles` direto (todos passam por
/// `theme.textTheme.*`), o que é o que torna este eixo suficiente.
const AppBrandTypography _spaceGroteskDisplay = AppBrandTypography(
  displayFamily: AppFontFamilies.spaceGrotesk,
);

/// Uma fonte do próprio app: família sem pacote nenhum.
const AppBrandTypography _appOwnedFont = AppBrandTypography(
  bodyFamily: 'Inter',
  bodyFontPackage: null,
  displayFamily: 'Inter',
  displayFontPackage: null,
);

/// Os 15 estilos, separados pelo papel que a marca controla.
List<TextStyle> _display(AppTextTheme t) => <TextStyle>[
  t.displayLarge,
  t.displayMedium,
  t.displaySmall,
  t.headlineLarge,
  t.headlineMedium,
  t.headlineSmall,
];

List<TextStyle> _body(AppTextTheme t) => <TextStyle>[
  t.bodyLarge,
  t.bodyMedium,
  t.bodySmall,
  t.labelLarge,
  t.labelMedium,
  t.labelSmall,
  t.titleLarge,
  t.titleMedium,
  t.titleSmall,
];

AppTextTheme _themeOf(AppBrandTypography typography) => AppThemeData.forBrand(
  jotapeBrand.copyWith(typography: typography),
  dark: false,
).textTheme;

void main() {
  group('eixo de tipografia — a marca chega ao textTheme', () {
    test('padrão do pacote: Poppins empacotada nos 15 estilos', () {
      final AppTextTheme t = _themeOf(AppBrandTypography.standard);
      for (final TextStyle s in <TextStyle>[..._display(t), ..._body(t)]) {
        expect(s.fontFamily, 'packages/flocks/Poppins');
      }
    });

    test('displayFamily vale para display* e headline*, e SÓ para eles', () {
      final AppTextTheme t = _themeOf(_spaceGroteskDisplay);
      for (final TextStyle s in _display(t)) {
        expect(s.fontFamily, 'packages/flocks/SpaceGrotesk');
      }
      for (final TextStyle s in _body(t)) {
        expect(s.fontFamily, 'packages/flocks/Poppins');
      }
    });

    test('bodyFamily ausente: a display não arrasta o corpo junto', () {
      final AppTextTheme t = _themeOf(_spaceGroteskDisplay);
      expect(t.bodyLarge.fontFamily, isNot(t.displayLarge.fontFamily));
    });

    test(
      'displayFamily ausente: a display herda o corpo, com o pacote certo',
      () {
        final AppTextTheme t = _themeOf(
          const AppBrandTypography(bodyFamily: 'Inter', bodyFontPackage: null),
        );
        expect(t.bodyLarge.fontFamily, 'Inter');
        expect(t.displayLarge.fontFamily, 'Inter');
      },
    );

    test('fonte do app: família crua, sem prefixo de pacote', () {
      final AppTextTheme t = _themeOf(_appOwnedFont);
      for (final TextStyle s in <TextStyle>[..._display(t), ..._body(t)]) {
        expect(s.fontFamily, 'Inter');
        expect(s.fontFamily, isNot(startsWith('packages/')));
      }
    });

    test('fonte do app: reconstruir o estilo não perde a geometria', () {
      // O caminho sem pacote é o único que reconstrói o TextStyle em vez de
      // copiar (o `package` não se limpa por `copyWith`). Reconstruir é onde se
      // perde campo em silêncio — o estilo continuaria "funcionando", só que
      // com o tamanho ou o peso errado.
      final AppTextTheme base = _themeOf(AppBrandTypography.standard);
      final AppTextTheme own = _themeOf(_appOwnedFont);
      final List<TextStyle> a = <TextStyle>[..._display(base), ..._body(base)];
      final List<TextStyle> b = <TextStyle>[..._display(own), ..._body(own)];
      for (int i = 0; i < a.length; i++) {
        expect(b[i].fontSize, a[i].fontSize, reason: 'fontSize do estilo $i');
        expect(b[i].fontWeight, a[i].fontWeight, reason: 'fontWeight do $i');
        expect(b[i].height, a[i].height, reason: 'height do estilo $i');
        expect(b[i].color, a[i].color, reason: 'color do estilo $i');
      }
    });

    test('trocar a marca muda a família — duas marcas, mesmo processo', () {
      final AppTextTheme a = _themeOf(AppBrandTypography.standard);
      final AppTextTheme b = _themeOf(_spaceGroteskDisplay);
      expect(a.displayLarge.fontFamily, isNot(b.displayLarge.fontFamily));
    });

    test('a cor do brilho continua sendo aplicada junto da família', () {
      final AppThemeData light = AppThemeData.forBrand(
        jotapeBrand.copyWith(typography: _spaceGroteskDisplay),
        dark: false,
      );
      final AppThemeData dark = AppThemeData.forBrand(
        jotapeBrand.copyWith(typography: _spaceGroteskDisplay),
        dark: true,
      );
      expect(light.textTheme.displayLarge.color, light.colorTheme.onSurface);
      expect(dark.textTheme.displayLarge.color, dark.colorTheme.onSurface);
      expect(
        light.textTheme.displayLarge.color,
        isNot(dark.textTheme.displayLarge.color),
      );
    });
  });

  group('eixo de tipografia — chega ao widget renderizado', () {
    testWidgets('o AppText pinta com a família da marca', (tester) async {
      final AppThemeData data = AppThemeData.forBrand(
        jotapeBrand.copyWith(typography: _spaceGroteskDisplay),
        dark: false,
      );
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AppTheme(
            data: data,
            child: Center(
              child: AppText('Flocks', style: data.textTheme.displayLarge),
            ),
          ),
        ),
      );
      final RichText rich = tester.widget<RichText>(
        find.descendant(
          of: find.byType(AppText),
          matching: find.byType(RichText),
        ),
      );
      expect(rich.text.style?.fontFamily, 'packages/flocks/SpaceGrotesk');
    });
  });

  group('AppTextTheme.copyWith — o escape hatch de um estilo só', () {
    test('troca o estilo pedido e não encosta nos outros 14', () {
      final AppTextTheme base = _themeOf(AppBrandTypography.standard);
      final AppTextTheme patched = base.copyWith(
        titleLarge: base.titleLarge.copyWith(letterSpacing: 4.2),
      );
      expect(patched.titleLarge.letterSpacing, 4.2);
      expect(patched.titleMedium, base.titleMedium);
      expect(patched.displayLarge, base.displayLarge);
      expect(patched.labelSmall, base.labelSmall);
    });

    test('sem argumento nenhum, devolve um tema igual', () {
      final AppTextTheme base = _themeOf(AppBrandTypography.standard);
      expect(base.copyWith(), base);
    });
  });

  group('AppBrandConfig.copyWith', () {
    test('troca a tipografia e preserva o resto da marca', () {
      final AppBrandConfig derived = jotapeBrand.copyWith(
        typography: _spaceGroteskDisplay,
      );
      expect(derived.typography, _spaceGroteskDisplay);
      expect(derived.clientSlug, jotapeBrand.clientSlug);
      expect(derived.primaryColor, jotapeBrand.primaryColor);
      expect(derived.radiusTheme, jotapeBrand.radiusTheme);
      expect(derived.glassTheme, jotapeBrand.glassTheme);
    });
  });
}
