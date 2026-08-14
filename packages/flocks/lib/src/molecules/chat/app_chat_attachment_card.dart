import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../interactive/interactive.dart';
import 'app_attachment_kind.dart';

/// Disposição de um [AppChatAttachmentCard].
enum AppChatAttachmentCardLayout {
  /// Cartão quadrado ([AppChatAttachmentCard.size] de lado) — o default.
  square,

  /// Bloco horizontal: leading (thumb ou ícone tingido) + nome + subtítulo,
  /// com o X de remover em linha. Largura `2 × size`, altura do conteúdo.
  row,
}

/// Card de anexo — a alternativa "cartão" ao `AppChatAttachmentChip`
/// (mesma informação, formato maior, estilo dos anexos do Claude).
///
/// No layout **quadrado** (default), mostra a **thumbnail** da imagem
/// preenchendo o card (com o nome sobreposto), ou um **ícone grande** tingido
/// pela categoria ([AppAttachmentKind], resolvida da extensão de [label]) com o
/// nome abaixo. No layout **row**, vira um bloco horizontal — thumb/ícone à
/// esquerda, nome + [subtitle] ao lado, X em linha — para a bolha de arquivo e
/// o cartão rico. A fronteira com o chip: o `AppChatAttachmentChip` é a pílula
/// compacta de 1 linha para faixas densas; o card-row é o bloco horizontal
/// rico, com subtítulo e alvo maior. [onTap] visualiza; [onRemove] mostra um X
/// clicável (sem fundo). Participa do eixo [style] (filled/outlined/elevated) e
/// de forma ([radiusMode]/[radius]).
///
/// ```dart
/// AppChatAttachmentCard(image: MemoryImage(bytes), label: 'foto.png', onTap: _view, onRemove: _rm)
/// AppChatAttachmentCard(label: 'relatorio.pdf', subtitle: 'PDF', onRemove: _rm)
/// ```
final class AppChatAttachmentCard extends StatelessWidget {
  /// Cria um card de anexo.
  const AppChatAttachmentCard({
    this.image,
    this.label,
    this.kind,
    this.icon,
    this.subtitle,
    this.onTap,
    this.onRemove,
    this.size = 104,
    this.layout = AppChatAttachmentCardLayout.square,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Thumbnail da imagem. `null` → card de ícone.
  final ImageProvider? image;

  /// Nome do arquivo. Dirige o ícone/tom quando [kind]/[icon] são nulos.
  final String? label;

  /// Categoria do anexo. `null` = resolvida de [label].
  final AppAttachmentKind? kind;

  /// Ícone explícito. `null` = resolvido da extensão de [label].
  final String? icon;

  /// Subtítulo opcional (ex.: "PDF", "240 KB"). No quadrado, só no card de
  /// ícone; no [AppChatAttachmentCardLayout.row], vale também com imagem.
  final String? subtitle;

  /// Abre/visualiza o anexo. `null` = não tappável.
  final VoidCallback? onTap;

  /// Remove o anexo. `null` = sem botão de remover.
  final VoidCallback? onRemove;

  /// Lado do card (px) no quadrado. Default 104. No layout `row` vira o fator
  /// de escala: a largura é `2 × size` e a altura vem do conteúdo.
  final double size;

  /// Disposição do card. Default [AppChatAttachmentCardLayout.square] — o
  /// desenho de sempre; `row` deita o card num bloco horizontal.
  final AppChatAttachmentCardLayout layout;

  /// Estilo de container (filled/outlined/elevated). Default: global.
  final AppStyle? style;

  /// Override local do modo de forma. Vence o global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (px). Vence [radiusMode] e o global.
  final double? radius;

  AppAttachmentKind get _kind => kind ?? AppAttachmentKind.fromFileName(label);
  String get _icon => icon ?? appAttachmentIcon(label, kind: kind);

  static const double _kRowThumbSide = 40.0;

  @override
  Widget build(BuildContext context) {
    if (layout == AppChatAttachmentCardLayout.row) return _buildRow(context);
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final AppStyle s = style ?? theme.styleTheme.style;
    final BorderRadius br = radius != null
        ? BorderRadius.circular(radius!)
        : theme.radiusTheme.resolve(
            override: radiusMode,
            size: Size.square(size),
          );
    final bool isCircle = br.topLeft.x >= size / 2 - 1;

    Widget card = image != null
        ? _imageCard(theme, s, br)
        : _fileCard(theme, s, br);

    if (onTap != null) {
      card = AppInteraction(
        onTap: onTap,
        radius: br,
        semanticLabel: 'Ver ${label ?? 'anexo'}',
        child: card,
      );
    }

    if (onRemove == null) return card;
    // No círculo, o canto do bounding-box fica fora da forma — recolhe o X para
    // dentro do arco. Nas demais formas, fica no canto.
    final double inset = isCircle ? size * 0.13 : AppSpacings.s4;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        card,
        Positioned(top: inset, right: inset, child: _removeButton(colors)),
      ],
    );
  }

  Widget _imageCard(AppThemeData theme, AppStyle s, BorderRadius br) {
    final Widget stack = SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: br,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image(image: image!, fit: BoxFit.cover),
            if (label != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: <Color>[
                        theme.colorTheme.neutralBlack.customOpacity(0.6),
                        theme.colorTheme.neutralBlack.customOpacity(0),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacings.s8,
                      vertical: AppSpacings.s4,
                    ),
                    child: AppText(
                      label!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall.withColor(
                        theme.colorTheme.neutralWhite,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    return _applyStyle(theme, s, br, stack);
  }

  Widget _fileCard(AppThemeData theme, AppStyle s, BorderRadius br) {
    final AppColorTheme colors = theme.colorTheme;
    // A borda (outlined) vai numa DecoratedBox de FOREGROUND (via _applyStyle),
    // não na decoração do Container — assim não insere o conteúdo nem estoura o
    // tamanho fixo do card. O Container fica só com o fundo (+ sombra do elevated).
    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: theme.brightness == AppBrightness.dark,
      outline: colors.outline,
      surfaceContainer: colors.surfaceContainer,
      ownFill: colors.surfaceContainer,
    );
    final Widget card = Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: deco.color,
        boxShadow: deco.boxShadow,
        borderRadius: br,
      ),
      padding: const EdgeInsets.all(AppSpacings.s8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _tintedIconTile(theme),
          const SizedBox(height: AppSpacings.s2),
          AppText(
            label ?? 'arquivo',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall.withColor(colors.onSurface),
          ),
          if (subtitle != null)
            AppText(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall.withColor(
                colors.onSurface.customOpacity(0.55),
              ),
            ),
        ],
      ),
    );
    if (deco.border == null) return card;
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(borderRadius: br, border: deco.border),
      child: card,
    );
  }

  /// Caixa tingida com o ícone da categoria — o MESMO tile do card quadrado,
  /// reusado pelo leading do layout `row`.
  Widget _tintedIconTile(AppThemeData theme) {
    final Color kindColor = _kind.accentOn(theme.colorTheme);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: kindColor.customOpacity(0.12),
        borderRadius: theme.radiusTheme.resolve(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.s2),
        child: AppIcon(_icon, color: kindColor, customSize: size * 0.22),
      ),
    );
  }

  /// O layout `row`: leading + textos + X em linha, largura `2 × size`.
  ///
  /// O raio resolve SEM `size:` — o precedente é a pílula de arquivo do chip:
  /// `redondo` respeita o teto (~12) e `circular` satura em pílula na altura
  /// real. Não há `isCircle` aqui porque o X vai EM LINHA no fim do Row (o
  /// idioma do chip) — o problema do canto sobreposto não existe.
  Widget _buildRow(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final AppStyle s = style ?? theme.styleTheme.style;
    final BorderRadius br = radius != null
        ? BorderRadius.circular(radius!)
        : theme.radiusTheme.resolve(override: radiusMode);

    final Widget leading = image != null
        ? ClipRRect(
            borderRadius: theme.radiusTheme.resolve(),
            child: SizedBox.square(
              dimension: _kRowThumbSide,
              child: Image(image: image!, fit: BoxFit.cover),
            ),
          )
        : _tintedIconTile(theme);

    Widget main = Padding(
      padding: const EdgeInsets.all(AppSpacings.s8),
      child: Row(
        children: <Widget>[
          leading,
          const SizedBox(width: AppSpacings.s8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  label ?? 'arquivo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall.withColor(colors.onSurface),
                ),
                if (subtitle != null)
                  AppText(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall.withColor(
                      colors.onSurface.customOpacity(0.55),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (onTap != null) {
      main = AppInteraction(
        onTap: onTap,
        radius: br,
        semanticLabel: 'Ver ${label ?? 'anexo'}',
        child: main,
      );
    }

    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: theme.brightness == AppBrightness.dark,
      outline: colors.outline,
      surfaceContainer: colors.surfaceContainer,
      ownFill: colors.surfaceContainer,
    );
    final Widget card = Container(
      width: size * 2,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: deco.color,
        boxShadow: deco.boxShadow,
        borderRadius: br,
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: main),
          if (onRemove != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacings.s8),
              child: _removeButton(colors),
            ),
        ],
      ),
    );
    if (deco.border == null) return card;
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(borderRadius: br, border: deco.border),
      child: card,
    );
  }

  /// Envolve o card de imagem com a borda (outlined) / sombra (elevated) do
  /// [style]; `filled` não acrescenta nada.
  Widget _applyStyle(
    AppThemeData theme,
    AppStyle s,
    BorderRadius br,
    Widget child,
  ) {
    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: theme.brightness == AppBrightness.dark,
      outline: theme.colorTheme.outline,
      surfaceContainer: theme.colorTheme.surfaceContainer,
    );
    Widget result = child;
    if (deco.boxShadow != null) {
      result = DecoratedBox(
        decoration: BoxDecoration(borderRadius: br, boxShadow: deco.boxShadow),
        child: result,
      );
    }
    if (deco.border != null) {
      result = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(borderRadius: br, border: deco.border),
        child: result,
      );
    }
    return result;
  }

  /// X clicável **sem fundo** — só o ícone.
  Widget _removeButton(AppColorTheme colors) => AppInteraction(
    onTap: onRemove,
    semanticLabel: 'Remover anexo',
    tooltip: 'Remover anexo',
    radius: BorderRadius.circular(999),
    padding: const EdgeInsets.all(AppSpacings.s2),
    child: AppIcon(
      AppIconToken.close,
      color: colors.onSurface.customOpacity(0.6),
      customSize: 16,
    ),
  );
}
