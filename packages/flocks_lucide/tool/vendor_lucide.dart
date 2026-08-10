// Baixa a matéria-prima do Lucide na versão fixada em `lucide_catalog.dart` e a
// deixa em `assets/fonts/` e `vendor/`.
//
// Uso: `dart run tool/vendor_lucide.dart`
//
// É o único passo que fala com a rede, e o único que precisa rodar quando se
// sobe a versão do Lucide. A geração (`generate_icons.dart`) e os testes leem só
// o que ficou em disco — se dependessem da rede, um PR passaria ou falharia
// conforme o CDN estivesse no ar, e a versão "fixada" não seria fixada.
//
// Depois de rodar isto, rode `dart run tool/generate_icons.dart`.
//
// ## Por que a fonte vem pronta, e não é construída aqui
//
// O Lucide publica a TTF já compilada, no mesmo build que produz o
// `codepoints.json`. Construí-la a partir dos ~1.600 SVGs exigiria toolchain de
// fonte no repositório e reprodutibilidade byte a byte para o gate de frescor
// — e produziria, na melhor das hipóteses, a mesma fonte. É a mesma decisão do
// `flocks_phosphor`, que vendoriza as seis TTFs de `phosphor-icons/web`.
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'lucide_catalog.dart';

/// A raiz do pacote npm na versão fixada.
///
/// `lucide-static` é o pacote que publica a fonte construída. Versão npm é
/// imutável: `@1.31.0` hoje e daqui a um ano é o mesmo conteúdo.
const String _kBase =
    'https://cdn.jsdelivr.net/npm/lucide-static@$kLucideVersion';

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

/// Confere o digest de [bytes] contra o pin, ou explica o que fazer.
///
/// Divergência não é conserto automático: subir o pin é decisão humana, e um
/// tool que reescrevesse o const sozinho tornaria o pin decorativo — bastaria
/// um CDN comprometido para o repositório passar a "confiar" no que veio.
void _verify(String label, List<int> bytes, String expected) {
  final String actual = sha256.convert(bytes).toString();
  if (actual != expected) {
    throw StateError(
      'O sha256 de $label não bate com o pin de `lucide_catalog.dart`.\n'
      '  esperado: $expected\n'
      '  obtido:   $actual\n'
      'Se você subiu $kLucideVersion de propósito, troque a constante pelo '
      'valor obtido no mesmo commit. Se não subiu, o conteúdo mudou embaixo de '
      'uma versão que deveria ser imutável — não vendorize antes de entender.',
    );
  }
  stdout.writeln('  $label  sha256 ok');
}

/// Lê `nome → codepoint` do `font/lucide.css`.
///
/// **É daqui que sai a numeração**, e não do `font/codepoints.json` — o que é o
/// contrário do que o nome dos dois arquivos sugere, e foi medido, não suposto.
///
/// Em `lucide-static 1.31.0`, o `codepoints.json` lista 2.045 nomes e o CSS
/// lista 2.025. Os 20 de diferença — `chrome`, `chromium`, `codepen`,
/// `codesandbox`, `dribbble`, `facebook`, `figma`, `framer`, `github`,
/// `gitlab`, `instagram`, `linkedin`, `pocket`, `slack`, `trello`, `twitch`,
/// `twitter`, `youtube`, `circle-euro-sign` e `rail-symbol` — **não têm glifo
/// na fonte**: são nomes retirados do set (as marcas saíram do Lucide) cujo
/// codepoint o `codepoints.json` preserva para não renumerar o resto. Gerar por
/// ele produziria 20 constantes que desenham vazio, e nada ficaria vermelho.
///
/// O CSS, ao contrário, é gerado do mesmo build que empacota a TTF e descreve o
/// que ela de fato contém: os 2.025 nomes dele têm glifo, conferido pelo gate
/// `font_coverage`. É a mesma escolha do `flocks_phosphor` — ler o artefato que
/// viaja ao lado do binário, e não o que o repositório de origem publica como
/// verdade.
Map<String, int> parseStyleSheet(String css) {
  final RegExp rule = RegExp(
    r'\.icon-([a-z0-9-]+)::before\s*\{\s*content:\s*"\\([0-9a-f]+)"',
  );
  final Map<String, int> codepoints = <String, int>{
    for (final RegExpMatch m in rule.allMatches(css))
      m.group(1)!: int.parse(m.group(2)!, radix: 16),
  };
  if (codepoints.length < 1000) {
    throw ArgumentError(
      'Só ${codepoints.length} regras saíram do CSS — o formato do upstream '
      'mudou. Conserte a regex; um mapa pela metade geraria classes pela '
      'metade sem nada ficar vermelho.',
    );
  }
  return codepoints;
}

Future<void> main() async {
  stdout.writeln('Lucide $kLucideVersion (lucide-static)');

  Directory(kFontsDirectory).createSync(recursive: true);

  final List<int> font = await _fetch('$_kBase/font/$kFontFileName');
  _verify(kFontFileName, font, kLucideFontSha256);
  File('$kFontsDirectory/$kFontFileName').writeAsBytesSync(font);
  stdout.writeln('  $kFontFileName  ${(font.length / 1024).round()} KB');

  // A licença de origem viaja junto do asset que ela cobre — a ISC exige o
  // aviso em toda cópia, e o arquivo do Lucide traz também a parte derivada do
  // Feather, que é MIT de outro titular. Uma licença só, resumida por nós,
  // seria atribuição errada num pacote que vai para o pub.dev.
  final List<int> license = await _fetch('$_kBase/LICENSE');
  _verify(kLicenseFileName, license, kLucideLicenseSha256);
  File('$kFontsDirectory/$kLicenseFileName').writeAsBytesSync(license);

  final Map<String, int> codepoints = parseStyleSheet(
    await _fetchText('$_kBase/font/lucide.css'),
  );

  // O `codepoints.json` entra como conferência, não como fonte: ele é um
  // superconjunto que carrega nomes já retirados do set (ver [parseStyleSheet]).
  // O que se cobra dele é concordância onde os dois se sobrepõem, e cobertura
  // do CSS — um nome no CSS que não esteja no JSON significaria que os dois
  // artefatos deixaram de sair do mesmo build.
  final Map<String, Object?> raw =
      jsonDecode(await _fetchText('$_kBase/font/codepoints.json'))
          as Map<String, Object?>;
  final Map<String, int> fromJson = <String, int>{
    for (final MapEntry<String, Object?> e in raw.entries)
      e.key: e.value! as int,
  };
  final List<String> diverged = <String>[
    for (final MapEntry<String, int> e in codepoints.entries)
      if (fromJson[e.key] != e.value)
        '${e.key}: css=${e.value} json=${fromJson[e.key]}',
  ];
  if (diverged.isNotEmpty) {
    throw StateError(
      'O `lucide.css` e o `codepoints.json` do mesmo build discordam em '
      '${diverged.length} nomes: ${diverged.take(5).join(', ')}. Os dois saem '
      'do mesmo empacotamento — se divergem, o formato mudou e a numeração '
      'deixou de ser confiável.',
    );
  }
  final List<String> retired = <String>[
    for (final String name in fromJson.keys)
      if (!codepoints.containsKey(name)) name,
  ]..sort();

  final List<LucideIconEntry> icons = <LucideIconEntry>[
    for (final MapEntry<String, int> e in codepoints.entries)
      LucideIconEntry(codepoint: e.value, name: e.key),
  ]..sort((LucideIconEntry a, LucideIconEntry b) => a.name.compareTo(b.name));

  File(kCatalogPath)
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(
      LucideCatalog(
        fontSha256: sha256.convert(font).toString(),
        icons: icons,
        licenseSha256: sha256.convert(license).toString(),
        version: kLucideVersion,
      ).serialize(),
    );

  // O que ficou de fora é dito em voz alta. Um corte silencioso é o que faz
  // "o catálogo tem tudo" virar mentira sem ninguém notar.
  stdout.writeln(
    '  $kCatalogPath  ${icons.length} nomes\n'
    '    ${retired.length} nomes do codepoints.json ficaram de fora, por não '
    'terem glifo na fonte:\n'
    '    ${retired.join(', ')}\n'
    '\nAgora rode `$kGenerateCommand`.',
  );
}
