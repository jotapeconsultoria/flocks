import 'package:flutter/widgets.dart';

import '../../atoms/divider/app_divider.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';

/// Card genérico e **estruturado** do flocks.
///
/// Superfície `surfaceContainer` que participa do eixo global de estilo
/// ([AppStyle]) — `filled` (chapado), `outlined` (borda `outline`) ou `elevated`
/// (sombra simétrica) — e do eixo global de forma (`radiusTheme`). Como os
/// demais containers do DS (ex.: `AppExpansionTile`/`AppAlert`), o default
/// **segue o global** `styleTheme.style`; passe [style] para sobrescrever por
/// uso (painéis flutuantes fixam `elevated`).
///
/// Estrutura o conteúdo via slots **opcionais**, todos combináveis:
/// - **Header** (`Padding` + `Row`): [headerLeading] · [headerTitle] ·
///   [headerTrailing]. Aparece se qualquer um dos três for não-nulo.
///   [headerTitle] é renderizado como `titleMedium`/`onSurface` (uma linha, com
///   reticências).
/// - **Conteúdo**: [child] livre.
/// - **Footer**: [footer] livre (ex.: botões de ação).
///
/// Com [showDividers] `true`, um [AppDivider] full-bleed separa as seções
/// presentes (header ↔ conteúdo ↔ footer). Default `false` (só espaçamento).
/// [accentColor] destaca a borda (só no modo `outlined`). [padding] (default
/// `EdgeInsets.all(AppSpacings.s16)`) é aplicado **por seção**; os dividers são
/// full-bleed. Todas as cores vêm do tema → adapta a claro/escuro e às marcas.
///
/// Não intercepta ponteiro: se o card flutua sobre uma *platform view* (ex.: um
/// mapa no web) e o clique não pode vazar, o chamador envolve com o interceptor
/// apropriado — isso não é responsabilidade de um primitivo de design.
///
/// ```dart
/// AppCard(
///   headerTitle: 'Localização',
///   headerTrailing: someAction,
///   child: mapPreview,
/// )
/// ```
final class AppCard extends StatelessWidget {
  /// Cria um [AppCard]. Ao menos uma seção (child/header*/footer) é obrigatória.
  const AppCard({
    this.child,
    this.headerTitle,
    this.headerLeading,
    this.headerTrailing,
    this.footer,
    this.showDividers = false,
    this.accentColor,
    this.padding,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  }) : assert(
         child != null ||
             headerTitle != null ||
             headerLeading != null ||
             headerTrailing != null ||
             footer != null,
         'AppCard precisa de ao menos uma seção (child/header*/footer).',
       );

  /// Conteúdo principal do card (opcional).
  final Widget? child;

  /// Título do header, renderizado como `titleMedium`/`onSurface` (1 linha,
  /// reticências). O header aparece se este ou [headerLeading]/[headerTrailing]
  /// for não-nulo.
  final String? headerTitle;

  /// Widget à esquerda do header (ex.: ícone, avatar).
  final Widget? headerLeading;

  /// Widget à direita do header (ex.: ação, badge, resumo).
  final Widget? headerTrailing;

  /// Rodapé do card (ex.: botões de ação).
  final Widget? footer;

  /// Desenha um [AppDivider] entre as seções presentes. Default `false`.
  final bool showDividers;

  /// Cor da borda de destaque. Quando `null`, usa o token `outline` do tema.
  /// Só tem efeito no estilo `outlined`.
  final Color? accentColor;

  /// Padding aplicado a cada seção. Default `EdgeInsets.all(AppSpacings.s16)`.
  final EdgeInsetsGeometry? padding;

  /// Tratamento de container do eixo global [AppStyle]. `null` (default) segue o
  /// global `styleTheme.style`; passe para sobrescrever só deste card.
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste card (vence o global
  /// `theme.radiusTheme.mode`).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio — vence [radiusMode] e o global.
  final BorderRadius? radius;

  bool get _hasHeader =>
      headerTitle != null || headerLeading != null || headerTrailing != null;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final BorderRadius r =
        radius ?? theme.radiusTheme.resolve(override: radiusMode);
    final AppStyle s = style ?? theme.styleTheme.style;
    final EdgeInsetsGeometry pad =
        padding ?? const EdgeInsets.all(AppSpacings.s16);

    final bool hasHeader = _hasHeader;
    final bool hasChild = child != null;
    final bool hasFooter = footer != null;

    final List<Widget> sections = <Widget>[
      if (hasHeader) Padding(padding: pad, child: _buildHeader(theme, colors)),
      if (showDividers && hasHeader && (hasChild || hasFooter))
        const AppDivider(),
      if (hasChild) Padding(padding: pad, child: child!),
      if (showDividers && hasChild && hasFooter) const AppDivider(),
      if (hasFooter) Padding(padding: pad, child: footer!),
    ];

    // Uma única seção (ex.: painel de overlay só com `child`): sem a `Column`
    // `stretch`, que forçaria largura infinita em contextos sem largura limitada
    // (overlays de menu/dropdown). Múltiplas seções pedem `stretch` (divisórias
    // full-bleed, trailing à direita) e vivem em layouts com largura limitada.
    final Widget body = sections.length == 1
        ? sections.first
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: sections,
          );

    // AppCard fica no fluxo do conteúdo (listas, painéis) → **ignora** o eixo
    // glass global de propósito (senão cards viram translúcidos no meio de uma
    // lista). Superfícies flutuantes que queiram vidro (Menu/Popover/overlays)
    // montam o `AppGlassSurface` por conta própria.
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: styleBoxDecoration(
        style: s,
        isDark: theme.brightness == AppBrightness.dark,
        radius: r,
        // `accentColor` é a cor da borda (só o `outlined` a usa).
        outline: accentColor ?? colors.outline,
        surfaceContainer: colors.surfaceContainer,
        // Fill sempre `surfaceContainer` (mesmo no `outlined`): o painel é opaco.
        ownFill: colors.surfaceContainer,
      ),
      child: body,
    );
  }

  Widget _buildHeader(AppThemeData theme, AppColorTheme colors) {
    return Row(
      spacing: AppSpacings.s16,
      children: <Widget>[
        ?headerLeading,
        Expanded(
          child: headerTitle != null
              ? AppText(
                  headerTitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium.copyWith(
                    color: colors.onSurface,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        ?headerTrailing,
      ],
    );
  }
}
