import 'dart:ui' show ColorFilter, ImageFilter;

/// Tokens numéricos do tratamento **glass** (frosted / "Liquid Glass" nível 1)
/// do Flocks.
///
/// Concentra as constantes do efeito num único lugar (igual `AppElevation`/
/// `AppStrokes`): o sigma do desfoque de fundo e os alphas que `AppColorTheme`
/// resolve em cores a partir da `surface`/branco (ver `AppColorTheme.glassTint`,
/// `glassHighlight`, `glassBorder`). O widget interno `AppGlassSurface` consome
/// [blurSigma]; as cores saem do tema para adaptar a claro/escuro e às marcas.
///
/// Glass **não** é um `BoxDecoration`: precisa de um `BackdropFilter` (camada de
/// widget) e também **não é um valor de `AppStyle`** — é um eixo aditivo próprio
/// (`AppGlassTheme`, ligado por marca). Os componentes da allow-list (overlays,
/// barras, FAB, Menu/Popover) delegam ao `AppGlassSurface` quando o eixo glass
/// está ligado; o resto continua no caminho barato de `styleBoxDecoration`.
sealed class AppGlass {
  /// Sigma do `ImageFilter.blur` do fundo (frost). Nível 1: moderado-alto —
  /// forte o suficiente para o "leitoso" do vidro sem estourar o custo de raster
  /// (o backdrop blur é a primitiva de superfície mais cara). Tunável.
  static const double blurSigma = 24.0;

  /// **Saturação** aplicada ao fundo desfocado (1 = neutro). O ingrediente que
  /// faz o vidro parecer vidro em vez de um véu cinza: o blur média as cores e as
  /// dessatura, então re-saturamos para as cores de trás "vazarem" pelo vidro.
  /// É o que permite manter o [tintAlphaLight] baixo sem o fundo sumir — quanto
  /// mais transparente o vidro, mais a saturação sustenta a leitura de "cor
  /// atravessando" (é assim que o vidro do iOS se mantém vivo com tint baixo).
  static const double saturation = 2.0;

  /// Alpha do **tint** translúcido (o `surfaceContainer` do tema — no claro,
  /// branco — pintado por cima do blur) no tema CLARO.
  ///
  /// Calibrado visualmente contra fundo colorido/ocupado (régua
  /// 0.42/0.32/0.24/0.16, referência: pasta da home do iOS): o critério é
  /// **reconhecer o que está atrás** sem perder a legibilidade do texto por cima.
  /// Só dá para ser tão baixo por causa da [saturation] — sem ela, este alpha
  /// deixaria o vidro lavado e sem cor.
  ///
  /// Cuidado ao baixar mais: o [highlightAlphaLight] EMPILHA por cima deste, e
  /// texto escuro sobre uma região escura do fundo começa a perder contraste (o
  /// iOS resolve isso com *vibrancy*, que o DS não tem).
  static const double tintAlphaLight = 0.24;

  /// Alpha do tint translúcido no escuro (o `surfaceContainer` escuro sobre o
  /// blur). Em paridade com o claro — mesma leitura de transparência nos dois
  /// temas.
  static const double tintAlphaDark = 0.24;

  /// Alpha do **sheen** (brilho branco no topo → transparente) no claro. Sutil de
  /// propósito: o sheen EMPILHA com o tint, então valor alto aqui reintroduz o
  /// véu branco que estamos tentando evitar.
  static const double highlightAlphaLight = 0.14;

  /// Alpha do sheen no escuro (mais sutil — o vidro escuro reflete menos).
  static const double highlightAlphaDark = 0.10;

  /// Alpha do **rim** (borda hairline branca, o brilho na quina do vidro) no
  /// claro. Traço em `AppStrokes.xs`. O rim pode ser vivo: é 1px, não veda o fundo.
  static const double borderAlphaLight = 0.55;

  /// Alpha do rim no escuro.
  static const double borderAlphaDark = 0.32;

  /// Ponto final do gradiente do sheen (fração da altura). O brilho é uma faixa
  /// no topo do vidro (quina iluminada), não uma lavagem sobre a superfície.
  static const double sheenStop = 0.35;

  // --------------------------------------------------------------------------
  // Barras (headers/footers) full-bleed — a "dissolução" estilo iOS Notes.
  //
  // Uma superfície flutuante (dialog, sheet, cápsula) tem quinas: o vidro
  // começa e termina, e o olho aceita um blur uniforme. Uma **band** colada na
  // borda da tela não tem a quina interna — ela precisa DISSOLVER no conteúdo.
  // Por isso a band rampa o **sigma** (ver `AppProgressiveBlur`) em vez de
  // rampar só o tint: tint decrescente sobre blur uniforme deixa o corte seco
  // do blur aparecendo, que é o que faz a barra ler como "um retângulo com
  // fill" em vez de vidro.
  // --------------------------------------------------------------------------

  /// Número de fatias da rampa de blur das bands (ver `AppProgressiveBlur`).
  ///
  /// Cada fatia é um `BackdropFilter.grouped` com o seu próprio sigma; sob um
  /// `BackdropGroup` todas amostram **um único** snapshot do backdrop, então o
  /// custo é ~1 pirâmide de blur, não [barBlurLayers]. Com 10 fatias o degrau
  /// entre vizinhas fica em ~2.4 de sigma — invisível sobre conteúdo já
  /// desfocado, e ainda mascarado pelo gradiente de tint por cima.
  static const int barBlurLayers = 10;

  /// **Piso de contraste** do tint da band: alpha mínimo mantido na região onde
  /// vivem o título e os ícones da própria barra.
  ///
  /// Sem ele o gradiente zeraria o tint exatamente sob o conteúdo da barra
  /// (a costura é logo abaixo do título), e texto escuro sobre um tile escuro
  /// passando por baixo perderia contraste. O iOS resolve isso com *vibrancy*,
  /// que o DS não tem — então seguramos um piso.
  static const double barTintFloorAlpha = 0.10;

  /// Fração da altura da band onde o piso ([barTintFloorAlpha]) começa a cair
  /// para zero. Colado na costura: os últimos ~18% dissolvem de vez, e o que
  /// segura a transição ali é a rampa de sigma, não o tint.
  static const double barTintFloorStop = 0.82;

  /// Matriz de saturação (preserva luminância) para [saturation].
  static List<double> _saturationMatrix(double s) {
    // Pesos de luminância ITU-R BT.709.
    const double lr = 0.2126, lg = 0.7152, lb = 0.0722;
    return <double>[
      lr + s * (1 - lr),
      lg * (1 - s),
      lb * (1 - s),
      0,
      0,
      lr * (1 - s),
      lg + s * (1 - lg),
      lb * (1 - s),
      0,
      0,
      lr * (1 - s),
      lg * (1 - s),
      lb + s * (1 - lb),
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  /// Filtro de backdrop do vidro: desfoca o fundo e **depois** re-satura o
  /// resultado. Fonte única — usado pelo `AppGlassSurface`, pelo `AppBarSurface`
  /// e pelo balão glass do `AppPopover`.
  ///
  /// [sigma] só é passado pelo `AppProgressiveBlur`, que precisa de um filtro
  /// por fatia da rampa; todo o resto usa o [blurSigma] padrão.
  static ImageFilter backdropFilter({double sigma = blurSigma}) =>
      ImageFilter.compose(
        outer: ColorFilter.matrix(_saturationMatrix(saturation)),
        inner: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      );
}
