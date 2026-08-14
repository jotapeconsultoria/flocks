import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppChoiceChip`. Registrado em `flocksCatalog`.
const AppComponentMeta appChoiceChipMeta = AppComponentMeta(
  id: 'app_choice_chip',
  name: 'AppChoiceChip',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Selectable chip — one option of a set, with an optional count.',
    pt: 'Chip selecionável — uma opção de um conjunto, com contador opcional.',
  ),
  description: LocalizedText(
    en: 'The third chip of the package and the only one with CHOICE state: AppFilterChip shows a filter already applied, AppSuggestionChip invites an action, this one answers "which of these is in effect". One target under TOGGLE semantics (checked/inMutuallyExclusiveGroup). Selected paints the filled accent — the SAME appFilledButtonColors resolver of the primary role that AppSegmentedButton consumes, so the two cannot drift; unselected is the AppStyle axis container with a neutral hover veil. Selection changes label weight AND fill, never one alone. The count pill (fg at 18%) exists because in a filter bar the number is part of the decision; count: null renders nothing, count: 0 renders "0". Minimum height 40, growing with text scale.',
    pt:
        'O terceiro chip do pacote e o único com estado de ESCOLHA: o '
        'AppFilterChip mostra um filtro já aplicado, o AppSuggestionChip '
        'convida a uma ação, este responde "qual destes está valendo". UM alvo '
        'sob semântica de TOGGLE (checked/inMutuallyExclusiveGroup). '
        'Selecionado pinta o acento preenchido — o MESMO resolvedor '
        'appFilledButtonColors do papel primary que o AppSegmentedButton '
        'consome, para os dois não divergirem; não-selecionado é o container '
        'do eixo AppStyle com véu neutro de hover. A seleção muda peso do '
        'rótulo E preenchimento, nunca um só. A pílula do contador (fg a 18%) '
        'existe porque numa barra de filtros o número é parte da decisão; '
        'count: null não renderiza nada, count: 0 renderiza "0". Altura '
        'mínima 40, crescendo com o text-scale.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A status filter bar on top of a list (queues with counts).',
      'A period/group selector where the current choice must stay visible.',
      'Multi-selection over a small set, inside an AppChoiceChipBar.multi.',
    ],
    pt: <String>[
      'Barra de filtros de status no topo de uma lista (filas com contagem).',
      'Seletor de período/grupo onde a escolha atual fica visível.',
      'Multi-seleção num conjunto pequeno, num AppChoiceChipBar.multi.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A filter already applied that the user removes → AppFilterChip.',
      'A one-shot suggestion → AppSuggestionChip.',
      'Few same-width options with a sliding pill → AppSegmentedButton.',
    ],
    pt: <String>[
      'Filtro já aplicado que o usuário tira → AppFilterChip.',
      'Sugestão de um toque → AppSuggestionChip.',
      'Poucas opções de largura igual com pílula → AppSegmentedButton.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'label', type: 'String', isRequired: true),
    PropMeta(name: 'selected', type: 'bool', isRequired: true),
    PropMeta(
      name: 'onChanged',
      type: 'ValueChanged<bool>?',
      description: LocalizedText(
        en: 'Called with the NEW selected value. `null` = read-only.',
        pt: 'Chamado com o valor NOVO de selected. `null` = somente-leitura.',
      ),
    ),
    PropMeta(
      name: 'count',
      type: 'int?',
      description: LocalizedText(
        en: '`null` hides the pill; `0` renders "0" — the caller decides.',
        pt: '`null` esconde a pílula; `0` renderiza "0" — o chamador decide.',
      ),
    ),
    PropMeta(name: 'icon', type: 'String?'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(
      name: 'mutuallyExclusive',
      type: 'bool',
      defaultValue: 'true',
      description: LocalizedText(
        en: 'Radio-like group announcement. Set false for multi-selection.',
        pt: 'Anúncio de grupo exclusivo. false para multi-seleção.',
      ),
    ),
    PropMeta(
      name: 'semanticLabel',
      type: 'String?',
      description: LocalizedText(
        en: 'Full announced phrase — NAME THE UNIT when there is a count.',
        pt: 'Frase anunciada inteira — NOMEIE A UNIDADE quando houver count.',
      ),
    ),
    PropMeta(name: 'tooltip', type: 'String?'),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(
      name: 'radiusMode',
      type: 'AppRadiusMode?',
      enumValues: <String>['reto', 'redondo', 'circular', 'padrao'],
    ),
    PropMeta(name: 'radius', type: 'double?'),
    PropMeta(name: 'statesController', type: 'FlocksStatesController?'),
  ],
  states: <String>[
    'selected',
    'unselected',
    'hovered',
    'focused',
    'pressed',
    'disabled',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Queue filter', pt: 'Filtro de fila'),
      code:
          "AppChoiceChip(label: 'Novos', count: 8, selected: f == 'queue', "
          "semanticLabel: 'Novos, 8 conversas na fila', "
          "onChanged: (_) => pick('queue'))",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Pass semanticLabel naming the unit whenever there is a count.',
      'Keep labels short; the chip ellipsizes at one line.',
    ],
    pt: <String>[
      'Passe semanticLabel nomeando a unidade sempre que houver count.',
      'Rótulos curtos; o chip corta em uma linha com elipse.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not glue the count into the label ("Novos (8)") — alignment dies.',
      'Do not use it for an applied filter — that is AppFilterChip.',
    ],
    pt: <String>[
      'Não cole o count no rótulo ("Novos (8)") — o alinhamento morre.',
      'Não o use para filtro aplicado — isso é AppFilterChip.',
    ],
  ),
  a11y: LocalizedText(
    en: 'One toggle node: checked, inMutuallyExclusiveGroup (default on), hasEnabledState. Default label is "<label> (<count>)" — which does NOT name the unit; a bar with counts should pass semanticLabel ("Novos, 8 conversas na fila"). tooltip reaches Semantics.tooltip. The focus ring has no duration and survives reduce-motion. Minimum height 40 is registered tap-target debt (the AppButton size-s number); give the bar extra padding on touch-first screens.',
    pt:
        'Um nó toggle: checked, inMutuallyExclusiveGroup (default ligado), '
        'hasEnabledState. O rótulo default é "<label> (<count>)" — que NÃO '
        'nomeia a unidade; barra com contador deve passar semanticLabel '
        '("Novos, 8 conversas na fila"). tooltip chega a Semantics.tooltip. O '
        'anel de foco não tem duração e sobrevive ao reduce-motion. A altura '
        'mínima 40 é dívida registrada de alvo de toque (o mesmo número do '
        'AppButton s); dê respiro extra à barra em telas de toque.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_choice_chip_bar',
    'app_filter_chip',
    'app_suggestion_chip',
    'app_segmented_button',
  ],
);

/// Descritor MCP do `AppChoiceChipBar`. Registrado em `flocksCatalog`.
const AppComponentMeta appChoiceChipBarMeta = AppComponentMeta(
  id: 'app_choice_chip_bar',
  name: 'AppChoiceChipBar',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Row of AppChoiceChip with single or multiple selection — the filter bar.',
    pt: 'Fila de AppChoiceChip com seleção única ou múltipla — a barra de filtros.',
  ),
  description: LocalizedText(
    en: 'Exists because AppSegmentedButton does not scroll: it equalizes cells by the widest label so its pill can slide, and six statuses of very different widths overflow the line. This bar trades the sliding pill for scrolling — each chip hugs its own content. It brings what a hand-rolled row loses: arrow keys walk the chips (the AppSegmentedButton keyboard, copied), the focused chip is scrolled into view, and the scrolled edges get an AppScrollEdgeFade veil instead of a hard cut. Options are data (AppChoiceChipOption<T>); the default constructor is single-selection (T? value + ValueChanged<T>), .multi takes a Set<T> and always hands back a NEW set.',
    pt:
        'Existe porque o AppSegmentedButton não rola: ele iguala as células '
        'pela largura do maior rótulo para a pílula deslizar, e seis status de '
        'larguras muito diferentes estouram a linha. Esta barra troca a pílula '
        'deslizante pela rolagem — cada chip abraça o próprio conteúdo. Traz o '
        'que a fila feita à mão perde: setas andam pelos chips (o teclado do '
        'AppSegmentedButton, copiado), o chip focado é rolado até aparecer, e '
        'as bordas roladas ganham véu de AppScrollEdgeFade em vez de corte '
        'seco. Opções são dado (AppChoiceChipOption<T>); o construtor default '
        'é seleção única (T? value + ValueChanged<T>), o .multi recebe Set<T> '
        'e devolve SEMPRE um conjunto novo.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A one-of-N filter bar that must not push the content down (scroll).',
      'A multi-selection over chips inside a form (.multi + wrap).',
    ],
    pt: <String>[
      'Barra 1-de-N que não pode empurrar o conteúdo para baixo (scroll).',
      'Multi-seleção por chips dentro de um formulário (.multi + wrap).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Two to four same-width options → AppSegmentedButton.',
      'Applied, removable filters → a row of AppFilterChip.',
    ],
    pt: <String>[
      'Duas a quatro opções de largura igual → AppSegmentedButton.',
      'Filtros aplicados e removíveis → uma fila de AppFilterChip.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'options',
      type: 'List<AppChoiceChipOption<T>>',
      isRequired: true,
    ),
    PropMeta(
      name: 'value',
      type: 'T?',
      isRequired: true,
      description: LocalizedText(
        en: 'Single-selection constructor: the chosen value; null = none.',
        pt: 'Construtor de seleção única: o valor escolhido; null = nenhum.',
      ),
    ),
    PropMeta(
      name: 'onChanged',
      type: 'ValueChanged<T> | ValueChanged<Set<T>>',
      isRequired: true,
      description: LocalizedText(
        en: 'Single: the tapped value. Multi: a NEW set (never a mutation).',
        pt: 'Única: o valor tocado. Multi: um conjunto NOVO (nunca mutação).',
      ),
    ),
    PropMeta(
      name: 'layout',
      type: 'AppChoiceChipLayout',
      defaultValue: 'scroll (single) / wrap (multi)',
      enumValues: <String>['scroll', 'wrap'],
    ),
    PropMeta(name: 'spacing', type: 'double', defaultValue: 'AppSpacings.s8'),
    PropMeta(name: 'padding', type: 'EdgeInsets', defaultValue: 'zero'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(
      name: 'semanticLabel',
      type: 'String?',
      description: LocalizedText(
        en: 'Names the GROUP for the screen reader ("Filtrar por status").',
        pt: 'Nomeia o GRUPO para o leitor de tela ("Filtrar por status").',
      ),
    ),
    PropMeta(
      name: 'fadeColor',
      type: 'Color?',
      description: LocalizedText(
        en: 'Where the edge veil fades from. Default surface; use surfaceContainer inside a card.',
        pt: 'De onde o véu parte. Default surface; use surfaceContainer num card.',
      ),
    ),
    PropMeta(name: 'controller', type: 'ScrollController?'),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(
      name: 'radiusMode',
      type: 'AppRadiusMode?',
      enumValues: <String>['reto', 'redondo', 'circular', 'padrao'],
    ),
    PropMeta(name: 'radius', type: 'double?'),
  ],
  variants: <String>['singleChoice', 'multipleChoice', 'horizontal'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Status filter bar', pt: 'Barra de status'),
      code:
          'AppChoiceChipBar<String>(value: filtro, onChanged: setFiltro, '
          "semanticLabel: 'Filtrar por status', options: [ "
          "AppChoiceChipOption(value: 'all', label: 'Todas'), "
          "AppChoiceChipOption(value: 'queue', label: 'Novos', count: 8)])",
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Audience multi-select',
        pt: 'Multi de audiência',
      ),
      code:
          'AppChoiceChipBar<String>.multi(values: selecionados, '
          'onChanged: (next) => setState(() => selecionados = next), '
          'options: opcoes)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Name the group (semanticLabel) — six loose toggles say nothing.',
      'Use scroll on top of lists; wrap inside forms.',
    ],
    pt: <String>[
      'Nomeie o grupo (semanticLabel) — seis toggles soltos não dizem nada.',
      'Use scroll no topo de listas; wrap dentro de formulários.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not mutate the Set you received in .multi — it hands back a new one.',
      'Do not hide the only selected option off-screen without the veil.',
    ],
    pt: <String>[
      'Não mute o Set recebido no .multi — ele devolve um novo.',
      'Não esconda a única opção selecionada fora da tela sem o véu.',
    ],
  ),
  a11y: LocalizedText(
    en: 'The bar is a named group (menu node with semanticLabel) of toggle chips; without the name the reader hears loose toggles. Left/Right arrows move focus chip to chip and the focused chip is scrolled into view with a motion-axis duration (instant under reduce-motion). In .multi the chips drop inMutuallyExclusiveGroup.',
    pt:
        'A barra é um grupo NOMEADO (nó de menu com semanticLabel) de chips '
        'toggle; sem o nome o leitor ouve toggles soltos. Setas ←/→ movem o '
        'foco chip a chip e o focado é rolado até aparecer com duração do eixo '
        'de motion (instantâneo sob reduce-motion). No .multi os chips perdem '
        'o inMutuallyExclusiveGroup.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_choice_chip',
    'app_segmented_button',
    'app_scroll_edge_fade',
  ],
);
