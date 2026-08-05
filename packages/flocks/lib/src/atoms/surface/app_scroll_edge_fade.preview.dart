import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_scroll_edge_fade.dart';

// Previews nativos (Regra 5). Lado a lado: o mesmo véu com conteúdo que ROLA
// (degradê na base) e com conteúdo curto (nada pintado) — a regra de "só
// aparece quando há o que esconder" só se vê comparando os dois.

Widget _rows(int n) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    for (int i = 1; i <= n; i++)
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacings.s8),
        child: AppText('Linha $i'),
      ),
  ],
);

Widget _box({required Widget child}) =>
    SizedBox(width: 180, height: 160, child: child);

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surfaceContainer,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacings.s24,
        children: <Widget>[
          // Rola: o véu nasce na borda que esconde conteúdo.
          _box(
            child: AppScrollEdgeFade(
              child: SingleChildScrollView(child: _rows(12)),
            ),
          ),
          // Não rola: nada é pintado.
          _box(
            child: AppScrollEdgeFade(
              child: SingleChildScrollView(child: _rows(2)),
            ),
          ),
          // O marcador desliga o véu de fora e deixa o de dentro cuidar.
          _box(
            child: AppScrollEdgeFade(
              child: AppScrollEdgeFadeOwner(
                child: Column(
                  children: <Widget>[
                    const AppText('abas'),
                    Expanded(
                      child: AppScrollEdgeFade(
                        child: SingleChildScrollView(child: _rows(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppScrollEdgeFade • claro')
Widget appScrollEdgeFadeLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppScrollEdgeFade • escuro')
Widget appScrollEdgeFadeDarkPreview() => _sample(AppThemeData.dark);
