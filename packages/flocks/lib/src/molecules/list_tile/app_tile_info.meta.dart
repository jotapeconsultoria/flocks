import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppTileInfo]. Registrado em `flocksCatalog`.
const AppComponentMeta appTileInfoMeta = AppComponentMeta(
  id: 'app_tile_info',
  name: 'AppTileInfo',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Label/value pair (not clickable).',
    pt: 'Par rótulo/valor (não clicável).',
  ),
  description: LocalizedText(
    en: 'A label in a legible neutral + a value in onSurface, stacked. Colors from the theme (AA contrast). A reusable data block for detail views.',
    pt:
        'Rótulo em neutro legível + valor em onSurface, empilhados. Cores do tema '
        '(contraste AA). Bloco de dado reutilizável em detalhes.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Showing a label/value field on detail screens.'],
    pt: <String>['Exibir um campo rótulo/valor em telas de detalhe.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A clickable row → AppListTile / AppListTileAction.'],
    pt: <String>['Linha clicável → AppListTile / AppListTileAction.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'text', type: 'String', isRequired: true),
    PropMeta(
      name: 'textAlign',
      type: 'TextAlign',
      defaultValue: 'TextAlign.start',
    ),
    PropMeta(
      name: 'layout',
      type: 'AppTileInfoLayout',
      defaultValue: 'AppTileInfoLayout.vertical',
      description: LocalizedText(
        en: 'vertical stacks label over value (the default); horizontal is the record row — label left, value taking the rest.',
        pt: 'vertical empilha rótulo sobre valor (o default); horizontal é a linha de ficha — rótulo à esquerda, valor no resto.',
      ),
      enumValues: <String>['vertical', 'horizontal'],
    ),
    PropMeta(
      name: 'icon',
      type: 'String?',
      description: LocalizedText(
        en: 'Optional icon slug next to the label, in the same muted color.',
        pt: 'Slug de ícone opcional junto ao rótulo, na mesma cor muted.',
      ),
    ),
  ],
  variants: <String>['vertical', 'horizontal'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Field', pt: 'Campo'),
      code: "AppTileInfo(title: 'Identificador', text: 'TTS4G47')",
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it in detail grids (label/value).'],
    pt: <String>['Use em grades de detalhe (label/valor).'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for clickable rows.'],
    pt: <String>['Não use para linhas clicáveis.'],
  ),
  a11y: LocalizedText(
    en: 'Label and value at AA contrast against the surface.',
    pt: 'Rótulo e valor com contraste AA sobre a superfície.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_list_tile'],
);
