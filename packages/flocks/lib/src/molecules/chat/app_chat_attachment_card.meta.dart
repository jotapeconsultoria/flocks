import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppChatAttachmentCard`. Registrado em `flocksCatalog`.
const AppComponentMeta appChatAttachmentCardMeta = AppComponentMeta(
  id: 'app_chat_attachment_card',
  name: 'AppChatAttachmentCard',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Square attachment card (thumbnail or large icon).',
    pt: 'Card quadrado de anexo (thumbnail ou ícone grande).',
  ),
  description: LocalizedText(
    en: 'The "card" alternative to the chip: an image thumbnail with the name over it, or a large icon tinted by category (resolved from the extension) with the name below. onTap previews it; onRemove puts the remove control in the corner.',
    pt:
        'Alternativa "cartão" ao chip: thumbnail da imagem com o nome sobreposto, '
        'ou um ícone grande tingido pela categoria (resolvida da extensão) com o '
        'nome abaixo. onTap visualiza; onRemove mostra o remover no canto.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The composer\'s attachment strip in card form (Claude style).',
    ],
    pt: <String>[
      'Faixa de anexos do composer em formato cartão (estilo Claude).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['The compact form → use AppChatAttachmentChip.'],
    pt: <String>['Formato compacto → use AppChatAttachmentChip.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'image', type: 'ImageProvider?'),
    PropMeta(name: 'label', type: 'String?'),
    PropMeta(name: 'kind', type: 'AppAttachmentKind?'),
    PropMeta(name: 'subtitle', type: 'String?'),
    PropMeta(name: 'onTap', type: 'VoidCallback?'),
    PropMeta(name: 'onRemove', type: 'VoidCallback?'),
    PropMeta(name: 'size', type: 'double', defaultValue: '104'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Attachment already sent, as a card',
        pt: 'Anexo já enviado, em cartão',
      ),
      code:
          'AppChatAttachmentCard(\n  label: \'rota-2026-07.xlsx\',\n  subtitle: \'240 KB\',\n  kind: AppAttachmentKind.spreadsheet,\n  onTap: () => _open(file),\n)',
      description: LocalizedText(
        en: 'The chip\'s large form: it has room for a subtitle and a thumbnail.',
        pt: 'A versão grande do chip: cabe subtítulo e miniatura.',
      ),
    ),
  ],
  a11y: LocalizedText(
    en: 'onTap/onRemove are labelled buttons.',
    pt: 'onTap/onRemove são botões rotulados.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_chat_attachment_chip', 'app_chat_composer'],
);
