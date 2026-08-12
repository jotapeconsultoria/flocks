// O exemplo de início não parte da marca do Flocks.
//
// Este arquivo é o que sobrou — de propósito — do `brand_cdn_test.dart`.
//
// Aquela suíte existia para impedir que o adotante dependesse do CDN do site:
// `cdnBaseUrl` era `required` no `AppBrandConfig`, alimentava sete getters de
// logo, e quem não tinha onde hospedar copiava o valor do `flocksBrand` — que
// apontava para `flocks.live`. O produto do adotante passava a depender da nossa
// infra e a embarcar o nosso logo.
//
// Esses campos saíram do design system: viraram a ficha de identidade do app, em
// `tracked_shared_pkg`. **O problema deixou de existir em vez de ser
// fiscalizado**, e resolver por ausência é melhor que resolver por gate — a
// maior parte daquela suíte perdeu objeto junto com os campos, e foi removida.
//
// O que NÃO perdeu objeto são os três casos abaixo, e o motivo deles nunca foi o
// CDN. `flocksBrand` continua existindo, continua sendo a marca **do site** —
// índigo, Space Grotesk, cantos redondos — e um exemplo de início que parte dela
// ensina o adotante a vestir a nossa identidade em vez de construir a dele. Um
// README de white-label que começa adotando a marca alheia não demonstra nada.
//
// Nada disso quebra sozinho: o exemplo compila, o app roda, e o erro só aparece
// no dia em que alguém repara que o produto tem a nossa cara. Por isso a regra é
// um gate e não um comentário.
//
// O segundo grupo, o da raiz de entrada, mora aqui por oportunidade: os blocos
// ```dart do README já estão parseados numa lista neste arquivo, e o exemplo é o
// vizinho natural deles. O critério dele está em `entry_root_tokens.dart`, junto
// da metade que fiscaliza as duas páginas do site.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'entry_root_tokens.dart';

/// O domínio do site — proibido em qualquer exemplo copiável.
const String kSiteDomain = 'flocks.live';

/// O exemplo que o pub.dev renderiza na aba Example.
const String kCaminhoDoExemplo = 'example/lib/main.dart';

/// O corpo dos blocos ```dart do README.
///
/// A checagem é sobre CÓDIGO, não sobre a página: o README cita
/// `flocks_brand.dart` na prosa de propósito (é o exemplo completo de marca), e
/// varrer o arquivo inteiro reprovaria essa menção legítima — assim como o link
/// para o site no cabeçalho.
List<String> _dartBlocks(String markdown) => RegExp(
  r'```dart\n(.*?)```',
  dotAll: true,
).allMatches(markdown).map((RegExpMatch m) => m.group(1)!).toList();

void main() {
  final String readme = File('README.md').readAsStringSync();
  final List<String> blocks = _dartBlocks(readme);

  group('o exemplo do README não parte da marca do site', () {
    test('há bloco dart para checar', () {
      // Guarda contra vacuidade: se a regex parar de casar (o README mudar de
      // formato), é este `expect` que reprova, e não os de baixo passando por
      // falta de entrada.
      expect(blocks, isNotEmpty, reason: 'Nenhum bloco ```dart no README.');
    });

    test('nenhum bloco de código usa flocksBrand', () {
      expect(
        blocks.where((String b) => b.contains('flocksBrand')),
        isEmpty,
        reason:
            'O exemplo voltou a montar o tema com `flocksBrand`. Ela é a marca '
            'do SITE: quem copiar o trecho veste a nossa identidade em vez da '
            'própria. O exemplo constrói um AppBrandConfig — é o white-label '
            'acontecendo, que é o que o README tem a ensinar.',
      );
    });

    test('nenhum bloco de código aponta para o domínio do site', () {
      expect(
        blocks.where((String b) => b.contains(kSiteDomain)),
        isEmpty,
        reason:
            'Um exemplo copiável passou a apontar para $kSiteDomain. O endereço '
            'do exemplo é o do adotante.',
      );
    });
  });

  group('a raiz de entrada monta o Overlay que o pacote exige', () {
    for (final String token in kTokensDaRaizDeEntrada) {
      test('o primeiro bloco do README monta $token', () {
        // O PRIMEIRO bloco, e não qualquer um: é a raiz que o visitante copia.
        // Os outros blocos do README são fragmentos (um botão, um `copyWith`) e
        // exigir a montagem deles seria falso.
        expect(
          blocks.first,
          contains(token),
          reason:
              'O primeiro bloco ```dart do README parou de montar `$token`. Ele '
              'é a raiz que quem instala o pacote copia, e sem `Overlay` '
              'ancestral os dropdowns, o `AppTooltip`, os pickers ancorados e '
              'qualquer campo de texto focado lançam em tempo de execução. O '
              'critério inteiro está em `entry_root_tokens.dart`.',
        );
      });

      test('$kCaminhoDoExemplo monta $token', () {
        expect(
          File(kCaminhoDoExemplo).readAsStringSync(),
          contains(token),
          reason:
              '`$kCaminhoDoExemplo` parou de montar `$token`. É o que o pub.dev '
              'renderiza na aba Example, e ele viaja no tarball congelado na '
              'versão: o conserto de um exemplo que lança só chega na próxima. '
              'O `dart analyze` não pega isto — a árvore sem `Overlay` compila.',
        );
      });
    }
  });
}
