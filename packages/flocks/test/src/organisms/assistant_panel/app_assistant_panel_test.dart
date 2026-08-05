import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const Key _bodyKey = Key('body');
const Key _composerKey = Key('composer');
const Key _bannerKey = Key('banner');

Future<void> _pumpPanel(
  WidgetTester tester, {
  Widget? alertBanner,
  Widget? composer,
  String? statusLabel = 'Sempre online',
  bool isOnline = true,
  List<Widget> actions = const [],
  double height = 700,
}) async {
  tester.view
    ..physicalSize = Size(400, height)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    AppTheme(
      data: AppThemeData.light,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 360,
          height: height,
          child: AppAssistantPanel(
            title: 'Atlas',
            statusLabel: statusLabel,
            isOnline: isOnline,
            alertBanner: alertBanner,
            composer: composer,
            actions: actions,
            body: const ColoredBox(
              key: _bodyKey,
              color: Color(0x00000000),
              child: SizedBox.expand(),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('AppAssistantPanel — cabeçalho', () {
    testWidgets('mostra nome e status', (tester) async {
      await _pumpPanel(tester);

      expect(find.text('Atlas'), findsOneWidget);
      // Status vive num badge, que pinta em caixa-alta.
      expect(find.text('SEMPRE ONLINE'), findsOneWidget);
      // O atalho que foca o composer é anunciado LÁ, não aqui: repetido nas
      // duas pontas da mesma coluna, vira ruído.
      expect(find.byType(AppShortcutHint), findsNothing);
    });

    testWidgets('sem status, só o nome', (tester) async {
      await _pumpPanel(tester, statusLabel: null);

      expect(find.text('Atlas'), findsOneWidget);
      expect(find.text('SEMPRE ONLINE'), findsNothing);
    });

    testWidgets('ações extras aparecem no cabeçalho', (tester) async {
      await _pumpPanel(
        tester,
        actions: const [Text('AÇÃO', textDirection: TextDirection.ltr)],
      );

      expect(find.text('AÇÃO'), findsOneWidget);
    });
  });

  group('AppAssistantPanel — composição', () {
    testWidgets('corpo ocupa o espaço restante', (tester) async {
      await _pumpPanel(tester);

      final body = tester.getRect(find.byKey(_bodyKey));
      // Cabeçalho fixo em cima, corpo com o resto.
      expect(body.top, kAppAssistantPanelHeaderHeight);
      expect(body.bottom, 700);
    });

    testWidgets('composer fica ancorado embaixo', (tester) async {
      await _pumpPanel(
        tester,
        composer: const SizedBox(key: _composerKey, height: 80),
      );

      final composer = tester.getRect(find.byKey(_composerKey));
      final body = tester.getRect(find.byKey(_bodyKey));

      expect(composer.bottom, 700);
      expect(body.bottom, composer.top);
    });

    testWidgets('faixa de alerta fica fixa entre cabeçalho e corpo', (
      tester,
    ) async {
      await _pumpPanel(
        tester,
        alertBanner: const SizedBox(key: _bannerKey, height: 48),
      );

      final banner = tester.getRect(find.byKey(_bannerKey));
      final body = tester.getRect(find.byKey(_bodyKey));

      // Fixa: não rola junto com a conversa — é o que sustenta "alertas
      // visíveis a todo tempo".
      expect(banner.top, kAppAssistantPanelHeaderHeight);
      expect(body.top, banner.bottom);
    });

    testWidgets('sem faixa, o corpo encosta no cabeçalho', (tester) async {
      await _pumpPanel(tester);

      final body = tester.getRect(find.byKey(_bodyKey));
      expect(body.top, kAppAssistantPanelHeaderHeight);
    });

    testWidgets('cabeçalho, faixa e composer coexistem', (tester) async {
      await _pumpPanel(
        tester,
        alertBanner: const SizedBox(key: _bannerKey, height: 48),
        composer: const SizedBox(key: _composerKey, height: 80),
      );

      final banner = tester.getRect(find.byKey(_bannerKey));
      final body = tester.getRect(find.byKey(_bodyKey));
      final composer = tester.getRect(find.byKey(_composerKey));

      expect(banner.top, kAppAssistantPanelHeaderHeight);
      expect(body.top, banner.bottom);
      expect(body.bottom, composer.top);
      expect(composer.bottom, 700);
    });
  });
}
