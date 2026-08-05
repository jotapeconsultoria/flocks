import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppPagination — Playground (all knobs). Clicking a page IS the interaction,
// so there is NO CTA. State is held by a small stateful demo.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppPagination)
Widget paginationPlayground(BuildContext context) {
  final pageCount = context.knobs.int
      .slider(label: 'pageCount', initialValue: 20, min: 1, max: 50)
      .round();
  final siblingCount = context.knobs.int
      .slider(label: 'siblingCount', initialValue: 1, min: 0, max: 3)
      .round();
  final boundaryCount = context.knobs.int
      .slider(label: 'boundaryCount', initialValue: 1, min: 0, max: 3)
      .round();
  final showPrevNext = context.knobs.boolean(
    label: 'showPrevNext',
    initialValue: true,
  );
  final withPerPage = context.knobs.boolean(
    label: 'per-page selector',
    initialValue: false,
  );

  return wbUseCase(
    context,
    name: 'AppPagination',
    description:
        'Prev/next, page numbers with ellipsis, optional per-page '
        'selector.',
    child: _PaginationDemo(
      pageCount: pageCount,
      siblingCount: siblingCount,
      boundaryCount: boundaryCount,
      showPrevNext: showPrevNext,
      withPerPage: withPerPage,
    ),
  );
}

class _PaginationDemo extends StatefulWidget {
  const _PaginationDemo({
    required this.pageCount,
    required this.siblingCount,
    required this.boundaryCount,
    required this.showPrevNext,
    required this.withPerPage,
  });

  final int pageCount;
  final int siblingCount;
  final int boundaryCount;
  final bool showPrevNext;
  final bool withPerPage;

  @override
  State<_PaginationDemo> createState() => _PaginationDemoState();
}

class _PaginationDemoState extends State<_PaginationDemo> {
  int _page = 1;
  int _perPage = 20;

  @override
  Widget build(BuildContext context) {
    final int page = _page.clamp(1, widget.pageCount);
    return AppPagination(
      currentPage: page,
      pageCount: widget.pageCount,
      siblingCount: widget.siblingCount,
      boundaryCount: widget.boundaryCount,
      showPrevNext: widget.showPrevNext,
      onPageChanged: (p) => setState(() => _page = p),
      perPage: widget.withPerPage
          ? AppPaginationPerPage(
              value: _perPage,
              options: const <int>[10, 20, 50, 100],
              onChanged: (v) => setState(() => _perPage = v),
            )
          : null,
    );
  }
}

@widgetbook.UseCase(name: 'States', type: AppPagination)
Widget paginationStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppPagination',
  description: 'First, middle, last and a short range at a glance.',
  maxWidth: 640,
  panelPadding: AppSpacings.s32,
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'First page',
        when: 'Prev disabled',
        width: 480,
        child: AppPagination(
          currentPage: 1,
          pageCount: 20,
          siblingCount: 1,
          boundaryCount: 1,
          onPageChanged: (_) {},
        ),
      ),
      wbState(
        context,
        name: 'Middle',
        when: 'Ellipsis on both sides',
        width: 480,
        child: AppPagination(
          currentPage: 10,
          pageCount: 20,
          siblingCount: 1,
          boundaryCount: 1,
          onPageChanged: (_) {},
        ),
      ),
      wbState(
        context,
        name: 'Last page',
        when: 'Next disabled',
        width: 480,
        child: AppPagination(
          currentPage: 20,
          pageCount: 20,
          siblingCount: 1,
          boundaryCount: 1,
          onPageChanged: (_) {},
        ),
      ),
      wbState(
        context,
        name: 'Few pages',
        when: 'No ellipsis',
        width: 480,
        child: AppPagination(
          currentPage: 1,
          pageCount: 3,
          onPageChanged: (_) {},
        ),
      ),
    ],
  ),
);
