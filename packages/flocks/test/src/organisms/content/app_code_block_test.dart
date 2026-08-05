import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {AppThemeData? theme}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(size: Size(800, 600)),
    child: AppTheme(
      data: theme ?? AppThemeData.light,
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

/// Intercepta o canal de plataforma do clipboard e guarda o que foi escrito.
///
/// `Clipboard.setData` vai por `SystemChannels.platform`, que no sandbox de
/// teste não tem receptor — sem o mock a chamada fica pendente e o `await` do
/// componente nunca resolve.
List<String> _spyClipboard(WidgetTester tester) {
  final List<String> written = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (MethodCall call) async {
      if (call.method == 'Clipboard.setData') {
        written.add(
          (call.arguments as Map<Object?, Object?>)['text']! as String,
        );
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
  return written;
}

void main() {
  group('AppCodeBlock', () {
    testWidgets('mostra o código e o rótulo da linguagem', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppCodeBlock(code: '{"a": 1}', language: 'json')),
      );

      expect(find.text('{"a": 1}'), findsOneWidget);
      expect(find.text('json'), findsOneWidget);
    });

    testWidgets('sem linguagem e sem copiar não desenha cabeçalho', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppCodeBlock(code: 'só o corpo', showCopy: false)),
      );

      expect(find.byType(AppIcon), findsNothing);
      expect(find.text('só o corpo'), findsOneWidget);
    });

    testWidgets('copiar escreve no clipboard e volta ao estado normal', (
      WidgetTester tester,
    ) async {
      final List<String> written = _spyClipboard(tester);
      int copies = 0;

      await tester.pumpWidget(
        _host(
          AppCodeBlock(
            code: 'curl -X GET /devices',
            language: 'bash',
            onCopy: () => copies++,
          ),
        ),
      );

      await tester.tap(find.byType(AppCopyButton));
      await tester.pump();

      expect(written, <String>['curl -X GET /devices']);
      expect(copies, 1);

      // Enquanto o feedback dura, o tooltip é o de "copiado".
      expect(
        tester.widget<AppInteraction>(find.byType(AppInteraction)).tooltip,
        'Copiado!',
      );

      await tester.pump(kAppCopiedFeedback);
      await tester.pumpAndSettle();

      expect(
        tester.widget<AppInteraction>(find.byType(AppInteraction)).tooltip,
        'Copiar',
      );
    });

    testWidgets('sem wrap rola na horizontal; com wrap não', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppCodeBlock(code: 'linha muito longa', showCopy: false)),
      );
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      await tester.pumpWidget(
        _host(
          const AppCodeBlock(
            code: 'linha muito longa',
            showCopy: false,
            wrap: true,
          ),
        ),
      );
      expect(find.byType(SingleChildScrollView), findsNothing);
    });

    test('está registrado no catálogo como migrado', () {
      expect(
        flocksCatalog.any(
          (AppComponentMeta m) =>
              m.id == 'app_code_block' && m.status == ComponentStatus.migrated,
        ),
        isTrue,
      );
    });
  });
}
