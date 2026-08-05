import 'package:flutter/widgets.dart';

import '../../molecules/headers/app_close_side.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_style.dart';
import 'bottom_sheet_engine.dart';
import 'bottom_sheet_route.dart';
import 'bottom_sheet_surface.dart';

/// Página modal estilo iOS: sobe até logo abaixo do safe-area do topo, deixando
/// um respiro (peek) que mostra a tela de baixo por trás dos cantos de cima
/// arredondados. É **edge-to-edge** em left/right/bottom (sem margem) e pode ser
/// fechada pelo botão de fechar, pelo barrier ou por **swipe para baixo**.
///
/// Este widget é a **superfície** (útil em previews/goldens). Para exibir como
/// modal (barrier + slide-up + swipe-to-dismiss), use [showAppBottomSheetPage].
///
/// Eixos globais: **estilo** ([AppStyle]) com default próprio `elevated` (sombra;
/// `outlined` troca por borda) — overlays não seguem o global; **forma**
/// ([AppRadiusMode]) controla os cantos de cima.
///
/// **Não participa do eixo glass:** apesar do nome "sheet", isto é uma **página**
/// (edge-to-edge, cobre a tela), não uma superfície flutuante — não há o que
/// desfocar atrás. O vidro fica com o [AppBottomSheet] (card no repouso) e com os
/// demais overlays.
final class AppBottomSheetPage extends StatelessWidget {
  /// Cria um [AppBottomSheetPage].
  const AppBottomSheetPage({
    required this.child,
    this.title,
    this.titleWidget,
    this.footer,
    this.showCloseButton = true,
    this.onCloseButton,
    this.closeSide = AppSheetCloseSide.end,
    this.style,
    this.radiusMode,
    super.key,
  });

  /// Corpo da página (não-rolável; a página cuida da rolagem).
  final Widget child;

  /// Título opcional, centralizado na barra de topo.
  final String? title;

  /// Escape hatch para o título que NÃO é só texto (ícone ao lado, título
  /// reativo). Aqui a tipografia é de quem passa — a barra não a impõe.
  final Widget? titleWidget;

  /// Rodapé fixo opcional (acima do safe-area inferior).
  final Widget? footer;

  /// Mostra o botão de fechar (chip circular). Default `true`.
  final bool showCloseButton;

  /// Ação do botão de fechar. `null` → fecha a página (pop).
  final VoidCallback? onCloseButton;

  /// Lado do botão de fechar. Default `end` (direita em LTR).
  final AppSheetCloseSide closeSide;

  /// Tratamento de container ([AppStyle]). `null` resolve para `elevated`.
  final AppStyle? style;

  /// Override do modo de forma dos cantos de cima. `null` segue o global.
  final AppRadiusMode? radiusMode;

  @override
  Widget build(BuildContext context) => BottomSheetSurface(
    pageProgress: 1,
    contentMaxHeightFraction: 1,
    title: title,
    titleWidget: titleWidget,
    footer: footer,
    showCloseButton: showCloseButton,
    onCloseButton: onCloseButton,
    closeSide: closeSide,
    style: style,
    // Página, não superfície flutuante: nunca vidro (e `false` explícito para
    // não herdar o eixo glass global da marca).
    glass: false,
    radiusMode: radiusMode,
    child: child,
  );
}

/// Exibe um [AppBottomSheetPage] como modal (slide-up + barrier + swipe para
/// baixo). Retorna o valor passado a [Navigator.pop] ou `null` se fechado.
///
/// Com [useRootNavigator] `true`, sobe no navigator raiz (cobre a bottom
/// navigation). O roteamento fica no app; o DS não depende de router.
Future<T?> showAppBottomSheetPage<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  Widget? titleWidget,
  Widget? footer,
  bool showCloseButton = true,
  VoidCallback? onCloseButton,
  AppSheetCloseSide closeSide = AppSheetCloseSide.end,
  double topPeek = kBottomSheetTopPeek,
  bool isDismissible = true,
  bool useRootNavigator = false,
  AppStyle? style,
  AppRadiusMode? radiusMode,
  bool scaleBelow = true,
}) {
  return pushBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    useRootNavigator: useRootNavigator,
    asPage: true,
    scaleBelow: scaleBelow,
    contentBuilder: (BuildContext context) => BottomSheetEngine(
      mode: BottomSheetMode.page,
      title: title,
      titleWidget: titleWidget,
      footer: footer,
      showCloseButton: showCloseButton,
      onCloseButton: onCloseButton,
      closeSide: closeSide,
      topPeek: topPeek,
      style: style,
      radiusMode: radiusMode,
      child: child,
    ),
  );
}
