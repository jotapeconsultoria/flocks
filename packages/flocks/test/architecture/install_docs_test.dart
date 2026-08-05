// O README e o `pubspec.yaml` não podem se contradizer sobre como instalar.
//
// O README instruía `flocks: ^1.0.0` — sintaxe de dependência hospedada —
// enquanto o pubspec tinha `publish_to: none`. As duas não podem ser verdade, e
// a copy de /instalar do site sai desse mesmo texto: a contradição não fica no
// repositório, ela é publicada.
//
// O destino está decidido (pub.dev, ver `doc/EXTRACAO.md`), mas o pacote ainda
// não foi publicado. Enquanto `publish_to: none` estiver lá, o README tem de
// dizer isso na cara — e no dia em que a linha sair, este teste cobra que o
// aviso saia junto. É o mesmo princípio do gate de contagem: o número (ou a
// instrução) não pode envelhecer em silêncio.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A marca que o README precisa carregar enquanto o pacote não está publicado.
/// Curta de propósito: é a âncora do gate, não a frase inteira.
///
/// Em inglês desde que o README passou a ser inglês — o pacote é internacional
/// a partir da publicação. A âncora acompanha a prosa: um marcador em português
/// num README inglês passaria a nunca casar, e o gate ficaria verde por
/// vacuidade em vez de por acerto.
const String kUnpublishedMarker = 'not yet published';

/// O bloco de dependência hospedada que o README instrui.
const String kHostedDependency = 'flocks: ^0.1.0';

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
          'O destino decidido é o pub.dev (doc/EXTRACAO.md). Se isso mudou, '
          'mude a instrução do README e este teste juntos — a copy de '
          '/instalar do site sai daqui.',
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

  // Havia aqui um quarto caso, exigindo que `resolution: workspace` e
  // `publish_to: none` andassem sempre juntos. Ele saiu na extração, e a
  // premissa dele — "um checkout avulso vindo do pub.dev não resolve com
  // `resolution: workspace`" — não sobreviveu à medição. O que o `pub` faz de
  // fato, verificado em 2026-08-05:
  //
  // | cenário                                        | resultado |
  // |------------------------------------------------|-----------|
  // | `dart pub publish --dry-run` com a linha        | passa, sem aviso |
  // | consumidor depende do pacote (path ou hosted)   | resolve — o campo é IGNORADO em dependência |
  // | `pub get` DENTRO do pacote, sem workspace acima | falha |
  // | membro de `workspace:` SEM a linha              | falha |
  //
  // Ou seja: a linha só quebra `pub get` rodado dentro do pacote quando não há
  // raiz de workspace acima dele — e aqui há, no repo do Flocks. Ela é o que
  // faz os adaptadores resolverem `flocks` localmente enquanto o pacote não
  // está no pub.dev; tirá-la quebra o `pub get` da raiz. Publicar não depende
  // dela em nada, então não há acoplamento a cobrar.
}
