import '../../meta/app_component_meta.dart';

// Metadados MCP dos três campos com seletor integrado. Registrados em
// `flocksCatalog`. Ficam juntos porque são a MESMA peça com máscaras e painéis
// diferentes: quem entende um entende os três.

/// Props que os três compartilham (o campo por baixo é o mesmo `AppInput`).
const List<PropMeta> _fieldProps = <PropMeta>[
  PropMeta(name: 'label', type: 'String?'),
  PropMeta(name: 'hintText', type: 'String?'),
  PropMeta(name: 'helperText', type: 'String?'),
  PropMeta(
    name: 'errorText',
    type: 'String?',
    description: LocalizedText(
      en: 'Replaces the helper on the same line (the form does not jump).',
      pt: 'Substitui o helper na mesma linha (o form não salta).',
    ),
  ),
  PropMeta(
    name: 'hasError',
    type: 'bool',
    defaultValue: 'false',
    description: LocalizedText(
      en: 'The frame only, for when the message lives somewhere else.',
      pt: 'Só a moldura, para quando a mensagem está em outro lugar.',
    ),
  ),
  PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
  PropMeta(
    name: 'info',
    type: 'Widget?',
    description: LocalizedText(
      en: 'Help in a popover beside the label.',
      pt: 'Ajuda em popover ao lado do rótulo.',
    ),
  ),
  PropMeta(
    name: 'size',
    type: 'AppFieldSize',
    defaultValue: 'AppFieldSize.m',
    enumValues: <String>['s', 'm', 'l'],
  ),
  PropMeta(name: 'style', type: 'AppStyle?'),
  PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
  PropMeta(name: 'radius', type: 'BorderRadius?'),
];

/// Descritor MCP do [AppDatePickerInput]. Registrado em `flocksCatalog`.
const AppComponentMeta appDatePickerInputMeta = AppComponentMeta(
  id: 'app_date_picker_input',
  name: 'AppDatePickerInput',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Date field: type it with a DD/MM/YYYY mask or pick it from the calendar.',
    pt: 'Campo de data: digitar com máscara DD/MM/AAAA ou escolher no calendário.',
  ),
  description: LocalizedText(
    en: 'The two doors are deliberate. Whoever knows the date types it — always faster than navigating months in a calendar — and gets an automatic mask (AppDateMaskFormatter). Whoever only knows "next Tuesday" opens the panel from the icon. The panel is an elevated AppCard anchored to the field, exactly like AppDropdown\'s: the same gesture opens a panel on any field in the form. firstDate/lastDate bound both the calendar AND what can be typed.',
    pt:
        'As duas portas de entrada convivem de propósito. Quem sabe a data '
        'digita — é sempre mais rápido que navegar meses num calendário — e '
        'ganha máscara automática (AppDateMaskFormatter). Quem só sabe "a '
        'próxima terça" abre o painel pelo ícone. O painel é um AppCard elevado, '
        'ancorado ao campo, igual ao do AppDropdown: o mesmo gesto abre painel '
        'em qualquer campo do formulário. firstDate/lastDate limitam o '
        'calendário E a digitação.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A single date in a form (a due date, the start of a validity period).',
      'A date filter in a list toolbar.',
    ],
    pt: <String>[
      'Data única num formulário (vencimento, início de vigência).',
      'Filtro por data em toolbar de listagem.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A range (from/to) → AppDateRangePicker.',
      'Date + time in the same field → AppDateTimePickerInput.',
      'A calendar kept visible on the screen → AppDatePicker directly.',
    ],
    pt: <String>[
      'Intervalo (de/até) → AppDateRangePicker.',
      'Data + hora no mesmo campo → AppDateTimePickerInput.',
      'Calendário sempre visível na tela → AppDatePicker direto.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'onDateSelected',
      type: 'ValueChanged<DateTime>',
      isRequired: true,
    ),
    PropMeta(name: 'initialDate', type: 'DateTime?'),
    PropMeta(
      name: 'firstDate',
      type: 'DateTime?',
      description: LocalizedText(
        en: 'Floor for the calendar and for validating what is typed.',
        pt: 'Piso do calendário e da validação da digitação.',
      ),
    ),
    PropMeta(
      name: 'lastDate',
      type: 'DateTime?',
      description: LocalizedText(en: 'Ceiling, likewise.', pt: 'Teto idem.'),
    ),
    ..._fieldProps,
  ],
  states: <String>['empty', 'filled', 'error', 'disabled', 'open'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Due date', pt: 'Data de vencimento'),
      code:
          'AppDatePickerInput(\n'
          "  label: 'Vencimento',\n"
          "  hintText: 'DD/MM/AAAA',\n"
          '  firstDate: DateTime.now(),\n'
          '  onDateSelected: form.setDueDate,\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Give it firstDate/lastDate — they bound the calendar and the typing at once.',
    ],
    pt: <String>[
      'Informe firstDate/lastDate — limitam calendário e digitação de uma vez.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not block typing to "force" the calendar: it is slower for someone who already knows the date.',
    ],
    pt: <String>[
      'Não bloqueie a digitação para "forçar" o calendário: é mais lento para '
          'quem já sabe a data.',
    ],
  ),
  a11y: LocalizedText(
    en: 'The field is a textField with the label as its label; the icon that opens the panel is a labelled button, not a mute glyph. The error enters as a live region, so validation is announced without the user going back to the field.',
    pt:
        'O campo é textField com o label como rótulo; o ícone que abre o painel '
        'é botão rotulado, não um glifo mudo. O erro entra como região viva, '
        'para a validação ser anunciada sem o usuário voltar ao campo.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_date_picker',
    'app_date_time_picker_input',
    'app_input',
  ],
);

/// Descritor MCP do [AppTimePickerInput]. Registrado em `flocksCatalog`.
const AppComponentMeta appTimePickerInputMeta = AppComponentMeta(
  id: 'app_time_picker_input',
  name: 'AppTimePickerInput',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Time field: type it with an HH:mm mask or pick it from the wheels.',
    pt: 'Campo de horário: digitar com máscara HH:mm ou escolher nas rodas.',
  ),
  description: LocalizedText(
    en: 'The same piece as the date field, with a time mask (AppTimeMaskFormatter) and wheels in the panel. `showSeconds` adds the third wheel and changes the mask along with it — the two always move together, otherwise the field accepts a format the panel cannot produce. The floors (minHour/minMinute/minSecond) exist for the "end time after the start time" case, where the limit depends on another field.',
    pt:
        'Mesma peça do campo de data, com máscara de horário '
        '(AppTimeMaskFormatter) e rodas no painel. `showSeconds` acrescenta a '
        'terceira roda e muda a máscara junto — as duas coisas andam sempre '
        'casadas, senão o campo aceita um formato que o painel não produz. Os '
        'pisos (minHour/minMinute/minSecond) existem para o caso "hora final '
        'depois da inicial", em que o limite muda conforme outro campo.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A standalone time (a service window, a cutoff time).',
      'A from/to pair, where the second one\'s floor comes from the first.',
    ],
    pt: <String>[
      'Horário isolado (janela de atendimento, horário de corte).',
      'Par de campos de/até, com o piso do segundo vindo do primeiro.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Date + time in the same field → AppDateTimePickerInput.',
      'A duration (2h30) → a numeric field; this is a time of day.',
    ],
    pt: <String>[
      'Data + hora no mesmo campo → AppDateTimePickerInput.',
      'Duração (2h30) → campo numérico; isto é hora do dia.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'onTimeSelected',
      type: 'ValueChanged<TimeOfDay>',
      isRequired: true,
    ),
    PropMeta(name: 'initialHour', type: 'int?'),
    PropMeta(name: 'initialMinute', type: 'int?'),
    PropMeta(name: 'initialSecond', type: 'int?'),
    PropMeta(
      name: 'showSeconds',
      type: 'bool',
      defaultValue: 'false',
      description: LocalizedText(
        en: 'Adds the seconds wheel and adjusts the mask.',
        pt: 'Acrescenta a roda de segundos e ajusta a máscara.',
      ),
    ),
    PropMeta(name: 'minHour', type: 'int', defaultValue: '0'),
    PropMeta(name: 'minMinute', type: 'int', defaultValue: '0'),
    PropMeta(name: 'minSecond', type: 'int', defaultValue: '0'),
    ..._fieldProps,
  ],
  states: <String>['empty', 'filled', 'error', 'disabled', 'open'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Service window', pt: 'Janela de atendimento'),
      code:
          'AppTimePickerInput(\n'
          "  label: 'Abre às',\n"
          "  hintText: 'HH:mm',\n"
          '  onTimeSelected: form.setOpensAt,\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use the floors when the time depends on another field.'],
    pt: <String>['Use os pisos quando o horário depende de outro campo.'],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not turn showSeconds on just "for precision": three wheels for an office hour is friction with no information.',
    ],
    pt: <String>[
      'Não ligue showSeconds só "por precisão": três rodas para um horário de '
          'expediente é fricção sem informação.',
    ],
  ),
  a11y: LocalizedText(
    en: 'A labelled textField; the icon opens the panel and is a labelled button. The panel\'s wheels are keyboard-navigable.',
    pt:
        'Campo textField rotulado; o ícone abre o painel e é botão rotulado. As '
        'rodas do painel são navegáveis por teclado.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_time_picker', 'app_date_time_picker_input'],
);

/// Descritor MCP do [AppDateTimePickerInput]. Registrado em `flocksCatalog`.
const AppComponentMeta appDateTimePickerInputMeta = AppComponentMeta(
  id: 'app_date_time_picker_input',
  name: 'AppDateTimePickerInput',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Single date + time field: a DD/MM/YYYY HH:mm mask, with the calendar and the wheels in one panel.',
    pt:
        'Campo único de data + hora: máscara DD/MM/AAAA HH:mm, calendário e '
        'rodas no mesmo painel.',
  ),
  description: LocalizedText(
    en: 'It exists for the instant that is ONE piece of data — the moment of an event, the scheduling of a command. Two separate fields let the form accept a date with no time, and then somebody picks a silent default (midnight) that nobody chose. Here the panel delivers the calendar and the wheels together, and the mask covers both at once.',
    pt:
        'Existe para o instante que é UM dado só — o momento de um evento, o '
        'agendamento de um comando. Dois campos separados deixam o formulário '
        'aceitar data sem hora, e aí alguém decide um default silencioso '
        '(meia-noite) que ninguém escolheu. Aqui o painel entrega calendário e '
        'rodas juntos, e a máscara cobre os dois de uma vez.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The exact moment of an event (scheduling, a report cutoff).',
      'A period filter with minute precision.',
    ],
    pt: <String>[
      'Momento exato de um evento (agendamento, corte de relatório).',
      'Filtro de período com precisão de minutos.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Only the date matters → AppDatePickerInput (do not ask for a time for nothing).',
      'A range of days → AppDateRangePicker.',
    ],
    pt: <String>[
      'Só a data importa → AppDatePickerInput (não peça hora à toa).',
      'Intervalo de dias → AppDateRangePicker.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'onDateTimeSelected',
      type: 'ValueChanged<DateTime>',
      isRequired: true,
    ),
    PropMeta(name: 'initialDateTime', type: 'DateTime?'),
    PropMeta(name: 'firstDate', type: 'DateTime?'),
    PropMeta(name: 'lastDate', type: 'DateTime?'),
    ..._fieldProps,
  ],
  states: <String>['empty', 'filled', 'error', 'disabled', 'open'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Scheduling a command',
        pt: 'Agendar um comando',
      ),
      code:
          'AppDateTimePickerInput(\n'
          "  label: 'Executar em',\n"
          "  hintText: 'DD/MM/AAAA HH:mm',\n"
          '  firstDate: DateTime.now(),\n'
          '  onDateTimeSelected: form.setScheduledAt,\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it when the date and the time are one piece of data.'],
    pt: <String>['Use quando data e hora formam um dado só.'],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not replace two independent fields with this one: if one can exist without the other, they are two pieces of data.',
    ],
    pt: <String>[
      'Não substitua dois campos independentes por este: se um pode existir sem '
          'o outro, são dois dados.',
    ],
  ),
  a11y: LocalizedText(
    en: 'A labelled textField with the full format in the hint; the panel combines the calendar and the wheels into a single keyboard-navigable node.',
    pt:
        'Campo textField rotulado com o formato completo no hint; o painel '
        'combina calendário e rodas num só nó navegável por teclado.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_date_picker_input', 'app_time_picker_input'],
);
