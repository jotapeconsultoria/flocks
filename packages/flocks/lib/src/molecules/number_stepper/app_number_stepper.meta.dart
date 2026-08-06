import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppNumberStepper]. Registrado em `flocksCatalog`.
const AppComponentMeta appNumberStepperMeta = AppComponentMeta(
  id: 'app_number_stepper',
  name: 'AppNumberStepper',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Numeric control − value + (min/max/step), with no text editing.',
    pt: 'Controle numérico − valor + (min/max/step), sem edição de texto.',
  ),
  description: LocalizedText(
    en: 'Decrements / displays / increments. The − disables at min and the + at max. No editable field (that would be an organism/AppInput).',
    pt:
        'Decrementa / exibe / incrementa. O − desabilita em min e o + em max. '
        'Sem campo editável (isso seria organism/AppInput).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Small quantities with discrete steps (items, copies, minutes).',
    ],
    pt: <String>[
      'Quantidades pequenas com passos discretos (itens, cópias, minutos).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Free or wide numeric input → a text field (AppInput, organism).',
      'Choosing from fixed options → AppDropdown/AppSegmentedButton.',
    ],
    pt: <String>[
      'Entrada numérica livre/ampla → campo de texto (AppInput, organism).',
      'Escolher de opções fixas → AppDropdown/AppSegmentedButton.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'value', type: 'num', isRequired: true),
    PropMeta(name: 'onChanged', type: 'ValueChanged<num>', isRequired: true),
    PropMeta(name: 'min', type: 'num', defaultValue: '0'),
    PropMeta(name: 'max', type: 'num', defaultValue: 'double.infinity'),
    PropMeta(name: 'step', type: 'num', defaultValue: '1'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'size', type: 'AppButtonSize', defaultValue: 'm'),
    PropMeta(name: 'format', type: 'String Function(num)?'),
  ],
  states: <String>['enabled', 'at-min', 'at-max', 'disabled'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Quantity 1–99', pt: 'Quantidade 1–99'),
      code: 'AppNumberStepper(value: qty, min: 1, max: 99, onChanged: setQty)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Set min/max; use format for units or currency.'],
    pt: <String>['Defina min/max; use format para unidades/moeda.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for wide numeric input (use a field).'],
    pt: <String>['Não use para entrada numérica ampla (use um campo).'],
  ),
  a11y: LocalizedText(
    en: 'The − and the + are labelled buttons (Decrease/Increase) and disable at the limits. The value is a status region (announced when it changes).',
    pt:
        'O − e o + são botões rotulados (Diminuir/Aumentar) e desabilitam nos '
        'limites. O valor é uma região de status (anunciada ao mudar).',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_interaction'],
);
