import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Item de ação para listas de opções/menus: ícone + texto.
///
/// Superfície tingida (por padrão, `primary.s50`) e clicável. [direction]
/// horizontal (default) põe o ícone à esquerda do texto; vertical empilha o
/// ícone acima do rótulo — a célula da grade de opções em folha — com o MESMO
/// padding, raio e cores. Participa do eixo global de estilo ([AppStyle]) e de
/// forma ([AppRadiusMode]); todas as cores vêm do tema → adapta a claro/escuro
/// e às marcas.
///
/// ```dart
/// AppActionItem(
///   icon: AppIconToken.support,
///   text: 'Suporte',
///   onPressed: openSupport,
/// )
/// ```
final class AppActionItem extends StatelessWidget {
  /// Cria um [AppActionItem].
  const AppActionItem({
    required this.icon,
    required this.onPressed,
    required this.text,
    this.direction = Axis.horizontal,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Ícone exibido à esquerda (horizontal) ou acima (vertical) do texto.
  final String icon;

  /// Orientação do item. Default [Axis.horizontal] — a linha de sempre.
  /// [Axis.vertical] empilha ícone sobre rótulo, centrados.
  final Axis direction;

  /// Callback executado ao pressionar o item.
  final VoidCallback onPressed;

  /// Texto exibido à direita do ícone.
  final String text;

  /// Tratamento de container ([AppStyle]). `null` segue o global.
  final AppStyle? style;

  /// Override do modo de forma. `null` segue o global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio. Vence [radiusMode] e o global.
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final AppStyle s = style ?? theme.styleTheme.style;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final BorderRadius br =
        radius ?? theme.radiusTheme.resolve(override: radiusMode);

    return SelectionContainer.disabled(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: DecoratedBox(
            decoration: styleBoxDecoration(
              style: s,
              isDark: isDark,
              radius: br,
              outline: colors.outline,
              surfaceContainer: colors.surfaceContainer,
              ownFill: colors.primary.s50,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacings.s16),
              child: _content(theme, colors),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(AppThemeData theme, AppColorTheme colors) {
    final Widget iconWidget = AppIcon(
      icon,
      color: readableStopOn(colors.secondary, colors.surface),
      size: AppIconSize.m,
    );
    final TextStyle textStyle = theme.textTheme.bodyLarge.copyWith(
      color: colors.neutralPrimary.s900,
    );

    if (direction == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacings.s8,
        children: <Widget>[
          iconWidget,
          AppText(
            text,
            maxLines: 1,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            semanticLabel: text,
            style: textStyle,
          ),
        ],
      );
    }

    return Row(
      spacing: AppSpacings.s8,
      children: <Widget>[
        iconWidget,
        Expanded(
          child: AppText(
            text,
            maxLines: 1,
            overflow: TextOverflow.clip,
            semanticLabel: text,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
