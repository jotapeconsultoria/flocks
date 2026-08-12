import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../icons/icons.dart';
import '../texts/texts.dart';
import 'app_step_data.dart';

/// Tamanho do círculo indicador de passo.
const appStepperCircleSize = 36.0;

/// Tamanho mínimo da linha de conexão entre passos.
const appStepperMinLineLength = 64.0;

const _lineThickness = 2.0;

/// Estado visual de um passo no stepper.
enum _StepState { completed, active, upcoming }

/// Cor do passo ALCANÇADO (ativo/concluído), visível na superfície: base no
/// claro; tom claro (`primary.s400`) no escuro — a base fica escura demais p/
/// contrastar com a superfície escura (mesma lógica do `focusRing`). Delega ao
/// acento canônico [AppColorTheme.primaryAccent].
Color _reachedAccent(AppThemeData theme) => theme.colorTheme.primaryAccent(
  isDark: theme.brightness == AppBrightness.dark,
);

/// Rótulo de acessibilidade de um passo.
String _stepSemanticsLabel(
  int index,
  AppStepData data,
  _StepState state, {
  required bool tappable,
}) {
  final statusText = switch (state) {
    _StepState.completed => 'concluído',
    _StepState.active => 'atual',
    _StepState.upcoming => 'pendente',
  };
  final base = 'Passo ${index + 1}: ${data.title}, $statusText';
  return tappable ? '$base. Toque para ir a este passo' : base;
}

/// Indicador visual de progresso em etapas com suporte a orientação
/// horizontal e vertical.
///
/// Exibe círculos numerados ou com ícone de check para passos completos,
/// conectados por linhas de progresso animadas (via [AppMotion], respeitando
/// reduce-motion). Passos completos podem ser tocados para voltar.
///
/// Exemplo:
/// ```dart
/// AppStepper(
///   currentStep: 1,
///   steps: [
///     AppStepData(title: 'Dados'),
///     AppStepData(title: 'Trigger'),
///     AppStepData(title: 'Acoes'),
///   ],
/// )
/// ```
final class AppStepper extends StatelessWidget {
  const AppStepper({
    required this.currentStep,
    required this.steps,
    this.activeColor,
    this.axis = Axis.horizontal,
    this.completedColor,
    this.onStepTapped,
    this.allStepsTappable = false,
    this.labelTappable = false,
    this.showLabels = true,
    this.upcomingColor,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  }) : assert(
         currentStep >= 0 && currentStep < steps.length,
         'currentStep deve estar entre 0 e steps.length - 1',
       );

  /// Cor do passo ativo. Padrão: `theme.colorTheme.primary`.
  final Color? activeColor;

  /// Orientação do indicador.
  final Axis axis;

  /// Cor dos passos completos. Padrão: `theme.colorTheme.primary`.
  final Color? completedColor;

  /// Passo atual (0-indexed).
  final int currentStep;

  /// Callback ao tocar em um passo. Recebe o índice tocado. Se `null`, nenhum
  /// passo é tocável. Quais passos respondem depende de [allStepsTappable].
  final ValueChanged<int>? onStepTapped;

  /// Se `true`, TODOS os passos são tocáveis (tendo passado por eles ou não),
  /// desde que [onStepTapped] seja fornecido. Se `false` (padrão), apenas os
  /// passos concluídos respondem ao toque.
  final bool allStepsTappable;

  /// Se `true`, o rótulo (título/subtítulo) faz parte do alvo do passo: clicar
  /// nele toca o passo e o hover ativa o anel de foco no círculo. Se `false`
  /// (padrão), apenas o círculo é o alvo.
  final bool labelTappable;

  /// Se deve exibir os labels (título/subtítulo).
  final bool showLabels;

  /// Dados dos passos.
  final List<AppStepData> steps;

  /// Cor dos passos futuros. Padrão: `theme.colorTheme.neutralPrimary.s100`.
  final Color? upcomingColor;

  /// Tratamento de container (borda/fundo/sombra) do eixo global [AppStyle]
  /// aplicado a cada círculo de passo. `null` (default) segue o global
  /// `theme.styleTheme.style`. Aditivo sobre o fill semântico do estado:
  /// alcançado = `primary`; futuro = superfície (`neutralPrimary.s200` em
  /// `filled`/`elevated`, ghost transparente em `outlined`).
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste stepper (vence o global
  /// `theme.radiusTheme.mode`). Default do componente: [AppRadiusMode.redondo].
  final AppRadiusMode? radiusMode;

  /// Override cru do raio dos círculos — vence [radiusMode] e o global.
  final BorderRadius? radius;

  _StepState _stepState(int index) {
    if (index < currentStep) return _StepState.completed;
    if (index == currentStep) return _StepState.active;
    return _StepState.upcoming;
  }

  bool _isTappable(_StepState state) =>
      onStepTapped != null &&
      (allStepsTappable || state == _StepState.completed);

  /// Envolve [builder] com a interação do passo [index]: foco/hover/press +
  /// teclado (Tab, Enter/Space) + semântica, via [FlocksInteraction]. [builder]
  /// recebe `highlighted` (foco OU hover, p/ o anel) e `pressed` (clique, p/ o
  /// overlay + escala no círculo).
  Widget _wrapStep(
    int index, {
    required Widget Function(bool highlighted, bool pressed) builder,
  }) {
    final state = _stepState(index);
    final tappable = _isTappable(state);
    final label = _stepSemanticsLabel(
      index,
      steps[index],
      state,
      tappable: tappable,
    );
    if (!tappable) {
      return AppSemantics.label(label: label, child: builder(false, false));
    }
    return AppSemantics.button(
      label: label,
      onTap: () => onStepTapped!(index),
      child: FlocksInteraction(
        onPressed: () => onStepTapped!(index),
        builder: (context, states) => builder(
          states.contains(WidgetState.focused) ||
              states.contains(WidgetState.hovered),
          states.contains(WidgetState.pressed),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return axis == Axis.horizontal
        ? _buildHorizontal(context)
        : _buildVertical(context);
  }

  /// Horizontal: cada passo ocupa uma célula [Expanded] de largura igual. A
  /// linha é dividida em duas metades (esquerda/direita) DENTRO da célula, então
  /// sempre encosta no círculo — independentemente da largura do label, que fica
  /// centralizado abaixo, limitado à célula (elipsa se longo). Círculos ficam
  /// distribuídos uniformemente.
  Widget _buildHorizontal(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Expanded(child: _horizontalCell(i)),
      ],
    );
  }

  Widget _horizontalCell(int i) {
    // A cor da metade de linha segue o passo em que ela CHEGA. O
    // `CrossAxisAlignment.center` da Row centraliza a linha (2px) no círculo.
    Widget halfLine(int arrivalIndex, {required bool visible}) => Expanded(
      child: visible
          ? _StepLine(
              state: _stepState(arrivalIndex),
              axis: axis,
              activeColor: activeColor,
              completedColor: completedColor,
              upcomingColor: upcomingColor,
            )
          : const SizedBox.shrink(),
    );
    _StepCircle circle(bool h, bool p) => _StepCircle(
      data: steps[i],
      index: i,
      state: _stepState(i),
      highlighted: h,
      pressed: p,
      activeColor: activeColor,
      completedColor: completedColor,
      upcomingColor: upcomingColor,
      style: style,
      radiusMode: radiusMode,
      radius: radius,
    );
    Widget circleRow(Widget node) => Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        halfLine(i, visible: i > 0),
        node,
        halfLine(i + 1, visible: i < steps.length - 1),
      ],
    );
    final labelWidget = _StepLabel(
      data: steps[i],
      state: _stepState(i),
      axis: axis,
    );
    // Quando o rótulo é parte do alvo (labelTappable) ele não deve capturar o
    // ponteiro — senão selecionava o texto em vez de tocar o passo.
    final label = labelTappable
        ? IgnorePointer(child: labelWidget)
        : labelWidget;

    // labelTappable: a célula inteira (círculo + label) é o alvo, com o anel no
    // círculo. Senão, só o círculo é o alvo e o label fica estático.
    if (labelTappable) {
      return _wrapStep(
        i,
        builder: (h, p) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            circleRow(circle(h, p)),
            if (showLabels) ...[const SizedBox(height: AppSpacings.s4), label],
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        circleRow(_wrapStep(i, builder: circle)),
        if (showLabels) ...[const SizedBox(height: AppSpacings.s4), label],
      ],
    );
  }

  /// Vertical: o trilho (círculo + linha) fica numa coluna à esquerda e os
  /// labels à direita. A linha de cada passo PREENCHE do fundo do círculo até o
  /// círculo seguinte (via `Expanded` dentro do `IntrinsicHeight`), então
  /// **sempre encosta nos dois círculos** — mesmo com label (título+subtítulo)
  /// mais alto que o círculo. Um `minHeight` garante o comprimento mínimo.
  Widget _buildVertical(BuildContext context) {
    final theme = AppTheme.of(context);
    // Nó e ritmo do trilho acompanham o textScaler (padding proporcional).
    final TextScaler scaler = MediaQuery.textScalerOf(context);
    final double nodeSize = scaler.scale(appStepperCircleSize);
    final double minLine = scaler.scale(appStepperMinLineLength);

    // Cor da linha = cor do passo em que ela CHEGA (o próximo): alcançado usa a
    // cor do estado, inativo usa a cor do futuro (honra os overrides).
    Color lineColorFor(int arrivalIndex) {
      final Color accent = _reachedAccent(theme);
      return switch (_stepState(arrivalIndex)) {
        _StepState.completed => completedColor ?? accent,
        _StepState.active => activeColor ?? accent,
        _StepState.upcoming =>
          upcomingColor ?? theme.colorTheme.neutralPrimary.s600,
      };
    }

    // Conector vertical: barra de 2px que PREENCHE a altura recebida (Expanded)
    // e encosta no círculo de cima; intrínseco 0 para conviver com o
    // IntrinsicHeight. A cor segue o passo em que a linha CHEGA ([arrivalIndex]).
    Widget connector(int arrivalIndex) => Expanded(
      child: SizedBox(
        width: _lineThickness,
        child: AnimatedContainer(
          duration: AppMotion.resolve(context, AppDurations.medium),
          curve: AppCurves.standard,
          decoration: BoxDecoration(
            color: lineColorFor(arrivalIndex),
            borderRadius: BorderRadius.circular(_lineThickness),
          ),
        ),
      ),
    );

    final children = <Widget>[];
    for (var i = 0; i < steps.length; i++) {
      final bool isLast = i == steps.length - 1;

      _StepCircle circle(bool h, bool p) => _StepCircle(
        data: steps[i],
        index: i,
        state: _stepState(i),
        highlighted: h,
        pressed: p,
        activeColor: activeColor,
        completedColor: completedColor,
        upcomingColor: upcomingColor,
        style: style,
        radiusMode: radiusMode,
        radius: radius,
      );
      // Trilho: círculo no topo + conector preenchendo o resto da altura.
      Widget trilho(Widget node) => SizedBox(
        width: nodeSize,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [node, if (!isLast) connector(i + 1)],
        ),
      );
      // Rótulo centralizado verticalmente com o círculo (min = nodeSize): sem
      // subtítulo o título fica no meio do nó; com subtítulo cresce e centra.
      Widget labelBox() {
        final box = ConstrainedBox(
          constraints: BoxConstraints(minHeight: nodeSize),
          child: _StepLabel(data: steps[i], state: _stepState(i), axis: axis),
        );
        // labelTappable: rótulo não captura ponteiro (toca o passo em vez de
        // selecionar o texto).
        return labelTappable ? IgnorePointer(child: box) : box;
      }

      Widget rowFor(Widget node) => IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            trilho(node),
            if (showLabels) ...[
              const SizedBox(width: AppSpacings.s8),
              labelBox(),
            ],
          ],
        ),
      );

      // labelTappable: alvo = trilho + label (o conector também entra no
      // toque). Senão, só o círculo é o alvo.
      Widget row = labelTappable
          ? _wrapStep(i, builder: (h, p) => rowFor(circle(h, p)))
          : rowFor(_wrapStep(i, builder: circle));

      // Comprimento mínimo do conector entre círculos (segmentos não-finais).
      if (!isLast) {
        row = ConstrainedBox(
          constraints: BoxConstraints(minHeight: nodeSize + minLine),
          child: row,
        );
      }

      children.add(row);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

/// Círculo numerado ou com check.
class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.data,
    required this.index,
    required this.state,
    required this.highlighted,
    required this.pressed,
    this.activeColor,
    this.completedColor,
    this.upcomingColor,
    this.style,
    this.radiusMode,
    this.radius,
  });

  final Color? activeColor;
  final Color? completedColor;
  final AppStepData data;

  /// Desenha o anel de foco/hover. A interação fica no pai (`_wrapStep`).
  final bool highlighted;

  /// Pressionado (clique): pinta o overlay e aplica a escala. Vem do pai.
  final bool pressed;
  final int index;
  final _StepState state;
  final Color? upcomingColor;
  final AppStyle? style;
  final AppRadiusMode? radiusMode;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) => _circle(context, AppTheme.of(context));

  Widget _circle(BuildContext context, AppThemeData theme) {
    // O nó escala junto com o texto (textScaler) — assim o padding do número/
    // ícone é preservado quando o usuário aumenta a fonte do sistema (a box
    // fixa quebrava o padding). Em escala 1.0 nada muda.
    final TextScaler scaler = MediaQuery.textScalerOf(context);
    final double nodeSize = scaler.scale(appStepperCircleSize);

    // Forma do nó (em espaço escalado). Default do nó: redondo (arredondado),
    // saturado no raio do nó (Reto→quadrado, Circular→círculo perfeito).
    // `radius`/`radiusMode` sobrescrevem o global.
    final double half = nodeSize / 2;
    final double circleRadius = math.min(
      scaler.scale(
        theme.radiusTheme.resolveRadius(
          componentDefault: AppRadiusMode.redondo,
          size: const Size.square(appStepperCircleSize),
          override: radiusMode,
        ),
      ),
      half,
    );
    final BorderRadius circleBR = radius ?? BorderRadius.circular(circleRadius);

    // Cor semântica por estado (dualidade checkbox): alcançado = accent
    // (fill+borda), futuro = ghost (fill nulo) + borda neutra. O eixo AppStyle
    // decide filled/outlined/elevated sobre isso.
    final Color accent = _reachedAccent(theme);
    final Color completed = completedColor ?? accent;
    final Color active = activeColor ?? accent;
    final Color upcoming =
        upcomingColor ?? theme.colorTheme.neutralPrimary.s600;
    final Color? ownFill = switch (state) {
      _StepState.completed => completed,
      _StepState.active => active,
      _StepState.upcoming => null,
    };
    final Color borderColor = switch (state) {
      _StepState.completed => completed,
      _StepState.active => active,
      _StepState.upcoming => upcoming,
    };
    final AppStyle s = style ?? theme.styleTheme.style;
    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: theme.brightness == AppBrightness.dark,
      outline: borderColor,
      // Poço do futuro no `filled`/`elevated`: neutro distinto da superfície.
      surfaceContainer: theme.colorTheme.neutralPrimary.s200,
      ownFill: ownFill,
    );

    // On-color legível do preenchimento alcançado (preto/branco por luminância).
    final Color onCircle = onColorFor(ownFill ?? theme.colorTheme.surface);
    Widget node = AnimatedContainer(
      duration: AppMotion.resolve(context, AppDurations.medium),
      curve: AppCurves.standard,
      width: nodeSize,
      height: nodeSize,
      decoration: BoxDecoration(
        color: deco.color,
        borderRadius: circleBR,
        border: deco.border,
        boxShadow: deco.boxShadow,
      ),
      child: Center(
        // Número/check é decorativo: ignora ponteiro p/ o clique/seleção ir ao
        // alvo tocável (senão selecionava o texto do número, não o passo).
        //
        // `SelectionContainer.disabled` porque na web o `IgnorePointer` sozinho
        // NÃO entrega essa intenção: o `AppText` do número vira um
        // `SelectableRegion`, que monta um platform view DOM por cima do
        // círculo do passo e cancela o `mousedown` — o alvo tocável parava de
        // receber o clique. Motivo completo em `molecules/input/app_input.dart`.
        child: SelectionContainer.disabled(
          child: IgnorePointer(
            child: AnimatedSwitcher(
              duration: AppMotion.resolve(context, AppDurations.normal),
              switchInCurve: AppCurves.standard,
              switchOutCurve: AppCurves.standard,
              child: state == _StepState.completed
                  ? AppIcon(
                      data.icon ?? AppIconToken.check,
                      key: const ValueKey('check'),
                      color: onCircle,
                      customSize: scaler.scale(AppIconSize.s.value),
                    )
                  : AppText(
                      '${index + 1}',
                      key: ValueKey('number_$index'),
                      style: theme.textTheme.labelLarge.withColor(
                        // Ativo: on-color sobre o accent. Pendente: número neutro
                        // legível sobre a superfície/poço.
                        state == _StepState.active
                            ? onCircle
                            : theme.colorTheme.neutralPrimary.s700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );

    // Overlay de estado (hover/foco/press) recortado ao círculo — ladder
    // pressed 0.12 › hover|foco 0.08 (mesma escala de badge/avatar).
    final double? overlayAlpha = pressed ? 0.12 : (highlighted ? 0.08 : null);
    if (overlayAlpha != null) {
      node = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          node,
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorTheme.onSurface.withValues(
                  alpha: overlayAlpha,
                ),
                borderRadius: circleBR,
              ),
            ),
          ),
        ],
      );
    }

    // Escala no press (motion-gated), igual badge/avatar.
    final double pressScale = pressed && AppMotion.enabled(context)
        ? 0.94
        : 1.0;
    Widget circle = AnimatedScale(
      scale: pressScale,
      duration: AppMotion.resolve(context, AppDurations.fast),
      curve: AppCurves.standard,
      child: node,
    );

    // Anel de foco/hover — feedback de alvo tocável, igual checkbox/radio/switch.
    if (highlighted) {
      circle = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: circleBR,
          border: Border.all(
            color: theme.colorTheme.focusRing,
            width: AppStrokes.m,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: circle,
      );
    }

    return circle;
  }
}

/// Label do passo (título + subtítulo opcional).
class _StepLabel extends StatelessWidget {
  const _StepLabel({
    required this.axis,
    required this.data,
    required this.state,
  });

  final Axis axis;
  final AppStepData data;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    // Upcoming precisa permanecer LEGÍVEL (AA) sobre superfície elevada
    // (surfaceContainer no dark). s400 dava ~1.2:1 (ilegível); s700 = 5.4:1. A
    // hierarquia "concluído × pendente" fica no círculo/linha, não na cor do
    // rótulo.
    final titleColor = switch (state) {
      _StepState.completed => theme.colorTheme.neutralPrimary.s700,
      _StepState.active => theme.colorTheme.neutralPrimary.s900,
      _StepState.upcoming => theme.colorTheme.neutralPrimary.s700,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      // Centraliza o conteúdo quando o pai dá altura extra (ver ConstrainedBox
      // do vertical): título sem subtítulo fica no meio do nó.
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: axis == Axis.horizontal
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Título = labelLarge; subtítulo = bodySmall (menor). Hierarquia por
        // TAMANHO — sobre surfaceContainer no dark não dá p/ diferenciar só pela
        // cor (o piso legível AA já é s700).
        AppText(
          data.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // Ativo em negrito: reforça o passo atual além da cor.
          style:
              (state == _StepState.active
                      ? theme.textTheme.labelLarge.bold
                      : theme.textTheme.labelLarge)
                  .withColor(titleColor),
        ),
        if (data.subtitle != null)
          AppText(
            data.subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // s700 = piso legível (~5.4:1) sobre surfaceContainer no dark; s500
            // dava ~1.75:1 (ilegível).
            style: theme.textTheme.bodySmall.withColor(
              theme.colorTheme.neutralPrimary.s700,
            ),
          ),
      ],
    );
  }
}

/// Linha de conexão entre passos com animação de preenchimento.
class _StepLine extends StatelessWidget {
  const _StepLine({
    required this.state,
    required this.axis,
    this.activeColor,
    this.completedColor,
    this.upcomingColor,
  });

  final Axis axis;
  final _StepState state;
  final Color? activeColor;
  final Color? completedColor;
  final Color? upcomingColor;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    // A linha assume a cor do passo em que CHEGA (o próximo): alcançado usa a
    // cor do estado (active/completed), inativo usa a cor do futuro. Honra os
    // overrides de cor passados pelo stepper.
    final Color accent = _reachedAccent(theme);
    final Color filledColor = state == _StepState.completed
        ? (completedColor ?? accent)
        : (activeColor ?? accent);
    final Color emptyColor =
        upcomingColor ?? theme.colorTheme.neutralPrimary.s600;

    final isFilled =
        state == _StepState.completed || state == _StepState.active;

    if (axis == Axis.horizontal) {
      return Stack(
        children: [
          Container(
            height: _lineThickness,
            decoration: BoxDecoration(
              color: emptyColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(_lineThickness),
              ),
            ),
          ),
          AnimatedContainer(
            duration: AppMotion.resolve(context, AppDurations.medium),
            curve: AppCurves.standard,
            height: _lineThickness,
            decoration: BoxDecoration(
              color: isFilled ? filledColor : emptyColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(_lineThickness),
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        Container(
          width: _lineThickness,
          height: double.infinity,
          decoration: BoxDecoration(
            color: emptyColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(_lineThickness),
            ),
          ),
        ),
        // Anima só a COR (altura constante). Interpolar a altura entre 0 e
        // double.infinity dispara assert no Flutter ("Cannot interpolate between
        // finite constraints and unbounded constraints") ao trocar de passo.
        AnimatedContainer(
          duration: AppMotion.resolve(context, AppDurations.medium),
          curve: AppCurves.standard,
          width: _lineThickness,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isFilled ? filledColor : emptyColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(_lineThickness),
            ),
          ),
        ),
      ],
    );
  }
}
