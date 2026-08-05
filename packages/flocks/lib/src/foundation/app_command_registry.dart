import 'package:flutter/widgets.dart';

/// Um comando invocável por `/atalho`, tanto na busca global quanto no chat.
///
/// O comando não sabe *onde* foi acionado: quem monta a superfície (campo de
/// busca ou composer) resolve o termo pelo [AppCommandRegistry] e chama [run].
@immutable
final class AppCommand {
  const AppCommand({
    required this.id,
    required this.label,
    required this.run,
    this.description,
    this.icon,
    this.aliases = const <String>[],
  });

  /// Termo digitado **sem** a barra (ex.: `sair` para `/sair`).
  final String id;

  /// Rótulo curto exibido na lista (ex.: "Encerrar sessão").
  final String label;

  /// Uma linha de contexto, quando o rótulo não basta.
  final String? description;

  /// Constante de `AppIcons`.
  final String? icon;

  /// Outras formas de digitar o mesmo comando (ex.: `logout` para `/sair`).
  final List<String> aliases;

  /// O que executar. Recebe o contexto da superfície que acionou.
  final void Function(BuildContext context) run;

  /// Como o comando aparece escrito (ex.: `/sair`).
  String get token => '/$id';

  /// [term] casa com o id ou com algum alias (prefixo, sem diferenciar caixa)?
  bool matches(String term) {
    final needle = term.trim().toLowerCase();
    if (needle.isEmpty) return true;
    if (id.toLowerCase().startsWith(needle)) return true;
    return aliases.any((alias) => alias.toLowerCase().startsWith(needle));
  }
}

/// Registro dos comandos `/` disponíveis.
///
/// Nasce **mínimo e só com comandos globais**: a intenção é fixar a estrutura
/// (declaração, casamento do termo, exibição e interceptação), não catalogar
/// comandos. Comandos por tela — que só existem enquanto uma tela está montada
/// — ficam para quando estiver claro quais são de fato úteis.
@immutable
final class AppCommandRegistry {
  const AppCommandRegistry({this.commands = const <AppCommand>[]});

  final List<AppCommand> commands;

  /// Prefixo que marca uma entrada como comando.
  static const String prefix = '/';

  /// [input] é uma tentativa de comando (começa com `/`)?
  ///
  /// Uma barra sozinha já conta: é assim que a lista inteira aparece enquanto o
  /// usuário ainda não digitou nada.
  static bool isCommandInput(String input) =>
      input.trimLeft().startsWith(prefix);

  /// Comandos que casam com [input].
  ///
  /// Devolve vazio quando [input] não é uma entrada de comando — nunca a lista
  /// toda, para que uma busca textual comum não vire uma lista de comandos.
  List<AppCommand> search(String input) {
    if (!isCommandInput(input)) return const <AppCommand>[];
    final term = input.trimLeft().substring(prefix.length);
    return commands.where((command) => command.matches(term)).toList();
  }

  /// Comando cujo id (ou alias) é exatamente [input], já sem ambiguidade.
  ///
  /// É o que o composer do chat usa para decidir se intercepta a mensagem
  /// localmente em vez de mandar ao modelo.
  AppCommand? exact(String input) {
    if (!isCommandInput(input)) return null;
    final term = input.trim().substring(prefix.length).toLowerCase();
    if (term.isEmpty) return null;
    for (final command in commands) {
      if (command.id.toLowerCase() == term) return command;
      if (command.aliases.any((alias) => alias.toLowerCase() == term)) {
        return command;
      }
    }
    return null;
  }
}

/// Disponibiliza o [AppCommandRegistry] para a subárvore.
final class AppCommandScope extends InheritedWidget {
  const AppCommandScope({
    required this.registry,
    required super.child,
    super.key,
  });

  final AppCommandRegistry registry;

  /// Registro mais próximo, ou um vazio quando não há escopo — assim uma
  /// superfície de busca funciona mesmo fora de um app que declare comandos.
  static AppCommandRegistry of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppCommandScope>();
    return scope?.registry ?? const AppCommandRegistry();
  }

  @override
  bool updateShouldNotify(AppCommandScope oldWidget) =>
      registry != oldWidget.registry;
}
