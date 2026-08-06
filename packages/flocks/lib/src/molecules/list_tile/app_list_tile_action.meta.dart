import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppListTileAction]. Registrado em `flocksCatalog`.
const AppComponentMeta appListTileActionMeta = AppComponentMeta(
  id: 'app_list_tile_action',
  name: 'AppListTileAction',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Title/value row with a trailing action, clickable.',
    pt: 'Linha título/valor com trailing de ação, clicável.',
  ),
  description: LocalizedText(
    en: 'A discreet title (titleSmall) over a strong value (titleMedium), with a bottom border and a trailing action widget (e.g. AppIcon(swapArrow)). The whole row is clickable when onPressed != null.',
    pt:
        'Título discreto (titleSmall) sobre valor forte (titleMedium), com borda '
        'inferior e um widget trailing de ação (ex.: AppIcon(swapArrow)). A linha '
        'inteira é clicável quando onPressed != null.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Opening a picker or an action from a field row.'],
    pt: <String>['Abrir um seletor/ação a partir de uma linha de campo.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Toggling a boolean → AppListTileCheckbox.'],
    pt: <String>['Alternar um booleano → AppListTileCheckbox.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'text', type: 'String', isRequired: true),
    PropMeta(name: 'trailing', type: 'Widget', isRequired: true),
    PropMeta(name: 'onPressed', type: 'VoidCallback?', isRequired: true),
  ],
  states: <String>['default', 'pressed'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Action', pt: 'Ação'),
      code:
          "AppListTileAction(title: 'Veículos', text: 'TTS4G47', "
          'trailing: const AppIcon(AppIconToken.swapArrow), onPressed: pick)',
    ),
  ],
  a11y: LocalizedText(
    en: 'A clickable row; title and value at AA contrast against the surface.',
    pt: 'Linha clicável; título e valor com contraste AA sobre a superfície.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_list_tile', 'app_tile_info'],
);
