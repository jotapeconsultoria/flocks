import 'package:flutter/widgets.dart';

import '../../foundation/a11y/app_semantics.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';

/// Quanto a tela de baixo encolhe ao ser coberta por uma sheet **page**
/// (`1 - escala`). Espelha a apresentação modal do iOS. Tunável.
const double kSheetBelowScaleFactor = 0.0835;

/// Deslocamento vertical da tela de baixo (fração da altura) no efeito iOS.
const double kSheetBelowSlideFactor = 0.07;

/// Opacidade do véu escuro sobre a tela de baixo — separa os dois planos.
const double kSheetBelowScrimOpacity = 0.10;

/// Transição **delegada** aplicada à rota de BAIXO quando uma sheet page sobe:
/// ela encolhe, desce um pouco, arredonda os cantos e escurece — o "cartão"
/// que fica espiando no topo (apresentação modal do iOS).
///
/// É passada ao Flutter via [ModalRoute.delegatedTransition]; a rota de baixo a
/// aplica em si mesma (`canTransitionTo` já contempla rotas com transição
/// delegada). Precisa ser uma função **estável** (top-level), porque o framework
/// compara as referências para decidir se adota a transição.
Widget? appSheetBelowTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  bool allowSnapshotting,
  Widget? child,
) {
  if (child == null) return child;
  // Reduce-motion: a tela de baixo fica parada (sem escala/slide/scrim).
  if (!AppMotion.enabled(context)) return child;

  final AppThemeData theme = AppTheme.of(context);
  final CurvedAnimation curved = CurvedAnimation(
    parent: secondaryAnimation,
    curve: AppCurves.emphasized,
    reverseCurve: AppCurves.accelerate,
  );
  final Animation<double> scale = curved.drive(
    Tween<double>(begin: 1.0, end: 1.0 - kSheetBelowScaleFactor),
  );
  final Animation<Offset> slide = curved.drive(
    Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, kSheetBelowSlideFactor),
    ),
  );
  final Animation<double> scrim = curved.drive(
    Tween<double>(begin: 0, end: kSheetBelowScrimOpacity),
  );
  // O raio dos cantos acompanha a escala de superfície do DS (a tela de baixo
  // vira um cartão com a mesma linguagem da sheet que a cobre).
  final Animation<BorderRadiusGeometry> radius = curved.drive(
    Tween<BorderRadiusGeometry>(
      begin: BorderRadius.zero,
      end: BorderRadius.circular(theme.radiusTheme.surfaceCornerRadius()),
    ),
  );
  curved.dispose();

  return SlideTransition(
    position: slide,
    child: ScaleTransition(
      scale: scale,
      alignment: Alignment.topCenter,
      filterQuality: FilterQuality.medium,
      child: AnimatedBuilder(
        animation: secondaryAnimation,
        child: child,
        builder: (BuildContext context, Widget? inner) => ClipRRect(
          borderRadius: radius.value.resolve(Directionality.of(context)),
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              ?inner,
              // Véu que separa os planos; não intercepta toque.
              IgnorePointer(
                child: Opacity(
                  opacity: scrim.value,
                  child: ColoredBox(
                    color: theme.colorTheme.neutralPrimary.s900,
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Comportamento comum das rotas de bottom sheet — slide-up pela base, barrier
/// rotulado e reduce-motion, sem dependência de Material.
mixin _BottomSheetRouteBehavior<T> on ModalRoute<T> {
  /// Constrói o conteúdo da rota (já dentro do `AppOverlayScope`).
  WidgetBuilder get builder;

  /// Se o toque no barrier fecha a sheet.
  bool get isDismissible;

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
    // Reduce-motion: aparece sem o slide.
    if (!AppMotion.enabled(context)) return child;
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: animation,
              curve: AppCurves.emphasized,
              reverseCurve: AppCurves.accelerate,
            ),
          ),
      child: child,
    );
  }
}

/// Rota do bottom sheet **comum** (card sobreposto): um [PopupRoute], porque a
/// sheet é um overlay e não uma página da pilha.
class BottomSheetRoute<T> extends PopupRoute<T>
    with _BottomSheetRouteBehavior<T> {
  /// Cria uma [BottomSheetRoute].
  BottomSheetRoute({
    required this.builder,
    required this.barrierColor,
    this.isDismissible = true,
  });

  @override
  final WidgetBuilder builder;

  @override
  final Color barrierColor;

  @override
  final bool isDismissible;
}

/// Rota do bottom sheet **page** (a sheet É uma página apresentada por baixo).
///
/// É um [PageRoute] — e não um [PopupRoute] — de propósito: a rota de baixo só
/// aceita a transição delegada de um `PageRoute`
/// (`PageRoute.canTransitionTo => nextRoute is PageRoute`). É a mesma escolha do
/// `CupertinoSheetRoute` do Flutter. Sem isso o efeito iOS na tela de baixo
/// simplesmente não roda.
class BottomSheetPageRoute<T> extends PageRoute<T>
    with _BottomSheetRouteBehavior<T> {
  /// Cria uma [BottomSheetPageRoute].
  BottomSheetPageRoute({
    required this.builder,
    required this.barrierColor,
    this.isDismissible = true,
    this.scaleBelow = true,
  });

  @override
  final WidgetBuilder builder;

  @override
  final Color barrierColor;

  @override
  final bool isDismissible;

  /// Aplica o efeito iOS na tela de BAIXO (encolher + descer + arredondar +
  /// escurecer).
  final bool scaleBelow;

  // A sheet é translúcida por cima da tela de baixo: nada de snapshot.
  @override
  bool get allowSnapshotting => false;

  @override
  DelegatedTransitionBuilder? get delegatedTransition =>
      scaleBelow ? appSheetBelowTransition : null;
}

/// Empurra uma [BottomSheetRoute] capturando tema/text-scale no trigger e
/// reprovendo-os na rota via `AppOverlayScope` (o Overlay do root vive acima do
/// tema — senão `AppTheme.of` estoura no conteúdo). [contentBuilder] recebe o
/// contexto já com o overlay scope.
Future<T?> pushBottomSheet<T>({
  required BuildContext context,
  required bool isDismissible,
  required bool useRootNavigator,
  required WidgetBuilder contentBuilder,
  bool asPage = false,
  bool scaleBelow = false,
}) {
  final AppThemeData theme = AppTheme.of(context);
  final TextScaler textScaler = MediaQuery.textScalerOf(context);
  final NavigatorState navigator = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );

  Widget content(BuildContext context) => AppOverlayScope(
    theme: theme,
    textScaler: textScaler,
    child: Builder(builder: contentBuilder),
  );
  final Color barrier = theme.colorTheme.neutralPrimary.barrier();

  // `asPage` decide a CLASSE da rota (PageRoute vs PopupRoute) — ver
  // [BottomSheetPageRoute] sobre por que a sheet page precisa ser um PageRoute.
  return navigator.push<T>(
    asPage
        ? BottomSheetPageRoute<T>(
            isDismissible: isDismissible,
            scaleBelow: scaleBelow,
            barrierColor: barrier,
            builder: content,
          )
        : BottomSheetRoute<T>(
            isDismissible: isDismissible,
            barrierColor: barrier,
            builder: content,
          ),
  );
}
