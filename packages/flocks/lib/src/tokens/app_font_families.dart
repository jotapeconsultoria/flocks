/// As famílias tipográficas empacotadas com o Flocks.
///
/// Ambas são SIL Open Font License 1.1, com o texto da licença ao lado do
/// arquivo em `assets/fonts/`. Uma família nova só entra aqui se puder ser
/// redistribuída — ver o comentário da seção `fonts:` do `pubspec.yaml`.
///
/// A marca escolhe quais destas usar (ou uma fonte própria) por
/// [AppBrandTypography]; o padrão do pacote é a [poppins] em toda a escala.
sealed class AppFontFamilies {
  /// A Poppins — geométrica, padrão do pacote em toda a escala tipográfica.
  static const String poppins = 'Poppins';

  /// A Space Grotesk — display da marca `flocks`. Não é padrão do pacote.
  static const String spaceGrotesk = 'SpaceGrotesk';
}
