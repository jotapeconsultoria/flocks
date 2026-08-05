import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Cores resolvidas de um campo de texto ([AppInput]) por estado. Espelha
/// `dropdownFieldColors` do trigger do dropdown para manter os dois campos
/// visualmente consistentes.
typedef InputFieldColors = ({
  Color border,
  Color label,
  Color icon,
  Color hint,
  Color text,
  Color cursor,
});

/// Resolve as cores de um campo por estado (RULES §5): borda `outline` no
/// repouso; foco em `primary` (acentos em `secondary`); erro em `danger`;
/// desabilitado esmaecido por tom (`mutedForDisabled`). Acentos sempre em um
/// stop legível sobre a `surface`.
InputFieldColors inputFieldColors(
  AppColorTheme colors, {
  required bool enabled,
  required bool focused,
  required bool error,
}) {
  final Color hint = colors.neutralPrimary.s600;
  if (!enabled) {
    final Color muted = mutedForDisabled(colors.onSurface, colors.surface);
    return (
      border: muted,
      label: muted,
      icon: muted,
      hint: muted,
      text: muted,
      cursor: muted,
    );
  }
  if (error) {
    final Color danger = readableStopOn(
      colors.danger,
      colors.surface,
      minRatio: 4.5,
    );
    return (
      border: danger,
      label: danger,
      icon: danger,
      hint: hint,
      text: colors.onSurface,
      cursor: danger,
    );
  }
  if (focused) {
    // Foco = `primary` (borda + label + ícone + cursor). Antes o label/ícone
    // usavam `secondary`, que na jotape lê como laranja/vermelho (parecia erro).
    final Color accent = readableStopOn(colors.primary, colors.surface);
    return (
      border: accent,
      label: accent,
      icon: accent,
      hint: hint,
      text: colors.onSurface,
      cursor: accent,
    );
  }
  return (
    border: colors.outline,
    label: colors.onSurface,
    icon: colors.onSurface,
    hint: hint,
    text: colors.onSurface,
    cursor: colors.onSurface,
  );
}
