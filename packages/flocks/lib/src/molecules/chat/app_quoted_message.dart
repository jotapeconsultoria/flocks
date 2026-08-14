import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../interactive/interactive.dart';
import 'app_chat_bubble.dart';

/// Bloco de **citação** de uma mensagem — autor + prévia + miniatura opcional.
///
/// O par que faltava no subsistema de chat: dentro da bolha (a mensagem
/// respondida, estilo WhatsApp) e no composer (a prévia de "respondendo a…",
/// com [onRemove] para cancelar). Anatomia: barra de acento vertical, autor
/// tingido pelo mesmo acento, prévia esmaecida, miniatura na borda.
///
/// A cor segue o [AppChatBubbleColor] que a conversa já usa: `accentOn`
/// (legível sobre a superfície) pinta a barra e o autor; `resolve` a **10%**
/// tinge o fundo — translúcido de propósito, e um degrau ABAIXO dos 14% da
/// bolha, porque a citação vive DENTRO de uma superfície já tingida e precisa
/// ler como camada aninhada, não como segunda bolha.
///
/// [onTap] (pular para a original) faz o corpo inteiro virar UM alvo nomeado.
/// [onRemove] acrescenta um "×" como alvo PRÓPRIO — idioma do [AppFilterChip]:
/// cancelar a citação e navegar até ela são ações diferentes, e um alvo só
/// faria a errada acontecer por engano.
///
/// ```dart
/// AppChatBubble(
///   author: AppChatAuthor.me,
///   header: AppQuotedMessage(
///     author: 'Ana',
///     excerpt: 'Consegue mandar o relatório de ontem?',
///     onTap: () => scrollTo(original),
///   ),
///   child: const Text('Mandando agora!'),
/// )
/// ```
final class AppQuotedMessage extends StatelessWidget {
  /// Cria um [AppQuotedMessage].
  const AppQuotedMessage({
    required this.excerpt,
    this.author,
    this.thumbnail,
    this.color = AppChatBubbleColor.primary,
    this.onTap,
    this.onRemove,
    this.maxLines = 2,
    this.semanticLabel,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Prévia da mensagem citada. Trunca com elipse em [maxLines]; quem limpa
  /// markdown/quebras é o chamador.
  final String excerpt;

  /// Quem escreveu a mensagem citada ('Você', o nome do contato). `null`
  /// oculta a linha do autor (citação anônima/de sistema).
  final String? author;

  /// Miniatura (foto/preview do anexo citado), recortada em cover na borda do
  /// fim. `null` = só texto. Decorativa para o leitor de tela — a prévia
  /// textual é a informação.
  final ImageProvider? thumbnail;

  /// Papel de cor do acento/tint. Reusa o enum da bolha para a citação casar
  /// com a conversa. Default [AppChatBubbleColor.primary].
  final AppChatBubbleColor color;

  /// Toque no corpo (pular para a mensagem original). `null` = não tappável.
  final VoidCallback? onTap;

  /// Cancela/remove a citação (o caso composer). `null` = sem "×". Quando
  /// presente, o "×" é alvo próprio, separado do corpo.
  final VoidCallback? onRemove;

  /// Máximo de linhas da prévia (elipse). Default `2`.
  final int maxLines;

  /// Rótulo do alvo do corpo. Default: `'Mensagem citada de {author}'`, ou
  /// `'Ver mensagem citada'` sem autor. Sem [onTap], substitui a semântica
  /// dos textos (via [AppSemantics.label]) quando informado.
  final String? semanticLabel;

  /// Estilo de container (filled/outlined/elevated). Default: global.
  final AppStyle? style;

  /// Override local do modo de forma. Vence o global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (px). Vence [radiusMode] e o global.
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final AppStyle s = style ?? theme.styleTheme.style;
    final BorderRadius br = radius != null
        ? BorderRadius.circular(radius!)
        : theme.radiusTheme.resolve(override: radiusMode);
    final Color accent = color.accentOn(colors);

    // Fundo: papel a 10% (um degrau abaixo dos 14% da bolha — camada aninhada);
    // sólido no `elevated`, senão a sombra vazaria por baixo (molde da bolha).
    final Color tint = color.resolve(colors).customOpacity(0.10);
    final Color ownFill = s == AppStyle.elevated
        ? Color.alphaBlend(tint, colors.surfaceContainer)
        : tint;

    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: isDark,
      // A borda do `outlined` usa o próprio acento (molde da bolha `me`) —
      // outline cinza sobre o tint sujaria a citação.
      outline: accent,
      surfaceContainer: colors.surfaceContainer,
      ownFill: ownFill,
    );

    final Widget texts = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (author case final String a) ...<Widget>[
          AppText(
            a,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium.withColor(accent),
          ),
          const SizedBox(height: AppSpacings.s2),
        ],
        AppText(
          excerpt,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall.withColor(
            colors.onSurface.customOpacity(0.72),
          ),
        ),
      ],
    );

    final Widget body = IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // A barra de acento — esticada, recortada pelos cantos do clip.
          ColoredBox(
            color: accent,
            child: const SizedBox(width: AppStrokes.l),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacings.s8),
              child: texts,
            ),
          ),
          if (thumbnail case final ImageProvider t)
            AppSemantics.decorative(
              SizedBox(
                width: AppSizes.s48,
                child: Image(image: t, fit: BoxFit.cover),
              ),
            ),
        ],
      ),
    );

    final String tapLabel =
        semanticLabel ??
        (author == null ? 'Ver mensagem citada' : 'Mensagem citada de $author');

    final Widget tappable = onTap != null
        ? AppInteraction(
            onTap: onTap,
            radius: br,
            semanticLabel: tapLabel,
            child: body,
          )
        : body;

    Widget result = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: deco.color,
        border: deco.border,
        boxShadow: deco.boxShadow,
        borderRadius: br,
      ),
      child: onRemove == null
          ? tappable
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(child: tappable),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacings.s8,
                  ),
                  child: _removeButton(colors),
                ),
              ],
            ),
    );

    if (onTap == null && semanticLabel != null) {
      result = AppSemantics.label(label: semanticLabel!, child: result);
    }
    return result;
  }

  /// "×" clicável sem fundo — molde literal do [AppChatAttachmentChip].
  Widget _removeButton(AppColorTheme colors) => AppInteraction(
    onTap: onRemove,
    semanticLabel: 'Remover citação',
    radius: BorderRadius.circular(999),
    padding: const EdgeInsets.all(AppSpacings.s2),
    child: AppIcon(
      AppIconToken.close,
      color: colors.onSurface.customOpacity(0.6),
      customSize: 16,
    ),
  );
}
