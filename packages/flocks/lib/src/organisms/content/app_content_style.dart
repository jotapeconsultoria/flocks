import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Família monoespaçada primária usada em código.
///
/// O Flocks empacota apenas Poppins e Space Grotesk — nenhuma mono —, então o
/// código
/// depende da mono do sistema. Esta é a família tentada primeiro;
/// [kAppContentMonoFallback] cobre as demais plataformas.
///
/// TODO(flocks): empacotar uma mono nos assets do pacote elimina a dependência
/// do sistema e torna os goldens de código determinísticos em qualquer
/// plataforma. Feito isso, isto vira `fontFamily: 'X', package: 'flocks'`.
const String kAppContentMonoFamily = 'SF Mono';

/// Monos alternativas, por plataforma.
const List<String> kAppContentMonoFallback = <String>[
  'Menlo',
  'Consolas',
  'Roboto Mono',
  'DejaVu Sans Mono',
  'Courier New',
  'monospace',
];

/// Folha de estilo compartilhada por [AppMarkdown] e [AppHtml].
///
/// Um único objeto para os dois renderers — é o que garante que o mesmo
/// documento fique idêntico vindo de Markdown ou de HTML. Todos os valores
/// saem de `AppTheme.of(context)`, então acompanham marca e claro/escuro sem
/// nada hardcoded.
@immutable
final class AppContentStyle {
  /// Constrói a folha explicitamente. Na prática prefira
  /// [AppContentStyle.resolve] e sobrescreva com [copyWith].
  const AppContentStyle({
    required this.base,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.h5,
    required this.h6,
    required this.code,
    required this.link,
    required this.blockquote,
    required this.codeBackground,
    required this.inlineCodeBackground,
    required this.blockquoteBar,
    required this.dividerColor,
    required this.blockSpacing,
    required this.listIndent,
    required this.inlineImageMaxHeight,
    required this.codePadding,
    required this.codeBorderRadius,
    required this.blockquoteBarRadius,
  });

  /// Resolve a folha a partir do tema ativo.
  ///
  /// [base] e [color] são os ganchos de retrocompatibilidade dos parâmetros
  /// `style`/`textColor` dos componentes: quando informados, redefinem o corpo
  /// de texto e a cor de todo o documento.
  factory AppContentStyle.resolve(
    BuildContext context, {
    TextStyle? base,
    Color? color,
  }) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;

    final Color foreground = color ?? base?.color ?? colors.onSurface;
    final TextStyle body = (base ?? theme.textTheme.bodyLarge).withColor(
      foreground,
    );

    TextStyle heading(TextStyle token) => token.withColor(foreground);

    return AppContentStyle(
      base: body,
      h1: heading(theme.textTheme.headlineLarge),
      h2: heading(theme.textTheme.headlineMedium),
      h3: heading(theme.textTheme.headlineSmall),
      h4: heading(theme.textTheme.titleLarge),
      h5: heading(theme.textTheme.titleMedium),
      h6: heading(theme.textTheme.titleSmall),
      code: TextStyle(
        color: foreground,
        fontFamily: kAppContentMonoFamily,
        fontFamilyFallback: kAppContentMonoFallback,
        fontSize: (body.fontSize ?? 16) * 0.92,
        height: body.height,
        fontWeight: FontWeight.w400,
      ),
      link: body
          .withColor(colors.primaryAccent(isDark: isDark))
          .copyWith(
            decoration: TextDecoration.underline,
            decorationColor: colors.primaryAccent(isDark: isDark),
          ),
      blockquote: body.withColor(foreground.withValues(alpha: 0.78)),
      codeBackground: colors.surfaceContainer,
      inlineCodeBackground: colors.surfaceContainer,
      blockquoteBar: colors.outline,
      dividerColor: colors.divider,
      blockSpacing: AppSpacings.s12,
      listIndent: AppSpacings.s24,
      inlineImageMaxHeight: AppSpacings.s128,
      codePadding: const EdgeInsets.all(AppSpacings.s12),
      codeBorderRadius: theme.radiusTheme.resolve(),
      // A barra da citação é uma régua de 4px: a ponta é cápsula ou é quadrada,
      // não há meio-termo legível. Por isso o modo é forçado em vez de passado
      // como `componentDefault` — este só vale sob `AppRadiusMode.padrao`, e
      // NENHUMA das marcas usa `padrao` (ambas fixam `redondo`), o que aqui
      // renderia 4 × 0,25 = 1px e apagaria a cápsula.
      blockquoteBarRadius: theme.radiusTheme.resolve(
        override: theme.radiusTheme.mode == AppRadiusMode.reto
            ? AppRadiusMode.reto
            : AppRadiusMode.circular,
        size: const Size.square(AppStrokes.l),
      ),
    );
  }

  /// Estilo do texto corrido (parágrafos, itens de lista, células).
  final TextStyle base;

  /// Estilos de heading, `h1` a `h6`.
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle h4;
  final TextStyle h5;
  final TextStyle h6;

  /// Estilo do código (inline e em bloco).
  final TextStyle code;

  /// Estilo dos links.
  final TextStyle link;

  /// Estilo do texto dentro de citações.
  final TextStyle blockquote;

  /// Fundo do bloco de código.
  final Color codeBackground;

  /// Fundo do código inline.
  final Color inlineCodeBackground;

  /// Barra vertical à esquerda da citação.
  final Color blockquoteBar;

  /// Cor da régua horizontal (`<hr>`).
  final Color dividerColor;

  /// Espaço vertical entre blocos irmãos.
  final double blockSpacing;

  /// Recuo por nível de lista aninhada.
  final double listIndent;

  /// Altura máxima de uma imagem inline, para que não estoure a linha.
  final double inlineImageMaxHeight;

  /// Padding interno do bloco de código.
  final EdgeInsets codePadding;

  /// Raio do bloco de código.
  final BorderRadius codeBorderRadius;

  /// Raio das pontas da barra vertical da citação (blockquote).
  final BorderRadius blockquoteBarRadius;

  /// Cópia com um ou mais campos sobrescritos.
  AppContentStyle copyWith({
    TextStyle? base,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? h5,
    TextStyle? h6,
    TextStyle? code,
    TextStyle? link,
    TextStyle? blockquote,
    Color? codeBackground,
    Color? inlineCodeBackground,
    Color? blockquoteBar,
    Color? dividerColor,
    double? blockSpacing,
    double? listIndent,
    double? inlineImageMaxHeight,
    EdgeInsets? codePadding,
    BorderRadius? codeBorderRadius,
    BorderRadius? blockquoteBarRadius,
  }) => AppContentStyle(
    base: base ?? this.base,
    h1: h1 ?? this.h1,
    h2: h2 ?? this.h2,
    h3: h3 ?? this.h3,
    h4: h4 ?? this.h4,
    h5: h5 ?? this.h5,
    h6: h6 ?? this.h6,
    code: code ?? this.code,
    link: link ?? this.link,
    blockquote: blockquote ?? this.blockquote,
    codeBackground: codeBackground ?? this.codeBackground,
    inlineCodeBackground: inlineCodeBackground ?? this.inlineCodeBackground,
    blockquoteBar: blockquoteBar ?? this.blockquoteBar,
    dividerColor: dividerColor ?? this.dividerColor,
    blockSpacing: blockSpacing ?? this.blockSpacing,
    listIndent: listIndent ?? this.listIndent,
    inlineImageMaxHeight: inlineImageMaxHeight ?? this.inlineImageMaxHeight,
    codePadding: codePadding ?? this.codePadding,
    codeBorderRadius: codeBorderRadius ?? this.codeBorderRadius,
    blockquoteBarRadius: blockquoteBarRadius ?? this.blockquoteBarRadius,
  );

  /// Estilo do heading de [level] (1–6).
  TextStyle headingFor(int level) => switch (level) {
    1 => h1,
    2 => h2,
    3 => h3,
    4 => h4,
    5 => h5,
    _ => h6,
  };
}
