import 'package:flocks/flocks.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

late List<String> selected;
late List<String> ranCommands;
late List<String> searchedTerms;

AppOmniSearchItem _item(String id, String title, {String? subtitle}) =>
    AppOmniSearchItem(
      id: id,
      title: title,
      subtitle: subtitle,
      onSelected: () => selected.add(id),
    );

AppOmniSearchResult _vehiclesAndDevices() => AppOmniSearchResult(
  groups: [
    AppOmniSearchGroup(
      label: 'Veículos',
      items: [_item('v1', 'KRO3E75', subtitle: 'Caminhos Dourados')],
    ),
    AppOmniSearchGroup(
      label: 'Rastreadores',
      items: [_item('d1', '862096071035773')],
    ),
  ],
);

Future<void> _pumpSearch(
  WidgetTester tester, {
  AppOmniSearchCallback? onSearch,
  List<AppCommand> commands = const [],
  Duration debounce = Duration.zero,
}) async {
  tester.view
    ..physicalSize = const Size(900, 700)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    AppTheme(
      data: AppThemeData.light,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: AppCommandScope(
            registry: AppCommandRegistry(commands: commands),
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (_) => Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 420,
                      child: AppOmniSearch(
                        debounce: debounce,
                        onSearch:
                            onSearch ??
                            (term) async {
                              searchedTerms.add(term);
                              return _vehiclesAndDevices();
                            },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(EditableText).first, text);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    selected = <String>[];
    ranCommands = <String>[];
    searchedTerms = <String>[];
  });

  group('AppOmniSearch — busca', () {
    testWidgets('mostra resultados agrupados por entidade', (tester) async {
      await _pumpSearch(tester);
      await _type(tester, 'KRO');

      // O rótulo do grupo é o que mantém legível uma lista que mistura placa,
      // IMEI e ICCID.
      expect(find.text('VEÍCULOS'), findsOneWidget);
      expect(find.text('RASTREADORES'), findsOneWidget);
      expect(find.text('Caminhos Dourados'), findsOneWidget);
    });

    testWidgets('campo vazio fecha o painel', (tester) async {
      await _pumpSearch(tester);
      await _type(tester, 'KRO');
      expect(find.text('VEÍCULOS'), findsOneWidget);

      await _type(tester, '');

      expect(find.text('VEÍCULOS'), findsNothing);
    });

    testWidgets('resultado vazio mostra mensagem, não painel em branco', (
      tester,
    ) async {
      await _pumpSearch(
        tester,
        onSearch: (_) async => const AppOmniSearchResult(),
      );
      await _type(tester, 'zzz');

      expect(find.text('Nada encontrado'), findsOneWidget);
    });

    testWidgets('erro é distinto de vazio', (tester) async {
      await _pumpSearch(
        tester,
        onSearch: (_) async =>
            const AppOmniSearchResult.failed('Falha ao buscar'),
      );
      await _type(tester, 'abc');

      // "não achei" e "não consegui buscar" pedem reações diferentes.
      expect(find.text('Falha ao buscar'), findsOneWidget);
      expect(find.text('Nada encontrado'), findsNothing);
    });

    testWidgets('exceção da busca vira erro visível', (tester) async {
      await _pumpSearch(
        tester,
        onSearch: (_) async => throw StateError('sem rede'),
      );
      await _type(tester, 'abc');

      expect(find.textContaining('sem rede'), findsOneWidget);
    });

    testWidgets('resposta atrasada de termo antigo é descartada', (
      tester,
    ) async {
      // Sem isso, uma resposta lenta do termo anterior sobrescreveria a atual.
      await _pumpSearch(
        tester,
        onSearch: (term) async {
          if (term == 'lento') {
            await Future<void>.delayed(const Duration(milliseconds: 200));
            return AppOmniSearchResult(
              groups: [
                AppOmniSearchGroup(
                  label: 'Antigo',
                  items: [_item('old', 'RESULTADO ANTIGO')],
                ),
              ],
            );
          }
          return AppOmniSearchResult(
            groups: [
              AppOmniSearchGroup(
                label: 'Novo',
                items: [_item('new', 'RESULTADO NOVO')],
              ),
            ],
          );
        },
      );

      await tester.enterText(find.byType(EditableText).first, 'lento');
      await tester.pump();
      await tester.enterText(find.byType(EditableText).first, 'rapido');
      await tester.pumpAndSettle(const Duration(milliseconds: 400));

      expect(find.text('RESULTADO NOVO'), findsOneWidget);
      expect(find.text('RESULTADO ANTIGO'), findsNothing);
    });

    testWidgets('debounce agrupa teclas numa busca só', (tester) async {
      await _pumpSearch(
        tester,
        debounce: const Duration(milliseconds: 120),
        onSearch: (term) async {
          searchedTerms.add(term);
          return const AppOmniSearchResult();
        },
      );

      final field = find.byType(EditableText).first;
      await tester.enterText(field, 'K');
      await tester.pump(const Duration(milliseconds: 30));
      await tester.enterText(field, 'KR');
      await tester.pump(const Duration(milliseconds: 30));
      await tester.enterText(field, 'KRO');
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(searchedTerms, ['KRO']);
    });
  });

  group('AppOmniSearch — comandos', () {
    final commands = [
      AppCommand(
        id: 'sair',
        label: 'Encerrar sessão',
        run: (_) => ranCommands.add('sair'),
      ),
    ];

    testWidgets('barra lista os comandos sem chamar a busca', (tester) async {
      await _pumpSearch(tester, commands: commands);
      await _type(tester, '/');

      expect(find.text('COMANDOS'), findsOneWidget);
      expect(find.text('Encerrar sessão'), findsOneWidget);
      // O comando é local: nada foi ao servidor.
      expect(searchedTerms, isEmpty);
    });

    testWidgets('filtra comandos pelo termo', (tester) async {
      await _pumpSearch(tester, commands: commands);
      await _type(tester, '/sa');

      expect(find.text('Encerrar sessão'), findsOneWidget);
    });

    testWidgets('tocar no comando executa e limpa o campo', (tester) async {
      await _pumpSearch(tester, commands: commands);
      await _type(tester, '/sair');

      await tester.tap(find.text('Encerrar sessão'));
      await tester.pumpAndSettle();

      expect(ranCommands, ['sair']);
      expect(find.text('COMANDOS'), findsNothing);
    });
  });

  group('AppOmniSearch — teclado', () {
    testWidgets('setas andam pelos resultados e Enter escolhe', (tester) async {
      await _pumpSearch(tester);
      await _type(tester, 'KRO');

      // Começa no primeiro item; uma seta para baixo leva ao segundo, que está
      // em outro grupo — a navegação atravessa os blocos.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selected, ['d1']);
    });

    testWidgets('Enter sem mover escolhe o primeiro', (tester) async {
      await _pumpSearch(tester);
      await _type(tester, 'KRO');

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selected, ['v1']);
    });

    testWidgets('seta para cima a partir do topo dá a volta', (tester) async {
      await _pumpSearch(tester);
      await _type(tester, 'KRO');

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selected, ['d1']);
    });

    testWidgets('Esc fecha o painel sem escolher', (tester) async {
      await _pumpSearch(tester);
      await _type(tester, 'KRO');

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('VEÍCULOS'), findsNothing);
      expect(selected, isEmpty);
    });
  });

  group('AppOmniSearch — seleção', () {
    testWidgets('tocar num resultado dispara onSelected e fecha', (
      tester,
    ) async {
      await _pumpSearch(tester);
      await _type(tester, 'KRO');

      await tester.tap(find.text('Caminhos Dourados'));
      await tester.pumpAndSettle();

      expect(selected, ['v1']);
      expect(find.text('VEÍCULOS'), findsNothing);
    });
  });
}
