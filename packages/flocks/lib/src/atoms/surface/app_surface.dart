import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/app_style.dart';

/// Nível de elevação de um [AppSurface].
///
/// A elevação é expressa por **tom** (não por sombra), seguindo a filosofia de
/// contraste do design system ("elevar = clarear").
enum AppSurfaceVariant {
  /// Ao nível da página — `colorTheme.surface`.
  flat,

  /// Elevado — `colorTheme.surfaceContainer` (um passo de tom acima).
  raised,

  /// Ao nível da página, delimitado por uma borda `colorTheme.outline`.
  bordered,
}

/// Container-base temável do Flocks — a superfície sobre a qual o conteúdo se
/// apoia (cards, painéis, menus, sheets).
///
/// Padroniza o padrão onipresente de `DecoratedBox`/`Container` com cor de
/// superfície + raio (+ borda), lendo tudo do tema. A elevação vem do [variant]
/// por **tom**, não por sombra.
///
/// ```dart
/// AppSurface(
///   variant: AppSurfaceVariant.raised,
///   padding: const EdgeInsets.all(AppSpacings.s16),
///   child: content,
/// )
/// ```
final class AppSurface extends StatelessWidget {
  /// Cria um [AppSurface] em torno de [child].
  const AppSurface({
    required this.child,
    this.variant = AppSurfaceVariant.flat,
    this.padding = EdgeInsets.zero,
    this.radius,
    this.color,
    this.border,
    this.style,
    this.clip = Clip.antiAlias,
    super.key,
  });

  /// Conteúdo da superfície.
  final Widget child;

  /// Nível de elevação (por tom). Default [AppSurfaceVariant.flat]. É a fonte do
  /// "fundo próprio" sobre o qual o [style] aplica borda/sombra.
  final AppSurfaceVariant variant;

  /// Espaço interno entre a borda da superfície e o [child].
  final EdgeInsetsGeometry padding;

  /// Raio dos cantos. Default: global (modo redondo), content-sized.
  final BorderRadius? radius;

  /// Sobrescreve a cor de fundo (default: derivada do [variant]). Equivale ao
  /// `background` do eixo [AppStyle].
  final Color? color;

  /// Sobrescreve a borda (default: derivada do [style]/[variant]).
  final BoxBorder? border;

  /// Estilo de container (borda/fundo/sombra). Default: global
  /// (`theme.styleTheme.style`). Aditivo sobre o [variant].
  final AppStyle? style;

  /// Recorte do conteúdo ao raio. Default [Clip.antiAlias].
  final Clip clip;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final BorderRadius r = radius ?? theme.radiusTheme.resolve();
    final AppStyle s = style ?? theme.styleTheme.style;

    // "Fundo próprio" derivado do variant — sempre preenchido (é uma superfície).
    final Color ownFill = switch (variant) {
      AppSurfaceVariant.flat => colors.surface,
      AppSurfaceVariant.raised => colors.surfaceContainer,
      AppSurfaceVariant.bordered => colors.surface,
    };

    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: theme.brightness == AppBrightness.dark,
      outline: colors.outline,
      surfaceContainer: colors.surfaceContainer,
      ownFill: ownFill,
      background: color,
    );

    // `bordered` força borda mesmo em `filled`; `border` explícito vence tudo.
    BoxBorder? b = border ?? deco.border;
    if (b == null && variant == AppSurfaceVariant.bordered) {
      b = Border.all(color: colors.outline, width: AppStrokes.s);
    }

    return Container(
      padding: padding,
      clipBehavior: clip,
      decoration: BoxDecoration(
        color: deco.color,
        borderRadius: r,
        border: b,
        boxShadow: deco.boxShadow,
      ),
      child: child,
    );
  }
}
