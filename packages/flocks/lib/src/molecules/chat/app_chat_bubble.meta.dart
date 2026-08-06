import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppChatBubble`. Registrado em `flocksCatalog`.
const AppComponentMeta appChatBubbleMeta = AppComponentMeta(
  id: 'app_chat_bubble',
  name: 'AppChatBubble',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Content-agnostic message bubble (LLM + WhatsApp style).',
    pt: 'Bolha de mensagem agnóstica de conteúdo (LLM + estilo WhatsApp).',
  ),
  description: LocalizedText(
    en: 'The visual shell of a message: alignment by author (me/other), tint or surface, corners with an asymmetric tail, a maximum width and header/footer slots. It takes an arbitrary child (text, markdown, image). It takes part in the style and shape axes and reads 100% from the theme.',
    pt:
        'A casca visual de uma mensagem: alinhamento por autor (me/other), tint '
        'ou superfície, cantos com tail assimétrico, largura máxima e slots '
        'header/footer. Recebe um child arbitrário (texto, markdown, imagem). '
        'Participa dos eixos style/forma e lê 100% do tema.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Rendering any message in a conversation.',
      'The user\'s bubble in an LLM chat, or both sides in a WhatsApp-style chat.',
    ],
    pt: <String>[
      'Renderizar qualquer mensagem de uma conversa.',
      'Bolha do usuário num chat com LLM ou ambos os lados num chat WhatsApp.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A "flat" assistant reply (full width, no bubble) → render the content directly + AppChatActionBar.',
    ],
    pt: <String>[
      'Resposta do assistente "plana" (largura cheia, sem bolha) → renderize o '
          'conteúdo direto + AppChatActionBar.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'child',
      type: 'Widget',
      isRequired: true,
      description: LocalizedText(
        en: 'The bubble\'s agnostic content.',
        pt: 'Conteúdo agnóstico da bolha.',
      ),
    ),
    PropMeta(
      name: 'author',
      type: 'AppChatAuthor',
      defaultValue: 'AppChatAuthor.other',
      enumValues: <String>['me', 'other'],
    ),
    PropMeta(
      name: 'color',
      type: 'AppChatBubbleColor',
      defaultValue: 'AppChatBubbleColor.primary',
      enumValues: <String>['primary', 'secondary', 'tertiary', 'neutral'],
    ),
    PropMeta(
      name: 'tail',
      type: 'AppChatBubbleTail',
      defaultValue: 'AppChatBubbleTail.top',
      enumValues: <String>['none', 'top', 'bottom'],
    ),
    PropMeta(name: 'header', type: 'Widget?'),
    PropMeta(name: 'footer', type: 'Widget?'),
    PropMeta(name: 'style', type: 'AppStyle?'),
    PropMeta(name: 'maxWidthFraction', type: 'double', defaultValue: '0.78'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'User message', pt: 'Mensagem do usuário'),
      code:
          'AppChatBubble(\n  author: AppChatAuthor.me,\n  child: AppText(\'Quantos veículos estão parados agora?\'),\n)',
      description: LocalizedText(
        en: 'Aligns right and tints with the author\'s color. The child is agnostic — text, markdown or image.',
        pt: 'Alinha à direita e tinge com a cor do autor. O child é agnóstico — texto, markdown ou imagem.',
      ),
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Bubble from the other side with meta in the footer',
        pt: 'Bolha do outro lado com meta no rodapé',
      ),
      code:
          'AppChatBubble(\n  author: AppChatAuthor.other,\n  color: AppChatBubbleColor.neutral,\n  tail: AppChatBubbleTail.bottom,\n  footer: AppMessageMeta(time: sentAt, status: AppMessageStatus.read),\n  child: AppMarkdown(answer),\n)',
    ),
  ],
  a11y: LocalizedText(
    en: 'Takes a semanticLabel to group the message into one labelled node.',
    pt: 'Aceita semanticLabel para agrupar a mensagem num nó rotulado.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_message_meta', 'app_chat_message_list'],
);
