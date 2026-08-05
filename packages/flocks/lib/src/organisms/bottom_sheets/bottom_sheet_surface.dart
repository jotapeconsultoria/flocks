import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../atoms/glass/app_glass_surface.dart';
import '../../molecules/headers/app_close_side.dart';
import '../../molecules/headers/app_surface_top_bar.dart';
import '../../theme/theme.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';

/// Margem do card destacado (repouso) em L/R/base — some (→0) ao virar page.
const double kBottomSheetDetachedMargin = AppSpacings.s12;

/// Respiro fixo no topo da page (abaixo do safe-area) mostrando a tela de baixo.
const double kBottomSheetTopPeek = AppSpacings.s12;

/// Fração máxima da altura da tela que o repouso pode ocupar (teto do content-fit).
const double kBottomSheetRestMaxFraction = 0.65;

/// Superfície **não-glass** das sheets (bottom e side): fundo (fill + sombra) +
/// corpo clipado sobre `surface` + **borda em foreground**.
///
/// A borda do `outlined` precisa ser desenhada **por cima** do corpo: o
/// `DecoratedBox` pinta a borda ATRÁS do filho, e o `ColoredBox(surface)` interno
/// (que preenche até a borda) a cobriria — some no `outlined`. Um segundo
/// `DecoratedBox` em `DecorationPosition.foreground` desenha só a borda por cima.
Widget sheetDecoratedSurface(
  AppStyle style, {
  required bool isDark,
  required BorderRadius radius,
  required AppColorTheme colors,
  required Widget body,
}) {
  final StyleDecoration d = resolveStyleDecoration(
    style: style,
    isDark: isDark,
    outline: colors.outline,
    surfaceContainer: colors.surfaceContainer,
  );
  Widget surface = DecoratedBox(
    decoration: BoxDecoration(
      color: d.color,
      boxShadow: d.boxShadow,
      borderRadius: radius,
    ),
    child: ClipRRect(
      borderRadius: radius,
      // Overlay opaco (não-glass) = `surfaceContainer` (como AppDialog/AppMenu),
      // inclusive no `outlined` (uma sheet não pode ser translúcida).
      child: ColoredBox(color: colors.surfaceContainer, child: body),
    ),
  );
  if (d.border != null) {
    surface = DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(border: d.border, borderRadius: radius),
      child: surface,
    );
  }
  return surface;
}

/// A **superfície pura** de um bottom sheet, parametrizada por [pageProgress]
/// (`0` = card destacado no repouso; `1` = page edge-to-edge). É função pura do
/// progresso: margens, cantos e safe-area interpolam entre os dois extremos, o
/// que faz o "morph" ser só interpolação e torna os goldens determinísticos.
///
/// Não é exportada no baril do pacote — é usada por [AppBottomSheet],
/// [AppBottomSheetPage] e pelo engine de arraste.
class BottomSheetSurface extends StatelessWidget {
  /// Cria uma [BottomSheetSurface].
  const BottomSheetSurface({
    required this.pageProgress,
    required this.child,
    this.footer,
    this.title,
    this.titleWidget,
    this.showHandle = false,
    this.showCloseButton = true,
    this.closeSide = AppSheetCloseSide.end,
    this.onCloseButton,
    this.style,
    this.glass,
    this.radiusMode,
    this.scrollController,
    this.contentMaxHeightFraction = kBottomSheetRestMaxFraction,
    super.key,
  });

  /// `0` (card no repouso) → `1` (page edge-to-edge). Fora de [0,1] é clampado.
  final double pageProgress;

  /// Corpo (não-rolável; a superfície cuida da rolagem).
  final Widget child;

  /// Rodapé fixo opcional (ex.: `AppButtonsFooter`), acima do safe-area.
  final Widget? footer;

  /// Título opcional, centralizado na barra de topo.
  final String? title;

  /// Escape hatch para o título que NÃO é só texto (ícone ao lado, título
  /// reativo). Aqui a tipografia é de quem passa — a barra não a impõe.
  final Widget? titleWidget;

  /// Mostra a handle (grabber) centralizada no topo.
  final bool showHandle;

  /// Mostra o botão de fechar (chip circular). Default `true`.
  final bool showCloseButton;

  /// Lado do botão de fechar. Default `end` (direita em LTR).
  final AppSheetCloseSide closeSide;

  /// Ação do botão de fechar. `null` → dá pop na rota.
  final VoidCallback? onCloseButton;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. `null` resolve
  /// para `elevated`.
  final AppStyle? style;

  /// Override do eixo glass só desta sheet. `null` segue o global
  /// (`theme.glassTheme.enabled`).
  final bool? glass;

  /// Override do modo de forma dos cantos. `null` segue o global.
  final AppRadiusMode? radiusMode;

  /// Quando != null, o corpo usa um `CustomScrollView` ligado a este controller
  /// (modo fill: page/arrastável, com header fixado); nesse modo o [child] deve
  /// ser **não-rolável** (a sheet é a dona da rolagem — coordena com o arraste).
  /// Quando `null`, o corpo é content-fit (card estático não-arrastável) e o
  /// [child] cuida da **própria** rolagem (ex.: `AppBottomSheetContent`).
  final ScrollController? scrollController;

  /// Teto de altura (fração da tela) do modo content-fit. Ignorado no modo fill.
  final double contentMaxHeightFraction;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final MediaQueryData mq = MediaQuery.of(context);
    final bool isDark = theme.brightness == AppBrightness.dark;
    // Overlay flutuante: default próprio `elevated` (não segue o global).
    final AppStyle s = style ?? AppStyle.elevated;
    // Eixo glass (aditivo): override por instância ou o global da marca.
    final bool glassOn = glass ?? theme.glassTheme.enabled;
    final double p = pageProgress.clamp(0.0, 1.0);

    // Escala de raio própria das superfícies grandes: `reto` = 0; `redondo`/
    // `padrao` = raio dedicado; `circular` = raio bem pronunciado (sem virar
    // oval que corta o conteúdo). Ver `surfaceCornerRadius`.
    final double rTop = theme.radiusTheme.surfaceCornerRadius(radiusMode);
    final double rBottom = lerpDouble(rTop, 0, p)!;
    final BorderRadius br = BorderRadius.only(
      topLeft: Radius.circular(rTop),
      topRight: Radius.circular(rTop),
      bottomLeft: Radius.circular(rBottom),
      bottomRight: Radius.circular(rBottom),
    );

    final double sideM = lerpDouble(kBottomSheetDetachedMargin, 0, p)!;
    final double bottomM = lerpDouble(kBottomSheetDetachedMargin, 0, p)!;
    // O safe-area inferior só entra à medida que a sheet vira page (edge-to-edge);
    // no repouso o card já flutua acima da borda (margem inferior).
    final double bottomSafe = lerpDouble(0, mq.viewPadding.bottom, p)!;

    final Widget topBar = AppSurfaceTopBar(
      showHandle: showHandle,
      showCloseButton: showCloseButton,
      closeSide: closeSide,
      onCloseButton: onCloseButton,
      title: title,
      titleWidget: titleWidget,
      // Glass: barra de topo transparente para a sheet ler como um único painel
      // de vidro (senão um `surface` opaco cobriria o blur atrás do header).
      transparent: glassOn,
    );

    final Widget? paddedFooter = footer == null
        ? null
        : Padding(
            padding: EdgeInsets.only(bottom: bottomSafe),
            child: footer,
          );

    final ScrollController? sc = scrollController;
    final Widget body = sc != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: CustomScrollView(
                  controller: sc,
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _TopBarDelegate(topBar),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: footer == null ? bottomSafe : 0,
                        ),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
              ?paddedFooter,
            ],
          )
        : ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: mq.size.height * contentMaxHeightFraction,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                topBar,
                // O child cuida da própria rolagem (contrato do modo content-fit).
                Flexible(child: child),
                ?paddedFooter,
              ],
            ),
          );

    // Glass: sem o `ColoredBox(surface)` opaco (mataria o blur) — o vidro traz o
    // tint translúcido. O `br` anima por frame no arraste → o `BackdropFilter`
    // re-rasteriza a cada frame (aceitável no Impeller; ver plano).
    final Widget surface = glassOn
        ? AppGlassSurface(borderRadius: br, child: body)
        : sheetDecoratedSurface(
            s,
            isDark: isDark,
            radius: br,
            colors: colors,
            body: body,
          );

    return Padding(
      padding: EdgeInsets.only(left: sideM, right: sideM, bottom: bottomM),
      child: surface,
    );
  }
}

/// Delegate do header fixado (a barra de topo) no `CustomScrollView` do modo
/// fill — extent fixo, para não encolher com o scroll.
class _TopBarDelegate extends SliverPersistentHeaderDelegate {
  _TopBarDelegate(this.topBar);

  final Widget topBar;

  @override
  double get minExtent => kAppSurfaceTopBarHeight;

  @override
  double get maxExtent => kAppSurfaceTopBarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => topBar;

  @override
  bool shouldRebuild(_TopBarDelegate oldDelegate) =>
      oldDelegate.topBar != topBar;
}
