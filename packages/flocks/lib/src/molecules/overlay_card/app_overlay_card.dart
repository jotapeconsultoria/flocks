import 'package:flutter/widgets.dart';

import '../../atoms/glass/app_glass_surface.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
// A condição é `dart.library.js_interop`, e NÃO `dart.library.html`: as duas
// valem no dart2js, mas `dart:html` não existe no dart2wasm. Com o predicado
// antigo, todo `flutter build web --wasm` cairia no stub e a interceptação
// sumiria em silêncio — o pior tipo de regressão, porque nenhum teste deste
// repositório roda no browser.
import '../../foundation/pointer/pointer_interceptor_stub.dart'
    if (dart.library.js_interop) '../../foundation/pointer/pointer_interceptor_web.dart'
    as pointer;

/// Card flutuante com [child] livre, que **intercepta o ponteiro** (bloqueia
/// cliques de vazarem para uma *platform view* embaixo, ex.: um mapa no web).
///
/// Superfície `surfaceContainer` que participa do eixo global de estilo
/// ([AppStyle], default próprio `elevated`) e de forma ([AppRadiusMode]).
/// [accentColor] destaca a borda (no modo `outlined`). Todas as cores vêm do
/// tema → adapta a claro/escuro e às marcas.
///
/// Diferente do [AppCard], este embrulha o conteúdo na interceptação de
/// ponteiro — use-o quando o card flutua sobre um mapa/vídeo e o clique não
/// pode vazar. A interceptação é real no web e passa-direto fora dele.
final class AppOverlayCard extends StatelessWidget {
  /// Cria um [AppOverlayCard].
  const AppOverlayCard({
    required this.child,
    this.accentColor,
    this.padding,
    this.style,
    this.glass,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Cor da borda de destaque (só no estilo `outlined`). `null` usa o token
  /// neutro do tema.
  final Color? accentColor;

  /// Conteúdo do card.
  final Widget child;

  /// Padding interno. Default `EdgeInsets.all(AppSpacings.s16)`.
  final EdgeInsetsGeometry? padding;

  /// Tratamento de container ([AppStyle]) do render **não-glass**. `null` resolve
  /// para `elevated`.
  final AppStyle? style;

  /// Override do eixo glass só deste card. `null` segue o global
  /// (`theme.glassTheme.enabled`).
  final bool? glass;

  /// Override do modo de forma. `null` segue o global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio. Vence [radiusMode] e o modo global.
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final AppStyle s = style ?? AppStyle.elevated;
    final bool glassOn = glass ?? theme.glassTheme.enabled;
    final bool isDark = theme.brightness == AppBrightness.dark;
    // Escala de superfície (24/48), NÃO o resolver genérico: o card é
    // content-sized, então `circular` saturaria em metade do lado menor e o
    // painel viraria um estádio gigante que corta o próprio conteúdo.
    final BorderRadius br =
        radius ??
        BorderRadius.circular(
          theme.radiusTheme.surfaceCornerRadius(radiusMode),
        );
    final Color outline = accentColor ?? colors.neutralPrimary.s100;
    final EdgeInsetsGeometry pad =
        padding ?? const EdgeInsets.all(AppSpacings.s16);

    // A interceptação fica SEMPRE mais externa: cobre o rect visível do card e
    // bloqueia o clique de vazar para a platform view (mapa) embaixo — o
    // `BackdropFilter`/`RepaintBoundary` do vidro moram dentro dela. No web é um
    // `<div>` vazio montado atrás do conteúdo; fora do web devolve o filho
    // intocado, e é por isso que os goldens (que rodam na VM) não se mexem.
    return pointer.interceptPointer(
      glassOn
          ? AppGlassSurface(borderRadius: br, padding: pad, child: child)
          : DecoratedBox(
              decoration: styleBoxDecoration(
                style: s,
                isDark: isDark,
                radius: br,
                outline: outline,
                surfaceContainer: colors.surfaceContainer,
              ),
              child: ClipRRect(
                borderRadius: br,
                child: Padding(padding: pad, child: child),
              ),
            ),
    );
  }
}
