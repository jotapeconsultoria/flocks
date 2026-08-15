import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppDataTable — grid paginado com ordenação. AppSimpleDataTable — grid estático.
// ---------------------------------------------------------------------------

const List<String> _cols = <String>['Placa', 'Modelo', 'Status'];

List<List<Widget>> _rows(int n) => List<List<Widget>>.generate(
  n,
  (int i) => <Widget>[
    AppText('ABC-${1000 + i}'),
    const AppText('GV75'),
    AppText(i.isEven ? 'Online' : 'Offline'),
  ],
);

@widgetbook.UseCase(name: 'Playground', type: AppDataTable)
Widget dataTablePlayground(BuildContext context) {
  final int rowCount = context.knobs.int.slider(
    label: 'rows',
    initialValue: 6,
    min: 1,
    max: 16,
  );
  return wbUseCase(
    context,
    name: 'AppDataTable',
    description:
        'Paginated, column-sortable grid. Pagination is server-side in real '
        'usage; here the callbacks are no-ops.',
    maxWidth: 720,
    child: AppDataTable(
      columnLabels: _cols,
      rows: _rows(rowCount),
      page: 1,
      perPage: 16,
      total: rowCount,
      totalPages: 1,
      columnSortOrders: const <AppDataTableSortOrder>[
        AppDataTableSortOrder.none,
        AppDataTableSortOrder.asc,
        AppDataTableSortOrder.none,
      ],
      onColumnSortTap: (_) {},
      onPageChange: (_) {},
      onPerPageChange: (_) {},
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppSimpleDataTable)
Widget simpleDataTablePlayground(BuildContext context) {
  final bool weighted = context.knobs.boolean(
    label: 'columnFlex ([2, 1, 1])',
    initialValue: false,
  );
  final int rowCount = context.knobs.int.slider(
    label: 'rows',
    initialValue: 3,
    min: 1,
    max: 8,
  );
  return wbUseCase(
    context,
    name: 'AppSimpleDataTable',
    description: 'Static grid: header + rows, no sort/pagination.',
    maxWidth: 560,
    child: AppSimpleDataTable(
      columnLabels: _cols,
      rows: _rows(rowCount),
      columnFlex: weighted ? const <double>[2, 1, 1] : null,
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppDataTable)
Widget dataTableStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDataTable',
  description: 'Unsorted vs a column sorted ascending.',
  maxWidth: 720,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      wbState(
        context,
        name: 'Unsorted',
        width: 640,
        child: AppDataTable(
          columnLabels: _cols,
          rows: _rows(3),
          page: 1,
          perPage: 16,
          total: 3,
          totalPages: 1,
          onColumnSortTap: (_) {},
          onPageChange: (_) {},
          onPerPageChange: (_) {},
        ),
      ),
      const SizedBox(height: AppSpacings.s32),
      wbState(
        context,
        name: 'Sorted (asc)',
        width: 640,
        child: AppDataTable(
          columnLabels: _cols,
          rows: _rows(3),
          page: 1,
          perPage: 16,
          total: 3,
          totalPages: 1,
          columnSortOrders: const <AppDataTableSortOrder>[
            AppDataTableSortOrder.asc,
            AppDataTableSortOrder.none,
            AppDataTableSortOrder.none,
          ],
          onColumnSortTap: (_) {},
          onPageChange: (_) {},
          onPerPageChange: (_) {},
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppSimpleDataTable)
Widget simpleDataTableStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSimpleDataTable',
  description: 'Two vs three columns.',
  maxWidth: 640,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      wbState(
        context,
        name: '2 columns',
        width: 480,
        child: AppSimpleDataTable(
          columnLabels: const <String>['Placa', 'Modelo'],
          rows: <List<Widget>>[
            for (int i = 0; i < 2; i++)
              <Widget>[AppText('ABC-${1000 + i}'), const AppText('GV75')],
          ],
        ),
      ),
      const SizedBox(height: AppSpacings.s32),
      wbState(
        context,
        name: '3 columns',
        width: 480,
        child: AppSimpleDataTable(columnLabels: _cols, rows: _rows(2)),
      ),
    ],
  ),
);
