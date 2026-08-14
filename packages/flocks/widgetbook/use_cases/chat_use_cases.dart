import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// Chat (LLM + WhatsApp): bubble, message meta, composer, attachment, typing,
// assistant status, action bar, suggestion, day divider, inline card, list.
// ---------------------------------------------------------------------------

// === AppChatBubble ==========================================================

@widgetbook.UseCase(name: 'Playground', type: AppChatBubble)
Widget appChatBubblePlayground(BuildContext context) {
  final text = context.knobs.string(
    label: 'text',
    initialValue: 'Bora rastrear! Quais veículos estão parados agora?',
  );
  final author = context.knobs.object.dropdown<AppChatAuthor>(
    label: 'author',
    options: AppChatAuthor.values,
    initialOption: AppChatAuthor.me,
    labelBuilder: (a) => a.name,
  );
  final color = context.knobs.object.dropdown<AppChatBubbleColor>(
    label: 'color (me)',
    options: AppChatBubbleColor.values,
    initialOption: AppChatBubbleColor.primary,
    labelBuilder: (c) => c.name,
  );
  final tail = context.knobs.object.dropdown<AppChatBubbleTail>(
    label: 'tail',
    options: AppChatBubbleTail.values,
    initialOption: AppChatBubbleTail.top,
    labelBuilder: (t) => t.name,
  );
  return wbUseCase(
    context,
    name: 'AppChatBubble',
    description:
        'A message bubble. Pick author, tint, tail; style/radius '
        'follow the addons.',
    child: SizedBox(
      width: 360,
      child: AppChatBubble(
        author: author,
        color: color,
        tail: tail,
        style: wbStyleKnob(context),
        radiusMode: wbRadiusModeKnob(context),
        footer: const AppMessageMeta(
          time: '10:32',
          status: AppMessageStatus.read,
        ),
        child: AppText(text),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppChatBubble)
Widget appChatBubbleStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppChatBubble',
  description: 'Author + tail combinations.',
  child: const SizedBox(
    width: 360,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppChatBubble(
          author: AppChatAuthor.other,
          child: AppText('Olá! Como posso ajudar?'),
        ),
        SizedBox(height: AppSpacings.s8),
        AppChatBubble(
          author: AppChatAuthor.me,
          footer: AppMessageMeta(time: '10:31', status: AppMessageStatus.sent),
          child: AppText('Quero um resumo do dia.'),
        ),
        SizedBox(height: AppSpacings.s8),
        AppChatBubble(
          author: AppChatAuthor.me,
          tail: AppChatBubbleTail.none,
          footer: AppMessageMeta(time: '10:31', status: AppMessageStatus.read),
          child: AppText('Por favor.'),
        ),
      ],
    ),
  ),
);

// === AppMessageMeta =========================================================

@widgetbook.UseCase(name: 'Playground', type: AppMessageMeta)
Widget appMessageMetaPlayground(BuildContext context) {
  final time = context.knobs.string(label: 'time', initialValue: '10:32');
  final status = context.knobs.object.dropdown<AppMessageStatus>(
    label: 'status',
    options: AppMessageStatus.values,
    initialOption: AppMessageStatus.read,
    labelBuilder: (s) => s.name,
  );
  final edited = context.knobs.boolean(label: 'edited', initialValue: false);
  return wbUseCase(
    context,
    name: 'AppMessageMeta',
    description:
        'Timestamp + delivery ticks. "read" is tinted; "failed" '
        'shows danger.',
    child: AppMessageMeta(time: time, status: status, edited: edited),
  );
}

@widgetbook.UseCase(name: 'States', type: AppMessageMeta)
Widget appMessageMetaStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppMessageMeta',
  description: 'Every delivery status.',
  child: Wrap(
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s16,
    children: <Widget>[
      for (final AppMessageStatus s in AppMessageStatus.values)
        wbState(
          context,
          name: s.name,
          width: 110,
          child: AppMessageMeta(time: '10:32', status: s),
        ),
    ],
  ),
);

// === AppChatComposer ========================================================

class _ComposerHost extends StatefulWidget {
  const _ComposerHost({
    required this.busy,
    required this.enabled,
    required this.withAttachments,
    required this.useCards,
    required this.showModel,
    required this.showInfo,
    required this.showContext,
    required this.size,
    required this.style,
    required this.radiusMode,
  });

  final bool busy;
  final bool enabled;
  final bool withAttachments;
  final bool useCards;
  final bool showModel;
  final bool showInfo;
  final bool showContext;
  final AppFieldSize size;
  final AppStyle? style;
  final AppRadiusMode? radiusMode;

  @override
  State<_ComposerHost> createState() => _ComposerHostState();
}

class _ComposerHostState extends State<_ComposerHost> {
  final TextEditingController _controller = TextEditingController();
  String _model = 'Atlas';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 440,
    child: AppChatComposer(
      controller: _controller,
      hintText: 'Pergunte ou peça o que quiser…',
      enabled: widget.enabled,
      busy: widget.busy,
      size: widget.size,
      style: widget.style,
      radiusMode: widget.radiusMode,
      onSend: () {},
      onStop: () {},
      onAttach: () {},
      modelLabel: widget.showModel ? _model : null,
      modelOptions: widget.showModel
          ? const <String>['Atlas', 'Lens']
          : const <String>[],
      onModelSelected: widget.showModel
          ? (String m) => setState(() => _model = m)
          : null,
      info: widget.showInfo
          ? const AppText('Use Shift+Enter para quebrar a linha.')
          : null,
      contextProgress: widget.showContext ? 0.35 : null,
      contextPopover: widget.showContext
          ? const AppText('35% do contexto usado.')
          : null,
      attachmentLayout: widget.useCards
          ? AppChatAttachmentLayout.row
          : AppChatAttachmentLayout.wrap,
      attachments: !widget.withAttachments
          ? const <Widget>[]
          : widget.useCards
          ? <Widget>[
              AppChatAttachmentCard(label: 'relatorio.pdf', onRemove: () {}),
              AppChatAttachmentCard(label: 'dados.csv', onRemove: () {}),
            ]
          : <Widget>[
              AppChatAttachmentChip(label: 'relatorio.pdf', onRemove: () {}),
              AppChatAttachmentChip(label: 'dados.csv', onRemove: () {}),
            ],
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppChatComposer)
Widget appChatComposerPlayground(BuildContext context) => wbUseCase(
  context,
  name: 'AppChatComposer',
  description:
      'Multimodal input; only the input + send sit on the surface. Attachments '
      'go ABOVE it and the toolbar (attach/model left, info/context right) '
      'below — both outside the surface (like Claude). Buttons are neutral; '
      'only the context ring is colored. Attachments follow the style. Enter '
      'sends; Shift+Enter breaks. Circular falls back to redondo with '
      'attachments OR when the text wraps to multiple lines.',
  child: _ComposerHost(
    busy: context.knobs.boolean(label: 'busy', initialValue: false),
    enabled: context.knobs.boolean(label: 'enabled', initialValue: true),
    withAttachments: context.knobs.boolean(
      label: 'with attachments',
      initialValue: true,
    ),
    useCards: context.knobs.boolean(
      label: 'attachments as cards',
      initialValue: false,
    ),
    showModel: context.knobs.boolean(label: 'model', initialValue: true),
    showInfo: context.knobs.boolean(label: 'info', initialValue: true),
    showContext: context.knobs.boolean(label: 'context', initialValue: true),
    size: wbFieldSizeKnob(context, label: 'size (default S)'),
    style: wbStyleKnob(context),
    radiusMode: wbRadiusModeKnob(context),
  ),
);

// === AppChatAttachmentChip / Card ===========================================

const List<String> _sampleFiles = <String>[
  'relatorio.pdf',
  'planilha.xlsx',
  'dados.csv',
  'contrato.docx',
  'apresentacao.pptx',
  'musica.mp3',
  'clipe.mp4',
  'backup.zip',
  'imagem.png',
  'config.xyz',
];

@widgetbook.UseCase(name: 'Playground', type: AppChatAttachmentChip)
Widget appChatAttachmentChipPlayground(BuildContext context) {
  final label = context.knobs.string(
    label: 'label (the extension picks the icon)',
    initialValue: 'relatorio.pdf',
  );
  final removable = context.knobs.boolean(
    label: 'removable',
    initialValue: true,
  );
  final viewable = context.knobs.boolean(
    label: 'viewable (onTap)',
    initialValue: true,
  );
  return wbUseCase(
    context,
    name: 'AppChatAttachmentChip',
    description:
        'File pill; icon + tint come from the extension. Image variant needs '
        'an ImageProvider at runtime.',
    child: AppChatAttachmentChip(
      label: label,
      style: wbStyleKnob(context),
      onRemove: removable ? () {} : null,
      onTap: viewable ? () {} : null,
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppChatAttachmentChip)
Widget appChatAttachmentChipKinds(BuildContext context) => wbUseCase(
  context,
  name: 'AppChatAttachmentChip',
  description: 'Icon + tint resolved per file extension.',
  maxWidth: 640,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s8,
    runSpacing: AppSpacings.s8,
    children: <Widget>[
      for (final String f in _sampleFiles)
        AppChatAttachmentChip(label: f, onRemove: () {}),
    ],
  ),
);

@widgetbook.UseCase(name: 'Playground', type: AppChatAttachmentCard)
Widget appChatAttachmentCardPlayground(BuildContext context) {
  final label = context.knobs.string(
    label: 'label (the extension picks the icon)',
    initialValue: 'relatorio.pdf',
  );
  final subtitle = context.knobs.string(label: 'subtitle', initialValue: 'PDF');
  final removable = context.knobs.boolean(
    label: 'removable',
    initialValue: true,
  );
  final viewable = context.knobs.boolean(
    label: 'viewable (onTap)',
    initialValue: true,
  );
  final size = wbSizeKnob(context, label: 'size', initial: AppSizes.s128);
  final layout = context.knobs.object.dropdown<AppChatAttachmentCardLayout>(
    label: 'layout',
    options: AppChatAttachmentCardLayout.values,
    initialOption: AppChatAttachmentCardLayout.square,
    labelBuilder: (l) => 'AppChatAttachmentCardLayout.${l.name}',
  );
  return wbUseCase(
    context,
    name: 'AppChatAttachmentCard',
    description:
        'Attachment card (Claude-style): square by default, or a horizontal '
        'row block. Image variant needs an ImageProvider at runtime.',
    child: AppChatAttachmentCard(
      label: label,
      subtitle: subtitle.isEmpty ? null : subtitle,
      size: size,
      layout: layout,
      style: wbStyleKnob(context),
      onRemove: removable ? () {} : null,
      onTap: viewable ? () {} : null,
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppChatAttachmentCard)
Widget appChatAttachmentCardKinds(BuildContext context) => wbUseCase(
  context,
  name: 'AppChatAttachmentCard',
  description:
      'Icon + tint resolved per file extension; the last line shows the row '
      'layout.',
  maxWidth: 720,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s12,
    runSpacing: AppSpacings.s12,
    children: <Widget>[
      for (final String f in _sampleFiles)
        AppChatAttachmentCard(label: f, onRemove: () {}),
      AppChatAttachmentCard(
        label: 'relatorio.pdf',
        subtitle: '240 KB',
        layout: AppChatAttachmentCardLayout.row,
        onRemove: () {},
      ),
    ],
  ),
);

// === AppTypingIndicator =====================================================

@widgetbook.UseCase(name: 'Playground', type: AppTypingIndicator)
Widget appTypingIndicatorPlayground(BuildContext context) {
  final dotSize = wbSizeKnob(context, label: 'dotSize', initial: AppSizes.s8);
  return wbUseCase(
    context,
    name: 'AppTypingIndicator',
    description:
        'Three bouncing dots. Toggle the Motion addon to see it freeze '
        'under reduce-motion.',
    child: AppTypingIndicator(
      dotSize: dotSize,
      color: wbSemanticColorKnob(context, label: 'color'),
    ),
  );
}

// === AppAssistantStatus =====================================================

class _AssistantStatusHost extends StatefulWidget {
  const _AssistantStatusHost({required this.showIndicator});

  final bool showIndicator;

  @override
  State<_AssistantStatusHost> createState() => _AssistantStatusHostState();
}

class _AssistantStatusHostState extends State<_AssistantStatusHost> {
  static const List<String> _labels = <String>[
    'Entendendo o pedido',
    'Buscando dados',
    'Organizando a resposta',
  ];
  int _i = 0;

  @override
  Widget build(BuildContext context) => wbUseCase(
    context,
    name: 'AppAssistantStatus',
    description:
        'Cycling status label with an animated swap. Advance to see '
        'the transition.',
    cta: wbCta(
      context,
      label: 'Next step',
      onPressed: () => setState(() => _i = (_i + 1) % _labels.length),
    ),
    child: AppAssistantStatus(
      label: _labels[_i],
      showIndicator: widget.showIndicator,
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppAssistantStatus)
Widget appAssistantStatusPlayground(BuildContext context) =>
    _AssistantStatusHost(
      showIndicator: context.knobs.boolean(
        label: 'showIndicator',
        initialValue: true,
      ),
    );

// === AppChatActionBar =======================================================

@widgetbook.UseCase(name: 'Playground', type: AppChatActionBar)
Widget appChatActionBarPlayground(BuildContext context) {
  final liked = context.knobs.boolean(
    label: 'liked (active)',
    initialValue: false,
  );
  return wbUseCase(
    context,
    name: 'AppChatActionBar',
    description:
        'Icon actions under an assistant reply. Active state tints by '
        'secondary.',
    child: AppChatActionBar(
      actions: <AppChatAction>[
        AppChatAction(
          icon: AppIconToken.thumbsUp,
          label: 'Gostei',
          active: liked,
          onPressed: () {},
        ),
        AppChatAction(
          icon: AppIconToken.thumbsDown,
          label: 'Não gostei',
          onPressed: () {},
        ),
        AppChatAction(
          icon: AppIcons.rotate,
          label: 'Regenerar',
          onPressed: () {},
        ),
        AppChatAction(
          icon: AppIconToken.copy,
          label: 'Copiar',
          onPressed: () {},
        ),
      ],
    ),
  );
}

// === AppSuggestionChip ======================================================

@widgetbook.UseCase(name: 'Playground', type: AppSuggestionChip)
Widget appSuggestionChipPlayground(BuildContext context) {
  final label = context.knobs.string(
    label: 'label',
    initialValue: 'Quais veículos estão parados?',
  );
  final withIcon = context.knobs.boolean(
    label: 'with icon',
    initialValue: true,
  );
  return wbUseCase(
    context,
    name: 'AppSuggestionChip',
    description: 'A tappable prompt/quick-reply chip; put several in a Wrap.',
    child: AppSuggestionChip(
      label: label,
      icon: withIcon ? AppIconToken.chat : null,
      style: wbStyleKnob(context, nullLabel: 'Default (outlined)'),
      radiusMode: wbRadiusModeKnob(context),
      onTap: () {},
    ),
  );
}

// === AppChatDayDivider ======================================================

@widgetbook.UseCase(name: 'Playground', type: AppChatDayDivider)
Widget appChatDayDividerPlayground(BuildContext context) {
  final label = context.knobs.string(label: 'label', initialValue: 'Hoje');
  final withRules = context.knobs.boolean(
    label: 'withRules',
    initialValue: true,
  );
  return wbUseCase(
    context,
    name: 'AppChatDayDivider',
    description: 'Centered date pill separating days.',
    child: SizedBox(
      width: 360,
      child: AppChatDayDivider(label: label, withRules: withRules),
    ),
  );
}

// === AppQuestionCard ========================================================

// Um Playground, três construtores. Antes eram três casos irmãos — mas o que
// muda entre eles é qual construtor se chama, e isso é um knob, não um caso.

enum _QuestionKind { confirmation, singleChoice, multipleChoice }

@widgetbook.UseCase(name: 'Playground', type: AppQuestionCard)
Widget appQuestionCardPlayground(BuildContext context) {
  final kind = context.knobs.object.dropdown<_QuestionKind>(
    label: 'constructor',
    options: _QuestionKind.values,
    initialOption: _QuestionKind.confirmation,
    labelBuilder: (k) => 'AppQuestionCard.${k.name}',
  );
  final role = context.knobs.object.dropdown<AppQuestionCardRole>(
    label: 'role',
    options: AppQuestionCardRole.values,
    initialOption: AppQuestionCardRole.warning,
    labelBuilder: (r) => r.name,
  );
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final withDetail = context.knobs.boolean(
    label: 'detail (confirmation only)',
    initialValue: true,
  );
  final allowCustom = context.knobs.boolean(
    label: 'allowCustom (choice only)',
    initialValue: true,
  );
  final style = wbStyleKnob(context);
  final radiusMode = wbRadiusModeKnob(context);

  return wbUseCase(
    context,
    name: 'AppQuestionCard',
    description:
        'The card the assistant uses to ask before acting. confirmation is '
        'the risky-action gate (detail carries the payload being confirmed); '
        'singleChoice/multipleChoice ask with up to 3 options plus an optional '
        'free-text answer — the escape hatch for when none of the three is it.',
    child: SizedBox(
      width: 380,
      child: switch (kind) {
        _QuestionKind.confirmation => AppQuestionCard.confirmation(
          title: 'Confirmação necessária — risco alto',
          subtitle: 'criar_geocerca',
          role: role,
          enabled: enabled,
          style: style,
          radiusMode: radiusMode,
          detail: withDetail
              ? const AppText('{ "raio": 500, "centro": "-23.5, -46.6" }')
              : null,
          onConfirm: () {},
          onCancel: () {},
        ),
        _QuestionKind.singleChoice => AppQuestionCard.singleChoice(
          title: 'Qual relatório você quer?',
          options: const <String>[
            'Resumo do dia',
            'Veículos parados',
            'Alertas',
          ],
          role: role,
          enabled: enabled,
          allowCustom: allowCustom,
          style: style,
          radiusMode: radiusMode,
          onSingleSelected: (_) {},
          onCancel: () {},
        ),
        _QuestionKind.multipleChoice => AppQuestionCard.multipleChoice(
          title: 'Quais colunas exportar?',
          options: const <String>['Placa', 'Motorista', 'KM rodado'],
          role: role,
          enabled: enabled,
          allowCustom: allowCustom,
          style: style,
          radiusMode: radiusMode,
          onMultipleSubmit: (_) {},
          onCancel: () {},
        ),
      },
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppQuestionCard)
Widget appQuestionCardRoles(BuildContext context) => wbUseCase(
  context,
  name: 'AppQuestionCard',
  description: 'The semantic roles (confirmation).',
  maxWidth: 640,
  child: Wrap(
    spacing: AppSpacings.s16,
    runSpacing: AppSpacings.s16,
    children: <Widget>[
      for (final AppQuestionCardRole r in AppQuestionCardRole.values)
        SizedBox(
          width: 260,
          child: AppQuestionCard.confirmation(
            title: r.name,
            subtitle: 'exemplo',
            role: r,
            onConfirm: () {},
            onCancel: () {},
          ),
        ),
    ],
  ),
);

// === AppChatMessageList =====================================================

@widgetbook.UseCase(name: 'Playground', type: AppChatMessageList)
Widget appChatMessageListPlayground(BuildContext context) {
  final stick = context.knobs.boolean(
    label: 'stickToBottom',
    initialValue: true,
  );
  final rows = <Widget>[
    const AppChatDayDivider(label: 'Hoje'),
    const AppChatBubble(
      author: AppChatAuthor.other,
      child: AppText('Olá! Como posso ajudar?'),
    ),
    const AppChatBubble(
      author: AppChatAuthor.me,
      footer: AppMessageMeta(time: '10:31', status: AppMessageStatus.read),
      child: AppText('Resumo do dia, por favor.'),
    ),
    const AppChatBubble(
      author: AppChatAuthor.other,
      child: AppText('Claro — 12 veículos ativos, 3 parados.'),
    ),
  ];
  return wbUseCase(
    context,
    name: 'AppChatMessageList',
    description:
        'Sticks to the bottom, auto-scrolls, spaces items. Grouping/'
        'dividers come from the itemBuilder.',
    child: SizedBox(
      height: 300,
      width: 380,
      child: AppChatMessageList(
        itemCount: rows.length,
        stickToBottom: stick,
        itemBuilder: (context, i) => rows[i],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// States — a visão de conjunto das peças de chat. O que cada uma mostra é o
// estado que o Playground só alcança um de cada vez.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: AppChatComposer)
Widget appChatComposerStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppChatComposer',
  description:
      'Idle, busy (send becomes stop), disabled and with attachments. Busy is '
      'not "disabled with a spinner": the field keeps taking text, because the '
      'next question is usually typed while the last answer streams.',
  maxWidth: 760,
  panelPadding: AppSpacings.s24,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    spacing: AppSpacings.s24,
    children: [
      for (final (String name, bool busy, bool enabled, bool withAttachments)
          in const <(String, bool, bool, bool)>[
            ('idle', false, true, false),
            ('busy (stop)', true, true, false),
            ('disabled', false, false, false),
            ('with attachments', false, true, true),
          ])
        wbState(
          context,
          name: name,
          width: 420,
          child: AppChatComposer(
            controller: TextEditingController(),
            hintText: 'Pergunte alguma coisa…',
            busy: busy,
            enabled: enabled,
            attachments: withAttachments
                ? const <Widget>[
                    AppChatAttachmentChip(label: 'relatorio.pdf'),
                    AppChatAttachmentChip(label: 'rota.xlsx'),
                  ]
                : const <Widget>[],
            onSend: () {},
            onStop: () {},
          ),
        ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppTypingIndicator)
Widget appTypingIndicatorStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppTypingIndicator',
  description:
      'Dot size and colour. The animation is gated by AppMotion, so under '
      'reduce-motion the dots hold still and the live region keeps announcing '
      '— the information does not live in the movement.',
  maxWidth: 640,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s32,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(context, name: 'default', child: const AppTypingIndicator()),
      wbState(
        context,
        name: 'dotSize: s12',
        child: const AppTypingIndicator(dotSize: AppSizes.s12),
      ),
      wbState(
        context,
        name: 'accent colour',
        child: AppTypingIndicator(
          color: AppTheme.of(context).colorTheme.secondary,
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppAssistantStatus)
Widget appAssistantStatusStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppAssistantStatus',
  description:
      'With and without the presence dot, and with a semantic colour. The '
      'label is a live region: changing it announces the new step, which is '
      'the whole point of showing the step at all.',
  maxWidth: 700,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s32,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'with indicator',
        width: 220,
        child: const AppAssistantStatus(label: 'Consultando os veículos…'),
      ),
      wbState(
        context,
        name: 'no indicator',
        width: 220,
        child: const AppAssistantStatus(label: 'Pronto', showIndicator: false),
      ),
      wbState(
        context,
        name: 'semantic colour',
        width: 220,
        child: AppAssistantStatus(
          label: 'Falha ao consultar',
          color: AppTheme.of(context).colorTheme.danger,
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppChatActionBar)
Widget appChatActionBarStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppChatActionBar',
  description:
      'Neutral, one action active, and a bigger icon size. `active` is what '
      'makes a rating stick: without it, the user cannot tell whether the '
      'thumbs-up registered.',
  maxWidth: 700,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s32,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'neutral',
        width: 200,
        child: AppChatActionBar(
          actions: <AppChatAction>[
            AppChatAction(
              icon: AppIconToken.copy,
              label: 'Copiar',
              onPressed: () {},
            ),
            AppChatAction(
              icon: AppIcons.synchronizeRefreshArrow,
              label: 'Regenerar',
              onPressed: () {},
            ),
          ],
        ),
      ),
      wbState(
        context,
        name: 'one active',
        width: 200,
        child: AppChatActionBar(
          actions: <AppChatAction>[
            AppChatAction(
              icon: AppIconToken.thumbsUp,
              label: 'Gostei',
              active: true,
              onPressed: () {},
            ),
            AppChatAction(
              icon: AppIconToken.thumbsDown,
              label: 'Não gostei',
              onPressed: () {},
            ),
          ],
        ),
      ),
      wbState(
        context,
        name: 'iconSize: m',
        width: 200,
        child: AppChatActionBar(
          iconSize: AppIconSize.m,
          actions: <AppChatAction>[
            AppChatAction(
              icon: AppIconToken.copy,
              label: 'Copiar',
              onPressed: () {},
            ),
          ],
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppSuggestionChip)
Widget appSuggestionChipStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSuggestionChip',
  description:
      'Short, with icon, and long enough to wrap. maxLines: 2 is deliberate — '
      'a suggestion the user cannot read whole is a suggestion they will not '
      'press.',
  maxWidth: 720,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'short',
        width: 200,
        child: AppSuggestionChip(label: 'Veículos parados', onTap: () {}),
      ),
      wbState(
        context,
        name: 'with icon',
        width: 200,
        child: AppSuggestionChip(
          label: 'Resumo do dia',
          icon: AppIconToken.dashboard,
          onTap: () {},
        ),
      ),
      wbState(
        context,
        name: 'wraps (maxLines: 2)',
        width: 200,
        child: AppSuggestionChip(
          label: 'Quais veículos ficaram sem sinal por mais de uma hora?',
          onTap: () {},
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppChatDayDivider)
Widget appChatDayDividerStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppChatDayDivider',
  description:
      'Bare pill vs with rules. The DS does not format dates — the label '
      'arrives ready, because "Hoje"/"Ontem" is a product decision, not a '
      'rendering one.',
  maxWidth: 640,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    spacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'pill',
        width: 360,
        child: const AppChatDayDivider(label: 'Hoje'),
      ),
      wbState(
        context,
        name: 'withRules',
        width: 360,
        child: const AppChatDayDivider(label: '15 de julho', withRules: true),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppChatMessageList)
Widget appChatMessageListStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppChatMessageList',
  description:
      'Short conversation (anchored to the bottom, not stretched to fill) vs '
      'a long one that scrolls. stickToBottom is why a new message does not '
      'leave the reader mid-air.',
  maxWidth: 760,
  panelPadding: AppSpacings.s24,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      for (final (String name, int count) in const <(String, int)>[
        ('2 messages', 2),
        ('12 messages (scrolls)', 12),
      ])
        wbState(
          context,
          name: name,
          width: 320,
          child: SizedBox(
            height: 240,
            child: AppChatMessageList(
              itemCount: count,
              itemBuilder: (BuildContext context, int i) => AppChatBubble(
                author: i.isEven ? AppChatAuthor.other : AppChatAuthor.me,
                child: AppText('Mensagem ${i + 1}'),
              ),
            ),
          ),
        ),
    ],
  ),
);
