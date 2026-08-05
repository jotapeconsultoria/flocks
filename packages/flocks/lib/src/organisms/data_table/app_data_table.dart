import 'package:flutter/gestures.dart' show kPrimaryMouseButton;
import '../../molecules/interactive/interactive.dart';
import '../../theme/theme.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../tokens/tokens.dart';
import 'app_data_table_sort_order.dart';
import 'linked_horizontal_scroll.dart';

/// Chevron de ordenação no cabeçalho. Menor que o `AppIconSize.s`: ali ele é
/// um indicador ao lado do rótulo, não um ícone de ação.
const double _sortChevronSize = 14.0;

String _sortTooltipMessage({
  required String label,
  required AppDataTableSortOrder currentOrder,
}) {
  final nextAction = switch (currentOrder) {
    AppDataTableSortOrder.none => 'decrescente',
    AppDataTableSortOrder.desc => 'crescente',
    AppDataTableSortOrder.asc => 'sem ordenação',
  };

  return 'Ordenar "$label" ($nextAction)';
}

/// Tabela genérica paginada, com ordenação opcional por coluna.
///
/// Reutilizável em listas do backoffice. Recebe rótulos das colunas,
/// linhas como listas de células, e dados de paginação com callbacks.
/// Se [columnSortOrders] e [onColumnSortTap] forem passados, o header
/// exibe chevrons e é clicável (toggle none → desc → asc → none).
final class AppDataTable extends StatefulWidget {
  const AppDataTable({
    required this.columnLabels,
    required this.onPageChange,
    required this.onPerPageChange,
    required this.page,
    required this.perPage,
    required this.rows,
    required this.total,
    required this.totalPages,
    this.columnSortOrders,
    this.onColumnSortTap,
    this.onRowTap,
    this.onRowSecondaryTap,
    this.selectedRowIndex,
    this.columnWidths,
    this.onColumnReorder,
    this.onColumnResize,
    this.perPageOptions = const [12, 16, 20, 24, 32],
    this.totalLabelPlural = 'Itens',
    this.totalLabelSingular = 'Item',
    this.padding = const EdgeInsets.all(AppSpacings.s16),
    super.key,
  });

  /// Rótulos das colunas (cabeçalho).
  final List<String> columnLabels;

  /// Largura de cada coluna, em px. `null` mantém o repartir automático.
  ///
  /// Com larguras explícitas a **última coluna estica** para ocupar a sobra:
  /// deixar espaço vazio à direita chamaria mais atenção do que a coluna
  /// larga. Só a última — as outras respeitam o que o usuário definiu.
  final List<double>? columnWidths;

  /// Reordenação de colunas por arraste no cabeçalho.
  ///
  /// Recebe `(origem, destino)` com o destino **já ajustado** para a remoção.
  /// Exige [columnWidths]: sem largura explícita não há como manter
  /// cabeçalho e corpo alinhados enquanto os dois rolam.
  final void Function(int oldIndex, int newIndex)? onColumnReorder;

  /// Redimensionamento por arraste na divisória entre colunas.
  ///
  /// Recebe o índice da coluna e o deslocamento em px. Exige [columnWidths] —
  /// só faz sentido onde a largura é um valor, não uma repartição.
  final void Function(int columnIndex, double delta)? onColumnResize;

  /// Ordenação por coluna (índice = índice da coluna). Se null ou vazio, sem ordenação.
  final List<AppDataTableSortOrder>? columnSortOrders;

  /// Callback ao clicar no header da coluna (índice da coluna).
  final void Function(int columnIndex)? onColumnSortTap;

  /// Callback ao mudar a página.
  final void Function(int page) onPageChange;

  /// Callback ao mudar itens por página.
  final void Function(int perPage) onPerPageChange;

  /// Callback ao clicar em uma linha da tabela (índice da linha).
  final void Function(int rowIndex)? onRowTap;

  /// Callback ao clicar com o botão direito em uma linha (abrir em nova aba).
  final void Function(int rowIndex)? onRowSecondaryTap;

  /// Índice da linha selecionada (destacada com shade mais forte que o hover).
  /// Quando null, nenhuma linha fica destacada.
  final int? selectedRowIndex;

  /// Página atual (1-based).
  final int page;

  /// Itens por página.
  final int perPage;

  /// Opções de itens por página.
  final List<int> perPageOptions;

  /// Linhas da tabela; cada linha é uma lista de widgets (células).
  final List<List<Widget>> rows;

  /// Total de itens.
  final int total;

  /// Label plural para o total (ex.: "Clientes" → "X Clientes").
  final String totalLabelPlural;

  /// Label singular para o total (ex.: "Cliente" → "X Clientes").
  final String totalLabelSingular;

  /// Total de páginas.
  final int totalPages;

  /// Inset externo da tabela (cabeçalho + corpo + paginação). Default
  /// `EdgeInsets.all(AppSpacings.s16)` — o respiro do cartão nos quatro lados.
  ///
  /// Uma página pode zerar um dos lados (ex.: o topo) quando **possui** o vão
  /// contra o vizinho na própria composição, para os dois não se somarem.
  final EdgeInsets padding;

  @override
  State<AppDataTable> createState() => _AppDataTableState();
}

class _AppDataTableState extends State<AppDataTable> {
  static const double _minimumColumnWidth = 160.0;

  /// Altura da faixa do cabeçalho no modo de largura explícita.
  ///
  /// Fixa porque ali o cabeçalho é uma lista rolável: uma lista precisa de
  /// altura definida, e o texto de uma coluna não pode esticar a faixa e
  /// desalinhá-la do corpo.
  static const double _headerHeight = 44.0;

  int? _hoveredRowIndex;

  /// Gesto de coluna em andamento — só para escolher o cursor.
  ///
  /// Durante um arraste o ponteiro sai da alça (ou da célula) e o cursor
  /// voltaria ao normal no meio do movimento. Uma região por cima da tabela
  /// inteira segura o cursor até o gesto terminar.
  bool _isReorderingColumn = false;
  bool _isResizingColumn = false;

  void _setColumnGesture({bool? reordering, bool? resizing}) {
    final bool nextReordering = reordering ?? _isReorderingColumn;
    final bool nextResizing = resizing ?? _isResizingColumn;
    if (nextReordering == _isReorderingColumn &&
        nextResizing == _isResizingColumn) {
      return;
    }
    setState(() {
      _isReorderingColumn = nextReordering;
      _isResizingColumn = nextResizing;
    });
  }

  /// Cabeçalho e corpo rolam juntos. Só existe no modo de largura explícita.
  LinkedHorizontalScroll? _linkedScroll;

  LinkedHorizontalScroll get _scroll =>
      _linkedScroll ??= LinkedHorizontalScroll();

  @override
  void dispose() {
    _linkedScroll?.dispose();
    super.dispose();
  }

  /// Larguras finais: as pedidas, com a **última** absorvendo a sobra.
  List<double> _resolveWidths(double available) {
    final List<double> widths = [...widget.columnWidths!];
    if (widths.isEmpty) return widths;
    final double total = widths.reduce((a, b) => a + b);
    if (total >= available) return widths;
    widths[widths.length - 1] += available - total;
    return widths;
  }

  // Métricas de coluna memoizadas: só recalculam quando o nº de colunas muda,
  // evitando realocar o Map a cada build (inclusive a cada frame de resize).
  int _cachedColumnCount = -1;
  Map<int, TableColumnWidth> _cachedColumnWidths = const {};
  double _cachedMinimumTableWidth = 0;

  void _ensureColumnMetrics(int columnCount) {
    if (_cachedColumnCount == columnCount) return;
    _cachedColumnCount = columnCount;
    _cachedColumnWidths = <int, TableColumnWidth>{
      for (var i = 0; i < columnCount; i++) i: const FlexColumnWidth(),
    };
    _cachedMinimumTableWidth = columnCount * _minimumColumnWidth;
  }

  /// Uma célula do cabeçalho: rótulo, chevron de ordenação e o toque que ordena.
  ///
  /// Extraída porque os dois modos de largura (automático e explícito) desenham
  /// o mesmo cabeçalho — só o que os envolve muda.
  Widget _headerCell({
    required int columnIndex,
    required AppThemeData theme,
    required List<AppDataTableSortOrder> sortOrders,
    required bool hasSort,
  }) {
    final label = widget.columnLabels[columnIndex];
    final order = hasSort && columnIndex < sortOrders.length
        ? sortOrders[columnIndex]
        : AppDataTableSortOrder.none;
    final labelStyle = theme.textTheme.labelLarge.withColor(
      theme.colorTheme.onSurface,
    );
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (order == AppDataTableSortOrder.asc) ...[
          AppIcon(
            AppIconToken.chevronUp,
            color: theme.colorTheme.onSurface,
            customSize: _sortChevronSize,
          ),
          const SizedBox(width: AppSpacings.s4),
        ] else if (order == AppDataTableSortOrder.desc) ...[
          AppIcon(
            AppIconToken.chevronDown,
            color: theme.colorTheme.onSurface,
            customSize: _sortChevronSize,
          ),
          const SizedBox(width: AppSpacings.s4),
        ],
        Expanded(
          child: AppText(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            semanticLabel: label,
            style: labelStyle,
          ),
        ),
      ],
    );
    final padded = Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.s16,
        AppSpacings.s8,
        AppSpacings.s0,
        AppSpacings.s8,
      ),
      child: content,
    );
    if (hasSort) {
      return AppInteraction(
        onTap: () => widget.onColumnSortTap!(columnIndex),
        tooltip: _sortTooltipMessage(label: label, currentOrder: order),
        semanticLabel: label,
        child: SelectionContainer.disabled(child: padded),
      );
    }
    return padded;
  }

  /// Layout de **largura explícita**: cabeçalho reordenável em cima, linhas
  /// embaixo, os dois rolando juntos.
  ///
  /// O cabeçalho é uma lista rolável própria — é o que traz o auto-scroll de
  /// borda durante o arraste, sem o qual reordenar seria impossível numa tabela
  /// mais larga que a tela. O corpo tem o seu, e [LinkedHorizontalScroll]
  /// mantém os dois no mesmo offset.
  Widget _buildExplicitLayout({
    required AppThemeData theme,
    required BoxConstraints constraints,
    required int columnCount,
    required List<AppDataTableSortOrder>? sortOrders,
    required bool hasSort,
  }) {
    final List<double> widths = _resolveWidths(constraints.maxWidth);
    final double totalWidth = widths.isEmpty
        ? 0
        : widths.reduce((a, b) => a + b);

    // O conteúdo do cabeçalho (rótulo + ordenação), sem a alça.
    Widget headerContent(int index) => _headerCell(
      columnIndex: index,
      theme: theme,
      sortOrders: sortOrders ?? const [],
      hasSort: hasSort,
    );

    /// A alça de redimensionar é IRMÃ do gatilho de arraste, nunca filha.
    ///
    /// Descendente dela, os dois reconhecedores disputavam a arena e o de
    /// reordenar vencia — ficar "por cima" resolve o hit-test, não a disputa de
    /// gesto. Como irmãos, cada um tem a sua área e não há disputa.
    Widget headerCell(int index, {required bool draggable}) => SizedBox(
      key: ValueKey<String>(widget.columnLabels[index]),
      width: widths[index],
      child: Stack(
        children: [
          Positioned.fill(
            child: draggable
                ? ReorderableDragStartListener(
                    index: index,
                    child: headerContent(index),
                  )
                : headerContent(index),
          ),
          if (widget.onColumnResize != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: _ColumnResizeHandle(
                onResize: (delta) => widget.onColumnResize!(index, delta),
                onResizeStart: () => _setColumnGesture(resizing: true),
                onResizeEnd: () => _setColumnGesture(resizing: false),
                color: theme.colorTheme.divider,
              ),
            ),
        ],
      ),
    );

    final Widget header = DecoratedBox(
      decoration: BoxDecoration(
        // Header em `surface` (as linhas usam `surfaceContainer`): invertido
        // para o cabeçalho não se perder no fundo elevado no tema escuro.
        color: theme.colorTheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(theme.radiusTheme.resolveRadius()),
        ),
      ),
      child: SizedBox(
        height: _headerHeight,
        child: widget.onColumnReorder == null
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scroll.header,
                child: Row(
                  children: [
                    for (int i = 0; i < columnCount; i++)
                      headerCell(i, draggable: false),
                  ],
                ),
              )
            : ReorderableList(
                scrollDirection: Axis.horizontal,
                controller: _scroll.header,
                itemCount: columnCount,
                onReorderItem: widget.onColumnReorder!,
                onReorderStart: (_) => _setColumnGesture(reordering: true),
                onReorderEnd: (_) => _setColumnGesture(reordering: false),
                // O proxy é pintado no Overlay, fora desta árvore — e portanto
                // fora do `AppTheme`. Reprovê-lo aqui, como nos dialogs.
                proxyDecorator: (child, index, animation) => AppTheme(
                  data: theme,
                  child: Opacity(opacity: 0.85, child: child),
                ),
                itemBuilder: (BuildContext context, int index) =>
                    headerCell(index, draggable: true),
              ),
      ),
    );

    return MouseRegion(
      // `defer` em repouso: cada filho decide (a alça pede o cursor de
      // redimensionar, o cabeçalho o de clique). Durante o gesto esta região
      // vence e segura o cursor mesmo com o ponteiro fora do alvo original.
      cursor: _isResizingColumn
          ? SystemMouseCursors.resizeColumn
          : _isReorderingColumn
          ? SystemMouseCursors.grabbing
          : MouseCursor.defer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          header,
          Expanded(
            child: RepaintBoundary(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scroll.body,
                child: SizedBox(
                  width: totalWidth,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (
                          int rowIndex = 0;
                          rowIndex < widget.rows.length;
                          rowIndex++
                        )
                          _buildRow(
                            theme: theme,
                            rowIndex: rowIndex,
                            widths: widths,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Uma linha no modo de largura explícita.
  Widget _buildRow({
    required AppThemeData theme,
    required int rowIndex,
    required List<double> widths,
  }) {
    final List<Widget> cells = widget.rows[rowIndex];
    final bool isHovered = _hoveredRowIndex == rowIndex;
    final bool isSelected = widget.selectedRowIndex == rowIndex;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _resolveRowColor(
          hasRowTap: widget.onRowTap != null,
          isRowHovered: isHovered,
          isRowSelected: isSelected,
          theme: theme,
        ),
        border: Border(
          bottom: BorderSide(
            color: theme.colorTheme.divider,
            width: AppStrokes.s,
          ),
        ),
      ),
      child: MouseRegion(
        cursor: widget.onRowTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: widget.onRowTap == null
            ? null
            : (_) => _setHoveredRow(rowIndex),
        onExit: widget.onRowTap == null
            ? null
            : (_) => _clearHoveredRow(rowIndex),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onRowTap == null
              ? null
              : () => widget.onRowTap!(rowIndex),
          onSecondaryTap: widget.onRowSecondaryTap == null
              ? null
              : () => widget.onRowSecondaryTap!(rowIndex),
          // `center` e não `stretch`: dentro do scroll vertical a linha não tem
          // altura definida, e esticar pediria altura infinita. A altura sai da
          // célula mais alta, que é o que se quer.
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < widths.length; i++)
                SizedBox(
                  width: widths[i],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacings.s16,
                      vertical: AppSpacings.s8,
                    ),
                    // A célula media a COLUNA inteira, e o cursor de seleção
                    // aparecia em toda a faixa — inclusive longe do texto
                    // (revisão P1r9). Precisa das duas coisas:
                    //
                    // - `Align`: a `SizedBox` da coluna passa largura APERTADA;
                    //   sem afrouxar, o texto é esticado e nenhuma base de
                    //   medida o encolhe;
                    // - `longestLine`: com largura frouxa, o padrão (`parent`)
                    //   ainda mediria o máximo disponível.
                    child: i < cells.length
                        ? DefaultTextStyle.merge(
                            textWidthBasis: TextWidthBasis.longestLine,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: cells[i],
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final columnCount = widget.columnLabels.length;
    final sortOrders = widget.columnSortOrders;
    final hasSort =
        sortOrders != null &&
        sortOrders.isNotEmpty &&
        widget.onColumnSortTap != null;
    _ensureColumnMetrics(columnCount);
    final columnWidths = _cachedColumnWidths;
    final minimumTableWidth = _cachedMinimumTableWidth;

    return Padding(
      padding: widget.padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Com larguras explícitas o layout é outro: cabeçalho e corpo viram
          // scrollables irmãos, sincronizados. É o que destrava reordenar e
          // redimensionar coluna — e o que o modo automático não consegue dar,
          // porque ali a largura é decidida pelo `Table` a cada layout.
          if (widget.columnWidths != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: _buildExplicitLayout(
                    theme: theme,
                    constraints: constraints,
                    columnCount: columnCount,
                    sortOrders: sortOrders,
                    hasSort: hasSort,
                  ),
                ),
                _AppDataTablePagination(
                  onPageChange: widget.onPageChange,
                  onPerPageChange: widget.onPerPageChange,
                  page: widget.page,
                  perPage: widget.perPage,
                  perPageOptions: widget.perPageOptions,
                  total: widget.total,
                  totalLabelSingular: widget.totalLabelSingular,
                  totalLabelPlural: widget.totalLabelPlural,
                  totalPages: widget.totalPages,
                ),
              ],
            );
          }

          final scrollableTable = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Table(
                columnWidths: columnWidths,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      // Header usa `surface` (as linhas usam `surfaceContainer`):
                      // invertido para o cabeçalho não se perder no fundo elevado
                      // no tema escuro.
                      color: theme.colorTheme.surface,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(theme.radiusTheme.resolveRadius()),
                      ),
                    ),
                    children: List.generate(
                      columnCount,
                      (columnIndex) => _headerCell(
                        columnIndex: columnIndex,
                        theme: theme,
                        sortOrders: sortOrders ?? const [],
                        hasSort: hasSort,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                // RepaintBoundary isola o repaint do corpo da tabela do resto
                // da tela (e vice-versa) durante resize/scroll/hover.
                child: RepaintBoundary(
                  child: SingleChildScrollView(
                    // O corpo usa um Column de linhas (em vez de Table) para que
                    // a área de toque/hover de cada linha ocupe toda a sua
                    // altura — inclusive o espaço vertical "vazio" de células
                    // mais baixas que a célula mais alta da linha. Larguras de
                    // coluna seguem iguais às do cabeçalho: Expanded com flex 1
                    // equivale ao FlexColumnWidth() usado no Table do cabeçalho.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...widget.rows.asMap().entries.map((entry) {
                          final rowIndex = entry.key;
                          final rowCells = entry.value;
                          final isRowHovered = _hoveredRowIndex == rowIndex;
                          final isRowSelected =
                              widget.selectedRowIndex == rowIndex;
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: _resolveRowColor(
                                hasRowTap: widget.onRowTap != null,
                                isRowHovered: isRowHovered,
                                isRowSelected: isRowSelected,
                                theme: theme,
                              ),
                              border: Border(
                                bottom: BorderSide(
                                  // Mesmo token do `AppDivider` (onSurface@10%),
                                  // coerente entre tema claro/escuro.
                                  color: theme.colorTheme.divider,
                                  width: AppStrokes.s,
                                ),
                              ),
                            ),
                            child: MouseRegion(
                              cursor: widget.onRowTap != null
                                  ? SystemMouseCursors.click
                                  : SystemMouseCursors.basic,
                              onEnter: widget.onRowTap == null
                                  ? null
                                  : (_) => _setHoveredRow(rowIndex),
                              onExit: widget.onRowTap == null
                                  ? null
                                  : (_) => _clearHoveredRow(rowIndex),
                              child: _AppDataTableTapProxy(
                                onTap: widget.onRowTap != null
                                    ? () => widget.onRowTap!(rowIndex)
                                    : null,
                                onSecondaryTap: widget.onRowSecondaryTap != null
                                    ? () => widget.onRowSecondaryTap!(rowIndex)
                                    : null,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: rowCells.map((cell) {
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          AppSpacings.s16,
                                          AppSpacings.s8,
                                          AppSpacings.s0,
                                          AppSpacings.s8,
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: cell,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );

          final pagination = _AppDataTablePagination(
            onPageChange: widget.onPageChange,
            onPerPageChange: widget.onPerPageChange,
            page: widget.page,
            perPage: widget.perPage,
            perPageOptions: widget.perPageOptions,
            total: widget.total,
            totalLabelSingular: widget.totalLabelSingular,
            totalLabelPlural: widget.totalLabelPlural,
            totalPages: widget.totalPages,
          );

          final Widget tableBody;
          if (constraints.maxWidth < minimumTableWidth) {
            // Em telas estreitas, somente o cabeçalho e as linhas rolam
            // horizontalmente; a paginação fica fixa fora do scroll para
            // permanecer sempre visível na tela.
            tableBody = SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(width: minimumTableWidth, child: scrollableTable),
            );
          } else {
            tableBody = scrollableTable;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: tableBody),
              pagination,
            ],
          );
        },
      ),
    );
  }

  void _clearHoveredRow(int rowIndex) {
    if (_hoveredRowIndex != rowIndex) {
      return;
    }

    setState(() => _hoveredRowIndex = null);
  }

  Color _resolveRowColor({
    required bool hasRowTap,
    required bool isRowHovered,
    required bool isRowSelected,
    required AppThemeData theme,
  }) {
    // Fundo da linha ciente do tema (era `neutralWhite` = branco fixo). Base =
    // `surfaceContainer` (invertido com o header/footer, que agora usam
    // `surface`); selecionado = tint do acento `secondary` resolvido sobre a
    // superfície (opaco, via alphaBlend); hover = realce neutro (`onSurface`).
    final Color base = theme.colorTheme.surfaceContainer;
    if (isRowSelected) {
      final Color accent = readableStopOn(theme.colorTheme.secondary, base);
      return Color.alphaBlend(accent.customOpacity(.12), base);
    }

    if (hasRowTap && isRowHovered) {
      return Color.alphaBlend(
        theme.colorTheme.onSurface.customOpacity(.06),
        base,
      );
    }

    return base;
  }

  void _setHoveredRow(int rowIndex) {
    if (_hoveredRowIndex == rowIndex) {
      return;
    }

    setState(() => _hoveredRowIndex = rowIndex);
  }
}

class _AppDataTablePagination extends StatelessWidget {
  const _AppDataTablePagination({
    required this.onPageChange,
    required this.onPerPageChange,
    required this.page,
    required this.perPage,
    required this.perPageOptions,
    required this.total,
    required this.totalPages,
    required this.totalLabelSingular,
    required this.totalLabelPlural,
  });

  final void Function(int page) onPageChange;
  final void Function(int perPage) onPerPageChange;
  final int page;
  final int perPage;
  final List<int> perPageOptions;
  final int total;
  final String totalLabelSingular;
  final String totalLabelPlural;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final canGoPrevious = page > 1;
    final canGoNext = page < totalPages;

    // Barra de paginação ciente do tema: usa `surface` (as linhas usam
    // `surfaceContainer`) para o footer não se perder no fundo elevado no tema
    // escuro; acentos resolvidos por contraste sobre ela.
    final Color barBg = theme.colorTheme.surface;
    final Color accent = readableStopOn(
      theme.colorTheme.tertiary,
      barBg,
      minRatio: 4.5,
    );
    final Color accentActive = readableStopOn(
      theme.colorTheme.secondary,
      barBg,
      minRatio: 4.5,
    );
    // Chevron DESABILITADO (primeira/última página). Era `neutralPrimary.s400`
    // fixo — o mesmo stop nos dois temas, que sobre a barra dava 1.67 no claro,
    // abaixo do piso de perceptibilidade do DS (`kDisabledMinRatio`). A receita
    // do DS para disabled é apagar por TOM a partir da cor habilitada, o que
    // mantém a distância dela e da superfície nos dois temas.
    final Color mutedIcon = mutedForDisabled(accent, barBg);
    // Os totais ficam FORA da barra, sobre a superfície que hospeda a tabela —
    // o cartão. `neutralPrimary.s600` fixo dava 3.74 ali no tema escuro.
    // Tamanho de página NÃO escolhido: neutro. Antes era o mesmo acento do
    // ativo em outra família (`tertiary` x `secondary`), que em algumas marcas
    // resolve para o MESMO stop — os dois ficavam idênticos.
    final Color idleOption = readableStopOn(
      theme.colorTheme.neutralPrimary,
      barBg,
      minRatio: kAaNormal,
    );
    final Color totalsColor = readableStopOn(
      theme.colorTheme.neutralPrimary,
      theme.colorTheme.surfaceContainer,
      minRatio: kAaNormal,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacings.s8,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: barBg,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(theme.radiusTheme.resolveRadius()),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.s16,
              vertical: AppSpacings.s8,
            ),
            child: Row(
              spacing: AppSpacings.s8,
              children: [
                Expanded(
                  child: Row(
                    spacing: AppSpacings.s4,
                    children: perPageOptions.map((n) {
                      final bool isCurrent = n == perPage;
                      return AppInteraction(
                        onTap: () => onPerPageChange(n),
                        tooltip: 'Mostrar $n itens por página',
                        semanticLabel: '$n itens por página',
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacings.s4,
                        ),
                        child: SelectionContainer.disabled(
                          child: SizedBox(
                            height: 20.0,
                            child: Center(
                              child: AppText(
                                '$n',
                                style: theme.textTheme.labelLarge.copyWith(
                                  // Ativo x inativo não podem se separar só
                                  // pela cor: em marcas onde `secondary` e
                                  // `tertiary` resolvem para o MESMO stop (a
                                  // zxtrack), os dois ficavam idênticos. O peso
                                  // é o que sobrevive a isso.
                                  color: isCurrent ? accentActive : idleOption,
                                  fontWeight: isCurrent
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppInteraction(
                        enabled: canGoPrevious,
                        onTap: canGoPrevious
                            ? () => onPageChange(page - 1)
                            : null,
                        tooltip: canGoPrevious
                            ? 'Ir para a página anterior'
                            : 'Página anterior indisponível',
                        semanticLabel: 'Página anterior',
                        padding: const EdgeInsets.all(AppSpacings.s4),
                        child: AppIcon(
                          AppIconToken.chevronLeft,
                          size: AppIconSize.s,
                          color: canGoPrevious ? accent : mutedIcon,
                        ),
                      ),
                      const SizedBox(width: AppSpacings.s8),
                      AppText(
                        'Página $page',
                        semanticLabel: 'Página $page',
                        style: theme.textTheme.labelLarge.withColor(accent),
                      ),
                      const SizedBox(width: AppSpacings.s8),
                      AppInteraction(
                        enabled: canGoNext,
                        onTap: canGoNext ? () => onPageChange(page + 1) : null,
                        tooltip: canGoNext
                            ? 'Ir para a próxima página'
                            : 'Próxima página indisponível',
                        semanticLabel: 'Próxima página',
                        padding: const EdgeInsets.all(AppSpacings.s4),
                        child: AppIcon(
                          AppIconToken.chevronRight,
                          size: AppIconSize.s,
                          color: canGoNext ? accent : mutedIcon,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacings.s16,
            AppSpacings.s8,
            AppSpacings.s32,
            AppSpacings.s8,
          ),
          child: Row(
            spacing: AppSpacings.s16,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    '$total ${total == 1 ? totalLabelSingular : totalLabelPlural}',
                    semanticLabel:
                        '$total ${total == 1 ? totalLabelSingular : totalLabelPlural}',
                    style: theme.textTheme.labelLarge.withColor(totalsColor),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AppText(
                    '$totalPages ${totalPages == 1 ? 'Página' : 'Páginas'}',
                    semanticLabel:
                        '$totalPages ${totalPages == 1 ? 'Página' : 'Páginas'}',
                    style: theme.textTheme.labelLarge.withColor(totalsColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AppDataTableTapProxy extends StatefulWidget {
  const _AppDataTableTapProxy({
    required this.child,
    this.onTap,
    this.onSecondaryTap,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onSecondaryTap;

  @override
  State<_AppDataTableTapProxy> createState() => _AppDataTableTapProxyState();
}

class _AppDataTableTapProxyState extends State<_AppDataTableTapProxy> {
  static const _dragThreshold = 6.0;
  Offset? _pointerDownPosition;
  bool _dragged = false;

  @override
  Widget build(BuildContext context) {
    final child = widget.onSecondaryTap == null
        ? widget.child
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onSecondaryTap: widget.onSecondaryTap,
            child: widget.child,
          );
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: widget.onTap == null
          ? null
          : (event) {
              if ((event.buttons & kPrimaryMouseButton) == 0) {
                return;
              }
              _pointerDownPosition = event.position;
              _dragged = false;
            },
      onPointerMove: widget.onTap == null
          ? null
          : (event) {
              final start = _pointerDownPosition;
              if (start == null || _dragged) {
                return;
              }
              if ((event.position - start).distance > _dragThreshold) {
                _dragged = true;
              }
            },
      onPointerCancel: widget.onTap == null
          ? null
          : (_) {
              _pointerDownPosition = null;
              _dragged = false;
            },
      onPointerUp: widget.onTap == null
          ? null
          : (event) {
              final start = _pointerDownPosition;
              final moved = start == null
                  ? true
                  : (event.position - start).distance > _dragThreshold ||
                        _dragged;
              _pointerDownPosition = null;
              _dragged = false;
              if (!moved) {
                widget.onTap?.call();
              }
            },
      child: child,
    );
  }
}

/// Alça de redimensionamento na divisória entre duas colunas.
///
/// Estreita de propósito: uma área larga engoliria o clique de ordenar, que
/// ocupa o resto do cabeçalho. O cursor muda para deixar claro onde ela está —
/// sem isso, a alça só seria descoberta por acidente.
final class _ColumnResizeHandle extends StatelessWidget {
  const _ColumnResizeHandle({
    required this.onResize,
    required this.onResizeStart,
    required this.onResizeEnd,
    required this.color,
  });

  static const double _width = 8.0;

  final ValueChanged<double> onResize;
  final VoidCallback onResizeStart;
  final VoidCallback onResizeEnd;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (_) => onResizeStart(),
        onHorizontalDragUpdate: (details) => onResize(details.delta.dx),
        onHorizontalDragEnd: (_) => onResizeEnd(),
        onHorizontalDragCancel: onResizeEnd,
        child: SizedBox(
          width: _width,
          child: Center(
            child: SizedBox(
              width: AppStrokes.s,
              child: ColoredBox(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
