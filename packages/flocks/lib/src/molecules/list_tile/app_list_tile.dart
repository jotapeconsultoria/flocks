import 'package:flutter/widgets.dart';

import '../../atoms/badge/badge.dart';
import '../../atoms/checkbox/checkbox.dart';
import '../../atoms/icons/icons.dart';
import '../../atoms/switch/switch.dart';
import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import 'app_list_tile_group.dart';
import 'list_tile_shell.dart';

enum _TileKind { generic, navigation, checkbox, toggle, badge }

/// Linha de lista do design system, em dois estilos ([AppListTileStyle]) e com
/// variações ortogonais via **construtores nomeados**: navegação (chevron),
/// checkbox, switch (`toggle`) e badge — todas com `leading` e `subtitle`
/// opcionais e `reorderIndex` (draggable). Agrupe várias com [AppListTileGroup].
///
/// Sobre um scaffold com hover/press/foco (`FlocksInteraction`), cores 100% do
/// tema, raio/animação globais. Para seleção única use [AppListTileRadio].
///
/// ```dart
/// AppListTile.navigation(
///   leading: AppIcon(AppIconToken.support),
///   title: 'Suporte',
///   onTap: openSupport,
/// )
/// ```
final class AppListTile extends StatelessWidget {
  /// Tile genérico: [trailing] custom (badge, ação…) e [onTap] opcionais.
  const AppListTile({
    required this.title,
    this.danger = false,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.style = AppListTileStyle.grouped,
    this.enabled = true,
    this.reorderIndex,
    this.reorderEnabled = true,
    this.semanticLabel,
    super.key,
  }) : _kind = _TileKind.generic,
       _boolValue = false,
       _boolChanged = null,
       _badgeText = null,
       _badgeRole = AppBadgeColor.neutral;

  /// Tile de **navegação**: trailing = chevron; tocar navega ([onTap]).
  const AppListTile.navigation({
    required this.title,
    required this.onTap,
    this.danger = false,
    this.subtitle,
    this.leading,
    this.style = AppListTileStyle.grouped,
    this.enabled = true,
    this.reorderIndex,
    this.reorderEnabled = true,
    this.semanticLabel,
    super.key,
  }) : _kind = _TileKind.navigation,
       trailing = null,
       _boolValue = false,
       _boolChanged = null,
       _badgeText = null,
       _badgeRole = AppBadgeColor.neutral;

  /// Tile com **checkbox**: tocar a linha alterna ([value]/[onChanged]).
  const AppListTile.checkbox({
    required this.title,
    required bool value,
    ValueChanged<bool>? onChanged,
    this.danger = false,
    this.subtitle,
    this.leading,
    this.style = AppListTileStyle.grouped,
    this.enabled = true,
    this.reorderIndex,
    this.reorderEnabled = true,
    this.semanticLabel,
    super.key,
  }) : _kind = _TileKind.checkbox,
       _boolValue = value,
       _boolChanged = onChanged,
       trailing = null,
       onTap = null,
       _badgeText = null,
       _badgeRole = AppBadgeColor.neutral;

  /// Tile com **switch** (`toggle`): tocar a linha alterna.
  const AppListTile.toggle({
    required this.title,
    required bool value,
    ValueChanged<bool>? onChanged,
    this.danger = false,
    this.subtitle,
    this.leading,
    this.style = AppListTileStyle.grouped,
    this.enabled = true,
    this.reorderIndex,
    this.reorderEnabled = true,
    this.semanticLabel,
    super.key,
  }) : _kind = _TileKind.toggle,
       _boolValue = value,
       _boolChanged = onChanged,
       trailing = null,
       onTap = null,
       _badgeText = null,
       _badgeRole = AppBadgeColor.neutral;

  /// Tile com **badge** no trailing (+ [onTap] opcional).
  const AppListTile.badge({
    required this.title,
    required String badge,
    AppBadgeColor badgeColor = AppBadgeColor.neutral,
    this.danger = false,
    this.onTap,
    this.subtitle,
    this.leading,
    this.style = AppListTileStyle.grouped,
    this.enabled = true,
    this.reorderIndex,
    this.reorderEnabled = true,
    this.semanticLabel,
    super.key,
  }) : _kind = _TileKind.badge,
       trailing = null,
       _boolValue = false,
       _boolChanged = null,
       _badgeText = badge,
       _badgeRole = badgeColor;

  /// Título (forte).
  final String title;

  /// Aplica o papel semântico destrutivo ao conteúdo do tile.
  final bool danger;

  /// Subtítulo (muted, opcional).
  final String? subtitle;

  /// Leading (ícone/avatar), opcional.
  final Widget? leading;

  /// Trailing custom (só no construtor genérico).
  final Widget? trailing;

  /// Ação de toque (genérico/navigation/badge).
  final VoidCallback? onTap;

  /// Estilo do container quando avulso.
  final AppListTileStyle style;

  /// Se está habilitado.
  final bool enabled;

  /// Draggable: índice de reordenamento (adiciona drag handle).
  final int? reorderIndex;

  /// Se o reordenamento está ativo.
  final bool reorderEnabled;

  /// Rótulo de acessibilidade (default: [title]).
  final String? semanticLabel;

  final _TileKind _kind;
  final bool _boolValue;
  final ValueChanged<bool>? _boolChanged;
  final String? _badgeText;
  final AppBadgeColor _badgeRole;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final TileTextColors text = danger
        ? dangerTileTextColors(theme.colorTheme)
        : tileTextColors(theme.colorTheme);

    final Widget? resolvedTrailing;
    final VoidCallback? resolvedTap;
    final TileSemantics sem;

    switch (_kind) {
      case _TileKind.generic:
        resolvedTrailing = trailing;
        resolvedTap = onTap;
        sem = onTap != null ? TileSemantics.button : TileSemantics.none;
      case _TileKind.navigation:
        resolvedTrailing = AppIcon(
          AppIconToken.chevronRight,
          color: text.muted,
          size: AppIconSize.s,
        );
        resolvedTap = onTap;
        sem = TileSemantics.button;
      case _TileKind.checkbox:
        final ValueChanged<bool>? onChanged = _boolChanged;
        resolvedTrailing = AppCheckbox(
          checked: _boolValue,
          enabled: enabled,
          onChanged: onChanged,
        );
        resolvedTap = enabled && onChanged != null
            ? () => onChanged(!_boolValue)
            : null;
        sem = TileSemantics.merge;
      case _TileKind.toggle:
        final ValueChanged<bool>? onChanged = _boolChanged;
        resolvedTrailing = AppSwitch(
          value: _boolValue,
          enabled: enabled,
          onChanged: onChanged,
        );
        resolvedTap = enabled && onChanged != null
            ? () => onChanged(!_boolValue)
            : null;
        sem = TileSemantics.merge;
      case _TileKind.badge:
        resolvedTrailing = AppBadge(_badgeText!, color: _badgeRole);
        resolvedTap = onTap;
        sem = onTap != null ? TileSemantics.button : TileSemantics.none;
    }

    return TileScaffold(
      danger: danger,
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: resolvedTrailing,
      onTap: resolvedTap,
      enabled: enabled,
      style: style,
      reorderIndex: reorderIndex,
      reorderEnabled: reorderEnabled,
      semantics: sem,
      semanticLabel: semanticLabel,
    );
  }
}
