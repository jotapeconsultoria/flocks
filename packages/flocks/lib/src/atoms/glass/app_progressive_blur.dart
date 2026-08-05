import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Primitivo interno que aplica um **blur progressivo** (rampa de sigma) no eixo
/// vertical: forte numa aresta, zero na outra.
///
/// Existe por causa das **barras full-bleed** (headers/footers). Uma superfície
/// flutuante tem quinas — o vidro começa e termina, e o olho aceita um blur
/// uniforme. Uma band colada na borda da tela não tem a quina interna: ela
/// precisa **dissolver** no conteúdo. Com blur uniforme + tint em gradiente (o
/// que o DS fazia antes), o tint some mas o blur **corta seco** na aresta —
/// e é esse corte que faz a barra ler como "um retângulo com fill translúcido"
/// em vez de vidro. Rampando o sigma, não há aresta: é o efeito do iOS Notes.
///
/// A pilha:
///
/// ```
/// BackdropGroup                          // 1 snapshot do backdrop p/ todas
///  └ Stack(passthrough)
///    ├ Positioned.fill                   // as fatias, ATRÁS do conteúdo
///    │  └ Column[ Expanded(ClipRect(BackdropFilter.grouped(sigma_i))) × N ]
///    └ child                             // tint + conteúdo da barra
/// ```
///
/// **Custo.** São [layers] `BackdropFilter`, mas todos com `.grouped` sob um
/// [BackdropGroup]: eles compartilham **um único** snapshot/pirâmide de blur do
/// que está atrás, em vez de reamostrar N vezes. É por isso que dá para usar
/// uma dezena de fatias sem pagar uma dezena de blurs.
///
/// **Fatias disjuntas, não aninhadas.** Com `.grouped` os filtros *não* compõem
/// entre si (cada um lê o backdrop original, não o resultado do irmão), então
/// empilhar fatias cumulativas não somaria blur — a suavidade tem que vir da
/// quantidade de fatias.
///
/// **Acessibilidade:** com transparência reduzida ([AppTransparency]) não
/// instancia `BackdropFilter` nenhum — devolve o [child] cru. O chamador é quem
/// escolhe a superfície opaca de fallback.
///
/// **Não é exportado no baril** — detalhe de implementação do `AppBarSurface`,
/// igual ao `AppGlassSurface`.
@internal
class AppProgressiveBlur extends StatelessWidget {
  /// Cria um [AppProgressiveBlur].
  const AppProgressiveBlur({
    required this.strongAtTop,
    required this.child,
    this.maxSigma = AppGlass.blurSigma,
    this.layers = AppGlass.barBlurLayers,
    super.key,
  });

  /// Aresta onde o blur é **máximo**: `true` = topo (header, que dissolve para
  /// baixo), `false` = base (footer, que dissolve para cima).
  final bool strongAtTop;

  /// Sigma na aresta forte. Cai até ~0 na aresta oposta.
  final double maxSigma;

  /// Número de fatias da rampa.
  final int layers;

  /// Conteúdo pintado **sobre** a rampa (tint + conteúdo da barra).
  final Widget child;

  /// Sigma da fatia [i], pelo centro dela.
  ///
  /// Rampa `1 - f²` (e não linear) de propósito: mantém o vidro em força quase
  /// total na maior parte da barra e concentra a dissolução no terço colado na
  /// costura — que é onde o Notes de fato dissolve. Rampa linear "vaza" blur
  /// fraco na região onde o título deveria estar sobre vidro cheio.
  double _sigmaFor(int i) {
    // Fração do centro da fatia medida A PARTIR da aresta forte.
    final double f = (i + 0.5) / layers;
    return maxSigma * (1 - f * f);
  }

  @override
  Widget build(BuildContext context) {
    if (layers <= 0 || maxSigma <= 0 || !AppTransparency.enabled(context)) {
      return child;
    }

    final List<Widget> slices = <Widget>[
      for (int i = 0; i < layers; i++) Expanded(child: _slice(_sigmaFor(i))),
    ];

    return BackdropGroup(
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Positioned.fill(
            child: IgnorePointer(
              child: Column(
                children: strongAtTop ? slices : slices.reversed.toList(),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  /// Uma fatia da rampa. Abaixo de meio sigma o blur é imperceptível e só
  /// custaria uma camada — a fatia vira um vão vazio (o conteúdo passa limpo).
  Widget _slice(double sigma) {
    if (sigma < 0.5) return const SizedBox.expand();
    return ClipRect(
      child: BackdropFilter.grouped(
        // Desfoca E re-satura, igual ao resto do vidro (ver AppGlass).
        filter: AppGlass.backdropFilter(sigma: sigma),
        child: const SizedBox.expand(),
      ),
    );
  }
}
