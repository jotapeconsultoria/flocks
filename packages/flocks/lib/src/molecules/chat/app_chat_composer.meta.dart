import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppChatComposer`. Registrado em `flocksCatalog`.
const AppComponentMeta appChatComposerMeta = AppComponentMeta(
  id: 'app_chat_composer',
  name: 'AppChatComposer',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@1.1.0',
  summary: LocalizedText(
    en: 'Multimodal field with a toolbar (attachment/model/info/context).',
    pt: 'Campo multimodal com toolbar (anexo/modelo/info/contexto).',
  ),
  description: LocalizedText(
    en: 'The surface wraps ONLY the compose area (a "bare" multiline AppInput + a bare send/stop button). OUTSIDE it (as in Claude): attachments ABOVE the input and the toolbar BELOW (left: attachment + model; right: info popover + context ring). Neutral items (onSurface) with hover/focus/click + tooltip; the only colored one is the context ring. Attachments follow the composer\'s style. It resolves the global style axis (filled/outlined/elevated, with an opaque fill — so the shadow does not bleed) and the shape axis (circular becomes round with attachments OR multiline). Enter sends; Shift+Enter breaks the line. Replaces Material\'s TextField.',
    pt:
        'A superfície envolve SÓ o compose (AppInput multiline "nu" + botão '
        'enviar/parar bare). FORA dela (como no Claude): anexos ACIMA do input e '
        'a toolbar ABAIXO (esquerda: anexo + modelo; direita: info popover + anel '
        'de contexto). Itens neutros (onSurface) com hover/foco/clique + tooltip; '
        'o único colorido é o anel de contexto. Anexos seguem o estilo do '
        'composer. Resolve os eixos globais de estilo (filled/outlined/elevated, '
        'fundo opaco — sombra não vaza) e de forma (circular vira redondo com '
        'anexos OU multiline). Enter envia; Shift+Enter quebra. Substitui o '
        'TextField do Material.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Message input for any chat.'],
    pt: <String>['Entrada de mensagens de qualquer chat.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['An ordinary form field → use AppInput directly.'],
    pt: <String>['Campo de formulário comum → use AppInput direto.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'controller',
      type: 'TextEditingController',
      isRequired: true,
    ),
    PropMeta(name: 'onSend', type: 'VoidCallback?'),
    PropMeta(name: 'onStop', type: 'VoidCallback?'),
    PropMeta(name: 'onAttach', type: 'VoidCallback?'),
    PropMeta(
      name: 'attachments',
      type: 'List<Widget>',
      defaultValue: 'const []',
    ),
    PropMeta(name: 'attachmentLimit', type: 'int', defaultValue: '2'),
    PropMeta(name: 'modelLabel', type: 'String?'),
    PropMeta(name: 'onModelTap', type: 'VoidCallback?'),
    PropMeta(
      name: 'info',
      type: 'Widget?',
      description: LocalizedText(en: 'info popover', pt: 'popover de info'),
    ),
    PropMeta(
      name: 'contextProgress',
      type: 'double?',
      description: LocalizedText(en: '0..1', pt: '0..1'),
    ),
    PropMeta(name: 'contextPopover', type: 'Widget?'),
    PropMeta(name: 'busy', type: 'bool', defaultValue: 'false'),
    PropMeta(
      name: 'size',
      type: 'AppFieldSize',
      defaultValue: 'AppFieldSize.s',
      enumValues: <String>['s', 'm', 'l'],
    ),
    PropMeta(name: 'style', type: 'AppStyle?'),
    PropMeta(
      name: 'radiusMode',
      type: 'AppRadiusMode?',
      description: LocalizedText(
        en: 'with attachments, circular → round',
        pt: 'com anexos, circular → redondo',
      ),
    ),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Basic composer', pt: 'Composer básico'),
      code:
          'AppChatComposer(\n  controller: _controller,\n  hintText: \'Pergunte alguma coisa…\',\n  onSend: _send,\n)',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'While the assistant is answering',
        pt: 'Enquanto o assistente responde',
      ),
      code:
          'AppChatComposer(\n  controller: _controller,\n  busy: true,\n  onStop: _cancel,\n  attachments: files.map(AppChatAttachmentChip.new).toList(),\n)',
      description: LocalizedText(
        en: 'With busy, the send button becomes stop; attachments sit above the field.',
        pt: 'Com busy o botão de enviar vira parar; os anexos ficam acima do campo.',
      ),
    ),
  ],
  a11y: LocalizedText(
    en: 'Attachment/model/info/send/stop with labelled semantics; a tooltip on the attachment limit.',
    pt:
        'Anexo/modelo/info/enviar/parar com semântica rotulada; tooltip no '
        'limite de anexos.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_chat_attachment_chip'],
);
