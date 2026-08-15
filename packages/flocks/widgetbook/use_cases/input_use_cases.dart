import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// input family — text field on the AppStyle + AppRadiusMode axes, plus the
// date/time/datetime and color pickers built on it. Typing/picking IS the
// interaction, so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppInput)
Widget appInputPlayground(BuildContext context) {
  final TextAlign textAlign = context.knobs.object.dropdown<TextAlign>(
    label: 'textAlign',
    options: const <TextAlign>[
      TextAlign.start,
      TextAlign.center,
      TextAlign.end,
    ],
    initialOption: TextAlign.start,
    labelBuilder: (a) => 'TextAlign.${a.name}',
  );
  final label = context.knobs.string(label: 'label', initialValue: 'E-mail');
  final hint = context.knobs.string(
    label: 'hintText',
    initialValue: 'nome@dominio.com',
  );
  final helper = context.knobs.string(label: 'helperText', initialValue: '');
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final error = context.knobs.boolean(label: 'hasError', initialValue: false);
  final prefix = context.knobs.boolean(
    label: 'prefixIcon',
    initialValue: false,
  );
  final multiline = context.knobs.boolean(
    label: 'multiline (maxLines 4)',
    initialValue: false,
  );
  final counter = context.knobs.boolean(
    label: 'showCounter (maxLength 20)',
    initialValue: false,
  );
  final info = context.knobs.boolean(
    label: 'info (popover)',
    initialValue: false,
  );
  // null (knob "Global (inherit)") → o AppInput segue o `theme.styleTheme.style`
  // global (o StyleAddon). NÃO coagir para outlined aqui, senão o filtro global
  // nunca chega ao componente.
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);
  final size = wbFieldSizeKnob(context);

  return wbUseCase(
    context,
    name: 'AppInput',
    description:
        'Text field on the AppStyle (outlined/filled/elevated) + AppRadiusMode '
        'axes. Type, focus, toggle error/disabled.',
    child: SizedBox(
      width: 320,
      child: AppInput(
        textAlign: textAlign,
        label: label.isEmpty ? null : label,
        hintText: hint.isEmpty ? null : hint,
        helperText: helper.isEmpty ? null : helper,
        enabled: enabled,
        hasError: error,
        errorText: error ? 'Campo obrigatório' : null,
        prefixIcon: prefix ? AppIconToken.search : null,
        maxLines: multiline ? 4 : 1,
        maxLength: counter ? 20 : null,
        showCounter: counter,
        info: info ? const AppText('Usamos seu e-mail só para login.') : null,
        style: style,
        radiusMode: radiusMode,
        size: size,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppDatePickerInput)
Widget appDatePickerInputPlayground(BuildContext context) {
  final label = context.knobs.string(label: 'label', initialValue: 'Data');
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final error = context.knobs.boolean(label: 'hasError', initialValue: false);
  return wbUseCase(
    context,
    name: 'AppDatePickerInput',
    description: 'Type DD/MM/AAAA or pick from the calendar overlay.',
    child: SizedBox(
      width: 320,
      child: AppDatePickerInput(
        label: label.isEmpty ? null : label,
        hintText: 'DD/MM/AAAA',
        enabled: enabled,
        hasError: error,
        errorText: error ? 'Data inválida' : null,
        onDateSelected: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppTimePickerInput)
Widget appTimePickerInputPlayground(BuildContext context) {
  final label = context.knobs.string(label: 'label', initialValue: 'Horário');
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final seconds = context.knobs.boolean(
    label: 'showSeconds',
    initialValue: false,
  );
  return wbUseCase(
    context,
    name: 'AppTimePickerInput',
    description: 'Type HH:mm (or HH:mm:ss) or pick from the wheels overlay.',
    child: SizedBox(
      width: 320,
      child: AppTimePickerInput(
        label: label.isEmpty ? null : label,
        hintText: seconds ? 'HH:mm:ss' : 'HH:mm',
        enabled: enabled,
        showSeconds: seconds,
        onTimeSelected: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppDateTimePickerInput)
Widget appDateTimePickerInputPlayground(BuildContext context) {
  final label = context.knobs.string(
    label: 'label',
    initialValue: 'Data e hora',
  );
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  return wbUseCase(
    context,
    name: 'AppDateTimePickerInput',
    description: 'Type DD/MM/AAAA HH:mm or pick from the calendar + wheels.',
    child: SizedBox(
      width: 320,
      child: AppDateTimePickerInput(
        label: label.isEmpty ? null : label,
        hintText: 'DD/MM/AAAA HH:mm',
        enabled: enabled,
        onDateTimeSelected: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppColorPickerInput)
Widget appColorPickerInputPlayground(BuildContext context) {
  final label = context.knobs.string(label: 'label', initialValue: 'Cor');
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final error = context.knobs.boolean(label: 'hasError', initialValue: false);
  final showSuggested = context.knobs.boolean(
    label: 'show suggested colors',
    initialValue: true,
  );
  final size = wbFieldSizeKnob(context);
  return wbUseCase(
    context,
    name: 'AppColorPickerInput',
    description: 'Type a #HEX or pick from the HSV panel overlay.',
    child: SizedBox(
      width: 320,
      child: _ColorDemo(
        label: label,
        enabled: enabled,
        error: error,
        showSuggestedColors: showSuggested,
        size: size,
      ),
    ),
  );
}

/// O color picker é controlado (`value`) — guarda o hex para o swatch atualizar.
class _ColorDemo extends StatefulWidget {
  const _ColorDemo({
    required this.label,
    required this.enabled,
    required this.error,
    required this.showSuggestedColors,
    required this.size,
  });

  final String label;
  final bool enabled;
  final bool error;
  final bool showSuggestedColors;
  final AppFieldSize size;

  @override
  State<_ColorDemo> createState() => _ColorDemoState();
}

class _ColorDemoState extends State<_ColorDemo> {
  String _hex = '#FF5B04';

  @override
  Widget build(BuildContext context) => AppColorPickerInput(
    label: widget.label.isEmpty ? null : widget.label,
    value: _hex,
    enabled: widget.enabled,
    hasError: widget.error,
    errorText: widget.error ? 'Cor inválida' : null,
    showSuggestedColors: widget.showSuggestedColors,
    size: widget.size,
    onChanged: (v) => setState(() => _hex = v),
  );
}

// ---------------------------------------------------------------------------
// States — a static grid of the visual states of each field.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: AppInput)
Widget appInputStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppInput',
  description: 'Every container style plus the error and disabled states.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Filled',
        when: 'Default field',
        width: 280,
        child: const SizedBox(
          width: 280,
          child: AppInput(
            label: 'E-mail',
            hintText: 'nome@dominio.com',
            style: AppStyle.filled,
          ),
        ),
      ),
      wbState(
        context,
        name: 'Outlined',
        when: 'On a busy surface',
        width: 280,
        child: const SizedBox(
          width: 280,
          child: AppInput(
            label: 'E-mail',
            hintText: 'nome@dominio.com',
            style: AppStyle.outlined,
          ),
        ),
      ),
      wbState(
        context,
        name: 'Elevated',
        when: 'Raised emphasis',
        width: 280,
        child: const SizedBox(
          width: 280,
          child: AppInput(
            label: 'E-mail',
            hintText: 'nome@dominio.com',
            style: AppStyle.elevated,
          ),
        ),
      ),
      wbState(
        context,
        name: 'Error',
        when: 'Invalid value',
        width: 280,
        child: const SizedBox(
          width: 280,
          child: AppInput(
            label: 'E-mail',
            hintText: 'nome@dominio.com',
            hasError: true,
            errorText: 'Campo obrigatório',
          ),
        ),
      ),
      wbState(
        context,
        name: 'Error + filled',
        when: 'Suffix clears the value',
        width: 280,
        child: const SizedBox(
          width: 280,
          child: AppInput(
            label: 'E-mail',
            initialValue: 'nome@dominio',
            hasError: true,
            errorText: 'E-mail inválido',
          ),
        ),
      ),
      wbState(
        context,
        name: 'Info',
        when: 'Help popover on the label',
        width: 280,
        child: const SizedBox(
          width: 280,
          child: AppInput(
            label: 'E-mail',
            hintText: 'nome@dominio.com',
            info: AppText('Usamos seu e-mail só para login.'),
          ),
        ),
      ),
      wbState(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        width: 280,
        child: const SizedBox(
          width: 280,
          child: AppInput(
            label: 'E-mail',
            hintText: 'nome@dominio.com',
            enabled: false,
          ),
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppDatePickerInput)
Widget appDatePickerInputStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDatePickerInput',
  description: 'Default, error and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Default',
        when: 'Ready to type/pick',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppDatePickerInput(
            label: 'Data',
            hintText: 'DD/MM/AAAA',
            onDateSelected: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Error',
        when: 'Invalid date',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppDatePickerInput(
            label: 'Data',
            hintText: 'DD/MM/AAAA',
            hasError: true,
            errorText: 'Data inválida',
            onDateSelected: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppDatePickerInput(
            label: 'Data',
            hintText: 'DD/MM/AAAA',
            enabled: false,
            onDateSelected: (_) {},
          ),
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppTimePickerInput)
Widget appTimePickerInputStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppTimePickerInput',
  description: 'Default, seconds and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Default',
        when: 'HH:mm',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppTimePickerInput(
            label: 'Horário',
            hintText: 'HH:mm',
            onTimeSelected: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Seconds',
        when: 'HH:mm:ss',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppTimePickerInput(
            label: 'Horário',
            hintText: 'HH:mm:ss',
            showSeconds: true,
            onTimeSelected: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppTimePickerInput(
            label: 'Horário',
            hintText: 'HH:mm',
            enabled: false,
            onTimeSelected: (_) {},
          ),
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppDateTimePickerInput)
Widget appDateTimePickerInputStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDateTimePickerInput',
  description: 'Default, error and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Default',
        when: 'Ready to type/pick',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppDateTimePickerInput(
            label: 'Data e hora',
            hintText: 'DD/MM/AAAA HH:mm',
            onDateTimeSelected: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Error',
        when: 'Invalid value',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppDateTimePickerInput(
            label: 'Data e hora',
            hintText: 'DD/MM/AAAA HH:mm',
            hasError: true,
            errorText: 'Valor inválido',
            onDateTimeSelected: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppDateTimePickerInput(
            label: 'Data e hora',
            hintText: 'DD/MM/AAAA HH:mm',
            enabled: false,
            onDateTimeSelected: (_) {},
          ),
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppColorPickerInput)
Widget appColorPickerInputStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppColorPickerInput',
  description: 'With a value, in error and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Value',
        when: 'A color is set',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppColorPickerInput(
            label: 'Cor',
            value: '#FF5B04',
            onChanged: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Error',
        when: 'Invalid hex',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppColorPickerInput(
            label: 'Cor',
            value: '#ZZZ',
            hasError: true,
            errorText: 'Cor inválida',
            onChanged: (_) {},
          ),
        ),
      ),
      wbState(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        width: 280,
        child: SizedBox(
          width: 280,
          child: AppColorPickerInput(
            label: 'Cor',
            value: '#FF5B04',
            enabled: false,
            onChanged: (_) {},
          ),
        ),
      ),
    ],
  ),
);
