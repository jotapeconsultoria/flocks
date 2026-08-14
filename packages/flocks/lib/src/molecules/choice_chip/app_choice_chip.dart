import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../foundation/flocks_states_controller.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/app_style.dart';
import '../../tokens/contrast.dart';
import '../buttons/app_button_color.dart';
import '../buttons/button_state_colors.dart';
import '../tooltip/tooltip.dart';

/// Altura MÍNIMA do chip (px).
///
/// Igual a `AppButtonSize.s.height` de propósito: numa barra de filtros o chip
/// convive com botões `s`, e dois alvos de alturas diferentes lado a lado leem
/// como dois componentes distintos. É MÍNIMA, e não fixa: com text-scale alto o
/// chip cresce em vez de cortar o rótulo (mesma escolha do `AppBadge`).
const double kAppChoiceChipMinHeight = 40.0;

/// Chip **selecionável** — uma opção de um conjunto, com contador opcional.
///
/// É o terceiro chip do pacote, e o único com ESTADO DE ESCOLHA. O
/// [AppFilterChip] mostra um filtro já aplicado e oferece tirá-lo; o
/// [AppSuggestionChip] convida a uma ação; este responde "qual destes está
/// valendo agora" — e é ele que vai numa barra de 6 status, num seletor de
/// período ou numa lista de grupos.
///
/// O [count] existe porque, nessas barras, o número faz parte da decisão: "8
/// na fila" é o que manda o atendente tocar no chip. Colá-lo no rótulo
/// (`'Novos (8)'`) faria o número herdar o peso do rótulo e o alinhamento
/// morrer quando um chip tem contador e o vizinho não.
///
/// Selecionado pinta o **acento preenchido** — a MESMA cor do
/// [AppSegmentedButton] (`appFilledButtonColors` do papel `primary`), porque
/// os dois respondem à mesma pergunta e não podem parecer conceitos
/// diferentes. Não-selecionado é o container do eixo [AppStyle]; no
/// `outlined`, a borda do selecionado vira a própria cor do fill — uma borda
/// cinza sobre o acento sujaria a pílula.
///
/// A troca de estado muda peso do rótulo (w500 → w700) **e** preenchimento —
/// nenhum dos dois sozinho: só peso some no escuro, só preenchimento perde no
/// text-scale alto.
///
/// ```dart
/// AppChoiceChip(
///   label: 'Novos',
///   count: 8,
///   selected: filtro == 'queue',
///   onChanged: (_) => setFiltro('queue'),
/// )
/// ```
final class AppChoiceChip extends StatelessWidget {
  /// Cria um [AppChoiceChip].
  const AppChoiceChip({
    required this.label,
    required this.selected,
    this.onChanged,
    this.count,
    this.icon,
    this.enabled = true,
    this.mutuallyExclusive = true,
    this.semanticLabel,
    this.tooltip,
    this.style,
    this.radiusMode,
    this.radius,
    this.statesController,
    super.key,
  });

  /// Texto da opção. Uma linha, com elipse — chip não quebra linha.
  final String label;

  /// Se esta opção está escolhida agora.
  final bool selected;

  /// Notifica a escolha, com o valor NOVO de [selected].
  ///
  /// Em seleção única o chamador ignora o `bool` (`onChanged: (_) =>
  /// pick(v)`); em multi-seleção ele diz se entrou ou saiu do conjunto.
  /// `null` deixa o chip somente-leitura.
  final ValueChanged<bool>? onChanged;

  /// Número associado à opção (itens na fila, membros do grupo). `null`
  /// esconde a pílula — não renderiza um "0" fantasma; `0` renderiza "0"
  /// (quem decide esconder o zero é o chamador).
  final int? count;

  /// Ícone opcional à esquerda (`AppIconToken.*`).
  final String? icon;

  /// Se o chip aceita toque.
  final bool enabled;

  /// `true` (default): o chip é um de um grupo EXCLUSIVO (radio-like) e o
  /// leitor de tela anuncia isso via `inMutuallyExclusiveGroup`. `false` para
  /// multi-seleção (seletor de audiência, p.ex.).
  final bool mutuallyExclusive;

  /// Substitui o rótulo anunciado. Sem ele o padrão é `label` ou
  /// `'<label> (<count>)'` — que não diz a UNIDADE. Passe a frase inteira
  /// quando o número precisar de nome: `'Novos, 8 conversas na fila'`.
  final String? semanticLabel;

  /// Dica no hover/foco (via [AppTooltip]), publicada também em
  /// `Semantics.tooltip` — a dica não fica só no pixel.
  final String? tooltip;

  /// Tratamento de container do NÃO-selecionado (eixo [AppStyle]). `null`
  /// segue `theme.styleTheme.style`. O selecionado ignora o fill do eixo (o
  /// acento é o que comunica a escolha) mas mantém borda e sombra do estilo.
  final AppStyle? style;

  /// Override local do modo de forma. Vence o global. Default do componente:
  /// [AppRadiusMode.circular] — chip é pílula.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (px). Vence [radiusMode] e o global.
  final double? radius;

  /// Controlador de estados externo (o dono cuida do ciclo de vida).
  final FlocksStatesController? statesController;

  bool get _interactive => enabled && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final AppStyle s = style ?? theme.styleTheme.style;
    final AppRadiusMode mode = radiusMode ?? theme.radiusTheme.mode;
    final BorderRadius br = radius != null
        ? BorderRadius.circular(radius!)
        : appResolveRadius(
            mode: mode,
            componentDefault: AppRadiusMode.circular,
            size: const Size.square(kAppChoiceChipMinHeight),
          );

    final Widget chip = FlocksInteraction(
      onPressed: _interactive ? () => onChanged!(!selected) : null,
      enabled: _interactive,
      selected: selected,
      statesController: statesController,
      builder: (BuildContext context, Set<WidgetState> states) {
        final bool hovered = states.contains(WidgetState.hovered);
        final bool pressed = states.contains(WidgetState.pressed);
        final bool focused = states.contains(WidgetState.focused);

        // O MESMO resolvedor do AppSegmentedButton (papel primary) — os dois
        // respondem "um de N" e não podem divergir de cor. Hover/press
        // aprofundam o fundo e o contraste do texto só sobe.
        final ButtonColors sel = appFilledButtonColors(
          colors,
          AppButtonColor.primary.role(colors),
          AppButtonColor.primary.onRole(colors),
          hovered: hovered,
          pressed: pressed,
          disabled: !_interactive,
        );

        // Não-selecionado: realce NEUTRO (onSurface 8%/12%, as opacidades do
        // ghost) blendado sobre a base do estilo.
        Color? bgOverride;
        if (!selected && _interactive && (hovered || pressed)) {
          final Color base = s == AppStyle.outlined
              ? colors.surface
              : colors.surfaceContainer;
          bgOverride = Color.alphaBlend(
            colors.onSurface.customOpacity(pressed ? 0.12 : 0.08),
            base,
          );
        }

        final StyleDecoration deco = resolveStyleDecoration(
          style: s,
          isDark: isDark,
          // A borda do selecionado é a própria cor do fill: some, em vez de
          // sujar a pílula com um contorno cinza (modo outlined).
          outline: selected ? sel.background : colors.outline,
          surfaceContainer: colors.surfaceContainer,
          ownFill: selected ? sel.background : null,
          background: bgOverride,
        );

        final Color fg = selected
            ? sel.foreground
            : _interactive
            ? colors.onSurface
            : mutedForDisabled(colors.onSurface, colors.surfaceContainer);

        final Widget content = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon case final String i) ...<Widget>[
              AppIcon(i, size: AppIconSize.s, color: fg),
              const SizedBox(width: AppSpacings.s8),
            ],
            Flexible(
              child: AppText(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge.copyWith(
                  color: fg,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (count case final int c) ...<Widget>[
              const SizedBox(width: AppSpacings.s8),
              _countPill(theme, mode, fg, c),
            ],
          ],
        );

        final Widget box = ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kAppChoiceChipMinHeight),
          child: AnimatedContainer(
            duration: AppMotion.resolve(context, AppDurations.fast),
            curve: AppCurves.standard,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.s12,
              vertical: AppSpacings.s8,
            ),
            decoration: BoxDecoration(
              color: deco.color,
              border: deco.border,
              boxShadow: deco.boxShadow,
              borderRadius: br,
            ),
            // A seleção de texto venceria o tap na arena (idioma button_core);
            // ExcludeSemantics porque o nó do toggle JÁ carrega o rótulo — sem
            // ele o MergeSemantics concatenaria "Novos (8) Novos 8". O Row
            // (crossAxisAlignment center, default) centraliza o conteúdo
            // quando o minHeight força o chip mais alto que o texto.
            child: ExcludeSemantics(
              child: SelectionContainer.disabled(child: content),
            ),
          ),
        );

        final Widget scaled = AnimatedScale(
          scale: pressed && AppMotion.enabled(context) ? 0.97 : 1.0,
          duration: AppMotion.resolve(context, AppDurations.fast),
          curve: AppCurves.standard,
          child: box,
        );

        // Anel de foco por fora, SEM duração — sobrevive a reduce-motion
        // (idioma do AppBadge: transição encurta, estado nunca some).
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: br,
            border: Border.all(
              color: focused ? colors.focusRing : colors.transparent,
              width: AppStrokes.m,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: scaled,
        );
      },
    );

    final Widget toggled = AppSemantics.toggle(
      value: selected,
      enabled: _interactive,
      mutuallyExclusive: mutuallyExclusive,
      label: semanticLabel ?? (count == null ? label : '$label ($count)'),
      onTap: _interactive ? () => onChanged!(!selected) : null,
      child: chip,
    );
    // O AppTooltip fica por FORA do toggle: o MergeSemantics do toggle não
    // absorve `tooltip` de descendentes, e a dica sumiria da árvore.
    return tooltip == null
        ? toggled
        : AppTooltip(message: tooltip!, child: toggled);
  }

  /// A pílula do contador: fundo `fg@0.18` — UMA fórmula para os dois estados
  /// (sobre o acento clareia/escurece; sobre a superfície é o degrau do
  /// divider). O raio segue o mesmo eixo do chip.
  Widget _countPill(AppThemeData theme, AppRadiusMode mode, Color fg, int c) =>
      DecoratedBox(
        decoration: BoxDecoration(
          color: fg.customOpacity(0.18),
          borderRadius: appResolveRadius(
            mode: mode,
            componentDefault: AppRadiusMode.circular,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s8,
            vertical: AppSpacings.s2,
          ),
          child: AppText(
            '$c',
            style: theme.textTheme.labelSmall.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
}
