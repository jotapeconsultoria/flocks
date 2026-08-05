import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

AppCommand _command(String id, {List<String> aliases = const []}) =>
    AppCommand(id: id, label: id, aliases: aliases, run: (_) {});

void main() {
  group('AppCommandRegistry.isCommandInput', () {
    test('reconhece entrada iniciada por barra, inclusive só a barra', () {
      expect(AppCommandRegistry.isCommandInput('/'), isTrue);
      expect(AppCommandRegistry.isCommandInput('/sair'), isTrue);
      // Espaço à esquerda não deveria atrapalhar quem colou o texto.
      expect(AppCommandRegistry.isCommandInput('  /sair'), isTrue);
    });

    test('texto comum não é comando', () {
      expect(AppCommandRegistry.isCommandInput('sair'), isFalse);
      expect(AppCommandRegistry.isCommandInput('ABC1D23'), isFalse);
      expect(AppCommandRegistry.isCommandInput(''), isFalse);
      // Barra no meio é conteúdo (ex.: uma data).
      expect(AppCommandRegistry.isCommandInput('21/07'), isFalse);
    });
  });

  group('AppCommandRegistry.search', () {
    final registry = AppCommandRegistry(
      commands: [
        _command('sair', aliases: const ['logout']),
        _command('suporte'),
        _command('perfil'),
      ],
    );

    test('só a barra lista tudo', () {
      expect(registry.search('/').map((c) => c.id), [
        'sair',
        'suporte',
        'perfil',
      ]);
    });

    test('filtra por prefixo do id', () {
      expect(registry.search('/su').map((c) => c.id), ['suporte']);
      expect(registry.search('/s').map((c) => c.id), ['sair', 'suporte']);
    });

    test('filtra por alias', () {
      expect(registry.search('/log').map((c) => c.id), ['sair']);
    });

    test('ignora caixa', () {
      expect(registry.search('/SAIR').map((c) => c.id), ['sair']);
    });

    test('texto que não é comando devolve vazio, não a lista toda', () {
      // Importante: senão toda busca textual viraria uma lista de comandos.
      expect(registry.search('sair'), isEmpty);
      expect(registry.search('ABC1D23'), isEmpty);
    });
  });

  group('AppCommandRegistry.exact', () {
    final registry = AppCommandRegistry(
      commands: [
        _command('sair', aliases: const ['logout']),
      ],
    );

    test('casa id e alias exatos', () {
      expect(registry.exact('/sair')?.id, 'sair');
      expect(registry.exact('/logout')?.id, 'sair');
    });

    test('prefixo incompleto não é match exato', () {
      // O chat só intercepta com certeza; "/sa" ainda é digitação.
      expect(registry.exact('/sa'), isNull);
    });

    test('barra sozinha e texto comum não casam', () {
      expect(registry.exact('/'), isNull);
      expect(registry.exact('sair'), isNull);
    });
  });

  group('AppCommandScope', () {
    testWidgets('sem escopo devolve registro vazio em vez de estourar', (
      tester,
    ) async {
      late AppCommandRegistry resolved;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            resolved = AppCommandScope.of(context);
            return const SizedBox.shrink();
          },
        ),
      );

      expect(resolved.commands, isEmpty);
    });

    testWidgets('entrega o registro do escopo mais próximo', (tester) async {
      late AppCommandRegistry resolved;
      await tester.pumpWidget(
        AppCommandScope(
          registry: AppCommandRegistry(commands: [_command('sair')]),
          child: Builder(
            builder: (context) {
              resolved = AppCommandScope.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved.commands.single.id, 'sair');
      expect(resolved.commands.single.token, '/sair');
    });
  });
}
