import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Cor do passo ALCANÇADO (atual/anteriores), visível na superfície: base no
/// claro; tom claro (`primary.s400`) no escuro — a base é escura demais p/
/// contrastar (mesma lógica do `focusRing`). Delega ao acento canônico
/// [AppColorTheme.primaryAccent].
Color _reachedAccent(AppThemeData theme) => theme.colorTheme.primaryAccent(
  isDark: theme.brightness == AppBrightness.dark,
);

/// Indicador de passos/páginas em formato de "dots".
///
/// Exibe círculos que indicam a página atual em um fluxo de múltiplas etapas.
/// Para etapas rotuladas com título/ícone, use [AppStepper].
///
/// Três estados por cor: passos **anteriores** ([completedColor]) e o **atual**
/// ([activeColor], com um "pop") usam o accent; os **futuros** ([inactiveColor])
/// ficam neutros. Passe [onStepTapped] para tornar os dots clicáveis (foco por
/// Tab, hover, Enter/Space).
///
/// Exemplo:
/// ```dart
/// AppDotsIndicator(currentStep: 0, totalSteps: 3)
/// ```
final class AppDotsIndicator extends StatelessWidget {
  const AppDotsIndicator({
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
    this.completedColor,
    this.inactiveColor,
    this.size = AppSizes.s8,
    this.spacing = AppSpacings.s4,
    this.onStepTapped,
    this.allStepsTappable = false,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  }) : assert(
         currentStep >= 0 && currentStep < totalSteps,
         'currentStep deve estar entre 0 e totalSteps - 1',
       );

  /// Cor do dot ATUAL. Se nulo, usa o accent visível ([_reachedAccent]).
  final Color? activeColor;

  /// Cor dos dots ANTERIORES (já percorridos). Se nulo, usa o accent.
  final Color? completedColor;

  /// Passo atual (0-indexed).
  final int currentStep;

  /// Cor dos dots FUTUROS. Se nulo, usa `neutralPrimary.s500` (neutro legível).
  final Color? inactiveColor;

  /// Diâmetro de cada círculo indicador.
  final double size;

  /// Espaçamento entre os indicadores.
  final double spacing;

  /// Número total de passos.
  final int totalSteps;

  /// Callback ao tocar num dot. Recebe o índice. Se `null`, nada é tocável.
  final ValueChanged<int>? onStepTapped;

  /// Se `true`, TODOS os dots são tocáveis (tendo passado ou não). Se `false`
  /// (padrão), apenas os anteriores ao atual respondem ao toque.
  final bool allStepsTappable;

  /// Tratamento de container (borda/fundo/sombra) do eixo global [AppStyle]
  /// aplicado à pílula. `null` (default) segue o global `theme.styleTheme.style`:
  /// `filled` = fundo `neutralPrimary.s100` (atual), `outlined` = + borda,
  /// `elevated` = + sombra.
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste indicador (vence o global
  /// `theme.radiusTheme.mode`) — aplica à pílula e aos dots.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio da pílula — vence [radiusMode] e o global.
  final BorderRadius? radius;

  bool _isTappable(int index) =>
      onStepTapped != null && (allStepsTappable || index < currentStep);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final accent = _reachedAccent(theme);
    final active = activeColor ?? accent;
    final completed = completedColor ?? accent;
    final inactive = inactiveColor ?? theme.colorTheme.neutralPrimary.s500;

    // Eixo de estilo global aplicado à PÍLULA (container): filled = fundo s100
    // (atual), outlined = + borda `outline`, elevated = + sombra. Os dots seguem
    // sendo o conteúdo (accent/neutro), sem restyle.
    final AppStyle s = style ?? theme.styleTheme.style;
    final StyleDecoration pillDeco = resolveStyleDecoration(
      style: s,
      isDark: theme.brightness == AppBrightness.dark,
      outline: theme.colorTheme.outline,
      surfaceContainer: theme.colorTheme.neutralPrimary.s200,
      ownFill: theme.colorTheme.neutralPrimary.s100,
    );
    // Passa o tamanho REAL da pílula ao resolvedor: assim `redondo` fica
    // PROPORCIONAL à altura (não satura em pílula "por conta da altura"),
    // refletindo o mesmo modo que os dots aplicam à sua própria forma.
    final double pillHeight = size + AppSpacings.s8 * 2;
    final double pillWidth =
        totalSteps * size + (totalSteps - 1) * spacing + AppSpacings.s8 * 2;
    final BorderRadius pillBR =
        radius ??
        theme.radiusTheme.resolve(
          override: radiusMode,
          size: Size(pillWidth, pillHeight),
        );

    // Forma dos dots. Default do dot: circular (satura em metade do dot);
    // Reto→quadrado, Redondo→quadrado arredondado. `radiusMode` sobrescreve.
    final double dotRadius = theme.radiusTheme.resolveRadius(
      componentDefault: AppRadiusMode.circular,
      size: Size.square(size),
      override: radiusMode,
    );

    Widget dot(int index) {
      final bool isActive = index == currentStep;
      final bool passed = index < currentStep;
      final Color color = isActive ? active : (passed ? completed : inactive);

      Widget core(bool highlighted, bool pressed) {
        Widget d = AnimatedContainer(
          duration: AppMotion.resolve(context, AppDurations.normal),
          curve: AppCurves.standard,
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(dotRadius),
          ),
        );
        // Overlay de estado (hover/foco/press) recortado ao dot — ladder
        // pressed 0.12 › hover|foco 0.08 (mesma escala de badge/avatar).
        final double? overlayAlpha = pressed
            ? 0.12
            : (highlighted ? 0.08 : null);
        if (overlayAlpha != null) {
          d = Stack(
            alignment: Alignment.center,
            children: <Widget>[
              d,
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorTheme.onSurface.withValues(
                      alpha: overlayAlpha,
                    ),
                    borderRadius: BorderRadius.circular(dotRadius),
                  ),
                ),
              ),
            ],
          );
        }
        // Anel de foco/hover — igual checkbox/radio/switch (dentro do pop p/
        // escalar junto com o dot ativo).
        if (highlighted) {
          d = DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(dotRadius + AppStrokes.m),
              border: Border.all(
                color: theme.colorTheme.focusRing,
                width: AppStrokes.m,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: d,
          );
        }
        // Escala no press (motion-gated), composta com o "pop" do dot ativo.
        final double pressScale = pressed && AppMotion.enabled(context)
            ? 0.94
            : 1.0;
        d = AnimatedScale(
          scale: pressScale,
          duration: AppMotion.resolve(context, AppDurations.fast),
          curve: AppCurves.standard,
          child: d,
        );
        // Dot ativo dá um "pop" (escala com overshoot).
        return AppPop(scale: isActive ? 1.2 : 1.0, child: d);
      }

      if (_isTappable(index)) {
        return AppSemantics.button(
          label: 'Ir para o passo ${index + 1}',
          onTap: () => onStepTapped!(index),
          child: FlocksInteraction(
            onPressed: () => onStepTapped!(index),
            builder: (context, states) => core(
              states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.hovered),
              states.contains(WidgetState.pressed),
            ),
          ),
        );
      }
      return core(false, false);
    }

    return AppSemantics.status(
      label: 'Passo ${currentStep + 1} de $totalSteps',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: pillDeco.color,
          border: pillDeco.border,
          boxShadow: pillDeco.boxShadow,
          borderRadius: pillBR,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s8,
            vertical: AppSpacings.s8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalSteps, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < totalSteps - 1 ? spacing : 0,
                ),
                child: dot(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}
