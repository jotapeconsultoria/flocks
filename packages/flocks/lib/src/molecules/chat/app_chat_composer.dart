import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../card/card.dart' show AppOverlayPlacement;
import '../input/input.dart';
import '../interactive/interactive.dart';
import '../menu/menu.dart';
import '../popover/popover.dart';
import '../tooltip/tooltip.dart';

/// Tamanho visual comum dos itens da toolbar (ícones/anel) — o texto do modelo
/// (`labelLarge`) casa com isto.
const double _kFooterItemSize = 20;

/// Tons **neutros** dos itens da toolbar. O único elemento com cor é o anel de
/// contexto (progresso) — todos os botões usam `onSurface` esmaecido.
const double _kIconActiveOpacity = 0.7; // ícone ativo (anexo/info)
const double _kSendActiveOpacity = 0.9; // enviar/parar (ação primária)
const double _kIconDisabledOpacity = 0.35; // ícone desabilitado

/// Tamanho do ícone de enviar (bare).
const double _kSendIconSize = 22;

/// Largura ocupada pelo botão de enviar na linha do campo (ícone + padding do
/// [AppInteraction]) — usada para estimar a largura do texto (multiline).
const double _kSendButtonExtent = _kSendIconSize + AppSpacings.s4 * 2;

/// Como a faixa de anexos do [AppChatComposer] é disposta.
enum AppChatAttachmentLayout {
  /// Quebra em várias linhas (`Wrap`). Ideal para `AppChatAttachmentChip`.
  wrap,

  /// Linha única com rolagem horizontal. Ideal para `AppChatAttachmentCard`.
  row,
}

/// Campo de entrada **multimodal** de um chat — o composer.
///
/// A **superfície** do DS (eixos globais [style] filled/outlined/elevated e a
/// forma) embrulha **só o compose**: o campo de texto (um [AppInput] multiline
/// "nu") com o botão de enviar/parar à direita. O resto fica **FORA da
/// superfície** (como no Claude): a faixa de **anexos** (opcional) **acima** do
/// input e a **barra de ferramentas** **abaixo**. A toolbar só aparece com itens:
///
/// - **Esquerda**: botão de anexo ([onAttach]) e o modelo ([modelLabel]).
/// - **Direita**: ícone de info ([info], abre popover) e o progresso de
///   contexto ([contextProgress], abre popover).
///
/// Todos os itens da toolbar têm feedback de interação (hover/foco/clique) e
/// tooltip, e usam **shade neutro** (`onSurface`) — o **único elemento colorido
/// é o anel de contexto** (o progresso). Os **anexos seguem o estilo** do
/// composer. A superfície é **opaca** (`surfaceContainer`) em qualquer estilo —
/// no `elevated` a sombra não vaza por baixo. A forma segue o eixo global, com
/// uma exceção: `circular` (pílula) só cabe num compose de **uma linha** — **com
/// anexos** ou quando o texto vira **multiline**, cai para `redondo`.
///
/// Envio por **Enter** / quebra com **Shift+Enter**. O botão de enviar habilita
/// quando há texto ou anexos.
///
/// ```dart
/// AppChatComposer(
///   controller: _controller,
///   hintText: 'Pergunte o que quiser…',
///   onSend: _send,
///   onAttach: _pick,
///   modelLabel: 'Atlas', onModelTap: _swapModel,
///   info: const AppText('Dica: use Shift+Enter para quebrar linha.'),
///   contextProgress: 0.35, contextPopover: const AppText('35% do contexto usado.'),
/// )
/// ```
final class AppChatComposer extends StatefulWidget {
  /// Cria um [AppChatComposer].
  const AppChatComposer({
    required this.controller,
    this.focusNode,
    this.hintText,
    this.enabled = true,
    this.busy = false,
    this.onSend,
    this.onStop,
    this.onChanged,
    this.onAttach,
    this.attachEnabled = true,
    this.attachmentLimit = 2,
    this.attachLimitMessage,
    this.attachments = const <Widget>[],
    this.attachmentLayout = AppChatAttachmentLayout.wrap,
    this.preview,
    this.modelLabel,
    this.modelOptions = const <String>[],
    this.onModelSelected,
    this.onModelTap,
    this.info,
    this.contextProgress,
    this.contextPopover,
    this.leading = const <Widget>[],
    this.trailing,
    this.maxLines = 5,
    this.size = AppFieldSize.s,
    this.style,
    this.radiusMode,
    this.radius,
    this.sendIcon = AppIconToken.arrowUp,
    this.stopIcon = AppIconToken.stop,
    this.attachIcon = AppIconToken.attachment,
    super.key,
    this.shortcut,
  });

  /// Controlador do texto (o dono é o app).
  final TextEditingController controller;

  /// Nó de foco do campo (opcional).
  final FocusNode? focusNode;

  /// Placeholder do campo.
  final String? hintText;

  /// Se o composer aceita entrada. `false` esmaece e bloqueia tudo.
  final bool enabled;

  /// Se o assistente está respondendo — troca o botão de enviar por **parar**
  /// (quando [onStop] != null).
  final bool busy;

  /// Envia a mensagem (Enter ou toque no botão).
  final VoidCallback? onSend;

  /// Atalho que foca o composer. Exibido no lugar do botão de enviar enquanto
  /// não há texto para mandar.
  final AppShortcut? shortcut;

  /// Interrompe a resposta em andamento. Mostra o botão de parar quando [busy].
  final VoidCallback? onStop;

  /// Notifica mudanças de texto.
  final ValueChanged<String>? onChanged;

  /// Abre o seletor de anexos. `null` = sem botão de anexo.
  final VoidCallback? onAttach;

  /// Gate extra do botão de anexo (além do limite/busy). Default `true`.
  final bool attachEnabled;

  /// Máximo de anexos. Ao atingir, o botão de anexo desabilita e mostra um
  /// tooltip explicando. Default 2.
  final int attachmentLimit;

  /// Mensagem do tooltip quando o limite de anexos é atingido. `null` = padrão
  /// ("Limite de N anexos atingido").
  final String? attachLimitMessage;

  /// Faixa de anexos **acima do campo** (ex.: `AppChatAttachmentChip`/`Card`).
  final List<Widget> attachments;

  /// Como a faixa de anexos é disposta. Default [AppChatAttachmentLayout.wrap]
  /// (chips); use [AppChatAttachmentLayout.row] para os cards.
  final AppChatAttachmentLayout attachmentLayout;

  /// Prévia acima do campo — o banner de resposta ("respondendo a…"), a
  /// citação, o aviso de edição. `null` (default) = o composer de sempre.
  ///
  /// Fica IMEDIATAMENTE acima da superfície (abaixo da faixa de anexos): a
  /// prévia é a citação do que a mensagem responde e ancora no campo que
  /// responde a ela. O composer só POSICIONA o slot — a aparência é do
  /// chamador (um banner de reply é peça composta do app; não há tema escopado
  /// nem estilo imposto). A faixa recebe a largura do composer.
  final Widget? preview;

  /// Nome do modelo atual (ex.: "Atlas"). `null` = sem escolha de modelo.
  final String? modelLabel;

  /// Opções de modelo. Quando não-vazio (com [onModelSelected]), clicar no
  /// modelo abre um **menu** com as opções.
  final List<String> modelOptions;

  /// Seleciona um modelo do menu.
  final ValueChanged<String>? onModelSelected;

  /// Toque simples no modelo (fallback quando não há [modelOptions]).
  final VoidCallback? onModelTap;

  /// Conteúdo do popover de info (à direita). `null` = sem ícone de info.
  final Widget? info;

  /// Fração de contexto usado (0..1). `null` = sem indicador de contexto.
  final double? contextProgress;

  /// Conteúdo do popover do indicador de contexto (opcional).
  final Widget? contextPopover;

  /// Ações extras à esquerda, na linha do campo (ex.: microfone).
  final List<Widget> leading;

  /// Substitui o botão de enviar/parar por um widget próprio.
  final Widget? trailing;

  /// Máximo de linhas do texto (o [AppInput] limita a 5 com scroll).
  final int maxLines;

  /// Tamanho do campo (altura/ícones). Default [AppFieldSize.s].
  final AppFieldSize size;

  /// Estilo de container da barra. Default: global (`theme.styleTheme.style`).
  final AppStyle? style;

  /// Override local do modo de forma. Vence o global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (px). Vence [radiusMode] e o global.
  final double? radius;

  /// Ícone do botão de enviar. Default [AppIconToken.arrowUp].
  final String sendIcon;

  /// Ícone do botão de parar. Default [AppIconToken.stop].
  final String stopIcon;

  /// Ícone do botão de anexo. Default [AppIconToken.attachment].
  final String attachIcon;

  @override
  State<AppChatComposer> createState() => _AppChatComposerState();
}

class _AppChatComposerState extends State<AppChatComposer> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.trim().isNotEmpty;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant AppChatComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
      _hasText = widget.controller.text.trim().isNotEmpty;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final bool hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  bool get _canSend =>
      widget.enabled &&
      !widget.busy &&
      (_hasText || widget.attachments.isNotEmpty);

  bool get _atAttachLimit =>
      widget.attachments.length >= widget.attachmentLimit;

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!widget.enabled || widget.busy || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final bool isEnter =
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter;
    if (!isEnter || HardwareKeyboard.instance.isShiftPressed) {
      return KeyEventResult.ignored;
    }
    if (_canSend) widget.onSend?.call();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final bool hasAttachments = widget.attachments.isNotEmpty;
    final bool hasPreview = widget.preview != null;

    // Estilo de container: segue o eixo global (filled/outlined/elevated), com
    // override local. O fill é sempre OPACO (`surfaceContainer`) — assim no
    // `elevated` a sombra não vaza por baixo e o campo herda a superfície.
    final AppStyle style = widget.style ?? theme.styleTheme.style;

    final Widget field = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onKey,
      child: AppInput(
        controller: widget.controller,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        hintText: widget.hintText,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
        readOnly: widget.busy,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        style: AppStyle.filled,
        background: theme.colorTheme.transparent,
        size: widget.size,
        isDense: true,
      ),
    );

    final Widget inputRow = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        ...widget.leading,
        Expanded(child: field),
        const SizedBox(width: AppSpacings.s4),
        // Piso da altura de uma linha + centro: com o campo em uma linha o
        // botão fica no meio dela (alinhado ao texto, não ao rodapé da caixa);
        // quando o texto quebra, a caixa cresce, o piso não, e o `end` do Row
        // mantém o botão junto à última linha.
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: widget.size.height),
          // Os dois fatores são obrigatórios: sem eles o `Center` cresce até o
          // limite do pai e estica a barra inteira.
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: widget.trailing ?? _actionButton(theme),
          ),
        ),
      ],
    );

    final Widget? toolbar = _buildToolbar(theme);

    // A superfície do eixo AppStyle embrulha SÓ o compose (campo + botão de
    // enviar): filled = só o fundo; outlined = fundo + borda `outline`;
    // elevated = fundo + sombra simétrica (sem borda). Fundo opaco → a sombra
    // não vaza. Sem `ClipRRect` (recortar cortaria o conteúdo perto dos cantos).
    //
    // A forma (raio) reage ao conteúdo: `circular` (pílula) só cabe num compose
    // de **uma linha** — com anexos OU quando o texto vira multiline, cai para
    // `redondo`. Por isso o `LayoutBuilder` (mede a largura) dentro do
    // `ValueListenableBuilder` (recomputa quando o texto muda). O compose é o
    // `child` estável — não rebuilda a cada tecla.
    final Widget composeSurface = ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s12,
          vertical: AppSpacings.s8,
        ),
        child: inputRow,
      ),
      builder: (BuildContext context, TextEditingValue value, Widget? child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final BorderRadius radius = _resolveRadius(
              context,
              theme,
              constraints.maxWidth,
              value.text,
              hasBandAbove: hasAttachments || hasPreview,
            );
            return DecoratedBox(
              decoration: styleBoxDecoration(
                style: style,
                isDark: isDark,
                radius: radius,
                outline: colors.outline,
                surfaceContainer: colors.surfaceContainer,
                ownFill: colors.surfaceContainer,
              ),
              child: child,
            );
          },
        );
      },
    );

    // Sem nada em volta, o composer É a superfície.
    if (!hasAttachments && !hasPreview && toolbar == null) {
      return composeSurface;
    }

    // Anexos e prévia ficam ACIMA do input e a toolbar ABAIXO — todos FORA da
    // superfície (como no Claude): só o input + enviar ficam sobre a
    // superfície. Os anexos seguem o mesmo estilo do composer (ver
    // [_styledAttachments]); a prévia é slot cru do chamador.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (hasAttachments)
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacings.s8,
              left: AppSpacings.s4,
              right: AppSpacings.s4,
            ),
            child: _styledAttachments(theme, style),
          ),
        if (widget.preview case final Widget p)
          Padding(
            // O mesmo respiro da faixa de anexos: faixas irmãs, mesmo ritmo, e
            // o l/r s4 alinha a prévia com os itens da toolbar.
            padding: const EdgeInsets.only(
              bottom: AppSpacings.s8,
              left: AppSpacings.s4,
              right: AppSpacings.s4,
            ),
            child: p,
          ),
        composeSurface,
        ?toolbar,
      ],
    );
  }

  /// Raio da superfície do compose. Segue o eixo global, mas `circular`
  /// (pílula) só cabe num compose de **uma linha** que se lê como controle
  /// solitário: com qualquer faixa acima (anexos OU prévia), ou quando o texto
  /// vira multiline (mais de uma linha renderizada), cai para `redondo`. Um
  /// `radius` cru sempre vence.
  BorderRadius _resolveRadius(
    BuildContext context,
    AppThemeData theme,
    double maxWidth,
    String text, {
    required bool hasBandAbove,
  }) {
    if (widget.radius != null) return BorderRadius.circular(widget.radius!);
    final AppRadiusMode mode = widget.radiusMode ?? theme.radiusTheme.mode;
    if (mode == AppRadiusMode.circular &&
        (hasBandAbove || _isMultiline(context, theme, maxWidth, text))) {
      return theme.radiusTheme.resolve(override: AppRadiusMode.redondo);
    }
    return theme.radiusTheme.resolve(override: mode);
  }

  /// Se o [text] renderiza em mais de uma linha no campo, dada a [maxWidth] da
  /// superfície. Mede com o mesmo `bodyLarge` do [AppInput], descontando os
  /// paddings, o botão de enviar e o padding interno (denso) do campo. Vazio ou
  /// campo de uma linha (`maxLines == 1`) nunca é multiline.
  bool _isMultiline(
    BuildContext context,
    AppThemeData theme,
    double maxWidth,
    String text,
  ) {
    if (text.isEmpty || widget.maxLines <= 1) return false;
    if (text.contains('\n')) return true;
    if (!maxWidth.isFinite) return false;
    // Largura útil do texto = superfície − padding horizontal − enviar − gap −
    // padding interno (denso) do AppInput.
    final double textWidth =
        maxWidth -
        AppSpacings.s12 * 2 -
        _kSendButtonExtent -
        AppSpacings.s4 -
        AppSpacings.s4 * 2 -
        _leadingExtent;
    if (textWidth <= 0) return false;
    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: theme.textTheme.bodyLarge),
      textDirection: TextDirection.ltr,
      maxLines: widget.maxLines,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: textWidth);
    final bool multiline = painter.computeLineMetrics().length > 1;
    painter.dispose();
    return multiline;
  }

  /// Estimativa da largura dos widgets [AppChatComposer.leading] (raro; 0 no
  /// caso comum) para a medição de multiline.
  double get _leadingExtent =>
      widget.leading.isEmpty ? 0 : AppSpacings.s32 * widget.leading.length;

  /// Envolve a faixa de anexos num tema escopado cujo `styleTheme` = o estilo
  /// **efetivo** do composer, para os chips/cards seguirem o mesmo estilo
  /// (global ou override local). Um `style` explícito no chip ainda vence.
  Widget _styledAttachments(AppThemeData theme, AppStyle style) => AppTheme(
    data: theme.copyWith(styleTheme: theme.styleTheme.copyWith(style: style)),
    child: _buildAttachmentStrip(),
  );

  Widget _buildAttachmentStrip() {
    switch (widget.attachmentLayout) {
      case AppChatAttachmentLayout.wrap:
        return Wrap(
          spacing: AppSpacings.s8,
          runSpacing: AppSpacings.s8,
          children: widget.attachments,
        );
      case AppChatAttachmentLayout.row:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < widget.attachments.length; i++) ...<Widget>[
                if (i > 0) const SizedBox(width: AppSpacings.s8),
                widget.attachments[i],
              ],
            ],
          ),
        );
    }
  }

  // --- Toolbar (abaixo do campo) ------------------------------------------

  Widget? _buildToolbar(AppThemeData theme) {
    final List<Widget> left = <Widget>[
      if (widget.onAttach != null) _attachButton(theme),
      if (widget.modelLabel != null) _modelButton(theme),
    ];
    final List<Widget> right = <Widget>[
      if (widget.info != null) _infoButton(theme),
      if (widget.contextProgress != null) _contextButton(theme),
    ];
    if (left.isEmpty && right.isEmpty) return null;

    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacings.s8,
        left: AppSpacings.s4,
        right: AppSpacings.s4,
      ),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < left.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: AppSpacings.s8),
            left[i],
          ],
          const Spacer(),
          for (int i = 0; i < right.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: AppSpacings.s8),
            right[i],
          ],
        ],
      ),
    );
  }

  Widget _attachButton(AppThemeData theme) {
    final AppColorTheme colors = theme.colorTheme;
    final bool active =
        widget.enabled &&
        !widget.busy &&
        widget.attachEnabled &&
        !_atAttachLimit;
    final Widget button = AppInteraction(
      onTap: active ? widget.onAttach : null,
      enabled: active,
      semanticLabel: 'Anexar arquivo',
      tooltip: _atAttachLimit ? null : 'Anexar arquivo',
      padding: const EdgeInsets.all(AppSpacings.s4),
      child: AppIcon(
        widget.attachIcon,
        color: colors.onSurface.customOpacity(
          active ? _kIconActiveOpacity : _kIconDisabledOpacity,
        ),
        customSize: _kFooterItemSize,
      ),
    );
    if (_atAttachLimit) {
      return AppTooltip(
        message:
            widget.attachLimitMessage ??
            'Limite de ${widget.attachmentLimit} anexos atingido',
        child: button,
      );
    }
    return button;
  }

  Widget _modelButton(AppThemeData theme) {
    final AppColorTheme colors = theme.colorTheme;
    final bool active = widget.enabled && !widget.busy;
    // Texto maior (labelLarge) e sem chevron — casa com os ícones do footer.
    // SelectionContainer.disabled: senão a seleção de texto rouba o toque do
    // menu/interação (conteúdo passivo, como no AppBadge clicável).
    final Widget label = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s8,
        vertical: AppSpacings.s4,
      ),
      child: SelectionContainer.disabled(
        child: AppText(
          widget.modelLabel!,
          style: theme.textTheme.labelLarge.withColor(
            colors.onSurface.customOpacity(active ? 0.85 : 0.4),
          ),
        ),
      ),
    );

    // Com opções, clicar abre um menu (para cima); senão, toque simples. O menu
    // torna o trigger acionável mas não pinta hover — envolvemos num realce
    // decorativo + tooltip para o mesmo feedback dos demais itens da toolbar.
    if (active &&
        widget.modelOptions.isNotEmpty &&
        widget.onModelSelected != null) {
      return AppMenu(
        placement: AppOverlayPlacement.topStart,
        trigger: AppTooltip(
          message: 'Trocar modelo',
          child: AppHoverHighlight(child: label),
        ),
        entries: <AppMenuEntry>[
          for (final String m in widget.modelOptions)
            AppMenuItem(
              label: m,
              onPressed: () => widget.onModelSelected!(m),
              selected: m == widget.modelLabel,
            ),
        ],
      );
    }
    return AppInteraction(
      onTap: active ? widget.onModelTap : null,
      enabled: active,
      semanticLabel: 'Modelo: ${widget.modelLabel}',
      tooltip: active && widget.onModelTap != null ? 'Trocar modelo' : null,
      child: label,
    );
  }

  Widget _infoButton(AppThemeData theme) => AppPopover(
    placement: AppOverlayPlacement.topEnd,
    // O popover cuida do clique/foco; o realce decorativo dá o hover e o
    // tooltip o rótulo — mesmo feedback dos botões vizinhos.
    trigger: AppTooltip(
      message: 'Informações da conversa',
      child: AppHoverHighlight(
        padding: const EdgeInsets.all(AppSpacings.s4),
        child: AppIcon(
          AppIconToken.infoCircle,
          color: theme.colorTheme.onSurface.customOpacity(_kIconActiveOpacity),
          customSize: _kFooterItemSize,
        ),
      ),
    ),
    child: widget.info!,
  );

  Widget _contextButton(AppThemeData theme) {
    final AppColorTheme colors = theme.colorTheme;
    final double progress = widget.contextProgress!.clamp(0.0, 1.0);
    final Widget ring = AppBorderProgress(
      progress: progress,
      borderRadius: BorderRadius.circular(999),
      strokeWidth: 2.5,
      color: readableStopOn(colors.secondary, colors.surface),
      backgroundColor: colors.onSurface.customOpacity(0.15),
      child: const SizedBox(width: _kFooterItemSize, height: _kFooterItemSize),
    );
    final String message = '${(progress * 100).round()}% do contexto usado';
    // Sem popover, o anel é só informativo (não clicável): tooltip, sem realce
    // de hover que sugeriria clique.
    if (widget.contextPopover == null) {
      return AppTooltip(message: message, child: ring);
    }
    return AppPopover(
      placement: AppOverlayPlacement.topEnd,
      trigger: AppTooltip(
        message: message,
        child: AppHoverHighlight(
          padding: const EdgeInsets.all(AppSpacings.s4),
          child: ring,
        ),
      ),
      child: widget.contextPopover!,
    );
  }

  Widget _actionButton(AppThemeData theme) {
    final AppColorTheme colors = theme.colorTheme;
    final bool showStop = widget.busy && widget.onStop != null;
    final bool active = showStop || _canSend;
    final VoidCallback? onTap = showStop ? widget.onStop : widget.onSend;

    // Enquanto não há o que enviar, o lugar da seta apagada mostra o atalho
    // que traz o foco para cá. Uma seta desabilitada não informa nada; o selo
    // ensina a tecla exatamente onde o olho já está.
    if (!active && widget.shortcut != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacings.s2),
        child: AppShortcutHint(widget.shortcut!),
      );
    }
    // Enviar/parar também neutro (o único item colorido é o anel de contexto).
    final Color color = colors.onSurface.customOpacity(
      active ? _kSendActiveOpacity : _kIconDisabledOpacity,
    );

    return AppInteraction(
      onTap: active ? onTap : null,
      enabled: active,
      semanticLabel: showStop ? 'Parar resposta' : 'Enviar mensagem',
      tooltip: showStop ? 'Parar resposta' : 'Enviar mensagem',
      padding: const EdgeInsets.all(AppSpacings.s4),
      child: AppIcon(
        showStop ? widget.stopIcon : widget.sendIcon,
        color: color,
        customSize: _kSendIconSize,
      ),
    );
  }
}
