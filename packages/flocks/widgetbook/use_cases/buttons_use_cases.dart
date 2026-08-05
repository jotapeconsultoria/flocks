import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppButton — States (reference grid) + Playground (interactive, all knobs).
// The button IS the interaction target (tap/hover/focus), so there is NO CTA.
// ---------------------------------------------------------------------------

AppButtonColor _colorKnob(BuildContext context) =>
    context.knobs.object.dropdown<AppButtonColor>(
      label: 'color',
      options: AppButtonColor.values,
      initialOption: AppButtonColor.primary,
      labelBuilder: (c) => 'AppButtonColor.${c.name}',
    );

AppButtonSize _sizeKnob(BuildContext context) =>
    context.knobs.object.dropdown<AppButtonSize>(
      label: 'size',
      options: AppButtonSize.values,
      initialOption: AppButtonSize.l,
      labelBuilder: (s) => 'AppButtonSize.${s.name}',
    );

@widgetbook.UseCase(name: 'States', type: AppButton)
Widget appButtonStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppButton',
  description: 'Every style and state at a glance (color: primary).',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: [
      wbState(
        context,
        name: 'Filled',
        when: 'Primary action',
        child: AppButton(label: 'Salvar', onPressed: () {}),
      ),
      wbState(
        context,
        name: 'Outlined',
        when: 'Secondary action',
        child: AppButton(
          style: AppStyle.outlined,
          label: 'Salvar',
          onPressed: () {},
        ),
      ),
      wbState(
        context,
        name: 'Elevated',
        when: 'Raised emphasis',
        child: AppButton(
          style: AppStyle.elevated,
          label: 'Salvar',
          onPressed: () {},
        ),
      ),
      wbState(
        context,
        name: 'Icon + label',
        when: 'Reinforce meaning',
        child: AppButton(
          label: 'Salvar',
          icon: AppIconToken.add,
          onPressed: () {},
        ),
      ),
      wbState(
        context,
        name: 'Icon-only',
        when: 'Compact action',
        child: AppButton(
          icon: AppIconToken.add,
          semanticsLabel: 'Add',
          onPressed: () {},
        ),
      ),
      wbState(
        context,
        name: 'Loading',
        when: 'Awaiting result',
        child: const AppButton(label: 'Salvar', loading: true, onPressed: null),
      ),
      wbState(
        context,
        name: 'Disabled',
        when: 'Action unavailable',
        child: const AppButton(
          label: 'Salvar',
          enabled: false,
          onPressed: null,
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'Playground', type: AppButton)
Widget appButtonPlayground(BuildContext context) {
  final label = context.knobs.string(label: 'label', initialValue: 'Salvar');
  final withIcon = context.knobs.boolean(
    label: 'with icon',
    initialValue: false,
  );
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final loading = context.knobs.boolean(label: 'loading', initialValue: false);
  final expanded = context.knobs.boolean(
    label: 'expandedWidth',
    initialValue: false,
  );
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);
  return wbUseCase(
    context,
    name: 'AppButton',
    description:
        'Action with label/icon; varies by AppStyle (filled/outlined/elevated). '
        'style/radius follow the addons unless overridden here.',
    child: AppButton(
      style: style,
      label: label.isEmpty ? null : label,
      icon: withIcon ? AppIconToken.add : null,
      color: _colorKnob(context),
      size: _sizeKnob(context),
      enabled: enabled,
      loading: loading,
      expandedWidth: expanded,
      radiusMode: radiusMode,
      onPressed: () {},
    ),
  );
}

// ---------------------------------------------------------------------------
// AppFloatingButton (FAB) — States grid + Playground. Floats → always shadowed
// (even outside `elevated`); circular by default; icon and/or label. The FAB IS
// the interaction target, so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: AppFloatingButton)
Widget appFloatingButtonStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppFloatingButton',
  description:
      'Every style and shape at a glance (color: primary). Always shadowed; '
      'glass frosts the backdrop.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: [
      wbState(
        context,
        name: 'Filled',
        when: 'Primary floating action',
        child: AppFloatingButton(icon: AppIconToken.add, onPressed: () {}),
      ),
      wbState(
        context,
        name: 'Outlined',
        when: 'Lower emphasis',
        child: AppFloatingButton(
          style: AppStyle.outlined,
          icon: AppIconToken.add,
          onPressed: () {},
        ),
      ),
      wbState(
        context,
        name: 'Elevated',
        when: 'Raised emphasis',
        child: AppFloatingButton(
          style: AppStyle.elevated,
          icon: AppIconToken.add,
          onPressed: () {},
        ),
      ),
      wbState(
        context,
        name: 'Glass',
        when: 'Over rich content',
        child: AppFloatingButton(
          glass: true,
          icon: AppIconToken.add,
          onPressed: () {},
        ),
      ),
      wbState(
        context,
        name: 'Extended',
        when: 'Icon + label',
        child: AppFloatingButton(
          icon: AppIconToken.add,
          label: 'Novo',
          onPressed: () {},
        ),
      ),
      wbState(
        context,
        name: 'Text-only',
        when: 'Label without icon',
        child: AppFloatingButton(label: 'Novo', onPressed: () {}),
      ),
      wbState(
        context,
        name: 'Loading',
        when: 'Awaiting result',
        child: const AppFloatingButton(
          icon: AppIconToken.add,
          loading: true,
          onPressed: null,
        ),
      ),
      wbState(
        context,
        name: 'Disabled',
        when: 'Action unavailable',
        child: const AppFloatingButton(
          icon: AppIconToken.add,
          enabled: false,
          onPressed: null,
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'Playground', type: AppFloatingButton)
Widget appFloatingButtonPlayground(BuildContext context) {
  final label = context.knobs.string(label: 'label', initialValue: '');
  final withIcon = context.knobs.boolean(
    label: 'with icon',
    initialValue: true,
  );
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final loading = context.knobs.boolean(label: 'loading', initialValue: false);
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);
  // Só o FAB participa do eixo glass entre os botões (allow-list do glass).
  final glass = wbGlassKnob(context);
  return wbUseCase(
    context,
    name: 'AppFloatingButton',
    description:
        'Floating action with icon and/or label; always shadowed. Varies by '
        'AppStyle (filled/outlined/elevated/glass). style/radius follow the '
        'addons unless overridden here.',
    child: AppFloatingButton(
      style: style,
      glass: glass,
      label: label.isEmpty ? null : label,
      icon: withIcon ? AppIconToken.add : null,
      color: _colorKnob(context),
      size: _sizeKnob(context),
      enabled: enabled,
      loading: loading,
      radiusMode: radiusMode,
      onPressed: () {},
    ),
  );
}
