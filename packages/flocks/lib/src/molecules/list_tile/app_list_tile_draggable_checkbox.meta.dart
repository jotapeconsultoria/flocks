import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppListTileDraggableCheckbox]. Registrado em `flocksCatalog`.
const AppComponentMeta appListTileDraggableCheckboxMeta = AppComponentMeta(
  id: 'app_list_tile_draggable_checkbox',
  name: 'AppListTileDraggableCheckbox',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Reorderable selection row: a drag handle + a checkbox.',
    pt: 'Linha de seleção reordenável: handle de arraste + checkbox.',
  ),
  description: LocalizedText(
    en: 'Like AppListTileCheckbox, with a drag handle (dragArrow) on the left through ReorderableDragStartListener(index: reorderIndex). Use it inside a reorderable list.',
    pt:
        'Como AppListTileCheckbox, com um handle de arraste (dragArrow) à esquerda '
        'via ReorderableDragStartListener(index: reorderIndex). Use dentro de uma '
        'lista reordenável.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Selecting and reordering items (e.g. table columns).'],
    pt: <String>['Selecionar e reordenar itens (ex.: colunas de tabela).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['No reordering → AppListTileCheckbox.'],
    pt: <String>['Sem reordenação → AppListTileCheckbox.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'checked', type: 'bool', isRequired: true),
    PropMeta(name: 'reorderIndex', type: 'int', isRequired: true),
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'text', type: 'String?'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'onChanged', type: 'ValueChanged<bool>?'),
    PropMeta(name: 'reorderEnabled', type: 'bool', defaultValue: 'true'),
  ],
  states: <String>['unchecked', 'checked', 'dragging'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Reorderable', pt: 'Reordenável'),
      code:
          "AppListTileDraggableCheckbox(reorderIndex: i, title: 'Coluna', "
          "text: 'Placa', checked: col.visible, onChanged: onToggle)",
    ),
  ],
  a11y: LocalizedText(
    en: 'A dedicated drag handle; the row toggles the selection.',
    pt: 'Handle de arraste dedicado; a linha alterna a seleção.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_list_tile_checkbox', 'app_list_tile'],
);
