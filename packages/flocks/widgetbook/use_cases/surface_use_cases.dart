import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppSurface — Playground (all knobs) + States (the 3 variants). A surface is
// static; no CTA. panel: false so the surface sits on the base `surface` and
// the tone-based elevation is visible (a surfaceContainer panel would hide it).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppSurface)
Widget appSurfacePlayground(BuildContext context) {
  final variant = context.knobs.object.dropdown<AppSurfaceVariant>(
    label: 'variant',
    options: AppSurfaceVariant.values,
    initialOption: AppSurfaceVariant.raised,
    labelBuilder: (v) => 'AppSurfaceVariant.${v.name}',
  );
  final radius = wbRadiusKnob(context, label: 'radius', initial: AppRadius.m);
  final padding = wbSpacingKnob(
    context,
    label: 'padding',
    initial: AppSpacings.s16,
  );

  return wbUseCase(
    context,
    name: 'AppSurface',
    description: 'Elevation by tone: flat / raised / bordered.',
    panel: false,
    child: AppSurface(
      variant: variant,
      radius: BorderRadius.circular(radius),
      padding: EdgeInsets.all(padding),
      child: const AppText('Surface content'),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppSurface)
Widget appSurfaceStates(BuildContext context) {
  return wbUseCase(
    context,
    name: 'AppSurface',
    description: 'The three elevation variants.',
    panel: false,
    child: Wrap(
      spacing: AppSpacings.s16,
      runSpacing: AppSpacings.s16,
      children: [
        for (final v in AppSurfaceVariant.values)
          AppSurface(
            variant: v,
            padding: const EdgeInsets.all(AppSpacings.s24),
            child: AppText(v.name),
          ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// AppScrollEdgeFade (+Owner) — the veil only exists when there IS hidden
// content, so the cases put a scrolling box next to a short one. No CTA: the
// scroll gesture is the control.
// ---------------------------------------------------------------------------

Widget _rows(int n) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
    for (int i = 1; i <= n; i++)
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacings.s8),
        child: AppText('Row $i'),
      ),
  ],
);

@widgetbook.UseCase(name: 'Playground', type: AppScrollEdgeFade)
Widget appScrollEdgeFadePlayground(BuildContext context) {
  final rows = context.knobs.int.slider(
    label: 'rows',
    initialValue: 12,
    min: 1,
    max: 30,
  );
  final extent = wbSpacingKnob(
    context,
    label: 'extent',
    initial: AppSpacings.s24,
  );
  final horizontal = context.knobs.boolean(label: 'axis: horizontal');
  final color = wbSemanticColorKnob(context, label: 'color');

  return wbUseCase(
    context,
    name: 'AppScrollEdgeFade',
    description:
        'Fades the edge of scrolling content. Drop rows to 2 and the veil '
        'disappears: a permanent gradient would promise content that is not '
        'there. color is where the gradient departs from — pass the real '
        'surface when it is not surfaceContainer.',
    child: SizedBox(
      width: 240,
      height: 180,
      child: AppScrollEdgeFade(
        extent: extent,
        color: color,
        axis: horizontal ? Axis.horizontal : Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: horizontal ? Axis.horizontal : Axis.vertical,
          child: horizontal
              ? Row(
                  children: [
                    for (int i = 1; i <= rows; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacings.s16,
                        ),
                        child: AppText('Col $i'),
                      ),
                  ],
                )
              : _rows(rows),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppScrollEdgeFade)
Widget appScrollEdgeFadeStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppScrollEdgeFade',
  description:
      'Scrollable vs short content: the veil is painted only on the side that '
      'actually hides something.',
  maxWidth: 640,
  panelPadding: AppSpacings.s32,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'scrolls',
        width: 200,
        child: SizedBox(
          height: 160,
          child: AppScrollEdgeFade(
            child: SingleChildScrollView(child: _rows(12)),
          ),
        ),
      ),
      wbState(
        context,
        name: 'fits (no veil)',
        width: 200,
        child: SizedBox(
          height: 160,
          child: AppScrollEdgeFade(
            child: SingleChildScrollView(child: _rows(2)),
          ),
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'Playground', type: AppScrollEdgeFadeOwner)
Widget appScrollEdgeFadeOwnerPlayground(BuildContext context) {
  final owned = context.knobs.boolean(
    label: 'wrap inner area in AppScrollEdgeFadeOwner',
    initialValue: true,
  );

  final inner = Column(
    children: [
      const AppText('tab bar'),
      Expanded(
        child: AppScrollEdgeFade(
          child: SingleChildScrollView(child: _rows(12)),
        ),
      ),
    ],
  );

  return wbUseCase(
    context,
    name: 'AppScrollEdgeFadeOwner',
    description:
        'Turn the knob off and the OUTER veil lands on the tab bar — it hears '
        'the same scroll but does not know where the content starts. The owner '
        'marks "the veil in here is mine" and switches the ancestor off.',
    child: SizedBox(
      width: 240,
      height: 200,
      child: AppScrollEdgeFade(
        child: owned ? AppScrollEdgeFadeOwner(child: inner) : inner,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppScrollEdgeFadeOwner)
Widget appScrollEdgeFadeOwnerStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppScrollEdgeFadeOwner',
  description:
      'With an ancestor it switches it off; standalone it is a pass-through — '
      'a tabbed component should not have to know whether someone wrapped it.',
  maxWidth: 640,
  panelPadding: AppSpacings.s32,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'inside a fade',
        width: 200,
        child: SizedBox(
          height: 160,
          child: AppScrollEdgeFade(
            child: AppScrollEdgeFadeOwner(
              child: SingleChildScrollView(child: _rows(12)),
            ),
          ),
        ),
      ),
      wbState(
        context,
        name: 'standalone',
        width: 200,
        child: SizedBox(
          height: 160,
          child: AppScrollEdgeFadeOwner(
            child: SingleChildScrollView(child: _rows(12)),
          ),
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppSideInset — applies (and consumes) the side gutter the host surface
// published in MediaQuery.padding. The case publishes one, like a side sheet.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppSideInset)
Widget appSideInsetPlayground(BuildContext context) {
  final published = wbSpacingKnob(
    context,
    label: 'published MediaQuery.padding',
    initial: AppSpacings.s24,
  );
  final wrap = context.knobs.boolean(
    label: 'wrap in AppSideInset',
    initialValue: true,
  );

  const Widget content = AppText('Content');

  return wbUseCase(
    context,
    name: 'AppSideInset',
    description:
        'The host surface PUBLISHES its side gutter instead of padding the '
        'content, so scrollables can add it to their own padding and keep the '
        'scrollbar on the edge. This is the shortcut for content that does '
        'not scroll — it applies the inset and removes it from the MediaQuery, '
        'so nothing below applies it twice.',
    child: MediaQuery(
      data: MediaQueryData(
        padding: EdgeInsets.symmetric(horizontal: published),
      ),
      child: SizedBox(
        width: 260,
        height: 80,
        child: ColoredBox(
          color: AppTheme.of(context).colorTheme.surface,
          child: wrap ? const AppSideInset(child: content) : content,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppSideInset)
Widget appSideInsetStates(BuildContext context) {
  final colors = AppTheme.of(context).colorTheme;
  Widget box(Widget child) => SizedBox(
    width: 200,
    height: 72,
    child: ColoredBox(color: colors.surface, child: child),
  );

  return wbUseCase(
    context,
    name: 'AppSideInset',
    description:
        'Same published gutter, three ways. Nesting two is a no-op: the outer '
        'one consumes the value, which is what stops double indentation.',
    maxWidth: 700,
    panelPadding: AppSpacings.s32,
    child: MediaQuery(
      data: const MediaQueryData(
        padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacings.s24,
        runSpacing: AppSpacings.s24,
        children: [
          wbState(
            context,
            name: 'unwrapped',
            width: 200,
            child: box(const AppText('Touches the edge')),
          ),
          wbState(
            context,
            name: 'AppSideInset',
            width: 200,
            child: box(const AppSideInset(child: AppText('Breathes'))),
          ),
          wbState(
            context,
            name: 'nested (no-op)',
            width: 200,
            child: box(
              const AppSideInset(
                child: AppSideInset(child: AppText('Same as one')),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
