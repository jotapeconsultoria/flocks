// O catálogo do Lucide vendorizado: onde a versão fixada é declarada e como o
// arquivo em `vendor/` é lido.
//
// Compartilhado por `vendor_lucide.dart` (que baixa), `generate_icons.dart`
// (que gera) e pelos testes (que conferem). O pin mora aqui e em nenhum outro
// lugar — foi a duplicação de número escrito à mão que já produziu deriva
// silenciosa no catálogo de componentes do core.
import 'dart:convert';
import 'dart:io';

/// A versão de `lucide-static` de onde a TTF e os codepoints saíram.
///
/// É a versão npm, que é imutável: um `1.31.0` publicado nunca muda de
/// conteúdo. Vale como pin tanto quanto uma tag do git — e é o pacote que
/// publica a fonte já construída, que é o que este pacote vendoriza.
const String kLucideVersion = '1.31.0';

/// O sha256 de `assets/fonts/lucide.ttf` na versão fixada.
///
/// Onde o `flocks_phosphor` confia só na imutabilidade da referência, aqui há
/// digest: a fonte chega por um CDN, e um CDN é mais superfície do que um
/// `raw.githubusercontent` por commit. Conferido no download e reconferido em
/// disco a cada `flutter test`.
const String kLucideFontSha256 =
    '5d4c9bcc577eb2bcdd3e9e0fb6f05eecb872d4a0f715e429b71f21fb15199cb4';

/// O sha256 de `assets/fonts/LICENSE-lucide` na versão fixada.
const String kLucideLicenseSha256 =
    'b495047bd93a9b06913511076f504daba17d5bbeb3e0650f3bb53a4220329c57';

/// O catálogo vendorizado, relativo à raiz do pacote.
const String kCatalogPath = 'vendor/lucide_icons.json';

/// Onde a TTF vive, relativo à raiz do pacote.
const String kFontsDirectory = 'assets/fonts';

/// O nome do arquivo de fonte, como o `pubspec` o declara.
const String kFontFileName = 'lucide.ttf';

/// A licença de origem, vendorizada ao lado da fonte que ela cobre.
const String kLicenseFileName = 'LICENSE-lucide';

/// A família declarada no `pubspec`.
const String kFontFamily = 'Lucide';

/// O pacote que embute a fonte.
const String kFontPackage = 'flocks_lucide';

/// O comando que rebaixa a matéria-prima — citado nas mensagens de falha.
const String kVendorCommand = 'dart run tool/vendor_lucide.dart';

/// O comando que regenera as classes — citado nas mensagens de falha.
const String kGenerateCommand = 'dart run tool/generate_icons.dart';

/// Onde as classes geradas moram, relativo à raiz do pacote.
const String kGeneratedDirectory = 'lib/src/generated';

/// Um ícone do Lucide: o nome kebab e o codepoint na fonte.
///
/// ## De onde vem o codepoint
///
/// De `font/codepoints.json`, que o `lucide-static` publica **ao lado da
/// própria fonte**, no mesmo build. Um mapa que viaja junto do binário não tem
/// como divergir dele — é a mesma escolha que o `flocks_phosphor` fez ao ler o
/// `style.css` do lado da TTF em vez do campo `codepoint` do repositório de
/// origem, que lá divergia em 9 nomes.
///
/// O `vendor_lucide.dart` ainda confere esse mapa contra o `font/lucide.css`,
/// que é gerado pelo mesmo build a partir da mesma fonte: se os dois
/// discordarem, o formato do upstream mudou e é melhor descobrir ali do que por
/// um ícone errado em produção.
final class LucideIconEntry {
  /// Cria uma entrada do catálogo.
  const LucideIconEntry({required this.codepoint, required this.name});

  /// Lê uma entrada do JSON vendorizado.
  factory LucideIconEntry.fromJson(Map<String, Object?> json) =>
      LucideIconEntry(
        codepoint: json['codepoint']! as int,
        name: json['name']! as String,
      );

  /// O codepoint do desenho na fonte.
  final int codepoint;

  /// O nome kebab do Lucide (`arrow-left-right`).
  final String name;

  /// O JSON desta entrada, com as chaves em ordem alfabética.
  Map<String, Object?> toJson() => <String, Object?>{
    'codepoint': codepoint,
    'name': name,
  };
}

/// O catálogo inteiro, com o pin de onde ele veio.
final class LucideCatalog {
  /// Cria um catálogo.
  const LucideCatalog({
    required this.fontSha256,
    required this.icons,
    required this.licenseSha256,
    required this.version,
  });

  /// Lê o catálogo de [kCatalogPath].
  factory LucideCatalog.fromJson(Map<String, Object?> json) => LucideCatalog(
    fontSha256: json['fontSha256']! as String,
    icons: <LucideIconEntry>[
      for (final Object? e in json['icons']! as List<Object?>)
        LucideIconEntry.fromJson(e! as Map<String, Object?>),
    ],
    licenseSha256: json['licenseSha256']! as String,
    version: json['version']! as String,
  );

  /// O sha256 da TTF que gerou este arquivo.
  final String fontSha256;

  /// Os ícones, em ordem de nome.
  final List<LucideIconEntry> icons;

  /// O sha256 da licença de origem vendorizada.
  final String licenseSha256;

  /// A versão de `lucide-static` que gerou este arquivo.
  final String version;

  /// O conteúdo exato que [kCatalogPath] deve ter, com a quebra final.
  String serialize() =>
      '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{
        'fontSha256': fontSha256,
        'icons': <Map<String, Object?>>[for (final LucideIconEntry i in icons) i.toJson()],
        'licenseSha256': licenseSha256,
        'version': version,
      })}\n';
}

/// Lê o catálogo vendorizado a partir de [root] (a raiz do pacote).
///
/// Falha com a instrução de regenerar quando o arquivo não existe: quem clonou
/// o repositório precisa saber qual comando rodar, e não que um `null` viajou.
LucideCatalog readVendoredCatalog({String root = '.'}) {
  final File file = File('$root/$kCatalogPath');
  if (!file.existsSync()) {
    throw StateError('$kCatalogPath não existe. Rode `$kVendorCommand`.');
  }
  return LucideCatalog.fromJson(
    jsonDecode(file.readAsStringSync()) as Map<String, Object?>,
  );
}
