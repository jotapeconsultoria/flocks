import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_code_block.dart';
import 'app_html.dart';
import 'app_markdown.dart';

// Previews nativos (Regra 5) — Markdown e HTML, em claro e escuro.

const String _markdown = '''
# Relatório

Resumo com **destaque**, `código` e [link](https://exemplo.com).

- Excesso de velocidade
    - Trecho urbano
- Frenagem brusca

> A média considera apenas trechos com GPS válido.
''';

const String _html = '''
<h1>Termos de uso</h1>
<p>Leia com <strong>atenção</strong> antes de continuar.</p>
<ul><li>Uso pessoal</li><li>Dados de telemetria</li></ul>
''';

Widget _frame(AppThemeData data, Widget child) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surface,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: child,
    ),
  ),
);

@Preview(name: 'AppMarkdown • claro')
Widget appMarkdownLightPreview() =>
    _frame(AppThemeData.light, const AppMarkdown(data: _markdown));

@Preview(name: 'AppMarkdown • escuro')
Widget appMarkdownDarkPreview() =>
    _frame(AppThemeData.dark, const AppMarkdown(data: _markdown));

@Preview(name: 'AppHtml • claro')
Widget appHtmlLightPreview() =>
    _frame(AppThemeData.light, const AppHtml(data: _html));

@Preview(name: 'AppHtml • escuro')
Widget appHtmlDarkPreview() =>
    _frame(AppThemeData.dark, const AppHtml(data: _html));

const String _json = '''
{
  "imei": "860123456789012",
  "device_model_id": "0f6f1b6a-2f1a-4f0e-9a1b-2c3d4e5f6a7b",
  "active": true
}''';

@Preview(name: 'AppCodeBlock • claro')
Widget appCodeBlockLightPreview() => _frame(
  AppThemeData.light,
  const AppCodeBlock(code: _json, language: 'json'),
);

@Preview(name: 'AppCodeBlock • escuro')
Widget appCodeBlockDarkPreview() => _frame(
  AppThemeData.dark,
  const AppCodeBlock(code: _json, language: 'json'),
);
