import 'package:flutter/widgets.dart';

import '../../molecules/headers/app_close_side.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_style.dart';
import 'bottom_sheet_engine.dart';
import 'bottom_sheet_route.dart';
import 'bottom_sheet_surface.dart';

/// Painel flutuante ancorado na base — um **card destacado** (margem em L/R/base,
/// sem encostar nas bordas, cantos arredondados) que sobe até o conteúdo caber
/// (teto [maxHeightFraction], com scroll interno acima disso).
///
/// Este widget é a **superfície** no estado de repouso (útil em previews/goldens
/// e como corpo estático). Para exibir como modal use [showAppBottomSheet] —
/// que ainda pode torná-lo **arrastável** (`draggable: true`): ele então tem dois
/// estados, o repouso e a **page** (edge-to-edge), com morph fluido entre eles.
///
/// Eixos globais: **estilo** ([AppStyle]) com default próprio `elevated` (sombra;
/// `outlined` troca por borda) — overlays não seguem o global; **forma**
/// ([AppRadiusMode]) controla os cantos.
final class AppBottomSheet extends StatelessWidget {
  /// Cria um [AppBottomSheet] (superfície de repouso).
  const AppBottomSheet({
    required this.child,
    this.footer,
    this.title,
    this.titleWidget,
    this.showHandle = false,
    this.showCloseButton = true,
    this.onCloseButton,
    this.closeSide = AppSheetCloseSide.end,
    this.maxHeightFraction = kBottomSheetRestMaxFraction,
    this.style,
    this.glass,
    this.radiusMode,
    super.key,
  });

  /// Corpo do painel (não-rolável; a sheet cuida da rolagem).
  final Widget child;

  /// Rodapé fixo opcional (ex.: `AppButtonsFooter`).
  final Widget? footer;

  /// Título opcional, centralizado na barra de topo.
  final String? title;

  /// Escape hatch para o título que NÃO é só texto (ícone ao lado, título
  /// reativo). Aqui a tipografia é de quem passa — a barra não a impõe.
  final Widget? titleWidget;

  /// Mostra a handle (grabber) centralizada no topo. Default `false`.
  ///
  /// No card estático ela é só affordance visual; no modal arrastável
  /// ([showAppBottomSheet] com `draggable: true`) é o convite ao arraste.
  final bool showHandle;

  /// Mostra o botão de fechar (chip circular). Default `true`.
  final bool showCloseButton;

  /// Ação do botão de fechar. `null` → fecha (pop).
  final VoidCallback? onCloseButton;

  /// Lado do botão de fechar. Default `end` (direita em LTR).
  final AppSheetCloseSide closeSide;

  /// Fração máxima da altura da tela no repouso (teto do content-fit). Default 0.65.
  final double maxHeightFraction;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. `null` resolve
  /// para `elevated`.
  final AppStyle? style;

  /// Override do eixo glass só desta sheet. `null` segue o global
  /// (`theme.glassTheme.enabled`).
  final bool? glass;

  /// Override do modo de forma dos cantos. `null` segue o global.
  final AppRadiusMode? radiusMode;

  @override
  Widget build(BuildContext context) => BottomSheetSurface(
    pageProgress: 0,
    contentMaxHeightFraction: maxHeightFraction,
    title: title,
    titleWidget: titleWidget,
    footer: footer,
    showHandle: showHandle,
    showCloseButton: showCloseButton,
    onCloseButton: onCloseButton,
    closeSide: closeSide,
    style: style,
    glass: glass,
    radiusMode: radiusMode,
    child: child,
  );
}

/// Exibe um [AppBottomSheet] como modal deslizante (base da tela).
///
/// Por padrão é um **card estático** (`draggable: false`) que sobe até o conteúdo
/// caber (teto [maxHeightFraction]); dispensa por barrier/botão de fechar.
///
/// Com [draggable] `true` ganha dois estados — repouso ⇄ **page** (edge-to-edge)
/// — com arraste coordenado ao scroll e morph fluido:
/// - arrastar para cima: repouso → page;
/// - arrastar para baixo: no repouso, **fecha**; na page, volta ao repouso —
///   a menos que [alwaysClose] seja `true` (aí a page também fecha).
///
/// [showHandle] mostra a grabber no topo — nos **dois** modos: no card
/// estático é affordance visual; no arrastável, o convite ao arraste.
///
/// [onCloseButton] customiza o botão de fechar (`null` = pop). [onClose] dispara
/// quando a sheet fecha por **qualquer** meio (arraste/barrier/botão). Retorna o
/// valor passado a [Navigator.pop] ou `null`.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  Widget? footer,
  String? title,
  Widget? titleWidget,
  bool draggable = false,
  bool alwaysClose = false,
  bool showHandle = false,
  bool showCloseButton = true,
  VoidCallback? onCloseButton,
  AppSheetCloseSide closeSide = AppSheetCloseSide.end,
  VoidCallback? onClose,
  double maxHeightFraction = kBottomSheetRestMaxFraction,
  bool isDismissible = true,
  bool useRootNavigator = false,
  AppStyle? style,
  bool? glass,
  AppRadiusMode? radiusMode,
}) {
  final Future<T?> result = pushBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    useRootNavigator: useRootNavigator,
    contentBuilder: (BuildContext context) => draggable
        ? BottomSheetEngine(
            mode: BottomSheetMode.draggable,
            alwaysClose: alwaysClose,
            showHandle: showHandle,
            title: title,
            titleWidget: titleWidget,
            footer: footer,
            showCloseButton: showCloseButton,
            onCloseButton: onCloseButton,
            closeSide: closeSide,
            maxHeightFraction: maxHeightFraction,
            style: style,
            glass: glass,
            radiusMode: radiusMode,
            child: child,
          )
        : Align(
            alignment: Alignment.bottomCenter,
            child: AppBottomSheet(
              title: title,
              titleWidget: titleWidget,
              footer: footer,
              showHandle: showHandle,
              showCloseButton: showCloseButton,
              onCloseButton: onCloseButton,
              closeSide: closeSide,
              maxHeightFraction: maxHeightFraction,
              style: style,
              glass: glass,
              radiusMode: radiusMode,
              child: child,
            ),
          ),
  );
  return onClose == null ? result : result.whenComplete(onClose);
}
