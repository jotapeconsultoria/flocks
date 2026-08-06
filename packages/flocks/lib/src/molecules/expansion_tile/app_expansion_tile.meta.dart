import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppExpansionTile]. Registrado em `flocksCatalog`.
const AppComponentMeta appExpansionTileMeta = AppComponentMeta(
  id: 'app_expansion_tile',
  name: 'AppExpansionTile',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Expandable tile: a clickable header + an animated body.',
    pt: 'Tile expansível: cabeçalho clicável + corpo animado.',
  ),
  description: LocalizedText(
    en: 'A header on FlocksInteraction (hover/press/focus/keyboard); the chevron rotates through AppAnimatedRotation and the body opens/closes through AppExpand — both driven by AppMotion (reduce-motion + the global toggle). Tooltip through AppTooltip. Colors from the theme; it takes part in the global style (filled/outlined/elevated) and shape (radius) axes, wrapping the whole card.',
    pt:
        'Cabeçalho sobre FlocksInteraction (hover/press/foco/teclado); o chevron '
        'gira via AppAnimatedRotation e o corpo abre/fecha via AppExpand — ambos '
        'por AppMotion (reduce-motion + toggle global). Tooltip via AppTooltip. '
        'Cores do tema; participa dos eixos globais de estilo '
        '(filled/outlined/elevated) e forma (radius), envolvendo o card inteiro.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A collapsible section of content (details, FAQ, advanced filters).',
    ],
    pt: <String>[
      'Seção colapsável de conteúdo (detalhes, FAQ, filtros avançados).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Navigation between sibling panels → tabs (organism).',
      'A simple option row → AppListTile / AppActionItem.',
    ],
    pt: <String>[
      'Navegação entre painéis irmãos → abas (organism).',
      'Linha simples de opção → AppListTile / AppActionItem.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'children', type: 'List<Widget>', isRequired: true),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'hoverEnabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'initiallyExpanded', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'onExpansionChanged', type: 'ValueChanged<bool>?'),
    PropMeta(
      name: 'collapsedIconTooltip',
      type: 'String',
      defaultValue: "'Abrir'",
    ),
    PropMeta(
      name: 'expandedIconTooltip',
      type: 'String',
      defaultValue: "'Fechar'",
    ),
  ],
  states: <String>['collapsed', 'expanded', 'hovered', 'focused', 'disabled'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Collapsible section', pt: 'Seção colapsável'),
      code: "AppExpansionTile(title: 'Detalhes', children: [AppText('...')])",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use it for secondary content that can stay hidden by default.',
    ],
    pt: <String>[
      'Use para conteúdo secundário que pode ficar oculto por padrão.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not nest many levels — it becomes a maze.'],
    pt: <String>['Não aninhe muitos níveis — vira labirinto.'],
  ),
  a11y: LocalizedText(
    en: 'A header with a button role (AppSemantics.button); activation with Enter/Space; title and chevron in onSurface over the surface (an AA pair); disabled dimmed by tone.',
    pt:
        'Cabeçalho com role de botão (AppSemantics.button); ativação por '
        'Enter/Space; título/chevron em onSurface sobre a superfície (par AA); '
        'desabilitado apagado por tom.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_list_tile', 'app_action_item'],
);
