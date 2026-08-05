import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Autor de uma mensagem de chat — dirige o **alinhamento** e o **tint padrão**
/// da bolha.
///
/// - [me]: mensagem do próprio usuário → alinhada à direita, com fundo tingido
///   pelo papel de cor ([AppChatBubbleColor]).
/// - [other]: mensagem do interlocutor (assistente, contato) → alinhada à
///   esquerda, sobre `surfaceContainer` (uma superfície elevada por tom).
enum AppChatAuthor {
  /// O próprio usuário (direita, tingida).
  me,

  /// O interlocutor (esquerda, superfície).
  other,
}

/// Papel de cor do **tint** da bolha do próprio autor ([AppChatAuthor.me]).
///
/// O tint é uma versão translúcida do papel sobre a superfície — mantém
/// contraste em claro/escuro e acompanha a marca. Ignorado para
/// [AppChatAuthor.other] (que usa `surfaceContainer`).
enum AppChatBubbleColor {
  /// Papel primário (marca).
  primary,

  /// Papel secundário.
  secondary,

  /// Papel terciário.
  tertiary,

  /// Neutro — o conteúdo (`onSurface`) a baixa opacidade.
  neutral;

  /// Resolve o papel para a sua cor-base em [t] (usada como tint translúcido).
  Color resolve(AppColorTheme t) => switch (this) {
    AppChatBubbleColor.primary => t.primary,
    AppChatBubbleColor.secondary => t.secondary,
    AppChatBubbleColor.tertiary => t.tertiary,
    AppChatBubbleColor.neutral => t.onSurface,
  };

  /// Acento **legível** do papel sobre a superfície ([readableStopOn]) — para a
  /// borda do `outlined`: a base de `primary`/`tertiary` é escura demais no tema
  /// escuro e a borda sumia. `neutral` já é conteúdo legível (`onSurface`).
  Color accentOn(AppColorTheme t) => switch (this) {
    AppChatBubbleColor.primary => readableStopOn(t.primary, t.surface),
    AppChatBubbleColor.secondary => readableStopOn(t.secondary, t.surface),
    AppChatBubbleColor.tertiary => readableStopOn(t.tertiary, t.surface),
    AppChatBubbleColor.neutral => t.onSurface,
  };
}

/// Canto reto ("orelhinha"/tail) da bolha, no lado do autor.
///
/// Espelha o WhatsApp: a bolha é totalmente arredondada, exceto por **um** canto
/// reto no lado de quem falou, que aponta para o avatar.
enum AppChatBubbleTail {
  /// Todos os cantos arredondados (bolha "solta"/agrupada).
  none,

  /// Canto reto no **topo** do lado do autor (primeira bolha de um grupo).
  top,

  /// Canto reto na **base** do lado do autor (tail clássico do WhatsApp).
  bottom,
}

/// Bolha de mensagem do Flocks — o átomo visual de qualquer conversa (LLM ou
/// estilo WhatsApp).
///
/// É **agnóstica de conteúdo**: recebe um [child] arbitrário (texto, markdown,
/// imagem, tabela — o app injeta o que quiser, inclusive widgets que vivem fora
/// do design system). Cuida só da "casca": alinhamento por [author], tint/
/// superfície, cantos (incl. o [tail] assimétrico), largura máxima e os slots
/// opcionais [header] (nome do remetente) e [footer] (meta — ver
/// `AppMessageMeta`).
///
/// Participa dos eixos globais: [style] (filled/outlined/elevated via
/// [resolveStyleDecoration]), forma ([radiusMode]/[radius]) e tema (cores 100%
/// do [AppTheme]).
///
/// ```dart
/// AppChatBubble(
///   author: AppChatAuthor.me,
///   footer: const AppMessageMeta(time: '10:32', status: AppMessageStatus.read),
///   child: const AppText('Bora rastrear!'),
/// )
/// ```
final class AppChatBubble extends StatelessWidget {
  /// Cria uma [AppChatBubble] em torno de [child].
  const AppChatBubble({
    required this.child,
    this.author = AppChatAuthor.other,
    this.color = AppChatBubbleColor.primary,
    this.header,
    this.footer,
    this.tail = AppChatBubbleTail.top,
    this.style,
    this.radiusMode,
    this.radius,
    this.background,
    this.maxWidthFraction = 0.78,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacings.s16,
      vertical: AppSpacings.s8,
    ),
    this.semanticLabel,
    super.key,
  }) : assert(
         maxWidthFraction > 0 && maxWidthFraction <= 1,
         'maxWidthFraction deve estar em (0, 1].',
       );

  /// Conteúdo da bolha (agnóstico — texto, markdown, imagem…).
  final Widget child;

  /// Quem enviou a mensagem — dirige alinhamento e tint. Default
  /// [AppChatAuthor.other].
  final AppChatAuthor author;

  /// Papel de cor do tint da bolha do próprio autor ([AppChatAuthor.me]).
  /// Ignorado para [AppChatAuthor.other]. Default [AppChatBubbleColor.primary].
  final AppChatBubbleColor color;

  /// Slot superior opcional (ex.: nome do remetente em conversas de grupo).
  final Widget? header;

  /// Slot inferior opcional (ex.: `AppMessageMeta` com horário + status).
  final Widget? footer;

  /// Canto reto ("orelhinha") no lado do autor. Default [AppChatBubbleTail.top].
  final AppChatBubbleTail tail;

  /// Estilo de container (borda/fundo/sombra). Default: global
  /// (`theme.styleTheme.style`). Aditivo sobre o tint/superfície.
  final AppStyle? style;

  /// Override local do modo de forma (`radiusMode`) — vence o global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio-base dos cantos (px). Vence [radiusMode] e o global.
  final double? radius;

  /// Sobrescreve a cor de fundo da bolha (vence tint/superfície).
  final Color? background;

  /// Fração da largura disponível que a bolha pode ocupar. Default `0.78`.
  final double maxWidthFraction;

  /// Espaço interno entre a borda da bolha e o conteúdo.
  final EdgeInsetsGeometry padding;

  /// Rótulo semântico da mensagem (ex.: "Você: Bora rastrear, 10:32, lido").
  /// `null` = deixa a semântica do [child]/[footer] fluir.
  final String? semanticLabel;

  bool get _isMe => author == AppChatAuthor.me;

  BorderRadius _resolveRadius(AppThemeData theme) {
    final double r =
        radius ?? theme.radiusTheme.tileRadius(radiusMode).topLeft.x;
    final Radius full = Radius.circular(r);
    const Radius flat = Radius.zero;

    Radius topLeft = full;
    Radius topRight = full;
    Radius bottomLeft = full;
    Radius bottomRight = full;

    switch (tail) {
      case AppChatBubbleTail.none:
        break;
      case AppChatBubbleTail.top:
        if (_isMe) {
          topRight = flat;
        } else {
          topLeft = flat;
        }
      case AppChatBubbleTail.bottom:
        if (_isMe) {
          bottomRight = flat;
        } else {
          bottomLeft = flat;
        }
    }

    return BorderRadius.only(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final AppStyle s = style ?? theme.styleTheme.style;
    final Color roleColor = color.resolve(colors);
    final BorderRadius br = _resolveRadius(theme);

    // Fill próprio: `me` = papel a 14% (sólido no elevated, senão a sombra
    // vazaria por baixo, igual ao AppBadge); `other` = surfaceContainer.
    final Color ownFill;
    if (_isMe) {
      final Color tint = roleColor.customOpacity(0.14);
      ownFill = s == AppStyle.elevated
          ? Color.alphaBlend(tint, colors.surfaceContainer)
          : tint;
    } else {
      ownFill = colors.surfaceContainer;
    }

    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: isDark,
      // A borda (outlined) do `me` usa o acento legível do papel; a do `other`,
      // o outline neutro.
      outline: _isMe ? color.accentOn(colors) : colors.outline,
      surfaceContainer: colors.surfaceContainer,
      ownFill: ownFill,
      background: background,
    );

    final Widget content = Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: _isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          if (header != null) ...<Widget>[
            header!,
            const SizedBox(height: AppSpacings.s4),
          ],
          child,
          if (footer != null) ...<Widget>[
            const SizedBox(height: AppSpacings.s4),
            footer!,
          ],
        ],
      ),
    );

    // Cor de texto padrão legível sobre o fill (o child pode ser um `Text` cru
    // sem cor). AppText com cor explícita continua vencendo.
    final Widget bubble = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: deco.color,
        border: deco.border,
        boxShadow: deco.boxShadow,
        borderRadius: br,
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: colors.onSurface),
        child: content,
      ),
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Widget result = bubble;
        if (constraints.hasBoundedWidth) {
          result = Align(
            alignment: _isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * maxWidthFraction,
              ),
              child: bubble,
            ),
          );
        }
        if (semanticLabel != null) {
          result = AppSemantics.label(label: semanticLabel!, child: result);
        }
        return result;
      },
    );
  }
}
