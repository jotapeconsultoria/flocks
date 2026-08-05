import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {MediaQueryData? media}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: media ?? const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (_) => Center(child: child)),
        ],
      ),
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

AppInteraction _target(WidgetTester tester) =>
    tester.widget<AppInteraction>(find.byType(AppInteraction));

/// O painter do tique — `progress` é a fração do traço desenhada.
AppCheckmarkPainter? _painter(WidgetTester tester) => tester
    .widgetList<CustomPaint>(find.byType(CustomPaint))
    .map((CustomPaint c) => c.painter)
    .whereType<AppCheckmarkPainter>()
    .firstOrNull;

void main() {
  group('AppCopyButton', () {
    testWidgets('copia o valor e dispara onCopied', (
      WidgetTester tester,
    ) async {
      final List<String> written = _spyClipboard(tester);
      int copies = 0;

      await tester.pumpWidget(
        _host(
          AppCopyButton(onCopied: () => copies++, value: '860123456789012'),
        ),
      );

      await tester.tap(find.byType(AppCopyButton));
      await tester.pump();

      expect(written, <String>['860123456789012']);
      expect(copies, 1);
    });

    testWidgets('tooltip e rótulo viram "Copiado!" e voltam sozinhos', (
      WidgetTester tester,
    ) async {
      _spyClipboard(tester);

      await tester.pumpWidget(_host(const AppCopyButton(value: 'abc')));

      expect(_target(tester).tooltip, 'Copiar');
      expect(_target(tester).semanticLabel, 'Copiar');

      await tester.tap(find.byType(AppCopyButton));
      await tester.pump();

      expect(_target(tester).tooltip, 'Copiado!');
      expect(_target(tester).semanticLabel, 'Copiado!');

      await tester.pump(kAppCopiedFeedback);
      await tester.pumpAndSettle();

      expect(_target(tester).tooltip, 'Copiar');
      expect(_target(tester).semanticLabel, 'Copiar');
    });

    testWidgets('o tique é DESENHADO, não é um ícone de rede', (
      WidgetTester tester,
    ) async {
      _spyClipboard(tester);

      await tester.pumpWidget(_host(const AppCopyButton(value: 'abc')));

      // Trava a regressão que motivou a mudança: com `AppIcons.check` a
      // confirmação dependia de um download, e um `SvgPicture` que falha nunca
      // retenta — a falha virava um erro visual permanente. O único AppIcon
      // aqui é o de copiar; o tique sai do AppCheckmarkPainter.
      expect(find.byType(AppIcon), findsOneWidget);
      expect(_painter(tester), isNotNull);

      await tester.tap(find.byType(AppCopyButton));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(AppIcon), findsOneWidget);
      // Copiado: o traço está inteiro.
      expect(_painter(tester)!.progress, 1.0);
    });

    testWidgets('em repouso o traço do tique não é desenhado', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const AppCopyButton(value: 'abc')));

      expect(_painter(tester)!.progress, 0.0);
    });

    testWidgets('sob reduce-motion o tique salta para o traço completo', (
      WidgetTester tester,
    ) async {
      _spyClipboard(tester);

      await tester.pumpWidget(
        _host(
          const AppCopyButton(value: 'abc'),
          media: const MediaQueryData(disableAnimations: true),
        ),
      );

      await tester.tap(find.byType(AppCopyButton));
      await tester.pump();

      // Sem animação: nada de traço pela metade num frame intermediário.
      expect(_painter(tester)!.progress, 1.0);
    });

    testWidgets('enabled: false não copia', (WidgetTester tester) async {
      final List<String> written = _spyClipboard(tester);

      await tester.pumpWidget(
        _host(const AppCopyButton(enabled: false, value: 'abc')),
      );

      await tester.tap(find.byType(AppCopyButton), warnIfMissed: false);
      await tester.pump();

      expect(written, isEmpty);
    });

    testWidgets('falha ao copiar NÃO confirma e não vaza exceção', (
      WidgetTester tester,
    ) async {
      // No navegador, `navigator.clipboard.writeText` rejeita sem gesto do
      // usuário / com permissão negada, e o Flutter transforma isso num
      // PlatformException. Confirmar mesmo assim seria mentir para quem vai
      // colar em outro lugar.
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall call) async {
          if (call.method == 'Clipboard.setData') {
            throw PlatformException(code: 'copy_fail');
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

      Object? failure;
      int copies = 0;

      await tester.pumpWidget(
        _host(
          AppCopyButton(
            onCopied: () => copies++,
            onCopyFailed: (Object e) => failure = e,
            value: 'abc',
          ),
        ),
      );

      await tester.tap(find.byType(AppCopyButton));
      await tester.pump();

      expect(failure, isA<PlatformException>());
      expect(copies, 0);
      // Segue dizendo "Copiar": sem cópia, sem confirmação.
      expect(_target(tester).tooltip, 'Copiar');
      expect(tester.takeException(), isNull);
    });

    testWidgets('descartar durante o feedback não deixa timer pendente', (
      WidgetTester tester,
    ) async {
      _spyClipboard(tester);

      await tester.pumpWidget(_host(const AppCopyButton(value: 'abc')));
      await tester.tap(find.byType(AppCopyButton));
      await tester.pump();

      // Sem o cancel no dispose, o flutter_test falharia aqui com um Timer
      // pendente ao fim do teste.
      await tester.pumpWidget(_host(const SizedBox.shrink()));
      await tester.pump();
    });

    test('está registrado no catálogo como migrado', () {
      expect(
        flocksCatalog.any(
          (AppComponentMeta m) =>
              m.id == 'app_copy_button' && m.status == ComponentStatus.migrated,
        ),
        isTrue,
      );
    });
  });
}
