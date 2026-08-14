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

  // Regressão da revisão adversarial: emitir no pointer-down (pré-arena)
  // fazia uma tentativa de ROLAGEM mudar e persistir o valor.
  testWidgets('rolar a página por cima do slider NÃO muda o valor', (
    tester,
  ) async {
    final List<double> changes = <double>[];
    final List<double> ends = <double>[];
    final ScrollController scroll = ScrollController();
    addTearDown(scroll.dispose);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: AppTheme(
            data: AppThemeData.light,
            child: ListView(
              controller: scroll,
              children: <Widget>[
                const SizedBox(height: 40),
                AppSlider(
                  value: 5,
                  min: 1,
                  max: 60,
                  step: 1,
                  onChanged: changes.add,
                  onChangeEnd: ends.add,
                ),
                const SizedBox(height: 1200),
              ],
            ),
          ),
        ),
      ),
    );

    // Dedo desce SOBRE o slider e arrasta na vertical, em passos pequenos —
    // o scrollable vence a arena.
    final TestGesture g = await tester.startGesture(
      tester.getCenter(find.byType(AppSlider)),
    );
    for (int i = 0; i < 10; i++) {
      await g.moveBy(const Offset(0, -10));
      await tester.pump();
    }
    await g.up();
    await tester.pump();

    expect(scroll.offset, greaterThan(0), reason: 'a página rolou');
    expect(changes, isEmpty, reason: 'rolagem não é ajuste de valor');
    expect(ends, isEmpty, reason: 'nada foi persistido pelo acidente');
  });

  testWidgets('End salta para o max EXATO mesmo com step não múltiplo', (
    tester,
  ) async {
    final List<double> emitted = <double>[];
    await tester.pumpWidget(
      _host(
        AppSlider(value: 0, min: 0, max: 10, step: 3, onChanged: emitted.add),
      ),
    );
    Focus.of(
      tester.element(find.byType(AnimatedContainer).first),
    ).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
    // Quantizado seria 9 (0 + 3·3); a promessa é o extremo exato.
    expect(emitted.last, 10);
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

  // O par abaixo é uma coisa só, e por isso são dois testes e não um: medir o
  // polegar SÓ sob reduce-motion não distingue "colapsou a duração" de "nunca
  // animou". O contraste é a prova — no primeiro frame do arrasto o polegar já
  // está no tamanho final com reduce-motion, e ainda NÃO está sem ele.
  //
  // Isto substitui um teste de mesmo nome cujo corpo assertava apenas
  // `takeException(), isNull`: ele passaria com o AnimatedContainer removido,
  // com a duração chumbada e com o polegar sem crescer — ausência de ofensor
  // não é presença de efeito.
  const double kLado = AppSizes.s16; // thumbSize default
  const double kLadoArrastando = kLado + 4; // o crescimento do _dragging

  testWidgets('reduce-motion: o polegar chega ao tamanho final em 1 frame', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(AppSlider(value: 0.5, onChanged: (_) {}), reduceMotion: true),
    );
    expect(tester.getSize(find.byType(AnimatedContainer)).width, kLado);

    final TestGesture g = await tester.startGesture(
      tester.getCenter(find.byType(AppSlider)),
    );
    // MOVER além do kTouchSlop, e não só tocar: depois do conserto de arena o
    // polegar só cresce quando o arrasto VENCE a arena (onPanStart) — um toque
    // parado, ou um movimento dentro do slop, não abre o gesto.
    await g.moveBy(const Offset(40, 0));
    // UM frame: sem interpolação, o tamanho novo já está aqui.
    await tester.pump();
    expect(
      tester.getSize(find.byType(AnimatedContainer)).width,
      kLadoArrastando,
    );
    expect(
      tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).duration,
      Duration.zero,
      reason: 'AppMotion.resolve tem de colapsar a duração, não encurtá-la',
    );

    await g.up();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'sem reduce-motion: o mesmo frame ainda está no meio do caminho',
    (tester) async {
      await tester.pumpWidget(_host(AppSlider(value: 0.5, onChanged: (_) {})));
      final TestGesture g = await tester.startGesture(
        tester.getCenter(find.byType(AppSlider)),
      );
      await g.moveBy(const Offset(40, 0));
      await tester.pump();
      final double noPrimeiroFrame = tester
          .getSize(find.byType(AnimatedContainer))
          .width;
      expect(
        noPrimeiroFrame,
        lessThan(kLadoArrastando),
        reason:
            'com motion ligado o polegar interpola; se já chegou, não animou',
      );
      expect(
        tester
            .widget<AnimatedContainer>(find.byType(AnimatedContainer))
            .duration,
        greaterThan(Duration.zero),
      );

      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(AnimatedContainer)).width,
        kLadoArrastando,
      );

      await g.up();
      await tester.pumpAndSettle();
    },
  );

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
