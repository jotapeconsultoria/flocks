@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Matriz {claro,escuro} × {jotape,zxtrack}. Gerar:
//   flutter test --update-goldens --tags golden
//
// Nota: são 8 baselines — `app_markdown_*` e `app_html_*` na matriz —, e só as 4
// de Markdown têm glifo mono (o fixture de HTML não tem `<code>` nem `<pre>`).
//
// Nenhuma fonte aqui vem do SO: as três famílias são empacotadas. Antes de o
// Flocks empacotar a IBM Plex Mono, o bloco de código era a ÚNICA parte que
// vinha, e no sandbox de teste — onde nenhuma mono de sistema existe — o
// `flutter_test_config.dart` registrava a Poppins sob o nome `SF Mono`: estas
// baselines mostravam uma proporcional fingindo ser mono.
//
// Continuam geradas no macOS, como o resto do repositório, porque o que ainda
// varia entre máquinas é o rasterizador de texto — e isso vale para os 8 por
// igual, não para o trecho de código em particular.

const String _markdown = '''
# Relatório de viagem

Resumo do período com **destaques**, _observações_ e ~~itens descartados~~.
Consulte a [rota completa](https://exemplo.com/rota) para o detalhe.

## Ocorrências

- Excesso de velocidade
    - Trecho urbano
    - Rodovia
- Frenagem brusca

1. Revisar telemetria
2. Notificar o motorista

> A média considera apenas trechos com sinal de GPS válido.

Use `speed_kmh` para o cálculo:

```dart
final media = pontos
    .where((p) => p.gpsValido)
    .map((p) => p.speedKmh)
    .average;
```

---

| Placa | Modelo | Eventos |
| --- | --- | --- |
| ABC-1234 | GV75 | 12 |
| XYZ-9876 | GV55 | 3 |
''';

const String _html = '''
<h1>Política de Privacidade</h1>
<p>Esta política descreve como tratamos <strong>dados pessoais</strong>.</p>
<h2>Dados coletados</h2>
<ul>
  <li>Identificação do dispositivo</li>
  <li>Posição geográfica</li>
</ul>
<blockquote>Os dados são retidos por 12 meses.</blockquote>
<p>Dúvidas? Fale com o <a href="https://exemplo.com/dpo">encarregado</a>.</p>
<table>
  <thead><tr><th>Categoria</th><th>Retenção</th></tr></thead>
  <tbody>
    <tr><td>Telemetria</td><td>12 meses</td></tr>
    <tr><td>Cadastro</td><td>5 anos</td></tr>
  </tbody>
</table>
''';

void main() {
  final List<AppBrandConfig> brands = <AppBrandConfig>[
    jotapeBrand,
    zxtrackBrand,
  ];

  Widget frame(AppThemeData data, Widget child) => Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(720, 1200)),
      child: AppTheme(
        data: data,
        child: Container(
          key: const Key('golden'),
          color: data.colorTheme.surface,
          width: 720,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(child: child),
        ),
      ),
    ),
  );

  for (final AppBrandConfig brand in brands) {
    for (final bool dark in <bool>[false, true]) {
      final String label = '${brand.clientSlug}_${dark ? 'dark' : 'light'}';

      testWidgets('AppMarkdown golden · $label', (WidgetTester tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(
          frame(data, const AppMarkdown(data: _markdown)),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_markdown_$label.png'),
        );
      });

      testWidgets('AppHtml golden · $label', (WidgetTester tester) async {
        final AppThemeData data = AppThemeData.forBrand(brand, dark: dark);

        await tester.pumpWidget(frame(data, const AppHtml(data: _html)));
        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(const Key('golden')),
          matchesGoldenFile('goldens/app_html_$label.png'),
        );
      });
    }
  }
}
