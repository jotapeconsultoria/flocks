import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {required Size size}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(size: size),
    child: AppTheme(data: AppThemeData.light, child: child),
  ),
);

AppAuthSplitLayout _layout() => const AppAuthSplitLayout(
  brandTitle: 'Bem-vindo',
  brandSubtitle: 'Acesse sua conta',
  logoUrl: AppIcons.infoCircle,
  child: Text('formulário'),
);

/// O rótulo que o link do logo anuncia ao leitor de tela.
const String _linkLabel = 'Abrir site da marca';

void main() {
  group('logo widget e identidade', () {
    testWidgets(
      'asserts: canal duplo, widget sem rótulo, tela sem identidade',
      (tester) async {
        expect(
          () => AppAuthSplitLayout(
            brandTitle: 'Marca',
            logoUrl: AppIcons.infoCircle,
            logo: const Text('ACME'),
            logoSemanticLabel: 'ACME',
            child: const SizedBox(),
          ),
          throwsAssertionError,
        );
        expect(
          () => AppAuthSplitLayout(
            brandTitle: 'Marca',
            logo: const Text('ACME'),
            child: const SizedBox(),
          ),
          throwsAssertionError,
        );
        expect(
          () => AppAuthSplitLayout(
            brandSubtitle: 'apoio não conta',
            child: const SizedBox(),
          ),
          throwsAssertionError,
        );
      },
    );

    testWidgets('sem título, com logo widget: renderiza e anuncia a marca', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          size: const Size(1280, 800),
          const AppAuthSplitLayout(
            logo: Text('ACME', key: ValueKey<String>('marca')),
            logoSemanticLabel: 'ACME',
            child: SizedBox(),
          ),
        ),
      );
      expect(find.byKey(const ValueKey<String>('marca')), findsOneWidget);
      expect(find.bySemanticsLabel('ACME'), findsWidgets);
      handle.dispose();
    });

    testWidgets('com websiteUrl o rótulo do link segue fixo, em nó separado', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          size: const Size(1280, 800),
          const AppAuthSplitLayout(
            logo: Text('ACME'),
            logoSemanticLabel: 'ACME',
            websiteUrl: 'https://acme.example',
            child: SizedBox(),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Abrir site da marca'), findsOneWidget);
      expect(find.bySemanticsLabel('ACME'), findsWidgets);
      handle.dispose();
    });

    testWidgets('logoUrl + logoSemanticLabel nomeia o ícone', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          size: const Size(1280, 800),
          const AppAuthSplitLayout(
            logoUrl: AppIcons.infoCircle,
            logoSemanticLabel: 'ACME',
            child: SizedBox(),
          ),
        ),
      );
      expect(find.bySemanticsLabel('ACME'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('só subtítulo some junto com o título ausente', (tester) async {
      await tester.pumpWidget(
        _host(
          size: const Size(1280, 800),
          const AppAuthSplitLayout(
            logoSemanticLabel: 'ACME',
            logo: Text('A'),
            brandSubtitle: 'Slogan',
            child: SizedBox(),
          ),
        ),
      );
      expect(find.text('Slogan'), findsOneWidget);
    });
  });

  testWidgets('desktop: mostra título, subtítulo e formulário', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(_layout(), size: const Size(1200, 800)));
    expect(find.text('Bem-vindo'), findsOneWidget);
    expect(find.text('Acesse sua conta'), findsOneWidget);
    expect(find.text('formulário'), findsOneWidget);
  });

  testWidgets('mobile: renderiza o card com o formulário', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(_layout(), size: const Size(400, 800)));
    expect(find.text('formulário'), findsOneWidget);
    expect(find.text('Bem-vindo'), findsOneWidget);
  });

  group('o logo só vira link quando há site para abrir', () {
    // A URL chega por PARÂMETRO. O organism lia `AppBrand.current.websiteUrl` —
    // um singleton global alcançado de dentro de `lib/src` para buscar um dado
    // que já vinha por parâmetro ao seu lado. Estes casos fixam as duas pontas
    // do contrato novo, e o par importa: sem o segundo, o primeiro ficaria verde
    // no dia em que o link sumisse por qualquer outro motivo.
    testWidgets('sem websiteUrl: o logo fica, o link não', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_host(_layout(), size: const Size(1200, 800)));
      expect(find.byType(AppIcon), findsOneWidget);
      expect(find.bySemanticsLabel(_linkLabel), findsNothing);
      handle.dispose();
    });

    testWidgets('com websiteUrl: o logo vira alvo anunciado', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          const AppAuthSplitLayout(
            brandTitle: 'Bem-vindo',
            brandSubtitle: 'Acesse sua conta',
            logoUrl: AppIcons.infoCircle,
            websiteUrl: 'https://acme.example',
            child: Text('formulário'),
          ),
          size: const Size(1200, 800),
        ),
      );
      expect(find.bySemanticsLabel(_linkLabel), findsOneWidget);
      handle.dispose();
    });

    testWidgets('sem logo não deixa alvo fantasma', (tester) async {
      // Um AppInteraction de tamanho zero continuaria anunciado ao leitor de
      // tela sem nada para tocar. Sem logo, o link sai junto — mesmo com site
      // declarado, porque não há o que clicar.
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          const AppAuthSplitLayout(
            brandTitle: 'Bem-vindo',
            brandSubtitle: 'Acesse sua conta',
            websiteUrl: 'https://acme.example',
            child: Text('formulário'),
          ),
          size: const Size(1200, 800),
        ),
      );
      expect(find.bySemanticsLabel(_linkLabel), findsNothing);
      expect(find.text('Bem-vindo'), findsOneWidget);
      handle.dispose();
    });
  });

  test('AppAuthSplitLayout está no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_auth_split_layout' &&
            m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
