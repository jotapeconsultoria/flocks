import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppQuotedMessage`. Registrado em `flocksCatalog`.
const AppComponentMeta appQuotedMessageMeta = AppComponentMeta(
  id: 'app_quoted_message',
  name: 'AppQuotedMessage',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Quoted-message block: author, excerpt and an optional thumbnail.',
    pt: 'Bloco de citação: autor, prévia e miniatura opcional.',
  ),
  description: LocalizedText(
    en: 'The reply/quote block of the chat subsystem — inside a bubble (the message being replied to, WhatsApp-style) or in the composer (the "replying to…" preview, with onRemove to cancel). Anatomy: a vertical accent bar, the author tinted with the same accent, a dimmed excerpt and an optional cover-cropped thumbnail. Color comes from the AppChatBubbleColor enum the conversation already uses: accentOn paints bar and author, resolve at 10% tints the background — one step BELOW the bubble\'s 14%, so the quote reads as a nested layer, not a second bubble. With onTap the whole body becomes ONE named target; onRemove adds the "×" as its OWN target (the AppFilterChip idiom — cancelling and navigating are different actions).',
    pt:
        'O bloco de responder/citar do subsistema de chat — dentro da bolha (a '
        'mensagem respondida, estilo WhatsApp) ou no composer (a prévia de '
        '"respondendo a…", com onRemove para cancelar). Anatomia: barra de '
        'acento vertical, autor tingido pelo mesmo acento, prévia esmaecida e '
        'miniatura opcional em cover. A cor vem do enum AppChatBubbleColor que '
        'a conversa já usa: accentOn pinta barra e autor, resolve a 10% tinge '
        'o fundo — um degrau ABAIXO dos 14% da bolha, para a citação ler como '
        'camada aninhada, não como segunda bolha. Com onTap o corpo inteiro '
        'vira UM alvo nomeado; onRemove acrescenta o "×" como alvo PRÓPRIO '
        '(idioma do AppFilterChip — cancelar e navegar são ações diferentes).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Showing the message a bubble replies to, above its content.',
      'The "replying to…" preview in the composer, with a cancel "×".',
      'A forwarded/quoted excerpt anywhere the chat idiom applies.',
    ],
    pt: <String>[
      'Mostrar a mensagem que uma bolha responde, acima do conteúdo dela.',
      'A prévia de "respondendo a…" no composer, com "×" de cancelar.',
      'Um trecho citado/encaminhado onde o idioma de chat se aplica.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Long-form quotations in documents → the content blockquote.',
      'An attachment on its own (no quoted text) → AppChatAttachmentChip.',
    ],
    pt: <String>[
      'Citação longa de documento → o blockquote de conteúdo.',
      'Um anexo sozinho (sem texto citado) → AppChatAttachmentChip.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'excerpt', type: 'String', isRequired: true),
    PropMeta(
      name: 'author',
      type: 'String?',
      description: LocalizedText(
        en: '`null` hides the author line (anonymous/system quote).',
        pt: '`null` oculta a linha do autor (citação anônima/de sistema).',
      ),
    ),
    PropMeta(
      name: 'thumbnail',
      type: 'ImageProvider?',
      description: LocalizedText(
        en: 'Cover-cropped preview on the end edge. Decorative for the screen reader — the excerpt is the information.',
        pt:
            'Preview em cover na borda do fim. Decorativa para o leitor de '
            'tela — a prévia textual é a informação.',
      ),
    ),
    PropMeta(
      name: 'color',
      type: 'AppChatBubbleColor',
      defaultValue: 'AppChatBubbleColor.primary',
      enumValues: <String>['primary', 'secondary', 'tertiary', 'neutral'],
    ),
    PropMeta(
      name: 'onTap',
      type: 'VoidCallback?',
      description: LocalizedText(
        en: 'Jump to the original message. `null` = not tappable.',
        pt: 'Pular para a mensagem original. `null` = não tappável.',
      ),
    ),
    PropMeta(
      name: 'onRemove',
      type: 'VoidCallback?',
      description: LocalizedText(
        en: 'Cancel the quote (the composer case). Renders the "×" as its own target.',
        pt: 'Cancela a citação (o caso composer). O "×" é alvo próprio.',
      ),
    ),
    PropMeta(name: 'maxLines', type: 'int', defaultValue: '2'),
    PropMeta(
      name: 'semanticLabel',
      type: 'String?',
      description: LocalizedText(
        en: 'Label of the body target. Defaults to a localized "quoted message from {author}" phrase.',
        pt:
            'Rótulo do alvo do corpo. Default "Mensagem citada de {author}" / '
            '"Ver mensagem citada".',
      ),
    ),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(
      name: 'radiusMode',
      type: 'AppRadiusMode?',
      enumValues: <String>['reto', 'redondo', 'circular', 'padrao'],
    ),
    PropMeta(name: 'radius', type: 'double?'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Reply inside a bubble',
        pt: 'Resposta na bolha',
      ),
      code:
          'AppChatBubble(author: AppChatAuthor.me, '
          "header: AppQuotedMessage(author: 'Ana', "
          "excerpt: 'Consegue mandar o relatório?', onTap: jump), "
          "child: const Text('Mandando agora!'))",
    ),
    CodeExample(
      title: LocalizedText(en: 'Composer preview', pt: 'Prévia no composer'),
      code:
          "AppQuotedMessage(author: 'Você', "
          "excerpt: 'A reunião fica para amanhã.', onRemove: cancelReply)",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Keep the excerpt short — the caller strips markdown and newlines.',
      'Match `color` with the conversation\'s bubble color.',
    ],
    pt: <String>[
      'Mantenha a prévia curta — o chamador limpa markdown e quebras.',
      'Case o `color` com a cor das bolhas da conversa.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not put the full original message in the excerpt — it is a preview.',
      'Do not use raw colors; the accent comes from the role enum.',
    ],
    pt: <String>[
      'Não ponha a mensagem original inteira na prévia — é uma prévia.',
      'Não use cor crua; o acento vem do enum de papel.',
    ],
  ),
  a11y: LocalizedText(
    en: 'With onTap the body is ONE named button (a localized "quoted message from {author}" label); with onRemove the "×" is a SEPARATE named target (a localized "remove quote" label) — two actions, two nodes. The thumbnail is excluded from semantics (the excerpt carries the information). Accent (accentOn) passes 3:1 against the surface in light and dark on both brands; the excerpt reads at onSurface 72%.',
    pt:
        'Com onTap o corpo é UM botão nomeado ("Mensagem citada de {author}"); '
        'com onRemove o "×" é alvo SEPARADO e nomeado ("Remover citação") — '
        'duas ações, dois nós. A miniatura fica fora da semântica (a prévia '
        'carrega a informação). O acento (accentOn) passa 3:1 sobre a '
        'superfície em claro/escuro nas duas marcas; a prévia lê em onSurface '
        '72%.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_chat_bubble',
    'app_chat_composer',
    'app_chat_attachment_chip',
  ],
);
