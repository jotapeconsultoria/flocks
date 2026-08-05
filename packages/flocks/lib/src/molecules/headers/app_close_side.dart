/// Lado da barra de topo onde o botão de fechar de uma superfície flutuante
/// (dialog, bottom sheet, side sheet) aparece.
///
/// Usa `start`/`end` (relativo à direção do texto), não `left`/`right` — RTL-safe.
/// Em LTR: `end` = direita (default), `start` = esquerda.
///
/// Mora aqui, e não em `organisms/`, porque quem o consome é a barra de topo
/// compartilhada (`AppSurfaceTopBar`), uma molécula — um organismo não pode ser
/// importado por uma camada abaixo dele. O nome mantém o prefixo `Sheet` por ser
/// API pública desde antes de o dialog ganhar barra.
enum AppSheetCloseSide {
  /// Início da linha (esquerda em LTR).
  start,

  /// Fim da linha (direita em LTR). Default.
  end,
}
