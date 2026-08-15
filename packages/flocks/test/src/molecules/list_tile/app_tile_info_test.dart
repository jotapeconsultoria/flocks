import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {AppThemeData? data}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: data ?? AppThemeData.light,
      child: Center(child: SizedBox(width: 280, child: child)),
    ),
  ),
);

/// `find.text` casa o `Text`/`RichText` de dentro, não o `AppText` — o estilo
/// resolvido mora no widget do DS, então é ele que precisa ser encontrado.
Finder _appText(String text) =>
    find.byWidgetPredicate((Widget w) => w is AppText && w.data == text);

Color _colorOf(WidgetTester tester, String text) =>
    tester.widget<AppText>(_appText(text)).style!.color!;

void main() {
  testWidgets('vertical default sem icon: geometria e árvore de sempre', (
    tester,
  ) async {
    Widget host(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: AppTheme(
          data: AppThemeData.light,
          child: Center(child: SizedBox(width: 260, child: child)),
        ),
      ),
    );
    await tester.pumpWidget(
      host(const AppTileInfo(title: 'Identificador', text: 'TTS4G47')),
    );
    final Size sem = tester.getSize(find.byType(AppTileInfo));
    expect(find.byType(AppIcon), findsNothing);
    expect(find.byType(Row), findsNothing);

    await tester.pumpWidget(
      host(
        const AppTileInfo(
          title: 'Identificador',
          text: 'TTS4G47',
          layout: AppTileInfoLayout.vertical,
        ),
      ),
    );
    expect(tester.getSize(find.byType(AppTileInfo)), sem);
  });

  testWidgets('horizontal: rótulo à esquerda, valor à direita na mesma linha', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppTileInfo(
          title: 'Telefone',
          text: '+55 11 91234-5678',
          layout: AppTileInfoLayout.horizontal,
        ),
      ),
    );
    final Rect title = tester.getRect(find.text('Telefone'));
    final Rect value = tester.getRect(find.text('+55 11 91234-5678'));
    expect(title.left, lessThan(value.left));
    expect((title.center.dy - value.center.dy).abs(), lessThan(title.height));
  });

  testWidgets('icon acompanha o rótulo na cor muted', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppTileInfo(
          title: 'Telefone',
          text: 'x',
          icon: AppIconToken.infoCircle,
        ),
      ),
    );
    final AppIcon icon = tester.widget<AppIcon>(find.byType(AppIcon));
    expect(icon.color, AppThemeData.light.colorTheme.neutralPrimary.s700);
    expect(
      tester.getTopLeft(find.byType(AppIcon)).dx,
      lessThan(tester.getTopLeft(find.text('Telefone')).dx),
    );
  });

  testWidgets('mostra o par rótulo/valor', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(const AppTileInfo(title: 'Identificador', text: 'TTS4G47')),
    );

    expect(find.text('Identificador'), findsOneWidget);
    expect(find.text('TTS4G47'), findsOneWidget);
  });

  testWidgets(
    'a ênfase é INVERSA à do list tile: rótulo apagado, valor forte',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _host(const AppTileInfo(title: 'Identificador', text: 'TTS4G47')),
      );

      final AppColorTheme colors = AppThemeData.light.colorTheme;
      // O valor é o dado; o rótulo só diz o que ele é. Numa grade de 20 pares,
      // rótulo e valor com o mesmo peso viram uma parede de texto.
      expect(_colorOf(tester, 'TTS4G47'), colors.onSurface);
      expect(
        _colorOf(tester, 'Identificador'),
        isNot(_colorOf(tester, 'TTS4G47')),
      );
    },
  );

  testWidgets('não é clicável — nenhum alvo de gesto', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(const AppTileInfo(title: 'Identificador', text: 'TTS4G47')),
    );

    expect(
      find.descendant(
        of: find.byType(AppTileInfo),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  testWidgets('textAlign alinha os dois textos juntos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppTileInfo(
          title: 'Identificador',
          text: 'TTS4G47',
          textAlign: TextAlign.end,
        ),
      ),
    );

    for (final String t in <String>['Identificador', 'TTS4G47']) {
      expect(tester.widget<AppText>(_appText(t)).textAlign, TextAlign.end);
    }
  });

  testWidgets('as cores vêm do tema (claro ≠ escuro)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(const AppTileInfo(title: 'Identificador', text: 'TTS4G47')),
    );
    final Color light = _colorOf(tester, 'TTS4G47');

    await tester.pumpWidget(
      _host(
        const AppTileInfo(title: 'Identificador', text: 'TTS4G47'),
        data: AppThemeData.dark,
      ),
    );
    expect(_colorOf(tester, 'TTS4G47'), isNot(light));
  });

  test('AppTileInfo no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_tile_info' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
