import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Monta [child] sob um `MediaQuery` que PUBLICA [published] como recuo
/// lateral — é o que o side sheet faz para reservar a gutter de arraste.
Widget _host({required Widget child, required EdgeInsets published}) =>
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(padding: published),
        child: AppTheme(
          data: AppThemeData.light,
          child: Center(child: SizedBox(width: 300, child: child)),
        ),
      ),
    );

/// O recuo lateral efetivo do primeiro `Padding` sob o [AppSideInset].
EdgeInsets _appliedInset(WidgetTester tester) {
  final Padding padding = tester.widget<Padding>(
    find
        .descendant(
          of: find.byType(AppSideInset),
          matching: find.byType(Padding),
        )
        .first,
  );
  return padding.padding.resolve(TextDirection.ltr);
}

void main() {
  const Widget content = SizedBox(key: Key('content'), height: 20);

  testWidgets('aplica o recuo lateral que a superfície publicou', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        published: const EdgeInsets.only(left: 24, right: 16),
        child: const AppSideInset(child: content),
      ),
    );

    final EdgeInsets applied = _appliedInset(tester);
    expect(applied.left, 24);
    expect(applied.right, 16);
    // Só o eixo horizontal: o vertical é problema de quem monta o layout.
    expect(applied.top, 0);
    expect(applied.bottom, 0);
  });

  testWidgets('CONSOME o recuo — ninguém abaixo o aplica de novo', (
    WidgetTester tester,
  ) async {
    late EdgeInsets seenBelow;
    await tester.pumpWidget(
      _host(
        published: const EdgeInsets.only(left: 24, right: 24),
        child: AppSideInset(
          child: Builder(
            builder: (BuildContext context) {
              seenBelow = MediaQuery.paddingOf(context);
              return content;
            },
          ),
        ),
      ),
    );

    expect(seenBelow.left, 0);
    expect(seenBelow.right, 0);
  });

  testWidgets('aninhado é no-op: o de dentro não dobra o recuo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        published: const EdgeInsets.only(left: 24, right: 24),
        child: const AppSideInset(child: AppSideInset(child: content)),
      ),
    );

    // A caixa de 300 perde 24+24 UMA vez, não duas.
    expect(tester.getSize(find.byKey(const Key('content'))).width, 300 - 48);
  });

  testWidgets('sem recuo publicado é passa-through (não monta Padding)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        published: EdgeInsets.zero,
        child: const AppSideInset(child: content),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(AppSideInset),
        matching: find.byType(Padding),
      ),
      findsNothing,
    );
    expect(tester.getSize(find.byKey(const Key('content'))).width, 300);
  });

  test('AppSideInset no catálogo como migrated', () {
    expect(
      flocksCatalog.any(
        (AppComponentMeta m) =>
            m.id == 'app_side_inset' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
