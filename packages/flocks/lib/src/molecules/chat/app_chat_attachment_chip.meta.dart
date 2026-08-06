import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppChatAttachmentChip`. Registrado em `flocksCatalog`.
const AppComponentMeta appChatAttachmentChipMeta = AppComponentMeta(
  id: 'app_chat_attachment_chip',
  name: 'AppChatAttachmentChip',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Image thumbnail or file pill, with a remove control.',
    pt: 'Thumbnail de imagem ou pílula de arquivo, com remover.',
  ),
  description: LocalizedText(
    en: 'Preview of a composer attachment: a thumbnail (through an ImageProvider) or an icon+name pill for files. The remove button reuses AppInteraction.',
    pt:
        'Preview de um anexo do composer: thumbnail (via ImageProvider) ou uma '
        'pílula ícone+nome para arquivos. O botão de remover reusa AppInteraction.',
  ),
  whenToUse: LocalizedList(
    en: <String>['The attachment strip of an AppChatComposer.'],
    pt: <String>['Faixa de anexos de um AppChatComposer.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'image', type: 'ImageProvider?'),
    PropMeta(name: 'label', type: 'String?'),
    PropMeta(name: 'onRemove', type: 'VoidCallback?'),
    PropMeta(name: 'size', type: 'double', defaultValue: '48'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Removable attachment in the send queue',
        pt: 'Anexo removível na fila de envio',
      ),
      code:
          'AppChatAttachmentChip(\n  label: \'relatorio.pdf\',\n  kind: AppAttachmentKind.pdf,\n  onRemove: () => _remove(file),\n)',
      description: LocalizedText(
        en: 'With no kind, the icon comes from the label\'s extension.',
        pt: 'Sem kind o ícone sai da extensão do label.',
      ),
    ),
  ],
  a11y: LocalizedText(
    en: 'Remove button with a label ("Remove attachment").',
    pt: 'Botão de remover rotulado ("Remover anexo").',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_chat_composer'],
);
