import 'package:flutter/widgets.dart';

import '../../atoms/glass/app_glass_surface.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/app_overlay_bounds.dart';
import '../../molecules/headers/app_close_side.dart';
import '../../molecules/headers/app_surface_top_bar.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';

/// Card central de um dialog do design system (a superfície flutuante em si).
///
/// É apenas a **superfície**: uma barra de topo, um [child] rolável e um
/// [footer] opcional (ex.: um `AppButtonsFooter` com as ações). Para exibi-lo
/// como modal (barrier + transição + gestão de foco) use o helper
/// [showAppDialog].
///
/// A **barra de topo** é a mesma das sheets ([AppSurfaceTopBar]): [title]
/// opcional e botão de fechar em chip circular, ligado por padrão e à direita
/// (`end`) por padrão. Diferente das sheets, o título é alinhado ao **início** —
/// no dialog ele é o cabeçalho de um formulário, não o rótulo de um painel.
/// Sem título e sem botão a barra simplesmente não existe (nada de vão vazio).
/// Ela fica **fora** da rolagem, como o rodapé.
///
/// Participa dos eixos globais do DS:
/// - **Estilo** ([AppStyle]): por ser uma superfície **flutuante**, o default é
///   `elevated` (sombra simétrica) — como os demais overlays (`AppMenu`,
///   `AppPopover`, `AppCard` de painel). Sobrescreva por instância via [style]
///   (`outlined` troca a sombra por borda `outline`; `filled` deixa chapado).
/// - **Forma** ([AppRadiusMode]): segue o modo de raio global, com override via
///   [radiusMode]/[radius].
///
/// Todas as cores vêm do tema (`surfaceContainer`, `outline`) → contraste AA em
/// claro/escuro nas duas marcas.
///
/// ```dart
/// showAppDialog(
///   context: context,
///   title: const AppText('Excluir veículo?'),
///   child: const AppDialogContent(
///     message: 'Esta ação não pode ser desfeita.',
///     illustration: 'assets/delete.svg',
///   ),
///   footer: AppButtonsFooter(primary: confirmButton, secondary: cancelButton),
/// );
/// ```
final class AppDialog extends StatelessWidget {
  /// Cria um [AppDialog].
  const AppDialog({
    required this.child,
    this.footer,
    this.title,
    this.titleWidget,
    this.showCloseButton = true,
    this.closeSide = AppSheetCloseSide.end,
    this.onCloseButton,
    this.style,
    this.glass,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Conteúdo do dialog (rolável quando excede a altura disponível).
  final Widget child;

  /// Rodapé opcional (ex.: um `AppButtonsFooter` com Ok/Cancelar).
  final Widget? footer;

  /// Título opcional, alinhado ao início da barra de topo.
  final String? title;

  /// Escape hatch para o título que NÃO é só texto (ícone ao lado, título
  /// reativo). Aqui a tipografia é de quem passa — a barra não a impõe.
  final Widget? titleWidget;

  /// Mostra o botão de fechar (chip circular). Default `true`.
  ///
  /// Desligue num dialog `barrierDismissible: false` só se o rodapé já oferecer
  /// uma saída — senão o usuário fica preso.
  final bool showCloseButton;

  /// Lado do botão de fechar. Default `end` (direita em LTR).
  final AppSheetCloseSide closeSide;

  /// Ação do botão de fechar. `null` → dá pop na rota.
  final VoidCallback? onCloseButton;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. `null`
  /// (default) resolve para `elevated` — o padrão dos overlays flutuantes; passe
  /// para sobrescrever.
  final AppStyle? style;

  /// Override do eixo glass só deste dialog. `null` segue o global
  /// (`theme.glassTheme.enabled`); `true`/`false` força ligado/desligado.
  final bool? glass;

  /// Override do modo de forma (raio) só deste dialog. `null` segue o modo
  /// global (`theme.radiusTheme`).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio. Vence [radiusMode] e o modo global.
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    // Overlay flutuante: default próprio `elevated` (não segue o global
    // `styleTheme`, igual a AppMenu/AppPopover), sobrescrevível por instância.
    final AppStyle s = style ?? AppStyle.elevated;
    // Eixo glass (aditivo): override por instância ou o global da marca.
    final bool glassOn = glass ?? theme.glassTheme.enabled;
    final bool isDark = theme.brightness == AppBrightness.dark;
    // Superfície grande: usa a escala dedicada (`circular` não satura em oval).
    final BorderRadius br =
        radius ??
        BorderRadius.circular(
          theme.radiusTheme.surfaceCornerRadius(radiusMode),
        );

    // Sem título e sem "X" não há chrome nenhum: a barra NÃO entra na coluna
    // (montá-la com o conteúdo vazio deixaria um vão de 64px).
    final bool hasTopBar = title != null || showCloseButton;

    Widget inner = Column(
      mainAxisSize: MainAxisSize.min,
      // A barra vai de borda a borda, então COM ela a coluna estica e o card
      // passa a ocupar a largura máxima das constraints (640 por default) em vez
      // de abraçar o conteúdo. SEM barra, o comportamento histórico fica intacto.
      crossAxisAlignment: hasTopBar
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.center,
      children: <Widget>[
        // FORA do `SingleChildScrollView`: o header é chrome fixo, como o
        // rodapé. Dentro da rolagem ele sairia de vista junto com o conteúdo.
        if (hasTopBar)
          AppSurfaceTopBar(
            title: title,
            titleWidget: titleWidget,
            titleAlign: AppSurfaceTopBarTitleAlign.start,
            showCloseButton: showCloseButton,
            closeSide: closeSide,
            onCloseButton: onCloseButton,
            // A superfície do dialog JÁ é `surfaceContainer` e a barra não cobre
            // nada que role. Pintar por cima só apagaria a borda do `outlined`,
            // que o `DecoratedBox` abaixo desenha ATRÁS do filho.
            transparent: true,
          ),
        Flexible(child: SingleChildScrollView(child: child)),
        ?footer,
      ],
    );

    // O corpo precisa saber se a superfície já desenhou uma barra — ver
    // [AppDialogChrome].
    inner = AppDialogChrome(hasTopBar: hasTopBar, child: inner);

    // Glass: barreira + página atrás são Flutter-painted → o blur é real aqui.
    if (glassOn) {
      return AppGlassSurface(borderRadius: br, child: inner);
    }

    return DecoratedBox(
      decoration: styleBoxDecoration(
        style: s,
        isDark: isDark,
        radius: br,
        outline: colors.outline,
        surfaceContainer: colors.surfaceContainer,
        // Overlay opaco (não-glass) sempre em `surfaceContainer` — inclusive no
        // `outlined` (senão o dialog fica see-through sobre o barrier).
        background: colors.surfaceContainer,
      ),
      child: ClipRRect(borderRadius: br, child: inner),
    );
  }
}

/// Diz ao corpo se a superfície do dialog **já desenhou** uma barra de topo.
///
/// Existe por causa do respiro: um corpo padrão como `AppDialogContent` abre com
/// um respiro generoso porque, sem barra, ele nasce colado no topo do card. Com
/// a barra por cima, esse mesmo respiro vira um vão duplo. Em vez de cada corpo
/// adivinhar, a superfície publica o fato.
final class AppDialogChrome extends InheritedWidget {
  /// Cria um [AppDialogChrome].
  const AppDialogChrome({
    required this.hasTopBar,
    required super.child,
    super.key,
  });

  /// `true` quando a superfície desenhou a barra de topo.
  final bool hasTopBar;

  /// Lê o escopo mais próximo. `false` fora de um [AppDialog] — um corpo usado
  /// solto (preview, Widgetbook) segue com o respiro cheio.
  static bool hasTopBarOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<AppDialogChrome>()
          ?.hasTopBar ??
      false;

  @override
  bool updateShouldNotify(AppDialogChrome oldWidget) =>
      oldWidget.hasTopBar != hasTopBar;
}

/// Rota modal do [showAppDialog] — sem dependência de Material.
///
/// Usa o [Navigator] do app, que já cuida de escopo de foco e devolução de foco
/// ao gatilho ao fechar. A transição (fade) e sua duração vêm dos tokens de
/// motion e colapsam sob reduce-motion ([AppMotion]).
class _AppDialogRoute<T> extends PopupRoute<T> {
  _AppDialogRoute({
    required this.builder,
    required this.barrierColor,
    this.bounds,
    this.barrierDismissible = true,
  });

  final WidgetBuilder builder;

  /// Região a que o dialog se confina; `null` = tela toda.
  final AppOverlayBoundsHandle? bounds;

  /// O barrier acompanha o confinamento — ver [AppOverlayBounds].
  @override
  Widget buildModalBarrier() =>
      AppConfinedToBounds(bounds: bounds, child: super.buildModalBarrier());

  @override
  final Color barrierColor;

  @override
  final bool barrierDismissible;

  @override
  String get barrierLabel => 'Fechar';

  @override
  Duration get transitionDuration => AppDurations.normal;

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
    // Reduce-motion: aparece instantâneo (sem tween de opacidade).
    if (!AppMotion.enabled(context)) {
      return AppConfinedToBounds(bounds: bounds, child: child);
    }
    // Confinado por fora do fade: o `Center` do conteúdo passa a centrar na
    // região, não na tela.
    return AppConfinedToBounds(
      bounds: bounds,
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: AppCurves.standard),
        child: child,
      ),
    );
  }
}

/// Exibe um [AppDialog] como modal central (barrier dismissível por padrão).
///
/// Retorna o valor passado a [Navigator.pop] ou `null` se fechado pelo barrier
/// ou pelo botão de fechar. Os eixos [style]/[glass]/[radiusMode]/[radius] e a
/// barra de topo ([title]/[showCloseButton]/[closeSide]/[onCloseButton]) são
/// repassados ao [AppDialog].
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget child,
  Widget? footer,
  String? title,
  Widget? titleWidget,
  bool showCloseButton = true,
  AppSheetCloseSide closeSide = AppSheetCloseSide.end,
  VoidCallback? onCloseButton,
  bool barrierDismissible = true,
  BoxConstraints? constraints,
  AppStyle? style,
  bool? glass,
  AppRadiusMode? radiusMode,
  BorderRadius? radius,
}) {
  // O tema/text-scale vivem ABAIXO do Navigator (o overlay da rota fica acima
  // deles). Captura-os no trigger e reprovê dentro da rota via AppOverlayScope —
  // senão `AppTheme.of` estoura no conteúdo do dialog (ex.: no Widgetbook, onde
  // o ThemeAddon embrulha por use-case).
  final AppThemeData theme = AppTheme.of(context);
  final TextScaler textScaler = MediaQuery.textScalerOf(context);

  return Navigator.of(context).push<T>(
    _AppDialogRoute<T>(
      barrierDismissible: barrierDismissible,
      barrierColor: theme.colorTheme.neutralPrimary.barrier(),
      // Capturado no gatilho: a rota nasce acima do shell e não veria a região.
      bounds: AppOverlayBounds.maybeOf(context),
      builder: (BuildContext context) => AppOverlayScope(
        theme: theme,
        textScaler: textScaler,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s64),
            child: ConstrainedBox(
              constraints:
                  constraints ??
                  const BoxConstraints(minWidth: 448, maxWidth: 640),
              child: AppDialog(
                footer: footer,
                title: title,
                titleWidget: titleWidget,
                showCloseButton: showCloseButton,
                closeSide: closeSide,
                onCloseButton: onCloseButton,
                style: style,
                glass: glass,
                radiusMode: radiusMode,
                radius: radius,
                child: child,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
