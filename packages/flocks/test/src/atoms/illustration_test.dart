import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(
  Widget child, {
  AppIllustrationProvider? provider,
}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    // reduce-motion → AppShimmerLoading renderiza estático (sem timer pendente).
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: provider == null
          ? AppThemeData.light
          : AppThemeData.light.copyWith(
              illustrationTheme: AppIllustrationTheme(provider: provider),
            ),
      child: Center(child: child),
    ),
  ),
);

/// Provider que renderiza SÓ o placeholder — para provar o que o componente
/// entrega, sem depender de quando um asset ou uma rede resolvem.
final class _PlaceholderProbe implements AppIllustrationProvider {
  const _PlaceholderProbe();

  @override
  Widget build(
    BuildContext context,
    String illustration, {
    required Color accentColor,
    required Color baseColor,
    required WidgetBuilder placeholder,
    required double size,
  }) => placeholder(context);
}

void main() {
  group('AppIllustrationColorMapper', () {
    const mapper = AppIllustrationColorMapper(
      baseColor: Color(0xFF111111),
      accentColor: Color(0xFF222222),
    );

    test('substitui baseColor quando o id começa com baseColor', () {
      expect(
        mapper.substitute(
          'baseColor_1',
          'path',
          'fill',
          const Color(0xFF000000),
        ),
        const Color(0xFF111111),
      );
    });

    test('substitui accentColor quando o id começa com accentColor', () {
      expect(
        mapper.substitute(
          'accentColor_1',
          'path',
          'fill',
          const Color(0xFF000000),
        ),
        const Color(0xFF222222),
      );
    });

    test('id desconhecido retorna a cor original', () {
      const original = Color(0xFF00FF00);
      expect(mapper.substitute('unknown', 'path', 'fill', original), original);
    });

    test('id null retorna a cor original', () {
      const original = Color(0xFF00FF00);
      expect(mapper.substitute(null, 'path', 'fill', original), original);
    });

    test('id vazio retorna a cor original', () {
      const original = Color(0xFF00FF00);
      expect(mapper.substitute('', 'path', 'fill', original), original);
    });
  });

  group('AppIllustration', () {
    testWidgets('entrega o shimmer ao provider como placeholder de espera', (
      tester,
    ) async {
      // O teste anterior afirmava "mostra shimmer enquanto carrega" e passava
      // por ARTEFATO do sandbox: a implementação antiga ficava presa num
      // `FutureBuilder` que nunca completava sem rede, então o shimmer ficava
      // para sempre. Não media UX, media a ausência de rede.
      //
      // O que é verificável de verdade é a costura: quem decide COMO a espera
      // aparece é o componente, e ele entrega isso pronto ao provider — que é
      // quem sabe SE há espera.
      await tester.pumpWidget(
        _host(
          const AppIllustration(AppIllustrationToken.empty),
          provider: const _PlaceholderProbe(),
        ),
      );
      expect(find.byType(AppShimmerLoading), findsOneWidget);
    });

    testWidgets('semanticLabel expõe imagem rotulada', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          const AppIllustration(AppIllustrations.empty, semanticLabel: 'Vazio'),
        ),
      );
      expect(find.bySemanticsLabel('Vazio'), findsOneWidget);
      handle.dispose();
    });

    // Ausência de asset é estado desenhável, não exceção — o mesmo contrato do
    // AppIcon. O `_host` já centraliza o filho, então o tamanho medido é o do
    // widget e não o das constraints apertadas da raiz do `pumpWidget`.
    testWidgets('null não desenha nada', (tester) async {
      await tester.pumpWidget(_host(const AppIllustration(null)));
      expect(tester.getSize(find.byType(AppIllustration)), Size.zero);
    });
  });

  test('illustration no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) =>
            m.id == 'app_illustration' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
