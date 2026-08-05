import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Overlay(
        initialEntries: [OverlayEntry(builder: (_) => Center(child: child))],
      ),
    ),
  ),
);

/// Host que reproduz o cenário do Widgetbook: o `AppTheme` é injetado ABAIXO do
/// `Overlay` (dentro de uma entry), então a entry do tooltip — irmã, inserida no
/// mesmo Overlay — NÃO herda o tema por contexto. O tooltip precisa capturar e
/// reprovê-lo. Sem o fix, isto estoura "No AppTheme found in context".
Widget _hostThemeBelowOverlay(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (_) => AppTheme(
            data: AppThemeData.light,
            child: Center(child: child),
          ),
        ),
      ],
    ),
  ),
);

/// Como [_hostThemeBelowOverlay], mas com um text scale abaixo do Overlay — a
/// entry irmã do balão só o reflete se o tooltip o reprovê (via AppOverlayScope).
Widget _hostScaledBelowOverlay(Widget child, double scale) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (_) => MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: AppTheme(
              data: AppThemeData.light,
              child: Center(child: child),
            ),
          ),
        ),
      ],
    ),
  ),
);

void main() {
  testWidgets('o balão reflete o text scale', (tester) async {
    await tester.pumpWidget(
      _hostScaledBelowOverlay(
        const AppTooltip(
          message: 'Ajuda',
          child: SizedBox(width: 40, height: 40),
        ),
        2.0,
      ),
    );
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
    await tester.pumpAndSettle();

    // O balão (entry irmã) só vê o scale 2.0 porque o tooltip o reprovê.
    expect(
      MediaQuery.textScalerOf(tester.element(find.text('Ajuda'))),
      const TextScaler.linear(2.0),
    );
  });

  testWidgets('hover mostra e esconde o tooltip', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppTooltip(
          message: 'Ajuda',
          child: SizedBox(width: 40, height: 40),
        ),
      ),
    );
    expect(find.text('Ajuda'), findsNothing);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
    await tester.pumpAndSettle();
    expect(find.text('Ajuda'), findsOneWidget);

    await gesture.moveTo(const Offset(-100, -100));
    await tester.pumpAndSettle();
    expect(find.text('Ajuda'), findsNothing);
  });

  testWidgets('funciona com o tema abaixo do Overlay (cenário Widgetbook)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _hostThemeBelowOverlay(
        const AppTooltip(
          message: 'Ajuda',
          child: SizedBox(width: 40, height: 40),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
    await tester.pumpAndSettle();

    // Sem o fix, o build da entry estouraria "No AppTheme found in context".
    expect(tester.takeException(), isNull);
    expect(find.text('Ajuda'), findsOneWidget);
  });

  testWidgets('maxWidth restringe a largura do balão', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppTooltip(
          message: 'Um texto longo que precisa quebrar em várias linhas',
          maxWidth: 120,
          child: SizedBox(width: 40, height: 40),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
    await tester.pumpAndSettle();

    final constrained = tester
        .widgetList<ConstrainedBox>(find.byType(ConstrainedBox))
        .where((c) => c.constraints.maxWidth == 120);
    expect(constrained, isNotEmpty);
  });

  testWidgets('mantém margem mínima das bordas da viewport', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(320, 568)),
          child: AppTheme(
            data: AppThemeData.light,
            child: Overlay(
              initialEntries: <OverlayEntry>[
                OverlayEntry(
                  builder: (context) => const Align(
                    alignment: Alignment.centerLeft,
                    child: AppTooltip(
                      message: 'Anexar arquivo',
                      position: AppTooltipPosition.left,
                      child: SizedBox(height: 40, width: 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
    await tester.pumpAndSettle();

    final tooltipRect = tester.getRect(
      find.byKey(const ValueKey<String>('app-tooltip-viewport-bounds')),
    );
    expect(tooltipRect.left, greaterThanOrEqualTo(24));
    expect(tooltipRect.right, lessThanOrEqualTo(296));
  });

  testWidgets('mantém texto longo dentro da borda direita no celular', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 568),
            viewPadding: EdgeInsets.only(top: 44, bottom: 34),
          ),
          child: AppTheme(
            data: AppThemeData.light,
            child: Overlay(
              initialEntries: <OverlayEntry>[
                OverlayEntry(
                  builder: (context) => const Align(
                    alignment: Alignment.topRight,
                    child: AppTooltip(
                      message: 'Informações da conversa e do modelo atual',
                      position: AppTooltipPosition.right,
                      child: SizedBox(height: 40, width: 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.longPressAt(tester.getCenter(find.byType(SizedBox)));
    await tester.pumpAndSettle();

    final tooltipRect = tester.getRect(
      find.byKey(const ValueKey<String>('app-tooltip-viewport-bounds')),
    );
    expect(tooltipRect.left, greaterThanOrEqualTo(24));
    expect(tooltipRect.right, lessThanOrEqualTo(296));
    expect(tooltipRect.top, greaterThanOrEqualTo(68));
  });

  testWidgets('toque prolongado mostra o tooltip no celular', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppTooltip(
          message: 'Ajuda',
          child: SizedBox(width: 40, height: 40),
        ),
      ),
    );

    await tester.longPressAt(tester.getCenter(find.byType(SizedBox)));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Ajuda'), findsOneWidget);
  });

  testWidgets('trocar a mensagem com o balão aberto faz cross-fade', (
    tester,
  ) async {
    final message = ValueNotifier<String>('Copiar');
    addTearDown(message.dispose);

    await tester.pumpWidget(
      _host(
        ValueListenableBuilder<String>(
          valueListenable: message,
          builder: (BuildContext context, String m, Widget? _) => AppTooltip(
            message: m,
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
    await tester.pumpAndSettle();
    expect(find.text('Copiar'), findsOneWidget);

    message.value = 'Copiado!';
    // Dois pumps: o `didUpdateWidget` agenda o `markNeedsBuild` da entry num
    // post-frame callback, então a entry só reconstrói no frame seguinte.
    await tester.pump();
    await tester.pump();

    // No meio da transição os dois textos coexistem — é o cross-fade.
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Copiar'), findsOneWidget);
    expect(find.text('Copiado!'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Copiar'), findsNothing);
    expect(find.text('Copiado!'), findsOneWidget);
  });

  testWidgets('mensagem que CRESCE perto da borda continua na viewport', (
    tester,
  ) async {
    // O cross-fade dimensiona pelo maior filho já no primeiro frame da troca,
    // então a correção de viewport (que só reprograma a partir do `build`)
    // enxerga o tamanho final. Um `AnimatedSize` aqui mediria o tamanho ANTIGO
    // e o balão vazaria para fora da tela ao crescer.
    final message = ValueNotifier<String>('Ok');
    addTearDown(message.dispose);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(320, 568)),
          child: AppTheme(
            data: AppThemeData.light,
            child: Overlay(
              initialEntries: <OverlayEntry>[
                OverlayEntry(
                  builder: (context) => Align(
                    alignment: Alignment.centerRight,
                    child: ValueListenableBuilder<String>(
                      valueListenable: message,
                      builder: (BuildContext context, String m, Widget? _) =>
                          AppTooltip(
                            message: m,
                            child: const SizedBox(height: 40, width: 40),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
    await tester.pumpAndSettle();

    message.value = 'Copiado para a área de transferência!';
    await tester.pump();
    await tester.pumpAndSettle();

    final rect = tester.getRect(
      find.byKey(const ValueKey<String>('app-tooltip-viewport-bounds')),
    );
    expect(rect.left, greaterThanOrEqualTo(24));
    expect(rect.right, lessThanOrEqualTo(296));
  });

  test('está no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_tooltip' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
