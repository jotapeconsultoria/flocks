// O eixo de ilustração: contrato e alcance.
//
// Último canto em que o pacote levava a asset licenciado de terceiro —
// `AppIllustrations` interpolava a URL do CDN privado, servindo Streamline,
// exatamente o defeito que o eixo de ícone já tinha resolvido.
//
// Espelha `icon_axis_test.dart`, e pela mesma razão: contrato (o provider
// padrão serve tudo que o design system pede) e alcance (trocar o provider
// troca o que aparece). O contrato aqui é de UM — só `empty` é usada em runtime
// dentro de `lib/src`.
import 'dart:io';

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

final class _MarkerIllustrationProvider implements AppIllustrationProvider {
  const _MarkerIllustrationProvider(this.marker);

  final String marker;

  @override
  Widget build(
    BuildContext context,
    String illustration, {
    required Color accentColor,
    required Color baseColor,
    required WidgetBuilder placeholder,
    required double size,
  }) => SizedBox.square(
    dimension: size,
    child: Text('$marker:$illustration', textDirection: TextDirection.ltr),
  );
}

Widget _host(Widget child, {AppIllustrationProvider? provider}) =>
    Directionality(
      textDirection: TextDirection.ltr,
      child: AppTheme(
        data: provider == null
            ? AppThemeData.light
            : AppThemeData.light.copyWith(
                illustrationTheme: AppIllustrationTheme(provider: provider),
              ),
        child: child,
      ),
    );

void main() {
  group('contrato — o provider padrão serve todo AppIllustrationToken', () {
    test('cada token tem um SVG em assets/illustrations/', () {
      final List<String> missing = <String>[
        for (final AppIllustrationToken t in AppIllustrationToken.values)
          if (!File('assets/illustrations/${t.slug}.svg').existsSync()) t.slug,
      ];
      expect(missing, isEmpty);
    });

    test('não há SVG órfão', () {
      final Set<String> slugs = AppIllustrationToken.values
          .map((AppIllustrationToken t) => t.slug)
          .toSet();
      final List<String> orphans = <String>[
        for (final FileSystemEntity f in Directory(
          'assets/illustrations',
        ).listSync())
          if (f.path.endsWith('.svg') &&
              !slugs.contains(f.uri.pathSegments.last.split('.').first))
            f.uri.pathSegments.last,
      ];
      expect(orphans, isEmpty);
    });

    test('o SVG embutido não carrega cor — quem pinta é o tema', () {
      for (final AppIllustrationToken t in AppIllustrationToken.values) {
        final String svg = File(
          'assets/illustrations/${t.slug}.svg',
        ).readAsStringSync();
        expect(
          svg,
          isNot(contains('fill="#')),
          reason:
              '${t.slug} tem cor no arquivo: não vai seguir o tema nem inverter '
              'no escuro.',
        );
        expect(
          svg,
          contains('id="baseColor'),
          reason:
              '${t.slug} não tem camada baseColor — o AppIllustrationColorMapper '
              'pinta por id, e sem ela a ilustração sai invisível.',
        );
      }
    });
  });

  group('censo — o catálogo não guarda mais URL', () {
    test('AppIllustrations são slugs', () {
      expect(
        File('lib/src/tokens/app_illustrations.dart').readAsStringSync(),
        isNot(contains('http')),
        reason:
            'O catálogo voltou a embutir endereço. Quem traduz slug em URL é o '
            'AppNetworkIllustrationProvider do app.',
      );
    });

    test('nenhuma marca embute provider — quem escolhe o set é o app', () {
      for (final AppBrandConfig brand in <AppBrandConfig>[
        flocksBrand,
        jotapeBrand,
        zxtrackBrand,
      ]) {
        expect(
          brand.illustrationTheme.provider,
          isA<AppAssetIllustrationProvider>(),
          reason: '${brand.clientSlug} fixou um provider de ilustração.',
        );
      }
    });
  });

  group('alcance — trocar o provider troca o pixel', () {
    testWidgets('a AppIllustration desenha pelo provider do tema', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppIllustration(AppIllustrationToken.empty),
          provider: const _MarkerIllustrationProvider('A'),
        ),
      );
      expect(find.text('A:empty'), findsOneWidget);
    });

    testWidgets('trocar o provider muda o que aparece', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppIllustration(AppIllustrationToken.empty),
          provider: const _MarkerIllustrationProvider('A'),
        ),
      );
      await tester.pumpWidget(
        _host(
          const AppIllustration(AppIllustrationToken.empty),
          provider: const _MarkerIllustrationProvider('B'),
        ),
      );
      expect(find.text('A:empty'), findsNothing);
      expect(find.text('B:empty'), findsOneWidget);
    });

    test('o default do pacote é o provider de assets', () {
      expect(
        AppIllustrationTheme.standard.provider,
        isA<AppAssetIllustrationProvider>(),
      );
    });
  });

  group('compatibilidade — URL crua ainda é aceita', () {
    const AppNetworkIllustrationProvider provider =
        AppNetworkIllustrationProvider(baseUrl: 'https://cdn.example.com/ill');

    test('slug vira endereço sob a baseUrl', () {
      expect(provider.urlFor('empty'), 'https://cdn.example.com/ill/empty.svg');
    });

    test('URL absoluta passa direto', () {
      const String url = 'https://outro.example.com/x.svg';
      expect(provider.urlFor(url), url);
    });
  });
}
