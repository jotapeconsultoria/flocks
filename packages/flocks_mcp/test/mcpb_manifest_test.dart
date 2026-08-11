// O manifesto do `.mcpb` é artefato derivado, e artefato derivado nesta casa
// vem com gate — quarta aplicação do padrão (`catalog.json`,
// `widgetbook_use_cases.json`, `catalog_data.g.dart`): o gerador e este teste
// chamam a MESMA função, e a falha diz qual comando rodar.
//
// Este arquivo também carrega a validação que o `mcpb pack` (a CLI npm
// `@anthropic-ai/mcpb`) faria antes de empacotar. O pipeline não traz Node —
// regra anti-supply-chain documentada no `ci.yml` — então o zip é montado à
// mão no job de release, e o que a CLI validaria está reescrito aqui: campos
// obrigatórios do schema 0.3, enum do `server.type`, chaves de
// `platform_overrides` que o host entende, e a existência de cada caminho que
// o manifesto promete. `npx @anthropic-ai/mcpb validate` continua útil como
// conferência manual de desenvolvimento; o gate é este.
import 'dart:convert';
import 'dart:io';

import 'package:flocks_mcp/flocks_mcp.dart';
import 'package:test/test.dart';

import '../tool/generate_mcpb_manifest.dart';

/// O workflow que monta o bundle, relativo à raiz deste pacote. Dois testes
/// daqui o leem: um confere o esqueleto que o zip leva, o outro os binários que
/// o job compila.
const String kWorkflowPath = '../../.github/workflows/ci.yml';

/// O conteúdo do `.mcpb`, `destino: origem`, exatamente como o passo "Montar o
/// bundle" do [kWorkflowPath] o copia — `bundle/server/` é o diretório onde os
/// quatro binários caem de uma vez.
///
/// Isto não é documentação: o teste compara a lista real do workflow com esta,
/// por igualdade. Mudar o que se distribui exige mudar as duas pontas.
const Map<String, String> kBundleSkeleton = <String, String>{
  'bundle/manifest.json': 'packages/flocks_mcp/mcpb/manifest.json',
  'bundle/server/run.sh': 'packages/flocks_mcp/mcpb/run.sh',
  'bundle/server/': 'binaries/flocks_mcp-*',
  'bundle/LICENSE': 'packages/flocks_mcp/LICENSE',
};

void main() {
  final Map<String, Object?> manifest =
      jsonDecode(File(kManifestPath).readAsStringSync())
          as Map<String, Object?>;
  final Map<String, Object?> server =
      manifest['server']! as Map<String, Object?>;
  final Map<String, Object?> mcpConfig =
      server['mcp_config']! as Map<String, Object?>;

  test('$kManifestPath está em dia com o gerador', () {
    expect(
      File(kManifestPath).readAsStringSync(),
      mcpbManifestSource(),
      reason:
          'O manifesto em disco não é o que o gerador produz hoje. Rode '
          '`$kManifestCommand` e commite o resultado.',
    );
  });

  group('a validação que o `mcpb pack` faria', () {
    test('os campos obrigatórios do schema 0.3 existem e não estão vazios', () {
      // `required` do mcpb-manifest-v0.3.schema.json: name, version,
      // description, author, server. O `manifest_version` não está no
      // `required` do schema, mas o host o usa — cobrado junto.
      expect(manifest['manifest_version'], '0.3');
      for (final String field in <String>['name', 'version', 'description']) {
        expect(
          manifest[field],
          isA<String>().having((String s) => s, 'valor', isNotEmpty),
          reason: 'O campo obrigatório `$field` está ausente ou vazio.',
        );
      }
      final Map<String, Object?> author =
          manifest['author']! as Map<String, Object?>;
      expect(author['name'], isA<String>());
    });

    test('o server é um binário lançado por /bin/sh, não direto', () {
      // O Claude Desktop extrai o zip com tudo em 0600 (mcpb#294): um
      // `command` apontando para arquivo do bundle falha com EACCES. Se
      // alguém "simplificar" isto para chamar o binário direto, o bundle
      // volta a quebrar em toda instalação — este teste é o que fica
      // vermelho antes disso.
      expect(server['type'], 'binary');
      expect(server['entry_point'], 'server/run.sh');
      expect(mcpConfig['command'], '/bin/sh');
      expect(mcpConfig['args'], <String>[r'${__dirname}/server/run.sh']);
    });

    test('platform_overrides só usa chaves que o host entende', () {
      // O host conhece darwin, win32 e linux — uma chave inventada (um
      // `darwin-arm64`, digamos) é silenciosamente ignorada, que é o pior
      // modo de falha: o override some sem nada acusar.
      final Map<String, Object?> overrides =
          mcpConfig['platform_overrides']! as Map<String, Object?>;
      expect(
        overrides.keys,
        everyElement(isIn(<String>['darwin', 'win32', 'linux'])),
      );
      // Windows não passa pelo run.sh (não há /bin/sh nem bit de execução
      // lá): o .exe entra direto, e o override precisa trocar `args` junto —
      // override só substitui as chaves que declara, e herdar o run.sh como
      // argumento do .exe seria lixo na linha de comando.
      final Map<String, Object?> win32 =
          overrides['win32']! as Map<String, Object?>;
      expect(
        win32['command'],
        r'${__dirname}/server/flocks_mcp-windows-x64.exe',
      );
      expect(win32['args'], isEmpty);
    });

    test('todo caminho que o manifesto promete existe no esqueleto', () {
      expect(
        File(kLauncherPath).existsSync(),
        isTrue,
        reason:
            'O manifesto declara `server/run.sh` como entry point, e o job de '
            'release o copia de `$kLauncherPath` — que não existe.',
      );
      const String win32Binary = 'flocks_mcp-windows-x64.exe';
      expect(
        kBundleBinaries,
        contains(win32Binary),
        reason:
            'O override win32 aponta para `$win32Binary`, que não está na '
            'lista de binários que o job de release compila.',
      );
    });
  });

  test('a versão do manifesto é a do pubspec', () {
    // O terceiro lugar da mesma versão: pubspec ↔ `kServerVersion` já têm
    // gate no `install_docs_test.dart`; este fecha o triângulo. A frescura
    // acima já o implica (o gerador lê o pubspec), mas a falha desta
    // asserção diz "0.1.0 contra 0.2.0" em vez de um diff de JSON.
    final RegExpMatch? declared = RegExp(
      r'^version:\s*(\S+)\s*$',
      multiLine: true,
    ).firstMatch(File(kPubspecPath).readAsStringSync());
    expect(declared, isNotNull);
    expect(manifest['version'], declared!.group(1));
    expect(kServerVersion, declared.group(1));
  });

  test('as tools do manifesto são as do código, descrição inclusa', () {
    // O manifesto anuncia as tools na UI de instalação do Claude Desktop.
    // Uma tool a mais é promessa quebrada; uma a menos é contrato escondido;
    // uma descrição divergente é a mesma mentira em dose menor.
    final List<Object?> declared = manifest['tools']! as List<Object?>;
    expect(declared, hasLength(flocksTools.length));
    for (int i = 0; i < flocksTools.length; i++) {
      final Map<String, Object?> entry = declared[i]! as Map<String, Object?>;
      expect(entry['name'], flocksTools[i].name);
      expect(entry['description'], flocksTools[i].description);
    }
  });

  test('o run.sh monta exatamente os nomes de binário do bundle', () {
    // Três pontas usam o mesmo nome: o `dart compile exe` do ci.yml o produz,
    // o manifesto o promete no win32, e o run.sh o monta com `uname`. Este
    // teste segura a do launcher; a do CI é o teste seguinte.
    final String launcher = File(kLauncherPath).readAsStringSync();
    expect(launcher, contains(r'flocks_mcp-$os-$arch'));
    for (final String value in <String>['darwin', 'linux', 'arm64', 'x64']) {
      expect(
        launcher,
        contains(value),
        reason:
            'O run.sh não sabe montar `$value` — algum binário do bundle '
            'ficou inalcançável no macOS/Linux.',
      );
    }
  });

  test('o job de release zipa o esqueleto inteiro, LICENSE inclusa', () {
    // O `.mcpb` é a ÚNICA via pela qual os quatro binários compilados chegam a
    // alguém: quem instala pelo Claude Desktop baixa o zip de um GitHub Release
    // e não passa pelo pub.dev nem pelo repo. Distribuir binário MIT sem o texto
    // da licença descumpre a licença, e o `manifest.json` deste pacote declara
    // `"license": "MIT"` — a declaração e o arquivo saem juntos, ou a declaração
    // é promessa vazia. O Release `v0.1.1` saiu com 7 entradas no zip, nenhuma
    // delas o `LICENSE`, e o CHANGELOG afirmava o contrário; este teste é o que
    // impede a afirmação de voltar a divergir do artefato.
    //
    // A asserção é de IGUALDADE, não de contenção: tirar o `LICENSE` reprova, e
    // acrescentar arquivo ao bundle sem declará-lo aqui também — o conteúdo do
    // que se distribui não muda em silêncio.
    final File workflow = File(kWorkflowPath);
    if (!workflow.existsSync()) {
      return;
    }
    final String ci = workflow.readAsStringSync();
    expect(
      copiasDoPasso(ci, 'Montar o bundle'),
      kBundleSkeleton,
      reason:
          'A lista de `cp` do passo "Montar o bundle" não é mais o esqueleto '
          'que o bundle promete. Se a mudança é intencional, atualize '
          '`kBundleSkeleton` — e confira se o CHANGELOG ainda diz a verdade.',
    );
    // Toda origem que vem do repo tem que existir. `binaries/` não entra: chega
    // do `download-artifact` e só existe dentro do job.
    for (final String origem in kBundleSkeleton.values) {
      const String prefixo = 'packages/flocks_mcp/';
      if (!origem.startsWith(prefixo)) {
        continue;
      }
      expect(
        File(origem.substring(prefixo.length)).existsSync(),
        isTrue,
        reason:
            'O passo "Montar o bundle" copia `$origem`, que não existe no '
            'pacote — o release quebraria no `cp`.',
      );
    }
    expect(
      File('LICENSE').readAsStringSync(),
      startsWith('MIT License'),
      reason:
          'O bundle leva este arquivo como a licença dos binários, e o '
          '`manifest.json` a declara como MIT.',
    );
    // O passo de medição monta bundles hipotéticos por plataforma para comparar
    // com o único que é publicado. Sem o `LICENSE` neles a comparação deixa de
    // ser maçã com maçã: um bundle por plataforma carregaria a licença também.
    expect(
      copiasDoPasso(ci, 'Medir os dois desenhos de bundle').values,
      contains('bundle/LICENSE'),
      reason:
          'Os bundles `medida-*` não levam o `LICENSE` — a medida compara o '
          'publicado com um hipotético mais magro do que ele poderia ser.',
    );
  });

  test('o ci.yml compila cada binário que o bundle promete', () {
    // O nome de saída do `dart compile exe` no job de release é o que o
    // run.sh procura dentro do bundle. Renomear lá sem renomear aqui é um
    // bundle que instala e não sobe — e nada mais reprovaria por isso.
    final File workflow = File(kWorkflowPath);
    if (!workflow.existsSync()) {
      // Num tarball avulso o repositório não vem junto; o gate roda onde o
      // workflow existe — todo checkout do git, inclusive o da própria CI.
      return;
    }
    final String ci = workflow.readAsStringSync();
    for (final String binary in kBundleBinaries) {
      expect(
        ci,
        contains(binary),
        reason:
            'O binário `$binary` está no bundle e não aparece no ci.yml — o '
            'job de release não o compila, e o run.sh vai procurá-lo em vão.',
      );
    }
  });
}

/// Os `cp <origem> <destino>` do passo chamado [nome] no workflow [ci], como um
/// mapa `destino: origem`.
///
/// Sem parser de YAML de propósito, pela mesma razão do `pubspecField` do
/// gerador: uma dependência de YAML aqui viraria dependência do PACOTE, que é
/// Dart puro e instalável por `dart pub global activate`. O que se procura são
/// linhas `cp a b` dentro de um bloco delimitado pelo próximo `- name:`/`-
/// uses:` — texto, e o gate falha alto se o recorte vier vazio.
Map<String, String> copiasDoPasso(String ci, String nome) {
  final List<String> linhas = ci.split('\n');
  final int inicio = linhas.indexWhere(
    (String l) => l.trimLeft().startsWith('- name: $nome'),
  );
  if (inicio < 0) {
    throw StateError(
      'O ci.yml não tem mais um passo "$nome" — o gate do bundle ficou sem '
      'objeto, e é isso que este erro impede de passar em silêncio.',
    );
  }
  final RegExp limite = RegExp(r'^\s+- (name|uses):');
  final RegExp copia = RegExp(r'^\s*cp (\S+) (\S+)\s*$');
  final Map<String, String> copias = <String, String>{};
  for (final String linha in linhas.skip(inicio + 1)) {
    if (limite.hasMatch(linha)) {
      break;
    }
    final RegExpMatch? match = copia.firstMatch(linha);
    if (match != null) {
      copias[semAspas(match.group(2)!)] = semAspas(match.group(1)!);
    }
  }
  if (copias.isEmpty) {
    throw StateError('O passo "$nome" não copia mais nada — recorte vazio.');
  }
  return copias;
}

/// Tira as aspas duplas que o shell usa em torno de um caminho com expansão
/// (`"medida-${alvo}/manifest.json"`), para o mapa guardar o caminho.
String semAspas(String path) => path.startsWith('"') && path.endsWith('"')
    ? path.substring(1, path.length - 1)
    : path;
