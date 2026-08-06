import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppListTileRadio]. Registrado em `flocksCatalog`.
const AppComponentMeta appListTileRadioMeta = AppComponentMeta(
  id: 'app_list_tile_radio',
  name: 'AppListTileRadio',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'List row with a radio (single selection).',
    pt: 'Linha de lista com radio (seleção única).',
  ),
  description: LocalizedText(
    en: 'Generic AppListTileRadio<T>. Tapping the row selects the value. Same styles and variations as AppListTile (leading/subtitle/draggable/style); trailing = AppRadio. Its own class because a named constructor cannot introduce a <T>.',
    pt:
        'Genérico AppListTileRadio<T>. Tocar a linha seleciona o value. Mesmos '
        'estilos/variações do AppListTile (leading/subtitle/draggable/style); '
        'trailing = AppRadio. Classe própria porque um construtor nomeado não '
        'pode introduzir <T>.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Choosing one option among several, in a list.'],
    pt: <String>['Escolher uma opção entre várias, em lista.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Multiple selection → AppListTile.checkbox.',
      'On/off → AppListTile.toggle.',
    ],
    pt: <String>[
      'Múltipla seleção → AppListTile.checkbox.',
      'Liga/desliga → AppListTile.toggle.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'value', type: 'T', isRequired: true),
    PropMeta(name: 'groupValue', type: 'T?', isRequired: true),
    PropMeta(name: 'onChanged', type: 'ValueChanged<T?>?'),
    PropMeta(name: 'subtitle', type: 'String?'),
    PropMeta(name: 'leading', type: 'Widget?'),
    PropMeta(
      name: 'style',
      type: 'AppListTileStyle',
      defaultValue: 'AppListTileStyle.grouped',
      enumValues: <String>['bordered', 'grouped'],
    ),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'reorderIndex', type: 'int?'),
    PropMeta(name: 'semanticLabel', type: 'String?'),
  ],
  states: <String>['unselected', 'selected', 'disabled', 'hovered', 'focused'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Choose', pt: 'Escolher'),
      code:
          'AppListTileRadio<String>(title: "Polo", value: id, '
          'groupValue: sel, onChanged: choose)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use it inside an AppListTileGroup sharing the same groupValue.',
    ],
    pt: <String>['Use dentro de um AppListTileGroup com o mesmo groupValue.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for multiple selection.'],
    pt: <String>['Não use para múltipla seleção.'],
  ),
  a11y: LocalizedText(
    en: 'AppRadio exposes the exclusive-group semantics; merged with the title; title in onSurface at AA contrast.',
    pt:
        'AppRadio expõe a semântica de grupo exclusivo; merge com o título; título '
        'onSurface com contraste AA.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_list_tile', 'app_radio'],
);
