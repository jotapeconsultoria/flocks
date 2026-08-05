import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppDotsIndicator (dots) — one Playground exposing every constructor knob. A CTA
// advances the current step (wraps around totalSteps).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppDotsIndicator)
Widget appDotsIndicatorPlayground(BuildContext context) {
  final totalSteps = context.knobs.int.slider(
    label: 'totalSteps',
    initialValue: 4,
    min: 2,
    max: 8,
    divisions: 6,
  );
  final size = wbSizeKnob(context, initial: AppSizes.s8);
  final spacing = wbSpacingKnob(context, initial: AppSpacings.s4);
  final activeColor = wbSemanticColorKnob(context, label: 'activeColor');
  final completedColor = wbSemanticColorKnob(context, label: 'completedColor');
  final inactiveColor = wbSemanticColorKnob(context, label: 'inactiveColor');
  final tappable = context.knobs.boolean(
    label: 'tappable',
    initialValue: false,
  );
  final allStepsTappable = context.knobs.boolean(
    label: 'allStepsTappable',
    initialValue: false,
  );
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);
  return _StepperDotsDemo(
    totalSteps: totalSteps,
    size: size,
    spacing: spacing,
    activeColor: activeColor,
    completedColor: completedColor,
    inactiveColor: inactiveColor,
    tappable: tappable,
    allStepsTappable: allStepsTappable,
    style: style,
    radiusMode: radiusMode,
  );
}

class _StepperDotsDemo extends StatefulWidget {
  const _StepperDotsDemo({
    required this.totalSteps,
    required this.size,
    required this.spacing,
    required this.tappable,
    required this.allStepsTappable,
    this.activeColor,
    this.completedColor,
    this.inactiveColor,
    this.style,
    this.radiusMode,
  });

  final Color? activeColor;
  final bool allStepsTappable;
  final Color? completedColor;
  final Color? inactiveColor;
  final double size;
  final double spacing;
  final bool tappable;
  final int totalSteps;
  final AppStyle? style;
  final AppRadiusMode? radiusMode;

  @override
  State<_StepperDotsDemo> createState() => _StepperDotsDemoState();
}

class _StepperDotsDemoState extends State<_StepperDotsDemo> {
  int _step = 0;

  void _next() => setState(() => _step = (_step + 1) % widget.totalSteps);

  @override
  Widget build(BuildContext context) {
    // Keep the current step valid when totalSteps shrinks via the knob.
    final step = _step % widget.totalSteps;
    return wbUseCase(
      context,
      name: 'AppDotsIndicator',
      description:
          'Dots page indicator: passed + current use the accent, upcoming are '
          'neutral. Tap Next, or a dot (toggle tappable/allStepsTappable).',
      child: AppDotsIndicator(
        currentStep: step,
        totalSteps: widget.totalSteps,
        size: widget.size,
        spacing: widget.spacing,
        activeColor: widget.activeColor,
        completedColor: widget.completedColor,
        inactiveColor: widget.inactiveColor,
        allStepsTappable: widget.allStepsTappable,
        style: widget.style,
        radiusMode: widget.radiusMode,
        onStepTapped: widget.tappable ? (i) => setState(() => _step = i) : null,
      ),
      cta: wbCta(context, label: 'Next step', onPressed: _next),
    );
  }
}

// ---------------------------------------------------------------------------
// AppStepper (labeled) — one Playground with every knob. A CTA
// advances the current step; completed steps can be tapped to jump back.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppStepper)
Widget appStepperPlayground(BuildContext context) {
  final axis = context.knobs.object.dropdown<Axis>(
    label: 'axis',
    options: const [Axis.horizontal, Axis.vertical],
    initialOption: Axis.horizontal,
    labelBuilder: (a) => a == Axis.horizontal ? 'horizontal' : 'vertical',
  );
  final stepCount = context.knobs.int.slider(
    label: 'stepCount',
    initialValue: 3,
    min: 2,
    max: 6,
    divisions: 4,
  );
  final showLabels = context.knobs.boolean(
    label: 'showLabels',
    initialValue: true,
  );
  final subtitles = context.knobs.boolean(
    label: 'subtitles',
    initialValue: false,
  );
  final customIcons = context.knobs.boolean(
    label: 'customIcons',
    initialValue: false,
  );
  final tappable = context.knobs.boolean(label: 'tappable', initialValue: true);
  final allStepsTappable = context.knobs.boolean(
    label: 'allStepsTappable',
    initialValue: false,
  );
  final labelTappable = context.knobs.boolean(
    label: 'labelTappable',
    initialValue: false,
  );
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);
  return _FormStepperDemo(
    axis: axis,
    stepCount: stepCount,
    showLabels: showLabels,
    subtitles: subtitles,
    customIcons: customIcons,
    tappable: tappable,
    allStepsTappable: allStepsTappable,
    labelTappable: labelTappable,
    style: style,
    radiusMode: radiusMode,
  );
}

class _FormStepperDemo extends StatefulWidget {
  const _FormStepperDemo({
    required this.axis,
    required this.stepCount,
    required this.showLabels,
    required this.subtitles,
    required this.customIcons,
    required this.tappable,
    required this.allStepsTappable,
    required this.labelTappable,
    this.style,
    this.radiusMode,
  });

  final Axis axis;
  final bool allStepsTappable;
  final bool customIcons;
  final bool labelTappable;
  final bool showLabels;
  final int stepCount;
  final bool subtitles;
  final bool tappable;
  final AppStyle? style;
  final AppRadiusMode? radiusMode;

  @override
  State<_FormStepperDemo> createState() => _FormStepperDemoState();
}

class _FormStepperDemoState extends State<_FormStepperDemo> {
  int _step = 0;

  void _next() => setState(() => _step = (_step + 1) % widget.stepCount);

  @override
  Widget build(BuildContext context) {
    // Keep the current step valid when stepCount shrinks via the knob.
    final step = _step % widget.stepCount;
    final steps = List.generate(
      widget.stepCount,
      (i) => AppStepData(
        title: 'Step ${i + 1}',
        subtitle: widget.subtitles ? 'Description ${i + 1}' : null,
        icon: widget.customIcons ? AppIconToken.calendar : null,
      ),
    );
    return wbUseCase(
      context,
      name: 'AppStepper',
      description:
          'Labeled step indicator. Tappable steps get hover/focus ring + '
          'Tab/Enter; toggle allStepsTappable to make every step clickable.',
      child: AppStepper(
        currentStep: step,
        steps: steps,
        axis: widget.axis,
        showLabels: widget.showLabels,
        allStepsTappable: widget.allStepsTappable,
        labelTappable: widget.labelTappable,
        style: widget.style,
        radiusMode: widget.radiusMode,
        onStepTapped: widget.tappable ? (i) => setState(() => _step = i) : null,
      ),
      cta: wbCta(context, label: 'Next step', onPressed: _next),
    );
  }
}

// ---------------------------------------------------------------------------
// States — o progresso é uma sequência, e a grade mostra a sequência inteira
// de uma vez: é comparando começo/meio/fim que se vê se "concluído" e "atual"
// são realmente distinguíveis.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: AppDotsIndicator)
Widget appDotsIndicatorStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDotsIndicator',
  description:
      'Start, middle and end of a 4-step sequence, plus a longer one. The dot '
      'is a position marker, not a control: it says where you are, and the '
      'number of steps has to stay readable at a glance.',
  maxWidth: 700,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    spacing: AppSpacings.s24,
    children: [
      for (final (String name, int step, int total)
          in const <(String, int, int)>[
            ('first of 4', 0, 4),
            ('middle of 4', 2, 4),
            ('last of 4', 3, 4),
            ('2 of 8', 1, 8),
          ])
        wbState(
          context,
          name: name,
          width: 260,
          child: AppDotsIndicator(currentStep: step, totalSteps: total),
        ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppStepper)
Widget appStepperStates(BuildContext context) {
  // `const` só na LISTA: o `AppStepper` tem `assert(steps.length…)`, que não é
  // const-avaliável — o widget não pode ser const.
  const List<AppStepData> steps = <AppStepData>[
    AppStepData(title: 'Dados'),
    AppStepData(title: 'Chip'),
    AppStepData(title: 'Veículo'),
  ];

  return wbUseCase(
    context,
    name: 'AppStepper',
    description:
        'Horizontal and vertical, with and without labels. The completed step '
        'is not just "coloured differently" from the current one — the shape '
        'changes, so the difference survives a colour-blind reading.',
    maxWidth: 780,
    panelPadding: AppSpacings.s24,
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacings.s32,
      runSpacing: AppSpacings.s32,
      children: [
        wbState(
          context,
          name: 'first',
          width: 220,
          child: AppStepper(currentStep: 0, steps: steps),
        ),
        wbState(
          context,
          name: 'middle',
          width: 220,
          child: AppStepper(currentStep: 1, steps: steps),
        ),
        wbState(
          context,
          name: 'last',
          width: 220,
          child: AppStepper(currentStep: 2, steps: steps),
        ),
        wbState(
          context,
          name: 'no labels',
          width: 220,
          child: AppStepper(currentStep: 1, steps: steps, showLabels: false),
        ),
        wbState(
          context,
          name: 'vertical',
          width: 220,
          child: AppStepper(currentStep: 1, steps: steps, axis: Axis.vertical),
        ),
      ],
    ),
  );
}
