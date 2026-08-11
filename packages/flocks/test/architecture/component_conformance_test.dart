// A "Definition of Migrated" dentro do `flutter test`.
//
// O gate já existia em `tool/validate_components.dart`, mas só a CI o rodava —
// e quem trabalha no pacote roda `flutter test`. O resultado era um validador
// vermelho por semanas sem ninguém ver. Aqui as MESMAS regras falham na suíte.
//
// E, desde a guarda de cwd, aqui também se cobra que o gate tenha VALIDADO algo:
// rodado da raiz do repositório ele descobria zero widget e aprovava, porque os
// caminhos de `kComponentDirs` são relativos à raiz do pacote. Um validador que
// passa sem validar é pior que um que não existe — quem o roda no lugar errado
// acredita nele. Os dois vácuos são distintos e têm teste cada:
//  - cwd errado (`grupo guarda de cwd`), que a guarda fecha;
//  - o leitor que parou de ler (`a descoberta não pode ficar vazia nem
//    parcial`), que a guarda NÃO fecha: os diretórios existem e o regex deixa
//    de casar.
import 'dart:io';

import 'package:flocks/meta.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/component_conformance.dart';

void main() {
  test('todo componente cumpre a Definition of Migrated', () {
    final List<String> errors = conformanceErrors('.');
    expect(
      errors,
      isEmpty,
      reason:
          'Conformidade de componentes ("Definition of Migrated", as regras '
          'em tool/component_conformance.dart):\n'
          '${errors.map((String e) => '  - $e').join('\n')}',
    );
  });

  test('a descoberta não pode ficar vazia nem parcial', () {
    // É esta asserção que impede o gate de virar vácuo com os diretórios no
    // lugar: se `_widgetClass` parar de casar (uma classe base própria em vez de
    // `extends StatelessWidget`, digamos), `discoverWidgets` devolve lista vazia
    // e TODAS as regras da fase 2 passam por não ter sujeito. Derivada dos dois
    // lados, não pinada num número — `isNotEmpty` sobreviveria a "organisms
    // parou de casar", a igualdade não.
    final Set<String> discovered = discoverWidgets('.')
        .where((DiscoveredWidget w) => !w.isInternal)
        .map((DiscoveredWidget w) => w.name)
        .toSet();
    final Set<String> migrated = flocksCatalog
        .where((AppComponentMeta m) => m.status == ComponentStatus.migrated)
        .map((AppComponentMeta m) => m.name)
        .toSet();
    expect(
      discovered,
      migrated,
      reason:
          'Públicos descobertos em ${kComponentDirs.join(', ')}: '
          '${discovered.length} · migrados em flocksCatalog: '
          '${migrated.length}. Divergir aqui significa uma das duas: a '
          'descoberta parou de achar o que existe (e aí o gate inteiro está '
          'passando a vácuo), ou o catálogo cita componente que não existe mais '
          'no código.',
    );
  });

  group('guarda de cwd', () {
    test('rodado da raiz do repositório, o gate falha em vez de aprovar', () {
      // A reprodução literal do defeito: `dart run
      // packages/flocks/tool/validate_components.dart` da raiz imprimia
      // "OK: 131 componente(s) migrado(s) + 0 interno(s)" e saía 0. O `+ 0` era
      // a única pista, e o número honesto é 7.
      //
      // As DUAS entradas públicas são asseridas porque as duas são chamadas de
      // fora deste arquivo (`validate_components.dart` usa as duas), e a guarda
      // vive num lugar só: dentro de `discoverWidgets`. `conformanceErrors` está
      // coberta por chamá-la — em qualquer ponto do corpo, não só na primeira
      // linha. Isto NÃO trava a ordem de leitura lá dentro: com o hoist
      // revertido, estes cinco testes continuam verdes (medido). O hoist é
      // higiene de diagnóstico, não invariante — quem quiser mudá-lo não vai
      // encontrar rede aqui.
      expect(() => discoverWidgets('../..'), throwsStateError);
      expect(
        () => conformanceErrors('../..'),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            contains(kValidateCommand),
          ),
        ),
      );
    });

    test('camada ausente reprova, e a mensagem nomeia só as que faltam', () {
      // `kComponentDirs` é manifesto, não descoberta: um `git mv lib/src/atoms
      // lib/src/primitives` com o const para trás faria o gate perder a camada
      // inteira em silêncio — o mesmo defeito um nível abaixo. Daí exigir os
      // três, e não "pelo menos um".
      final Directory tmp = Directory.systemTemp.createTempSync(
        'flocks_conformance',
      );
      addTearDown(() => tmp.deleteSync(recursive: true));
      Directory('${tmp.path}/lib/src/atoms').createSync(recursive: true);

      expect(
        () => requireComponentRoot(tmp.path),
        throwsA(
          isA<StateError>().having(
            (StateError e) => e.message,
            'message',
            allOf(
              contains('lib/src/molecules'),
              contains('lib/src/organisms'),
              isNot(contains('lib/src/atoms')),
            ),
          ),
        ),
      );
    });

    test('a raiz do pacote passa', () {
      expect(() => requireComponentRoot('.'), returnsNormally);
    });
  });
}
