import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppNavigationFooter]. Registrado em `flocksCatalog`.
const AppComponentMeta appNavigationFooterMeta = AppComponentMeta(
  id: 'app_navigation_footer',
  name: 'AppNavigationFooter',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.5.0',
  summary: LocalizedText(
    en: 'Bottom navigation bar (icon+title items).',
    pt: 'Barra de navegação inferior (itens ícone+título).',
  ),
  description: LocalizedText(
    en: 'Icon+title items; the current route\'s item is highlighted in a legible accent (`secondary`), the rest in a legible neutral. Each item sits on FlocksInteraction (hover/press/focus). Colors from the theme; radius and animation global.',
    pt:
        'Itens ícone+título; o item da rota atual é destacado num acento legível '
        '(`secondary`), os demais num neutro legível. Cada item sobre '
        'FlocksInteraction (hover/press/foco). Cores do tema; raio/animação globais.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Primary navigation on mobile (3–5 destinations).'],
    pt: <String>['Navegação primária no mobile (3–5 destinos).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Form actions → AppButtonsFooter.'],
    pt: <String>['Ações de formulário → AppButtonsFooter.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'items',
      type: 'List<AppNavigationFooterItemData>',
      isRequired: true,
    ),
    PropMeta(
      name: 'getCurrentRoute',
      type: 'String Function(BuildContext)',
      isRequired: true,
    ),
    PropMeta(name: 'constraints', type: 'BoxConstraints?'),
    PropMeta(name: 'decoration', type: 'BoxDecoration?'),
    PropMeta(name: 'padding', type: 'EdgeInsets?'),
  ],
  states: <String>['selected', 'unselected', 'hovered', 'focused', 'pressed'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Bottom bar', pt: 'Barra inferior'),
      code:
          'AppNavigationFooter(items: [...], '
          'getCurrentRoute: (c) => currentRoute)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['3–5 destinations; a short title.'],
    pt: <String>['3–5 destinos; título curto.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for many items — use a menu.'],
    pt: <String>['Não use para muitos itens — use um menu.'],
  ),
  a11y: LocalizedText(
    en: 'Each item carries a button role; active/inactive colors are ≥ 3:1 against the surface (validated across 2 brands × 2 brightnesses).',
    pt:
        'Cada item com role de botão; ativo/inativo em cores ≥ 3:1 sobre a '
        'superfície (validado nas 2 marcas × 2 brilhos).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_buttons_footer'],
);
