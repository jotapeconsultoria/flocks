import 'package:flutter/widgets.dart';

import '../theme/theme.dart';
import '../tokens/app_style.dart';

/// Aresta de uma barra que **encosta no conteúdo** (a costura).
///
/// [BarEdge.bottom] = header (conteúdo embaixo); [BarEdge.top] = footer
/// (conteúdo em cima). Governa de que lado ficam a borda (`outlined`), a sombra
/// (`elevated`) e o lado transparente do gradiente (glass).
enum BarEdge { top, bottom }

/// Contrato que uma **barra** (header/footer) expõe para o [AppScaffold] decidir
/// se ela **sobrepõe** o conteúdo (efeito iOS Notes) em vez de ficar no fluxo em
/// coluna.
///
/// Só o eixo glass sobrepõe: a barra flutua sobre o conteúdo (que rola por baixo
/// e é desfocado) e o scaffold reserva [resolveBarExtent] de padding no conteúdo.
/// [overlaysContent] depende **apenas** do eixo glass resolvido ([resolveGlassOn]
/// = prop `glass` ou o global `glassTheme`), não da transparência do SO, para não
/// haver *reflow* ao alternar reduzir-transparência — o fallback opaco ocupa o
/// mesmo slot sobreposto.
mixin AppOverlayBar on Widget {
  /// Estilo de container efetivo da barra no render **não-glass** (já resolvido
  /// do tema, se aplicável).
  AppStyle get barStyle;

  /// Override do eixo glass da barra (`null` segue o global `glassTheme`).
  bool? get glass;

  /// Aresta que encosta no conteúdo ([BarEdge.bottom] header / [BarEdge.top]
  /// footer).
  BarEdge get barEdge;

  /// Altura total que a barra ocupa (faixa de safe-area + conteúdo), para o
  /// scaffold reservar padding no conteúdo sob a barra sobreposta.
  double resolveBarExtent(BuildContext context);

  /// Eixo glass resolvido: override por instância ([glass]) ou o global da marca
  /// (`theme.glassTheme.enabled`). Delega ao resolvedor único do eixo.
  bool resolveGlassOn(BuildContext context) =>
      appResolveGlassOn(context, glass);

  /// Se a barra deve ser sobreposta ao conteúdo (só quando o glass está ligado).
  bool overlaysContent(BuildContext context) => resolveGlassOn(context);
}
