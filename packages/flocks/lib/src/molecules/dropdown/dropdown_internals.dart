import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_field_size.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/app_style.dart';
import '../../tokens/contrast.dart';
import '../../tokens/swatch_generator.dart';
import '../card/app_overlay_panel.dart';
import '../input/field_label.dart';

/// Cores resolvidas do trigger de um dropdown por estado.
typedef DropdownFieldColors = ({
  Color border,
  Color label,
  Color icon,
  Color hint,
});

/// Resolve as cores do trigger (borda/label/ícone/hint) por estado. Acentos
/// resolvem para um stop legível (RULES §5); desabilitado apaga por tom.
DropdownFieldColors dropdownFieldColors(
  AppColorTheme colors, {
  required bool open,
  required bool enabled,
  required bool error,
}) {
  final Color hint = colors.neutralPrimary.s600;
  if (!enabled) {
    final Color muted = mutedForDisabled(colors.onSurface, colors.surface);
    return (border: muted, label: muted, icon: muted, hint: muted);
  }
  if (error) {
    final Color danger = readableStopOn(
      colors.danger,
      colors.surface,
      minRatio: 4.5,
    );
    return (border: danger, label: danger, icon: danger, hint: hint);
  }
  if (open) {
    // Foco/aberto = `primary` (borda + label + ícone), como no AppInput.
    final Color accent = readableStopOn(colors.primary, colors.surface);
    return (border: accent, label: accent, icon: accent, hint: hint);
  }
  return (
    border: colors.outline,
    label: colors.onSurface,
    icon: colors.onSurface,
    hint: hint,
  );
}

/// Trigger compartilhado dos dropdowns: label + campo com borda (foco-Tab via
/// FlocksInteraction) + [display] + chevron animado + helper/erro. Não é público.
class DropdownField extends StatelessWidget {
  /// Cria um [DropdownField].
  const DropdownField({
    required this.display,
    required this.isOpen,
    required this.enabled,
    required this.onTap,
    required this.triggerKey,
    required this.layerLink,
    this.label,
    this.hasError = false,
    this.errorText,
    this.helperText,
    this.info,
    this.onClear,
    this.style,
    this.size = AppFieldSize.m,
    this.semanticValue,
    super.key,
  });

  /// Conteúdo do trigger (label selecionado, chips ou hint).
  final Widget display;

  /// A escolha corrente em TEXTO, para o leitor de tela.
  ///
  /// O [display] é visual (chips, ícones, texto truncado) e não serve de nome:
  /// sem isto o controle é anunciado sem dizer o que está valendo.
  final String? semanticValue;

  /// Se o overlay está aberto.
  final bool isOpen;

  /// Se está habilitado.
  final bool enabled;

  /// Ação de abrir/fechar.
  final VoidCallback onTap;

  /// Chave para medir a largura do trigger.
  final GlobalKey triggerKey;

  /// Link para ancorar o overlay.
  final LayerLink layerLink;

  /// Label acima do campo.
  final String? label;

  /// Se está em erro.
  final bool hasError;

  /// Texto de erro.
  final String? errorText;

  /// Texto auxiliar.
  final String? helperText;

  /// Conteúdo livre de um popover de informação ao lado do [label].
  final Widget? info;

  /// Ação ao limpar a seleção pelo ✕ do estado de erro. Quando não-nulo (o
  /// chamador só passa em erro + habilitado + com seleção), o chevron vira um
  /// ✕ que dispara isto (tipicamente: limpar a seleção e reabrir o overlay).
  final VoidCallback? onClear;

  /// Eixo global [AppStyle] do trigger. `null` segue o global do tema.
  final AppStyle? style;

  /// Tamanho do trigger (altura fixa + métricas). Default [AppFieldSize.m].
  final AppFieldSize size;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool error = hasError || errorText != null;
    final DropdownFieldColors labelColors = dropdownFieldColors(
      colors,
      open: isOpen,
      enabled: enabled,
      error: error,
    );

    final Widget trigger = CompositedTransformTarget(
      link: layerLink,
      // Regra 8: o gatilho é um controle EXPANSÍVEL, não um botão qualquer.
      // Sem `expanded` o leitor anuncia "botão" e some a pista de que há um
      // painel do outro lado — e de que ele está aberto agora.
      child: AppSemantics.expandable(
        expanded: isOpen,
        label: label,
        value: semanticValue,
        enabled: enabled,
        onTap: onTap,
        child: SelectionContainer.disabled(
          child: FlocksInteraction(
            onPressed: enabled ? onTap : null,
            enabled: enabled,
            builder: (BuildContext context, Set<WidgetState> states) {
              final bool focused = states.contains(WidgetState.focused);
              final DropdownFieldColors c = dropdownFieldColors(
                colors,
                open: isOpen || focused,
                enabled: enabled,
                error: error,
              );
              // Eixo global de style: override do campo > global do tema. A
              // cor de borda por estado (`c.border`) entra como `outline`.
              final AppStyle s = style ?? theme.styleTheme.style;
              final bool fillStyle =
                  s == AppStyle.filled || s == AppStyle.elevated;
              // Fill por estado (igual ao AppInput): desabilitado sutil, erro
              // em fundo danger nos estilos preenchidos, senão a surface
              // `neutralPrimary.s200`.
              final Color? ownFill = !enabled
                  ? colors.neutralPrimary.s50
                  : (error && fillStyle)
                  ? colors.danger.s100
                  : null;
              final StyleDecoration deco = resolveStyleDecoration(
                style: s,
                isDark: theme.brightness == AppBrightness.dark,
                outline: c.border,
                // Derivado, não fixo: hoje resolve para `s200` nas duas marcas e nos
                // dois temas, mas se a rampa de uma marca mudar o campo acompanha em
                // vez de colidir em silêncio com a superfície.
                surfaceContainer: mostSeparatedStop(
                  colors.neutralPrimary,
                  surfaces: <Color>[colors.surface, colors.surfaceContainer],
                  content: colors.onSurface,
                ),
                ownFill: ownFill,
                borderWidth: AppStrokes.m,
              );
              // O trigger é um campo como qualquer outro: segue o radius
              // global normalmente (inclusive circular → pílula). Só o
              // painel/opções do overlay usam containedMode.
              final BorderRadius radius = theme.radiusTheme.resolve();
              // Borda em PRIMEIRO PLANO + altura fixa por `size`: alternar de
              // estilo não muda o tamanho do trigger nem o espaçamento.
              return Container(
                key: triggerKey,
                constraints: BoxConstraints(minHeight: size.height),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: deco.color,
                  boxShadow: deco.boxShadow,
                  borderRadius: radius,
                ),
                foregroundDecoration: deco.border == null
                    ? null
                    : BoxDecoration(border: deco.border, borderRadius: radius),
                padding: EdgeInsets.symmetric(
                  horizontal: size.horizontalPadding,
                ),
                child: Row(
                  children: <Widget>[
                    // O texto/chips do display NÃO entram na mesclagem: o
                    // conteúdo já viaja em `semanticValue`, e deixá-lo
                    // mesclar fazia o nó nascer "Fruta\nBanana" — o leitor
                    // anunciava o rótulo e o valor grudados, duas vezes.
                    Expanded(child: ExcludeSemantics(child: display)),
                    const SizedBox(width: AppSpacings.s8),
                    // Erro + habilitado + com seleção: chevron vira ✕ que
                    // limpa e reabre o overlay. O GestureDetector aninhado
                    // vence o tap do FlocksInteraction (como o ✕ dos chips).
                    if (error && enabled && onClear != null)
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onClear,
                          child: AppIcon(
                            AppIconToken.close,
                            customSize: size.iconSize,
                            color: c.icon,
                          ),
                        ),
                      )
                    else
                      AppAnimatedRotation(
                        turns: isOpen ? 0.5 : 0.0,
                        child: AppIcon(
                          AppIconToken.chevronDown,
                          customSize: size.iconSize,
                          color: c.icon,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    // O trigger sempre tem sufixo (chevron/✕). Com label, o info vai na row do
    // label; sem label, fica ao lado do trigger (encolhendo-o). O `triggerKey`/
    // `layerLink` seguem no Container interno, então a largura do overlay
    // acompanha o trigger encolhido.
    final Widget triggerRow = (label == null && info != null)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: trigger),
              const SizedBox(width: AppSpacings.s8),
              appFieldInfo(
                info: info!,
                color: labelColors.icon,
                iconSize: size.iconSize,
              ),
            ],
          )
        : trigger;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacings.s4),
            child: appFieldLabel(
              label: label!,
              style: theme.textTheme.labelLarge.copyWith(
                color: labelColors.label,
              ),
              infoIconSize: size.iconSize,
              info: info,
            ),
          ),
        triggerRow,
        // Guarda o `!`: em erro sem `errorText`/`helperText` não há texto a
        // exibir (o sinal de erro fica na borda/label/✕), sem estourar.
        if (errorText != null || helperText != null) ...<Widget>[
          const SizedBox(height: AppSpacings.s4),
          AppText(
            errorText ?? helperText!,
            style: error
                ? theme.textTheme.labelMedium.copyWith(
                    color: readableStopOn(
                      colors.danger,
                      colors.surface,
                      minRatio: 4.5,
                    ),
                  )
                : theme.textTheme.bodySmall.copyWith(
                    color: colors.neutralPrimary.s700,
                  ),
          ),
        ],
      ],
    );
  }
}

/// Uma linha de opção do overlay (hover neutro, ✓ no selecionado). Não é público.
Widget dropdownOptionRow(
  BuildContext context, {
  required String label,
  required bool selected,
  required bool hovered,
  required VoidCallback onTap,
  required ValueChanged<bool> onHover,
}) {
  final AppThemeData theme = AppTheme.of(context);
  final AppColorTheme colors = theme.colorTheme;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s4),
    child: SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedContainer(
            duration: AppMotion.resolve(context, AppDurations.fast),
            curve: AppCurves.standard,
            decoration: BoxDecoration(
              borderRadius: theme.radiusTheme.resolve(
                override: theme.radiusTheme.containedMode(),
              ),
              color: hovered
                  ? colors.onSurface.withValues(alpha: 0.08)
                  : colors.transparent,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.s8,
              vertical: AppSpacings.s8,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: AppText(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // Selecionado = rótulo em negrito (sem ícone de check).
                    style: theme.textTheme.bodyMedium.copyWith(
                      color: colors.onSurface,
                      fontWeight: selected ? FontWeight.w700 : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// Cabeçalho de seção não-selecionável do overlay (ex.: "Recomendados"). Um
/// rótulo discreto em caixa alta que separa grupos de opções. Não é público.
Widget dropdownSectionHeader(BuildContext context, String label) {
  final AppThemeData theme = AppTheme.of(context);
  final AppColorTheme colors = theme.colorTheme;
  return Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacings.s12,
      AppSpacings.s8,
      AppSpacings.s12,
      AppSpacings.s4,
    ),
    child: SelectionContainer.disabled(
      child: AppText(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelMedium.copyWith(
          color: colors.neutralPrimary.s600,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

/// Painel de overlay compartilhado: [AppOverlayPanel] ancorado ao trigger, com
/// um [search] opcional no topo e a lista de [options]. Não é público.
///
/// Segue o **eixo glass global** (`theme.glassTheme.enabled`) via o
/// [AppOverlayPanel] — não expõe override por instância, porque os quatro
/// componentes que o montam (`AppDropdown`, `AppMultiSelect`,
/// `AppSearchableDropdown`, `AppSearchableMultiSelect`) não têm caso de uso para
/// um dropdown vidro e outro opaco na mesma tela.
class DropdownPanel extends StatelessWidget {
  /// Cria um [DropdownPanel].
  const DropdownPanel({
    required this.layerLink,
    required this.triggerWidth,
    required this.options,
    required this.onDismiss,
    this.search,
    this.emptyLabel,
    super.key,
  });

  /// Link para ancorar ao trigger.
  final LayerLink layerLink;

  /// Largura do trigger (o painel acompanha).
  final double triggerWidth;

  /// Linhas de opção já construídas.
  final List<Widget> options;

  /// Fecha o overlay (clique fora).
  final VoidCallback onDismiss;

  /// Campo de busca opcional (topo do painel).
  final Widget? search;

  /// Texto de "nenhum resultado" (quando [options] vazio e há busca).
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    // O painel vive num Overlay acima do DefaultTextStyle do app → sem isto o
    // texto cai no fallback do Flutter (sublinhado amarelo "faltou Material").
    // Reprovê um estilo-base concreto (o AppText resolve o default no build).
    return DefaultTextStyle(
      style: theme.textTheme.bodyMedium.copyWith(
        color: theme.colorTheme.onSurface,
        decoration: TextDecoration.none,
      ),
      child: TapRegion(
        onTapOutside: (_) => onDismiss(),
        child: DropdownPanelPlacement(
          layerLink: layerLink,
          gap: AppSpacings.s4,
          builder: (BuildContext context, double maxHeight) => SizedBox(
            width: triggerWidth,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: FocusScope(
                child: AppOverlayPanel(
                  // Painel flutuante: mantém profundidade sob qualquer global.
                  style: AppStyle.elevated,
                  accentColor: readableStopOn(
                    theme.colorTheme.secondary,
                    theme.colorTheme.surface,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacings.s4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ?search,
                      // `Flexible`: com pouco espaço na tela, é a LISTA que
                      // encolhe — a busca continua inteira, senão o usuário
                      // perde justamente a saída para achar a opção.
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: kDropdownListMaxHeight,
                          ),
                          child: options.isEmpty && emptyLabel != null
                              ? Padding(
                                  padding: const EdgeInsets.all(
                                    AppSpacings.s16,
                                  ),
                                  child: AppText(
                                    emptyLabel!,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium.copyWith(
                                      color:
                                          theme.colorTheme.neutralPrimary.s700,
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: options,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Altura máxima da LISTA de opções dentro do painel.
const double kDropdownListMaxHeight = 240;

/// Altura máxima do painel inteiro (busca + lista + respiros) quando há espaço
/// de sobra na tela.
const double kDropdownPanelMaxHeight = 320;

/// Coloca o painel do dropdown ancorado ao trigger — **abrindo para cima quando
/// não cabe para baixo**, e limitando a altura ao espaço que existe.
///
/// O painel era ancorado sempre em `bottomLeft → topLeft`, com altura fixa: num
/// campo perto do rodapé (o "Fuso horário" no fim do formulário) a lista nascia
/// fora da tela e não havia como escolher opção nenhuma (revisão P1r9).
///
/// Como funciona: o painel é montado na posição natural (abaixo), medido no
/// pós-frame e, se não couber, deslocado para cima do trigger por
/// `altura + altura-do-trigger + 2×gap`. A decisão é reavaliada a cada mudança
/// de tamanho (a lista encolhe conforme a busca filtra), e a altura máxima é o
/// espaço real do lado escolhido.
class DropdownPanelPlacement extends StatefulWidget {
  /// Cria o posicionador do painel.
  const DropdownPanelPlacement({
    required this.layerLink,
    required this.builder,
    this.gap = AppSpacings.s4,
    super.key,
  });

  /// Link do trigger (fornece também a ALTURA dele, necessária para o flip).
  final LayerLink layerLink;

  /// Respiro entre o trigger e o painel.
  final double gap;

  /// Constrói o painel com a altura máxima disponível já resolvida.
  final Widget Function(BuildContext context, double maxHeight) builder;

  @override
  State<DropdownPanelPlacement> createState() => _DropdownPanelPlacementState();
}

class _DropdownPanelPlacementState extends State<DropdownPanelPlacement> {
  final GlobalKey _panelKey = GlobalKey();
  bool _measureScheduled = false;
  bool _flipped = false;
  double _maxHeight = kDropdownPanelMaxHeight;

  @override
  Widget build(BuildContext context) {
    _scheduleMeasure();

    // A inversão é feita pelas ÂNCORAS do follower, não por um `Transform`:
    // ancorar o rodapé do painel no topo do trigger dispensa saber a altura e
    // — o que importa — preserva o hit-test. Com `Transform.translate` o painel
    // aparecia no lugar certo mas não recebia o toque.
    return CompositedTransformFollower(
      link: widget.layerLink,
      targetAnchor: _flipped ? Alignment.topLeft : Alignment.bottomLeft,
      followerAnchor: _flipped ? Alignment.bottomLeft : Alignment.topLeft,
      offset: Offset(0, _flipped ? -widget.gap : widget.gap),
      child: Align(
        alignment: _flipped ? Alignment.bottomLeft : Alignment.topLeft,
        child: KeyedSubtree(
          key: _panelKey,
          child: widget.builder(context, _maxHeight),
        ),
      ),
    );
  }

  void _scheduleMeasure() {
    if (_measureScheduled) return;
    _measureScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureScheduled = false;
      if (!mounted) return;

      final RenderObject? object = _panelKey.currentContext?.findRenderObject();
      if (object is! RenderBox || !object.hasSize) return;

      final MediaQueryData media = MediaQuery.of(context);
      final view = View.of(context);
      // Em teste o MediaQuery pode vir sem dimensões.
      final Size viewport = media.size.isEmpty
          ? view.physicalSize / view.devicePixelRatio
          : media.size;

      final double height = object.size.height;
      final double leaderHeight = widget.layerLink.leaderSize?.height ?? 0;
      final double panelTop = object.localToGlobal(Offset.zero).dy;
      // Reconstrói o trigger a partir do painel — os dois lados da inversão são
      // simétricos, então não é preciso guardar deslocamento nenhum.
      final double triggerTop = _flipped
          ? panelTop + height + widget.gap
          : panelTop - widget.gap - leaderHeight;
      final double triggerBottom = triggerTop + leaderHeight;

      final double below =
          viewport.height -
          media.viewPadding.bottom -
          triggerBottom -
          widget.gap;
      final double above = triggerTop - media.viewPadding.top - widget.gap;

      // Só inverte quando não cabe embaixo E cabe melhor em cima: virar por
      // virar tiraria o painel do lugar que o usuário já espera.
      final bool flip = height > below && above > below;
      final double space = flip ? above : below;
      final double nextMaxHeight = space <= 0
          ? kDropdownPanelMaxHeight
          : math.min(space, kDropdownPanelMaxHeight);

      if (flip == _flipped && (nextMaxHeight - _maxHeight).abs() < 0.5) return;
      setState(() {
        _flipped = flip;
        _maxHeight = nextMaxHeight;
      });
    });
  }
}

/// Campo de busca do overlay (searchable): ícone + [EditableText]. Não é público.
///
/// Filtro simples — foco automático ao abrir. Não é um campo de formulário
/// completo (a receita de seleção da Regra 7 fica no futuro `AppInput`).
class DropdownSearchField extends StatelessWidget {
  /// Cria um [DropdownSearchField].
  const DropdownSearchField({
    required this.controller,
    required this.focusNode,
    this.hint,
    super.key,
  });

  /// Controlador do texto de busca.
  final TextEditingController controller;

  /// Nó de foco (autofocus ao abrir).
  final FocusNode focusNode;

  /// Placeholder.
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final TextStyle style = theme.textTheme.bodyMedium.copyWith(
      color: colors.onSurface,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.s8,
        AppSpacings.s4,
        AppSpacings.s8,
        AppSpacings.s8,
      ),
      child: Row(
        children: <Widget>[
          AppIcon(
            AppIconToken.search,
            size: AppIconSize.s,
            color: colors.neutralPrimary.s700,
          ),
          const SizedBox(width: AppSpacings.s8),
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (BuildContext context, TextEditingValue value, _) =>
                      value.text.isEmpty && hint != null
                      ? AppText(
                          hint!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: style.copyWith(
                            color: colors.neutralPrimary.s600,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                EditableText(
                  controller: controller,
                  focusNode: focusNode,
                  style: style,
                  cursorColor: readableStopOn(colors.primary, colors.surface),
                  backgroundCursorColor: colors.transparent,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
