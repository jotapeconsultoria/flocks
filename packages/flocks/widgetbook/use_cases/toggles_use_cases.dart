import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppCheckbox — States (reference grid) + Playground (interactive, all knobs).
// Selector: the interaction is on the component itself, so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: AppCheckbox)
Widget checkboxStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppCheckbox',
  description: 'Every visual state of the checkbox at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s16,
    runSpacing: AppSpacings.s32,
    children: [
      wbState(
        context,
        name: 'Checked',
        when: 'Option is on',
        child: AppCheckbox(checked: true, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'Unchecked',
        when: 'Option is off',
        child: AppCheckbox(checked: false, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'Checked · disabled',
        when: 'On, read-only',
        child: const AppCheckbox(checked: true, enabled: false),
      ),
      wbState(
        context,
        name: 'Unchecked · disabled',
        when: 'Off, read-only',
        child: const AppCheckbox(checked: false, enabled: false),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'Playground', type: AppCheckbox)
Widget checkboxPlayground(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final label = context.knobs.string(
    label: 'label',
    initialValue: 'I accept the terms of use',
  );
  final tooltip = context.knobs.string(label: 'tooltip', initialValue: '');
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);
  return wbUseCase(
    context,
    name: 'AppCheckbox',
    description:
        'Toggle the checkbox; control every attribute via knobs. '
        'style/radius follow the addons unless overridden here.',
    child: _CheckboxDemo(
      enabled: enabled,
      label: label,
      tooltip: tooltip.isEmpty ? null : tooltip,
      style: style,
      radiusMode: radiusMode,
    ),
  );
}

// ---------------------------------------------------------------------------
// AppSwitch — States + Playground. Also a selector, so NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: AppSwitch)
Widget switchStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSwitch',
  description: 'Every visual state of the switch at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s16,
    runSpacing: AppSpacings.s32,
    children: [
      wbState(
        context,
        name: 'On',
        when: 'Setting is active',
        child: AppSwitch(value: true, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'Off',
        when: 'Setting is inactive',
        child: AppSwitch(value: false, onChanged: (_) {}),
      ),
      wbState(
        context,
        name: 'On · disabled',
        when: 'Active, read-only',
        child: const AppSwitch(value: true, enabled: false),
      ),
      wbState(
        context,
        name: 'Off · disabled',
        when: 'Inactive, read-only',
        child: const AppSwitch(value: false, enabled: false),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'Playground', type: AppSwitch)
Widget switchPlayground(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final label = context.knobs.string(
    label: 'label',
    initialValue: 'Notifications',
  );
  final tooltip = context.knobs.string(label: 'tooltip', initialValue: '');
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);
  return wbUseCase(
    context,
    name: 'AppSwitch',
    description:
        'Flip the switch; control every attribute via knobs. '
        'style/radius follow the addons unless overridden here.',
    child: _SwitchDemo(
      enabled: enabled,
      label: label,
      tooltip: tooltip.isEmpty ? null : tooltip,
      style: style,
      radiusMode: radiusMode,
    ),
  );
}

// ---------------------------------------------------------------------------
// Interactive demos (stateful) — the CTA rule does not apply: tapping the
// control itself flips it.
// ---------------------------------------------------------------------------

class _CheckboxDemo extends StatefulWidget {
  const _CheckboxDemo({
    required this.enabled,
    required this.label,
    this.tooltip,
    this.style,
    this.radiusMode,
  });

  final bool enabled;
  final String label;
  final String? tooltip;
  final AppStyle? style;
  final AppRadiusMode? radiusMode;

  @override
  State<_CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<_CheckboxDemo> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacings.s8,
      children: [
        AppCheckbox(
          checked: _checked,
          enabled: widget.enabled,
          tooltip: widget.tooltip,
          semanticLabel: widget.label,
          style: widget.style,
          radiusMode: widget.radiusMode,
          onChanged: (v) => setState(() => _checked = v),
        ),
        AppText(widget.label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo({
    required this.enabled,
    required this.label,
    this.tooltip,
    this.style,
    this.radiusMode,
  });

  final bool enabled;
  final String label;
  final String? tooltip;
  final AppStyle? style;
  final AppRadiusMode? radiusMode;

  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _on = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacings.s8,
      children: [
        AppText(widget.label, style: theme.textTheme.bodyMedium),
        AppSwitch(
          value: _on,
          enabled: widget.enabled,
          tooltip: widget.tooltip,
          semanticLabel: widget.label,
          style: widget.style,
          radiusMode: widget.radiusMode,
          onChanged: (v) => setState(() => _on = v),
        ),
      ],
    );
  }
}
