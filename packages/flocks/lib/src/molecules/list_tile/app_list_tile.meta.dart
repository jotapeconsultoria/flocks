import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppListTile]. Registrado em `flocksCatalog`.
const AppComponentMeta appListTileMeta = AppComponentMeta(
  id: 'app_list_tile',
  name: 'AppListTile',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.5.0',
  summary: LocalizedText(
    en: 'List row in 2 styles, with orthogonal variations.',
    pt: 'Linha de lista em 2 estilos, com variações ortogonais.',
  ),
  description: LocalizedText(
    en: 'One tile in 2 styles (AppListTileStyle bordered/grouped) with variations through named constructors: navigation (chevron), checkbox, toggle (switch), badge, and a generic one (custom trailing). leading and subtitle are optional; reorderIndex adds a drag handle. Built on FlocksInteraction; colors, radius and animation from the theme, with an optional danger role. Group them with AppListTileGroup.',
    pt:
        'Um só tile em 2 estilos (AppListTileStyle bordered/grouped) e variações '
        'via construtores nomeados: navigation (chevron), checkbox, toggle '
        '(switch), badge, + genérico (trailing custom). leading e subtitle '
        'opcionais; reorderIndex adiciona drag handle. Sobre FlocksInteraction; '
        'cores/raio/animação do tema e papel danger opcional. Agrupe com '
        'AppListTileGroup.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Menu, selection or navigation rows (with or without a leading and a subtitle).',
    ],
    pt: <String>[
      'Linhas de menu, seleção ou navegação (com/sem leading e subtitle).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Single selection (radio) → AppListTileRadio.',
      'A static label/value pair in a grid → AppTileInfo.',
    ],
    pt: <String>[
      'Seleção única (radio) → AppListTileRadio.',
      'Par rótulo/valor estático em grid → AppTileInfo.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'danger', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'subtitle', type: 'String?'),
    PropMeta(
      name: 'leading',
      type: 'Widget?',
      description: LocalizedText(
        en: 'AppIcon/AppAvatar/custom.',
        pt: 'AppIcon/AppAvatar/custom.',
      ),
    ),
    PropMeta(
      name: 'style',
      type: 'AppListTileStyle',
      defaultValue: 'AppListTileStyle.grouped',
      enumValues: <String>['bordered', 'grouped'],
    ),
    PropMeta(name: 'onTap', type: 'VoidCallback?'),
    PropMeta(
      name: 'trailing',
      type: 'Widget?',
      description: LocalizedText(
        en: 'Generic constructor only.',
        pt: 'Só no construtor genérico.',
      ),
    ),
    PropMeta(
      name: 'value',
      type: 'bool',
      description: LocalizedText(
        en: '.checkbox/.toggle',
        pt: '.checkbox/.toggle',
      ),
    ),
    PropMeta(
      name: 'onChanged',
      type: 'ValueChanged<bool>?',
      description: LocalizedText(
        en: '.checkbox/.toggle',
        pt: '.checkbox/.toggle',
      ),
    ),
    PropMeta(
      name: 'badge',
      type: 'String',
      description: LocalizedText(en: '.badge', pt: '.badge'),
    ),
    PropMeta(
      name: 'badgeColor',
      type: 'AppBadgeColor',
      description: LocalizedText(en: '.badge', pt: '.badge'),
    ),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(
      name: 'reorderIndex',
      type: 'int?',
      description: LocalizedText(
        en: 'Draggable: adds a drag handle.',
        pt: 'Draggable: adiciona drag handle.',
      ),
    ),
    PropMeta(name: 'semanticLabel', type: 'String?'),
  ],
  variants: <String>['generic', 'navigation', 'checkbox', 'toggle', 'badge'],
  states: <String>['default', 'hovered', 'pressed', 'focused', 'disabled'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Navigation with a leading',
        pt: 'Navegação com leading',
      ),
      code:
          'AppListTile.navigation(leading: AppIcon(AppIconToken.support), '
          'title: "Suporte", onTap: open)',
    ),
    CodeExample(
      title: LocalizedText(en: 'Checkbox', pt: 'Checkbox'),
      code: 'AppListTile.checkbox(title: "Item", value: v, onChanged: set)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Group related rows with AppListTileGroup.',
      'Use grouped for actions, bordered for information.',
    ],
    pt: <String>[
      'Agrupe linhas relacionadas com AppListTileGroup.',
      'Use grouped p/ ações, bordered p/ informativo.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not mix a radio in here — use AppListTileRadio.'],
    pt: <String>['Não misture radio aqui — use AppListTileRadio.'],
  ),
  a11y: LocalizedText(
    en: 'navigation/badge carry a button role; checkbox/toggle merge the title with the control; title in onSurface and subtitle in neutral s700, both at AA contrast over either surface (grouped/bordered).',
    pt:
        'navigation/badge com role de botão; checkbox/toggle fazem merge do título '
        'com o controle; título onSurface e subtítulo neutro s700 com contraste AA '
        'sobre ambas as superfícies (grouped/bordered).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_list_tile_group',
    'app_list_tile_radio',
    'app_tile_info',
  ],
);
