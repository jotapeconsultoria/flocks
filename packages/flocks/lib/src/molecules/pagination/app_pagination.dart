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
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/swatch_generator.dart';
import '../dropdown/dropdown.dart';
import '../interactive/app_interaction.dart';

/// Sequência de páginas a exibir, com reticências (`null`) nas lacunas.
///
/// Ex.: `paginationRange(currentPage: 6, pageCount: 20)` →
/// `[1, null, 5, 6, 7, null, 20]`. Uma lacuna de exatamente uma página vira a
/// própria página (nunca esconde uma só atrás de reticências). Função pura →
/// testável isoladamente.
List<int?> paginationRange({
  required int currentPage,
  required int pageCount,
  int siblingCount = 1,
  int boundaryCount = 1,
}) {
  if (pageCount <= 0) return const <int?>[];

  // Se todas as páginas cabem sem economia de espaço, mostra todas (sem
  // reticências).
  final int maxWithEllipsis = boundaryCount * 2 + siblingCount * 2 + 5;
  if (pageCount <= maxWithEllipsis) {
    return <int?>[for (int i = 1; i <= pageCount; i++) i];
  }

  final Set<int> pages = <int>{};
  for (int i = 1; i <= boundaryCount && i <= pageCount; i++) {
    pages.add(i);
  }
  for (int i = pageCount - boundaryCount + 1; i <= pageCount; i++) {
    if (i >= 1) pages.add(i);
  }
  final int lo = (currentPage - siblingCount).clamp(1, pageCount);
  final int hi = (currentPage + siblingCount).clamp(1, pageCount);
  for (int i = lo; i <= hi; i++) {
    pages.add(i);
  }

  final List<int> sorted = pages.toList()..sort();
  final List<int?> items = <int?>[];
  int? previous;
  for (final int page in sorted) {
    if (previous != null) {
      if (page - previous == 2) {
        items.add(previous + 1); // lacuna de 1 → mostra a página
      } else if (page - previous > 2) {
        items.add(null); // reticências
      }
    }
    items.add(page);
    previous = page;
  }
  return items;
}

/// Seletor de "itens por página" de um [AppPagination].
final class AppPaginationPerPage {
  /// Cria um [AppPaginationPerPage].
  const AppPaginationPerPage({
    required this.value,
    required this.options,
    required this.onChanged,
    this.label = 'Por página',
  });

  /// Valor atual.
  final int value;

  /// Opções (ex.: `[10, 20, 50, 100]`).
  final List<int> options;

  /// Notifica a troca.
  final ValueChanged<int> onChanged;

  /// Rótulo antes do seletor.
  final String label;
}

/// Navegação de **páginas** standalone (desacoplada de tabela).
///
/// `‹ prev` + números com reticências (`1 … 5 [6] 7 … 20`) + `next ›`, com um
/// seletor de "por página" opcional. A página atual é uma pílula preenchida
/// (acento legível); as demais são fantasmas com realce de hover.
///
/// ```dart
/// AppPagination(
///   currentPage: page,
///   pageCount: totalPages,
///   onPageChanged: (p) => setState(() => page = p),
/// )
/// ```
final class AppPagination extends StatelessWidget {
  /// Cria um [AppPagination].
  const AppPagination({
    required this.currentPage,
    required this.pageCount,
    required this.onPageChanged,
    this.siblingCount = 1,
    this.boundaryCount = 1,
    this.showPrevNext = true,
    this.perPage,
    super.key,
  });

  /// Página atual (1-based).
  final int currentPage;

  /// Total de páginas.
  final int pageCount;

  /// Notifica a navegação.
  final ValueChanged<int> onPageChanged;

  /// Páginas irmãs mostradas de cada lado da atual.
  final int siblingCount;

  /// Páginas fixas em cada extremidade antes das reticências.
  final int boundaryCount;

  /// Se mostra os botões anterior/próximo.
  final bool showPrevNext;

  /// Seletor de "por página" opcional.
  final AppPaginationPerPage? perPage;

  static const double _cell = AppSizes.s48;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final List<int?> items = paginationRange(
      currentPage: currentPage,
      pageCount: pageCount,
      siblingCount: siblingCount,
      boundaryCount: boundaryCount,
    );

    final List<Widget> children = <Widget>[
      if (showPrevNext)
        AppInteraction(
          semanticLabel: 'Página anterior',
          enabled: currentPage > 1,
          padding: const EdgeInsets.all(AppSpacings.s8),
          onTap: () => onPageChanged(currentPage - 1),
          child: AppIcon(
            AppIconToken.chevronLeft,
            size: AppIconSize.s,
            color: colors.onSurface,
          ),
        ),
      for (final int? item in items)
        if (item == null)
          _ellipsis(theme, colors)
        else
          _pageButton(theme, colors, item),
      if (showPrevNext)
        AppInteraction(
          semanticLabel: 'Próxima página',
          enabled: currentPage < pageCount,
          padding: const EdgeInsets.all(AppSpacings.s8),
          onTap: () => onPageChanged(currentPage + 1),
          child: AppIcon(
            AppIconToken.chevronRight,
            size: AppIconSize.s,
            color: colors.onSurface,
          ),
        ),
    ];

    final Widget nav = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacings.s2,
      children: children,
    );

    if (perPage == null) return nav;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacings.s16,
      children: <Widget>[nav, _perPageSelector(theme, colors, perPage!)],
    );
  }

  Widget _ellipsis(AppThemeData theme, AppColorTheme colors) => SizedBox(
    width: _cell,
    height: _cell,
    child: Center(
      child: AppText(
        '…',
        style: theme.textTheme.bodyMedium.copyWith(
          color: colors.neutralPrimary.s600,
        ),
      ),
    ),
  );

  Widget _pageButton(AppThemeData theme, AppColorTheme colors, int page) {
    final bool current = page == currentPage;
    final Color accent = readableStopOn(colors.primary, colors.surface);

    if (current) {
      return Semantics(
        button: true,
        selected: true,
        label: 'Página $page, atual',
        child: SizedBox(
          width: _cell,
          height: _cell,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: accent,
                borderRadius: theme.radiusTheme.resolve(),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacings.s12,
                  vertical: AppSpacings.s8,
                ),
                child: AppText(
                  '$page',
                  style: theme.textTheme.titleMedium.copyWith(
                    color: onColorFor(accent),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return AppSemantics.button(
      label: 'Página $page',
      onTap: () => onPageChanged(page),
      child: SelectionContainer.disabled(
        child: FlocksInteraction(
          onPressed: () => onPageChanged(page),
          builder: (BuildContext context, Set<WidgetState> states) {
            final bool highlight =
                states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused);
            return SizedBox(
              width: _cell,
              height: _cell,
              child: Center(
                child: AnimatedContainer(
                  duration: AppMotion.resolve(context, AppDurations.fast),
                  curve: AppCurves.standard,
                  decoration: BoxDecoration(
                    color: highlight
                        ? colors.onSurface.withValues(alpha: 0.08)
                        : colors.transparent,
                    borderRadius: theme.radiusTheme.resolve(),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacings.s12,
                    vertical: AppSpacings.s8,
                  ),
                  child: AppText(
                    '$page',
                    style: theme.textTheme.titleMedium.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _perPageSelector(
    AppThemeData theme,
    AppColorTheme colors,
    AppPaginationPerPage config,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacings.s8,
      children: <Widget>[
        AppText(
          config.label,
          style: theme.textTheme.bodyMedium.copyWith(
            color: colors.neutralPrimary.s700,
          ),
        ),
        SizedBox(
          width: AppSizes.s128,
          child: AppDropdown<int>(
            selectedValue: config.value,
            onChanged: (int? v) {
              if (v != null) config.onChanged(v);
            },
            options: <AppDropdownOption<int>>[
              for (final int option in config.options)
                AppDropdownOption<int>(value: option, label: '$option'),
            ],
          ),
        ),
      ],
    );
  }
}
