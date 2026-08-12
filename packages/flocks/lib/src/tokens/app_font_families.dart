/// As famílias tipográficas empacotadas com o Flocks.
///
/// As três são SIL Open Font License 1.1, com o texto da licença ao lado do
/// arquivo em `assets/fonts/`. Uma família nova só entra aqui se puder ser
/// redistribuída — ver o comentário da seção `fonts:` do `pubspec.yaml`.
///
/// A marca escolhe qual das duas de texto usar (ou uma fonte própria) por
/// [AppBrandTypography]; o padrão do pacote é a [poppins] em toda a escala. A
/// [ibmPlexMono] fica de fora dessa escolha de propósito: ela é a família de
/// código de `AppContentStyle`, e deixá-la variar por marca faria o mesmo
/// trecho de código mudar de forma entre uma marca e outra.
sealed class AppFontFamilies {
  /// A Poppins — geométrica, padrão do pacote em toda a escala tipográfica.
  static const String poppins = 'Poppins';

  /// A Space Grotesk — display da marca `flocks`. Não é padrão do pacote.
  static const String spaceGrotesk = 'SpaceGrotesk';

  /// A IBM Plex Mono — a monoespaçada de `AppContentStyle.code`.
  ///
  /// Empacotada nos pesos 400 e 600, que são exatamente os que o pacote pede:
  /// 400 em todo bloco e código inline, 600 nos placeholders de `AppApiPath`.
  static const String ibmPlexMono = 'IBMPlexMono';
}
