// Gera as classes de ícone a partir do catálogo vendorizado.
//
// Uso: `dart run tool/generate_icons.dart`
//
// Lê só o que está em disco (`vendor/phosphor_icons.json`), nunca a rede: é o
// que faz a saída ser função pura da versão fixada, e é o que permite ao teste
// `test/architecture/generated_freshness_test.dart` chamar [formattedSources] e
// comparar com o que foi commitado. Geração e conferência partem da MESMA
// função, então não têm como divergir — o mesmo arranjo de
// `tool/serialize_meta.dart` no core, que nasceu de um catálogo que derivou
// duas vezes em três dias por depender de alguém lembrar de rodar o comando.
import 'dart:io';

// ignore: implementation_imports
import 'package:flocks/src/tokens/app_icon_token.dart';
import 'package:flocks_phosphor/src/flocks_to_phosphor.dart';
import 'package:flocks_phosphor/src/phosphor_weight.dart';

import 'phosphor_catalog.dart';

/// Onde as classes geradas moram, relativo à raiz do pacote.
const String kGeneratedDirectory = 'lib/src/generated';

/// O arquivo dos mapas do contrato, relativo à raiz do pacote.
const String kContractPath = '$kGeneratedDirectory/phosphor_contract.dart';

/// O identificador Dart de um nome kebab (`arrow-square-out` →
/// `arrowSquareOut`).
///
/// Três nomes do Phosphor — `export`, `factory` e `function` — são
/// identificadores embutidos do Dart. Como membros estáticos eles são legais,
/// então não há escape a fazer; o teste de geração confere que todo
/// identificador emitido é válido, que é o que pegaria um nome novo do upstream
/// que não fosse.
String dartIdentifier(String kebab) {
  final List<String> parts = kebab.split('-');
  return <String>[
    parts.first,
    for (final String p in parts.skip(1))
      '${p[0].toUpperCase()}${p.substring(1)}',
  ].join();
}

/// O nome da classe de [weight] (`FlocksPhosphorBold`).
String className(PhosphorWeight weight) =>
    'FlocksPhosphor${_capitalize(weight.name)}';

/// O nome do mapa de contrato de [weight] (`kPhosphorContractBold`).
String contractName(PhosphorWeight weight) =>
    'kPhosphorContract${_capitalize(weight.name)}';

/// O arquivo de [weight], relativo à raiz do pacote.
String sourcePath(PhosphorWeight weight) =>
    '$kGeneratedDirectory/flocks_phosphor_${weight.name}.dart';

String _capitalize(String s) => '${s[0].toUpperCase()}${s.substring(1)}';

/// 1512 → `1.512`, que é como o resto da documentação do pacote escreve.
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

/// Um campo a emitir: o identificador Dart e o ícone que ele nomeia.
typedef _Field = ({String identifier, PhosphorIconEntry icon, String kebab});

/// Todos os campos de uma classe, em ordem alfabética de identificador.
///
/// Apelidos entram como campos próprios apontando para o mesmo codepoint. São
/// 18, e custam zero no bundle — a classe é anotada com `@staticIconProvider`,
/// então o tree-shaker ignora a declaração inteira e só retém o que o app
/// escrever. O ganho é para quem chega pelo nome antigo, vindo de uma classe
/// CSS ou de outro binding.
List<_Field> _fieldsOf(PhosphorCatalog catalog) {
  final List<_Field> fields = <_Field>[
    for (final PhosphorIconEntry icon in catalog.icons) ...<_Field>[
      (identifier: dartIdentifier(icon.name), icon: icon, kebab: icon.name),
      for (final String alias in icon.aliases)
        (identifier: dartIdentifier(alias), icon: icon, kebab: alias),
    ],
  ];
  return fields
    ..sort((_Field a, _Field b) => a.identifier.compareTo(b.identifier));
}

/// O slug do Flocks traduzido para o nome no Phosphor.
///
/// Ausente da tabela significa "o mesmo nome nos dois vocabulários" — 19 dos
/// 55.
String phosphorNameOf(String slug) => kFlocksToPhosphor[slug] ?? slug;

String _hex(int codepoint) =>
    '0x${codepoint.toRadixString(16).padLeft(4, '0')}';

String _header(PhosphorCatalog catalog) =>
    '// GERADO por `$kGenerateCommand`. Não edite à mão.\n'
    '//\n'
    '// Phosphor web ${catalog.webTag} · core '
    '${catalog.coreCommit.substring(0, 8)}\n';

String _fieldDoc(_Field f) => f.kebab == f.icon.name
    ? '  /// `${f.kebab}`'
    : '  /// `${f.kebab}` — apelido de `${f.icon.name}`';

String _classPreamble(PhosphorCatalog catalog, PhosphorWeight weight) =>
    '@staticIconProvider\n'
    'abstract final class ${className(weight)} {\n'
    '  /// A família declarada no `pubspec` para este peso.\n'
    "  static const String fontFamily = '${weight.fontFamily}';\n"
    '\n'
    '  /// O pacote que embute a fonte.\n'
    "  static const String fontPackage = 'flocks_phosphor';\n";

String _monoSource(PhosphorCatalog catalog, PhosphorWeight weight) {
  final int total = catalog.icons.length;
  final StringBuffer out = StringBuffer(_header(catalog))
    ..writeln("\nimport 'package:flutter/widgets.dart';\n")
    ..writeln(
      _doc(
        'Os ${_ptNumber(total)} ícones do Phosphor no peso `${weight.name}`.',
      ),
    )
    ..writeln('///')
    ..writeln('/// ```dart')
    ..writeln('/// const PhosphorIcon(${className(weight)}.storefront)')
    ..writeln('/// ```')
    ..writeln('///')
    ..writeln(
      _doc(
        'A classe é anotada com `@staticIconProvider`, e é isso que mantém o '
        'pacote leve: o `--tree-shake-icons` ignora esta declaração inteira e '
        'embute na fonte só os codepoints que o app realmente escreveu. '
        'Escrever o campo direto é o que preserva esse ganho — um seletor de '
        'peso em tempo de execução tornaria os ${_ptNumber(total)} '
        'alcançáveis de uma vez e traria a fonte inteira junto.',
      ),
    )
    ..write(_classPreamble(catalog, weight));

  for (final _Field f in _fieldsOf(catalog)) {
    out
      ..writeln()
      ..writeln(_fieldDoc(f))
      ..writeln('  static const IconData ${f.identifier} = IconData(')
      ..writeln('    ${_hex(f.icon.codepoint)},')
      ..writeln('    fontFamily: fontFamily,')
      ..writeln('    fontPackage: fontPackage,')
      ..writeln('  );');
  }
  return (out..writeln('}')).toString();
}

String _duotoneSource(PhosphorCatalog catalog) {
  const PhosphorWeight weight = PhosphorWeight.duotone;
  final int total = catalog.icons.length;
  final StringBuffer out = StringBuffer(_header(catalog))
    ..writeln("\nimport 'package:flutter/widgets.dart';\n")
    ..writeln("import '../phosphor_duotone_icon_data.dart';\n")
    ..writeln(
      _doc('Os ${_ptNumber(total)} ícones do Phosphor no peso `duotone`.'),
    )
    ..writeln('///')
    ..writeln('/// ```dart')
    ..writeln('/// const PhosphorDuotoneIcon(${className(weight)}.storefront)')
    ..writeln('/// ```')
    ..writeln('///')
    ..writeln(
      _doc(
        '**Quase todo campo carrega DOIS codepoints**, não um: o duotone é o '
        'único peso montado empilhando dois glifos. Ver '
        '[PhosphorDuotoneIconData] — é por isso que o tipo aqui não é '
        '`IconData`: com um glifo só, o ícone sai pela metade.',
      ),
    )
    ..writeln('///')
    ..writeln(
      _doc(
        'O par vem LIDO do CSS que o Phosphor publica ao lado da fonte, e não '
        'calculado: `codepoint + 1` acerta 1.462 dos ${_ptNumber(total)} e '
        'erra os outros. Dois ícones têm camada única e saem sem `ground`.',
      ),
    )
    ..writeln('///')
    ..writeln(
      _doc(
        'Os `IconData` são constantes, e precisam ser: o `--tree-shake-icons` '
        'só enxerga codepoint escrito como constante, e um calculado em '
        'execução sumiria da fonte no build de release.',
      ),
    )
    ..write(_classPreamble(catalog, weight));

  for (final _Field f in _fieldsOf(catalog)) {
    out
      ..writeln()
      ..writeln(_fieldDoc(f))
      ..writeln(
        '  static const PhosphorDuotoneIconData ${f.identifier} = '
        'PhosphorDuotoneIconData(',
      )
      ..writeln(
        '    figure: IconData(${_hex(f.icon.duotoneFigure ?? f.icon.codepoint)},'
        ' fontFamily: fontFamily, fontPackage: fontPackage),',
      );
    if (f.icon.duotoneFigure != null) {
      out.writeln(
        '    ground: IconData(${_hex(f.icon.codepoint)}, '
        'fontFamily: fontFamily, fontPackage: fontPackage),',
      );
    }
    out.writeln('  );');
  }
  return (out..writeln('}')).toString();
}

String _contractSource(PhosphorCatalog catalog) {
  final List<String> slugs =
      AppIconToken.values.map((AppIconToken t) => t.slug).toList()..sort();
  final Map<String, PhosphorIconEntry> byName = <String, PhosphorIconEntry>{
    for (final PhosphorIconEntry i
        in catalog.icons) ...<String, PhosphorIconEntry>{
      i.name: i,
      for (final String alias in i.aliases) alias: i,
    },
  };

  final StringBuffer out = StringBuffer(_header(catalog))
    ..writeln("\nimport 'package:flutter/widgets.dart';\n")
    ..writeln("import '../phosphor_duotone_icon_data.dart';");
  // Ordem alfabética de caminho, que é o que `directives_ordering` cobra — e
  // não a ordem da rampa de pesos.
  for (final PhosphorWeight w in <PhosphorWeight>[
    ...PhosphorWeight.values,
  ]..sort((PhosphorWeight a, PhosphorWeight b) => a.name.compareTo(b.name))) {
    out.writeln("import 'flocks_phosphor_${w.name}.dart';");
  }
  out
    ..writeln()
    ..writeln(
      _doc(
        'A tradução dos ${slugs.length} `AppIconToken` em glifo, peso a peso.',
      ),
    )
    ..writeln('///')
    ..writeln(
      _doc(
        '**Estes mapas são o preço do peso como eixo de marca.** O '
        '`PhosphorIconProvider` resolve o peso em execução, então os seis '
        'mapas são alcançáveis e os seus glifos ficam retidos na fonte, use o '
        'app um peso ou os seis. Com ${slugs.length} tokens isso é pequeno e '
        'é o comportamento certo; um mapa dos ${_ptNumber(catalog.icons.length)} '
        'mataria o tree-shaking. É por isso que o contrato e as classes '
        'completas são coisas separadas: mapa só dos ${slugs.length}, classe '
        'para o resto.',
      ),
    );

  /// O campo da classe de peso que serve [slug].
  String fieldFor(String slug) {
    final String name = phosphorNameOf(slug);
    final PhosphorIconEntry icon = byName[name]!;
    return dartIdentifier(icon.aliases.contains(name) ? name : icon.name);
  }

  for (final PhosphorWeight w in PhosphorWeight.values) {
    if (w == PhosphorWeight.duotone) {
      continue;
    }
    out.writeln(
      'const Map<String, IconData> ${contractName(w)} = <String, IconData>{',
    );
    for (final String slug in slugs) {
      out.writeln("  '$slug': ${className(w)}.${fieldFor(slug)},");
    }
    out
      ..writeln('};')
      ..writeln();
  }

  // O duotone sai em DOIS mapas de `IconData`, e não num de
  // `PhosphorDuotoneIconData`. Ver a doc emitida logo acima deles.
  for (final (String suffix, String layer) in <(String, String)>[
    ('Figure', 'figure'),
    ('Ground', 'ground'),
  ]) {
    out
      ..writeln(
        _doc(
          'A camada `$layer` dos ${slugs.length} `AppIconToken` em `duotone`.',
        ),
      )
      ..writeln('///')
      ..writeln(
        _doc(
          'São dois mapas de `IconData`, e não um de '
          '`PhosphorDuotoneIconData`, por uma razão medida: o '
          '`--tree-shake-icons` NÃO encontra um `IconData` aninhado dentro de '
          'outro objeto constante dentro de um mapa constante. Com o mapa '
          'único, um app em `duotone` compilava e embarcava a fonte sem '
          'nenhum glifo do contrato — 1,3 KB e ícones em branco, só no build '
          'de release. Com dois mapas de `IconData`, que é a forma que os '
          'outros cinco pesos já usavam, os glifos são retidos.',
        ),
      )
      ..writeln('///')
      ..writeln(
        _doc(
          'O mapa `ground` não tem os ícones de camada única — ver '
          '[PhosphorDuotoneIconData.ground].',
        ),
      )
      ..writeln(
        'const Map<String, IconData> ${contractName(PhosphorWeight.duotone)}'
        '$suffix = <String, IconData>{',
      );
    for (final String slug in slugs) {
      final PhosphorIconEntry icon = byName[phosphorNameOf(slug)]!;
      // O codepoint vai LITERAL, e não como `FlocksPhosphorDuotone.x.$layer`:
      // acessar campo de um objeto constante não é expressão constante em
      // Dart, então a referência nem compilaria — e é justamente a forma
      // literal que o tree-shaker enxerga.
      final int? codepoint = layer == 'ground'
          ? (icon.duotoneFigure == null ? null : icon.codepoint)
          : icon.duotoneFigure ?? icon.codepoint;
      if (codepoint == null) {
        continue;
      }
      out.writeln(
        "  '$slug': IconData(${_hex(codepoint)}, "
        'fontFamily: ${className(PhosphorWeight.duotone)}.fontFamily, '
        'fontPackage: ${className(PhosphorWeight.duotone)}.fontPackage),',
      );
    }
    out
      ..writeln('};')
      ..writeln();
  }

  final String source = out.toString();
  return source.substring(0, source.length - 1);
}

/// O conteúdo de cada arquivo gerado antes de passar pelo formatador.
Map<String, String> generatedSources(PhosphorCatalog catalog) =>
    <String, String>{
      kContractPath: _contractSource(catalog),
      for (final PhosphorWeight w in PhosphorWeight.values)
        sourcePath(w): w == PhosphorWeight.duotone
            ? _duotoneSource(catalog)
            : _monoSource(catalog, w),
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
Map<String, String> formattedSources(PhosphorCatalog catalog) {
  final Directory scratch = Directory.systemTemp.createTempSync(
    'flocks_phosphor_gen',
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
  final PhosphorCatalog catalog = readVendoredCatalog();
  Directory(kGeneratedDirectory).createSync(recursive: true);

  formattedSources(catalog).forEach((String path, String content) {
    File(path).writeAsStringSync(content);
    stdout.writeln(
      '  ${path.padRight(46)} ${'\n'.allMatches(content).length} linhas',
    );
  });

  stdout.writeln(
    '\n${catalog.icons.length} ícones × ${PhosphorWeight.values.length} pesos '
    'de Phosphor web ${catalog.webTag}.',
  );
}
