import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppPagination]. Registrado em `flocksCatalog`.
const AppComponentMeta appPaginationMeta = AppComponentMeta(
  id: 'app_pagination',
  name: 'AppPagination',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.4.0',
  summary: LocalizedText(
    en: 'Page navigation (prev/next + numbers with an ellipsis).',
    pt: 'Navegação de páginas (prev/next + números com reticências).',
  ),
  description: LocalizedText(
    en: 'Standalone (decoupled from any table). The current page is a filled pill; the rest are ghosts. An optional "per page" selector (it reuses AppDropdown).',
    pt:
        'Standalone (desacoplada de tabela). Página atual = pílula preenchida; '
        'demais = fantasmas. Seletor de "por página" opcional (reusa AppDropdown).',
  ),
  whenToUse: LocalizedList(
    en: <String>['Paginating a large list or table from the footer.'],
    pt: <String>['Paginar uma lista/tabela grande no rodapé.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Infinite scrolling / load-more → a different pattern.',
      'A few items on a single page → do not paginate.',
    ],
    pt: <String>[
      'Rolagem infinita / carregar-mais → outro padrão.',
      'Poucos itens numa página só → não pagine.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'currentPage', type: 'int', isRequired: true),
    PropMeta(name: 'pageCount', type: 'int', isRequired: true),
    PropMeta(
      name: 'onPageChanged',
      type: 'ValueChanged<int>',
      isRequired: true,
    ),
    PropMeta(name: 'siblingCount', type: 'int', defaultValue: '1'),
    PropMeta(name: 'boundaryCount', type: 'int', defaultValue: '1'),
    PropMeta(name: 'showPrevNext', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'perPage', type: 'AppPaginationPerPage?'),
  ],
  states: <String>['current', 'other', 'hovered', 'ellipsis'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'List footer', pt: 'Rodapé de lista'),
      code:
          'AppPagination(currentPage: page, pageCount: total, '
          'onPageChanged: (p) => goTo(p))',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Tune siblingCount/boundaryCount for the space available.'],
    pt: <String>['Ajuste siblingCount/boundaryCount para o espaço disponível.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it with infinite scrolling.'],
    pt: <String>['Não use com rolagem infinita.'],
  ),
  a11y: LocalizedText(
    en: 'Each number is a "Page N" button; the current one is marked as selected. Previous/Next disable at the ends. The truncation is a pure function (paginationRange).',
    pt:
        'Cada número é um botão "Página N"; a atual é marcada como selecionada. '
        'Anterior/Próxima desabilitam nos extremos. O truncamento é uma função '
        'pura (paginationRange).',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_dropdown', 'app_interaction'],
);
