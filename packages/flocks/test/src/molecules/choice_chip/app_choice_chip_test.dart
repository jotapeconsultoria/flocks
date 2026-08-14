import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/semantics.dart' show SemanticsNode;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {double? width, double textScale = 1.0}) =>
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: AppTheme(
          data: AppThemeData.light,
          child: Center(
            child: width == null ? child : SizedBox(width: width, child: child),
          ),
        ),
      ),
    );

AppColorTheme get _colors => AppThemeData.light.colorTheme;

void main() {
  testWidgets('renderiza rótulo e contador; count null sem pílula', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppChoiceChip(
          label: 'Novos',
          count: 8,
          selected: false,
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.text('Novos'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);

    await tester.pumpWidget(
      _host(AppChoiceChip(label: 'Novos', selected: false, onChanged: (_) {})),
    );
    expect(find.text('8'), findsNothing);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('count 0 renderiza "0" — quem esconde o zero é o chamador', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppChoiceChip(
          label: 'Novos',
          count: 0,
          selected: false,
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('selecionado usa EXATAMENTE o resolvedor do segmented', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(AppChoiceChip(label: 'Novos', selected: true, onChanged: (_) {})),
    );
    // Comparação contra o RETORNO da função, nunca literal — anti-deriva.
    final ButtonColors sel = appFilledButtonColors(
      _colors,
      AppButtonColor.primary.role(_colors),
      AppButtonColor.primary.onRole(_colors),
      hovered: false,
      pressed: false,
      disabled: false,
    );
    final AnimatedContainer box = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    final BoxDecoration deco = box.decoration! as BoxDecoration;
    expect(deco.color, sel.background);

    final AppText label = tester.widget<AppText>(
      find.widgetWithText(AppText, 'Novos'),
    );
    expect(label.style?.color, sel.foreground);
    expect(label.style?.fontWeight, FontWeight.w700);
  });

  testWidgets('não-selecionado: container do eixo e peso w500', (tester) async {
    await tester.pumpWidget(
      _host(AppChoiceChip(label: 'Novos', selected: false, onChanged: (_) {})),
    );
    final AppText label = tester.widget<AppText>(
      find.widgetWithText(AppText, 'Novos'),
    );
    expect(label.style?.fontWeight, FontWeight.w500);
    expect(label.style?.color, _colors.onSurface);

    final AnimatedContainer box = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    expect(
      (box.decoration! as BoxDecoration).color,
      _colors.surfaceContainer,
      reason: 'filled default: surfaceContainer',
    );
  });

  testWidgets('outlined: a borda do selecionado é a cor do próprio fill', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppChoiceChip(
          label: 'Novos',
          selected: true,
          style: AppStyle.outlined,
          onChanged: (_) {},
        ),
      ),
    );
    final AnimatedContainer box = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    final BoxDecoration deco = box.decoration! as BoxDecoration;
    expect((deco.border! as Border).top.color, deco.color);
  });

  testWidgets('onChanged recebe o valor NOVO; desabilitado não dispara', (
    tester,
  ) async {
    final List<bool> received = <bool>[];
    await tester.pumpWidget(
      _host(
        AppChoiceChip(label: 'Novos', selected: false, onChanged: received.add),
      ),
    );
    await tester.tap(find.text('Novos'));
    await tester.pump();
    expect(received, <bool>[true]);

    await tester.pumpWidget(
      _host(
        AppChoiceChip(
          label: 'Novos',
          selected: false,
          enabled: false,
          onChanged: received.add,
        ),
      ),
    );
    await tester.tap(find.text('Novos'), warnIfMissed: false);
    await tester.pump();
    expect(received, <bool>[true], reason: 'enabled: false não dispara');
  });

  testWidgets('semântica: toggle com checked e grupo exclusivo', (
    tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppChoiceChip(
          label: 'Novos',
          count: 8,
          selected: true,
          onChanged: (_) {},
        ),
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Novos (8)')),
      isSemantics(
        label: 'Novos (8)',
        hasCheckedState: true,
        isChecked: true,
        isInMutuallyExclusiveGroup: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('mutuallyExclusive false tira o grupo; semanticLabel vence', (
    tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppChoiceChip(
          label: 'Novos',
          count: 8,
          selected: false,
          mutuallyExclusive: false,
          semanticLabel: 'Novos, 8 conversas na fila',
          onChanged: (_) {},
        ),
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Novos, 8 conversas na fila')),
      isSemantics(
        label: 'Novos, 8 conversas na fila',
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('raio: default pílula; reto zera chip E pílula do count', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppChoiceChip(
          label: 'Novos',
          count: 8,
          selected: false,
          radiusMode: AppRadiusMode.reto,
          onChanged: (_) {},
        ),
      ),
    );
    final AnimatedContainer chip = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    expect((chip.decoration! as BoxDecoration).borderRadius, BorderRadius.zero);
    final DecoratedBox pill = tester.widget<DecoratedBox>(
      find
          .ancestor(of: find.text('8'), matching: find.byType(DecoratedBox))
          .first,
    );
    expect((pill.decoration as BoxDecoration).borderRadius, BorderRadius.zero);
  });

  testWidgets('rótulo de 200 chars em 120px: 1 linha, sem estouro', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppChoiceChip(label: 'x' * 200, selected: false, onChanged: (_) {}),
        width: 120,
      ),
    );
    expect(tester.takeException(), isNull);
    final AppText label = tester.widget<AppText>(find.byType(AppText).first);
    expect(label.maxLines, 1);
    expect(label.overflow, TextOverflow.ellipsis);
  });

  testWidgets('text-scale 2.0: o chip CRESCE em vez de cortar', (tester) async {
    await tester.pumpWidget(
      _host(
        AppChoiceChip(label: 'Novos', selected: false, onChanged: (_) {}),
        textScale: 2.0,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(AppChoiceChip)).height,
      greaterThan(kAppChoiceChipMinHeight),
    );
  });

  testWidgets('altura mínima 40 com texto padrão', (tester) async {
    await tester.pumpWidget(
      _host(AppChoiceChip(label: 'N', selected: false, onChanged: (_) {})),
    );
    expect(
      tester.getSize(find.byType(AppChoiceChip)).height,
      greaterThanOrEqualTo(kAppChoiceChipMinHeight),
    );
  });

  testWidgets('tooltip chega ao nó semântico, não só ao pixel', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppChoiceChip(
          label: 'IA',
          selected: true,
          tooltip: 'IA respondendo',
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.byType(AppTooltip), findsOneWidget);
    // A dica existe como nó semântico (Semantics.tooltip), não só no pixel —
    // varredura da árvore, o molde do app_tooltip_semantics_test.
    final List<String> tooltips = <String>[];
    void walk(SemanticsNode n) {
      tooltips.add(n.getSemanticsData().tooltip);
      n.visitChildren((SemanticsNode c) {
        walk(c);
        return true;
      });
    }

    walk(tester.binding.rootElement!.renderObject!.debugSemantics!);
    expect(tooltips, contains('IA respondendo'));
    handle.dispose();
  });

  test('AppChoiceChip e AppChoiceChipBar no catálogo como migrated', () {
    for (final String id in <String>[
      'app_choice_chip',
      'app_choice_chip_bar',
    ]) {
      expect(
        flocksCatalog.any(
          (AppComponentMeta m) =>
              m.id == id && m.status == ComponentStatus.migrated,
        ),
        isTrue,
        reason: '$id deve estar migrated',
      );
    }
  });
}
