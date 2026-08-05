import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppChatMessageList`. Registrado em `flocksCatalog`.
const AppComponentMeta appChatMessageListMeta = AppComponentMeta(
  id: 'app_chat_message_list',
  name: 'AppChatMessageList',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@1.1.0',
  summary: LocalizedText(
    en: 'Scrollable list that sticks to the bottom + auto-scroll + spacing.',
    pt: 'Lista rolável que gruda no fim + auto-scroll + espaçamento.',
  ),
  description: LocalizedText(
    en: 'The conversation\'s "floor": it anchors content to the bottom when short, scrolls to the end when a new message arrives and spaces the items. Agnostic: it neither groups nor inserts dividers — that comes from the consumer\'s itemBuilder.',
    pt:
        'O "chão" da conversa: ancora o conteúdo na base quando curto, rola para '
        'o fim ao chegar mensagem nova e espaça os itens. Agnóstica: não agrupa '
        'nem insere divisores — isso vem do itemBuilder do consumidor.',
  ),
  whenToUse: LocalizedList(
    en: <String>['The scroll container of a chat screen.'],
    pt: <String>['Container de rolagem de uma tela de chat.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'itemCount', type: 'int', isRequired: true),
    PropMeta(
      name: 'itemBuilder',
      type: 'IndexedWidgetBuilder',
      isRequired: true,
    ),
    PropMeta(name: 'controller', type: 'ScrollController?'),
    PropMeta(name: 'stickToBottom', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'autoScroll', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'spacing', type: 'double', defaultValue: 'AppSpacings.s16'),
    PropMeta(
      name: 'padding',
      type: 'EdgeInsets',
      defaultValue: 'EdgeInsets.zero',
    ),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'List that sticks to the bottom',
        pt: 'Lista que gruda no fim',
      ),
      code:
          'AppChatMessageList(\n'
          '  itemCount: messages.length,\n'
          '  itemBuilder: (BuildContext context, int i) => AppChatBubble(\n'
          '    author: messages[i].author,\n'
          '    child: AppText(messages[i].text),\n'
          '  ),\n'
          ')',
      description: LocalizedText(
        en: 'With stickToBottom the list starts at the end and follows each new message, except while the user has scrolled back.',
        pt:
            'Com stickToBottom a lista nasce no fim e acompanha a mensagem '
            'nova, menos quando o usuário rolou para trás.',
      ),
    ),
  ],
  a11y: LocalizedText(
    en: 'It is only the scroll container: the conversation\'s semantics live in the items (AppChatBubble groups a message into one labelled node). Auto-scroll does not steal focus — whoever was reading further up stays where they were.',
    pt:
        'É só o container de rolagem: a semântica da conversa mora nos itens '
        '(AppChatBubble agrupa a mensagem num nó rotulado). O auto-scroll não '
        'rouba o foco — quem estava lendo mais acima continua onde parou.',
  ),
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_chat_bubble', 'app_chat_day_divider'],
);
