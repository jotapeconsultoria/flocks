import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppTimePicker]. Registrado em `flocksCatalog`.
const AppComponentMeta appTimePickerMeta = AppComponentMeta(
  id: 'app_time_picker',
  name: 'AppTimePicker',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Hour/minute (and second) wheels in 24h format, with finite scrolling.',
    pt: 'Rodas de hora/minuto (e segundo) em formato 24h, com scroll finito.',
  ),
  description: LocalizedText(
    en: 'The bare time panel — no field, no overlay. The wheels are FINITE, not circular: the list stops at 00 and at 23, so the user feels where the ends are instead of spinning forever looking for the beginning. Always 24h, because the product is operational (shift rosters, service windows) and AM/PM introduces a 12-hour error that goes unnoticed. Values below the minimum appear DISABLED, not gone: the wheel keeps the same height and the user sees that a limit exists, instead of thinking the list starts there.',
    pt:
        'O painel de horário nu — sem campo, sem overlay. As rodas são FINITAS, '
        'não circulares: a lista para em 00 e em 23, então o usuário sente onde '
        'estão os extremos em vez de girar sem fim procurando o começo. Formato '
        '24h sempre, porque o produto é operacional (escala, janela de '
        'atendimento) e AM/PM introduz um erro de 12 horas que passa '
        'despercebido. Valores abaixo do mínimo aparecem DESABILITADOS, não '
        'sumidos: a roda mantém a mesma altura e o usuário vê que existe um '
        'limite, em vez de achar que a lista começa ali.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A hand-assembled time panel (AppTimePickerInput uses this one underneath).',
      'Time selection kept visible on a screen.',
    ],
    pt: <String>[
      'Painel de horário montado à mão (o AppTimePickerInput usa este por baixo).',
      'Seleção de hora sempre visível numa tela.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A form field → AppTimePickerInput (it brings the mask and typing).',
      'A duration (2h30) → a numeric field; this is a time of day.',
    ],
    pt: <String>[
      'Campo de formulário → AppTimePickerInput (traz máscara e digitação).',
      'Duração (2h30) → campo numérico; isto é hora do dia.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'onTimeSelected',
      type: 'ValueChanged<({int hour, int minute, int second})>',
      isRequired: true,
    ),
    PropMeta(name: 'initialHour', type: 'int', defaultValue: '0'),
    PropMeta(name: 'initialMinute', type: 'int', defaultValue: '0'),
    PropMeta(name: 'initialSecond', type: 'int', defaultValue: '0'),
    PropMeta(
      name: 'minHour',
      type: 'int',
      defaultValue: '0',
      description: LocalizedText(
        en: 'Floor; values below it are disabled.',
        pt: 'Piso; abaixo dele os valores ficam desabilitados.',
      ),
    ),
    PropMeta(name: 'minMinute', type: 'int', defaultValue: '0'),
    PropMeta(name: 'minSecond', type: 'int', defaultValue: '0'),
    PropMeta(
      name: 'showSeconds',
      type: 'bool',
      defaultValue: 'false',
      description: LocalizedText(
        en: 'Adds the third wheel.',
        pt: 'Acrescenta a terceira roda.',
      ),
    ),
  ],
  states: <String>['item-selected', 'adjacent-items', 'below-min (disabled)'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Time panel', pt: 'Painel de horário'),
      code:
          'AppTimePicker(\n'
          '  initialHour: 8,\n'
          '  onTimeSelected: (({int hour, int minute, int second}) t) =>\n'
          '      form.setTime(t.hour, t.minute),\n'
          ')',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'The end time cannot precede the start',
        pt: 'Hora final não pode ser antes da inicial',
      ),
      code:
          'AppTimePicker(\n'
          '  minHour: start.hour,\n'
          '  minMinute: start.minute,\n'
          '  onTimeSelected: form.setEnd,\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use the floors to tie the end time to the start instead of validating afterwards.',
    ],
    pt: <String>[
      'Use os pisos para amarrar a hora final à inicial em vez de validar depois.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not turn showSeconds on "for precision": three wheels for an office hour is friction with no information.',
    ],
    pt: <String>[
      'Não ligue showSeconds "por precisão": três rodas para um horário de '
          'expediente é fricção sem informação.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Each wheel is a keyboard-navigable list whose current value is announced on change; disabled ones announce the state instead of disappearing, so the limit is perceivable without seeing the color.',
    pt:
        'Cada roda é uma lista navegável por teclado, com o valor corrente '
        'anunciado ao mudar; os desabilitados anunciam o estado em vez de '
        'sumirem, para o limite ser perceptível sem enxergar a cor.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_time_picker_input', 'app_date_time_picker_input'],
);
