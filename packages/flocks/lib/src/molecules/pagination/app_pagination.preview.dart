import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_pagination.dart';

// Previews nativos (Regra 5). onPageChanged no-op (estado fixo no preview).

@Preview(name: 'AppPagination • claro (com reticências)')
Widget appPaginationLight() => AppTheme(
  data: AppThemeData.light,
  child: const Center(
    child: AppPagination(currentPage: 6, pageCount: 20, onPageChanged: _noop),
  ),
);

@Preview(name: 'AppPagination • escuro (poucas páginas)')
Widget appPaginationDark() => AppTheme(
  data: AppThemeData.dark,
  child: const Center(
    child: AppPagination(currentPage: 2, pageCount: 5, onPageChanged: _noop),
  ),
);

void _noop(int _) {}
