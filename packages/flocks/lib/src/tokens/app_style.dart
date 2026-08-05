/// Eixo global de **estilo de container** do Flocks.
///
/// Trata a APARÊNCIA da caixa de um componente — borda, fundo e sombra — como um
/// eixo ortogonal à cor (papel semântico) e ao radius. É temável globalmente
/// (`AppThemeData.styleTheme`) e sobrescrevível por componente (parâmetro
/// `style:`), espelhando o eixo de radius (`AppRadiusTheme`).
///
/// O `style` é um **tratamento aditivo**: NÃO troca a cor de fundo própria do
/// componente (o fill semântico de um badge, botão, alert…), apenas acrescenta
/// borda/superfície/sombra conforme a tabela. Para componentes preenchidos, a
/// cor de fundo pode ser trocada pelo parâmetro `background`.
///
/// | style      | componente preenchido por padrão   | componente transparente/ghost   |
/// |------------|------------------------------------|---------------------------------|
/// | [filled]   | fundo próprio, sem borda, sem sombra| `surfaceContainer`, sem borda   |
/// | [outlined] | fundo próprio + borda `outline`    | transparente + borda `outline`  |
/// | [elevated] | fundo próprio + sombra (sem borda)  | `surfaceContainer` + sombra     |
///
/// O tratamento **glass** (frosted / "Liquid Glass") NÃO é um valor de estilo: é
/// um eixo aditivo à parte (`AppGlassTheme`), aplicado só à allow-list de
/// superfícies flutuantes via `AppGlassSurface`. Ver `AppGlass`.
enum AppStyle {
  /// Sem borda; apenas uma superfície de contraste no fundo. **Padrão** do
  /// design system.
  filled,

  /// Borda fina (`outline`) em todos os componentes; sem sombra.
  outlined,

  /// Sem borda; apenas fundo + sombra simétrica (elevação real, distribuída em
  /// todos os lados). A sombra faz a separação — não há borda.
  elevated,
}
