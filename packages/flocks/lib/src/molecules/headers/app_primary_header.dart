import 'package:flutter/widgets.dart';

import '../../atoms/bars/app_bar_surface.dart';
import '../../atoms/icons/icons.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/app_overlay_bar.dart';
import '../../theme/theme.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../buttons/app_button_size.dart';
import '../buttons/app_floating_button.dart';
import '../interactive/app_interaction.dart';

/// Altura FIXA do conteúdo do header (não cresce com os filhos). A faixa da
/// status bar é somada por cima disso.
const double kAppHeaderContentHeight = 56.0;

/// Reserva horizontal simétrica dos slots leading/trailing — mantém o título
/// centralizado mesmo com só um dos lados. Casa com o alvo de toque das ações.
const double kAppHeaderSlotReserve = 48.0;

/// Inset inicial do child quando alinhado à esquerda sem leading (`_row`).
const double kAppHeaderChildInset = AppSpacings.s12;

/// Cabeçalho primário de página: um [child] centralizado com slots opcionais de
/// [leading] e [trailing], participando do eixo de estilo [AppStyle]
/// (`filled`/`outlined`/`elevated`) com **semântica de barra** (borda/sombra só
/// na aresta de baixo). Participa também do eixo glass ([glass] ou o global):
/// glass = blur + gradiente estilo Notes.
///
/// - **Altura fixa** ([kAppHeaderContentHeight] + safe-area do topo); não cresce
///   com o conteúdo.
/// - **Centralização real**: com [centerChild] e só um dos lados, o título
///   permanece centralizado (trunca em vez de deslocar).
/// - **Glass sobrepõe** o conteúdo via [AppScaffold] (efeito Notes).
///
/// Slots [leading]/[trailing] são `Widget?` livres. Convenção: no glass use um
/// FAB glass; nos demais um `AppButton` neutro do style — ver [action].
///
/// ```dart
/// AppPrimaryHeader(
///   glass: true,
///   leading: AppPrimaryHeader.action(context, icon: AppIconToken.chevronLeft, onTap: back, glass: true),
///   child: AppText('Detalhes'),
/// )
/// ```
final class AppPrimaryHeader extends StatelessWidget with AppOverlayBar {
  /// Cria um [AppPrimaryHeader].
  const AppPrimaryHeader({
    required this.child,
    this.centerChild = true,
    this.style = AppStyle.filled,
    this.glass,
    this.radiusMode,
    this.constraints,
    this.decoration,
    this.leading,
    this.padding,
    this.trailing,
    super.key,
  });

  /// Se o [child] é centralizado (senão, alinhado à esquerda).
  final bool centerChild;

  /// Conteúdo central do cabeçalho.
  final Widget child;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. Default
  /// `filled` (visual atual).
  final AppStyle style;

  /// Override do eixo glass. `null` segue o global (`theme.glassTheme.enabled`).
  @override
  final bool? glass;

  /// Modo de forma (só relevante se o header algum dia flutuar). `null` = band
  /// quadrada full-bleed.
  final AppRadiusMode? radiusMode;

  /// Restrições. `maxHeight` sobrescreve a altura fixa do conteúdo.
  final BoxConstraints? constraints;

  /// Decoração custom — **escape hatch legado**: quando não-nula, curto-circuita
  /// o eixo de [style] e pinta como antes.
  final BoxDecoration? decoration;

  /// Slot à esquerda (ex.: botão de voltar). Ver [action].
  final Widget? leading;

  /// Padding interno. Default all `s4` (bem pequeno).
  final EdgeInsets? padding;

  /// Slot à direita (ex.: ação). Ver [action].
  final Widget? trailing;

  @override
  AppStyle get barStyle => style;

  @override
  BarEdge get barEdge => BarEdge.bottom;

  @override
  double resolveBarExtent(BuildContext context) =>
      MediaQuery.viewPaddingOf(context).top +
      (constraints?.maxHeight ?? kAppHeaderContentHeight);

  /// Monta o botão de slot recomendado: um **FAB glass** quando [glass], senão um
  /// **ícone ghost** (só ícone, sem fundo) com alvo de toque generoso
  /// ([kAppHeaderSlotReserve]) e realce de hover/press no radius global. Ícone em
  /// tamanho normal (`AppIconSize.m`). Retorna um `Widget` — o tipo do slot
  /// continua livre.
  static Widget action(
    BuildContext context, {
    required String icon,
    required VoidCallback? onTap,
    bool glass = false,
    String? semanticLabel,
  }) {
    if (glass) {
      return AppFloatingButton(
        onPressed: onTap,
        glass: true,
        icon: icon,
        size: AppButtonSize.m,
        semanticsLabel: semanticLabel,
      );
    }
    final AppColorTheme colors = AppTheme.of(context).colorTheme;
    return AppInteraction(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: SizedBox(
        width: kAppHeaderSlotReserve,
        height: kAppHeaderSlotReserve,
        child: Center(
          child: AppIcon(icon, size: AppIconSize.m, color: colors.onSurface),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final double topInset = MediaQuery.viewPaddingOf(context).top;
    final EdgeInsets pad = padding ?? const EdgeInsets.all(AppSpacings.s4);
    final double contentHeight =
        constraints?.maxHeight ?? kAppHeaderContentHeight;

    final Widget content = SizedBox(
      height: contentHeight,
      child: Padding(padding: pad, child: centerChild ? _centered() : _row()),
    );

    // Escape hatch legado: decoração custom pinta como antes (band + safe-area).
    if (decoration != null) {
      return AppSemantics.header(
        DecoratedBox(
          decoration: decoration!.copyWith(
            color: decoration!.color ?? theme.colorTheme.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: topInset),
              content,
            ],
          ),
        ),
      );
    }

    final BorderRadius? radius = radiusMode == null
        ? null
        : theme.radiusTheme.resolve(override: radiusMode);

    return AppSemantics.header(
      AppBarSurface(
        style: style,
        glass: resolveGlassOn(context),
        contentEdge: BarEdge.bottom,
        outerSafeAreaInset: topInset,
        borderRadius: radius,
        child: content,
      ),
    );
  }

  /// Título centralizado no eixo do header inteiro (Stack), com reserva
  /// simétrica dos slots → o título trunca, nunca sobrepõe as pontas.
  Widget _centered() {
    final bool anySlot = leading != null || trailing != null;
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: anySlot ? kAppHeaderSlotReserve : 0,
            ),
            child: Center(child: child),
          ),
        ),
        if (leading != null)
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: kAppHeaderSlotReserve,
                ),
                child: leading,
              ),
            ),
          ),
        if (trailing != null)
          PositionedDirectional(
            end: 0,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: kAppHeaderSlotReserve,
                ),
                child: trailing,
              ),
            ),
          ),
      ],
    );
  }

  /// Layout à esquerda (comportamento de `centerChild: false`). Sem leading, o
  /// child ganha um inset inicial para não colar na borda.
  Widget _row() => Row(
    children: <Widget>[
      ?leading,
      if (leading != null) const SizedBox(width: AppSpacings.s8),
      Expanded(
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: leading == null ? kAppHeaderChildInset : 0,
          ),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: child,
          ),
        ),
      ),
      ?trailing,
    ],
  );
}
