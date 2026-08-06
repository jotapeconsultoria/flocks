import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppDropdown]. Registrado em `flocksCatalog`.
const AppComponentMeta appDropdownMeta = AppComponentMeta(
  id: 'app_dropdown',
  name: 'AppDropdown',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Single-selection dropdown.',
    pt: 'Dropdown de seleção única.',
  ),
  description: LocalizedText(
    en: 'A trigger with Tab focus (FlocksInteraction), an animated chevron (AppMotion) and an options overlay (AppCard). Colors 100% from the theme (outline border / primary when open / danger on error; accents in a legible stop). Choosing closes the overlay.',
    pt:
        'Trigger com foco-Tab (FlocksInteraction), chevron animado (AppMotion) e '
        'overlay de opções (AppCard). Cores 100% do tema (borda outline / '
        'primary aberto / danger erro; acentos em stop legível). A escolha fecha '
        'o overlay.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Choosing one option among a few or a moderate number (up to ~15).',
    ],
    pt: <String>['Escolher uma opção entre poucas/médias (até ~15).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Many options → AppSearchableDropdown.',
      'Several selections → AppMultiSelect.',
    ],
    pt: <String>[
      'Muitas opções → AppSearchableDropdown.',
      'Várias seleções → AppMultiSelect.',
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
      title: LocalizedText(en: 'Single', pt: 'Único'),
      code:
          'AppDropdown<String>(options: opts, selectedValue: v, '
          'onChanged: set)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use label + hintText for clarity.'],
    pt: <String>['Use label + hintText para clareza.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for many options without search.'],
    pt: <String>['Não use para muitas opções sem busca.'],
  ),
  a11y: LocalizedText(
    en: 'Focusable trigger (Enter/Space opens it); border/accent in a legible stop ≥ 3:1; error in a legible danger.',
    pt:
        'Trigger focável (Enter/Space abre); borda/acento em stop legível ≥ 3:1; '
        'erro em danger legível.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_multi_select', 'app_searchable_dropdown'],
);
