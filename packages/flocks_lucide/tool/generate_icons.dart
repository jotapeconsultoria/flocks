// Gera as classes de ícone a partir do catálogo vendorizado.
//
// Uso: `dart run tool/generate_icons.dart`
//
// Lê só o que está em disco (`vendor/lucide_icons.json`), nunca a rede: é o que
// faz a saída ser função pura da versão fixada, e é o que permite ao teste
// `test/architecture/generated_freshness_test.dart` chamar [formattedSources] e
// comparar com o que foi commitado. Geração e conferência partem da MESMA
// função, então não têm como divergir — o mesmo arranjo do `flocks_phosphor`.
import 'dart:io';

// ignore: implementation_imports
import 'package:flocks/src/tokens/app_icon_token.dart';
import 'package:flocks_lucide/src/flocks_to_lucide.dart';

import 'lucide_catalog.dart';

/// O arquivo da classe completa, relativo à raiz do pacote.
const String kIconsPath = '$kGeneratedDirectory/flocks_lucide_icons.dart';

/// O arquivo do mapa do contrato, relativo à raiz do pacote.
const String kContractPath = '$kGeneratedDirectory/lucide_contract.dart';

/// O identificador Dart de um nome kebab (`arrow-left-right` →
/// `arrowLeftRight`).
///
/// Alguns nomes do Lucide começam por dígito depois da conversão? Não: todos
/// começam por letra, e o teste de geração confere um a um — é o que pegaria um
/// nome novo do upstream que não coubesse.
String dartIdentifier(String kebab) {
  final List<String> parts = kebab.split('-');
  return <String>[
    parts.first,
    for (final String p in parts.skip(1))
      '${p[0].toUpperCase()}${p.substring(1)}',
  ].join();
}

/// O nome da classe com todos os ícones.
const String kClassName = 'FlocksLucide';

/// Um campo a emitir: o identificador Dart, o codepoint e os nomes que o
/// upstream dá ao mesmo desenho.
typedef Field = ({int codepoint, String identifier, List<String> names});

/// Os campos da classe, em ordem alfabética de identificador.
///
/// **Nomes diferentes podem virar o mesmo identificador Dart**, e no Lucide
/// 1.31.0 quatro pares viram: `arrow-down-0-1` e `arrow-down-01` (e os três
/// análogos) só diferem por um hífen que o camelCase come. Os dois nomes são
/// grafias do MESMO desenho — mesmo codepoint —, então um campo só os atende, e
/// a doc dele lista as duas grafias.
///
/// Colapsar é seguro exatamente enquanto o codepoint for o mesmo. Se um dia
/// dois DESENHOS distintos colidirem, um campo só passaria a desenhar o errado
/// para uma das grafias, em silêncio — por isso este caso lança, em vez de
/// escolher.
List<Field> fieldsOf(LucideCatalog catalog) {
  final Map<String, List<LucideIconEntry>> byIdentifier =
      <String, List<LucideIconEntry>>{};
  for (final LucideIconEntry icon in catalog.icons) {
    byIdentifier
        .putIfAbsent(dartIdentifier(icon.name), () => <LucideIconEntry>[])
        .add(icon);
  }

  final List<Field> fields = <Field>[];
  byIdentifier.forEach((String identifier, List<LucideIconEntry> group) {
    final Set<int> codepoints = group
        .map((LucideIconEntry i) => i.codepoint)
        .toSet();
    if (codepoints.length > 1) {
      throw StateError(
        'Os nomes ${group.map((LucideIconEntry i) => i.name).join(', ')} viram '
        'o identificador `$identifier` e apontam para codepoints diferentes '
        '($codepoints). Um campo só desenharia o ícone errado para uma das '
        'grafias. Desambigue no gerador antes de seguir.',
      );
    }
    fields.add((
      codepoint: codepoints.single,
      identifier: identifier,
      names: <String>[for (final LucideIconEntry i in group) i.name]..sort(),
    ));
  });
  return fields
    ..sort((Field a, Field b) => a.identifier.compareTo(b.identifier));
}

/// O nome do mapa do contrato.
const String kContractMapName = 'kLucideContract';

/// 2025 → `2.025`, que é como o resto da documentação do pacote escreve.
String _ptNumber(int n) => n.toString().replaceAllMapped(
  RegExp(r'(\d)(?=(\d{3})+$)'),
  (Match m) => '${m[1]}.',
);

/// Quebra [text] em linhas de doc de no máximo 80 colunas.
///
/// Escrever a prosa já quebrada no gerador produz parágrafos tortos assim que
/// um número interpolado muda de largura. Quebrar aqui mantém o texto legível
/// sem depender de sorte.
String _doc(String text, {String indent = ''}) {
  final List<String> lines = <String>[];
  StringBuffer line = StringBuffer();
  for (final String word in text.split(' ')) {
    if (line.isNotEmpty && '$indent/// $line $word'.length > 80) {
      lines.add('$indent/// $line');
      line = StringBuffer(word);
    } else {
      line.write(line.isEmpty ? word : ' $word');
    }
  }
  lines.add('$indent/// $line');
  return lines.join('\n');
}

/// O slug do Flocks traduzido para o nome no Lucide.
///
/// Ausente da tabela significa "o mesmo nome nos dois vocabulários" — 23 dos
/// 55.
String lucideNameOf(String slug) => kFlocksToLucide[slug] ?? slug;

String _hex(int codepoint) =>
    '0x${codepoint.toRadixString(16).padLeft(4, '0')}';

String _header(LucideCatalog catalog) =>
    '// GERADO por `$kGenerateCommand`. Não edite à mão.\n'
    '//\n'
    '// Lucide ${catalog.version} (lucide-static)\n';

String _iconsSource(LucideCatalog catalog) {
  final int total = catalog.icons.length;
  final StringBuffer out = StringBuffer(_header(catalog))
    ..writeln("\nimport 'package:flutter/widgets.dart';\n")
    ..writeln(_doc('Os ${_ptNumber(total)} ícones do Lucide.'))
    ..writeln('///')
    ..writeln('/// ```dart')
    ..writeln('/// const LucideIcon($kClassName.store)')
    ..writeln('/// ```')
    ..writeln('///')
    ..writeln(
      _doc(
        'A classe é anotada com `@staticIconProvider`, e é isso que mantém o '
        'pacote leve: o `--tree-shake-icons` ignora esta declaração inteira e '
        'embute na fonte só os codepoints que o app realmente escreveu. '
        'Escrever o campo direto é o que preserva esse ganho — qualquer coisa '
        'que torne os ${_ptNumber(total)} alcançáveis de uma vez traz a fonte '
        'inteira junto.',
      ),
    )
    ..writeln('///')
    ..writeln(
      _doc(
        'Nomes que o Lucide aposentou não estão aqui, mesmo aparecendo no '
        '`codepoints.json` do upstream: eles não têm glifo na fonte, e um '
        'campo para eles desenharia vazio. Ver `tool/vendor_lucide.dart`.',
      ),
    )
    ..writeln('@staticIconProvider')
    ..writeln('abstract final class $kClassName {')
    ..writeln('  /// A família declarada no `pubspec`.')
    ..writeln("  static const String fontFamily = '$kFontFamily';")
    ..writeln()
    ..writeln('  /// O pacote que embute a fonte.')
    ..writeln("  static const String fontPackage = '$kFontPackage';");

  for (final Field f in fieldsOf(catalog)) {
    out
      ..writeln()
      ..writeln('  /// ${f.names.map((String n) => '`$n`').join(', ')}')
      ..writeln('  static const IconData ${f.identifier} = IconData(')
      ..writeln('    ${_hex(f.codepoint)},')
      ..writeln('    fontFamily: fontFamily,')
      ..writeln('    fontPackage: fontPackage,')
      ..writeln('  );');
  }
  return (out..writeln('}')).toString();
}

String _contractSource(LucideCatalog catalog) {
  final List<String> slugs =
      AppIconToken.values.map((AppIconToken t) => t.slug).toList()..sort();
  final Map<String, LucideIconEntry> byName = <String, LucideIconEntry>{
    for (final LucideIconEntry i in catalog.icons) i.name: i,
  };

  final StringBuffer out = StringBuffer(_header(catalog))
    ..writeln("\nimport 'package:flutter/widgets.dart';\n")
    ..writeln("import 'flocks_lucide_icons.dart';\n")
    ..writeln(
      _doc('A tradução dos ${slugs.length} `AppIconToken` em glifo do Lucide.'),
    )
    ..writeln('///')
    ..writeln(
      _doc(
        '**É este mapa, e só ele, que o `LucideIconProvider` alcança.** Tudo '
        'alcançável por ele conta como escrito para o `--tree-shake-icons`, '
        'então um mapa dos ${_ptNumber(catalog.icons.length)} nomes traria a '
        'fonte inteira para o bundle de quem instalasse o pacote. Com '
        '${slugs.length} tokens, o custo é o dos ${slugs.length}. É por isso '
        'que o contrato e a classe completa são coisas separadas: mapa só dos '
        '${slugs.length}, [$kClassName] para o resto.',
      ),
    )
    ..writeln(
      'const Map<String, IconData> $kContractMapName = <String, IconData>{',
    );
  for (final String slug in slugs) {
    final LucideIconEntry icon = byName[lucideNameOf(slug)]!;
    out.writeln("  '$slug': $kClassName.${dartIdentifier(icon.name)},");
  }
  return (out..writeln('};')).toString();
}

/// O conteúdo de cada arquivo gerado antes de passar pelo formatador.
Map<String, String> generatedSources(LucideCatalog catalog) => <String, String>{
  kContractPath: _contractSource(catalog),
  kIconsPath: _iconsSource(catalog),
};

/// O conteúdo exato que cada arquivo gerado deve ter em disco, por caminho.
///
/// Passa a saída bruta pelo `dart format` antes de devolver, porque é ele quem
/// decide onde uma chamada quebra de linha — e essa decisão depende do
/// comprimento do identificador, que varia ícone a ícone. Reimplementar essas
/// regras no emissor seria manter um segundo formatador; rodar o de verdade
/// custa um processo e acerta sempre.
///
/// Pública porque o teste de deriva chama esta mesma função. Se a geração
/// morasse só dentro do `main`, o teste teria de reimplementá-la, e duas
/// implementações da mesma regra divergem.
Map<String, String> formattedSources(LucideCatalog catalog) {
  final Directory scratch = Directory.systemTemp.createTempSync(
    'flocks_lucide_gen',
  );
  try {
    final Map<String, String> raw = generatedSources(catalog);
    final Map<String, String> byBasename = <String, String>{};
    raw.forEach((String path, String content) {
      final String basename = path.split('/').last;
      byBasename[basename] = path;
      File('${scratch.path}/$basename').writeAsStringSync(content);
    });

    final ProcessResult result = Process.runSync('dart', <String>[
      'format',
      scratch.path,
    ]);
    if (result.exitCode != 0) {
      throw StateError('`dart format` falhou: ${result.stderr}');
    }

    return <String, String>{
      for (final MapEntry<String, String> e in byBasename.entries)
        e.value: File('${scratch.path}/${e.key}').readAsStringSync(),
    };
  } finally {
    scratch.deleteSync(recursive: true);
  }
}

void main() {
  final LucideCatalog catalog = readVendoredCatalog();
  Directory(kGeneratedDirectory).createSync(recursive: true);

  formattedSources(catalog).forEach((String path, String content) {
    File(path).writeAsStringSync(content);
    stdout.writeln(
      '  ${path.padRight(46)} ${'\n'.allMatches(content).length} linhas',
    );
  });

  stdout.writeln(
    '\n${catalog.icons.length} ícones de Lucide ${catalog.version}.',
  );
}
