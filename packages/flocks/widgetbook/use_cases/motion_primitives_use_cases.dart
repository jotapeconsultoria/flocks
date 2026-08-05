import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// Motion primitives — one 'Playground' per component, every configurable
// constructor parameter exposed as a knob. One-shot transitions get a CTA that
// flips the driving state; intrinsic controls (value slider, continuous spin)
// do not. Alignment/textAlign knobs reuse the shared dropdown helpers below.
// ---------------------------------------------------------------------------

/// Primary chip — the moving subject in most of these cases.
Widget _chip(BuildContext context, String label) {
  final theme = AppTheme.of(context);
  return DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colorTheme.primary,
      borderRadius: theme.radiusTheme.resolve(),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s16,
        vertical: AppSpacings.s8,
      ),
      child: AppText(
        label,
        style: theme.textTheme.labelLarge.withColor(theme.colorTheme.onPrimary),
      ),
    ),
  );
}

/// The nine [Alignment] anchors, for alignment knobs.
const _alignments = <Alignment>[
  Alignment.topLeft,
  Alignment.topCenter,
  Alignment.topRight,
  Alignment.centerLeft,
  Alignment.center,
  Alignment.centerRight,
  Alignment.bottomLeft,
  Alignment.bottomCenter,
  Alignment.bottomRight,
];

String _alignmentLabel(Alignment a) => switch (a) {
  Alignment.topLeft => 'topLeft',
  Alignment.topCenter => 'topCenter',
  Alignment.topRight => 'topRight',
  Alignment.centerLeft => 'centerLeft',
  Alignment.center => 'center',
  Alignment.centerRight => 'centerRight',
  Alignment.bottomLeft => 'bottomLeft',
  Alignment.bottomCenter => 'bottomCenter',
  Alignment.bottomRight => 'bottomRight',
  _ => 'center',
};

Alignment _alignmentKnob(
  BuildContext context, {
  Alignment initial = Alignment.center,
}) => context.knobs.object.dropdown<Alignment>(
  label: 'alignment',
  options: _alignments,
  initialOption: initial,
  labelBuilder: _alignmentLabel,
);

int _durationMsKnob(
  BuildContext context, {
  String label = 'duration',
  Duration initial = AppDurations.normal,
}) => wbDurationKnob(context, label: label, initial: initial).inMilliseconds;

// ---------------------------------------------------------------------------
// AppFade — fade a chip in and out. CTA flips `visible`.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppFade)
Widget appFadePlayground(BuildContext context) {
  final opacity = context.knobs.double.slider(
    label: 'opacity (when visible)',
    initialValue: 1,
    min: 0,
    max: 1,
  );
  final ms = _durationMsKnob(context);
  return _AppFadeDemo(
    opacity: opacity,
    duration: Duration(milliseconds: ms),
  );
}

class _AppFadeDemo extends StatefulWidget {
  const _AppFadeDemo({required this.opacity, required this.duration});

  final double opacity;
  final Duration duration;

  @override
  State<_AppFadeDemo> createState() => _AppFadeDemoState();
}

class _AppFadeDemoState extends State<_AppFadeDemo> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) => wbUseCase(
    context,
    name: 'AppFade',
    description: 'Fade a chip in and out.',
    cta: wbCta(
      context,
      label: 'Toggle',
      onPressed: () => setState(() => _visible = !_visible),
    ),
    child: AppFade(
      opacity: _visible ? widget.opacity : 0,
      duration: widget.duration,
      child: _chip(context, 'Fade me'),
    ),
  );
}

// ---------------------------------------------------------------------------
// AppPop — scale a chip in with an overshoot pop. CTA flips `visible`.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppPop)
Widget appPopPlayground(BuildContext context) {
  final scale = context.knobs.double.slider(
    label: 'scale (when visible)',
    initialValue: 1,
    min: 0,
    max: 1.5,
  );
  final ms = _durationMsKnob(context);
  final alignment = _alignmentKnob(context);
  return _AppPopDemo(
    scale: scale,
    duration: Duration(milliseconds: ms),
    alignment: alignment,
  );
}

class _AppPopDemo extends StatefulWidget {
  const _AppPopDemo({
    required this.scale,
    required this.duration,
    required this.alignment,
  });

  final double scale;
  final Duration duration;
  final Alignment alignment;

  @override
  State<_AppPopDemo> createState() => _AppPopDemoState();
}

class _AppPopDemoState extends State<_AppPopDemo> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) => wbUseCase(
    context,
    name: 'AppPop',
    description: 'Scale a chip in with a contained overshoot pop.',
    cta: wbCta(
      context,
      label: 'Pop',
      onPressed: () => setState(() => _visible = !_visible),
    ),
    child: AppPop(
      scale: _visible ? widget.scale : 0,
      duration: widget.duration,
      alignment: widget.alignment,
      child: _chip(context, 'Pop me'),
    ),
  );
}

// ---------------------------------------------------------------------------
// AppSlide — translate a chip by an offset (multiples of its own size). CTA
// toggles the offset between zero and (dx, dy). Wrapped in AppFade so the chip
// stays legible while it slides off.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppSlide)
Widget appSlidePlayground(BuildContext context) {
  final dx = context.knobs.double.slider(
    label: 'dx',
    initialValue: 1,
    min: -1,
    max: 1,
  );
  final dy = context.knobs.double.slider(
    label: 'dy',
    initialValue: 0,
    min: -1,
    max: 1,
  );
  final ms = _durationMsKnob(context);
  return _AppSlideDemo(
    offset: Offset(dx, dy),
    duration: Duration(milliseconds: ms),
  );
}

class _AppSlideDemo extends StatefulWidget {
  const _AppSlideDemo({required this.offset, required this.duration});

  final Offset offset;
  final Duration duration;

  @override
  State<_AppSlideDemo> createState() => _AppSlideDemoState();
}

class _AppSlideDemoState extends State<_AppSlideDemo> {
  bool _shifted = false;

  @override
  Widget build(BuildContext context) => wbUseCase(
    context,
    name: 'AppSlide',
    description: 'Translate a chip by an offset (multiples of its own size).',
    cta: wbCta(
      context,
      label: 'Slide',
      onPressed: () => setState(() => _shifted = !_shifted),
    ),
    child: AppSlide(
      offset: _shifted ? widget.offset : Offset.zero,
      duration: widget.duration,
      child: AppFade(
        opacity: _shifted ? 0 : 1,
        duration: widget.duration,
        child: _chip(context, 'Slide me'),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// AppExpand — reveal by size (expand/collapse). CTA toggles the child width.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppExpand)
Widget appExpandPlayground(BuildContext context) {
  final alignment = _alignmentKnob(context, initial: Alignment.topCenter);
  final ms = _durationMsKnob(context, initial: AppDurations.slow);
  return _AppExpandDemo(
    alignment: alignment,
    duration: Duration(milliseconds: ms),
  );
}

class _AppExpandDemo extends StatefulWidget {
  const _AppExpandDemo({required this.alignment, required this.duration});

  final Alignment alignment;
  final Duration duration;

  @override
  State<_AppExpandDemo> createState() => _AppExpandDemoState();
}

class _AppExpandDemoState extends State<_AppExpandDemo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return wbUseCase(
      context,
      name: 'AppExpand',
      description: 'Reveal by size — expand and collapse a panel.',
      cta: wbCta(
        context,
        label: 'Expand/Collapse',
        onPressed: () => setState(() => _expanded = !_expanded),
      ),
      child: AppExpand(
        alignment: widget.alignment,
        duration: widget.duration,
        child: SizedBox(
          width: _expanded ? 320 : 120,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorTheme.primary,
              borderRadius: theme.radiusTheme.resolve(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacings.s16,
                vertical: AppSpacings.s8,
              ),
              child: AppText(
                _expanded ? 'Expanded panel' : 'Collapsed',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge.withColor(
                  theme.colorTheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AppCrossFade — swap content with a cross-fade. CTA swaps a keyed child A/B.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppCrossFade)
Widget appCrossFadePlayground(BuildContext context) {
  final alignment = _alignmentKnob(context);
  final ms = _durationMsKnob(context);
  return _AppCrossFadeDemo(
    alignment: alignment,
    duration: Duration(milliseconds: ms),
  );
}

class _AppCrossFadeDemo extends StatefulWidget {
  const _AppCrossFadeDemo({required this.alignment, required this.duration});

  final Alignment alignment;
  final Duration duration;

  @override
  State<_AppCrossFadeDemo> createState() => _AppCrossFadeDemoState();
}

class _AppCrossFadeDemoState extends State<_AppCrossFadeDemo> {
  bool _showA = true;

  @override
  Widget build(BuildContext context) => wbUseCase(
    context,
    name: 'AppCrossFade',
    description:
        'Swap content with a cross-fade (old fades out, new fades in).',
    cta: wbCta(
      context,
      label: 'Swap A/B',
      onPressed: () => setState(() => _showA = !_showA),
    ),
    child: AppCrossFade(
      alignment: widget.alignment,
      duration: widget.duration,
      child: _showA
          ? KeyedSubtree(
              key: const ValueKey('a'),
              child: _chip(context, 'Content A'),
            )
          : KeyedSubtree(
              key: const ValueKey('b'),
              child: _chip(context, 'Content B'),
            ),
    ),
  );
}

// ---------------------------------------------------------------------------
// AppValueBuilder — animate a double and paint a progress bar. Intrinsic value
// slider drives it, so NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppValueBuilder)
Widget appValueBuilderPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final value = context.knobs.double.slider(
    label: 'value',
    initialValue: 0.6,
    min: 0,
    max: 1,
  );
  final ms = _durationMsKnob(context, initial: AppDurations.slow);
  return wbUseCase(
    context,
    name: 'AppValueBuilder',
    description:
        'Animate a double toward a target; here it fills a progress bar.',
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorTheme.surfaceContainer,
        borderRadius: theme.radiusTheme.resolve(),
      ),
      child: SizedBox(
        width: 260,
        height: 16,
        child: AppValueBuilder(
          value: value,
          duration: Duration(milliseconds: ms),
          builder: (context, v, _) => FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: v.clamp(0.0, 1.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorTheme.primary,
                borderRadius: theme.radiusTheme.resolve(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// AppTypewriter — reveal text character by character. CTA bumps a ValueKey to
// remount and replay.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppTypewriter)
Widget appTypewriterPlayground(BuildContext context) {
  final text = context.knobs.string(
    label: 'text',
    initialValue: 'Typing, one character at a time.',
  );
  final charMs = _durationMsKnob(
    context,
    label: 'charDuration',
    initial: AppDurations.fast,
  );
  final textAlign = context.knobs.object.dropdown<TextAlign>(
    label: 'textAlign',
    options: const [
      TextAlign.start,
      TextAlign.center,
      TextAlign.end,
      TextAlign.left,
      TextAlign.right,
    ],
    initialOption: TextAlign.start,
    labelBuilder: (a) => a.name,
  );
  return _AppTypewriterDemo(
    text: text,
    charDuration: Duration(milliseconds: charMs),
    textAlign: textAlign,
  );
}

class _AppTypewriterDemo extends StatefulWidget {
  const _AppTypewriterDemo({
    required this.text,
    required this.charDuration,
    required this.textAlign,
  });

  final String text;
  final Duration charDuration;
  final TextAlign textAlign;

  @override
  State<_AppTypewriterDemo> createState() => _AppTypewriterDemoState();
}

class _AppTypewriterDemoState extends State<_AppTypewriterDemo> {
  int _run = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return wbUseCase(
      context,
      name: 'AppTypewriter',
      description:
          'Reveal text character by character (full text stays accessible).',
      cta: wbCta(
        context,
        label: 'Retype',
        onPressed: () => setState(() => _run++),
      ),
      child: SizedBox(
        width: 280,
        child: AppTypewriter(
          key: ValueKey(_run),
          text: widget.text,
          charDuration: widget.charDuration,
          textAlign: widget.textAlign,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AppAppear — canonical fade + pop entrance on mount. CTA bumps a ValueKey to
// remount and replay.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppAppear)
Widget appAppearPlayground(BuildContext context) {
  final fromScale = context.knobs.double.slider(
    label: 'fromScale',
    initialValue: 0.85,
    min: 0,
    max: 1,
  );
  final ms = _durationMsKnob(context);
  return _AppAppearDemo(
    fromScale: fromScale,
    duration: Duration(milliseconds: ms),
  );
}

class _AppAppearDemo extends StatefulWidget {
  const _AppAppearDemo({required this.fromScale, required this.duration});

  final double fromScale;
  final Duration duration;

  @override
  State<_AppAppearDemo> createState() => _AppAppearDemoState();
}

class _AppAppearDemoState extends State<_AppAppearDemo> {
  int _run = 0;

  @override
  Widget build(BuildContext context) => wbUseCase(
    context,
    name: 'AppAppear',
    description: 'Canonical fade + pop entrance when the widget mounts.',
    cta: wbCta(
      context,
      label: 'Replay',
      onPressed: () => setState(() => _run++),
    ),
    child: AppAppear(
      key: ValueKey(_run),
      fromScale: widget.fromScale,
      duration: widget.duration,
      child: _chip(context, 'Here I am'),
    ),
  );
}

// ---------------------------------------------------------------------------
// AppAnimatedRotation — implicit rotation to a turns target. CTA toggles turns
// between 0 and the target.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppAnimatedRotation)
Widget appAnimatedRotationPlayground(BuildContext context) {
  final turns = context.knobs.double.slider(
    label: 'turns (target)',
    initialValue: 0.5,
    min: -2,
    max: 2,
  );
  final ms = _durationMsKnob(context);
  final alignment = _alignmentKnob(context);
  return _AppAnimatedRotationDemo(
    turns: turns,
    duration: Duration(milliseconds: ms),
    alignment: alignment,
  );
}

class _AppAnimatedRotationDemo extends StatefulWidget {
  const _AppAnimatedRotationDemo({
    required this.turns,
    required this.duration,
    required this.alignment,
  });

  final double turns;
  final Duration duration;
  final Alignment alignment;

  @override
  State<_AppAnimatedRotationDemo> createState() =>
      _AppAnimatedRotationDemoState();
}

class _AppAnimatedRotationDemoState extends State<_AppAnimatedRotationDemo> {
  bool _rotated = false;

  @override
  Widget build(BuildContext context) => wbUseCase(
    context,
    name: 'AppAnimatedRotation',
    description: 'Implicitly rotate a chip to a turns target (1.0 = 360°).',
    cta: wbCta(
      context,
      label: 'Rotate',
      onPressed: () => setState(() => _rotated = !_rotated),
    ),
    child: AppAnimatedRotation(
      turns: _rotated ? widget.turns : 0,
      duration: widget.duration,
      alignment: widget.alignment,
      child: _chip(context, 'Rotate me'),
    ),
  );
}

// ---------------------------------------------------------------------------
// AppSpin — continuous rotation for loading indicators. Intrinsic (always
// spinning), so NO CTA. The period knob sets one full turn.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppSpin)
Widget appSpinPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final period = wbDurationKnob(
    context,
    label: 'period',
    initial: AppDurations.loop,
  );
  return wbUseCase(
    context,
    name: 'AppSpin',
    description: 'Continuously rotate a child — the loading-indicator spinner.',
    child: AppSpin(
      period: period,
      child: AppIcon(
        AppIconToken.check,
        size: AppIconSize.xl,
        color: theme.colorTheme.primary,
        semanticLabel: 'spinning icon',
      ),
    ),
  );
}
