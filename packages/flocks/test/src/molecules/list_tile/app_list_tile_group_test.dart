import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: SizedBox(width: 320, child: child)),
    ),
  ),
);

Widget _group({String? title}) => AppListTileGroup(
  title: title,
  children: const <Widget>[
    AppListTile(title: 'Primeira'),
    AppListTile(title: 'Segunda'),
  ],
);

void main() {
  testWidgets('sem title a árvore é a de sempre (geometria idêntica)', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_group()));
    final Size sem = tester.getSize(find.byType(AppListTileGroup));
    // Nenhum AppText além dos títulos dos tiles.
    expect(
      find.descendant(
        of: find.byType(AppListTileGroup),
        matching: find.byType(AppText),
      ),
      findsNWidgets(2),
    );
    // O grupo É o card: DecoratedBox na raiz, sem Column externa de rótulo.
    expect(find.byType(AppDivider), findsOneWidget);

    await tester.pumpWidget(_host(_group(title: 'Seção')));
    final Size com = tester.getSize(find.byType(AppListTileGroup));
    expect(com.width, sem.width);
    expect(com.height, greaterThan(sem.height));
  });

  testWidgets('title desenha o rótulo ACIMA do card, no desenho do menu', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_group(title: 'Respostas rápidas')));
    final Finder label = find.text('Respostas rápidas');
    expect(label, findsOneWidget);

    final Rect labelRect = tester.getRect(label);
    final Rect cardRect = tester.getRect(
      find
          .descendant(
            of: find.byType(AppListTileGroup),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect(labelRect.bottom, lessThanOrEqualTo(cardRect.top));

    final AppText text = tester.widget<AppText>(
      find.widgetWithText(AppText, 'Respostas rápidas'),
    );
    final AppThemeData theme = AppThemeData.light;
    expect(text.maxLines, 1);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.style?.color, theme.colorTheme.neutralPrimary.s600);
    expect(text.style?.fontSize, theme.textTheme.labelSmall.fontSize);
  });

  testWidgets('as divisórias e o escopo continuam com o title presente', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_group(title: 'Seção')));
    expect(find.byType(AppDivider), findsOneWidget);
    expect(find.byType(ListTileGroupScope), findsOneWidget);
  });
}
