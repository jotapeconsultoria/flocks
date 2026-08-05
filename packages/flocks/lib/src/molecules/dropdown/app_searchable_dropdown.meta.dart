import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSearchableDropdown]. Registrado em `flocksCatalog`.
const AppComponentMeta appSearchableDropdownMeta = AppComponentMeta(
  id: 'app_searchable_dropdown',
  name: 'AppSearchableDropdown',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.5.0',
  summary: LocalizedText(
    en: 'Single-selection dropdown with a search field.',
    pt: 'Dropdown de seleção única com campo de busca.',
  ),
  description: LocalizedText(
    en: 'Like AppDropdown, with a filter field at the top of the overlay (focused automatically when it opens). The search field uses EditableText (a simple filter, not a full form field). Reuses the dropdown core.',
    pt:
        'Como AppDropdown, com um campo de filtro no topo do overlay (foco '
        'automático ao abrir). O campo de busca usa EditableText (filtro simples, '
        'não um campo de formulário completo). Reusa o core de dropdown.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Choosing one option among many (a long list).'],
    pt: <String>['Escolher uma opção entre muitas (lista longa).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Few options → AppDropdown.',
      'Several selections → AppSearchableMultiSelect.',
    ],
    pt: <String>[
      'Poucas opções → AppDropdown.',
      'Várias seleções → AppSearchableMultiSelect.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'options',
      type: 'List<AppDropdownOption<T>>',
      isRequired: true,
    ),
    PropMeta(name: 'onChanged', type: 'ValueChanged<T?>', isRequired: true),
    PropMeta(name: 'selectedValue', type: 'T?'),
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
      title: LocalizedText(en: 'With search', pt: 'Com busca'),
      code:
          'AppSearchableDropdown<String>(options: opts, '
          "searchHintText: 'Buscar…', onChanged: set)",
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it for long lists; offer a searchHintText.'],
    pt: <String>['Use para listas longas; ofereça searchHintText.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for 2–3 options.'],
    pt: <String>['Não use para 2–3 opções.'],
  ),
  a11y: LocalizedText(
    en: 'Search takes focus when it opens; options at AA contrast; a legible accent.',
    pt: 'Busca ganha foco ao abrir; opções com contraste AA; acento legível.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_dropdown', 'app_searchable_multi_select'],
);
