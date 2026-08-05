import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppCircularLoading — Playground (all constructor knobs). Spinner: motion is
// on the component itself, so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppCircularLoading)
Widget appCircularLoadingPlayground(BuildContext context) {
  final size = wbSizeKnob(context, initial: AppSizes.s48);
  final stroke = wbStrokeKnob(context, initial: AppStrokes.l);
  final determinate = context.knobs.boolean(
    label: 'determinate',
    initialValue: false,
  );
  final value = context.knobs.double.slider(
    label: 'value',
    initialValue: 0.7,
    min: 0,
    max: 1,
  );
  final color = wbSemanticColorKnob(context, label: 'color');
  final backgroundColor = wbSemanticColorKnob(
    context,
    label: 'backgroundColor',
  );
  return wbUseCase(
    context,
    name: 'AppCircularLoading',
    description:
        'Circular indicator — spinner or determinate arc (toggle determinate).',
    // panel:false → o loading fica sobre a `surface` base (o trilho
    // surfaceContainer sumiria contra um painel surfaceContainer).
    panel: false,
    child: AppCircularLoading(
      size: size,
      stroke: stroke,
      color: color,
      backgroundColor: backgroundColor,
      value: determinate ? value : null,
    ),
  );
}

// ---------------------------------------------------------------------------
// AppLinearLoading — Playground. Indeterminate bar; width is constrained so the
// track is visible on the panel. No CTA (motion is intrinsic).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppLinearLoading)
Widget appLinearLoadingPlayground(BuildContext context) {
  final height = wbSizeKnob(context, label: 'height', initial: AppSizes.s4);
  final determinate = context.knobs.boolean(
    label: 'determinate',
    initialValue: false,
  );
  final value = context.knobs.double.slider(
    label: 'value',
    initialValue: 0.7,
    min: 0,
    max: 1,
  );
  final color = wbSemanticColorKnob(context, label: 'color');
  final backgroundColor = wbSemanticColorKnob(
    context,
    label: 'backgroundColor',
  );
  return wbUseCase(
    context,
    name: 'AppLinearLoading',
    description:
        'Linear indicator — indeterminate bar or determinate fill (toggle).',
    // panel:false → sobre a `surface` base (o trilho surfaceContainer sumiria
    // contra um painel surfaceContainer).
    panel: false,
    child: SizedBox(
      width: 260,
      child: AppLinearLoading(
        height: height,
        color: color,
        backgroundColor: backgroundColor,
        value: determinate ? value : null,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// AppShimmerLoading — Playground. Skeleton placeholder with an animated sheen.
// No CTA (motion is intrinsic).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppShimmerLoading)
Widget appShimmerLoadingPlayground(BuildContext context) {
  final width = wbSizeKnob(context, label: 'width', initial: AppSizes.s192);
  final height = wbSizeKnob(context, label: 'height', initial: AppSizes.s24);
  final color = wbSemanticColorKnob(context, label: 'color');
  final highlightColor = wbSemanticColorKnob(context, label: 'highlightColor');
  return wbUseCase(
    context,
    name: 'AppShimmerLoading',
    description:
        'Skeleton placeholder with an animated sheen. Corner radius follows the '
        'global radius axis (redondo mode).',
    // Sem borderRadius explícito → usa o default do componente (radius global,
    // modo redondo).
    child: AppShimmerLoading(
      width: width,
      height: height,
      color: color,
      highlightColor: highlightColor,
    ),
  );
}

// ---------------------------------------------------------------------------
// AppBorderProgress — Playground. The constructor asserts EXACTLY one of
// progress / duration, so `autoMode` picks which one is passed:
//   - autoMode:false -> controlled by the `progress` slider (no CTA needed).
//   - autoMode:true  -> internal animation from `duration` (+ `repeat`).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppBorderProgress)
Widget appBorderProgressPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final autoMode = context.knobs.boolean(
    label: 'autoMode',
    initialValue: false,
  );
  final progress = context.knobs.double.slider(
    label: 'progress',
    initialValue: 0.6,
    min: 0,
    max: 1,
  );
  final duration = wbDurationKnob(context, initial: AppDurations.loopSlow);
  final repeat = context.knobs.boolean(label: 'repeat', initialValue: true);
  final strokeWidth = wbStrokeKnob(
    context,
    label: 'strokeWidth',
    initial: AppStrokes.l,
  );
  final color = wbSemanticColorKnob(context, label: 'color');
  final backgroundColor = wbSemanticColorKnob(
    context,
    label: 'backgroundColor',
  );
  final child = DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colorTheme.surface,
      borderRadius: theme.radiusTheme.resolve(),
    ),
    child: const SizedBox(width: 160, height: 100),
  );
  return wbUseCase(
    context,
    name: 'AppBorderProgress',
    description:
        'Traces a progress border around its child, from the bottom center '
        'clockwise.',
    // A fresh key per mode swaps controlled<->auto cleanly (they assert
    // mutually exclusive constructor args).
    child: autoMode
        ? AppBorderProgress(
            key: const ValueKey('auto'),
            duration: duration,
            repeat: repeat,
            strokeWidth: strokeWidth,
            color: color,
            backgroundColor: backgroundColor,
            borderRadius: theme.radiusTheme.resolve(),
            child: child,
          )
        : AppBorderProgress(
            key: const ValueKey('controlled'),
            progress: progress,
            strokeWidth: strokeWidth,
            color: color,
            backgroundColor: backgroundColor,
            borderRadius: theme.radiusTheme.resolve(),
            child: child,
          ),
  );
}

// ---------------------------------------------------------------------------
// AppOverlayLoading — Playground. Fades a scrim + spinner over its child while
// `isLoading` is true. Toggle the knob to demonstrate the cross-fade.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppOverlayLoading)
Widget appOverlayLoadingPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final isLoading = context.knobs.boolean(
    label: 'isLoading',
    initialValue: true,
  );
  // Mesmos knobs do AppCircularLoading — controlam o indicador do overlay.
  final size = wbSizeKnob(context, initial: AppSizes.s32);
  final stroke = wbStrokeKnob(context, initial: AppStrokes.l);
  final determinate = context.knobs.boolean(
    label: 'determinate',
    initialValue: false,
  );
  final value = context.knobs.double.slider(
    label: 'value',
    initialValue: 0.7,
    min: 0,
    max: 1,
  );
  final spinnerColor = wbSemanticColorKnob(context, label: 'color');
  final spinnerBackground = wbSemanticColorKnob(
    context,
    label: 'backgroundColor',
  );
  final card = DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colorTheme.neutralPrimary.s200,
      borderRadius: theme.radiusTheme.resolve(),
    ),
    child: SizedBox(
      width: 220,
      height: 140,
      child: Center(
        child: AppText(
          'Content behind the overlay',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium.withColor(
            theme.colorTheme.onSurface,
          ),
        ),
      ),
    ),
  );
  return wbUseCase(
    context,
    name: 'AppOverlayLoading',
    description:
        'Fades a dimming scrim + indicator over its child while loading. The '
        'overlay holds any indicator — here a spinner or a determinate arc.',
    child: ClipRRect(
      borderRadius: theme.radiusTheme.resolve(),
      child: AppOverlayLoading(
        isLoading: isLoading,
        overlay: Center(
          child: AppCircularLoading(
            size: size,
            stroke: stroke,
            color: spinnerColor,
            backgroundColor: spinnerBackground,
            value: determinate ? value : null,
          ),
        ),
        child: card,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// States — o que um Playground não mostra de uma vez: indeterminado ao lado de
// determinado. O par importa porque só o determinado sobrevive a reduce-motion
// (é um arco/barra estático), e é ele que se deve preferir quando há progresso
// real para mostrar.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: AppCircularLoading)
Widget appCircularLoadingStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppCircularLoading',
  description:
      'Indeterminate (spins) vs determinate (a static arc). Determinate is the '
      'one that survives reduce-motion — prefer it whenever real progress '
      'exists.',
  panel: false,
  maxWidth: 640,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s32,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'indeterminate',
        child: const AppCircularLoading(size: AppSizes.s32),
      ),
      wbState(
        context,
        name: 'value: 0.25',
        child: const AppCircularLoading(size: AppSizes.s32, value: 0.25),
      ),
      wbState(
        context,
        name: 'value: 0.7',
        child: const AppCircularLoading(size: AppSizes.s32, value: 0.7),
      ),
      wbState(
        context,
        name: 'value: 1',
        child: const AppCircularLoading(size: AppSizes.s32, value: 1),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppLinearLoading)
Widget appLinearLoadingStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppLinearLoading',
  description:
      'Indeterminate (sliding bar) vs determinate (fills from the left). The '
      'ends follow the global radius.',
  panel: false,
  maxWidth: 640,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final (String name, double? value) in const <(String, double?)>[
        ('indeterminate', null),
        ('value: 0.25', 0.25),
        ('value: 0.7', 0.7),
        ('value: 1', 1),
      ])
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacings.s24),
          child: wbState(
            context,
            name: name,
            width: 320,
            child: AppLinearLoading(value: value),
          ),
        ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppShimmerLoading)
Widget appShimmerLoadingStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppShimmerLoading',
  description:
      'A skeleton is a shape, not a spinner: it works by having the SAME '
      'geometry as the content it stands in for. Here, the skeleton of a list '
      'row next to the row itself.',
  maxWidth: 700,
  panelPadding: AppSpacings.s32,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s32,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'skeleton',
        width: 260,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppShimmerLoading(height: AppSizes.s16, width: 180),
            SizedBox(height: AppSpacings.s8),
            AppShimmerLoading(height: AppSizes.s12, width: 120),
          ],
        ),
      ),
      wbState(
        context,
        name: 'loaded',
        width: 260,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText('Polo Track 01'),
            SizedBox(height: AppSpacings.s8),
            AppText('TTS4G47'),
          ],
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppBorderProgress)
Widget appBorderProgressStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppBorderProgress',
  description:
      'Progress drawn AROUND the content instead of over it — nothing is '
      'covered while it runs. Controlled by `progress`; the timer mode '
      '(`duration`) lands on the final state under reduce-motion.',
  maxWidth: 700,
  panelPadding: AppSpacings.s32,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      for (final (String name, double p) in const <(String, double)>[
        ('progress: 0', 0),
        ('progress: 0.35', 0.35),
        ('progress: 0.75', 0.75),
        ('progress: 1', 1),
      ])
        wbState(
          context,
          name: name,
          width: 140,
          child: SizedBox(
            height: 56,
            child: AppBorderProgress(
              progress: p,
              borderRadius: BorderRadius.circular(AppRadius.m),
              child: const Center(child: AppText('Enviando…')),
            ),
          ),
        ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppOverlayLoading)
Widget appOverlayLoadingStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppOverlayLoading',
  description:
      'The content stays VISIBLE under the barrier — the user keeps the '
      'context of what is loading. Toggle between the two to see that the '
      'layout does not shift.',
  maxWidth: 700,
  panelPadding: AppSpacings.s32,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s32,
    runSpacing: AppSpacings.s24,
    children: [
      for (final bool loading in const <bool>[false, true])
        wbState(
          context,
          name: loading ? 'isLoading: true' : 'isLoading: false',
          width: 240,
          child: SizedBox(
            height: 96,
            child: AppOverlayLoading(
              isLoading: loading,
              overlay: const AppCircularLoading(),
              child: const Center(child: AppText('Formulário')),
            ),
          ),
        ),
    ],
  ),
);
