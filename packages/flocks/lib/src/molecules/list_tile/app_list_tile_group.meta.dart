import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppListTileGroup]. Registrado em `flocksCatalog`.
const AppComponentMeta appListTileGroupMeta = AppComponentMeta(
  id: 'app_list_tile_group',
  name: 'AppListTileGroup',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Groups list tiles into a card with a background/border + dividers.',
    pt: 'Agrupa list-tiles num card com fundo/borda + divisórias.',
  ),
  description: LocalizedText(
    en: 'The container for AppListTiles: depending on style, a `surfaceContainer` background (grouped) or an `outline` border (bordered), corners from the global radius and `outline` dividers between rows. It tells the tiles (through a scope) that it draws the container, so each tile renders only the row.',
    pt:
        'Container dos AppListTile: por style, fundo `surfaceContainer` (grouped) '
        'ou borda `outline` (bordered), cantos do radius global e divisórias '
        '`outline` entre as linhas. Informa aos tiles (via escopo) que ele desenha '
        'o container, então cada tile renderiza só a linha.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Stacking several related list rows into one block.'],
    pt: <String>['Empilhar várias linhas de lista relacionadas num bloco.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A single standalone row → use AppListTile directly.'],
    pt: <String>['Uma única linha avulsa → use o AppListTile direto.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'children', type: 'List<Widget>', isRequired: true),
    PropMeta(
      name: 'style',
      type: 'AppListTileStyle',
      defaultValue: 'AppListTileStyle.grouped',
      enumValues: <String>['bordered', 'grouped'],
    ),
  ],
  variants: <String>['grouped', 'bordered'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Menu', pt: 'Menu'),
      code:
          'AppListTileGroup(children: [AppListTile.navigation(title: "Suporte", '
          'onTap: s), AppListTile.navigation(title: "Sair", onTap: out)])',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it for menus, selections and short related lists.'],
    pt: <String>['Use para menus, seleções e listas curtas relacionadas.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not nest groups.'],
    pt: <String>['Não aninhe grupos.'],
  ),
  a11y: LocalizedText(
    en: 'A visual container; the semantics come from the child tiles. Background, border and divider meet the contract\'s contrast in light and dark across both brands.',
    pt:
        'Container visual; a semântica vem dos tiles filhos. Fundo/borda/divisória '
        'com contraste do contrato em claro/escuro nas duas marcas.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_list_tile', 'app_list_tile_radio'],
);
