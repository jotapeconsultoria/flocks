import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppActionItem]. Registrado em `flocksCatalog`.
const AppComponentMeta appActionItemMeta = AppComponentMeta(
  id: 'app_action_item',
  name: 'AppActionItem',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Action item (icon + text) on a clickable tinted surface.',
    pt: 'Item de ação (ícone + texto) numa superfície tingida clicável.',
  ),
  description: LocalizedText(
    en: 'Action row for menus and option lists: icon on the left + text. Tinted surface (primary.s50 by default), taking part in the AppStyle and AppRadiusMode axes. Colors 100% from the theme.',
    pt:
        'Linha de ação para menus/listas de opções: ícone à esquerda + texto. '
        'Superfície tingida (primary.s50 por padrão), participando dos eixos '
        'AppStyle e AppRadiusMode. Cores 100% do tema.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Quick actions in an option list or a menu.'],
    pt: <String>['Ações rápidas numa lista de opções ou menu.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A rich list row (avatar, trailing, selection) → AppListTile.',
    ],
    pt: <String>[
      'Linha de lista rica (avatar, trailing, seleção) → AppListTile.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'icon', type: 'String', isRequired: true),
    PropMeta(name: 'text', type: 'String', isRequired: true),
    PropMeta(name: 'onPressed', type: 'VoidCallback', isRequired: true),
    PropMeta(
      name: 'direction',
      type: 'Axis',
      defaultValue: 'Axis.horizontal',
      description: LocalizedText(
        en: 'horizontal = icon left of the text (the default row); vertical stacks icon over label, centered — the sheet grid cell. Same padding, radius and colors.',
        pt: 'horizontal = ícone à esquerda do texto (a linha de sempre); vertical empilha ícone sobre rótulo, centrados — a célula da grade em folha. Mesmo padding, raio e cores.',
      ),
      enumValues: <String>['horizontal', 'vertical'],
    ),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
  ],
  variants: <String>['horizontal', 'vertical'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Support item', pt: 'Item de suporte'),
      code:
          "AppActionItem(icon: AppIconToken.support, text: 'Suporte', "
          'onPressed: openSupport)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Short text (1 line); an icon that reinforces the action.'],
    pt: <String>['Texto curto (1 linha); ícone que reforça a ação.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for complex list rows (AppListTile).'],
    pt: <String>['Não use para linhas de lista complexas (AppListTile).'],
  ),
  a11y: LocalizedText(
    en: 'Text with a semanticLabel; the icon in secondary and the text in neutralPrimary s900 over the tinted background both pass AA.',
    pt:
        'Texto com semanticLabel; ícone na cor secondary e texto neutralPrimary '
        's900 sobre o fundo tingido passam AA.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_list_tile', 'app_menu'],
);
