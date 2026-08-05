import 'package:flutter/widgets.dart';

import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/app_overlay_bounds.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import 'app_sheet_side.dart';

/// Comportamento comum das rotas de side sheet — slide lateral (da borda
/// ancorada), barrier rotulado e reduce-motion, sem dependência de Material.
/// Espelha `_BottomSheetRouteBehavior`; a única diferença é o offset de entrada
/// (lateral em vez de por baixo).
mixin _SideSheetRouteBehavior<T> on ModalRoute<T> {
  /// Constrói o conteúdo da rota (já dentro do `AppOverlayScope`).
  WidgetBuilder get builder;

  /// Se o toque no barrier fecha a sheet.
  bool get isDismissible;

  /// Offset inicial do slide (`Offset(±1, 0)` conforme a borda ancorada).
  Offset get beginOffset;

  /// Região a que a rota se confina; `null` = tela toda. Ver [AppOverlayBounds].
  AppOverlayBoundsHandle? get bounds;

  /// O barrier acompanha o confinamento: escurecer a tela inteira enquanto o
  /// painel ocupa só o cartão diria que o resto está bloqueado — e não está.
  @override
  Widget buildModalBarrier() =>
      AppConfinedToBounds(bounds: bounds, child: super.buildModalBarrier());

  @override
  bool get barrierDismissible => isDismissible;

  @override
  String get barrierLabel => 'Fechar';

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => AppDurations.slow;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => AppSemantics.modalRoute(child: builder(context));

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (!AppMotion.enabled(context)) {
      return AppConfinedToBounds(bounds: bounds, child: child);
    }
    // O confinamento fica POR FORA do slide: assim o deslocamento é uma fração
    // da região, e a sheet entra pela borda do cartão em vez de atravessar a
    // tela inteira até chegar nele.
    return AppConfinedToBounds(
      bounds: bounds,
      child: SlideTransition(
        position: Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(
          CurvedAnimation(
            parent: animation,
            curve: AppCurves.emphasized,
            reverseCurve: AppCurves.accelerate,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Rota do side sheet **comum** (painel lateral sobreposto): um [PopupRoute],
/// porque a sheet é um overlay e não uma página da pilha.
class SideSheetRoute<T> extends PopupRoute<T> with _SideSheetRouteBehavior<T> {
  /// Cria uma [SideSheetRoute].
  SideSheetRoute({
    required this.builder,
    required this.barrierColor,
    required this.beginOffset,
    this.bounds,
    this.isDismissible = true,
  });

  @override
  final WidgetBuilder builder;

  @override
  final Color barrierColor;

  @override
  final Offset beginOffset;

  @override
  final AppOverlayBoundsHandle? bounds;

  @override
  final bool isDismissible;
}

/// Rota do side sheet **page** (a sheet É uma página da pilha, persistente).
///
/// É um [PageRoute] — e não um [PopupRoute] — de propósito: um destino roteado
/// de primeira classe (persiste, mantém estado pesado, e pode hospedar um sheet
/// efêmero por cima). Espelha `BottomSheetPageRoute`, mas **sem**
/// `delegatedTransition`: um side sheet é um painel lateral com o conteúdo de
/// baixo visível AO LADO — encolher/deslocar a tela de baixo (o efeito iOS do
/// bottom-sheet-page) a descolaria e revelaria fundo nas bordas. O `barrierColor`
/// já separa os planos.
class SideSheetPageRoute<T> extends PageRoute<T>
    with _SideSheetRouteBehavior<T> {
  /// Cria uma [SideSheetPageRoute].
  SideSheetPageRoute({
    required this.builder,
    required this.barrierColor,
    required this.beginOffset,
    this.bounds,
    this.isDismissible = true,
  });

  @override
  final WidgetBuilder builder;

  @override
  final Color barrierColor;

  @override
  final Offset beginOffset;

  @override
  final AppOverlayBoundsHandle? bounds;

  @override
  final bool isDismissible;

  // Painel translúcido por cima do conteúdo vivo: nada de snapshot.
  @override
  bool get allowSnapshotting => false;
}

/// Empurra uma [SideSheetRoute] (ou [SideSheetPageRoute] quando [asPage]),
/// capturando tema/text-scale no trigger e reprovendo-os via `AppOverlayScope`
/// (igual `pushBottomSheet`). O offset de entrada vem da borda ancorada
/// geométrica (`side` × direção do texto). [asPage] decide a CLASSE da rota
/// (PageRoute vs PopupRoute) — ver [SideSheetPageRoute].
Future<T?> pushSideSheet<T>({
  required BuildContext context,
  required AppSheetSide side,
  required bool isDismissible,
  required bool useRootNavigator,
  required WidgetBuilder contentBuilder,
  bool asPage = false,
}) {
  final AppThemeData theme = AppTheme.of(context);
  final TextScaler textScaler = MediaQuery.textScalerOf(context);
  // Capturado no GATILHO, não na rota: a rota nasce acima do shell e não
  // enxergaria a região. É o contexto de quem abriu que define o alcance.
  final AppOverlayBoundsHandle? bounds = AppOverlayBounds.maybeOf(context);
  final NavigatorState navigator = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );
  final bool anchoredRight =
      (side == AppSheetSide.end) ==
      (Directionality.of(context) == TextDirection.ltr);
  final Offset begin = anchoredRight ? const Offset(1, 0) : const Offset(-1, 0);
  final Color barrier = theme.colorTheme.neutralPrimary.barrier();

  Widget content(BuildContext context) => AppOverlayScope(
    theme: theme,
    textScaler: textScaler,
    child: Builder(builder: contentBuilder),
  );

  return navigator.push<T>(
    asPage
        ? SideSheetPageRoute<T>(
            isDismissible: isDismissible,
            barrierColor: barrier,
            beginOffset: begin,
            bounds: bounds,
            builder: content,
          )
        : SideSheetRoute<T>(
            isDismissible: isDismissible,
            barrierColor: barrier,
            beginOffset: begin,
            bounds: bounds,
            builder: content,
          ),
  );
}
