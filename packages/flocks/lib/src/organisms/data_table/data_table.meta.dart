import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppDataTable]. Registrado em `flocksCatalog`.
const AppComponentMeta appDataTableMeta = AppComponentMeta(
  id: 'app_data_table',
  name: 'AppDataTable',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Paginated table with per-column sorting (the backoffice grids).',
    pt: 'Tabela paginada com ordenação por coluna (grids do backoffice).',
  ),
  description: LocalizedText(
    en: 'A generic grid: labelled columns, rows of widgets, pagination (page/perPage/total) and per-column sorting (none→desc→asc). It supports click, right-click and row selection. No Material — the sort header\'s tooltip uses AppTooltip. Colors 100% from the theme.',
    pt:
        'Grid genérico: colunas rotuladas, linhas de widgets, paginação '
        '(page/perPage/total) e ordenação por coluna (none→desc→asc). Suporta '
        'clique/clique-direito/seleção de linha. Sem Material — o tooltip do '
        'header de ordenação usa AppTooltip. Cores 100% do tema.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Paginated backoffice listings (CRUDs) with sorting and row actions.',
    ],
    pt: <String>[
      'Listagens paginadas do backoffice (CRUDs) com ordenação e ações de linha.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A short static table, with no pagination or sorting → AppSimpleDataTable.',
    ],
    pt: <String>[
      'Tabela estática curta, sem paginação/ordenação → AppSimpleDataTable.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'columnLabels', type: 'List<String>', isRequired: true),
    PropMeta(name: 'rows', type: 'List<List<Widget>>', isRequired: true),
    PropMeta(name: 'page', type: 'int', isRequired: true),
    PropMeta(name: 'perPage', type: 'int', isRequired: true),
    PropMeta(name: 'total', type: 'int', isRequired: true),
    PropMeta(name: 'totalPages', type: 'int', isRequired: true),
    PropMeta(name: 'columnSortOrders', type: 'List<AppDataTableSortOrder>?'),
    PropMeta(name: 'onColumnSortTap', type: 'void Function(int)?'),
    PropMeta(name: 'onRowTap', type: 'void Function(int)?'),
    PropMeta(name: 'selectedRowIndex', type: 'int?'),
  ],
  states: <String>['default', 'sorted', 'row-selected'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Paginated grid', pt: 'Grid paginado'),
      code:
          'AppDataTable(columnLabels: cols, rows: rows, page: page, '
          'perPage: 16, total: total, totalPages: pages, '
          'onPageChange: cubit.setPage, onPerPageChange: cubit.setPerPage)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Pagination is server-side; pass the counters coming from the backend.',
    ],
    pt: <String>[
      'Paginação é server-side; passe os contadores vindos do backend.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for a few fixed rows (AppSimpleDataTable).'],
    pt: <String>['Não use para poucas linhas fixas (AppSimpleDataTable).'],
  ),
  a11y: LocalizedText(
    en: 'Sort headers with an AppTooltip describe the next state. The colors (surface/onSurface/outline) pass AA in light and dark.',
    pt:
        'Headers de ordenação com AppTooltip descrevem o próximo estado. Cores '
        '(surface/onSurface/outline) passam AA em claro/escuro.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_simple_data_table', 'app_pagination'],
);

/// Descritor MCP do [AppSimpleDataTable]. Registrado em `flocksCatalog`.
const AppComponentMeta appSimpleDataTableMeta = AppComponentMeta(
  id: 'app_simple_data_table',
  name: 'AppSimpleDataTable',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Static table (header + rows), with no sorting or pagination.',
    pt: 'Tabela estática (header + linhas), sem ordenação/paginação.',
  ),
  description: LocalizedText(
    en: 'A simple grid: labelled columns and rows of widgets, with no pagination and no sorting. Ideal for short blocks (e.g. assistant replies). Colors 100% from the theme; selectable text (AppSelectionRegion).',
    pt:
        'Grid simples: colunas rotuladas e linhas de widgets, sem paginação nem '
        'ordenação. Ideal para blocos curtos (ex.: respostas do assistente). '
        'Cores 100% do tema; texto selecionável (AppSelectionRegion).',
  ),
  whenToUse: LocalizedList(
    en: <String>['Showing a few fixed rows with a header.'],
    pt: <String>['Mostrar poucas linhas fixas com cabeçalho.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A large paginated listing with sorting → AppDataTable.'],
    pt: <String>['Listagem grande/paginada com ordenação → AppDataTable.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'columnLabels', type: 'List<String>', isRequired: true),
    PropMeta(name: 'rows', type: 'List<List<Widget>>', isRequired: true),
    PropMeta(
      name: 'columnFlex',
      type: 'List<double>?',
      description: LocalizedText(
        en: 'Flex factor per column (e.g. [2.2, 1, 1]). Null = the uniform split of always. In an unbounded-width context the factor only splits the leftover space.',
        pt: 'Fator de flex por coluna (ex.: [2.2, 1, 1]). Nulo = a repartição uniforme de sempre. Em contexto sem largura limitada o fator só reparte a sobra.',
      ),
    ),
  ],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Short table', pt: 'Tabela curta'),
      code: "AppSimpleDataTable(columnLabels: ['Chave', 'Valor'], rows: rows)",
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it for short, static blocks.'],
    pt: <String>['Use para blocos curtos e estáticos.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it when you need pagination or sorting.'],
    pt: <String>['Não use quando precisar paginar/ordenar.'],
  ),
  a11y: LocalizedText(
    en: 'Text selectable through AppSelectionRegion. The theme\'s colors pass AA in light and dark.',
    pt:
        'Texto selecionável via AppSelectionRegion. Cores do tema passam AA em '
        'claro/escuro.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_data_table'],
);
