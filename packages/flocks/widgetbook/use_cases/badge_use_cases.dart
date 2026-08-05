import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppBadge — Sizes (reference grid) + States (forced interaction states) +
// Playground (all knobs). Read-only by default; set clickable to exercise
// hover/focus/press live. Not a selector and no transition, so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Sizes', type: AppBadge)
Widget appBadgeSizes(BuildContext context) => wbUseCase(
  context,
  name: 'AppBadge',
  description: 'The named sizes — padding and label role grow per step.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      wbTile(
        context,
        name: 'Small',
        token: 'size: AppBadgeSize.s',
        child: const AppBadge(
          'Small',
          color: AppBadgeColor.info,
          size: AppBadgeSize.s,
        ),
      ),
      wbTile(
        context,
        name: 'Medium',
        token: 'size: AppBadgeSize.m',
        child: const AppBadge('Medium', color: AppBadgeColor.info),
      ),
      wbTile(
        context,
        name: 'Large',
        token: 'size: AppBadgeSize.l',
        child: const AppBadge(
          'Large',
          color: AppBadgeColor.info,
          size: AppBadgeSize.l,
        ),
      ),
      wbTile(
        context,
        name: 'Extra large',
        token: 'size: AppBadgeSize.xl',
        child: const AppBadge(
          'Extra',
          color: AppBadgeColor.info,
          size: AppBadgeSize.xl,
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppBadge)
Widget appBadgeStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppBadge',
  description:
      'Interaction states forced via a seeded FlocksStatesController. '
      'On the canvas, hover/focus/press also react live.',
  child: const Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      _BadgeStateCard(name: 'Neutral', states: <WidgetState>{}),
      _BadgeStateCard(
        name: 'Hovered',
        states: <WidgetState>{WidgetState.hovered},
      ),
      _BadgeStateCard(
        name: 'Pressed',
        states: <WidgetState>{WidgetState.pressed},
      ),
      _BadgeStateCard(
        name: 'Focused',
        states: <WidgetState>{WidgetState.focused},
      ),
      _BadgeStateCard(
        name: 'Dragged',
        states: <WidgetState>{WidgetState.dragged},
      ),
    ],
  ),
);

/// State card that seeds a [FlocksStatesController] so a single interaction
/// state renders statically. Owns the controller lifecycle (FlocksInteraction
/// never disposes an external one).
class _BadgeStateCard extends StatefulWidget {
  const _BadgeStateCard({required this.name, required this.states});

  final String name;
  final Set<WidgetState> states;

  @override
  State<_BadgeStateCard> createState() => _BadgeStateCardState();
}

class _BadgeStateCardState extends State<_BadgeStateCard> {
  late final FlocksStatesController _controller = FlocksStatesController(
    widget.states,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => wbState(
    context,
    name: widget.name,
    child: AppBadge(
      'Filter',
      color: AppBadgeColor.info,
      size: AppBadgeSize.l,
      onTap: () {},
      statesController: _controller,
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppBadge)
Widget appBadgePlayground(BuildContext context) {
  final label = context.knobs.string(label: 'label', initialValue: 'Pending');
  final color = context.knobs.object.dropdown<AppBadgeColor>(
    label: 'color',
    options: AppBadgeColor.values,
    initialOption: AppBadgeColor.warning,
    labelBuilder: (c) => 'AppBadgeColor.${c.name}',
  );
  final size = context.knobs.object.dropdown<AppBadgeSize>(
    label: 'size',
    options: AppBadgeSize.values,
    initialOption: AppBadgeSize.m,
    labelBuilder: (e) => e.name,
  );
  final clickable = context.knobs.boolean(
    label: 'clickable (onTap)',
    initialValue: false,
  );
  final effect = context.knobs.object.dropdown<AppBadgeEffect>(
    label: 'effect',
    options: AppBadgeEffect.values,
    initialOption: AppBadgeEffect.scale,
    labelBuilder: (e) => e.name,
  );
  return wbUseCase(
    context,
    name: 'AppBadge',
    description:
        'A status pill; pick its label, semantic color and size. Set '
        'clickable for hover/press animation; style/radius follow the addons.',
    child: AppBadge(
      label,
      color: color,
      size: size,
      effect: effect,
      onTap: clickable ? () {} : null,
    ),
  );
}
