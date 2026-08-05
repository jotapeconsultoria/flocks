import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Primitivo interno que realiza o tratamento **frosted glass** (Liquid Glass
/// nível 1) — a peça que os componentes da allow-list delegam quando o eixo glass
/// (`AppGlassTheme`) está ligado.
///
/// Existe porque glass **não cabe num `BoxDecoration`**: o "leitoso" vem de um
/// `BackdropFilter(ImageFilter.blur)`, uma camada de widget que amostra o que
/// está pintado **atrás** da superfície. A pilha é:
///
/// ```
/// RepaintBoundary                       // isola o blur caro dos irmãos
///  └ DecoratedBox(sombra, fill transparente)   // (A) sombra FORA do clip
///    └ ClipRRect(borderRadius)
///      └ BackdropFilter(blur)                   // frost do fundo
///        └ DecoratedBox(tint)                   // (B) véu translúcido
///          └ DecoratedBox(sheen)                // (C) brilho no topo
///            └ Stack[ conteúdo, rim hairline ]  // (D) borda como overlay interno
/// ```
///
/// A sombra fica fora do `ClipRRect` (senão o clip a comeria); a borda (rim) vai
/// como overlay **dentro** do clip, para ler como a quina brilhante do vidro. Os
/// três pedaços de `BoxDecoration` (tint, rim, sombra) são computados a partir dos
/// getters `glass*` do tema + `AppElevation.symmetricShadows`; só a cor/sigma
/// variam por tema.
///
/// **Acessibilidade:** quando a transparência é reduzida (`AppTransparency`), NÃO
/// instancia `BackdropFilter` — cai para uma superfície opaca `elevated`
/// (`surfaceContainer` + sombra), preservando o contraste AA do DS.
///
/// **Não é exportada no baril** — é um detalhe de implementação das superfícies
/// (`AppOverlayCard`, `AppDialog`, `BottomSheetSurface`, `AppMenu`…), não um
/// átomo de uso direto.
@internal
class AppGlassSurface extends StatelessWidget {
  /// Cria uma [AppGlassSurface].
  const AppGlassSurface({
    required this.borderRadius,
    required this.child,
    this.padding,
    super.key,
  });

  /// Raio dos cantos (aceita cantos assimétricos, ex.: o morph do bottom sheet).
  /// Aplicado ao clip, à sombra externa e ao rim.
  final BorderRadius borderRadius;

  /// Padding interno opcional (aplicado ao [child], dentro do vidro).
  final EdgeInsetsGeometry? padding;

  /// Conteúdo sobre o vidro.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final Widget content = padding == null
        ? child
        : Padding(padding: padding!, child: child);

    // Fallback opaco (reduzir transparência / alto contraste): sem BackdropFilter,
    // superfície `elevated` — mantém a leitura de "flutuante" e o contraste do DS.
    if (!AppTransparency.enabled(context)) {
      return DecoratedBox(
        decoration: styleBoxDecoration(
          style: AppStyle.elevated,
          isDark: isDark,
          radius: borderRadius,
          outline: colors.outline,
          surfaceContainer: colors.surfaceContainer,
        ),
        child: ClipRRect(borderRadius: borderRadius, child: content),
      );
    }

    // Pedaços do glass que SÃO BoxDecoration (tint, rim, sombra), computados
    // direto dos getters `glass*` do tema — o blur é a camada do wrapper.
    final Color tint = colors.glassTint(isDark: isDark);
    final Border rim = Border.all(
      color: colors.glassBorder(isDark: isDark),
      width: AppStrokes.xs,
    );
    final List<BoxShadow> shadow = AppElevation.symmetricShadows(isDark);

    final Color sheenTop = colors.glassHighlight(isDark: isDark);
    final Gradient sheen = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      // Interpola no MESMO branco (alpha→0) para não passar por cinza no meio.
      colors: <Color>[sheenTop, sheenTop.withValues(alpha: 0)],
      stops: const <double>[0, AppGlass.sheenStop],
    );

    return RepaintBoundary(
      child: DecoratedBox(
        // (A) só sombra + forma; fill transparente para o blur/tint aparecerem.
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: shadow,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            // Desfoca E re-satura o fundo: sem a saturação, o blur dessatura
            // as cores de trás e o vidro lê como um véu cinza.
            filter: AppGlass.backdropFilter(),
            child: DecoratedBox(
              // (B) véu translúcido sobre o fundo desfocado.
              decoration: BoxDecoration(color: tint),
              child: DecoratedBox(
                // (C) sheen: brilho no topo do vidro.
                decoration: BoxDecoration(gradient: sheen),
                child: Stack(
                  children: <Widget>[
                    content,
                    // (D) rim hairline como overlay interno (quina do vidro).
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: rim,
                            borderRadius: borderRadius,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
