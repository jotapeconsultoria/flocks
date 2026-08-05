import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_style.dart';
import '../../tokens/swatch_generator.dart';
import '../buttons/app_button_size.dart';
import '../interactive/app_interaction.dart';

/// Controle numérico **− valor +** (com `min`/`max`/`step`).
///
/// Sem edição de texto livre (isso seria organism/`AppInput`): apenas
/// decrementar / exibir / incrementar. O `−` desabilita em [min] e o `+` em
/// [max]. O valor é uma região de status (leitores de tela anunciam a mudança).
///
/// ```dart
/// AppNumberStepper(
///   value: quantity,
///   min: 1,
///   max: 99,
///   onChanged: (v) => setState(() => quantity = v as int),
/// )
/// ```
final class AppNumberStepper extends StatelessWidget {
  /// Cria um [AppNumberStepper].
  const AppNumberStepper({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = double.infinity,
    this.step = 1,
    this.enabled = true,
    this.size = AppButtonSize.m,
    this.format,
    this.style,
    this.background,
    super.key,
  }) : assert(step > 0, 'step deve ser > 0');

  /// Valor atual.
  final num value;

  /// Notifica a mudança (já respeitando [min]/[max]).
  final ValueChanged<num> onChanged;

  /// Valor mínimo (o `−` desabilita quando atingido).
  final num min;

  /// Valor máximo (o `+` desabilita quando atingido).
  final num max;

  /// Incremento por toque.
  final num step;

  /// Se está habilitado.
  final bool enabled;

  /// Tamanho (altura).
  final AppButtonSize size;

  /// Formata o valor exibido (ex.: moeda). Default: inteiro quando possível.
  final String Function(num)? format;

  /// Estilo de container (borda/fundo/sombra). Default: global `theme.styleTheme.style`.
  final AppStyle? style;

  /// Sobrescreve o fundo (quando o [style] preenche). Default: derivado do estilo.
  final Color? background;

  void _emit(num next) {
    final num clamped = next.clamp(min, max);
    if (clamped != value) onChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool canDecrease = enabled && value > min;
    final bool canIncrease = enabled && value < max;
    final String display = format?.call(value) ?? _defaultFormat(value);
    final AppStyle s = style ?? theme.styleTheme.style;
    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: theme.brightness == AppBrightness.dark,
      outline: colors.outline,
      // Fundo do `filled`: um neutro distinto de `surface`/`surfaceContainer`
      // (senão o controle some sobre um card/painel).
      // Derivado, não fixo: hoje resolve para `s200` nas duas marcas e nos
      // dois temas, mas se a rampa de uma marca mudar o campo acompanha em
      // vez de colidir em silêncio com a superfície.
      surfaceContainer: mostSeparatedStop(
        colors.neutralPrimary,
        surfaces: <Color>[colors.surface, colors.surfaceContainer],
        content: colors.onSurface,
      ),
      background: background,
    );

    // Padding lateral = folga vertical do botão denso dentro do container
    // (`size.height`), pra os botões não ficarem grudados na borda lateral.
    final double denseButton = AppIconSize.s.value + AppSizes.s8 * 2;
    final double hPad = ((size.height - denseButton) / 2).clamp(
      0.0,
      double.infinity,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: deco.color,
        border: deco.border,
        boxShadow: deco.boxShadow,
        borderRadius: theme.radiusTheme.resolve(),
      ),
      child: SizedBox(
        height: size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppInteraction(
                semanticLabel: 'Diminuir',
                enabled: canDecrease,
                padding: const EdgeInsets.all(AppSizes.s8),
                onTap: () => _emit(value - step),
                child: AppIcon(
                  AppIconToken.remove,
                  size: AppIconSize.s,
                  color: colors.onSurface,
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: AppSizes.s48),
                child: AppSemantics.status(
                  label: 'Valor: $display',
                  child: AppText(
                    display,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium.copyWith(
                      color: enabled
                          ? colors.onSurface
                          : colors.neutralPrimary.s600,
                    ),
                  ),
                ),
              ),
              AppInteraction(
                semanticLabel: 'Aumentar',
                enabled: canIncrease,
                padding: const EdgeInsets.all(AppSizes.s8),
                onTap: () => _emit(value + step),
                child: AppIcon(
                  AppIconToken.add,
                  size: AppIconSize.s,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _defaultFormat(num v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
