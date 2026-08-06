import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSearchFooter]. Registrado em `flocksCatalog`.
const AppComponentMeta appSearchFooterMeta = AppComponentMeta(
  id: 'app_search_footer',
  name: 'AppSearchFooter',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Floating search footer (Notes style), with the AppStyle axis + glass.',
    pt: 'Rodapé de busca flutuante (estilo Notes), com eixo AppStyle + glass.',
  ),
  description: LocalizedText(
    en: 'A floating search capsule: a bare AppInput over an AppBarSurface (which carries the style), with the bottom safe area and an optional detached trailing (e.g. a compose FAB). Supports `glass` (blur + gradient).',
    pt:
        'Cápsula de busca flutuante: um AppInput cru sobre uma AppBarSurface '
        '(carrega o estilo), com a safe-area inferior e um trailing isolado '
        'opcional (ex.: um FAB de compor). Suporta `glass` (blur + gradiente).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Search fixed at the bottom (lists, a map).',
      'The iOS Notes scenario (a capsule + a compose button).',
    ],
    pt: <String>[
      'Busca fixa no rodapé (listas, mapa).',
      'Cenário estilo iOS Notes (cápsula + botão de compor).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Message/chat composition → AppChatFooter.',
      'A filter inside a dropdown → AppSearchableDropdown.',
    ],
    pt: <String>[
      'Composição de mensagens/chat → AppChatFooter.',
      'Filtro dentro de um dropdown → AppSearchableDropdown.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'controller', type: 'TextEditingController?'),
    PropMeta(name: 'focusNode', type: 'FocusNode?'),
    PropMeta(name: 'hintText', type: 'String?'),
    PropMeta(name: 'onChanged', type: 'ValueChanged<String>?'),
    PropMeta(name: 'onSubmitted', type: 'ValueChanged<String>?'),
    PropMeta(name: 'prefixIcon', type: 'String'),
    PropMeta(name: 'suffixIcon', type: 'String?'),
    PropMeta(name: 'onSuffixIconTap', type: 'VoidCallback?'),
    PropMeta(name: 'trailing', type: 'Widget?'),
    PropMeta(name: 'style', type: 'AppStyle'),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
    PropMeta(name: 'size', type: 'AppFieldSize'),
    PropMeta(name: 'enabled', type: 'bool'),
  ],
  states: <String>['default', 'glass'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Search', pt: 'Busca'),
      code: 'AppSearchFooter(controller: c, hintText: \'Buscar\')',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use `glass` over scrollable content (the Notes effect).'],
    pt: <String>['Use `glass` sobre conteúdo rolável (efeito Notes).'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for chat — prefer AppChatFooter.'],
    pt: <String>['Não use para chat — prefira AppChatFooter.'],
  ),
  a11y: LocalizedText(
    en: 'A text field with a search action; labelled icons.',
    pt: 'Campo de texto com ação de busca; ícones rotulados.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_chat_footer', 'app_navigation_footer'],
);
