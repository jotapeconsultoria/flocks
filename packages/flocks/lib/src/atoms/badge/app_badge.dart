import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../icons/icons.dart';
import '../texts/texts.dart';
import 'badge_interaction.dart';

/// Semantic color role of an [AppBadge].
enum AppBadgeColor {
  /// Neutral / default (grey).
  neutral,

  /// Primary (brand).
  primary,

  /// Informational (blue).
  info,

  /// Success (green).
  success,

  /// Warning (amber).
  warning,

  /// Danger / error (red).
  danger;

  /// Resolves the role to its base color in [t].
  ///
  /// `neutral` uses the theme's `onSurface` (the readable content color) so the
  /// pill keeps contrast in both light and dark — the `neutralPrimary` swatch
  /// base is a light stop and would wash out on a light surface.
  ///
  /// `primary` here returns the raw base; the badge itself paints the role with
  /// the **brightness-resolved** accent ([AppColorTheme.primaryAccent]) instead,
  /// since the raw `primary` base is too dark to read on a dark surface.
  Color resolve(AppColorTheme t) => switch (this) {
    AppBadgeColor.neutral => t.onSurface,
    AppBadgeColor.primary => t.primary,
    AppBadgeColor.info => t.info,
    AppBadgeColor.success => t.success,
    AppBadgeColor.warning => t.warning,
    AppBadgeColor.danger => t.danger,
  };
}

/// Tamanho nomeado do [AppBadge] — dirige o padding interno e o papel de texto.
///
/// Diferente do [AppAvatar], o badge é **auto-dimensionado**: o text-scale já é
/// tratado pelo layout do [AppText]/`Wrap`, então o tamanho não deriva um
/// diâmetro — apenas escolhe o padding e o papel tipográfico (e o raio default).
/// O passo [m] (default) reproduz o visual histórico da pílula.
enum AppBadgeSize {
  /// Compacto — `labelSmall`, padding h8/v2.
  s,

  /// Médio (default) — `labelSmall`, padding h8/v4. Reproduz o visual histórico.
  m,

  /// Grande — `labelMedium`, padding h12/v8.
  l,

  /// Extra-grande — `labelLarge`, padding h16/v12.
  xl;

  /// Padding interno **fixo** da pílula neste passo.
  EdgeInsets get padding => switch (this) {
    AppBadgeSize.s => const EdgeInsets.symmetric(
      horizontal: AppSpacings.s8,
      vertical: AppSpacings.s2,
    ),
    AppBadgeSize.m => const EdgeInsets.symmetric(
      horizontal: AppSpacings.s8,
      vertical: AppSpacings.s4,
    ),
    AppBadgeSize.l => const EdgeInsets.symmetric(
      horizontal: AppSpacings.s12,
      vertical: AppSpacings.s8,
    ),
    AppBadgeSize.xl => const EdgeInsets.symmetric(
      horizontal: AppSpacings.s16,
      vertical: AppSpacings.s12,
    ),
  };

  /// Papel de texto (do tema) usado pelo label neste passo.
  TextStyle labelStyle(AppTextTheme t) => switch (this) {
    AppBadgeSize.s => t.labelSmall,
    AppBadgeSize.m => t.labelSmall,
    AppBadgeSize.l => t.labelMedium,
    AppBadgeSize.xl => t.labelLarge,
  };
}

/// A compact status pill — the Flocks badge.
///
/// Shows a short [label] tinted by a semantic [color] role: the text uses the
/// role's full color over a 10%-tinted background of the same color, so it
/// adapts to light/dark and brand. Sized by a named [size] step.
///
/// Read-only by default — exposed as a single labeled node to screen readers
/// (Regra 8). Pass [onTap] to make it an **interactive** pill (hover/press/focus
/// with a focus ring and button semantics), mirroring [AppAvatar]. Use the
/// interactive form only when the pill represents an action or a toggleable
/// filter, not for plain status display.
///
/// ```dart
/// AppBadge('Pending', color: AppBadgeColor.warning)
/// AppBadge('Resolved') // neutral by default
/// AppBadge('Filter', onTap: () {}) // interactive
/// ```
final class AppBadge extends StatelessWidget {
  /// Creates a badge showing [label] with the given semantic [color].
  const AppBadge(
    this.label, {
    this.color = AppBadgeColor.neutral,
    this.icon,
    this.size = AppBadgeSize.m,
    this.style,
    this.background,
    this.radius,
    this.onTap,
    this.effect = AppBadgeEffect.scale,
    this.statesController,
    this.preserveCase = false,
    super.key,
  });

  /// The short text shown inside the pill.
  ///
  /// Rendered in UPPERCASE: a badge is a label of state/category, and casing is
  /// what separates it from ordinary prose next to it. Keeping the decision here
  /// (rather than at every call site) is what makes every badge in the product
  /// look like the same thing. Pass [preserveCase] for the rare content whose
  /// casing carries meaning (an id, a token, a country code).
  final String label;

  /// The semantic color role. Defaults to [AppBadgeColor.neutral].
  final AppBadgeColor color;

  /// Optional [AppIconToken] slug painted LEFT of the label, in the same
  /// role color as the text and sized to the label's line box (it scales with
  /// text scale and never changes the pill's height — so the proportional
  /// radius stays put). `null` = the text-only pill of always.
  final String? icon;

  /// Named size — drives the inner padding and the label text role. Defaults to
  /// [AppBadgeSize.m] (the historical look).
  final AppBadgeSize size;

  /// Container style (border/fill/shadow). Defaults to the global
  /// `theme.styleTheme.style`. Additive over the tinted fill.
  final AppStyle? style;

  /// Overrides the tinted background fill. Defaults to the role color at 10%.
  final Color? background;

  /// Corner radius override (cru). When `null`, follows the global shape mode
  /// (`theme.radiusTheme`, default Redondo), resolved from the pill's real
  /// height so it stays proportional across the sizes.
  final BorderRadius? radius;

  /// Makes the pill interactive (click cursor, hover/press/focus highlight,
  /// focus ring and button semantics). When `null` (default) the badge is a
  /// read-only label.
  final VoidCallback? onTap;

  /// Hover/press micro-animation when [onTap] is set. Defaults to
  /// [AppBadgeEffect.scale]. Ignored while the badge is read-only.
  final AppBadgeEffect effect;

  /// External state driver — only effective when [onTap] is set. The caller
  /// owns its lifecycle ([FlocksInteraction] never disposes an external one).
  final FlocksStatesController? statesController;

  /// Keeps [label] exactly as given, instead of uppercasing it. For content
  /// whose casing is information (`IMEI`, `pt-BR`, a serial).
  final bool preserveCase;

  /// The text actually painted. Uppercasing here — and not in the caller —
  /// keeps the measured pill and the rendered pill in sync.
  String get _text => preserveCase ? label : label.toUpperCase();

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final bool motionOn = AppMotion.enabled(context);
    // O role `primary` usa o acento primário resolvido por brilho (base no
    // claro, `s400` no escuro) — a base do `primary` é escura demais como
    // texto/borda/tint sobre a superfície escura e o badge sumia (mesmo motivo
    // pelo qual `neutral` usa `onSurface`). Os demais roles têm bases médias que
    // já contrastam nos dois temas.
    final Color roleColor = color == AppBadgeColor.primary
        ? colors.primaryAccent(isDark: isDark)
        : color.resolve(colors);
    final AppStyle s = style ?? theme.styleTheme.style;
    final TextStyle labelStyle = size
        .labelStyle(theme.textTheme)
        .copyWith(color: roleColor);
    // O raio segue o modo de forma global (`theme.radiusTheme`, padrão Redondo =
    // fração da ALTURA), resolvido a partir do tamanho REAL da pílula — assim os
    // 4 tamanhos ficam proporcionalmente consistentes (Reto=0, Redondo=%altura,
    // Circular=pílula). Sem passar o tamanho, `redondo` cairia no teto fixo e o
    // raio "quebraria" entre os tamanhos. Medimos a altura do label (1 linha) +
    // padding vertical p/ dar o `size` ao resolvedor (mesma abordagem do AppAvatar).
    final TextPainter painter = TextPainter(
      text: TextSpan(text: _text, style: labelStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    // O ícone casa com a CAIXA DE LINHA medida do label (painter.height): o
    // TextPainter já aplica o textScaler, e altura do ícone == altura da linha
    // garante por construção que a pílula com ícone tem a MESMA altura da sem
    // — o raio proporcional (redondo = fração da altura) não se mexe.
    final double iconSize = painter.height;
    final Size pillSize = Size(
      painter.width +
          (icon == null ? 0 : AppSpacings.s4 + iconSize) +
          size.padding.horizontal,
      math.max(painter.height, icon == null ? 0 : iconSize) +
          size.padding.vertical,
    );
    painter.dispose();
    final BorderRadius br = radius ?? theme.radiusTheme.resolve(size: pillSize);
    // Fill tingido do badge: o papel a 10%. Em `elevated` ele precisa ser SÓLIDO
    // (sem transparência) — um fundo translúcido deixaria a sombra vazar por baixo
    // e o fundo "sumiria". Achatamos o tom sobre `surfaceContainer` (a superfície
    // elevada), não sobre `surface`: fica opaco e continua legível/elevado em
    // claro E escuro (sobre `surface`, no escuro, o achatamento viraria um "buraco"
    // quase-preto). Nos demais estilos (sem sombra) o tom translúcido é preservado.
    final Color tint = roleColor.withValues(alpha: 0.1);
    final Color tintedFill = s == AppStyle.elevated
        ? Color.alphaBlend(tint, colors.surfaceContainer)
        : tint;
    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: isDark,
      // A borda (outlined) usa a cor do papel — a mesma do texto.
      outline: roleColor,
      surfaceContainer: colors.surfaceContainer,
      ownFill: tintedFill,
      background: background,
    );

    // A "casca" visual: pílula auto-dimensionada com a decoração do estilo.
    // [shadow]/[overlay] variam por estado; [animated] usa AnimatedContainer
    // (motion-gated) no caminho clicável. O caminho estático (somente-leitura)
    // não recorta nem anima → idêntico ao comportamento histórico.
    Widget box({
      List<BoxShadow>? shadow,
      Color? overlay,
      bool animated = false,
    }) {
      // A borda do estilo NÃO entra na decoração do Container — ela inseriria o
      // conteúdo (via decoration.padding) e aumentaria o tamanho do componente.
      // Fica numa DecoratedBox por cima, que não afeta o layout: nem o texto nem
      // o tamanho mudam com a borda.
      final BoxDecoration decoration = BoxDecoration(
        color: deco.color,
        boxShadow: shadow,
        borderRadius: br,
      );
      // Quando clicável, o label é conteúdo passivo: desabilita a seleção de
      // texto para não roubar o clique (a seleção venceria o tap na arena de
      // gestos, dentro de uma SelectionArea). Ver button_core.
      final Widget label0 = AppText(_text, style: labelStyle);
      final Widget labelW = onTap == null
          ? label0
          : SelectionContainer.disabled(child: label0);
      // O ícone fica FORA do SelectionContainer (SVG não participa de seleção)
      // e é decorativo por construção (AppIcon sem semanticLabel) — o badge
      // continua um nó rotulado único.
      final Widget content = icon == null
          ? labelW
          : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AppIcon(icon!, color: roleColor, customSize: iconSize),
                const SizedBox(width: AppSpacings.s4),
                labelW,
              ],
            );
      final Widget filled = animated
          ? AnimatedContainer(
              duration: AppMotion.resolve(context, AppDurations.fast),
              curve: AppCurves.standard,
              padding: size.padding,
              decoration: decoration,
              child: content,
            )
          : Container(
              padding: size.padding,
              decoration: decoration,
              child: content,
            );
      // O realce (overlay) cobre a PÍLULA INTEIRA — padding incluído, não só o
      // texto. Fica por cima do fundo como uma DecoratedBox arredondada do
      // tamanho do container (Positioned.fill), então hover/press pintam o
      // componente todo.
      final Widget highlighted = overlay == null
          ? filled
          : Stack(
              children: <Widget>[
                filled,
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: overlay, borderRadius: br),
                  ),
                ),
              ],
            );
      if (deco.border == null) return highlighted;
      return DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(border: deco.border, borderRadius: br),
        child: highlighted,
      );
    }

    if (onTap == null) {
      // Somente-leitura: nó rotulado único (comportamento histórico).
      //
      // A semântica usa o [label] ORIGINAL, não o caixa-alta: leitor de tela
      // soletra sigla, e "ATIVA" viraria A-T-I-V-A. O caixa-alta é decisão
      // visual; o texto continua sendo o que foi escrito.
      return AppSemantics.label(
        label: label,
        child: box(shadow: deco.boxShadow),
      );
    }

    // Clicável: hover/press/dragged ([effect]) + realce + anel de foco + role de
    // botão. O AppSemantics.button embrulha o FlocksInteraction por fora (idioma
    // do DS, ver button_core) → o nó de botão é a raiz da semântica.
    return AppSemantics.button(
      label: label,
      enabled: true,
      onTap: onTap,
      child: FlocksInteraction(
        onPressed: onTap,
        statesController: statesController,
        builder: (BuildContext context, Set<WidgetState> states) {
          final BadgeInteraction v = resolveBadgeInteraction(
            states: states,
            effect: effect,
            onSurface: colors.onSurface,
            isDark: isDark,
            motionEnabled: motionOn,
          );
          final bool focused = states.contains(WidgetState.focused);

          // A caixa anima a sombra de lift (motion-gated). O realce (overlay) é
          // state-driven e aparece instantaneamente.
          final Widget scaled = AnimatedScale(
            scale: v.scale,
            duration: AppMotion.resolve(context, AppDurations.fast),
            curve: AppCurves.standard,
            child: box(
              shadow: v.liftShadow ?? deco.boxShadow,
              overlay: v.overlay,
              animated: true,
            ),
          );

          // Anel de foco por fora (não desloca layout; some no toque). PLAIN
          // (sem duração) → sobrevive a reduce-motion.
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
      ),
    );
  }
}
