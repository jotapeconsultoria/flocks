import 'package:flocks/tokens.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import 'app_list_tile_group.dart';

/// Cores de texto de um list-tile: título forte, subtítulo muted e cor muted
/// (ícone leading / chevron). Todas do tema, contraste AA sobre a superfície.
typedef TileTextColors = ({Color title, Color subtitle, Color muted});

/// Resolve as cores de texto dos tiles em [colors].
TileTextColors tileTextColors(AppColorTheme colors) => (
  title: colors.onSurface,
  subtitle: colors.neutralPrimary.s700,
  muted: colors.neutralPrimary.s600,
);

/// Resolve cores destrutivas com contraste sobre o container do tile.
TileTextColors dangerTileTextColors(AppColorTheme colors) {
  final danger = readableStopOn(
    colors.danger,
    colors.surfaceContainer,
    minRatio: 4.5,
  );
  return (
    muted: danger.customOpacity(0.8),
    subtitle: danger.customOpacity(0.8),
    title: danger,
  );
}

/// Papel semântico de um tile.
enum TileSemantics {
  /// Botão (navegação/ação): `AppSemantics.button` com o título.
  button,

  /// Controle (checkbox/radio/switch): merge do título + controle num nó.
  merge,

  /// Estático / sem papel próprio.
  none,
}

/// Scaffold compartilhado dos list-tiles: leading + (título/subtítulo) +
/// trailing, com [FlocksInteraction] (hover/press/foco), drag handle opcional e
/// container por estilo/grupo. Não é API pública — os `AppListTile*` delegam.
class TileScaffold extends StatelessWidget {
  /// Cria um [TileScaffold].
  const TileScaffold({
    required this.title,
    this.danger = false,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.style = AppListTileStyle.grouped,
    this.reorderIndex,
    this.reorderEnabled = true,
    this.semantics = TileSemantics.none,
    this.semanticLabel,
    super.key,
  });

  /// Título (forte).
  final String title;

  /// Aplica o papel semântico destrutivo ao conteúdo.
  final bool danger;

  /// Subtítulo (muted, opcional).
  final String? subtitle;

  /// Widget à esquerda (ícone/avatar). Opcional.
  final Widget? leading;

  /// Widget à direita (chevron/checkbox/badge…). Opcional.
  final Widget? trailing;

  /// Ação de toque. `null` = não interativo.
  final VoidCallback? onTap;

  /// Se está habilitado.
  final bool enabled;

  /// Estilo do container quando **avulso** (ignorado dentro de um grupo).
  final AppListTileStyle style;

  /// Se != null, adiciona um drag handle no leading (`ReorderableDragStartListener`).
  final int? reorderIndex;

  /// Se o reordenamento está ativo.
  final bool reorderEnabled;

  /// Papel semântico.
  final TileSemantics semantics;

  /// Rótulo de acessibilidade (default: [title]).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final TileTextColors text = danger
        ? dangerTileTextColors(colors)
        : tileTextColors(colors);
    final AppListTileStyle? groupStyle = ListTileGroupScope.maybeOf(context);
    final bool inGroup = groupStyle != null;
    final AppListTileStyle effStyle = groupStyle ?? style;
    final bool interactive = enabled && onTap != null;
    final BorderRadius radius = theme.radiusTheme.tileRadius();

    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s16,
        vertical: AppSpacings.s16,
      ),
      child: SelectionContainer.disabled(
        child: Row(
          spacing: AppSpacings.s16,
          children: <Widget>[
            if (reorderIndex != null) _dragHandle(text.muted),
            ?_tintedLeading(text.title),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppText(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium.copyWith(
                      color: text.title,
                    ),
                  ),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: AppSpacings.s2),
                    AppText(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium.copyWith(
                        color: text.subtitle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );

    Widget tile = interactive
        ? FlocksInteraction(
            onPressed: onTap,
            enabled: interactive,
            builder: (BuildContext context, Set<WidgetState> states) {
              final bool hovered = states.contains(WidgetState.hovered);
              final bool pressed = states.contains(WidgetState.pressed);
              final bool focused = states.contains(WidgetState.focused);
              final Color overlay = pressed
                  ? colors.onSurface.withValues(alpha: 0.12)
                  : hovered
                  ? colors.onSurface.withValues(alpha: 0.08)
                  : colors.transparent;
              return AnimatedContainer(
                duration: AppMotion.resolve(context, AppDurations.fast),
                curve: AppCurves.standard,
                decoration: BoxDecoration(
                  color: overlay,
                  border: focused
                      ? Border.all(color: colors.focusRing, width: AppStrokes.m)
                      : null,
                ),
                child: content,
              );
            },
          )
        : content;

    // Container próprio só quando avulso (dentro de um grupo, o grupo cuida).
    if (!inGroup) {
      final BoxDecoration decoration = effStyle == AppListTileStyle.grouped
          ? BoxDecoration(color: colors.surfaceContainer, borderRadius: radius)
          : BoxDecoration(
              border: Border.all(color: colors.outline),
              borderRadius: radius,
            );
      tile = DecoratedBox(
        decoration: decoration,
        child: ClipRRect(borderRadius: radius, child: tile),
      );
    }

    return switch (semantics) {
      TileSemantics.button => AppSemantics.button(
        label: semanticLabel ?? title,
        enabled: enabled,
        onTap: onTap,
        child: tile,
      ),
      TileSemantics.merge => MergeSemantics(child: tile),
      TileSemantics.none => tile,
    };
  }

  // Um AppIcon de leading SEM cor explícita segue o tema (`onSurface`) — senão
  // renderiza a cor nativa do SVG (que "parece tema claro" no escuro). Avatares
  // e widgets custom passam intactos.
  Widget? _tintedLeading(Color color) {
    final Widget? l = leading;
    if (l is AppIcon && l.color == null) {
      return AppIcon(
        l.icon,
        color: color,
        size: l.size,
        customSize: l.customSize,
        semanticLabel: l.semanticLabel,
      );
    }
    return l;
  }

  Widget _dragHandle(Color color) {
    final Widget icon = MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: AppIcon(AppIconToken.dragArrow, color: color, size: AppIconSize.m),
    );
    return reorderEnabled
        ? ReorderableDragStartListener(index: reorderIndex!, child: icon)
        : icon;
  }
}
