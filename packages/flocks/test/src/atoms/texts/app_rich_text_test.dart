import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {bool dark = false}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: dark ? AppThemeData.dark : AppThemeData.light,
      child: child,
    ),
  ),
);

AppTextSpan _span({String? text}) => AppTextSpan(
  text: text,
  style: const TextStyle(),
  children: const <InlineSpan>[
    TextSpan(text: 'This is an '),
    TextSpan(text: 'important'),
    TextSpan(text: ' highlight.'),
  ],
);

void main() {
  testWidgets('renderiza o texto composto', (tester) async {
    await tester.pumpWidget(_host(AppRichText(_span())));
    final text = tester.widget<Text>(find.byType(Text));
    expect(text.textSpan!.toPlainText(), 'This is an important highlight.');
  });

  testWidgets('usa data.text como semanticsLabel por padrão', (tester) async {
    await tester.pumpWidget(_host(AppRichText(_span(text: 'root label'))));
    final text = tester.widget<Text>(find.byType(Text));
    expect(text.semanticsLabel, 'root label');
  });

  testWidgets('semanticLabel explícito prevalece sobre data.text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(AppRichText(_span(text: 'root'), semanticLabel: 'custom')),
    );
    final text = tester.widget<Text>(find.byType(Text));
    expect(text.semanticsLabel, 'custom');
  });

  testWidgets('respeita maxLines e overflow', (tester) async {
    await tester.pumpWidget(
      _host(AppRichText(_span(), maxLines: 1, overflow: TextOverflow.ellipsis)),
    );
    final text = tester.widget<Text>(find.byType(Text));
    expect(text.maxLines, 1);
    expect(text.overflow, TextOverflow.ellipsis);
  });

  testWidgets('é selecionável (envolve AppSelectionRegion)', (tester) async {
    await tester.pumpWidget(_host(AppRichText(_span())));
    expect(find.byType(AppSelectionRegion), findsOneWidget);
  });

  testWidgets('está no catálogo como migrado', (tester) async {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_rich_text' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
