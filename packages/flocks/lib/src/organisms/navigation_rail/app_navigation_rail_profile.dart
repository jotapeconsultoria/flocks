import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../molecules/interactive/interactive.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_navigation_rail.dart';

const _animationCurve = AppCurves.standard;
const _animationDuration = AppDurations.medium;

/// Inset horizontal do conteúdo, alinhando o avatar ao ícone dos tiles do rail
/// (margem `s16` + padding interno `_innerPadding`).
const _innerPadding = 12.0;

/// Linha de perfil para o slot de footer do [AppNavigationRail]: avatar +
/// título/subtítulo + trailing (chevron por padrão). Clicável via
/// [AppInteraction]. No modo colapsado mostra só o avatar — lê o estado
/// colapsado do [AppNavigationRailScope] ancestral (ou de [isCollapsed]).
final class AppNavigationRailProfile extends StatelessWidget {
  const AppNavigationRailProfile({
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.initials,
    this.trailing,
    this.onTap,
    this.isCollapsed,
    super.key,
  });

  /// Nome exibido (linha principal).
  final String title;

  /// Papel/segunda linha (opcional).
  final String? subtitle;

  /// URL da foto do usuário (opcional; sem ela mostra [initials]).
  final String? imageUrl;

  /// Iniciais de fallback quando não há [imageUrl].
  final String? initials;

  /// Widget à direita. `null` usa um chevron para baixo.
  final Widget? trailing;

  /// Callback ao tocar a linha.
  final VoidCallback? onTap;

  /// Força o modo colapsado. `null` = lê do [AppNavigationRailScope].
  final bool? isCollapsed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final collapsed =
        isCollapsed ?? AppNavigationRailScope.isCollapsedOf(context);
    final muted = theme.colorTheme.neutralPrimary.s600;

    final avatar = AppAvatar(
      size: AppAvatarSize.s,
      imageUrl: imageUrl,
      fallback: initials,
      semanticLabel: title,
    );

    final Widget trailingWidget =
        trailing ??
        AppIcon(AppIconToken.chevronDown, color: muted, size: AppIconSize.s);

    final row = Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        avatar,
        Expanded(
          child: _AnimatedReveal(
            isCollapsed: collapsed,
            spacing: AppSpacings.s12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: theme.textTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  AppText(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: theme.textTheme.bodySmall.withColor(muted),
                  ),
              ],
            ),
          ),
        ),
        _AnimatedReveal(
          isCollapsed: collapsed,
          spacing: AppSpacings.s8,
          child: trailingWidget,
        ),
      ],
    );

    return SelectionContainer.disabled(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s16,
          vertical: AppSpacings.s2,
        ),
        child: AppInteraction(
          onTap: onTap,
          semanticLabel: subtitle == null || subtitle!.isEmpty
              ? title
              : '$title, $subtitle',
          padding: const EdgeInsets.symmetric(
            horizontal: _innerPadding,
            vertical: AppSpacings.s8,
          ),
          child: row,
        ),
      ),
    );
  }
}

/// Colapsa/expande um trecho horizontal (largura + opacidade + espaçamento à
/// esquerda) espelhando a animação de label/trailing dos tiles do rail.
final class _AnimatedReveal extends StatelessWidget {
  const _AnimatedReveal({
    required this.isCollapsed,
    required this.spacing,
    required this.child,
  });

  final bool isCollapsed;
  final double spacing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: _animationCurve,
      duration: AppMotion.resolve(context, _animationDuration),
      tween: Tween<double>(begin: 0, end: isCollapsed ? 0 : 1),
      child: child,
      builder: (context, value, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Opacity(
              opacity: value,
              child: Padding(
                padding: EdgeInsets.only(left: spacing * value),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
