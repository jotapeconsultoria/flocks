import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../foundation/foundation.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Tabela simplificada com cabeçalho e linhas, sem ordenação e paginação.
///
/// Mantém o visual base do [AppDataTable] para cenários como respostas da IA.
final class AppSimpleDataTable extends StatelessWidget {
  const AppSimpleDataTable({
    required this.columnLabels,
    required this.rows,
    super.key,
  });

  /// Rótulos das colunas (cabeçalho).
  final List<String> columnLabels;

  /// Linhas da tabela; cada linha é uma lista de widgets (células).
  final List<List<Widget>> rows;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final columnCount = columnLabels.length;

    if (columnCount == 0) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasFiniteWidth =
            constraints.hasBoundedWidth && constraints.maxWidth.isFinite;
        final preferredColumnWidth = hasFiniteWidth
            ? const FlexColumnWidth()
            : const IntrinsicColumnWidth();
        final columnWidths = Map<int, TableColumnWidth>.fromIterables(
          List.generate(columnCount, (index) => index),
          List<TableColumnWidth>.filled(columnCount, preferredColumnWidth),
        );
        final content = AppSelectionRegion(
          child: _buildContent(
            theme: theme,
            columnCount: columnCount,
            columnWidths: columnWidths,
          ),
        );

        if (!hasFiniteWidth) {
          return content;
        }

        return SizedBox(width: constraints.maxWidth, child: content);
      },
    );
  }

  Widget _buildContent({
    required AppThemeData theme,
    required int columnCount,
    required Map<int, TableColumnWidth> columnWidths,
  }) {
    // Um só raio para o envelope inteiro: o topo vem do header e a base da
    // última linha, e eles têm de fechar a mesma caixa.
    final double cornerRadius = theme.radiusTheme.resolveRadius();

    final tableRows = <TableRow>[
      TableRow(
        decoration: BoxDecoration(
          // Header usa `surface` (as linhas usam `surfaceContainer`): invertido
          // para o cabeçalho não se perder no fundo elevado no tema escuro.
          color: theme.colorTheme.surface,
          borderRadius: rows.isEmpty
              ? BorderRadius.all(Radius.circular(cornerRadius))
              : BorderRadius.vertical(top: Radius.circular(cornerRadius)),
        ),
        children: List.generate(columnCount, (columnIndex) {
          final label = columnLabels[columnIndex];

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.s16,
              vertical: AppSpacings.s8,
            ),
            child: SelectionContainer.disabled(
              child: AppText(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                semanticLabel: label,
                style: theme.textTheme.labelLarge.withColor(
                  theme.colorTheme.onSurface,
                ),
              ),
            ),
          );
        }),
      ),
      ...rows.asMap().entries.map((entry) {
        final rowIndex = entry.key;
        final isLastRow = rowIndex == rows.length - 1;
        final rowCells = _normalizeRowCells(entry.value, columnCount);

        return TableRow(
          decoration: BoxDecoration(
            // Linhas usam `surfaceContainer` (invertido com o header, que usa
            // `surface`).
            color: theme.colorTheme.surfaceContainer,
            borderRadius: isLastRow
                ? BorderRadius.vertical(bottom: Radius.circular(cornerRadius))
                : null,
            border: Border(
              bottom: BorderSide(
                // Mesmo token do `AppDivider` (onSurface@10%), coerente entre
                // tema claro/escuro.
                color: theme.colorTheme.divider,
                width: AppStrokes.m,
              ),
            ),
          ),
          children: rowCells
              .map(
                (cell) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacings.s16,
                    vertical: AppSpacings.s8,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.text,
                      child: cell,
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        );
      }),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [Table(columnWidths: columnWidths, children: tableRows)],
    );
  }

  List<Widget> _normalizeRowCells(List<Widget> row, int expectedColumns) {
    if (row.length == expectedColumns) {
      return row;
    }

    if (row.length > expectedColumns) {
      return row.take(expectedColumns).toList(growable: false);
    }

    return <Widget>[
      ...row,
      ...List<Widget>.filled(
        expectedColumns - row.length,
        const SizedBox.shrink(),
      ),
    ];
  }
}
