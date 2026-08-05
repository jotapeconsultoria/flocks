import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppColorPickerPanel — the HSV panel content (reused inside
// AppColorPickerInput). Dragging/picking IS the interaction, so there is NO CTA.
// ---------------------------------------------------------------------------

const List<Color> _customPresets = <Color>[
  Color(0xFFFF5B04),
  Color(0xFF1E88E5),
  Color(0xFF43A047),
  Color(0xFF8E24AA),
];

@widgetbook.UseCase(name: 'Playground', type: AppColorPickerPanel)
Widget appColorPickerPanelPlayground(BuildContext context) {
  final Color initial =
      wbSemanticColorKnob(
        context,
        label: 'initial color',
        initial: WbColorOption.primary,
      ) ??
      AppTheme.of(context).colorTheme.primary;
  final bool custom = context.knobs.boolean(
    label: 'custom presets',
    initialValue: false,
  );
  final bool showSuggested = context.knobs.boolean(
    label: 'show suggested colors',
    initialValue: true,
  );
  return wbUseCase(
    context,
    name: 'AppColorPickerPanel',
    description:
        'HSV panel: a saturation/brightness area, a hue bar and preset '
        'swatches (defaults to the suggested palette unless overridden). '
        'The hex is editable via the pencil icon.',
    child: SizedBox(
      width: 280,
      child: _ColorPanelDemo(
        initialColor: initial,
        presets: custom ? _customPresets : null,
        showSuggestedColors: showSuggested,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppColorPickerPanel)
Widget appColorPickerPanelStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppColorPickerPanel',
  description: 'Default palette, custom presets and a different initial color.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Default palette',
        when: 'Suggested presets',
        width: 280,
        child: const SizedBox(
          width: 280,
          child: _ColorPanelDemo(initialColor: Color(0xFFFF5B04)),
        ),
      ),
      wbState(
        context,
        name: 'Custom presets',
        when: 'Caller-supplied swatches',
        width: 280,
        child: const SizedBox(
          width: 280,
          child: _ColorPanelDemo(
            initialColor: Color(0xFF1E88E5),
            presets: _customPresets,
          ),
        ),
      ),
      wbState(
        context,
        name: 'Green',
        when: 'Another hue',
        width: 280,
        child: const SizedBox(
          width: 280,
          child: _ColorPanelDemo(initialColor: Color(0xFF43A047)),
        ),
      ),
    ],
  ),
);

/// O painel é controlado (`color`); guarda a cor atual p/ o preview atualizar.
class _ColorPanelDemo extends StatefulWidget {
  const _ColorPanelDemo({
    required this.initialColor,
    this.presets,
    this.showSuggestedColors = true,
  });

  final Color initialColor;
  final List<Color>? presets;
  final bool showSuggestedColors;

  @override
  State<_ColorPanelDemo> createState() => _ColorPanelDemoState();
}

class _ColorPanelDemoState extends State<_ColorPanelDemo> {
  late Color _color = widget.initialColor;

  @override
  void didUpdateWidget(_ColorPanelDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != oldWidget.initialColor) {
      _color = widget.initialColor;
    }
  }

  @override
  Widget build(BuildContext context) => AppColorPickerPanel(
    color: _color,
    presets: widget.presets,
    showSuggestedColors: widget.showSuggestedColors,
    onColorChanged: (c) => setState(() => _color = c),
  );
}
