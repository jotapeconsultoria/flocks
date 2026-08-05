import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSearchableMultiSelect]. Registrado em `flocksCatalog`.
const AppComponentMeta appSearchableMultiSelectMeta = AppComponentMeta(
  id: 'app_searchable_multi_select',
  name: 'AppSearchableMultiSelect',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.5.0',
  summary: LocalizedText(
    en: 'Multi-selection with chips and a search field.',
    pt: 'Seleção múltipla com chips e campo de busca.',
  ),
  description: LocalizedText(
    en: 'Like AppMultiSelect, with a filter field at the top of the overlay (focused automatically when it opens); selecting does not close it. Reuses the dropdown core.',
    pt:
        'Como AppMultiSelect, com um campo de filtro no topo do overlay (foco '
        'automático ao abrir); selecionar não fecha. Reusa o core de dropdown.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Selecting several options among many (a long list).'],
    pt: <String>['Selecionar várias opções entre muitas (lista longa).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Few options → AppMultiSelect.',
      'Single selection → AppSearchableDropdown.',
    ],
    pt: <String>[
      'Poucas opções → AppMultiSelect.',
      'Seleção única → AppSearchableDropdown.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'options',
      type: 'List<AppDropdownOption<T>>',
      isRequired: true,
    ),
    PropMeta(
      name: 'onChanged',
      type: 'ValueChanged<List<T>>',
      isRequired: true,
    ),
    PropMeta(name: 'selectedValues', type: 'List<T>', defaultValue: 'const []'),
    PropMeta(name: 'searchHintText', type: 'String?'),
    PropMeta(name: 'label', type: 'String?'),
    PropMeta(name: 'info', type: 'Widget?'),
    PropMeta(name: 'hintText', type: 'String?'),
    PropMeta(name: 'helperText', type: 'String?'),
    PropMeta(name: 'errorText', type: 'String?'),
    PropMeta(name: 'hasError', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
  ],
  states: <String>[
    'closed',
    'open',
    'searching',
    'focused',
    'error',
    'disabled',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Multiple with search',
        pt: 'Múltiplo com busca',
      ),
      code:
          'AppSearchableMultiSelect<String>(options: opts, '
          'selectedValues: vs, onChanged: set)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it for long lists with multiple selection.'],
    pt: <String>['Use para listas longas com seleção múltipla.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for a handful of options.'],
    pt: <String>['Não use para poucas opções.'],
  ),
  a11y: LocalizedText(
    en: 'Search takes focus when it opens; chips and options at AA contrast.',
    pt: 'Busca ganha foco ao abrir; chips e opções com contraste AA.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_multi_select', 'app_searchable_dropdown'],
);
