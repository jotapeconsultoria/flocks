import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/contrast.dart';
import '../../tokens/swatch_generator.dart';

/// Cores resolvidas de um botão por estado: `background`, `foreground`, `border`.
typedef ButtonColors = ({Color background, Color foreground, Color border});

/// Acento de um papel de cor: o stop do swatch legível sobre a superfície.
///
/// É **a** cor do papel na composição — o preenchimento do botão filled e o
/// conteúdo/borda do outlined saem daqui. Está exposta para que outros
/// elementos da mesma peça (a ilustração de um dialog, por exemplo) fiquem
/// exatamente na mesma cor do botão, em vez de usarem a base crua do swatch,
/// que é sempre mais saturada e nunca bate com o que o botão pinta.
Color appRoleAccent(AppColorTheme theme, ColorSwatch<int> role) =>
    readableStopOn(role, theme.surface, minRatio: kAaNormal);

const Color _black = Color(0xFF000000);
const Color _white = Color(0xFFFFFFFF);

/// Cores de um botão **preenchido** (fill) por estado.
///
/// Fundo = o **mesmo stop de acento** que a variante fantasma (line/text) usa —
/// o stop do papel legível sobre a superfície (`readableStopOn`) — para que
/// filled/outlined/elevated apareçam na MESMA cor, independente do estilo. O
/// conteúdo vira preto/branco por contraste (`onColorFor`), sempre ≥ AA sobre o
/// acento. Hover/press **aprofundam** o fundo na direção OPOSTA ao conteúdo
/// (10%/20%) → o contraste do texto só aumenta. Desabilitado apaga o fundo por
/// tom e usa um indicador legível (`disabledIndicatorOn`). `onRole` é aceito por
/// compatibilidade de API, mas o contraste do conteúdo agora é derivado do
/// acento.
ButtonColors appFilledButtonColors(
  AppColorTheme theme,
  ColorSwatch<int> role,
  ColorSwatch<int> onRole, {
  required bool hovered,
  required bool pressed,
  required bool disabled,
}) {
  // Acento = stop do papel legível (≥ AA) sobre a superfície. É o MESMO valor
  // que `appGhostButtonColors` escolhe para a borda/texto do outlined, então os
  // estilos ficam cromaticamente idênticos.
  final Color accent = appRoleAccent(theme, role);
  if (disabled) {
    final Color bg = mutedForDisabled(accent, theme.surface);
    return (background: bg, foreground: disabledIndicatorOn(bg), border: bg);
  }
  final Color fg = onColorFor(accent);
  final Color deepen = fg.computeLuminance() > 0.5 ? _black : _white;
  final Color bg = pressed
      ? Color.alphaBlend(deepen.withValues(alpha: 0.20), accent)
      : hovered
      ? Color.alphaBlend(deepen.withValues(alpha: 0.10), accent)
      : accent;
  return (background: bg, foreground: fg, border: bg);
}

/// Cores de um botão **fantasma** (line/text/icon) por estado.
///
/// Conteúdo = um stop legível (≥ AA) do papel sobre a superfície, escolhido
/// contra o realce de press (estado extremo) → legível em repouso e pressionado.
/// O realce de fundo é NEUTRO (`onSurface` 8%/12%), para não colidir com a hue
/// do conteúdo. [bordered] (line) usa o conteúdo como cor de borda. Desabilitado
/// apaga o conteúdo/borda por tom.
ButtonColors appGhostButtonColors(
  AppColorTheme theme,
  ColorSwatch<int> role, {
  required bool bordered,
  required bool hovered,
  required bool pressed,
  required bool disabled,
}) {
  final Color pressBg = Color.alphaBlend(
    theme.onSurface.withValues(alpha: 0.12),
    theme.surface,
  );
  Color fg = readableStopOn(role, pressBg, minRatio: 4.5);
  if (disabled) fg = mutedForDisabled(fg, theme.surface);
  final Color bg = disabled
      ? theme.transparent
      : pressed
      ? theme.onSurface.withValues(alpha: 0.12)
      : hovered
      ? theme.onSurface.withValues(alpha: 0.08)
      : theme.transparent;
  return (
    background: bg,
    foreground: fg,
    border: bordered ? fg : theme.transparent,
  );
}
