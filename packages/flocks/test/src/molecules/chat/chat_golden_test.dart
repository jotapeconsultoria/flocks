@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Goldens dos 11 componentes de chat, na matriz {claro,escuro} × {jotape,zxtrack}
// — prova visual da Regra 9. Cada componente vira um PNG por célula
// (`app_chat_bubble_jotape_light.png`, …). Os ícones renderizam um glifo
// determinístico via `AppIcon.debugIconBuilder`, instalado em
// `test/flutter_test_config.dart` (a rede/cache real estoura no sandbox).
//
// Gerar/atualizar:
//   flutter test --update-goldens --tags golden

/// Uma amostra: o nome de exibição, o slug do arquivo, a largura do palco
/// (`null` = encolhe ao conteúdo) e o construtor que depende do tema ativo.
class _ChatSample {
  const _ChatSample(this.name, this.file, this.build, {this.width});

  final String name;
  final String file;
  final double? width;
  final Widget Function(AppThemeData data) build;
}

/// Bolha `other` + bolha `me` com meta (o par típico de uma conversa).
Widget _bubbles(AppThemeData data) => const Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    AppChatBubble(
      tail: AppChatBubbleTail.top,
      child: AppText('Bora rastrear a frota de hoje?'),
    ),
    SizedBox(height: AppSpacings.s8),
    AppChatBubble(
      author: AppChatAuthor.me,
      footer: AppMessageMeta(time: '10:32', status: AppMessageStatus.read),
      child: AppText('Bora! Já puxando os dados.'),
    ),
  ],
);

/// Todos os status de entrega em coluna.
Widget _metas(AppThemeData data) => const Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    AppMessageMeta(time: '10:30', status: AppMessageStatus.sending),
    SizedBox(height: AppSpacings.s4),
    AppMessageMeta(time: '10:31', status: AppMessageStatus.sent),
    SizedBox(height: AppSpacings.s4),
    AppMessageMeta(time: '10:32', status: AppMessageStatus.delivered),
    SizedBox(height: AppSpacings.s4),
    AppMessageMeta(time: '10:33', status: AppMessageStatus.read),
    SizedBox(height: AppSpacings.s4),
    AppMessageMeta(
      time: '10:34',
      edited: true,
      status: AppMessageStatus.failed,
    ),
  ],
);

Widget _composer(AppThemeData data) => AppChatComposer(
  controller: TextEditingController(text: 'Quais veículos estão parados?'),
  hintText: 'Pergunte o que quiser…',
  onSend: () {},
  onAttach: () {},
  modelLabel: 'Atlas',
  onModelTap: () {},
  info: const AppText('Shift+Enter quebra a linha.'),
  contextProgress: 0.35,
  contextPopover: const AppText('35% do contexto usado.'),
  // Anexos e toolbar renderizam ABAIXO do campo (fora do compose).
  attachments: const <Widget>[
    AppChatAttachmentChip(label: 'relatorio.pdf'),
    AppChatAttachmentChip(label: 'dados.csv'),
  ],
);

Widget _attachments(AppThemeData data) => const Wrap(
  spacing: AppSpacings.s8,
  runSpacing: AppSpacings.s8,
  children: <Widget>[
    AppChatAttachmentChip(label: 'relatorio.pdf'),
    AppChatAttachmentChip(label: 'foto.png', onRemove: _noop),
  ],
);

Widget _typing(AppThemeData data) => const AppTypingIndicator();

Widget _status(AppThemeData data) =>
    const AppAssistantStatus(label: 'Buscando dados da frota');

Widget _actionBar(AppThemeData data) => AppChatActionBar(
  actions: <AppChatAction>[
    AppChatAction(icon: AppIcons.copy, label: 'Copiar', onPressed: () {}),
    AppChatAction(icon: AppIcons.sync, label: 'Regerar', onPressed: () {}),
    AppChatAction(
      icon: AppIcons.thumbsUp,
      label: 'Gostei',
      active: true,
      onPressed: () {},
    ),
    AppChatAction(
      icon: AppIcons.thumbsDown,
      label: 'Não gostei',
      onPressed: () {},
    ),
  ],
);

Widget _suggestions(AppThemeData data) => Wrap(
  spacing: AppSpacings.s8,
  runSpacing: AppSpacings.s8,
  children: <Widget>[
    AppSuggestionChip(
      label: 'Resumo do dia',
      icon: AppIcons.chat,
      onTap: () {},
    ),
    AppSuggestionChip(label: 'Veículos parados', onTap: () {}),
    AppSuggestionChip(label: 'Alertas de hoje', onTap: () {}),
  ],
);

Widget _dayDivider(AppThemeData data) => const Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    AppChatDayDivider(label: 'Hoje'),
    SizedBox(height: AppSpacings.s12),
    AppChatDayDivider(label: '14 jul', withRules: true),
  ],
);

Widget _questionCard(AppThemeData data) => AppQuestionCard.confirmation(
  title: 'Confirmação necessária — risco alto',
  subtitle: 'criar_geocerca',
  onConfirm: () {},
  onCancel: () {},
);

Widget _messageList(AppThemeData data) => SizedBox(
  height: 220,
  child: AppChatMessageList(
    itemCount: 3,
    itemBuilder: (BuildContext context, int i) => switch (i) {
      0 => const AppChatDayDivider(label: 'Hoje'),
      1 => const AppChatBubble(
        child: AppText('Oi! Tudo certo com o caminhão?'),
      ),
      _ => const AppChatBubble(
        author: AppChatAuthor.me,
        footer: AppMessageMeta(
          time: '09:12',
          status: AppMessageStatus.delivered,
        ),
        child: AppText('Tudo certo, chegou agora.'),
      ),
    },
  ),
);

void _noop() {}

const List<_ChatSample> _samples = <_ChatSample>[
  _ChatSample('AppChatBubble', 'app_chat_bubble', _bubbles, width: 320),
  _ChatSample('AppMessageMeta', 'app_message_meta', _metas),
  _ChatSample('AppChatComposer', 'app_chat_composer', _composer, width: 380),
  _ChatSample(
    'AppChatAttachmentChip',
    'app_chat_attachment_chip',
    _attachments,
    width: 320,
  ),
  _ChatSample('AppTypingIndicator', 'app_typing_indicator', _typing),
  _ChatSample('AppAssistantStatus', 'app_assistant_status', _status),
  _ChatSample('AppChatActionBar', 'app_chat_action_bar', _actionBar),
  _ChatSample(
    'AppSuggestionChip',
    'app_suggestion_chip',
    _suggestions,
    width: 320,
  ),
  _ChatSample(
    'AppChatDayDivider',
    'app_chat_day_divider',
    _dayDivider,
    width: 360,
  ),
  _ChatSample(
    'AppQuestionCard',
    'app_question_card',
    _questionCard,
    width: 380,
  ),
  _ChatSample(
    'AppChatMessageList',
    'app_chat_message_list',
    _messageList,
    width: 320,
  ),
];

Widget _host(
  AppThemeData data,
  Widget child, {
  double? width,
}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    // disableAnimations trava as animações perpétuas (typing/status) num quadro
    // determinístico e evita qualquer timer de cursor.
    data: const MediaQueryData(disableAnimations: true),
    child: AppTheme(
      data: data,
      // Container tingido pela superfície preenche o quadro (como os demais
      // goldens do DS); `alignment` dá restrições folgadas ao filho, e o
      // SizedBox prende a largura para os componentes sensíveis a ela
      // (alinhamento da bolha `me`, `Expanded` do composer) renderizarem justos.
      child: Container(
        key: const Key('golden'),
        color: data.colorTheme.surface,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(16),
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  for (final _ChatSample sample in _samples) {
    for (final AppBrandConfig brand in brands) {
      for (final bool dark in <bool>[false, true]) {
        final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

        testWidgets('${sample.name} golden · $label', (tester) async {
          final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

          await tester.pumpWidget(
            _host(data, sample.build(data), width: sample.width),
          );
          // Deixa o post-frame (scroll da lista) e o primeiro quadro correrem.
          await tester.pump();

          await expectLater(
            find.byKey(const Key('golden')),
            matchesGoldenFile('goldens/${sample.file}_$label.png'),
          );
        });
      }
    }
  }
}
