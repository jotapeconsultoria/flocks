// O README e o `pubspec.yaml` não podem se contradizer sobre como instalar.
//
// Portado de `packages/flocks_cupertino/test/install_docs_test.dart` — que por
// sua vez veio do `test/architecture/install_docs_test.dart` do core sem o loop
// de `site/`, porque adaptador não tem landing própria. O que muda em relação a
// ele é o estado do pacote — e o gate acompanha o estado.
//
// LÁ O GATE É UM XOR; AQUI NÃO. O arquivo de origem deriva um `blocked` de
// `publish_to: none` no pubspec e ramifica: enquanto a linha estiver lá, o README
// tem de avisar que a instrução não resolve; no dia em que ela sair, o aviso sai
// no mesmo commit. Este pacote já publicou — o CHANGELOG traz seções datadas de
// versões que já saíram, e o pubspec não traz a cláusula de estreia que o
// `test/release/release_versioning_test.dart` do core lê para isentar quem nunca
// publicou —, então `blocked` seria constante `false` e o ramo do aviso nunca
// rodaria. E não é só ramo morto: se alguém puser `publish_to: none` aqui amanhã,
// o pacote continua publicado, e cobrar do README a frase "ainda não publicado"
// seria cobrar uma mentira. As três asserções abaixo são incondicionais de
// propósito. Valem em qualquer estado do pubspec, o que as torna mais fortes que
// o XOR e não mais frouxas; e um `if` que nunca é tomado sai verde e calado, que
// é contra o que o `release_versioning_test.dart` citado acima argumenta ao
// preferir `skip:` a `return`.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O bloco de dependência hospedada que o README instrui.
const String kHostedDependency = 'flocks_material: ^0.1.0';

/// Os avisos de "ainda não publicado" que este README não pode carregar.
///
/// Duas âncoras porque a prosa deste README é portuguesa. A inglesa é a que os
/// `install_docs_test` dos outros pacotes do repo usam — é de um deles que este
/// arquivo veio; a portuguesa é a que o gate do core usa para a página
/// `site/pt/`. Um marcador de um idioma num texto do outro nunca casaria, e o
/// gate ficaria verde por vacuidade em vez de por acerto — é o que o comentário
/// do `kUnpublishedMarker` de lá diz.
const List<String> kAvisosDeNaoPublicado = <String>[
  'not yet published',
  'não publicado no pub.dev',
];

void main() {
  final String pubspec = File('pubspec.yaml').readAsStringSync();
  final String readme = File('README.md').readAsStringSync();

  test('o README instrui a dependência que o destino escolhido produz', () {
    expect(
      readme,
      contains(kHostedDependency),
      reason:
          'O destino é o pub.dev, como o dos outros pacotes do repo, e esta é a '
          'primeira coisa que a página renderizada de lá tem a responder. Se o '
          'destino mudou, mude a instrução do README e este teste juntos.',
    );
  });

  test('o pubspec não contradiz a instrução do README', () {
    expect(
      RegExp(r'^publish_to:\s*none\s*$', multiLine: true).hasMatch(pubspec),
      isFalse,
      reason:
          'O pubspec ganhou `publish_to: none`, então a partir da próxima versão '
          '`$kHostedDependency` para de acompanhar o que existe no pub.dev — o '
          'README instruiria uma via que o destino escolhido não produz mais. Se '
          'o pacote deve mesmo sair, é a instrução do README que muda primeiro, '
          'e este teste com ela.',
    );
  });

  test('o README não avisa que o pacote não está publicado', () {
    for (final String aviso in kAvisosDeNaoPublicado) {
      expect(
        readme,
        isNot(contains(aviso)),
        reason:
            'O README diz "$aviso" e o pacote está publicado: o aviso é mentira, '
            'e sai renderizado na página do pub.dev ao lado da instrução que '
            'funciona.',
      );
    }
  });

  // Não há aqui um gate de "a versão instruída é a do pubspec", e este próprio
  // pacote é o caso que mostra por quê: o `version:` já subiu acima do `0.1.0`
  // que o README instrui, e o caret continua admitindo-o. Vale igual para o
  // `flocks: ^0.1.0` que ele declara contra um core que também já subiu. Um gate
  // de igualdade reprovaria um bump legítimo — seria um teste medindo a coisa
  // errada. Sem número escrito aqui, de propósito: número dentro de comentário
  // apodrece sem que gate nenhum alcance.
}
