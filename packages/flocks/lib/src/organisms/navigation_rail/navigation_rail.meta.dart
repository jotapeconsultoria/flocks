import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppNavigationRail]. Registrado em `flocksCatalog`.
const AppComponentMeta appNavigationRailMeta = AppComponentMeta(
  id: 'app_navigation_rail',
  name: 'AppNavigationRail',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Collapsible side menu with items and sub-items (the app\'s navigation).',
    pt: 'Menu lateral colapsável com itens e subitens (navegação do app).',
  ),
  description: LocalizedText(
    en: 'A vertical navigation rail: logo, items (icon + title), expandable parent items and a generic footer slot (e.g. Support + profile), collapsible between a narrow mode (icons only) and a wide one. Collapse/expand is triggered by a floating circular chevron on the right edge (with no outline). A collapsed item shows its title through AppTooltip (no Material). Colors 100% from the theme; hover and selection use the primary accent and the global radius; the transition uses motion tokens (reduce-motion).',
    pt:
        'Rail de navegação vertical: logo, itens (ícone + título), itens-pai '
        'expansíveis e um slot de footer genérico (ex.: Suporte + perfil), '
        'colapsável entre modo estreito (só ícones) e largo. O colapso/expansão '
        'é acionado por um chevron circular flutuante na borda direita (sem '
        'borda de contorno). Item colapsado mostra o título via AppTooltip (sem '
        'Material). Cores 100% do tema; hover/seleção usam o accent primário e '
        'o raio global; a transição usa tokens de motion (reduce-motion).',
  ),
  whenToUse: LocalizedList(
    en: <String>['Primary side navigation for the backoffice/desktop.'],
    pt: <String>['Navegação primária lateral do backoffice/desktop.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Horizontal tabs within a section → AppTabView.',
      'Bottom navigation on mobile → AppNavigationFooter.',
    ],
    pt: <String>[
      'Abas horizontais de uma seção → AppTabView.',
      'Navegação inferior no mobile → AppNavigationFooter.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'items',
      type: 'List<AppNavigationRailItemData>',
      isRequired: true,
    ),
    PropMeta(
      name: 'getCurrentRoute',
      type: 'String Function(BuildContext)',
      isRequired: true,
    ),
    PropMeta(name: 'logoCollapsed', type: 'String', isRequired: true),
    PropMeta(name: 'logoExpanded', type: 'String?'),
    PropMeta(name: 'footer', type: 'Widget?'),
    PropMeta(name: 'showFooterDivider', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'decoration', type: 'BoxDecoration?'),
  ],
  states: <String>['collapsed', 'expanded', 'item-selected', 'item-hovered'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Side menu', pt: 'Menu lateral'),
      code:
          'AppNavigationRail(items: items, logoCollapsed: logo, '
          'getCurrentRoute: (c) => router.location)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use the same icon in both modes (collapsed/expanded).'],
    pt: <String>['Use o mesmo ícone nos dois modos (colapsado/expandido).'],
  ),
  donts: LocalizedList(
    en: <String>['Do not nest more than one level of sub-items.'],
    pt: <String>['Não aninhe mais de um nível de subitens.'],
  ),
  a11y: LocalizedText(
    en: 'Collapsed items expose their title through AppTooltip; clickable items carry Semantics(button:true, label:). The primary accent over the surface passes AA; the floating chevron has a tooltip + semanticLabel.',
    pt:
        'Itens colapsados expõem o título por AppTooltip; itens clicáveis têm '
        'Semantics(button:true, label:). O accent primário sobre a superfície '
        'passa AA; o chevron flutuante tem tooltip + semanticLabel.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_navigation_rail_item',
    'app_navigation_rail_profile',
    'app_tab_view',
  ],
);

/// Descritor MCP do [AppNavigationRailItem]. Registrado em `flocksCatalog`.
const AppComponentMeta appNavigationRailItemMeta = AppComponentMeta(
  id: 'app_navigation_rail_item',
  name: 'AppNavigationRailItem',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'An AppNavigationRail item (icon + title, with states).',
    pt: 'Item de um AppNavigationRail (ícone + título, com estados).',
  ),
  description: LocalizedText(
    en: 'A clickable rail row: icon + title (hidden in collapsed mode), with selection and hover states (a pill tinted by the primary accent, radius following the global axis). Collapsed, it exposes the title through AppTooltip. If isCollapsed is null, it reads the state from AppNavigationRailScope (useful in the footer slot). Colors from the theme; transition on motion tokens.',
    pt:
        'Linha clicável do rail: ícone + título (oculto no modo colapsado), com '
        'estados de seleção e hover (pill tingido pelo accent primário, raio '
        'seguindo o eixo global). Colapsado, expõe o título via AppTooltip. Se '
        'isCollapsed for null, lê o estado do AppNavigationRailScope (útil no '
        'slot de footer). Cores do tema; transição por tokens de motion.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Composing an AppNavigationRail (usually through AppNavigationRailItemData).',
    ],
    pt: <String>[
      'Compor um AppNavigationRail (normalmente via AppNavigationRailItemData).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A generic list row → AppListTile.'],
    pt: <String>['Linha de lista genérica → AppListTile.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'icon', type: 'String', isRequired: true),
    PropMeta(name: 'isCollapsed', type: 'bool?'),
    PropMeta(name: 'onPressed', type: 'VoidCallback', isRequired: true),
    PropMeta(name: 'isSelected', type: 'bool', defaultValue: 'false'),
    PropMeta(
      name: 'showSelectedBackground',
      type: 'bool',
      defaultValue: 'true',
    ),
    PropMeta(name: 'title', type: 'String?'),
    PropMeta(name: 'trailing', type: 'Widget?'),
  ],
  states: <String>['default', 'selected', 'hovered', 'collapsed'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Selected item', pt: 'Item selecionado'),
      code:
          "AppNavigationRailItem(icon: home, title: 'Início', "
          'isCollapsed: false, isSelected: true, onPressed: go)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Pass a title for the tooltip in collapsed mode.'],
    pt: <String>['Passe title para o tooltip no modo colapsado.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it outside an AppNavigationRail.'],
    pt: <String>['Não use fora de um AppNavigationRail.'],
  ),
  a11y: LocalizedText(
    en: 'Semantics(button:true, label:) + a tooltip when collapsed. Icon and text colors reflect the selection and pass AA.',
    pt:
        'Semantics(button:true, label:) + tooltip no colapsado. Cores de ícone/'
        'texto refletem seleção e passam AA.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_navigation_rail'],
);

/// Descritor MCP do [AppNavigationRailProfile]. Registrado em `flocksCatalog`.
const AppComponentMeta appNavigationRailProfileMeta = AppComponentMeta(
  id: 'app_navigation_rail_profile',
  name: 'AppNavigationRailProfile',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.7.0',
  summary: LocalizedText(
    en: 'Profile row (avatar + name/role + trailing) for the footer.',
    pt: 'Linha de perfil (avatar + nome/papel + trailing) para o footer.',
  ),
  description: LocalizedText(
    en: 'A clickable row for AppNavigationRail\'s footer slot: avatar + title/subtitle + trailing (a chevron by default). Clickable through AppInteraction (radius follows the global axis). Collapsed, it shows only the avatar — reading the state from AppNavigationRailScope (or from isCollapsed).',
    pt:
        'Linha clicável para o slot de footer do AppNavigationRail: avatar + '
        'título/subtítulo + trailing (chevron por padrão). Clicável via '
        'AppInteraction (raio segue o eixo global). Colapsado, mostra só o '
        'avatar — lê o estado do AppNavigationRailScope (ou de isCollapsed).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The signed-in user\'s identity in the rail\'s footer (it opens the profile).',
    ],
    pt: <String>[
      'Identidade do usuário logado no rodapé do rail (abre o perfil).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A generic list row with an avatar → AppListTile.navigation.'],
    pt: <String>[
      'Linha de lista genérica com avatar → AppListTile.navigation.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'subtitle', type: 'String?'),
    PropMeta(name: 'imageUrl', type: 'String?'),
    PropMeta(name: 'initials', type: 'String?'),
    PropMeta(name: 'trailing', type: 'Widget?'),
    PropMeta(name: 'onTap', type: 'VoidCallback?'),
    PropMeta(name: 'isCollapsed', type: 'bool?'),
  ],
  states: <String>['default', 'collapsed'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Profile in the footer', pt: 'Perfil no footer'),
      code:
          "AppNavigationRailProfile(title: 'João M.', subtitle: 'Operador', "
          'initials: \'JM\', onTap: openProfile)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it inside AppNavigationRail\'s footer slot.'],
    pt: <String>['Use dentro do slot footer do AppNavigationRail.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not force isCollapsed — let the scope resolve it.'],
    pt: <String>['Não force isCollapsed — deixe o scope resolver.'],
  ),
  a11y: LocalizedText(
    en: 'AppInteraction exposes Semantics(button:true) with the label "name, role"; the avatar has a semanticLabel carrying the name.',
    pt:
        'AppInteraction expõe Semantics(button:true) com label "nome, papel"; '
        'avatar tem semanticLabel com o nome.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_navigation_rail', 'app_avatar'],
);

/// Descritor MCP do [AppNavigationRailFilter]. Registrado em `flocksCatalog`.
const AppComponentMeta appNavigationRailFilterMeta = AppComponentMeta(
  id: 'app_navigation_rail_filter',
  name: 'AppNavigationRailFilter',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.7.0',
  summary: LocalizedText(
    en: 'Filter row for the rail\'s footer: icon, filter name and selected value.',
    pt:
        'Linha de filtro para o rodapé do rail: ícone, nome do filtro e valor '
        'selecionado.',
  ),
  description: LocalizedText(
    en: 'It keeps a global scope (account, group, client) visible at all times without taking up the top bar. Use the SAME icon the entity has in the menu — that is what makes the current slice recognizable at a glance. With no value selected it shows "All", making it explicit that no slice is in force, instead of leaving an ambiguous empty space. Collapsed, only the icon remains, with the slice in the tooltip. It reads the collapsed state from AppNavigationRailScope.',
    pt:
        'Deixa um escopo global (conta, grupo, cliente) visível o tempo todo sem '
        'ocupar a barra superior. Use o MESMO ícone que a entidade tem no menu — '
        'é o que faz reconhecer o recorte de relance. Sem valor selecionado '
        'mostra "Todos", deixando explícito que não há recorte em vigor, em vez '
        'de um espaço vazio ambíguo. Colapsado sobra só o ícone, com o recorte '
        'no tooltip. Lê o estado colapsado do AppNavigationRailScope.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A scope filter that applies to the whole app and has to stay in sight.',
    ],
    pt: <String>[
      'Filtro de escopo que vale para o app inteiro e precisa estar sempre à '
          'vista.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A filter for a single screen → a field in that screen\'s own toolbar.',
      'A selection with many options and no search → AppSearchableDropdown.',
    ],
    pt: <String>[
      'Filtro de uma tela só → um campo na toolbar da própria tela.',
      'Seleção com muitas opções sem busca → AppSearchableDropdown.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'icon', type: 'String', isRequired: true),
    PropMeta(name: 'label', type: 'String', isRequired: true),
    PropMeta(name: 'value', type: 'String?'),
    PropMeta(
      name: 'emptyLabel',
      type: 'String',
      defaultValue: 'kAppNavigationRailFilterAllLabel',
    ),
    PropMeta(name: 'onTap', type: 'VoidCallback?'),
    PropMeta(
      name: 'enabled',
      type: 'bool',
      defaultValue: 'true',
      description: LocalizedText(
        en: 'false dims it and blocks touch, but keeps the value legible — the user needs to understand why the filter does not apply.',
        pt:
            'false esmaece e bloqueia o toque, mas mantém o valor legível — o '
            'usuário precisa entender por que o filtro não se aplica.',
      ),
    ),
    PropMeta(name: 'isCollapsed', type: 'bool?'),
  ],
  states: <String>['default', 'empty', 'disabled', 'collapsed'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Group in the footer', pt: 'Grupo no rodapé'),
      code:
          "AppNavigationRailFilter(icon: AppIconToken.group, label: 'Grupo', "
          'value: selectedGroupName, onTap: openGroupPicker)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Repeat the icon the entity has in the menu.',
      'Let "All" show — it is information, not emptiness.',
    ],
    pt: <String>[
      'Repita o ícone que a entidade tem no menu.',
      'Deixe "Todos" aparecer — é informação, não vazio.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not hide the row when nothing is selected.',
      'Do not force isCollapsed — let the scope resolve it.',
    ],
    pt: <String>[
      'Não esconda a linha quando não há seleção.',
      'Não force isCollapsed — deixe o scope resolver.',
    ],
  ),
  a11y: LocalizedText(
    en: 'AppInteraction exposes Semantics(button:true) with the label "filter: value"; collapsed, that same text goes to the AppTooltip.',
    pt:
        'AppInteraction expõe Semantics(button:true) com label "filtro: valor"; '
        'colapsado, o mesmo texto vai para o AppTooltip.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_navigation_rail', 'app_navigation_rail_profile'],
);
