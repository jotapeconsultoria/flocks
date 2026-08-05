import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/swatch_generator.dart';

/// Item de um [AppBreadcrumb]: um rótulo, clicável quando [onTap] != null.
final class AppBreadcrumbItem {
  /// Cria um [AppBreadcrumbItem].
  const AppBreadcrumbItem({required this.label, this.onTap});

  /// Texto do item.
  final String label;

  /// Ação de navegação. `null` = item atual (não clicável).
  final VoidCallback? onTap;

  /// Se o item é clicável.
  bool get isClickable => onTap != null;
}

/// Trilha de navegação (breadcrumb) do design system.
///
/// Cada item clicável usa [FlocksInteraction] (hover/press/foco-Tab + Enter/
/// Space) com realce de fundo e anel de foco; o texto do link resolve para um
/// stop legível (≥ AA) da cor de acento (`tertiary`), enquanto o item atual
/// (não clicável) usa `onSurface` em **negrito** ("você está aqui"). Todos os
/// itens compartilham a mesma caixa (padding + espaço de borda), então o item
/// atual alinha igual aos links mesmo sem estados de clique. Separadores em
/// acento legível. Cores 100% do tema; raio e animação globais.
///
/// ```dart
/// AppBreadcrumb(
///   items: <AppBreadcrumbItem>[
///     AppBreadcrumbItem(label: 'Início', onTap: goHome),
///     AppBreadcrumbItem(label: 'Veículos'),
///   ],
/// )
/// ```
final class AppBreadcrumb extends StatelessWidget {
  /// Cria um [AppBreadcrumb].
  const AppBreadcrumb({required this.items, super.key});

  /// Itens da trilha, do mais raso ao atual.
  final List<AppBreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final AppThemeData theme = AppTheme.of(context);
    // Realce neutro (onSurface) para o texto de acento não interagir com a hue
    // do fundo. O stop do link é escolhido contra o realce de press (estado
    // extremo), garantindo ≥ AA em repouso E pressionado.
    final Color pressBg = Color.alphaBlend(
      theme.colorTheme.onSurface.withValues(alpha: 0.12),
      theme.colorTheme.surface,
    );
    final Color accent = readableStopOn(
      theme.colorTheme.tertiary,
      pressBg,
      minRatio: 4.5,
    );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: AppSpacings.s2,
      spacing: AppSpacings.s0,
      children: <Widget>[
        for (int i = 0; i < items.length; i++) ...<Widget>[
          if (i > 0)
            AppText(
              ' / ',
              style: theme.textTheme.labelLarge.copyWith(color: accent),
            ),
          _BreadcrumbItem(item: items[i], accent: accent),
        ],
      ],
    );
  }
}

class _BreadcrumbItem extends StatelessWidget {
  const _BreadcrumbItem({required this.item, required this.accent});

  final AppBreadcrumbItem item;
  final Color accent;

  // Geometria compartilhada por TODOS os itens (clicáveis ou não): mesmo padding
  // + espaço de borda, para o texto alinhar igual na trilha. No item atual a
  // borda é transparente, mas ocupa o mesmo lugar que o anel de foco dos links.
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: AppSpacings.s8,
    vertical: AppSpacings.s2,
  );

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;

    // Item atual (não clicável): onSurface forte + negrito ("você está aqui").
    // Mesma caixa (padding + borda transparente) dos links → sem deslocamento.
    if (!item.isClickable) {
      return Container(
        padding: _padding,
        decoration: BoxDecoration(
          borderRadius: theme.radiusTheme.resolve(),
          border: Border.all(color: colors.transparent, width: AppStrokes.m),
        ),
        child: AppText(
          item.label,
          semanticLabel: item.label,
          style: theme.textTheme.labelLarge.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return AppSemantics.button(
      label: item.label,
      onTap: item.onTap,
      child: FlocksInteraction(
        onPressed: item.onTap,
        builder: (BuildContext context, Set<WidgetState> states) {
          final bool pressed = states.contains(WidgetState.pressed);
          final bool hovered = states.contains(WidgetState.hovered);
          final bool focused = states.contains(WidgetState.focused);
          final Color overlay = pressed
              ? colors.onSurface.withValues(alpha: 0.12)
              : hovered
              ? colors.onSurface.withValues(alpha: 0.08)
              : colors.transparent;

          return AnimatedContainer(
            duration: AppMotion.resolve(context, AppDurations.fast),
            curve: AppCurves.standard,
            padding: _padding,
            decoration: BoxDecoration(
              color: overlay,
              borderRadius: theme.radiusTheme.resolve(),
              border: Border.all(
                color: focused ? colors.focusRing : colors.transparent,
                width: AppStrokes.m,
              ),
            ),
            child: SelectionContainer.disabled(
              child: AppText(
                item.label,
                style: theme.textTheme.labelLarge.copyWith(color: accent),
              ),
            ),
          );
        },
      ),
    );
  }
}
