/// Estrutura de dados para renderização de tabela.
final class AppMarkdownTableData {
  const AppMarkdownTableData({required this.columnLabels, required this.rows});

  /// Labels do cabeçalho.
  final List<String> columnLabels;

  /// Linhas da tabela.
  final List<List<String>> rows;
}

/// Helper para converter tabela em Markdown para [AppMarkdownTableData].
final class AppMarkdownTableFormatter {
  const AppMarkdownTableFormatter._();

  /// Faz parse de uma tabela em markdown.
  ///
  /// Retorna `null` se o conteúdo não aparentar ser uma tabela válida.
  static AppMarkdownTableData? parse(String markdown) {
    final lines = markdown
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);

    if (lines.length < 2) {
      return null;
    }

    for (var dividerIndex = 1; dividerIndex < lines.length; dividerIndex++) {
      final dividerCells = _splitMarkdownRow(lines[dividerIndex]);
      if (!_isDividerRow(dividerCells)) {
        continue;
      }

      final headerCells = _splitMarkdownRow(
        lines[dividerIndex - 1],
      ).map(_normalizeHeaderLabel).toList(growable: false);
      if (headerCells.length < 2 || dividerCells.length != headerCells.length) {
        continue;
      }

      final rowCount = headerCells.length;
      final parsedRows = <List<String>>[];

      for (
        var rowIndex = dividerIndex + 1;
        rowIndex < lines.length;
        rowIndex++
      ) {
        final rawRow = _splitMarkdownRow(lines[rowIndex]);
        if (rawRow.isEmpty) {
          continue;
        }

        parsedRows.add(_normalizeRow(rawRow, rowCount));
      }

      return AppMarkdownTableData(columnLabels: headerCells, rows: parsedRows);
    }

    return null;
  }

  static bool _isDividerRow(List<String> cells) {
    if (cells.isEmpty) {
      return false;
    }

    return cells.every((cell) => RegExp(r'^:?-{3,}:?$').hasMatch(cell));
  }

  static List<String> _normalizeRow(List<String> row, int targetSize) {
    if (row.length == targetSize) {
      return row;
    }

    if (row.length > targetSize) {
      return row.take(targetSize).toList(growable: false);
    }

    return <String>[
      ...row,
      ...List<String>.filled(targetSize - row.length, ''),
    ];
  }

  static List<String> _splitMarkdownRow(String line) {
    final trimmed = line.trim();

    if (!trimmed.contains('|')) {
      return const [];
    }

    var normalized = trimmed;
    if (normalized.startsWith('|')) {
      normalized = normalized.substring(1);
    }
    if (normalized.endsWith('|')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }

    final cells = <String>[];
    final buffer = StringBuffer();

    for (var index = 0; index < normalized.length; index++) {
      final char = normalized[index];
      final nextIndex = index + 1;
      final hasNext = nextIndex < normalized.length;

      if (char == '\\' && hasNext && normalized[nextIndex] == '|') {
        buffer.write('|');
        index++;
        continue;
      }

      if (char == '|') {
        cells.add(buffer.toString().trim());
        buffer.clear();
        continue;
      }

      buffer.write(char);
    }

    cells.add(buffer.toString().trim());
    return cells;
  }

  static String _normalizeHeaderLabel(String label) {
    final withoutParenthesis = label.replaceAll(RegExp(r'\s*\([^)]*\)'), '');
    final normalizedWhitespace = withoutParenthesis
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (normalizedWhitespace.isEmpty) {
      return label.trim();
    }

    return normalizedWhitespace;
  }
}
