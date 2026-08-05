import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../molecules/copy/app_copy_button.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import 'app_content_style.dart';

/// Bloco de código monoespaçado, com rótulo de linguagem e ação de copiar.
///
/// Divide a folha de estilo com [AppMarkdown]/[AppHtml] ([AppContentStyle]):
/// mesma família mono, mesmo fundo, mesmo padding e mesmo raio — um payload
/// JSON avulso fica idêntico ao mesmo JSON dentro de um documento Markdown.
///
/// Por padrão **não quebra linha**: rola na horizontal, que é o que preserva a
/// indentação de um JSON ou de um comando de shell. Com [wrap] `true` o texto
/// se ajusta à largura (útil em coluna estreita).
///
/// Eixos globais: **estilo** ([AppStyle]) e **forma** ([AppRadiusMode]). Como o
/// fundo próprio vem da folha de conteúdo, `outlined` acrescenta a borda sem
/// trocar o fundo e `elevated` acrescenta a sombra.
///
/// ```dart
/// AppCodeBlock(
///   code: '{"imei": "860123456789012"}',
///   language: 'json',
/// )
/// ```
final class AppCodeBlock extends StatelessWidget {
  /// Cria um [AppCodeBlock].
  const AppCodeBlock({
    required this.code,
    this.language,
    this.showCopy = true,
    this.wrap = false,
    this.selectable = true,
    this.copyTooltip = 'Copiar',
    this.copiedTooltip = 'Copiado!',
    this.onCopy,
    this.style,
    this.radiusMode,
    super.key,
  });

  /// Conteúdo do bloco, preservado byte a byte.
  final String code;

  /// Rótulo curto da linguagem (`json`, `bash`, `dart`). `null` esconde a faixa
  /// de cabeçalho quando também não há botão de copiar.
  final String? language;

  /// Mostra o botão de copiar. Default `true`.
  final bool showCopy;

  /// Quebra o texto na largura disponível. Default `false` (scroll horizontal).
  final bool wrap;

  /// Se o texto pode ser selecionado. Default `true`.
  final bool selectable;

  /// Tooltip do botão de copiar em repouso.
  final String copyTooltip;

  /// Tooltip do botão de copiar logo após copiar.
  final String copiedTooltip;

  /// Disparado depois de escrever na área de transferência — para instrumentar
  /// ou mostrar um snackbar no call site.
  final VoidCallback? onCopy;

  /// Tratamento de container ([AppStyle]). `null` segue o global.
  final AppStyle? style;

  /// Override do modo de forma. `null` segue o global.
  final AppRadiusMode? radiusMode;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final AppContentStyle content = AppContentStyle.resolve(context);
    final AppStyle style = this.style ?? theme.styleTheme.style;
    final BorderRadius radius = theme.radiusTheme.tileRadius(radiusMode);
    // O bloco já tem fundo próprio (o `codeBackground` da folha de conteúdo):
    // `outlined` só acrescenta a borda e `elevated` só a sombra.
    final StyleDecoration deco = resolveStyleDecoration(
      style: style,
      isDark: theme.brightness == AppBrightness.dark,
      outline: colors.outline,
      surfaceContainer: colors.surfaceContainer,
      ownFill: content.codeBackground,
    );

    final bool hasHeader = language != null || showCopy;

    Widget body = AppText(code, style: content.code, softWrap: wrap);
    if (!selectable) {
      body = SelectionContainer.disabled(child: body);
    }
    if (!wrap) {
      body = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: body,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: deco.color,
        border: deco.border,
        boxShadow: deco.boxShadow,
        borderRadius: radius,
      ),
      child: Padding(
        padding: content.codePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (hasHeader) ...<Widget>[
              _header(theme, colors),
              const SizedBox(height: AppSpacings.s8),
            ],
            body,
          ],
        ),
      ),
    );
  }

  Widget _header(AppThemeData theme, AppColorTheme colors) {
    return SelectionContainer.disabled(
      child: Row(
        children: <Widget>[
          if (language != null)
            Expanded(
              child: AppText(
                language!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall.copyWith(
                  color: colors.neutralPrimary.s600,
                ),
              ),
            )
          else
            const Spacer(),
          if (showCopy)
            AppCopyButton(
              copiedTooltip: copiedTooltip,
              copyTooltip: copyTooltip,
              onCopied: onCopy,
              value: code,
            ),
        ],
      ),
    );
  }
}
