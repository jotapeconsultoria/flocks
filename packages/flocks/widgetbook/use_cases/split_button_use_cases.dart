import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppSplitButton — Playground (all knobs). The primary segment runs the default
// action; the caret opens the menu. No CTA (the segments are the interaction).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppSplitButton)
Widget splitButtonPlayground(BuildContext context) {
  final label = context.knobs.string(label: 'label', initialValue: 'Save');
  final color = context.knobs.object.dropdown<AppButtonColor>(
    label: 'color',
    options: AppButtonColor.values,
    initialOption: AppButtonColor.primary,
    labelBuilder: (c) => 'AppButtonColor.${c.name}',
  );
  final size = context.knobs.object.dropdown<AppButtonSize>(
    label: 'size',
    options: AppButtonSize.values,
    initialOption: AppButtonSize.l,
    labelBuilder: (s) => 'AppButtonSize.${s.name}',
  );
  // Por padrão NÃO sobrescreve — segue os addons globais (Style/Radius). Os
  // knobs só forçam quando o usuário escolhe um valor concreto.
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);
  final withIcon = context.knobs.boolean(label: 'icon', initialValue: false);
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final loading = context.knobs.boolean(label: 'loading', initialValue: false);
  // menuStyle: `null` = default próprio do menu (elevated), não o addon global.
  final menuStyle = wbStyleKnob(
    context,
    label: 'menuStyle',
    nullLabel: 'Default (elevated)',
  );

  return wbUseCase(
    context,
    name: 'AppSplitButton',
    description:
        'Primary action plus a caret that opens related secondary '
        'actions.',
    child: AppSplitButton(
      label: label,
      color: color,
      size: size,
      style: style,
      radiusMode: radiusMode,
      icon: withIcon ? AppIconToken.check : null,
      enabled: enabled,
      loading: loading,
      menuStyle: menuStyle,
      onPressed: () {},
      menuEntries: _menuEntries(),
    ),
  );
}

List<AppMenuEntry> _menuEntries() => <AppMenuEntry>[
  AppMenuItem(label: 'Save and exit', onPressed: () {}),
  AppMenuItem(label: 'Save as draft', onPressed: () {}),
  const AppMenuDivider(),
  AppMenuItem(
    label: 'Discard',
    icon: AppIconToken.remove,
    danger: true,
    onPressed: () {},
  ),
];

@widgetbook.UseCase(name: 'States', type: AppSplitButton)
Widget appSplitButtonStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSplitButton',
  description: 'Every style plus loading and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Filled',
        when: 'Primary action',
        width: 180,
        child: AppSplitButton(
          label: 'Save',
          onPressed: () {},
          menuEntries: _menuEntries(),
        ),
      ),
      wbState(
        context,
        name: 'Outlined',
        when: 'Secondary action',
        width: 180,
        child: AppSplitButton(
          label: 'Save',
          style: AppStyle.outlined,
          onPressed: () {},
          menuEntries: _menuEntries(),
        ),
      ),
      wbState(
        context,
        name: 'Elevated',
        when: 'Raised emphasis',
        width: 180,
        child: AppSplitButton(
          label: 'Save',
          style: AppStyle.elevated,
          onPressed: () {},
          menuEntries: _menuEntries(),
        ),
      ),
      wbState(
        context,
        name: 'Loading',
        when: 'Awaiting result',
        width: 180,
        child: AppSplitButton(
          label: 'Save',
          loading: true,
          onPressed: () {},
          menuEntries: _menuEntries(),
        ),
      ),
      wbState(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        width: 180,
        child: AppSplitButton(
          label: 'Save',
          enabled: false,
          onPressed: () {},
          menuEntries: _menuEntries(),
        ),
      ),
    ],
  ),
);
