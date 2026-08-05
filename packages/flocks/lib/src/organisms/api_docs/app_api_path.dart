import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../content/app_content_style.dart';

/// Path de um endpoint em monoespaçada, com os placeholders destacados.
///
/// Os segmentos entre chaves (`/devices/{id}/commands`) recebem o acento
/// primário e peso maior: é o que o leitor precisa substituir, e destacá-los
/// evita a leitura errada de `{id}` como parte literal do path.
///
/// Usa a mesma família mono da folha de conteúdo ([AppContentStyle]), então o
/// path fica visualmente igual ao mesmo path dentro de um [AppCodeBlock].
///
/// ```dart
/// AppApiPath('/associations/vehicle-device')
/// AppApiPath('/devices/{id}', prefix: 'https://api.tracked.local')
/// ```
final class AppApiPath extends StatelessWidget {
  /// Cria um [AppApiPath].
  const AppApiPath(
    this.path, {
    this.prefix,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    super.key,
  });

  /// Path com os placeholders da especificação.
  final String path;

  /// Base opcional mostrada antes do path, esmaecida.
  final String? prefix;

  /// Estilo base. `null` usa o `code` da folha de conteúdo.
  final TextStyle? style;

  /// Máximo de linhas. Default 1.
  final int? maxLines;

  /// Tratamento de estouro. Default [TextOverflow.ellipsis].
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final TextStyle base =
        style ??
        AppContentStyle.resolve(context).code.copyWith(color: colors.onSurface);
    final TextStyle placeholder = base.copyWith(
      color: colors.primaryAccent(isDark: isDark),
      fontWeight: FontWeight.w600,
    );
    final TextStyle muted = base.copyWith(
      color: colors.disabledColor(colors.onSurface),
    );

    return AppRichText(
      AppTextSpan(
        style: base,
        children: <TextSpan>[
          if (prefix != null && prefix!.isNotEmpty)
            TextSpan(text: prefix, style: muted),
          ...splitApiPathSpans(path, base: base, placeholder: placeholder),
        ],
      ),
      maxLines: maxLines,
      overflow: overflow,
      semanticLabel: '${prefix ?? ''}$path',
    );
  }
}

/// Quebra [path] em spans alternando texto literal e placeholders `{…}`.
///
/// Exposto porque o tile de endpoint e o passo de fluxo montam o path dentro de
/// linhas maiores, sem o widget completo.
List<TextSpan> splitApiPathSpans(
  String path, {
  required TextStyle base,
  required TextStyle placeholder,
}) {
  final List<TextSpan> spans = <TextSpan>[];
  final StringBuffer literal = StringBuffer();

  void flushLiteral() {
    if (literal.isEmpty) return;
    spans.add(TextSpan(text: literal.toString(), style: base));
    literal.clear();
  }

  int i = 0;
  while (i < path.length) {
    if (path[i] == '{') {
      final int close = path.indexOf('}', i);
      // Chave sem fechamento: trata o resto como literal em vez de engolir.
      if (close == -1) {
        literal.write(path.substring(i));
        break;
      }
      flushLiteral();
      spans.add(
        TextSpan(text: path.substring(i, close + 1), style: placeholder),
      );
      i = close + 1;
      continue;
    }
    literal.write(path[i]);
    i++;
  }
  flushLiteral();
  return spans;
}
