// O README e o `pubspec.yaml` não podem se contradizer sobre como instalar.
//
// O padrão é o do `flocks` (`test/architecture/install_docs_test.dart`), pela
// mesma razão e com um agravante: a instrução de instalação DESTE pacote é o
// que uma pessoa cola no `claude mcp add` ou no `claude_desktop_config.json`.
// Uma linha errada aqui não é prosa desatualizada, é um servidor que não sobe
// — e o diagnóstico ("comando não encontrado") não aponta para o README.
//
// Enquanto `publish_to: none` estiver no pubspec, o `dart pub global activate
// flocks_mcp` não resolve para ninguém, e o README tem de dizer isso na cara.
// No dia em que a linha sair, este teste cobra que o aviso saia junto.
import 'dart:io';

import 'package:dart_mcp/server.dart';
import 'package:flocks_mcp/flocks_mcp.dart';
import 'package:test/test.dart';

/// A marca que o README carrega enquanto o pacote não está publicado.
///
/// A mesma string do README do `flocks`, e curta de propósito: é a âncora do
/// gate, não a frase inteira.
const String kUnpublishedMarker = 'not yet published';

/// O comando de instalação que o README instrui.
const String kActivateCommand = 'dart pub global activate flocks_mcp';

void main() {
  final String pubspec = File('pubspec.yaml').readAsStringSync();
  final String readme = File('README.md').readAsStringSync();

  /// `publish_to: none` presente = o pacote não vai para o pub.dev ainda.
  final bool blocked = RegExp(
    r'^publish_to:\s*none\s*$',
    multiLine: true,
  ).hasMatch(pubspec);

  test('o README instrui a instalação que o destino escolhido produz', () {
    expect(
      readme,
      contains(kActivateCommand),
      reason:
          'O destino decidido é o pub.dev, e a via deste pacote é '
          '`pub global activate` (ROADMAP, Fase C2). Se isso mudou, mude a '
          'instrução do README e este teste juntos.',
    );
  });

  test('enquanto não publicado, o README avisa e oferece a via por git', () {
    if (!blocked) {
      return;
    }
    expect(
      readme,
      contains(kUnpublishedMarker),
      reason:
          'O pubspec tem `publish_to: none`, então `$kActivateCommand` ainda '
          'não resolve para ninguém. O README precisa dizer isso onde instrui '
          'a instalação — senão publica um comando que falha.',
    );
    expect(
      readme,
      contains('--source git'),
      reason:
          'Avisar que não dá para instalar sem dizer como instalar deixa o '
          'leitor sem saída. Enquanto o pacote não está no pub.dev, a via é a '
          'ativação por git.',
    );
  });

  test('depois de publicado, o aviso sai', () {
    if (blocked) {
      return;
    }
    expect(
      readme,
      isNot(contains(kUnpublishedMarker)),
      reason:
          'O `publish_to: none` saiu do pubspec, então o pacote foi publicado '
          '— o aviso de "ainda não publicado" virou mentira. Tire-o do README.',
    );
  });

  test('as três tools do contrato estão documentadas no README', () {
    // O README É o contrato publicado (ROADMAP, Fase C1). Uma tool que exista
    // no código e não no README é contrato que ninguém sabe que pode usar; uma
    // que exista no README e não no código é promessa quebrada.
    for (final String name in <String>[
      for (final Tool tool in flocksTools) tool.name,
    ]) {
      expect(
        readme,
        contains('`$name`'),
        reason: 'A tool `$name` existe no código e não no README.',
      );
    }
  });

  test('a versão que o servidor anuncia é a do pubspec', () {
    // O `initialize` devolve esta versão para o cliente, e é ela que aparece no
    // log de quem for depurar a integração. Divergir do pubspec faria o log
    // mentir sobre qual build está rodando — e nada mais reprovaria por isso.
    final RegExpMatch? declared = RegExp(
      r'^version:\s*(\S+)\s*$',
      multiLine: true,
    ).firstMatch(pubspec);
    expect(declared, isNotNull, reason: 'O pubspec perdeu o campo `version:`.');
    expect(
      kServerVersion,
      declared!.group(1),
      reason:
          'O servidor se apresenta como $kServerVersion e o pubspec diz '
          '${declared.group(1)}. Ajuste `kServerVersion` em lib/src/server.dart.',
    );
  });
}
