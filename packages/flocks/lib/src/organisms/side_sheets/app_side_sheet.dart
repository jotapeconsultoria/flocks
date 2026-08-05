import 'package:flutter/widgets.dart';

import '../../molecules/headers/app_close_side.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_style.dart';
import 'app_sheet_side.dart';
import 'side_sheet_engine.dart';
import 'side_sheet_route.dart';
import 'side_sheet_surface.dart';

/// Painel lateral flutuante — o **irmão horizontal** do `AppBottomSheet`. Um card
/// destacado (margem + cantos arredondados) que desliza da borda [side] (default
/// `end` = direita) e cresce em direção ao centro. Segue as mesmas regras: eixos
/// style/radius/motion, botão de fechar (chip), e opcionalmente arrastável.
///
/// Este widget é a **superfície de repouso** (útil em previews/goldens). Para
/// exibir como modal (barrier + slide lateral + resize) use [showAppSideSheet].
final class AppSideSheet extends StatelessWidget {
  /// Cria um [AppSideSheet] (superfície de repouso).
  const AppSideSheet({
    required this.child,
    this.side = AppSheetSide.end,
    this.title,
    this.titleWidget,
    this.footer,
    this.showHandle = false,
    this.showCloseButton = true,
    this.closeSide,
    this.onCloseButton,
    this.style,
    this.glass,
    this.radiusMode,
    super.key,
  });

  /// Corpo (rola sozinho na vertical).
  final Widget child;

  /// Borda ancorada. Default `end` (direita em LTR).
  final AppSheetSide side;

  /// Título opcional, centralizado na barra de topo.
  final String? title;

  /// Escape hatch para o título que NÃO é só texto (ícone ao lado, título
  /// reativo). Aqui a tipografia é de quem passa — a barra não a impõe.
  final Widget? titleWidget;

  /// Rodapé fixo opcional.
  final Widget? footer;

  /// Mostra a grabber vertical na borda interna.
  final bool showHandle;

  /// Mostra o botão de fechar (chip circular). Default `true`.
  final bool showCloseButton;

  /// Lado do botão de fechar. `null` → canto **interno** conforme [side].
  final AppSheetCloseSide? closeSide;

  /// Ação do botão de fechar. `null` → fecha (pop).
  final VoidCallback? onCloseButton;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. `null` resolve
  /// para `elevated`.
  final AppStyle? style;

  /// Override do eixo glass só desta sheet. `null` segue o global
  /// (`theme.glassTheme.enabled`).
  final bool? glass;

  /// Override do modo de forma dos cantos. `null` segue o global.
  final AppRadiusMode? radiusMode;

  @override
  Widget build(BuildContext context) => SideSheetSurface(
    fullProgress: 0,
    side: side,
    title: title,
    titleWidget: titleWidget,
    footer: footer,
    showHandle: showHandle,
    showCloseButton: showCloseButton,
    closeSide: closeSide,
    onCloseButton: onCloseButton,
    style: style,
    glass: glass,
    radiusMode: radiusMode,
    child: child,
  );
}

/// Exibe um [AppSideSheet] como modal (slide da borda [side] + barrier).
///
/// Por padrão é um **painel fixo** (`draggable: false`) no 1º snap (40% em telas
/// largas `> 1024`, 70% em estreitas); dispensa por barrier/botão de fechar.
///
/// Com [draggable] `true`, arraste a borda interna para redimensionar entre os
/// snaps (`40% → 70% → full` no wide; `70% → full` no narrow) — arrastar pra
/// borda ancorada além do menor snap **fecha**; da full, volta ao snap menor (ou
/// fecha, se [alwaysClose]). [showHandle] mostra a grabber. [onClose] dispara ao
/// fechar por qualquer meio.
Future<T?> showAppSideSheet<T>({
  required BuildContext context,
  required Widget child,
  AppSheetSide side = AppSheetSide.end,
  String? title,
  Widget? titleWidget,
  Widget? footer,
  bool draggable = false,
  bool alwaysClose = false,
  bool showHandle = false,
  bool showCloseButton = true,
  AppSheetCloseSide? closeSide,
  VoidCallback? onCloseButton,
  VoidCallback? onClose,
  double mediumFraction = kSideSheetMediumFraction,
  double largeFraction = kSideSheetLargeFraction,
  double edgePeek = kSideSheetEdgePeek,
  AppSideSheetSnap initialSnap = AppSideSheetSnap.rest,
  bool isDismissible = true,
  bool useRootNavigator = false,
  AppStyle? style,
  bool? glass,
  AppRadiusMode? radiusMode,
}) {
  final Future<T?> result = pushSideSheet<T>(
    context: context,
    side: side,
    isDismissible: isDismissible,
    useRootNavigator: useRootNavigator,
    contentBuilder: (BuildContext context) => SideSheetEngine(
      side: side,
      draggable: draggable,
      alwaysClose: alwaysClose,
      showHandle: showHandle,
      showCloseButton: showCloseButton,
      closeSide: closeSide,
      onCloseButton: onCloseButton,
      title: title,
      titleWidget: titleWidget,
      footer: footer,
      mediumFraction: mediumFraction,
      largeFraction: largeFraction,
      edgePeek: edgePeek,
      initialSnap: initialSnap,
      style: style,
      glass: glass,
      radiusMode: radiusMode,
      child: child,
    ),
  );
  return onClose == null ? result : result.whenComplete(onClose);
}
