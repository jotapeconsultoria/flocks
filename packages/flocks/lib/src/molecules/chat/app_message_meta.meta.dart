import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppMessageMeta`. Registrado em `flocksCatalog`.
const AppComponentMeta appMessageMetaMeta = AppComponentMeta(
  id: 'app_message_meta',
  name: 'AppMessageMeta',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Time + delivery ticks in a bubble\'s footer.',
    pt: 'Horário + ticks de entrega no rodapé de uma bolha.',
  ),
  description: LocalizedText(
    en: 'A message\'s compact meta: the time (already formatted by the app) and, optionally, delivery status as ticks (sending/sent/delivered/read/failed). "Read" tints with info; "failed" with danger.',
    pt:
        'Meta compacta de uma mensagem: horário (já formatado pelo app) e, '
        'opcionalmente, o status de entrega como ticks (enviando/enviada/'
        'entregue/lida/falhou). "Lida" tinge com info; "falhou" com danger.',
  ),
  whenToUse: LocalizedList(
    en: <String>['The footer of an AppChatBubble.'],
    pt: <String>['Rodapé (footer) de uma AppChatBubble.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A system or alert status → use AppBadge/AppAlert.'],
    pt: <String>['Status de sistema/alerta → use AppBadge/AppAlert.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'time',
      type: 'String?',
      description: LocalizedText(
        en: 'Already formatted time. Null = status-only meta (requires status != none, asserted).',
        pt: 'Horário já formatado. Nulo = meta só de status (exige status != none, assert).',
      ),
    ),
    PropMeta(
      name: 'status',
      type: 'AppMessageStatus',
      defaultValue: 'AppMessageStatus.none',
      enumValues: <String>[
        'none',
        'sending',
        'sent',
        'delivered',
        'read',
        'failed',
      ],
    ),
    PropMeta(name: 'edited', type: 'bool', defaultValue: 'false'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Time + delivery status',
        pt: 'Hora + status de entrega',
      ),
      code:
          'AppMessageMeta(\n  time: message.sentAt,\n  status: AppMessageStatus.delivered,\n  edited: message.wasEdited,\n)',
      description: LocalizedText(
        en: 'Goes in AppChatBubble\'s footer slot. The status is labelled, not only colored.',
        pt: 'Vai no slot footer da AppChatBubble. O status é rotulado, não só colorido.',
      ),
    ),
  ],
  a11y: LocalizedText(
    en: 'The status is exposed as a label too (it does not depend on color alone).',
    pt: 'O status também é exposto como rótulo (não depende só da cor).',
  ),
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_chat_bubble'],
);
