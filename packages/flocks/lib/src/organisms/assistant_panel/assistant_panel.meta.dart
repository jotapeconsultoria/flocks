import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppAssistantPanel]. Registrado em `flocksCatalog`.
const AppComponentMeta appAssistantPanelMeta = AppComponentMeta(
  id: 'app_assistant_panel',
  name: 'AppAssistantPanel',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.7.0',
  summary: LocalizedText(
    en: 'Assistant side panel, always present: header, fixed banner, conversation and composer.',
    pt:
        'Painel lateral do assistente, sempre presente: cabeçalho, faixa fixa, '
        'conversa e composer.',
  ),
  description: LocalizedText(
    en: 'A full-height column beside the content, not an overlay. An assistant that covers the screen forces a choice between seeing the data and asking about it; here you can talk while looking at the screen that prompted the question. The alertBanner is FIXED between the header and the conversation: it is what upholds "alerts visible at all times", since a card inside the flow leaves the viewport as soon as the conversation scrolls. The shortcut badge in the header exists so the shortcut gets discovered. The width belongs to the caller — the panel fills whatever it is given.',
    pt:
        'Coluna de altura total ao lado do conteúdo, não um overlay. Um '
        'assistente que cobre a tela obriga a escolher entre ver o dado e '
        'perguntar sobre ele; aqui dá para conversar olhando a tela que motivou '
        'a pergunta. O alertBanner é FIXO entre cabeçalho e conversa: é o que '
        'sustenta "alertas visíveis a todo tempo", já que um cartão dentro do '
        'fluxo sai de vista assim que a conversa rola. O selo de atalho no '
        'cabeçalho existe para o atalho ser descoberto. A largura é de quem usa '
        '— o painel preenche o que receber.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'An assistant that has to coexist with the content, not cover it.',
      'A side panel with a header, a scrollable body and a fixed composer.',
    ],
    pt: <String>[
      'Assistente que precisa conviver com o conteúdo, não cobri-lo.',
      'Painel lateral com cabeçalho, corpo rolável e composer fixo.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A full-screen conversation (kiosk mode) → the chat screen directly.',
      'An ephemeral panel triggered by a button → AppSideSheet.',
    ],
    pt: <String>[
      'Conversa em tela cheia (modo quiosque) → a tela de chat direto.',
      'Painel efêmero acionado por um botão → AppSideSheet.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'body', type: 'Widget', isRequired: true),
    PropMeta(name: 'title', type: 'String', defaultValue: "'Assistente'"),
    PropMeta(name: 'statusLabel', type: 'String?'),
    PropMeta(name: 'isOnline', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'avatar', type: 'Widget?'),
    PropMeta(
      name: 'alertBanner',
      type: 'Widget?',
      description: LocalizedText(
        en: 'FIXED banner between the header and the conversation.',
        pt: 'Faixa FIXA entre cabeçalho e conversa.',
      ),
    ),
    PropMeta(name: 'composer', type: 'Widget?'),
    PropMeta(name: 'actions', type: 'List<Widget>', defaultValue: 'const []'),
    PropMeta(name: 'decoration', type: 'BoxDecoration?'),
  ],
  states: <String>['online', 'offline', 'with-banner'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Assistant in the shell',
        pt: 'Assistente no shell',
      ),
      code:
          "AppAssistantPanel(title: 'Atlas', statusLabel: 'Sempre online', "
          'alertBanner: alertsStrip, '
          'body: AppChatMessageList(...), composer: AppChatComposer(...))',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Keep the panel mounted — the history lives in it.',
      'Use the alertBanner for whatever has to survive the scroll.',
    ],
    pt: <String>[
      'Mantenha o painel montado — o histórico vive nele.',
      'Use o alertBanner para o que precisa sobreviver ao scroll.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not turn it into an overlay: that removes the context that prompted the question.',
      'Do not pin a width here — whoever assembles the shell decides.',
    ],
    pt: <String>[
      'Não transforme em overlay: some o contexto que motivou a pergunta.',
      'Não fixe largura aqui — quem monta o shell decide.',
    ],
  ),
  a11y: LocalizedText(
    en: 'The header is legible text (name + status), not color alone: the status dot accompanies the label instead of replacing it.',
    pt:
        'Cabeçalho é texto legível (nome + status), não só cor: o ponto de '
        'status acompanha o rótulo em vez de substituí-lo.',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_shell', 'app_chat_message_list', 'app_chat_composer'],
);
