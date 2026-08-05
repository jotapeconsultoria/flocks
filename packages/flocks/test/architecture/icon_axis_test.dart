import 'dart:io';

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// O eixo de ícone: censo, contrato e alcance.
///
/// Antes disto o desenho de um ícone era uma URL fixa dentro do pacote —
/// publicar o Flocks prendia todo adotante ao CDN e à licença de outra pessoa.
/// São três provas distintas, e nenhuma substitui as outras:
///
/// - **censo**: ninguém em `lib/src` desenha ícone por fora do eixo;
/// - **contrato**: o provider padrão serve TODOS os [AppIconToken];
/// - **alcance**: trocar o provider troca o que aparece na tela. Ausência de
///   ofensor não é presença de efeito.
/// Um provider de teste que devolve uma marca reconhecível.
final class _MarkerIconProvider implements AppIconProvider {
  const _MarkerIconProvider(this.marker);

  final String marker;

  @override
  Widget build(
    BuildContext context,
    String icon, {
    required double size,
    Color? color,
  }) => SizedBox.square(
    dimension: size,
    child: Text('$marker:$icon', textDirection: TextDirection.ltr),
  );
}

Widget _host(Widget child, {AppIconProvider? provider}) => Directionality(
  textDirection: TextDirection.ltr,
  child: AppTheme(
    data: provider == null
        ? AppThemeData.light
        : AppThemeData.light.copyWith(
            iconTheme: AppIconTheme(provider: provider),
          ),
    child: child,
  ),
);

void main() {
  group('contrato — o provider padrão serve todo AppIconToken', () {
    test('cada token tem um SVG em assets/icons/', () {
      final List<String> missing = <String>[
        for (final AppIconToken token in AppIconToken.values)
          if (!File('assets/icons/${token.slug}.svg').existsSync()) token.slug,
      ];
      expect(
        missing,
        isEmpty,
        reason:
            'Sem o arquivo, o AppAssetIconProvider desenha o placeholder de '
            'erro — e o Flocks deixa de funcionar sozinho. Baixe o SVG '
            '(instruções em assets/icons/README.md) ou tire o token do '
            'contrato.',
      );
    });

    test('não há SVG órfão — todo arquivo corresponde a um slug conhecido', () {
      // Contra `AppIconToken`, e não contra o catálogo: o core embute
      // EXATAMENTE o contrato. Asset a mais aqui é peso que todo adotante paga
      // sem pedir — a biblioteca inteira mora em `flocks_phosphor`.
      final Set<String> slugs = AppIconToken.values
          .map((AppIconToken t) => t.slug)
          .toSet();
      final List<String> orphans = <String>[
        for (final FileSystemEntity f in Directory('assets/icons').listSync())
          if (f.path.endsWith('.svg') &&
              !slugs.contains(f.uri.pathSegments.last.split('.').first))
            f.uri.pathSegments.last,
      ];
      expect(
        orphans,
        isEmpty,
        reason:
            'O core embute só o contrato. Ícone extra vai para o pacote irmão '
            '(flocks_phosphor), não para cá.',
      );
    });

    test('os 55 tokens são únicos e não vazios', () {
      final List<String> slugs = AppIconToken.values
          .map((AppIconToken t) => t.slug)
          .toList();
      expect(slugs.toSet().length, slugs.length, reason: 'slug duplicado');
      expect(slugs.where((String s) => s.isEmpty), isEmpty);
    });
  });

  group('censo — ninguém desenha ícone por fora do eixo', () {
    test('nenhum AppIcon em lib/src recebe URL crua', () {
      final List<String> offenders = <String>[];
      for (final FileSystemEntity entity in Directory(
        'lib/src',
      ).listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) {
          continue;
        }
        final String content = entity.readAsStringSync();
        for (final RegExp pattern in <RegExp>[
          RegExp(r"AppIcon\(\s*'https?://"),
          RegExp(r"AppIcon\(\s*'[a-z]"),
        ]) {
          if (pattern.hasMatch(content)) {
            offenders.add(entity.path);
          }
        }
      }
      expect(
        offenders.toSet(),
        isEmpty,
        reason:
            'Use AppIconToken. Literal e URL amarram o componente a um set de '
            'ícones, que é justo o que o eixo desfaz.',
      );
    });

    test('AppIcons não guarda mais URL — são slugs', () {
      final String source = File(
        'lib/src/tokens/app_icons.dart',
      ).readAsStringSync();
      expect(
        source,
        isNot(contains('http')),
        reason:
            'O catálogo voltou a embutir endereço. Quem traduz slug em URL é '
            'o AppNetworkIconProvider da marca.',
      );
    });

    test('o core não importa Material — nem pelo caminho do ícone', () {
      for (final FileSystemEntity entity in Directory(
        'lib/src/foundation/icons',
      ).listSync()) {
        if (entity is! File || !entity.path.endsWith('.dart')) {
          continue;
        }
        expect(
          entity.readAsStringSync(),
          isNot(contains('package:flutter/material.dart')),
          reason:
              'Um adaptador de Material tem de ser um pacote separado: é essa '
              'regra que sustenta a tese de zero Material.',
        );
      }
    });
  });

  group('alcance — trocar o provider troca o pixel', () {
    setUp(() => AppIcon.debugIconBuilder = null);
    tearDown(() => AppIcon.debugIconBuilder = null);

    testWidgets('o AppIcon desenha pelo provider do tema', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppIcon(AppIconToken.check),
          provider: const _MarkerIconProvider('A'),
        ),
      );
      expect(find.text('A:check'), findsOneWidget);
    });

    testWidgets('trocar o provider muda o que aparece', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppIcon(AppIconToken.check),
          provider: const _MarkerIconProvider('A'),
        ),
      );
      await tester.pumpWidget(
        _host(
          const AppIcon(AppIconToken.check),
          provider: const _MarkerIconProvider('B'),
        ),
      );
      expect(find.text('A:check'), findsNothing);
      expect(find.text('B:check'), findsOneWidget);
    });

    testWidgets('o token chega ao provider como slug, não como URL', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppIcon(AppIconToken.chevronDown),
          provider: const _MarkerIconProvider('slug'),
        ),
      );
      expect(find.text('slug:chevron-down'), findsOneWidget);
    });

    test('o default do PACOTE é o provider de assets', () {
      // Sem marca no caminho, o eixo cai no que o pacote embute — é isso que
      // faz o Flocks desenhar no primeiro `flutter run`, sem rede. Hoje as
      // marcas registradas também usam o de assets, mas os dois defaults são
      // objetos distintos: foi confundi-los que errou o alvo deste teste na
      // primeira versão.
      expect(AppIconTheme.standard.provider, isA<AppAssetIconProvider>());
      expect(
        AppThemeData(
          brightness: AppBrightness.light,
          colorTheme: AppColorTheme.light,
          textTheme: AppTextStyles.textTheme,
        ).iconTheme.provider,
        isA<AppAssetIconProvider>(),
      );
    });
  });

  group('compatibilidade — URL crua ainda é aceita', () {
    const AppNetworkIconProvider provider = AppNetworkIconProvider(
      baseUrl: 'https://cdn.example.com/icons',
    );

    test('slug vira endereço sob a baseUrl', () {
      expect(
        provider.urlFor('check'),
        'https://cdn.example.com/icons/check.svg',
      );
    });

    test('URL absoluta passa direto, sem concatenar', () {
      const String url = 'https://outro.example.com/x.svg';
      expect(provider.urlFor(url), url);
      expect(
        provider.urlFor('http://inseguro.example.com/y.svg'),
        'http://inseguro.example.com/y.svg',
      );
    });

    test('nenhuma marca embute provider — quem escolhe o set é o app', () {
      for (final AppBrandConfig brand in <AppBrandConfig>[
        flocksBrand,
        jotapeBrand,
        zxtrackBrand,
      ]) {
        expect(
          brand.iconTheme.provider,
          isA<AppAssetIconProvider>(),
          reason:
              '${brand.clientSlug} voltou a buscar ícone na rede. Os 55 do '
              'contrato estão embutidos, e é isso que faz o pacote desenhar '
              'offline; um app que precise de mais resolve no provider dele '
              '(o flocks_phosphor tem os 1.512 em fonte). O provider de rede '
              'existe para quem tem catálogo próprio, não para nós.',
        );
      }
    });
  });
}
