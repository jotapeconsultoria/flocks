import 'package:flutter/widgets.dart';

import '../../foundation/app_overlay_bar.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';

/// Layout de página consistente do design system: `header` · `child` · `footer`
/// sobre a superfície do tema (`surface`), com `SafeArea` opcional.
///
/// É um **organismo de layout** (estrutural): não participa dos eixos de estilo
/// ([AppStyle]) nem de forma (raio) — só posiciona as três regiões e pinta o
/// fundo com a cor `surface` do tema. Os slots [header]/[footer] aceitam
/// qualquer `Widget` (tipicamente um `AppSimpleHeader`/`AppPrimaryHeader` e um
/// `AppButtonsFooter`/`AppNavigationFooter`).
///
/// **Sobreposição (glass / efeito Notes):** quando o header/footer é um
/// [AppOverlayBar] com `overlaysContent(context)` (eixo glass ligado), o scaffold
/// o tira do fluxo em coluna e o **sobrepõe** ao conteúdo (dentro do `Stack`, por
/// cima do `child`, para o `BackdropFilter` amostrar o conteúdo rolando).
/// Barras não-glass seguem no fluxo em coluna, exatamente como antes.
///
/// Como a altura reservada (`resolveBarExtent`) chega ao [child] depende de
/// [contentUnderBars] — e é a diferença entre ter e não ter o efeito Notes:
///
/// - `false` (**default**): a reserva vira um `Padding` em volta do [child]. É
///   simples e não exige nada da página, mas encolhe o *viewport*: o conteúdo
///   rolável começa e termina exatamente nas arestas das barras e **nunca passa
///   por baixo delas**. O vidro acaba desfocando só o fundo chapado da página —
///   por isso uma barra glass sobre conteúdo assim lê como um véu opaco.
/// - `true`: a reserva é publicada em **`MediaQuery.padding`** e o [child] ocupa
///   a área inteira. Um `BoxScrollView` (`ListView`/`GridView`) com `padding`
///   **nulo** consome a reserva como padding de *conteúdo*: o primeiro item
///   nasce abaixo da barra e os seguintes deslizam por baixo dela.
///
/// [contentUnderBars] é opt-in porque exige cooperação da página: um
/// `SingleChildScrollView`/`CustomScrollView` **não** consome `MediaQuery`
/// sozinho (só `BoxScrollView` consome), e um [child] não-rolável precisa de
/// `SafeArea`. Ligar sem ajustar a página esconde o topo do conteúdo sob a
/// barra. Em ambos os casos a receita é a mesma: somar
/// `MediaQuery.paddingOf(context)` ao padding que a página já usa.
///
/// ```dart
/// AppScaffold(
///   header: const AppSimpleHeader(child: AppText('Veículos')),
///   footer: AppButtonsFooter(primary: saveButton),
///   child: content,
/// )
/// ```
final class AppScaffold extends StatelessWidget {
  /// Cria um [AppScaffold].
  const AppScaffold({
    required this.child,
    this.contentUnderBars = false,
    this.fadeFooter = false,
    this.fadeHeader = false,
    this.floatingAction,
    this.floatingActionAlignment = AlignmentDirectional.bottomEnd,
    this.footer,
    this.header,
    this.safeAreaOnBottom = false,
    this.safeAreaOnTop = false,
    super.key,
  });

  /// Conteúdo principal (ocupa o espaço entre header e footer).
  final Widget child;

  /// Ação flutuante (tipicamente um `AppFloatingButton`), sobreposta ao
  /// conteúdo. `null` = sem FAB. Alinhada por [floatingActionAlignment] com
  /// inset de borda `AppSpacings.s16`.
  final Widget? floatingAction;

  /// Alinhamento do [floatingAction] na área de conteúdo. Default
  /// [AlignmentDirectional.bottomEnd] (canto inferior, respeitando RTL).
  final AlignmentGeometry floatingActionAlignment;

  /// Suaviza o encontro do conteúdo com o rodapé ou com a borda inferior.
  final bool fadeFooter;

  /// Suaviza o encontro do conteúdo rolável com o cabeçalho.
  final bool fadeHeader;

  /// Se o [child] ocupa a área **inteira** (passando por baixo das barras
  /// sobrepostas) em vez de ser recuado por um `Padding`. Ver a doc da classe:
  /// é o que habilita o efeito Notes, e exige que a página consuma
  /// `MediaQuery.paddingOf(context)` no padding do seu scrollable.
  final bool contentUnderBars;

  /// Rodapé opcional (ex.: `AppButtonsFooter`). Fixo na base.
  final Widget? footer;

  /// Cabeçalho opcional (ex.: `AppSimpleHeader`). Fixo no topo.
  final Widget? header;

  /// Aplica `SafeArea` na base. Default `false`.
  final bool safeAreaOnBottom;

  /// Aplica `SafeArea` no topo. Default `false`.
  final bool safeAreaOnTop;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);

    // Barras que se sobrepõem ao conteúdo (glass): saem do fluxo em coluna e
    // vão para o `Stack`, por cima do `child`.
    final Widget? headerWidget = header;
    final Widget? footerWidget = footer;
    final AppOverlayBar? overlayHeader =
        headerWidget is AppOverlayBar && headerWidget.overlaysContent(context)
        ? headerWidget
        : null;
    final AppOverlayBar? overlayFooter =
        footerWidget is AppOverlayBar && footerWidget.overlaysContent(context)
        ? footerWidget
        : null;

    // Reserva das barras sobrepostas. Ou como Padding externo (default), ou
    // publicada em MediaQuery.padding — ver a doc da classe e [contentUnderBars].
    final double topPad = overlayHeader?.resolveBarExtent(context) ?? 0;
    final double bottomPad = overlayFooter?.resolveBarExtent(context) ?? 0;
    Widget content = child;
    if (topPad > 0 || bottomPad > 0) {
      if (contentUnderBars) {
        final MediaQueryData media = MediaQuery.of(context);
        content = MediaQuery(
          // A barra já embute a safe-area no próprio corpo, então a reserva
          // SUBSTITUI o inset do lado dela (não soma — senão reserva duas vezes).
          data: media.copyWith(
            padding: media.padding.copyWith(
              top: topPad > 0 ? topPad : media.padding.top,
              bottom: bottomPad > 0 ? bottomPad : media.padding.bottom,
            ),
          ),
          child: child,
        );
      } else {
        content = Padding(
          padding: EdgeInsets.only(top: topPad, bottom: bottomPad),
          child: child,
        );
      }
    }

    return SafeArea(
      top: safeAreaOnTop,
      bottom: safeAreaOnBottom,
      left: false,
      right: false,
      child: DecoratedBox(
        decoration: BoxDecoration(color: theme.colorTheme.surface),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  if (overlayHeader == null) ?header,
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        content,
                        // Fades só para barras NÃO sobrepostas (o glass já tem
                        // o próprio gradiente).
                        if (fadeHeader &&
                            header != null &&
                            overlayHeader == null)
                          const Align(
                            alignment: Alignment.topCenter,
                            child: _AppScaffoldFade(edge: _AppScaffoldEdge.top),
                          ),
                        if (fadeFooter &&
                            footer != null &&
                            overlayFooter == null)
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: _AppScaffoldFade(
                              edge: _AppScaffoldEdge.bottom,
                            ),
                          ),
                        // Barras sobrepostas: DEPOIS do `content` para o blur
                        // amostrar o conteúdo rolando.
                        if (overlayHeader != null)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: overlayHeader,
                          ),
                        if (overlayFooter != null)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: overlayFooter,
                          ),
                        if (floatingAction != null)
                          Align(
                            alignment: floatingActionAlignment,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.all(
                                AppSpacings.s16,
                              ),
                              child: floatingAction!,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (overlayFooter == null) ?footer,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _AppScaffoldEdge { bottom, top }

final class _AppScaffoldFade extends StatelessWidget {
  const _AppScaffoldFade({required this.edge});

  final _AppScaffoldEdge edge;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final surface = theme.colorTheme.surface;
    final transparentSurface = surface.withValues(alpha: 0);
    final colors = edge == _AppScaffoldEdge.top
        ? <Color>[surface, transparentSurface]
        : <Color>[transparentSurface, surface];

    return IgnorePointer(
      child: SizedBox(
        height: AppSpacings.s16,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: colors,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}
