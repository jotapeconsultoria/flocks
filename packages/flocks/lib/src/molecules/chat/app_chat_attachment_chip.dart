import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../interactive/interactive.dart';
import 'app_attachment_kind.dart';

/// Chip de anexo do composer — thumbnail de imagem **ou** pílula ícone+nome com
/// remover.
///
/// Quando não há [image], o ícone e o tom vêm da **extensão** de [label] (via
/// [AppAttachmentKind]). Passe [kind]/[icon] para sobrescrever. [onTap] abre/
/// visualiza; [onRemove] mostra um X clicável (sem fundo). Participa do eixo
/// [style] (filled/outlined/elevated) e de forma ([radiusMode]/[radius]).
///
/// ```dart
/// AppChatAttachmentChip(image: MemoryImage(bytes), onTap: _view, onRemove: _rm)
/// AppChatAttachmentChip(label: 'relatorio.pdf', onTap: _view, onRemove: _rm)
/// ```
final class AppChatAttachmentChip extends StatelessWidget {
  /// Cria um chip de anexo.
  const AppChatAttachmentChip({
    this.image,
    this.label,
    this.kind,
    this.icon,
    this.onTap,
    this.onRemove,
    this.size = 48,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Preview de imagem. `null` → renderiza a pílula de arquivo.
  final ImageProvider? image;

  /// Nome do arquivo. Dirige o ícone/tom quando [kind]/[icon] são nulos.
  final String? label;

  /// Categoria do anexo. `null` = resolvida de [label].
  final AppAttachmentKind? kind;

  /// Ícone explícito. `null` = resolvido da extensão de [label].
  final String? icon;

  /// Abre/visualiza o anexo. `null` = não tappável.
  final VoidCallback? onTap;

  /// Remove o anexo. `null` = sem botão de remover.
  final VoidCallback? onRemove;

  /// Lado do thumbnail de imagem (px). Default 48.
  final double size;

  /// Estilo de container (filled/outlined/elevated). Default: global.
  final AppStyle? style;

  /// Override local do modo de forma. Vence o global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (px). Vence [radiusMode] e o global.
  final double? radius;

  AppAttachmentKind get _kind => kind ?? AppAttachmentKind.fromFileName(label);
  String get _icon => icon ?? appAttachmentIcon(label, kind: kind);

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppStyle s = style ?? theme.styleTheme.style;
    return image != null ? _buildImage(theme, s) : _buildFile(theme, s);
  }

  Widget _buildFile(AppThemeData theme, AppStyle s) {
    final AppColorTheme colors = theme.colorTheme;
    final BorderRadius br = radius != null
        ? BorderRadius.circular(radius!)
        : theme.radiusTheme.resolve(override: radiusMode);
    final Widget label0 = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: AppText(
        label ?? 'arquivo',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelMedium.withColor(colors.onSurface),
      ),
    );
    final Widget main = Padding(
      padding: EdgeInsets.only(
        left: AppSpacings.s8,
        right: onRemove != null ? AppSpacings.s4 : AppSpacings.s8,
        top: AppSpacings.s4,
        bottom: AppSpacings.s4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppIcon(_icon, color: _kind.accentOn(colors), customSize: 18),
          const SizedBox(width: AppSpacings.s8),
          Flexible(child: label0),
        ],
      ),
    );
    final Widget tappable = onTap != null
        ? AppInteraction(
            onTap: onTap,
            radius: br,
            semanticLabel: 'Ver ${label ?? 'anexo'}',
            child: main,
          )
        : main;

    return DecoratedBox(
      decoration: styleBoxDecoration(
        style: s,
        isDark: theme.brightness == AppBrightness.dark,
        radius: br,
        outline: colors.outline,
        surfaceContainer: colors.surfaceContainer,
        ownFill: colors.surfaceContainer,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(child: tappable),
          if (onRemove != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacings.s8),
              child: _removeButton(colors),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(AppThemeData theme, AppStyle s) {
    final AppColorTheme colors = theme.colorTheme;
    final BorderRadius br = radius != null
        ? BorderRadius.circular(radius!)
        : theme.radiusTheme.resolve(
            override: radiusMode,
            size: Size.square(size),
          );
    final bool isCircle = br.topLeft.x >= size / 2 - 1;

    Widget thumb = SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: br,
        child: Image(image: image!, fit: BoxFit.cover),
      ),
    );
    thumb = _applyImageStyle(theme, s, br, thumb);
    if (onTap != null) {
      thumb = AppInteraction(
        onTap: onTap,
        radius: br,
        semanticLabel: label == null ? 'Ver imagem' : 'Ver $label',
        child: thumb,
      );
    }
    if (onRemove == null) return thumb;
    final double inset = isCircle ? size * 0.14 : AppSpacings.s2;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        thumb,
        Positioned(top: inset, right: inset, child: _removeButton(colors)),
      ],
    );
  }

  /// Aplica a borda (outlined) e/ou a sombra (elevated) do [style] em torno do
  /// thumbnail; `filled` não acrescenta nada.
  Widget _applyImageStyle(
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
    radius: BorderRadius.circular(999),
    padding: const EdgeInsets.all(AppSpacings.s2),
    child: AppIcon(
      AppIconToken.close,
      color: colors.onSurface.customOpacity(0.6),
      customSize: 16,
    ),
  );
}
