import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../../tokens/swatch_generator.dart';
import '../interactive/interactive.dart';

/// Papel de cor semântica de um [AppAlert].
enum AppAlertColor {
  /// Erro (vermelho).
  danger,

  /// Informativo (azul) — padrão.
  info,

  /// Ação genérica da marca.
  primary,

  /// Sucesso (verde).
  success,

  /// Atenção (âmbar).
  warning;

  /// Resolve o papel para o seu swatch semântico em [t].
  ColorSwatch<int> resolve(AppColorTheme t) => switch (this) {
    AppAlertColor.danger => t.danger,
    AppAlertColor.info => t.info,
    AppAlertColor.primary => t.primary,
    AppAlertColor.success => t.success,
    AppAlertColor.warning => t.warning,
  };

  /// Ícone default do papel.
  String get icon => switch (this) {
    AppAlertColor.danger => AppIconToken.errorCircle,
    AppAlertColor.info => AppIconToken.infoCircle,
    AppAlertColor.primary => AppIconToken.infoCircle,
    AppAlertColor.success => AppIconToken.checkCircle,
    AppAlertColor.warning => AppIconToken.alert,
  };
}

/// Onde a [AppAlert.action] repousa dentro do card.
enum AppAlertActionPlacement {
  /// Linha própria abaixo do conteúdo, alinhada ao fim (`centerEnd`). Default.
  ///
  /// É a única colocação que não disputa largura com o título de 1 linha: um
  /// botão no rodapé pode ter o tamanho que quiser sem comer o `ellipsis`.
  footer,

  /// Fim da linha do título, depois do ícone semântico.
  ///
  /// Para a faixa compacta, em que a mensagem inteira cabe no título e a ação é
  /// curta ('Assumir', 'Modelos'). Use um botão pequeno aqui: um `l` (56px)
  /// estica a linha do título e desalinha o ícone.
  trailing,
}

/// Card de alerta com título, descrição e ícone semântico — e, quando houver,
/// uma ação, um "×" de dispensar e conteúdo livre.
///
/// Mostra um título (1 linha) e descrição (até [maxLines] linhas) num card
/// sobre `surfaceContainer` levemente tingido pela cor semântica ([color]), com
/// o ícone na mesma cor. O tratamento de container (borda/fill/sombra) segue o
/// eixo [AppStyle] global (`theme.styleTheme`): `outlined` desenha a borda
/// semântica, `elevated` troca a borda por uma sombra, `filled` deixa só o tom
/// tingido — sobrescrevível por instância via [style]. A forma dos cantos segue
/// o modo de raio global ([AppRadiusMode]), com override via [radiusMode]/
/// [radius]. Todas as cores vêm do tema → contraste AA em claro/escuro nas duas
/// marcas. É anunciado por leitores de tela (`liveRegion`) — e [liveRegion]
/// existe justamente para desligar isso quando o alerta é mobília da tela.
///
/// Os eixos globais passados ao card ([style]/[radiusMode]/[radius]) valem para
/// a CAIXA do card e não são repassados aos slots ([action]/[child]): um
/// `AppButton` lá dentro segue o eixo global sozinho, que é o previsível.
///
/// ```dart
/// AppAlert(
///   title: 'Sem conexão',
///   description: 'Verifique sua internet e tente novamente.',
///   color: AppAlertColor.danger,
/// )
/// ```
final class AppAlert extends StatelessWidget {
  /// Cria um [AppAlert].
  const AppAlert({
    required this.title,
    required this.description,
    this.color = AppAlertColor.info,
    this.icon,
    this.action,
    this.actionPlacement = AppAlertActionPlacement.footer,
    this.onDismiss,
    this.dismissSemanticLabel = 'Dispensar',
    this.child,
    this.liveRegion = true,
    this.maxLines = 3,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Título (1 linha, `titleMedium`, `onSurface`).
  final String title;

  /// Descrição (até [maxLines] linhas, `bodyMedium`, neutro legível).
  final String description;

  /// Papel de cor semântica. Default [AppAlertColor.info].
  final AppAlertColor color;

  /// Ícone à direita do título. Default: o ícone do [color].
  final String? icon;

  /// Ação do alerta (botão, link), DENTRO do card. `null` (default) = o alerta
  /// de sempre, sem rodapé nem linha extra.
  ///
  /// É um slot `Widget?` e não um par `actionLabel`/`onAction` porque os casos
  /// reais não cabem num par: um precisa de `loading`, outro é um dropdown +
  /// botão, outro tem duas ações. Mesmo contrato do `AppButton.trailing` e do
  /// `AppListTile.trailing`.
  ///
  /// ```dart
  /// AppAlert(
  ///   title: 'Troca agendada',
  ///   description: 'O novo pacote entra no próximo ciclo.',
  ///   color: AppAlertColor.warning,
  ///   action: AppButton(
  ///     label: 'Cancelar',
  ///     size: AppButtonSize.s,
  ///     style: AppStyle.outlined,
  ///     onPressed: cancelarTroca,
  ///   ),
  /// )
  /// ```
  final Widget? action;

  /// Onde a [action] repousa. Sem efeito quando [action] é `null`.
  final AppAlertActionPlacement actionPlacement;

  /// Dispensar: desenha um "×" no fim da linha do título. `null` (default) =
  /// sem botão de dispensar.
  ///
  /// É um callback puro: o card NÃO some sozinho. Quem controla a visibilidade
  /// é o chamador (`if (visivel) AppAlert(...)`) ou o `showAppOverlay` — o
  /// alerta é só o card, e um `State` de visibilidade aqui disputaria a
  /// animação de saída do overlay.
  final VoidCallback? onDismiss;

  /// Rótulo de acessibilidade do "×". Default `'Dispensar'`.
  final String dismissSemanticLabel;

  /// Conteúdo livre ABAIXO da descrição e ACIMA do rodapé da [action].
  ///
  /// Para o que não é prosa: um valor em destaque, um seletor, uma linha de
  /// campos. Herda o padding e o fundo tingido do card — que é justamente o que
  /// se perde ao montar `Row(Expanded(AppAlert), ...)` por fora.
  final Widget? child;

  /// Se o card é anunciado como região viva (`AppSemantics.liveRegion`).
  /// Default `true` — o comportamento de sempre.
  ///
  /// Passe `false` quando o alerta é MOBÍLIA da tela (uma caixa de configuração
  /// permanente), não uma notícia. Com [action] ou [child] interativos, uma
  /// região viva re-anuncia o card inteiro a cada rebuild da semântica do
  /// filho — um botão entrando em `loading` faria o leitor reler título e
  /// descrição.
  final bool liveRegion;

  /// Teto de linhas da descrição (com `ellipsis`). Default `3` — o desenho de
  /// sempre. `null` remove o teto: o texto corre inteiro, sem truncar.
  final int? maxLines;

  /// Tratamento de container (borda/fill/sombra). Default: o eixo global
  /// `theme.styleTheme.style`. Aditivo sobre o fill tingido do papel.
  final AppStyle? style;

  /// Override do modo de forma (raio) só deste alerta. `null` = segue o modo
  /// global (`theme.radiusTheme`).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio. Vence [radiusMode] e o modo global.
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final ColorSwatch<int> role = color.resolve(colors);
    final AppStyle s = style ?? theme.styleTheme.style;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final BorderRadius br =
        radius ?? theme.radiusTheme.resolve(override: radiusMode);
    // Tinge a superfície elevada com um sussurro da cor semântica (mantém o
    // texto legível: o tom fica quase o de `surfaceContainer`). O fill já é
    // OPACO (alphaBlend sobre `surfaceContainer`), então em `elevated` a sombra
    // não vaza por baixo — dispensa o achatamento condicional do AppBadge.
    final Color fill = Color.alphaBlend(
      role.withValues(alpha: 0.08),
      colors.surfaceContainer,
    );
    // Acento (borda/ícone) resolvido para um stop legível (≥ 3:1) sobre o fundo
    // onde repousa — a base do swatch não garante contraste (RULES §5).
    final Color borderColor = readableStopOn(role, colors.surface);
    final Color iconColor = readableStopOn(role, fill);

    final Widget box = DecoratedBox(
      // O container segue o eixo AppStyle global: filled = só o tom tingido;
      // outlined = tom + borda semântica (o visual histórico); elevated = tom
      // + sombra, sem borda. Como o alerta pinta com DecoratedBox (só-pintura),
      // a borda não desloca o conteúdo — dispensa o truque de borda em
      // foreground que badge/switch usam por desenharem com Container.
      decoration: styleBoxDecoration(
        style: s,
        isDark: isDark,
        radius: br,
        outline: borderColor,
        surfaceContainer: colors.surfaceContainer,
        ownFill: fill,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: AppText(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacings.s16),
                AppIcon(
                  icon ?? color.icon,
                  color: iconColor,
                  size: AppIconSize.m,
                ),
                if (action != null &&
                    actionPlacement ==
                        AppAlertActionPlacement.trailing) ...<Widget>[
                  const SizedBox(width: AppSpacings.s8),
                  action!,
                ],
                if (onDismiss != null) ...<Widget>[
                  const SizedBox(width: AppSpacings.s4),
                  // Alvo PRÓPRIO (a mesma razão do "×" do AppFilterChip):
                  // dispensar e a `action` são coisas diferentes, e um alvo só
                  // faria uma delas por engano. Neutro de propósito — o "×" é
                  // controle, não parte da mensagem.
                  AppInteraction(
                    onTap: onDismiss,
                    semanticLabel: dismissSemanticLabel,
                    radius: BorderRadius.circular(999),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacings.s4),
                      child: AppIcon(
                        AppIconToken.close,
                        color: colors.onSurface.withValues(alpha: 0.72),
                        size: AppIconSize.s,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacings.s8),
            AppText(
              description,
              maxLines: maxLines,
              // Sem teto o texto nunca estoura — clip (o default do AppText) é
              // inerte; com teto, o ellipsis de sempre.
              overflow: maxLines == null
                  ? TextOverflow.clip
                  : TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium.copyWith(
                color: colors.neutralPrimary.s700,
              ),
            ),
            if (child != null) ...<Widget>[
              const SizedBox(height: AppSpacings.s12),
              child!,
            ],
            if (action != null &&
                actionPlacement == AppAlertActionPlacement.footer) ...<Widget>[
              const SizedBox(height: AppSpacings.s12),
              Align(alignment: AlignmentDirectional.centerEnd, child: action!),
            ],
          ],
        ),
      ),
    );
    return liveRegion ? AppSemantics.liveRegion(box) : box;
  }
}
