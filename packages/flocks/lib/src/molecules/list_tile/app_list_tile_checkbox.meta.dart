import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppListTileCheckbox]. Registrado em `flocksCatalog`.
const AppComponentMeta appListTileCheckboxMeta = AppComponentMeta(
  id: 'app_list_tile_checkbox',
  name: 'AppListTileCheckbox',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Selection row with a checkbox; the whole row toggles.',
    pt: 'Linha de seleção com checkbox; a linha inteira alterna.',
  ),
  description: LocalizedText(
    en: 'An optional title (titleSmall) over an identifier (titleMedium; secondary when checked) and an AppCheckbox on the right. Tapping anywhere on the row toggles the state when enabled.',
    pt:
        'Título opcional (titleSmall) sobre identificador (titleMedium; secondary '
        'quando marcado) e um AppCheckbox à direita. Tocar em qualquer ponto da '
        'linha alterna o estado quando habilitada.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Selecting items from a list (multi-selection).'],
    pt: <String>['Selecionar itens de uma lista (multi-seleção).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['An action or a picker → AppListTileAction.'],
    pt: <String>['Ação/seletor → AppListTileAction.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'checked', type: 'bool', isRequired: true),
    PropMeta(name: 'text', type: 'String', isRequired: true),
    PropMeta(name: 'title', type: 'String?'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'onChanged', type: 'ValueChanged<bool>?'),
  ],
  states: <String>['unchecked', 'checked', 'disabled'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Selection', pt: 'Seleção'),
      code:
          "AppListTileCheckbox(title: 'Polo Track 01', text: 'TTS4G47', "
          'checked: selected, onChanged: onToggle)',
    ),
  ],
  a11y: LocalizedText(
    en: 'The whole row is a touch target; AA contrast in both states.',
    pt: 'Linha inteira é alvo de toque; contraste AA em ambos os estados.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_list_tile', 'app_list_tile_draggable_checkbox'],
);
