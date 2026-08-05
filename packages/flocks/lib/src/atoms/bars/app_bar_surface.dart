import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../foundation/app_overlay_bar.dart' show BarEdge;
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../glass/app_glass_surface.dart';
import '../glass/app_progressive_blur.dart';

/// Fundo compartilhado de **barras** (headers/footers) para os três [AppStyle]
/// + o eixo glass, com semântica **própria de barra** (diferente de cards):
///
/// - `filled`  → fundo sólido ([fill] ?? `surface`).
/// - `outlined`→ fundo + borda 1px **só na aresta interna** ([contentEdge]).
/// - `elevated`→ fundo + sombra **só na aresta interna, na cor do fill** (esfuma
///   a barra no conteúdo — não é sombra preta de profundidade).
/// - [glass]   → um de **dois** tratamentos, conforme [floating] (ver abaixo),
///   com fallback opaco `elevated` quando `AppTransparency` está reduzido.
///   Ortogonal a [style] (o glass sobrepõe o tratamento de [style]).
///
/// ## Os dois vidros: band e flutuante
///
/// A diferença não é cosmética — as duas formas têm quinas diferentes:
///
/// - **Band** ([floating] = `false`): colada na borda da tela, sem quina
///   interna. Precisa **dissolver** no conteúdo, então usa [AppProgressiveBlur]
///   (rampa de sigma) + tint em gradiente com piso de contraste. Sem rim e sem
///   sheen: uma band não tem quina para o vidro brilhar. É o efeito iOS Notes.
/// - **Flutuante** ([floating] = `true`): cápsula destacada (nav footer, busca),
///   com quina em volta inteira. Não tem "aresta externa" para dissolver — pede
///   vidro **uniforme** com rim, sheen e sombra ambiente, que é exatamente o
///   [AppGlassSurface]. É a barra do Instagram.
///
/// [floating] é explícito e não inferido de [borderRadius]: uma band pode ter
/// cantos arredondados (ex.: `AppButtonsFooter` com `style: page`) e ainda assim
/// estar colada na base.
///
/// A faixa de safe-area externa ([outerSafeAreaInset] = status bar no header /
/// home indicator no footer) é **embutida** aqui: a barra reserva e pinta essa
/// faixa (para a band glass, é o platô sólido do gradiente).
///
/// Átomo **interno** — não exportado no baril (igual `AppGlassSurface`); os
/// headers/footers o consomem por import relativo.
@internal
class AppBarSurface extends StatelessWidget {
  /// Cria uma [AppBarSurface].
  const AppBarSurface({
    required this.style,
    required this.contentEdge,
    required this.child,
    this.glass = false,
    this.floating = false,
    this.borderRadius,
    this.outerSafeAreaInset = 0,
    this.fill,
    super.key,
  });

  /// Tratamento de container do render **não-glass**.
  final AppStyle style;

  /// Eixo glass da barra. Quando `true`, sobrepõe [style] com o frost (ou o
  /// fallback opaco `elevated` sob transparência reduzida).
  final bool glass;

  /// Se a barra é uma **cápsula destacada** (margens em volta) em vez de uma
  /// band colada na borda da tela. Só afeta o render glass — ver a doc da
  /// classe. Explícito de propósito: não dá para inferir de [borderRadius].
  final bool floating;

  /// Aresta que encosta no conteúdo (costura).
  final BarEdge contentEdge;

  /// Conteúdo da barra (já dimensionado; a faixa externa é adicionada aqui).
  final Widget child;

  /// `null` = band quadrada full-bleed; setado = barra flutuante arredondada.
  final BorderRadius? borderRadius;

  /// Faixa de safe-area externa (status bar / home indicator) reservada e
  /// pintada pela barra. Pré-computada pelo chamador (`viewPaddingOf`).
  final double outerSafeAreaInset;

  /// Cor de preenchimento. `null` = `colors.surface`.
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final Color fillColor = fill ?? colors.surface;

    // A faixa externa (status bar / home indicator) é reservada aqui: o header
    // (contentEdge=bottom) reserva no topo; o footer (top) reserva embaixo.
    final Widget banded = outerSafeAreaInset <= 0
        ? child
        : Padding(
            padding: contentEdge == BarEdge.bottom
                ? EdgeInsets.only(top: outerSafeAreaInset)
                : EdgeInsets.only(bottom: outerSafeAreaInset),
            child: child,
          );

    // Eixo glass sobrepõe o tratamento de `style` (com fallback opaco `elevated`
    // sob transparência reduzida). Senão, o `style` governa.
    if (glass) {
      if (!AppTransparency.enabled(context)) {
        return _elevated(fillColor, isDark, banded);
      }
      return floating
          ? _glassFloating(banded)
          : _glassBand(colors, isDark, banded);
    }
    return switch (style) {
      AppStyle.filled => _filled(fillColor, banded),
      AppStyle.outlined => _outlined(fillColor, colors.outline, banded),
      AppStyle.elevated => _elevated(fillColor, isDark, banded),
    };
  }

  Widget _clip(Widget w) => borderRadius == null
      ? w
      : ClipRRect(borderRadius: borderRadius!, child: w);

  Widget _filled(Color fillColor, Widget banded) => DecoratedBox(
    decoration: BoxDecoration(color: fillColor, borderRadius: borderRadius),
    child: _clip(banded),
  );

  Widget _outlined(Color fillColor, Color outline, Widget banded) {
    // Borda de 1 lado exige cantos quadrados; barra flutuante arredondada cai
    // para borda completa. Desenhada em foreground para não ser coberta.
    final BoxBorder border = borderRadius == null
        ? Border(
            top: contentEdge == BarEdge.top
                ? BorderSide(color: outline, width: AppStrokes.s)
                : BorderSide.none,
            bottom: contentEdge == BarEdge.bottom
                ? BorderSide(color: outline, width: AppStrokes.s)
                : BorderSide.none,
          )
        : Border.all(color: outline, width: AppStrokes.s);

    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(border: border, borderRadius: borderRadius),
      child: _filled(fillColor, banded),
    );
  }

  Widget _elevated(Color fillColor, bool isDark, Widget banded) {
    final BoxShadow shadow = _edgeShadow(fillColor, isDark);
    final Widget shadowed = DecoratedBox(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: borderRadius,
        boxShadow: <BoxShadow>[shadow],
      ),
      child: _clip(banded),
    );
    // Clipa a sombra para vazar SÓ pela aresta interna (não pelas outras).
    return ClipRect(
      clipper: _ContentEdgeShadowClipper(contentEdge, _kShadowBleed),
      child: shadowed,
    );
  }

  /// Vidro de **band** (full-bleed): dissolve no conteúdo.
  ///
  /// O que rampa é o **sigma** ([AppProgressiveBlur]), não só o tint — é a
  /// diferença entre dissolver e ter um retângulo de blur com corte seco na
  /// aresta interna. Sem rim e sem sheen (band não tem quina iluminada) e sem a
  /// sombra de aresta do `elevated`: ela é um segundo mecanismo de dissolução,
  /// competindo com a rampa e vazando fill para dentro do conteúdo.
  Widget _glassBand(AppColorTheme colors, bool isDark, Widget banded) {
    final Color tint = colors.glassTint(isDark: isDark);
    final Color tintFloor = tint.withValues(alpha: AppGlass.barTintFloorAlpha);
    final BorderRadius clipR = borderRadius ?? BorderRadius.zero;

    // Gradiente vertical: tint cheio na aresta EXTERNA → piso de contraste sob
    // o conteúdo da barra → transparente na costura.
    final bool header = contentEdge == BarEdge.bottom;
    final Alignment solidEnd = header
        ? Alignment.topCenter
        : Alignment.bottomCenter;
    final Alignment fadeEnd = header
        ? Alignment.bottomCenter
        : Alignment.topCenter;

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: clipR,
        child: AppProgressiveBlur(
          strongAtTop: header,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double h =
                  constraints.maxHeight.isFinite && constraints.maxHeight > 0
                  ? constraints.maxHeight
                  : 1.0;
              // Platô do tint cheio = a faixa de safe-area externa. Nunca pode
              // passar do início do piso, senão os stops saem fora de ordem.
              final double plateau = (outerSafeAreaInset / h).clamp(
                0.0,
                AppGlass.barTintFloorStop,
              );
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: solidEnd,
                    end: fadeEnd,
                    // Mesma cor com alpha decrescente (nunca outra cor) evita
                    // passar por cinza no meio do gradiente.
                    colors: <Color>[
                      tint,
                      tint,
                      tintFloor,
                      tint.withValues(alpha: 0),
                    ],
                    stops: <double>[0, plateau, AppGlass.barTintFloorStop, 1],
                  ),
                ),
                child: banded,
              );
            },
          ),
        ),
      ),
    );
  }

  /// Vidro de **cápsula flutuante**: uniforme, com rim/sheen/sombra ambiente.
  ///
  /// Delega ao [AppGlassSurface] — a cápsula é vidro pelas mesmas regras de
  /// dialog/sheet/menu. É aqui que o rim mora: no vidro é a **estrutura** que
  /// ganha a quina brilhante, nunca o seletor lá dentro.
  Widget _glassFloating(Widget banded) => AppGlassSurface(
    borderRadius: borderRadius ?? BorderRadius.zero,
    child: banded,
  );

  /// Sombra suave **na cor do fill** empurrada para a aresta interna.
  BoxShadow _edgeShadow(Color fillColor, bool isDark) => BoxShadow(
    color: fillColor.withValues(alpha: isDark ? 0.6 : 0.5),
    offset: Offset(0, contentEdge == BarEdge.bottom ? 6 : -6),
    blurRadius: 12,
    spreadRadius: -4,
  );
}

/// Folga do clip da sombra além da aresta interna.
const double _kShadowBleed = 24.0;

/// Clipa para a sombra vazar **só** pela aresta que encosta no conteúdo.
class _ContentEdgeShadowClipper extends CustomClipper<Rect> {
  const _ContentEdgeShadowClipper(this.edge, this.bleed);

  final BarEdge edge;
  final double bleed;

  @override
  Rect getClip(Size size) => edge == BarEdge.bottom
      ? Rect.fromLTRB(0, 0, size.width, size.height + bleed)
      : Rect.fromLTRB(0, -bleed, size.width, size.height);

  @override
  bool shouldReclip(_ContentEdgeShadowClipper oldClipper) =>
      oldClipper.edge != edge || oldClipper.bleed != bleed;
}
