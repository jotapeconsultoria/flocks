import 'package:flutter/widgets.dart';

import '../../molecules/headers/app_close_side.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_style.dart';
import 'app_sheet_side.dart';
import 'side_sheet_engine.dart';
import 'side_sheet_route.dart';
import 'side_sheet_surface.dart';

/// Versão **page** do [AppSideSheet]: o mesmo painel lateral flutuante, mas
/// exibido por uma [SideSheetPageRoute] (um [PageRoute] persistente) em vez de
/// uma rota efêmera. Use quando os detalhes hospedados forem uma "página" de
/// primeira classe — pesada, com estado próprio, que deve persistir e poder
/// hospedar um sheet efêmero por cima (ex.: a Ficha do Veículo).
///
/// Este widget é a **superfície de repouso** (útil em previews/goldens). Para
/// exibir como page-route (barrier + slide lateral + resize) use
/// [showAppSideSheetPage].
///
/// Visualmente é idêntico ao [AppSideSheet] (o "page" muda apenas a CLASSE da
/// rota, não a aparência do painel).
final class AppSideSheetPage extends StatelessWidget {
  /// Cria um [AppSideSheetPage] (superfície de repouso).
  const AppSideSheetPage({
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

/// Exibe um [AppSideSheetPage] como **page-route** (slide da borda [side] +
/// barrier). Igual a `showAppSideSheet`, mas a sheet é uma [SideSheetPageRoute]
/// (um [PageRoute] persistente) em vez de uma [SideSheetRoute] efêmera.
///
/// Reusa o mesmo [SideSheetEngine] — logo drag/snaps (`40% → 70% → full`),
/// handle, closeSide, title e footer funcionam igual. [onClose] dispara ao fechar
/// por qualquer meio.
Future<T?> showAppSideSheetPage<T>({
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
    asPage: true,
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
