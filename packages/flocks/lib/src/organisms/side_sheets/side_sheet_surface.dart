import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../atoms/glass/app_glass_surface.dart';
import '../../atoms/surface/app_scroll_edge_fade.dart';
import '../../molecules/headers/app_close_side.dart';
import '../../molecules/headers/app_surface_top_bar.dart';
import '../../theme/theme.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../shell/app_shell.dart' show AppShellContentScope;
import '../bottom_sheets/bottom_sheet_surface.dart'
    show kBottomSheetDetachedMargin, kBottomSheetTopPeek, sheetDecoratedSurface;
import 'app_sheet_side.dart';

/// 1º snap (largura) em telas largas (`> AppDevice.tablet.breakpoint`).
const double kSideSheetMediumFraction = 0.40;

/// 1º snap em telas estreitas / 2º snap em telas largas.
const double kSideSheetLargeFraction = 0.70;

/// Respiro na borda OPOSTA (safe-area + peek) que o `full` deixa — barrier tocável.
const double kSideSheetEdgePeek = kBottomSheetTopPeek;

/// Largura da área de arraste (gutter) na borda interna, alinhada à handle.
///
/// 24px: alvo confortável para um redimensionamento (o padrão de mercado é bem
/// menor) sem transformar em faixa morta um pedaço grande da sheet — com 48 o
/// respiro interno ficava enorme e só de um lado (revisão P1r9).
const double kSideSheetHandleHitWidth = AppSpacings.s24;

/// Fração do menor snap abaixo da qual soltar o arraste fecha a sheet.
const double kSideSheetDismissFactor = 0.5;

/// A **superfície pura** de um side sheet, parametrizada por [fullProgress]
/// (`0` = card destacado no snap atual; `1` = edge-to-edge full) e [side]. É
/// função pura do progresso — margens, cantos e safe-area interpolam — o que faz
/// o "morph" ser só interpolação e torna os goldens determinísticos.
///
/// Altura cheia: o [child] cuida da **própria** rolagem (vertical), independente
/// do resize (horizontal). Não é exportada no baril — usada por [AppSideSheet] e
/// pelo engine.
class SideSheetSurface extends StatelessWidget {
  /// Cria uma [SideSheetSurface].
  const SideSheetSurface({
    required this.fullProgress,
    required this.side,
    required this.child,
    this.footer,
    this.title,
    this.titleWidget,
    this.showHandle = false,
    this.showCloseButton = true,
    this.closeSide,
    this.onCloseButton,
    this.style,
    this.glass,
    this.radiusMode,
    this.gutterInset = 0,
    super.key,
  });

  /// `0` (card no snap) → `1` (edge-to-edge full). Fora de [0,1] é clampado.
  final double fullProgress;

  /// Borda ancorada (start/end).
  final AppSheetSide side;

  /// Corpo (rola sozinho na vertical).
  final Widget child;

  /// Rodapé fixo opcional.
  final Widget? footer;

  /// Título opcional, centralizado na barra de topo.
  final String? title;

  /// Escape hatch para o título que NÃO é só texto (ícone ao lado, título
  /// reativo). Aqui a tipografia é de quem passa — a barra não a impõe.
  final Widget? titleWidget;

  /// Mostra a grabber vertical na borda interna.
  final bool showHandle;

  /// Mostra o botão de fechar (chip circular). Default `true`.
  final bool showCloseButton;

  /// Lado do botão de fechar. `null` → canto **interno** conforme [side].
  final AppSheetCloseSide? closeSide;

  /// Ação do botão de fechar. `null` → pop.
  final VoidCallback? onCloseButton;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. `null` resolve
  /// para `elevated`.
  final AppStyle? style;

  /// Override do eixo glass só desta sheet. `null` segue o global
  /// (`theme.glassTheme.enabled`).
  final bool? glass;

  /// Override do modo de forma dos cantos. `null` segue o global.
  final AppRadiusMode? radiusMode;

  /// Faixa reservada no conteúdo para a gutter de arraste da borda interna.
  /// `0` quando a sheet não é redimensionável (não há gutter).
  final double gutterInset;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final MediaQueryData mq = MediaQuery.of(context);
    final bool isDark = theme.brightness == AppBrightness.dark;
    final AppStyle s = style ?? AppStyle.elevated;
    final bool glassOn = glass ?? theme.glassTheme.enabled;
    final double p = fullProgress.clamp(0.0, 1.0);
    final bool end = side == AppSheetSide.end;

    // Botão de fechar: default no canto interno (end→start, start→end).
    final AppSheetCloseSide effectiveCloseSide =
        closeSide ?? (end ? AppSheetCloseSide.start : AppSheetCloseSide.end);

    // A gutter de arraste mora na borda INTERNA e é opaca ao ponteiro. Quando o
    // "X" fica desse lado, ele nasce EMBAIXO dela e perde parte do alvo de
    // clique — então só ELE se afasta o bastante para escapar da faixa; a barra
    // segue de borda a borda (revisão P1r11).
    final AppSheetCloseSide gutterSide = end
        ? AppSheetCloseSide.start
        : AppSheetCloseSide.end;
    final double closeClearance =
        effectiveCloseSide == gutterSide &&
            gutterInset > kAppSurfaceTopBarCloseInset
        ? gutterInset - kAppSurfaceTopBarCloseInset
        : 0;

    // Raio próprio da sheet (mesma escala das superfícies grandes). Cantos
    // INTERNOS (borda do peek) ficam arredondados; cantos EXTERNOS (borda
    // ancorada) achatam no full. Ver `surfaceCornerRadius`.
    final double r = theme.radiusTheme.surfaceCornerRadius(radiusMode);
    final double rInner = r;
    final double rOuter = lerpDouble(r, 0, p)!;
    final TextDirection dir = Directionality.of(context);
    // Para `end`: interno = start, externo = end. Para `start`: invertido.
    // Resolvido para físico (styleBoxDecoration/AppGlassSurface pedem BorderRadius).
    final BorderRadius br = BorderRadiusDirectional.only(
      topStart: Radius.circular(end ? rInner : rOuter),
      bottomStart: Radius.circular(end ? rInner : rOuter),
      topEnd: Radius.circular(end ? rOuter : rInner),
      bottomEnd: Radius.circular(end ? rOuter : rInner),
    ).resolve(dir);

    // Margem do card (todos os lados) → 0 no full.
    final double m = lerpDouble(kBottomSheetDetachedMargin, 0, p)!;

    // Safe-area entra como padding do CONTEÚDO à medida que vira full: topo/base
    // e a borda ancorada (a interna fica sobre o peek, sem safe).
    final bool anchoredRight = end == (dir == TextDirection.ltr);
    final double anchoredSafe = anchoredRight
        ? mq.viewPadding.right
        : mq.viewPadding.left;
    // Safe-area da borda ancorada: vale para TODA a coluna (topo, corpo e
    // rodapé) — nada pode ficar embaixo do notch.
    final EdgeInsetsDirectional safeHorizontal = EdgeInsetsDirectional.only(
      start: end ? 0 : lerpDouble(0, anchoredSafe, p)!,
      end: end ? lerpDouble(0, anchoredSafe, p)! : 0,
    );
    // A gutter de arraste tem alvo de toque grande (acessibilidade) e mora na
    // borda INTERNA, por cima do conteúdo. Sem reservar essa faixa, ela rouba o
    // clique de tudo que estiver embaixo — e o conteúdo não tem respiro
    // horizontal próprio para absorvê-la (revisão P1r9).
    // Respiro horizontal IGUAL dos dois lados — o conteúdo não pode nascer
    // colado numa borda e afastado da outra. Do lado interno ele também é o que
    // tira a gutter de cima do conteúdo, por isso acompanha a largura dela.
    //
    // É respiro do CONTEÚDO, e só dele: a barra de topo e o rodapé já têm o
    // recuo interno deles, e somar os dois empurrava o "X" e os botões para
    // dentro como se a sheet tivesse duas margens (revisão P1r11).
    final double sidePadding = gutterInset > 0 ? gutterInset : AppSpacings.s16;
    final EdgeInsetsDirectional horizontal = EdgeInsetsDirectional.only(
      start: safeHorizontal.start + sidePadding,
      end: safeHorizontal.end + sidePadding,
    );

    final Widget body = Padding(
      // Só o VERTICAL recua a coluna inteira. O respiro lateral é aplicado por
      // faixa, logo abaixo — ver a barra de rolagem.
      padding: EdgeInsets.only(
        top: lerpDouble(0, mq.viewPadding.top, p)!,
        bottom: lerpDouble(0, mq.viewPadding.bottom, p)!,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: safeHorizontal,
            child: AppSurfaceTopBar(
              showCloseButton: showCloseButton,
              closeSide: effectiveCloseSide,
              onCloseButton: onCloseButton,
              title: title,
              titleWidget: titleWidget,
              transparent: glassOn,
              closeClearance: closeClearance,
            ),
          ),
          // O child cuida da própria rolagem vertical. O véu tira o corte seco
          // do conteúdo contra a barra de topo e o rodapé fixos.
          //
          // `AppShellContentScope`: a sheet JÁ é a superfície. Sem isso, uma
          // página hospedada aqui pinta o próprio cartão por cima e aparece uma
          // borda cinza no meio da sheet (revisão P1r9).
          //
          // O respiro lateral vai por `MediaQuery.padding` em vez de um `Padding`
          // em volta: recuando a faixa inteira, recuava junto o VIEWPORT da
          // rolagem, e a barra de rolagem — que mora na borda do viewport —
          // aparecia flutuando longe da lateral da sheet. Publicada, ela é
          // consumida pelo `padding` do scrollable: o conteúdo respira, a barra
          // encosta na borda (revisão P1r10).
          Expanded(
            child: MediaQuery(
              data: mq.copyWith(
                padding: mq.padding.add(horizontal).resolve(dir),
              ),
              child: AppShellContentScope(
                child: AppScrollEdgeFade(child: child),
              ),
            ),
          ),
          // Rodapé de borda a borda (só a safe-area): o respiro interno é dele,
          // não da sheet — ver o comentário do `sidePadding`.
          if (footer case final Widget f)
            Padding(padding: safeHorizontal, child: f),
        ],
      ),
    );

    final Widget surface = glassOn
        ? AppGlassSurface(borderRadius: br, child: body)
        : sheetDecoratedSurface(
            s,
            isDark: isDark,
            radius: br,
            colors: colors,
            body: body,
          );

    // Grabber vertical na borda INTERNA (end→esquerda/start; start→direita/end).
    final AlignmentDirectional innerAlign = end
        ? AlignmentDirectional.centerStart
        : AlignmentDirectional.centerEnd;

    return Padding(
      padding: EdgeInsets.all(m),
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: surface),
          if (showHandle)
            Align(
              alignment: innerAlign,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: end ? AppSpacings.s8 : 0,
                  end: end ? 0 : AppSpacings.s8,
                ),
                child: SizedBox(
                  width: 4,
                  height: 32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.onSurface.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
