import 'package:flutter/widgets.dart';

import '../tokens/app_elevation.dart';
import '../tokens/app_strokes.dart';
import '../tokens/app_style.dart';

/// Resultado de [resolveStyleDecoration]: os três aspectos de container que o
/// eixo [AppStyle] controla. O componente monta o `BoxDecoration` final juntando
/// o seu próprio `borderRadius` (ver [styleBoxDecoration] para o atalho).
typedef StyleDecoration = ({
  Color? color,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
});

/// Resolve o tratamento de container ([AppStyle]) de um componente — função
/// **pura** (padrão dos resolvers de cor do DS, ex.: `appFilledButtonColors`),
/// testável sem render.
///
/// O `style` é **aditivo**: não troca a cor semântica do componente, só
/// acrescenta borda/superfície/sombra. Semântica:
///
/// | style      | preenchido ([ownFill] ≠ null)      | transparente ([ownFill] = null) |
/// |------------|------------------------------------|---------------------------------|
/// | filled     | mantém `ownFill`, sem borda/sombra  | `surfaceContainer`, sem borda   |
/// | outlined   | `ownFill` + borda `outline`        | transparente + borda `outline`  |
/// | elevated   | `ownFill` + sombra (sem borda)      | `surfaceContainer` + sombra     |
///
/// O tratamento **glass** não passa por aqui: é um eixo aditivo à parte
/// (`AppGlassTheme`), resolvido pelo widget `AppGlassSurface` (que precisa de um
/// `BackdropFilter`, fora do alcance de um `BoxDecoration`).
///
/// - [ownFill] é o fill semântico do componente (badge=papel@10%, fill-button=
///   base do papel…); `null` = componente transparente/ghost por padrão.
/// - [background] sobrescreve o fundo (vence `ownFill`/`surfaceContainer`) — o
///   hook de "trocar a cor de fundo" dos componentes preenchidos.
/// - [outline]/[surfaceContainer] vêm de `theme.colorTheme`.
StyleDecoration resolveStyleDecoration({
  required AppStyle style,
  required bool isDark,
  required Color outline,
  required Color surfaceContainer,
  Color? ownFill,
  Color? background,
  double borderWidth = AppStrokes.m,
}) {
  final Border outlineBorder = Border.all(color: outline, width: borderWidth);
  return switch (style) {
    AppStyle.filled => (
      color: background ?? ownFill ?? surfaceContainer,
      border: null,
      boxShadow: null,
    ),
    AppStyle.outlined => (
      color: background ?? ownFill,
      border: outlineBorder,
      boxShadow: null,
    ),
    AppStyle.elevated => (
      // Elevado = só fundo + sombra, SEM borda (a sombra faz a separação).
      color: background ?? ownFill ?? surfaceContainer,
      border: null,
      boxShadow: AppElevation.symmetricShadows(isDark),
    ),
  };
}

/// Atalho de [resolveStyleDecoration] que já devolve um `BoxDecoration` com o
/// [radius] do componente aplicado.
BoxDecoration styleBoxDecoration({
  required AppStyle style,
  required bool isDark,
  required BorderRadius radius,
  required Color outline,
  required Color surfaceContainer,
  Color? ownFill,
  Color? background,
  double borderWidth = AppStrokes.m,
}) {
  final StyleDecoration d = resolveStyleDecoration(
    style: style,
    isDark: isDark,
    outline: outline,
    surfaceContainer: surfaceContainer,
    ownFill: ownFill,
    background: background,
    borderWidth: borderWidth,
  );
  return BoxDecoration(
    color: d.color,
    border: d.border,
    boxShadow: d.boxShadow,
    borderRadius: radius,
  );
}
