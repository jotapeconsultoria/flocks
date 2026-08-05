import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppPickerAnchor]. Registrado em `flocksCatalog`.
const AppComponentMeta appPickerAnchorMeta = AppComponentMeta(
  id: 'app_picker_anchor',
  name: 'AppPickerAnchor',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.5.0',
  summary: LocalizedText(
    en: 'Generic picker anchor: a trigger that opens an anchored floating panel (date/time/color…) in an AppCard.',
    pt:
        'Âncora genérica de picker: um trigger que abre um painel flutuante '
        'ancorado (date/time/color…) num AppCard.',
  ),
  description: LocalizedText(
    en: 'No Material. The pickers\' overlay machine, decoupled from the input: it takes a trigger builder and a panel builder (both with an AppPickerHandle for open/close/toggle/rebuild), anchors through a LayerLink (transform-safe), closes on an outside click or on Esc, and re-provides the theme, the text scale and the DefaultTextStyle inside the entry. Use it in AppInput (as the picker inputs do) or on any other trigger.',
    pt:
        'Sem Material. Máquina de overlay dos pickers, desacoplada do input: '
        'recebe um builder de trigger e um builder de painel (ambos com um '
        'AppPickerHandle p/ open/close/toggle/rebuild), ancora via LayerLink '
        '(transform-safe), fecha ao clicar fora ou no Esc, e reprovê tema, text '
        'scale e DefaultTextStyle dentro da entry. Use no AppInput (como os '
        'picker inputs) ou em qualquer outro trigger.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Opening an AppDatePicker/AppTimePicker/AppColorPickerPanel from any widget (a field, a button, a chip…).',
      'Building a new "picker input" by reusing the overlay machine.',
    ],
    pt: <String>[
      'Abrir um AppDatePicker/AppTimePicker/AppColorPickerPanel a partir de '
          'qualquer widget (campo, botão, chip…).',
      'Construir um novo "picker input" reaproveitando a máquina de overlay.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A rich-content balloon with an arrow → use AppPopover.',
      'A list of selectable options → use AppDropdown.',
      'A list of actions → use AppMenu.',
    ],
    pt: <String>[
      'Balão de conteúdo rico com seta → use AppPopover.',
      'Lista de opções selecionáveis → use AppDropdown.',
      'Lista de ações → use AppMenu.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'trigger',
      type: 'Widget Function(BuildContext, AppPickerHandle)',
      isRequired: true,
      description: LocalizedText(
        en: 'Builds the trigger; call handle.open/close/toggle.',
        pt: 'Constrói o trigger; chame handle.open/close/toggle.',
      ),
    ),
    PropMeta(
      name: 'panel',
      type: 'Widget Function(BuildContext, AppPickerHandle)',
      isRequired: true,
      description: LocalizedText(
        en: 'The panel\'s content inside the AppCard.',
        pt: 'Conteúdo do painel dentro do AppCard.',
      ),
    ),
    PropMeta(
      name: 'width',
      type: 'AppPickerWidth',
      defaultValue: 'matchTrigger()',
      description: LocalizedText(
        en: 'matchTrigger({min}) matches the trigger; fixed(w) pins it.',
        pt: 'matchTrigger({min}) casa com o trigger; fixed(w) fixa.',
      ),
    ),
    PropMeta(
      name: 'placement',
      type: 'AppOverlayPlacement',
      defaultValue: 'bottomStart',
      enumValues: <String>[
        'bottomStart',
        'bottomCenter',
        'bottomEnd',
        'topStart',
        'topCenter',
        'topEnd',
      ],
    ),
    PropMeta(
      name: 'panelStyle',
      type: 'AppStyle',
      defaultValue: 'elevated',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(
      name: 'panelGlass',
      type: 'bool?',
      description: LocalizedText(
        en: 'The panel\'s glass axis (real glass through AppOverlayPanel). null follows the global glassTheme.',
        pt:
            'Eixo glass do painel (vidro real via AppOverlayPanel). null segue o '
            'global glassTheme.',
      ),
    ),
    PropMeta(name: 'panelAccentColor', type: 'Color?'),
    PropMeta(
      name: 'panelPadding',
      type: 'EdgeInsetsGeometry',
      defaultValue: 'EdgeInsets.all(s8)',
    ),
  ],
  states: <String>['closed', 'open'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Date picker from a button',
        pt: 'Date picker a partir de um botão',
      ),
      code:
          'AppPickerAnchor(trigger: (c, h) => AppButton(label: "Data", '
          'onPressed: h.open), panel: (c, h) => AppDatePicker(onDateSelected: '
          '(d) { setState(() => _date = d); h.close(); }))',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Call handle.close() in the panel\'s callback when the choice is one-shot (e.g. a date); leave it open for continuous adjustment (e.g. the time wheels).',
      'Use width.matchTrigger(min:) for fields and width.fixed() for panels with a width of their own (e.g. the color picker).',
    ],
    pt: <String>[
      'Chame handle.close() no callback do painel quando a escolha for pontual '
          '(ex.: data); deixe aberto p/ ajustes contínuos (ex.: rodas de hora).',
      'Use width.matchTrigger(min:) p/ campos e width.fixed() p/ painéis de '
          'largura própria (ex.: color picker).',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not rebuild OverlayEntry/CompositedTransformFollower by hand — that is what this component encapsulates.',
    ],
    pt: <String>[
      'Não recrie OverlayEntry/CompositedTransformFollower à mão — é o que este '
          'componente encapsula.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Closes on Esc and on an outside click (a TapRegion with a groupId — touching the trigger does not close it). The trigger must carry its own semantics.',
    pt:
        'Fecha no Esc e ao clicar fora (TapRegion com groupId — tocar o trigger '
        'não fecha). O trigger deve ter semântica própria.',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_popover',
    'app_menu',
    'app_card',
    'app_date_picker',
    'app_time_picker',
  ],
);
