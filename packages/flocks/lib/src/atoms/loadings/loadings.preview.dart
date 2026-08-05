import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../texts/texts.dart';
import 'loadings.dart';

// Previews nativos (Regra 5).

Widget _gallery() => const Padding(
  padding: EdgeInsets.all(24),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 24,
    children: [
      AppCircularLoading(size: AppSizes.s32),
      SizedBox(width: 220, child: AppLinearLoading()),
      AppShimmerLoading(height: 16, width: 220),
      // `AppBorderProgress` e `AppOverlayLoading` envolvem conteúdo em vez de
      // se desenharem sozinhos — por isso vão com um filho de mentira.
      SizedBox(
        width: 220,
        height: 56,
        child: AppBorderProgress(
          progress: 0.6,
          child: Center(child: AppText('Enviando…')),
        ),
      ),
      SizedBox(
        width: 220,
        height: 56,
        child: AppOverlayLoading(
          isLoading: true,
          overlay: AppCircularLoading(),
          child: Center(child: AppText('Conteúdo bloqueado')),
        ),
      ),
    ],
  ),
);

@Preview(name: 'Loadings • claro')
Widget loadingsLight() => AppTheme(
  data: AppThemeData.light,
  child: Center(child: _gallery()),
);

@Preview(name: 'Loadings • escuro')
Widget loadingsDark() => AppTheme(
  data: AppThemeData.dark,
  child: Center(child: _gallery()),
);
