import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppChatFooter]. Registrado em `flocksCatalog`.
const AppComponentMeta appChatFooterMeta = AppComponentMeta(
  id: 'app_chat_footer',
  name: 'AppChatFooter',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Chat footer: wraps AppChatComposer with a safe area + AppStyle.',
    pt: 'Rodapé de chat: envolve o AppChatComposer com safe-area + AppStyle.',
  ),
  description: LocalizedText(
    en: 'Wraps AppChatComposer, adding the bottom safe area (which the composer does not handle) and the bar style axes (AppStyle) + glass. The composer is forced to `filled` (an opaque pill) — the bar carries the style, which avoids double styling. Docked by default; `floating` detaches it.',
    pt:
        'Envolve o AppChatComposer adicionando a safe-area inferior (que o '
        'composer não trata) e os eixos de estilo de barra (AppStyle) + glass. '
        'O composer é forçado a `filled` (pílula opaca) — a barra carrega o '
        'estilo, evitando duplo-styling. Docked por padrão; `floating` destaca.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Message composition fixed at the bottom (chat/AI).',
      'You need a safe area + the style axis (glass) around the composer.',
    ],
    pt: <String>[
      'Composição de mensagens fixa no rodapé (chat/IA).',
      'Precisa de safe-area + eixo de estilo (glass) em volta do composer.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Composing with no bar and no safe area → AppChatComposer directly.',
      'Search → AppSearchFooter.',
    ],
    pt: <String>[
      'Compose sem barra/safe-area → AppChatComposer direto.',
      'Busca → AppSearchFooter.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'controller',
      type: 'TextEditingController',
      isRequired: true,
    ),
    PropMeta(name: 'hintText', type: 'String?'),
    PropMeta(name: 'busy', type: 'bool'),
    PropMeta(name: 'onSend', type: 'VoidCallback?'),
    PropMeta(name: 'onStop', type: 'VoidCallback?'),
    PropMeta(name: 'onAttach', type: 'VoidCallback?'),
    PropMeta(name: 'attachments', type: 'List<Widget>'),
    PropMeta(name: 'modelLabel', type: 'String?'),
    PropMeta(name: 'style', type: 'AppStyle'),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
    PropMeta(name: 'floating', type: 'bool'),
    PropMeta(name: 'size', type: 'AppFieldSize'),
  ],
  states: <String>['default', 'busy', 'glass'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Chat', pt: 'Chat'),
      code:
          'AppChatFooter(controller: c, onSend: send, hintText: \'Pergunte…\')',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Let the bar carry the style (the composer stays filled).'],
    pt: <String>['Deixe a barra carregar o estilo (composer fica filled).'],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not style the composer from outside — pass `style` on the footer.',
    ],
    pt: <String>['Não estilize o composer por fora — passe `style` no footer.'],
  ),
  a11y: LocalizedText(
    en: 'Inherits AppChatComposer\'s semantics (send/stop, attachments).',
    pt: 'Herda a semântica do AppChatComposer (envio/parada, anexos).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_search_footer', 'app_navigation_footer'],
);
