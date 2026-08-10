// O README e o `pubspec.yaml` não podem se contradizer sobre como instalar.
//
// Portado de `packages/flocks/test/architecture/install_docs_test.dart`, sem o
// loop de `site/`: o adaptador não tem landing própria. O princípio é o mesmo —
// enquanto `publish_to: none` estiver no pubspec, o README tem de dizer isso na
// cara, e no dia em que a linha sair, o aviso sai no mesmo commit. Uma
// instrução de instalação que não resolve para ninguém não fica no
// repositório: ela é publicada.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A marca que o README precisa carregar enquanto o pacote não está publicado.
/// Curta de propósito: é a âncora do gate, não a frase inteira.
const String kUnpublishedMarker = 'not yet published';

/// O bloco de dependência hospedada que o README instrui.
const String kHostedDependency = 'flocks_lucide: ^0.1.0';

void main() {
  final String pubspec = File('pubspec.yaml').readAsStringSync();
  final String readme = File('README.md').readAsStringSync();

  /// `publish_to: none` presente = o pacote não vai para o pub.dev ainda.
  final bool blocked = RegExp(
    r'^publish_to:\s*none\s*$',
    multiLine: true,
  ).hasMatch(pubspec);

  test('o README instrui a dependência que o destino escolhido produz', () {
    expect(
      readme,
      contains(kHostedDependency),
      reason:
          'O destino é o pub.dev, como o dos outros pacotes do repo. Se isso '
          'mudou, mude a instrução do README e este teste juntos.',
    );
  });

  test('enquanto não publicado, o README avisa', () {
    if (!blocked) {
      return;
    }
    expect(
      readme,
      contains(kUnpublishedMarker),
      reason:
          'O pubspec tem `publish_to: none`, então `$kHostedDependency` ainda '
          'não resolve para ninguém. O README precisa dizer isso onde instrui '
          'a instalação — senão publica uma instrução que não funciona.',
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

  // Não há aqui um gate de "a versão instruída é a do pubspec". O caret de
  // `^0.1.0` continua válido em 0.1.1, e o `flocks_material` prova o caso: ele
  // está em 0.1.1 declarando `flocks: ^0.1.0`. Um gate assim reprovaria um
  // bump legítimo — seria um teste medindo a coisa errada.
}
