import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const Key _railKey = Key('rail');
const Key _headerKey = Key('header');
const Key _asideKey = Key('aside');
const Key _contentKey = Key('content');

Future<void> _pumpShell(
  WidgetTester tester, {
  bool fullscreen = false,
  Size size = const Size(1280, 800),
  EdgeInsets margin = kAppShellContentMargin,
  AppRadiusMode radiusMode = AppRadiusMode.padrao,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    AppTheme(
      data: AppThemeData.light.copyWith(
        radiusTheme: AppRadiusTheme(mode: radiusMode),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: AppShell(
              fullscreen: fullscreen,
              contentMargin: margin,
              header: const SizedBox(key: _headerKey, height: 64),
              rail: const SizedBox(key: _railKey, width: 88),
              aside: const SizedBox(key: _asideKey, width: 320),
              content: const SizedBox.expand(key: _contentKey),
            ),
          ),
        ),
      ),
    ),
  );
}

Rect _rectOf(WidgetTester tester, Key key) {
  final box = tester.renderObject<RenderBox>(find.byKey(key));
  final topLeft = box.localToGlobal(Offset.zero);
  return topLeft & box.size;
}

void main() {
  group('AppShell — geometria', () {
    testWidgets('aside ocupa a altura total', (tester) async {
      await _pumpShell(tester);

      final shell = _rectOf(tester, _contentKey);
      final aside = _rectOf(tester, _asideKey);
      final header = _rectOf(tester, _headerKey);

      // O aside começa no topo (acima do header terminar) e vai até a base.
      expect(aside.top, lessThanOrEqualTo(header.top));
      expect(aside.bottom, greaterThanOrEqualTo(shell.bottom));
      expect(aside.height, 800);
    });

    testWidgets('header vai da borda esquerda até o aside, não full-width', (
      tester,
    ) async {
      await _pumpShell(tester);

      final header = _rectOf(tester, _headerKey);
      final aside = _rectOf(tester, _asideKey);
      final rail = _rectOf(tester, _railKey);

      // Começa na mesma borda esquerda do rail...
      expect(header.left, rail.left);
      // ...e termina exatamente onde o aside começa.
      expect(header.right, aside.left);
      expect(header.width, 1280 - 320);
    });

    testWidgets('rail fica abaixo do header, sem atravessá-lo', (tester) async {
      await _pumpShell(tester);

      final header = _rectOf(tester, _headerKey);
      final rail = _rectOf(tester, _railKey);

      expect(rail.top, header.bottom);
      expect(rail.bottom, 800);
    });

    testWidgets('conteúdo é um cartão que não encosta na base', (tester) async {
      await _pumpShell(tester);

      final content = _rectOf(tester, _contentKey);
      final rail = _rectOf(tester, _railKey);

      // Margem embaixo: é o que dá a leitura de "flutuando sobre o fundo".
      expect(content.bottom, 800 - kAppShellContentMargin.bottom);
      // Margem à esquerda, separando do rail.
      expect(content.left, rail.right + kAppShellContentMargin.left);
      // E à direita, separando do aside.
      expect(content.right, 1280 - 320 - kAppShellContentMargin.right);
    });

    testWidgets('cartão tem raio nos quatro cantos', (tester) async {
      await _pumpShell(tester);

      final clip = tester.widget<ClipRRect>(
        find
            .ancestor(
              of: find.byKey(_contentKey),
              matching: find.byType(ClipRRect),
            )
            .first,
      );
      final radius = clip.borderRadius as BorderRadius;

      // Diferente do shell antigo, que arredondava só o topo.
      expect(radius.topLeft.x, kRedondoCap);
      expect(radius.topRight.x, kRedondoCap);
      expect(radius.bottomLeft.x, kRedondoCap);
      expect(radius.bottomRight.x, kRedondoCap);
    });

    testWidgets('o canto obedece ao eixo de forma da marca', (tester) async {
      // O cartão do shell é a maior superfície da tela: se a marca escolhe
      // `reto` e este canto continua curvo, o resto da tela desmente a marca.
      await _pumpShell(tester, radiusMode: AppRadiusMode.reto);

      final clip = tester.widget<ClipRRect>(
        find
            .ancestor(
              of: find.byKey(_contentKey),
              matching: find.byType(ClipRRect),
            )
            .first,
      );
      expect((clip.borderRadius as BorderRadius).topLeft.x, 0);
    });

    testWidgets('margem é configurável', (tester) async {
      await _pumpShell(tester, margin: const EdgeInsets.all(AppSpacings.s32));

      final content = _rectOf(tester, _contentKey);
      expect(content.bottom, 800 - AppSpacings.s32);
    });
  });

  group('AppShell — fullscreen', () {
    testWidgets('esconde rail, header e aside', (tester) async {
      await _pumpShell(tester, fullscreen: true);

      expect(find.byKey(_railKey), findsNothing);
      expect(find.byKey(_headerKey), findsNothing);
      expect(find.byKey(_asideKey), findsNothing);
      expect(find.byKey(_contentKey), findsOneWidget);
    });

    testWidgets('conteúdo ocupa a janela inteira, sem margem', (tester) async {
      await _pumpShell(tester, fullscreen: true);

      final content = _rectOf(tester, _contentKey);
      expect(content.size, const Size(1280, 800));
    });

    testWidgets('alternar não remonta o conteúdo', (tester) async {
      // Garante que mapas e abas vivas sobrevivem ao fullscreen.
      await _pumpShell(tester);
      final before = tester.element(find.byKey(_contentKey));

      await _pumpShell(tester, fullscreen: true);
      final after = tester.element(find.byKey(_contentKey));

      expect(identical(before, after), isTrue);
    });
  });

  group('AppShell — slots opcionais', () {
    testWidgets('só com conteúdo, ocupa tudo', (tester) async {
      await tester.pumpWidget(
        AppTheme(
          data: AppThemeData.light,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: AppShell(content: SizedBox.expand(key: _contentKey)),
          ),
        ),
      );

      expect(find.byKey(_contentKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
