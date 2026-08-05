/// Borda em que um [AppSideSheet] ancora e de onde desliza.
///
/// Usa `start`/`end` (relativo à direção do texto), não `left`/`right` — RTL-safe.
/// Em LTR: `end` = direita (default), `start` = esquerda. A sheet cresce da borda
/// ancorada em direção ao centro; a handle e o botão de fechar ficam na borda
/// **interna** (a que aponta para o centro).
enum AppSheetSide {
  /// Início da linha (esquerda em LTR).
  start,

  /// Fim da linha (direita em LTR). Default.
  end,
}

/// Snap em que um [AppSideSheet] **abre**.
///
/// Os snaps de largura são calculados no layout (dependem da largura disponível
/// e do `edgePeek`), então a escolha aqui é por posição na escala, não por
/// fração: `rest` é o primeiro snap (40% em telas largas, 70% em estreitas) e
/// `full` é o último (a largura toda menos o respiro da borda oposta).
enum AppSideSheetSnap {
  /// Menor snap disponível. Default — a sheet entra como painel lateral.
  rest,

  /// O snap INTERMEDIÁRIO (o segundo degrau), quando ele existe; em telas
  /// estreitas, onde só há um degrau antes do full, cai no `rest`.
  ///
  /// É o tamanho de um formulário: `rest` é estreito demais para dois campos
  /// lado a lado, e `full` cobre a lista que ficou atrás — o usuário perde a
  /// referência de onde estava.
  medium,

  /// Maior snap. Para conteúdo que precisa da largura toda (duas colunas,
  /// tabelas largas): abrir no `rest` obrigaria o usuário a arrastar antes de
  /// conseguir ler.
  full,
}
