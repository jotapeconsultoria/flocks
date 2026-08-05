// Baixa a matéria-prima do Phosphor na versão fixada em `phosphor_catalog.dart`
// e a deixa em `assets/fonts/` e `vendor/`.
//
// Uso: `dart run tool/vendor_phosphor.dart`
//
// É o único passo que fala com a rede, e o único que precisa rodar quando se
// sobe a versão do Phosphor. A geração (`generate_icons.dart`) e os testes leem
// só o que ficou em disco — se dependessem da rede, um PR passaria ou falharia
// conforme o GitHub estivesse no ar, e a versão "fixada" não seria fixada.
//
// Depois de rodar isto, rode `dart run tool/generate_icons.dart`.
import 'dart:convert';
import 'dart:io';

import 'package:flocks_phosphor/src/phosphor_weight.dart';

import 'phosphor_catalog.dart';

const String _kCoreRaw =
    'https://raw.githubusercontent.com/phosphor-icons/core/$kPhosphorCoreCommit';
const String _kWebRaw =
    'https://raw.githubusercontent.com/phosphor-icons/web/$kPhosphorWebTag';

/// A pasta de cada peso em `phosphor-icons/web`, que não é o nome do arquivo.
const Map<PhosphorWeight, String> _kWebDirectory = <PhosphorWeight, String>{
  PhosphorWeight.thin: 'thin',
  PhosphorWeight.light: 'light',
  PhosphorWeight.regular: 'regular',
  PhosphorWeight.bold: 'bold',
  PhosphorWeight.fill: 'fill',
  PhosphorWeight.duotone: 'duotone',
};

Future<List<int>> _fetch(String url) async {
  final HttpClient client = HttpClient();
  try {
    final HttpClientResponse response = await (await client.getUrl(
      Uri.parse(url),
    )).close();
    if (response.statusCode != 200) {
      throw StateError('HTTP ${response.statusCode} em $url');
    }
    return <int>[
      for (final List<int> chunk in await response.toList()) ...chunk,
    ];
  } finally {
    client.close();
  }
}

Future<String> _fetchText(String url) async => utf8.decode(await _fetch(url));

/// Lê `nome → codepoint` de um `style.css` do Phosphor.
///
/// [pseudo] escolhe a camada: `before` é o glifo do ícone em qualquer peso (e a
/// mancha de baixo, no duotone); `after` é a camada de cima do duotone.
///
/// É daqui que sai a numeração, e não do `codepoint` do `core` — ver a doc de
/// [PhosphorIconEntry] para os 9 nomes em que os dois discordam.
Map<String, int> parseStyleSheet(String css, {String pseudo = 'before'}) {
  final RegExp rule = RegExp(
    r'\.ph[a-z-]*\.ph-([a-z0-9-]+):' +
        pseudo +
        r' \{\s*content: "\\([0-9a-f]+)"',
  );
  final Map<String, int> codepoints = <String, int>{
    for (final RegExpMatch m in rule.allMatches(css))
      m.group(1)!: int.parse(m.group(2)!, radix: 16),
  };
  if (codepoints.length < 1000) {
    throw ArgumentError(
      'Só ${codepoints.length} regras `:$pseudo` saíram do CSS — o formato do '
      'upstream mudou. Conserte a regex; um mapa pela metade geraria classes '
      'pela metade sem nada ficar vermelho.',
    );
  }
  return codepoints;
}

/// Lê `nome canônico → apelidos` de `core/src/icons.ts`.
///
/// O `core` é usado só por isto: o CSS lista os 1.530 nomes sem dizer quais 18
/// são apelido de qual. O codepoint dele não é confiável — ver
/// [PhosphorIconEntry].
Map<String, List<String>> parseAliases(String source) {
  final RegExp entry = RegExp(r'\n  \{\n(.*?)\n  \},', dotAll: true);
  final RegExp name = RegExp(r'name: "([^"]+)"');
  final RegExp alias = RegExp(r'alias: \{ name: "([^"]+)"');

  final Map<String, List<String>> aliases = <String, List<String>>{
    for (final RegExpMatch m in entry.allMatches(source))
      name.firstMatch(m.group(1)!)!.group(1)!: <String>[
        if (alias.firstMatch(m.group(1)!) case final RegExpMatch a) a.group(1)!,
      ],
  };
  if (aliases.length < 1000) {
    throw ArgumentError(
      'Só ${aliases.length} ícones saíram de icons.ts — o formato mudou.',
    );
  }
  return aliases;
}

Future<void> main() async {
  stdout.writeln(
    'Phosphor web $kPhosphorWebTag · core '
    '${kPhosphorCoreCommit.substring(0, 8)}',
  );

  Directory(kFontsDirectory).createSync(recursive: true);
  for (final PhosphorWeight weight in PhosphorWeight.values) {
    final List<int> bytes = await _fetch(
      '$_kWebRaw/src/${_kWebDirectory[weight]}/${weight.fileName}',
    );
    File('$kFontsDirectory/${weight.fileName}').writeAsBytesSync(bytes);
    stdout.writeln(
      '  ${weight.fileName.padRight(22)} ${(bytes.length / 1024).round()} KB',
    );
  }

  // As duas licenças, porque são dois repositórios com titulares e anos
  // distintos. Embutir uma só e chamá-la de "a licença do Phosphor" seria
  // atribuição errada num pacote que vai para o pub.dev.
  for (final (String name, String url) in <(String, String)>[
    ('LICENSE-phosphor-core', '$_kCoreRaw/LICENSE'),
    ('LICENSE-phosphor-web', '$_kWebRaw/LICENSE'),
  ]) {
    File('$kFontsDirectory/$name').writeAsBytesSync(await _fetch(url));
    stdout.writeln('  $name');
  }

  // Um CSS por peso. Os cinco pesos de glifo único têm de concordar entre si e
  // com a camada de baixo do duotone — se um dia divergirem, uma entrada por
  // ícone deixa de bastar, e é melhor descobrir aqui do que por um ícone
  // errado em produção.
  final Map<PhosphorWeight, Map<String, int>> byWeight =
      <PhosphorWeight, Map<String, int>>{
        for (final PhosphorWeight w in PhosphorWeight.values)
          w: parseStyleSheet(
            await _fetchText('$_kWebRaw/src/${_kWebDirectory[w]}/style.css'),
          ),
      };
  final Map<String, int> codepoints = byWeight[PhosphorWeight.regular]!;
  for (final MapEntry<PhosphorWeight, Map<String, int>> e in byWeight.entries) {
    final List<String> diverged = <String>[
      for (final MapEntry<String, int> i in e.value.entries)
        if (codepoints[i.key] != i.value)
          '${i.key}: regular=${codepoints[i.key]} ${e.key.name}=${i.value}',
    ];
    if (diverged.isNotEmpty) {
      throw StateError(
        'O peso ${e.key.name} usa outra numeração em ${diverged.length} '
        'ícones: ${diverged.take(5).join(', ')}. O catálogo assume um '
        'codepoint por ícone para os seis pesos.',
      );
    }
  }

  final Map<String, int> duotoneFigures = parseStyleSheet(
    await _fetchText('$_kWebRaw/src/duotone/style.css'),
    pseudo: 'after',
  );
  final Map<String, List<String>> aliases = parseAliases(
    await _fetchText('$_kCoreRaw/src/icons.ts'),
  );

  final List<PhosphorIconEntry> icons =
      <PhosphorIconEntry>[
        for (final MapEntry<String, List<String>> e in aliases.entries)
          PhosphorIconEntry(
            aliases: e.value,
            codepoint: codepoints[e.key]!,
            duotoneFigure: duotoneFigures[e.key],
            name: e.key,
          ),
      ]..sort(
        (PhosphorIconEntry a, PhosphorIconEntry b) => a.name.compareTo(b.name),
      );

  File(kCatalogPath)
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(
      PhosphorCatalog(
        coreCommit: kPhosphorCoreCommit,
        icons: icons,
        webTag: kPhosphorWebTag,
      ).serialize(),
    );

  final int single = icons
      .where((PhosphorIconEntry i) => i.duotoneFigure == null)
      .length;
  final int derived = icons
      .where((PhosphorIconEntry i) => i.duotoneFigure == i.codepoint + 1)
      .length;
  stdout.writeln(
    '  $kCatalogPath  ${icons.length} ícones, '
    '${icons.fold(0, (int s, PhosphorIconEntry i) => s + i.aliases.length)} '
    'apelidos\n'
    '    duotone: ${icons.length - single} em duas camadas '
    '($derived em codepoint+1, ${icons.length - single - derived} não), '
    '$single em camada única\n'
    '\nAgora rode `$kGenerateCommand`.',
  );
}
