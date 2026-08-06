import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppChatDayDivider`. Registrado em `flocksCatalog`.
const AppComponentMeta appChatDayDividerMeta = AppComponentMeta(
  id: 'app_chat_day_divider',
  name: 'AppChatDayDivider',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Centered "Today/Yesterday/date" pill that separates days.',
    pt: 'Pílula central "Hoje/Ontem/data" que separa dias.',
  ),
  description: LocalizedText(
    en: 'Day divider for a conversation (WhatsApp\'s signature). The design system does not format dates: it takes the label ready-made. With withRules, it draws a rule on both sides.',
    pt:
        'Divisor de dia de uma conversa (assinatura do WhatsApp). O DS não '
        'formata datas: recebe o label pronto. Com withRules, desenha filetes '
        'dos dois lados.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Separating messages by day in an AppChatMessageList.'],
    pt: <String>['Separar mensagens por dia numa AppChatMessageList.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'label', type: 'String', isRequired: true),
    PropMeta(name: 'withRules', type: 'bool', defaultValue: 'false'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Day separator in the conversation',
        pt: 'Separador de dia na conversa',
      ),
      code: 'AppChatDayDivider(label: \'Hoje\')',
    ),
  ],
  a11y: LocalizedText(
    en: 'A reading landmark, not content: the label is read in order, between the previous day\'s last message and the new day\'s first. The withRules rules are decorative and stay out of the semantics tree.',
    pt:
        'Marco de leitura, não conteúdo: o label é lido em ordem, entre a última '
        'mensagem do dia anterior e a primeira do novo. Os filetes do withRules '
        'são decorativos e não entram na árvore semântica.',
  ),
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_chat_message_list'],
);
