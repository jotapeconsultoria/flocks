import '../../meta/app_component_meta.dart';

// Metadados MCP dos calendários. Registrados em `flocksCatalog`.

/// Descritor MCP do [AppDatePicker]. Registrado em `flocksCatalog`.
const AppComponentMeta appDatePickerMeta = AppComponentMeta(
  id: 'app_date_picker',
  name: 'AppDatePicker',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Single-date calendar: a day grid, month navigation and a direct jump to year/month.',
    pt:
        'Calendário de data única: grade de dias, navegação por mês e salto '
        'direto para ano/mês.',
  ),
  description: LocalizedText(
    en: 'The bare calendar — no field, no overlay. Whoever mounts the panel decides where it lives (AppDatePickerInput opens it anchored; a scheduling screen keeps it fixed). Clicking the header label swaps the day grid for the year/month grid: without that, picking a date of birth costs dozens of taps on the chevron. `markToday` is opt-in because "today" only helps when the chosen date is near today — in a historical calendar it becomes noise; and `today` is injectable so the test does not depend on the clock.',
    pt:
        'O calendário nu — sem campo, sem overlay. Quem monta o painel decide '
        'onde ele vive (o AppDatePickerInput o abre ancorado; uma tela de '
        'agenda o deixa fixo). Clicar no rótulo do cabeçalho troca a grade de '
        'dias pela de ano/mês: sem isso, escolher uma data de nascimento custa '
        'dezenas de toques no chevron. `markToday` é opt-in porque o "hoje" só '
        'ajuda quando a data escolhida é perto de hoje — num calendário de '
        'histórico ele vira ruído; e `today` é injetável para o teste não '
        'depender do relógio.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A calendar kept visible on a screen (scheduling, a report).',
      'The panel of a hand-assembled date field.',
    ],
    pt: <String>[
      'Calendário sempre visível numa tela (agenda, relatório).',
      'Painel de um campo de data montado à mão.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A form field → AppDatePickerInput (it brings the mask and validation).',
      'A from/to range → AppDateRangePicker.',
    ],
    pt: <String>[
      'Campo de formulário → AppDatePickerInput (traz máscara e validação).',
      'Intervalo de/até → AppDateRangePicker.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'initialDate', type: 'DateTime', isRequired: true),
    PropMeta(
      name: 'onDateSelected',
      type: 'ValueChanged<DateTime>',
      isRequired: true,
    ),
    PropMeta(
      name: 'firstDate',
      type: 'DateTime?',
      description: LocalizedText(
        en: 'Earlier days are disabled, not hidden.',
        pt: 'Dias anteriores ficam desabilitados, não escondidos.',
      ),
    ),
    PropMeta(name: 'lastDate', type: 'DateTime?'),
    PropMeta(
      name: 'markToday',
      type: 'bool',
      defaultValue: 'false',
      description: LocalizedText(
        en: 'Highlights today. Opt-in.',
        pt: 'Realça o dia de hoje. Opt-in.',
      ),
    ),
    PropMeta(
      name: 'today',
      type: 'DateTime?',
      description: LocalizedText(
        en: 'Injects "today" — it is what makes the component testable.',
        pt: 'Injeta "hoje" — é o que torna o componente testável.',
      ),
    ),
  ],
  states: <String>[
    'day-selected',
    'today',
    'out-of-range (disabled)',
    'hover',
    'year-month-grid',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Calendar fixed on a screen',
        pt: 'Calendário fixo numa tela',
      ),
      code:
          'AppDatePicker(\n'
          '  initialDate: DateTime.now(),\n'
          '  markToday: true,\n'
          '  onDateSelected: controller.select,\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Inject `today` in tests instead of depending on the machine\'s clock.',
    ],
    pt: <String>[
      'Injete `today` nos testes em vez de depender do relógio da máquina.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not hide days outside the range: disabled ones keep the grid stable.',
    ],
    pt: <String>[
      'Não esconda dias fora do intervalo: desabilitados mantêm a grade estável.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Each day is a button labelled with the date spelled out; disabled ones announce the state instead of disappearing. The header is a button (it opens the year/month grid), not decorative text.',
    pt:
        'Cada dia é um botão rotulado com a data por extenso; os desabilitados '
        'anunciam o estado em vez de sumirem. O cabeçalho é botão (abre a grade '
        'de ano/mês), não texto decorativo.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_date_range_picker', 'app_date_picker_input'],
);

/// Descritor MCP do [AppDateRangePicker]. Registrado em `flocksCatalog`.
const AppComponentMeta appDateRangePickerMeta = AppComponentMeta(
  id: 'app_date_range_picker',
  name: 'AppDateRangePicker',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Range calendar: one tap for the start, another for the end.',
    pt: 'Calendário de intervalo: um toque no início, outro no fim.',
  ),
  description: LocalizedText(
    en: 'A single month, navigated with the arrows. The range is drawn as a CONTINUOUS band behind the days — half a cell on the first and the last, a whole cell in between — so the selection reads as a stretch and not as a collection of marked days. While only the start is chosen, hover previews the band up to the day under the cursor: it is the answer to "how long does this cover?" before the second tap.',
    pt:
        'Mês único, navegável pelas setas. O intervalo é desenhado como uma '
        'banda CONTÍNUA por trás dos dias — meia célula no primeiro e no último, '
        'célula inteira no meio — para a seleção ler como uma faixa e não como '
        'uma coleção de dias marcados. Enquanto só há início escolhido, o hover '
        'pré-visualiza a banda até o dia sob o cursor: é a resposta à pergunta '
        '"quanto tempo isso pega?" antes do segundo toque.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The period of a report or a filter (from/to).',
      'A validity window.',
    ],
    pt: <String>[
      'Período de um relatório ou filtro (de/até).',
      'Janela de vigência.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A single date → AppDatePicker.',
      'A period with a time → two AppDateTimePickerInputs.',
    ],
    pt: <String>[
      'Data única → AppDatePicker.',
      'Período com hora → dois AppDateTimePickerInput.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'onRangeSelected',
      type: 'ValueChanged<AppDateRange>',
      isRequired: true,
    ),
    PropMeta(name: 'initialRange', type: 'AppDateRange?'),
    PropMeta(name: 'firstDate', type: 'DateTime?'),
    PropMeta(name: 'lastDate', type: 'DateTime?'),
    PropMeta(name: 'markToday', type: 'bool', defaultValue: 'false'),
    PropMeta(
      name: 'today',
      type: 'DateTime?',
      description: LocalizedText(
        en: 'Injects "today" — it is what makes the component testable.',
        pt: 'Injeta "hoje" — é o que torna o componente testável.',
      ),
    ),
  ],
  states: <String>[
    'nothing-picked',
    'start-only',
    'hover-preview',
    'range-closed',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Period of a report',
        pt: 'Período de um relatório',
      ),
      code:
          'AppDateRangePicker(\n'
          '  lastDate: DateTime.now(),\n'
          '  onRangeSelected: filters.setPeriod,\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Bound it with lastDate when the future makes no sense.'],
    pt: <String>['Limite com lastDate quando o futuro não faz sentido.'],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not demand an order: tapping the end before the start should swap them, not error.',
    ],
    pt: <String>[
      'Não exija ordem: tocar no fim antes do início deve inverter, não errar.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Each day is a labelled button; the day that opens and the one that closes the range announce their role, so the stretch does not depend on background color alone.',
    pt:
        'Cada dia é botão rotulado; o dia que abre e o que fecha o intervalo '
        'anunciam o papel, para a faixa não depender só da cor de fundo.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_date_picker'],
);
