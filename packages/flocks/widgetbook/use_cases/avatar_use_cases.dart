import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppAvatar — Sizes (reference grid) + States (forced interaction states) +
// Playground (all knobs). Not a selector and no transition to advance, so there
// is NO CTA (hover/focus/press are exercised live on the canvas).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Sizes', type: AppAvatar)
Widget avatarSizes(BuildContext context) => wbUseCase(
  context,
  name: 'AppAvatar',
  description:
      'Text and icon fallback across the named sizes (diameter grows '
      'with text-scale; padding stays fixed).',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.end,
    spacing: AppSpacings.s32,
    runSpacing: AppSpacings.s32,
    children: [
      wbTile(
        context,
        name: 'Small',
        token: 'size: AppAvatarSize.s',
        child: const AppAvatar(size: AppAvatarSize.s, fallback: 'JP'),
      ),
      wbTile(
        context,
        name: 'Medium',
        token: 'size: AppAvatarSize.m',
        child: const AppAvatar(size: AppAvatarSize.m, fallback: 'AB'),
      ),
      wbTile(
        context,
        name: 'Large',
        token: 'size: AppAvatarSize.l',
        child: const AppAvatar(size: AppAvatarSize.l, fallback: 'CD'),
      ),
      wbTile(
        context,
        name: 'Extra large',
        token: 'size: AppAvatarSize.xl',
        child: const AppAvatar(size: AppAvatarSize.xl, fallback: 'EF'),
      ),
      wbTile(
        context,
        name: 'Icon fallback',
        token: 'fallback: null',
        child: const AppAvatar(size: AppAvatarSize.xl),
      ),
      wbTile(
        context,
        name: 'Custom fallback icon',
        token: 'fallbackIcon: AppIconToken.attachment',
        child: const AppAvatar(
          size: AppAvatarSize.xl,
          fallbackIcon: AppIconToken.attachment,
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppAvatar)
Widget avatarStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppAvatar',
  description:
      'Interaction states forced via a seeded FlocksStatesController. '
      'On the canvas, hover/focus/press also react live.',
  child: const Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      _AvatarStateCard(name: 'Neutral', states: <WidgetState>{}),
      _AvatarStateCard(
        name: 'Hovered',
        states: <WidgetState>{WidgetState.hovered},
      ),
      _AvatarStateCard(
        name: 'Pressed',
        states: <WidgetState>{WidgetState.pressed},
      ),
      _AvatarStateCard(
        name: 'Focused',
        states: <WidgetState>{WidgetState.focused},
      ),
      _AvatarStateCard(
        name: 'Dragged',
        states: <WidgetState>{WidgetState.dragged},
      ),
    ],
  ),
);

/// State card that seeds a [FlocksStatesController] so a single interaction
/// state renders statically. Owns the controller lifecycle (FlocksInteraction
/// never disposes an external one).
class _AvatarStateCard extends StatefulWidget {
  const _AvatarStateCard({required this.name, required this.states});

  final String name;
  final Set<WidgetState> states;

  @override
  State<_AvatarStateCard> createState() => _AvatarStateCardState();
}

class _AvatarStateCardState extends State<_AvatarStateCard> {
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
    child: AppAvatar(
      size: AppAvatarSize.l,
      fallback: 'JP',
      onTap: () {},
      statesController: _controller,
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppAvatar)
Widget avatarPlayground(BuildContext context) {
  final size = context.knobs.object.dropdown<AppAvatarSize>(
    label: 'size',
    options: AppAvatarSize.values,
    initialOption: AppAvatarSize.m,
    labelBuilder: (e) => e.name,
  );
  final fallback = context.knobs.string(label: 'fallback', initialValue: 'JM');
  final fallbackIcon = context.knobs.string(
    label: 'fallbackIcon (used when fallback is empty)',
    initialValue: '',
  );
  final imageUrl = context.knobs.string(label: 'imageUrl', initialValue: '');
  final semanticLabel = context.knobs.string(
    label: 'semanticLabel',
    initialValue: '',
  );
  final clickable = context.knobs.boolean(
    label: 'clickable (onTap)',
    initialValue: false,
  );
  final effect = context.knobs.object.dropdown<AppAvatarEffect>(
    label: 'effect',
    options: AppAvatarEffect.values,
    initialOption: AppAvatarEffect.scale,
    labelBuilder: (e) => e.name,
  );
  return wbUseCase(
    context,
    name: 'AppAvatar',
    description:
        'Network image with text/icon fallback. Set clickable for hover/press '
        'animation; style/radius follow the global addons.',
    child: AppAvatar(
      size: size,
      fallback: fallback.isEmpty ? null : fallback,
      fallbackIcon: fallbackIcon.isEmpty ? null : fallbackIcon,
      imageUrl: imageUrl.isEmpty ? null : imageUrl,
      semanticLabel: semanticLabel.isEmpty ? null : semanticLabel,
      effect: effect,
      onTap: clickable ? () {} : null,
    ),
  );
}
