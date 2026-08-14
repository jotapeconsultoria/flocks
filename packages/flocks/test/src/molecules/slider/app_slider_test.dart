import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/semantics.dart' show SemanticsNode;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(
  Widget child, {
  TextDirection dir = TextDirection.ltr,
  bool reduceMotion = false,
}) => Directionality(
  textDirection: dir,
  child: MediaQuery(
    data: MediaQueryData(disableAnimations: reduceMotion),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: SizedBox(width: 200, child: child)),
    ),
  ),
);

void main() {
  testWidgets('tap na metade do trilho emite o valor do meio', (tester) async {
    double? emitted;
    await tester.pumpWidget(
      _host(
        AppSlider(
          value: 0,
          min: 0,
          max: 100,
          onChanged: (double v) => emitted = v,
        ),
      ),
    );
    await tester.tapAt(tester.getCenter(find.byType(AppSlider)));
    await tester.pump();
    expect(emitted, isNotNull);
    expect(emitted, closeTo(50, 3));
  });

  testWidgets('step quantiza a múltiplos a partir de min', (tester) async {
    final List<double> emitted = <double>[];
    await tester.pumpWidget(
      _host(
        AppSlider(value: 1, min: 1, max: 60, step: 1, onChanged: emitted.add),
      ),
    );
    await tester.tapAt(tester.getCenter(find.byType(AppSlider)));
    await tester.pump();
    expect(emitted, isNotEmpty);
    expect(emitted.last, emitted.last.roundToDouble());
    expect(emitted.last, inInclusiveRange(1, 60));
  });

  testWidgets('arraste emite onChanged contínuo e UM onChangeEnd', (
    tester,
  ) async {
    final List<double> changes = <double>[];
    final List<double> ends = <double>[];
    await tester.pumpWidget(
      _host(AppSlider(value: 0, onChanged: changes.add, onChangeEnd: ends.add)),
    );
    final Offset start = tester.getCenter(find.byType(AppSlider));
    final TestGesture gesture = await tester.startGesture(start);
    await gesture.moveBy(const Offset(30, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(30, 0));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(changes.length, greaterThanOrEqualTo(2));
    expect(ends.length, 1);
    expect(ends.single, changes.last);
  });

  testWidgets('valor nunca sai de [min, max]', (tester) async {
    final List<double> emitted = <double>[];
    await tester.pumpWidget(
      _host(AppSlider(value: 0.5, onChanged: emitted.add)),
    );
    final TestGesture g = await tester.startGesture(
      tester.getCenter(find.byType(AppSlider)),
    );
    await g.moveBy(const Offset(500, 0));
    await tester.pump();
    await g.up();
    await tester.pump();
    expect(emitted.every((double v) => v >= 0 && v <= 1), isTrue);
    expect(emitted.last, 1.0);
  });

  testWidgets('teclado: setas andam por passo, Home/End saltam, RTL espelha', (
    tester,
  ) async {
    final List<double> emitted = <double>[];
    final List<double> ends = <double>[];
    await tester.pumpWidget(
      _host(
        AppSlider(
          value: 30,
          min: 0,
          max: 60,
          step: 1,
          onChanged: emitted.add,
          onChangeEnd: ends.add,
        ),
      ),
    );
    // Sem WidgetsApp no host, Tab não vira traversal — foca o nó do slider
    // pelo contexto do polegar (descendente do Focus interno).
    Focus.of(
      tester.element(find.byType(AnimatedContainer).first),
    ).requestFocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(emitted.last, 31);
    expect(ends.last, 31, reason: 'passo de teclado também commita');

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(emitted.last, 29, reason: 'controlado: value continua 30 no host');

    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(emitted.last, 0);

    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
    expect(emitted.last, 60);

    // RTL: ArrowRight passa a DIMINUIR.
    emitted.clear();
    await tester.pumpWidget(
      _host(
        AppSlider(value: 30, min: 0, max: 60, step: 1, onChanged: emitted.add),
        dir: TextDirection.rtl,
      ),
    );
    Focus.of(
      tester.element(find.byType(AnimatedContainer).first),
    ).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(emitted.last, 29);
  });

  testWidgets('semântica: nó slider com value/increased/decreased e ações', (
    tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    final List<double> emitted = <double>[];
    await tester.pumpWidget(
      _host(
        AppSlider(
          value: 42,
          min: 1,
          max: 60,
          step: 1,
          semanticLabel: 'Ritmo de envio',
          formatValue: (double v) => '${v.round()}/min',
          onChanged: emitted.add,
        ),
      ),
    );
    final SemanticsNode node = tester.getSemantics(
      find.bySemanticsLabel('Ritmo de envio'),
    );
    expect(node.value, '42/min');
    expect(node.increasedValue, '43/min');
    expect(node.decreasedValue, '41/min');
    // As ações publicadas — o handler é o MESMO _step do teclado, que o teste
    // de setas já prova de ponta a ponta.
    expect(
      node,
      matchesSemantics(
        isSlider: true,
        isFocusable: true,
        hasFocusAction: true,
        hasIncreaseAction: true,
        hasDecreaseAction: true,
        // O framework publica os scrolls implícitos de um nó ajustável.
        hasScrollLeftAction: true,
        hasScrollRightAction: true,
        hasScrollUpAction: true,
        hasScrollDownAction: true,
        hasEnabledState: true,
        isEnabled: true,
        label: 'Ritmo de envio',
        value: '42/min',
        increasedValue: '43/min',
        decreasedValue: '41/min',
      ),
    );
    expect(emitted, isEmpty, reason: 'nada disparou ainda — só publicação');
    handle.dispose();
  });

  testWidgets('desabilitado mantém o nó com enabled false e gesto inerte', (
    tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        const AppSlider(value: 0.5, onChanged: null, semanticLabel: 'Volume'),
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Volume')),
      matchesSemantics(
        hasEnabledState: true,
        isEnabled: false,
        isSlider: true,
        label: 'Volume',
        value: '0.5',
      ),
    );

    await tester.tapAt(tester.getCenter(find.byType(AppSlider)));
    await tester.pump();
    expect(tester.takeException(), isNull);
    handle.dispose();
  });

  testWidgets('RTL: tap perto da borda esquerda dá valor ALTO', (tester) async {
    double? emitted;
    await tester.pumpWidget(
      _host(
        AppSlider(
          value: 0,
          min: 0,
          max: 100,
          onChanged: (double v) => emitted = v,
        ),
        dir: TextDirection.rtl,
      ),
    );
    final Rect rect = tester.getRect(find.byType(AppSlider));
    await tester.tapAt(Offset(rect.left + 10, rect.center.dy));
    await tester.pump();
    expect(emitted, greaterThan(80));
  });

  testWidgets('alvo de toque: o widget mede >= 48 de altura', (tester) async {
    await tester.pumpWidget(_host(AppSlider(value: 0.5, onChanged: (_) {})));
    expect(
      tester.getSize(find.byType(AppSlider)).height,
      greaterThanOrEqualTo(48),
    );
  });

  testWidgets('showValue exibe o rótulo formatado, fora da semântica', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppSlider(
          value: 42,
          min: 1,
          max: 60,
          showValue: true,
          formatValue: (double v) => '${v.round()}/min',
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.text('42/min'), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('42/min'),
        matching: find.byType(ExcludeSemantics),
      ),
      findsWidgets,
    );
  });

  testWidgets('reduce-motion: o crescimento do polegar colapsa', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(AppSlider(value: 0.5, onChanged: (_) {}), reduceMotion: true),
    );
    final TestGesture g = await tester.startGesture(
      tester.getCenter(find.byType(AppSlider)),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    await g.up();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  test('AppSlider está no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_slider' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
