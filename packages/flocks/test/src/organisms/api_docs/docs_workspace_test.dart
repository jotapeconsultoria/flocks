import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'api_docs_fixtures.dart';

/// Host com **altura limitada** — é o que o corpo de um `AppSideSheet` dá
/// (`Expanded`). O workspace precisa disso: as colunas rolam sozinhas.
Widget _hostWidget(Widget child, Size size) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: MediaQueryData(size: size),
    child: AppTheme(
      data: AppThemeData.light,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (_) => Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: child,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

/// Monta o host **e** ajusta a superfície de teste.
///
/// Sem `setSurfaceSize` a tela fica nos 800x600 do default e o SizedBox é
/// clampado — o workspace cairia sempre no modo empilhado, e os testes de duas
/// colunas passariam a medir outra coisa.
Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(1400, 800),
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(_hostWidget(child, size));
  await tester.pump();
}

String _rendered(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((Text t) => t.data ?? t.textSpan?.toPlainText() ?? '')
    .join('\n');

void main() {
  group('AppEntityDocPanel', () {
    testWidgets('mostra overview, relações e integrações', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const SingleChildScrollView(
          child: AppEntityDocPanel(doc: kDeviceEntity),
        ),
      );

      final String text = _rendered(tester);
      expect(text.toLowerCase(), contains('dispositivo'));
      // Overview vem de Markdown: o `**` é sintaxe, não conteúdo.
      expect(
        text.toLowerCase(),
        contains('é o hardware que transmite posição.'),
      );
      expect(text, isNot(contains('**dispositivo**')));
      expect(text.toLowerCase(), contains('relações'));
      expect(text.toLowerCase(), contains('chip (sim card)'));
      expect(text.toLowerCase(), contains('integrações'));
      expect(text.toLowerCase(), contains('gateway queclink'));
      expect(text.toLowerCase(), contains('ciclo de vida'));
    });

    testWidgets('cardinalidade e sentido aparecem como rótulo, não só cor', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const SingleChildScrollView(
          child: AppEntityDocPanel(doc: kDeviceEntity),
        ),
      );

      final String text = _rendered(tester);
      expect(text.toLowerCase(), contains('1 → 1'));
      expect(text.toLowerCase(), contains('n → 1'));
      expect(text.toLowerCase(), contains('recebe e envia'));
      expect(text.toLowerCase(), contains('recebe'));
    });

    testWidgets('showHeader: false tira o título próprio', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const SingleChildScrollView(
          child: AppEntityDocPanel(doc: kDeviceEntity, showHeader: false),
        ),
      );

      expect(
        _rendered(tester),
        isNot(contains('O rastreador físico instalado no veículo.')),
      );
    });
  });

  group('AppDocsWorkspace', () {
    testWidgets('em tela larga divide em duas colunas redimensionáveis', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const AppDocsWorkspace(entity: kDeviceEntity, api: kDevicesDoc),
      );

      expect(find.byType(AppResizableSplit), findsOneWidget);
      final String text = _rendered(tester);
      // Cabeçalho de cada coluna.
      expect(text.toLowerCase(), contains('documentação'));
      expect(text.toLowerCase(), contains('api'));
      // Conteúdo das duas metades ao mesmo tempo.
      expect(text.toLowerCase(), contains('chip (sim card)'));
      expect(text.toLowerCase(), contains('crud de dispositivos'));
    });

    testWidgets('cada coluna rola por conta própria', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const AppDocsWorkspace(entity: kDeviceEntity, api: kDevicesDoc),
      );

      // Uma por coluna — é o que impede que ler o schema faça a explicação
      // sumir. (Os blocos de código rolam na horizontal e não contam aqui.)
      final Iterable<SingleChildScrollView> vertical = tester
          .widgetList<SingleChildScrollView>(find.byType(SingleChildScrollView))
          .where(
            (SingleChildScrollView v) => v.scrollDirection == Axis.vertical,
          );
      expect(vertical, hasLength(2));
    });

    testWidgets('sem entidade, a API ocupa a largura toda', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const AppDocsWorkspace(entity: null, api: kDevicesDoc),
      );

      expect(find.byType(AppResizableSplit), findsNothing);
      expect(_rendered(tester), contains('CRUD de dispositivos'));
      expect(_rendered(tester), isNot(contains('Chip (SIM card)')));
    });

    testWidgets('abaixo do corte, empilha num scroll só', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const AppDocsWorkspace(entity: kDeviceEntity, api: kDevicesDoc),
        size: const Size(kAppDocsWorkspaceStackBelow - 100, 900),
      );

      expect(find.byType(AppResizableSplit), findsNothing);
      final Iterable<SingleChildScrollView> vertical = tester
          .widgetList<SingleChildScrollView>(find.byType(SingleChildScrollView))
          .where(
            (SingleChildScrollView v) => v.scrollDirection == Axis.vertical,
          );
      expect(vertical, hasLength(1));
      // As duas metades continuam presentes, só que uma embaixo da outra.
      final String text = _rendered(tester);
      expect(text.toLowerCase(), contains('chip (sim card)'));
      expect(text.toLowerCase(), contains('crud de dispositivos'));
    });

    testWidgets('os dois links externos aparecem e disparam', (
      WidgetTester tester,
    ) async {
      int docs = 0;
      int api = 0;

      await _pump(
        tester,
        AppDocsWorkspace(
          entity: kDeviceEntity,
          api: kDevicesDoc,
          onOpenEntityDocs: () => docs++,
          onOpenApiDocs: () => api++,
        ),
      );

      // O rótulo semântico casa o MergeSemantics e o nó interno; o alvo do tap
      // é o AppInteraction que o carrega.
      Finder link(String label) => find.ancestor(
        of: find.bySemanticsLabel(label).last,
        matching: find.byType(AppInteraction),
      );

      await tester.tap(link('Documentação completa'));
      await tester.tap(link('Referência da API'));
      await tester.pump();

      expect(docs, 1);
      expect(api, 1);
    });

    testWidgets('sem callback, o link some', (WidgetTester tester) async {
      await _pump(
        tester,
        const AppDocsWorkspace(entity: kDeviceEntity, api: kDevicesDoc),
      );

      expect(find.bySemanticsLabel('Documentação completa'), findsNothing);
      expect(find.bySemanticsLabel('Referência da API'), findsNothing);
    });
  });

  group('catálogo', () {
    test('os componentes novos estão registrados como migrados', () {
      for (final String id in <String>[
        'app_entity_doc_panel',
        'app_docs_workspace',
      ]) {
        expect(
          flocksCatalog.any(
            (AppComponentMeta m) =>
                m.id == id && m.status == ComponentStatus.migrated,
          ),
          isTrue,
          reason: '$id fora do flocksCatalog',
        );
      }
    });
  });
}
