import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_rich_text.dart';
import 'app_text_span.dart';

// Previews nativos (Regra 5) — renderizam no previewer da IDE (Flutter 3.44+).
// Os estilos inline derivam do tema (base onSurface + destaque primary), então
// os dois previews exercitam claro e escuro com a cor da marca.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: Builder(
    builder: (BuildContext context) {
      final AppThemeData theme = AppTheme.of(context);
      final TextStyle base = theme.textTheme.bodyMedium.copyWith(
        color: theme.colorTheme.onSurface,
      );
      return AppRichText(
        AppTextSpan(
          style: base,
          children: <InlineSpan>[
            const TextSpan(text: 'This is an '),
            TextSpan(
              text: 'important',
              style: base.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorTheme.primary,
              ),
            ),
            const TextSpan(text: ' inline highlight.'),
          ],
        ),
        semanticLabel: 'This is an important inline highlight.',
      );
    },
  ),
);

@Preview(name: 'AppRichText • claro')
Widget appRichTextLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppRichText • escuro')
Widget appRichTextDarkPreview() => _sample(AppThemeData.dark);
