import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppMultiSelect]. Registrado em `flocksCatalog`.
const AppComponentMeta appMultiSelectMeta = AppComponentMeta(
  id: 'app_multi_select',
  name: 'AppMultiSelect',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Multi-selection dropdown (chips + ✓).',
    pt: 'Dropdown de seleção múltipla (chips + ✓).',
  ),
  description: LocalizedText(
    en: 'A trigger with chips for the selected items; the overlay marks them with ✓ and does not close on selection. Reuses the dropdown core; colors 100% from the theme.',
    pt:
        'Trigger com chips dos selecionados; o overlay marca com ✓ e não fecha ao '
        'selecionar. Reusa o core de dropdown; cores 100% do tema.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Selecting several options among a few or a moderate number.'],
    pt: <String>['Selecionar várias opções entre poucas/médias.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Many options → AppSearchableMultiSelect.',
      'Single selection → AppDropdown.',
    ],
    pt: <String>[
      'Muitas opções → AppSearchableMultiSelect.',
      'Seleção única → AppDropdown.',
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
    PropMeta(name: 'label', type: 'String?'),
    PropMeta(name: 'info', type: 'Widget?'),
    PropMeta(name: 'hintText', type: 'String?'),
    PropMeta(name: 'helperText', type: 'String?'),
    PropMeta(name: 'errorText', type: 'String?'),
    PropMeta(name: 'hasError', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
  ],
  states: <String>['closed', 'open', 'focused', 'error', 'disabled'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Multiple', pt: 'Múltiplo'),
      code:
          'AppMultiSelect<String>(options: opts, selectedValues: vs, '
          'onChanged: set)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Remove a chip with the ✕; select in the overlay without it closing.',
    ],
    pt: <String>['Remova um chip pelo ✕; selecione no overlay sem fechar.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for many options without search.'],
    pt: <String>['Não use para muitas opções sem busca.'],
  ),
  a11y: LocalizedText(
    en: 'Focusable trigger; chips at AA contrast; accents in a legible stop.',
    pt: 'Trigger focável; chips com contraste AA; acentos em stop legível.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_dropdown', 'app_searchable_multi_select'],
);
