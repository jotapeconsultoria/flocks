import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../../atoms/divider/app_divider.dart';
import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../../tokens/contrast.dart';
import '../../tokens/swatch_generator.dart';
import '../card/anchored_overlay.dart';
import '../card/app_overlay_panel.dart';

/// Uma entrada de um [AppMenu]: item, seção ou divisória.
sealed class AppMenuEntry {
  const AppMenuEntry();
}

/// Uma ação clicável do menu.
final class AppMenuItem extends AppMenuEntry {
  /// Cria um [AppMenuItem].
  const AppMenuItem({
    required this.label,
    this.danger = false,
    this.enabled = true,
    this.icon,
    this.onPressed,
    this.selected = false,
    this.subtitle,
  });

  /// Ação destrutiva (pinta em `danger`).
  final bool danger;

  /// Se está habilitado.
  final bool enabled;

  /// URL do ícone (opcional), ex.: `AppIconToken.copy`.
  final String? icon;

  /// Rótulo da ação.
  final String label;

  /// Ação ao selecionar. `null` (ou [enabled] `false`) desabilita o item.
  final VoidCallback? onPressed;

  /// Se representa a opção selecionada atualmente.
  final bool selected;

  /// Segunda linha opcional — a prévia de conteúdo (o texto da resposta
  /// rápida, o detalhe do atalho). Até 2 linhas com ellipsis, no neutro do
  /// chrome do menu; entra no rótulo semântico junto do [label].
  final String? subtitle;
}

/// Um grupo de [AppMenuItem]s com um [title] opcional.
final class AppMenuSection extends AppMenuEntry {
  /// Cria um [AppMenuSection].
  const AppMenuSection({required this.items, this.title});

  /// Título da seção (opcional).
  final String? title;

  /// Itens da seção.
  final List<AppMenuItem> items;
}

/// Uma divisória entre entradas do menu.
final class AppMenuDivider extends AppMenuEntry {
  /// Cria um [AppMenuDivider].
  const AppMenuDivider();
}

/// Controla um [AppMenu] de forma programática.
final class AppMenuController {
  VoidCallback? _open;
  VoidCallback? _close;
  bool Function()? _isOpen;

  /// Se o menu está aberto.
  bool get isOpen => _isOpen?.call() ?? false;

  /// Abre o menu.
  void open() => _open?.call();

  /// Fecha o menu.
  void close() => _close?.call();

  /// Abre se fechado; fecha se aberto.
  void toggle() => isOpen ? close() : open();

  void _attach({
    required VoidCallback open,
    required VoidCallback close,
    required bool Function() isOpen,
  }) {
    _open = open;
    _close = close;
    _isOpen = isOpen;
  }

  void _detach() {
    _open = null;
    _close = null;
    _isOpen = null;
  }
}

/// Menu de **ações** ancorado a um [trigger] (popup / context menu).
///
/// Diferente do [AppDropdown] (que é um *select* de formulário): o [AppMenu]
/// mostra uma lista de ações ([AppMenuItem]) com ícone opcional, seções
/// ([AppMenuSection]), divisórias ([AppMenuDivider]) e itens destrutivos. Abre
/// no clique do [trigger] (e no clique-direito quando [openOnSecondaryTap]),
/// fecha ao selecionar uma ação, clicar fora ou no `Esc`. Navegação por teclado
/// (Tab e setas) via `FocusTraversalGroup`.
///
/// O [trigger] deve ser **conteúdo passivo** (ícone/texto/box) — o menu é quem o
/// torna acionável.
///
/// ```dart
/// AppMenu(
///   trigger: AppIcon(AppIconToken.settings, semanticLabel: 'Ações'),
///   entries: <AppMenuEntry>[
///     AppMenuItem(label: 'Editar', icon: AppIconToken.settings, onPressed: edit),
///     AppMenuDivider(),
///     AppMenuItem(label: 'Excluir', icon: AppIconToken.cancel, danger: true, onPressed: remove),
///   ],
/// )
/// ```
final class AppMenu extends StatefulWidget {
  /// Cria um [AppMenu].
  const AppMenu({
    required this.trigger,
    required this.entries,
    this.placement = AppOverlayPlacement.bottomStart,
    this.openOnSecondaryTap = false,
    this.minWidth = 176,
    this.style,
    this.glass,
    this.radiusMode,
    this.radius,
    this.controller,
    this.onOpenChanged,
    super.key,
  });

  /// Conteúdo passivo que ancora o menu.
  final Widget trigger;

  /// Entradas do menu (itens, seções, divisórias).
  final List<AppMenuEntry> entries;

  /// Posição do painel em relação ao trigger.
  final AppOverlayPlacement placement;

  /// Se também abre no clique-direito / long-press (menu de contexto).
  final bool openOnSecondaryTap;

  /// Largura mínima do painel.
  final double minWidth;

  /// Tratamento de container do painel no eixo [AppStyle], no render **não-glass**.
  /// `null` (default) = [AppStyle.elevated] (sombra) — o overlay não segue o
  /// global `styleTheme`.
  final AppStyle? style;

  /// Override do eixo glass só deste menu. `null` segue o global
  /// (`theme.glassTheme.enabled`); quando ligado, o painel vira vidro real.
  final bool? glass;

  /// Sobrescreve o modo de forma do painel (e dos itens) — vence o global
  /// `theme.radiusTheme.mode`.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio do painel — vence [radiusMode] e o global.
  final BorderRadius? radius;

  /// Controlador programático (opcional).
  final AppMenuController? controller;

  /// Notifica aberturas/fechamentos.
  final ValueChanged<bool>? onOpenChanged;

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  final AnchoredOverlayController _overlay = AnchoredOverlayController();

  @override
  void initState() {
    super.initState();
    _overlay.addListener(_notify);
    widget.controller?._attach(
      open: _open,
      close: _close,
      isOpen: () => _overlay.isOpen,
    );
  }

  @override
  void dispose() {
    _overlay.removeListener(_notify);
    widget.controller?._detach();
    _overlay.dispose();
    super.dispose();
  }

  void _notify() => widget.onOpenChanged?.call(_overlay.isOpen);

  void _open() {
    if (_overlay.isOpen) return;
    _overlay.open(context, placement: widget.placement, builder: _panel);
  }

  void _close() => _overlay.close();

  void _toggle() => _overlay.isOpen ? _close() : _open();

  void _select(AppMenuItem item) {
    item.onPressed?.call();
    _close();
  }

  Widget _panel(BuildContext context) {
    final List<Widget> rows = <Widget>[];
    for (final AppMenuEntry entry in widget.entries) {
      switch (entry) {
        case AppMenuDivider():
          rows.add(
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacings.s8,
                vertical: AppSpacings.s4,
              ),
              child: AppDivider(),
            ),
          );
        case AppMenuSection(
          :final String? title,
          :final List<AppMenuItem> items,
        ):
          if (title != null) rows.add(_SectionTitle(title: title));
          for (final AppMenuItem item in items) {
            rows.add(
              _MenuItemRow(
                item: item,
                radiusMode: widget.radiusMode,
                onSelected: () => _select(item),
              ),
            );
          }
        case AppMenuItem item:
          rows.add(
            _MenuItemRow(
              item: item,
              radiusMode: widget.radiusMode,
              onSelected: () => _select(item),
            ),
          );
      }
    }

    const EdgeInsets menuPad = EdgeInsets.symmetric(vertical: AppSpacings.s4);
    final Widget inner = ConstrainedBox(
      constraints: BoxConstraints(minWidth: widget.minWidth),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        ),
      ),
    );

    // Eixo glass: o painel vira vidro real quando ligado, senão cai no card
    // opaco `elevated` (painel flutuante mantém profundidade sob qualquer global).
    final Widget body = AppOverlayPanel(
      glass: widget.glass,
      style: widget.style,
      radiusMode: widget.radiusMode,
      radius: widget.radius,
      padding: menuPad,
      child: inner,
    );

    // Setas ↑/↓ navegam entre os itens (Tab também, via FocusTraversalGroup do
    // AnchoredOverlay). Registramos a ação explicitamente (não dependemos das
    // ações default do WidgetsApp).
    final Widget navigable = Actions(
      actions: <Type, Action<Intent>>{
        DirectionalFocusIntent: DirectionalFocusAction(),
      },
      child: Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(
            TraversalDirection.down,
          ),
          SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(
            TraversalDirection.up,
          ),
        },
        child: body,
      ),
    );

    return AppAppear(child: AppSemantics.menu(child: navigable));
  }

  @override
  Widget build(BuildContext context) {
    Widget anchored = CompositedTransformTarget(
      link: _overlay.link,
      child: FlocksInteraction(
        onPressed: _toggle,
        onLongPress: widget.openOnSecondaryTap ? _open : null,
        builder: (BuildContext context, Set<WidgetState> _) => widget.trigger,
      ),
    );
    if (widget.openOnSecondaryTap) {
      anchored = GestureDetector(onSecondaryTap: _open, child: anchored);
    }
    return TapRegion(groupId: _overlay.groupId, child: anchored);
  }
}

/// Título de uma seção do menu.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.s12,
        AppSpacings.s8,
        AppSpacings.s12,
        AppSpacings.s4,
      ),
      child: AppText(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall.copyWith(
          color: theme.colorTheme.neutralPrimary.s600,
        ),
      ),
    );
  }
}

/// Uma linha de ação do menu (ícone opcional + rótulo; hover/foco neutro).
class _MenuItemRow extends StatelessWidget {
  const _MenuItemRow({
    required this.item,
    required this.onSelected,
    this.radiusMode,
  });

  final AppMenuItem item;
  final VoidCallback onSelected;
  final AppRadiusMode? radiusMode;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool enabled = item.enabled && item.onPressed != null;

    final Color base = item.danger
        ? readableStopOn(colors.danger, colors.surfaceContainer, minRatio: 4.5)
        : colors.onSurface;
    final Color content = enabled
        ? base
        : mutedForDisabled(base, colors.surfaceContainer);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s4),
      child: AppSemantics.menuItem(
        label: item.subtitle == null
            ? item.label
            : '${item.label}, ${item.subtitle}',
        enabled: enabled,
        onTap: enabled ? onSelected : null,
        child: SelectionContainer.disabled(
          child: FlocksInteraction(
            onPressed: enabled ? onSelected : null,
            enabled: enabled,
            builder: (BuildContext context, Set<WidgetState> states) {
              final bool highlight =
                  states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused);
              return AnimatedContainer(
                duration: AppMotion.resolve(context, AppDurations.fast),
                curve: AppCurves.standard,
                decoration: BoxDecoration(
                  borderRadius: theme.radiusTheme.resolve(override: radiusMode),
                  color: highlight
                      ? colors.onSurface.withValues(alpha: 0.08)
                      : colors.transparent,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacings.s12,
                  vertical: AppSpacings.s8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (item.icon != null) ...<Widget>[
                      AppIcon(item.icon!, size: AppIconSize.s, color: content),
                      const SizedBox(width: AppSpacings.s8),
                    ],
                    Expanded(
                      child: item.subtitle == null
                          ? AppText(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium.copyWith(
                                color: content,
                                fontWeight: item.selected
                                    ? FontWeight.bold
                                    : null,
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AppText(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium.copyWith(
                                    color: content,
                                    fontWeight: item.selected
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                ),
                                // O mesmo par do chrome de seção do menu
                                // (labelSmall + s600), esmaecido junto com o
                                // label quando desabilitado.
                                AppText(
                                  item.subtitle!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall.copyWith(
                                    color: enabled
                                        ? colors.neutralPrimary.s600
                                        : mutedForDisabled(
                                            colors.neutralPrimary.s600,
                                            colors.surfaceContainer,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
