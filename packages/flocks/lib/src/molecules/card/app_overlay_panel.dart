import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../atoms/glass/app_glass_surface.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_card.dart';

/// Superfície de um **painel flutuante** — a peça que decide, num lugar só, se o
/// painel é vidro (`AppGlassSurface`) ou opaco (`AppCard`).
///
/// Existe porque o [AppCard] **ignora o eixo glass de propósito** (ele vive no
/// fluxo do conteúdo; cards translúcidos no meio de uma lista ficam ilegíveis).
/// Painéis que flutuam — menu, dropdown, painel de picker — precisam do vidro,
/// e antes disto cada um montava o branch à mão. Quem esquecia nascia opaco para
/// sempre, sem nada avisar: foi exatamente o que aconteceu com os dropdowns e os
/// pickers.
///
/// ```dart
/// AppOverlayPanel(
///   radiusMode: theme.radiusTheme.containedMode(),
///   padding: const EdgeInsets.symmetric(vertical: AppSpacings.s4),
///   child: options,
/// )
/// ```
///
/// **Quem deve usar** — ver o critério de três cláusulas em [appResolveGlassOn]:
/// destacada do fluxo, contêiner de conteúdo do chamador, e permanência legível.
/// O censo em `test/architecture/glass_axis_test.dart` cobra a classificação de
/// todo overlay novo.
///
/// **Quem NÃO usa, e por quê** (casos legítimos, não pendências):
/// - `AppPopover` — o balão tem seta, então recorta o blur com `ClipPath` +
///   painter próprio; `AppGlassSurface` (retângulo arredondado) não serve.
/// - `BottomSheetSurface` / `SideSheetSurface` — raio assimétrico durante o
///   morph e uma top bar que troca de fill conforme o eixo.
/// - `AppOverlayCard` — o render opaco dele não é um [AppCard] (usa
///   `neutralPrimary.s100` como borda), então a troca não seria 1:1.
///
/// No render **não-glass** delega ao [AppCard] em vez de reimplementar
/// `styleBoxDecoration`: é o que os painéis já pintavam, então com o eixo
/// desligado a saída é idêntica à anterior, sem risco de deriva.
@internal
final class AppOverlayPanel extends StatelessWidget {
  /// Cria um [AppOverlayPanel].
  const AppOverlayPanel({
    required this.child,
    this.glass,
    this.style,
    this.radiusMode,
    this.radius,
    this.accentColor,
    this.padding,
    super.key,
  });

  /// Conteúdo do painel.
  final Widget child;

  /// Override do eixo glass só deste painel. `null` segue o global
  /// (`theme.glassTheme.enabled`).
  final bool? glass;

  /// Tratamento de container no render **não-glass**. Default [AppStyle.elevated]
  /// — um painel flutuante mantém profundidade mesmo sob um global `filled`/
  /// `outlined`, senão perde a leitura de "solto sobre a página".
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste painel.
  ///
  /// Painéis largos normalmente passam `theme.radiusTheme.containedMode()`: nos
  /// modos `circular`/`padrão` o raio saturaria e viraria um círculo gigante que
  /// corta o conteúdo (calendário, roda de hora, lista de opções).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio — vence [radiusMode] e o global.
  final BorderRadius? radius;

  /// Cor da borda de destaque. Só tem efeito no render não-glass e no estilo
  /// `outlined` — no vidro a borda é o *rim* do próprio `AppGlassSurface`.
  final Color? accentColor;

  /// Padding interno do painel.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    // `containedMode` é o default do painel, não uma escolha de cada chamador:
    // nos modos `circular`/`padrão` o raio satura e o painel vira uma pílula que
    // corta o conteúdo (lista de opções, calendário, itens do menu). Dropdown e
    // picker já clampavam à mão; o AppMenu não, e virava oval sob marca
    // circular. Resolvido aqui, uma vez.
    final AppRadiusMode contained = theme.radiusTheme.containedMode(radiusMode);

    if (!appResolveGlassOn(context, glass)) {
      return AppCard(
        style: style ?? AppStyle.elevated,
        radiusMode: contained,
        radius: radius,
        accentColor: accentColor,
        padding: padding,
        child: child,
      );
    }

    return AppGlassSurface(
      borderRadius: radius ?? theme.radiusTheme.resolve(override: contained),
      padding: padding,
      child: child,
    );
  }
}
