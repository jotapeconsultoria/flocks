// O gerador de snippet, unidade a unidade.
//
// O gate de frescor (`test/architecture/brand_snippet_freshness_test.dart`)
// cobre uma marca real de ponta a ponta — compila, é byte a byte o esperado e
// faz round-trip. Aqui ficam os casos que aquela marca não exerce: os eixos que
// ela deixa no padrão, os slugs que não são identificadores, e a marca escrita à
// mão, que não tem semente que a descreva e cai no literal de 11 stops.
import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Uma marca mínima: só o obrigatório, todo eixo no padrão.
AppBrandConfig minimal({String slug = 'acme'}) => AppBrandConfig(
  clientSlug: slug,
  primaryColor: swatchFromSeed(const Color(0xFF4F46E5)),
);

void main() {
  group('só emite o que difere do padrão', () {
    test('uma marca mínima é uma semente e mais nada', () {
      final String snippet = minimal().toDartSnippet();

      expect(snippet, contains("clientSlug: 'acme'"));
      expect(
        snippet,
        contains('primaryColor: swatchFromSeed(const Color(0xFF4F46E5))'),
      );
      // Nenhum eixo no padrão aparece — é o que mantém a saída legível.
      expect(snippet, isNot(contains('radiusTheme')));
      expect(snippet, isNot(contains('styleTheme')));
      expect(snippet, isNot(contains('animationTheme')));
      expect(snippet, isNot(contains('glassTheme')));
      expect(snippet, isNot(contains('typography')));
      // Nem os papéis de cor que a marca não declarou.
      expect(snippet, isNot(contains('secondaryColor')));
      expect(snippet, isNot(contains('neutralLightColor')));
      expect(snippet, isNot(contains('dangerColor')));
    });

    test('e traz os dois imports que o corpo usa', () {
      final String snippet = minimal().toDartSnippet();

      expect(snippet, contains("import 'package:flocks/flocks.dart';"));
      expect(snippet, contains("import 'package:flutter/widgets.dart';"));
    });

    for (final (String field, AppBrandConfig brand, String expected)
        in <(String, AppBrandConfig, String)>[
          (
            'radiusTheme',
            minimal().copyWith(
              radiusTheme: const AppRadiusTheme(mode: AppRadiusMode.circular),
            ),
            'radiusTheme: const AppRadiusTheme(mode: AppRadiusMode.circular)',
          ),
          (
            'styleTheme',
            minimal().copyWith(
              styleTheme: const AppStyleTheme(style: AppStyle.outlined),
            ),
            'styleTheme: const AppStyleTheme(style: AppStyle.outlined)',
          ),
          (
            'animationTheme',
            minimal().copyWith(
              animationTheme: const AppAnimationTheme(enabled: false),
            ),
            'animationTheme: const AppAnimationTheme(enabled: false)',
          ),
          (
            'glassTheme',
            minimal().copyWith(glassTheme: const AppGlassTheme(enabled: true)),
            'glassTheme: const AppGlassTheme(enabled: true)',
          ),
        ]) {
      test('$field fora do padrão aparece', () {
        expect(brand.toDartSnippet(), contains(expected));
      });
    }

    test('a tipografia de uma fonte do próprio app zera o pacote', () {
      final String snippet = minimal()
          .copyWith(
            typography: const AppBrandTypography(
              bodyFamily: 'Inter',
              bodyFontPackage: null,
              displayFamily: 'Inter',
              displayFontPackage: null,
            ),
          )
          .toDartSnippet();

      expect(snippet, contains("bodyFamily: 'Inter'"));
      expect(snippet, contains('bodyFontPackage: null'));
      expect(snippet, contains('displayFontPackage: null'));
    });

    test('as duas famílias do pacote saem pelo token, não por string', () {
      final String snippet = minimal()
          .copyWith(
            typography: const AppBrandTypography(
              displayFamily: AppFontFamilies.spaceGrotesk,
            ),
          )
          .toDartSnippet();

      expect(snippet, contains('AppFontFamilies.spaceGrotesk'));
      expect(snippet, isNot(contains("'SpaceGrotesk'")));
    });
  });

  group('o slug vira nome de variável', () {
    for (final (String slug, String expected) in <(String, String)>[
      ('acme', 'acmeBrand'),
      ('Minha Marca', 'minhaMarcaBrand'),
      ('zx-track', 'zxTrackBrand'),
      // Identificador Dart não aceita acento, e o público desta serialização
      // escreve em português: transliterar é o que salva o nome.
      ('Açaí & Cia.', 'acaiCiaBrand'),
      ('Construções São João', 'construcoesSaoJoaoBrand'),
      // Sem nada aproveitável, ou começando por dígito: um nome genérico é
      // melhor que um arquivo que não compila.
      ('', 'myBrand'),
      ('...', 'myBrand'),
      ('4life', 'myBrand'),
    ]) {
      test("'$slug' vira $expected", () {
        expect(
          minimal(slug: slug).toDartSnippet(),
          contains('AppBrandConfig $expected = AppBrandConfig('),
        );
      });
    }

    test('clientSlug: sobrescreve o slug da configuração', () {
      final String snippet = minimal().toDartSnippet(clientSlug: 'globex');

      expect(snippet, contains("clientSlug: 'globex'"));
      expect(snippet, contains('AppBrandConfig globexBrand = AppBrandConfig('));
      expect(snippet, isNot(contains('acme')));
    });

    test('um slug com aspas não escapa da string', () {
      expect(
        minimal(slug: "d'Or").toDartSnippet(),
        contains(r"clientSlug: 'd\'Or'"),
      );
    });
  });

  group('brilho', () {
    test('não é campo da marca — sai só no comentário do tema', () {
      final String snippet = minimal().toDartSnippet(dark: true);

      expect(snippet, contains('AppThemeData.forBrand(acmeBrand, dark: true)'));
      // E não vira argumento do construtor, que não o aceita.
      expect(snippet, isNot(contains('dark: true,')));
    });
  });

  group('uma marca sem semente cai no literal', () {
    test('a jotape sai stop a stop, e a declaração inteira vira const', () {
      final String snippet = jotapeBrand.toDartSnippet();

      expect(snippet, contains('ColorSwatch<int>(0xFF0C3235, <int, Color>{'));
      // Toda a paleta é literal, então nada na declaração precisa de runtime.
      expect(snippet, contains('const AppBrandConfig jotapeBrand'));
      expect(snippet, isNot(contains('swatchFromSeed')));
    });

    test('e o literal é fiel: os 11 stops, valor por valor', () {
      final String snippet = jotapeBrand.toDartSnippet();
      // O primeiro swatch do corpo é o primary — o único obrigatório.
      final String literal = snippet.split('primaryColor: ')[1].split('}')[0];

      for (final int stop in kSwatchStops) {
        final Color expected = jotapeBrand.primaryColor[stop]!;
        final String hex = expected
            .toARGB32()
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0');
        expect(
          literal,
          contains('$stop: Color(0x$hex)'),
          reason: 'o stop $stop saiu diferente do swatch de origem',
        );
      }
    });

    test('uma marca gerada por semente NÃO cai no literal', () {
      expect(flocksBrand.toDartSnippet(), isNot(contains('<int, Color>{')));
    });
  });
}
