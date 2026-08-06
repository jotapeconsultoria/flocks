import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppOmniSearch]. Registrado em `flocksCatalog`.
const AppComponentMeta appOmniSearchMeta = AppComponentMeta(
  id: 'app_omni_search',
  name: 'AppOmniSearch',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Global search with async autocomplete, results grouped by entity and `/` commands.',
    pt:
        'Busca global com autocomplete assíncrono, resultados agrupados por '
        'entidade e comandos `/`.',
  ),
  description: LocalizedText(
    en: 'One field, two sources. An ordinary term goes to onSearch (async, debounced, discarding out-of-order responses). A term starting with `/` does NOT: it resolves locally through AppCommandScope\'s AppCommandRegistry, which keeps commands instant and avoids sending "/logout" to the server. Results arrive grouped by entity — the block\'s label is what keeps a list mixing plate, IMEI and ICCID readable. The typed fragment is highlighted in the title. Keyboard: the arrows cross the groups, Enter picks, Esc closes; the panel never steals focus from the field.',
    pt:
        'Um campo, duas fontes. Termo comum vai para onSearch (assíncrono, com '
        'debounce e descarte de resposta fora de ordem). Termo iniciado por `/` '
        'NÃO vai: resolve local pelo AppCommandRegistry do AppCommandScope, o '
        'que mantém o comando instantâneo e evita mandar "/sair" ao servidor. '
        'Os resultados vêm agrupados por entidade — é o rótulo do bloco que faz '
        'uma lista misturando placa, IMEI e ICCID continuar legível. O trecho '
        'digitado é realçado no título. Teclado: setas atravessam os grupos, '
        'Enter escolhe, Esc fecha; o painel nunca rouba o foco do campo.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Search that crosses several entities from a single field.',
      'A command palette combined with search.',
    ],
    pt: <String>[
      'Busca que cruza várias entidades a partir de um campo só.',
      'Paleta de comandos combinada com busca.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Selection from a known fixed list → AppSearchableDropdown.',
      'Filtering a table → that toolbar\'s own field.',
    ],
    pt: <String>[
      'Seleção de uma lista fixa conhecida → AppSearchableDropdown.',
      'Filtro de uma tabela → o campo da própria toolbar.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'onSearch',
      type: 'AppOmniSearchCallback',
      isRequired: true,
      description: LocalizedText(
        en: 'Receives the trimmed, non-empty term.',
        pt: 'Recebe o termo aparado e não vazio.',
      ),
    ),
    PropMeta(name: 'controller', type: 'TextEditingController?'),
    PropMeta(
      name: 'focusNode',
      type: 'FocusNode?',
      description: LocalizedText(
        en: 'Pass your own to focus the field from outside (the `/` shortcut).',
        pt: 'Passe o seu para focar o campo de fora (atalho `/`).',
      ),
    ),
    PropMeta(name: 'hintText', type: 'String', defaultValue: "'Buscar'"),
    PropMeta(name: 'helperText', type: 'String?'),
    PropMeta(name: 'shortcutHint', type: 'String?'),
    PropMeta(
      name: 'debounce',
      type: 'Duration',
      defaultValue: 'kAppOmniSearchDebounce',
    ),
    PropMeta(
      name: 'panelMaxHeight',
      type: 'double',
      defaultValue: 'kAppOmniSearchPanelMaxHeight',
    ),
    PropMeta(
      name: 'emptyLabel',
      type: 'String',
      defaultValue: "'Nada encontrado'",
    ),
  ],
  states: <String>['idle', 'loading', 'results', 'commands', 'empty', 'error'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Fleet search', pt: 'Busca de frota'),
      code:
          'AppOmniSearch(helperText: \'Placa, chassi, CPF, CNPJ, IMEI…\', '
          'onSearch: (term) => searchCubit.search(term))',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Group by entity and name each block.',
      'Return AppOmniSearchResult.failed on error — it is different from empty.',
    ],
    pt: <String>[
      'Agrupe por entidade e nomeie cada bloco.',
      'Devolva AppOmniSearchResult.failed em erro — é diferente de vazio.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not send command terms to the server.',
      'Do not let the panel steal focus: typing would stop.',
    ],
    pt: <String>[
      'Não mande termos de comando ao servidor.',
      'Não deixe o painel roubar o foco: a digitação pararia.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Each row exposes Semantics(button:true) with a title and a subtitle; the keyboard highlight uses the same color as hover, so mouse focus and arrow focus do not look like different states.',
    pt:
        'Cada linha expõe Semantics(button:true) com título e subtítulo; o '
        'realce por teclado usa a mesma cor do hover, para foco de mouse e de '
        'seta não parecerem estados diferentes.',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_searchable_dropdown', 'app_shell'],
);
