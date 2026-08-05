// O catálogo do Phosphor vendorizado: onde a versão fixada é declarada e como
// o arquivo em `vendor/` é lido.
//
// Compartilhado por `vendor_phosphor.dart` (que baixa), `generate_icons.dart`
// (que gera) e pelos testes (que conferem). O pin mora aqui e em nenhum outro
// lugar — foi a duplicação de número escrito à mão que já produziu deriva
// silenciosa no catálogo de componentes do core.
import 'dart:convert';
import 'dart:io';

/// A tag de `phosphor-icons/web` de onde as TTFs e os codepoints saíram.
const String kPhosphorWebTag = 'v2.1.2';

/// O commit de `phosphor-icons/core` que [kPhosphorWebTag] fixa como submódulo.
///
/// Um commit e não uma tag porque é isto que o `web` realmente aponta. Confira
/// com:
/// `curl -s https://api.github.com/repos/phosphor-icons/web/contents/core?ref=$kPhosphorWebTag`
const String kPhosphorCoreCommit = '33fb01d1d33cd0156633ea4d33f4011fabe4d2da';

/// O catálogo vendorizado, relativo à raiz do pacote.
const String kCatalogPath = 'vendor/phosphor_icons.json';

/// Onde as TTFs vivem, relativo à raiz do pacote.
const String kFontsDirectory = 'assets/fonts';

/// O comando que rebaixa a matéria-prima — citado nas mensagens de falha.
const String kVendorCommand = 'dart run tool/vendor_phosphor.dart';

/// O comando que regenera as classes — citado nas mensagens de falha.
const String kGenerateCommand = 'dart run tool/generate_icons.dart';

/// Um ícone do Phosphor: o nome kebab, o codepoint e a segunda camada.
///
/// ## De onde vem o codepoint, e por que não do lugar óbvio
///
/// `phosphor-icons/core` publica um campo `codepoint` anunciado como estável e
/// destinado a implementações em fonte. **Ele não serve aqui**, e isso foi
/// medido, não suposto: em `web v2.1.2`, o `codepoint` do `core` diverge do que
/// as fontes realmente usam em 9 nomes — `building-office`, `crane-tower`,
/// `file-ini`, `file-txt`, `jar-label`, `lego-smiley`, `question-mark`,
/// `solar-roof` e `tip-jar`. O `core` dá a esses o codepoint do sinônimo
/// canônico (`building-apartment`, `crane`, …); a fonte dá um próprio. Gerar
/// pelo `core` desenharia o ícone errado nesses nove, em todos os seis pesos, e
/// nada ficaria vermelho.
///
/// Então o codepoint sai de `web/src/<peso>/style.css`, que é o arquivo que o
/// upstream publica **ao lado da própria fonte**. Um mapa que viaja junto do
/// binário não tem como divergir dele. Continua sendo upstream — a regra de não
/// inventar nem manter mapa próprio vale, só que aplicada ao artefato certo.
///
/// O `core` segue sendo lido, pelo que só ele tem: quais nomes são apelidos de
/// quais.
final class PhosphorIconEntry {
  /// Cria uma entrada do catálogo.
  const PhosphorIconEntry({
    required this.aliases,
    required this.codepoint,
    required this.duotoneFigure,
    required this.name,
  });

  /// Lê uma entrada do JSON vendorizado.
  factory PhosphorIconEntry.fromJson(Map<String, Object?> json) =>
      PhosphorIconEntry(
        aliases: <String>[...?(json['aliases'] as List<Object?>?)?.cast()],
        codepoint: json['codepoint']! as int,
        duotoneFigure: json['duotoneFigure'] as int?,
        name: json['name']! as String,
      );

  /// Outros nomes do mesmo desenho, publicados pelo `core`.
  ///
  /// São 18 no catálogo — `folder-notch` para `folder`, `activity` para
  /// `pulse`. Entram nas classes geradas porque quem migra de outro binding ou
  /// de uma classe CSS chega pelo nome antigo, e um campo a mais numa classe
  /// anotada com `@staticIconProvider` não custa byte nenhum no bundle.
  final List<String> aliases;

  /// O codepoint do desenho, o mesmo nos seis pesos.
  ///
  /// Os seis arquivos de fonte usam a mesma numeração — conferido peso a peso
  /// no `vendor_phosphor.dart`, que reprova se algum divergir. É por isso que
  /// uma entrada basta para os seis.
  ///
  /// No `duotone`, é a camada de baixo (a mancha a 20%) quando existe
  /// [duotoneFigure], e o ícone inteiro quando não.
  final int codepoint;

  /// A camada de cima do `duotone` — o contorno —, ou `null`.
  ///
  /// **Não é `codepoint + 1`.** É o que mais parece: 1.462 dos 1.512 seguem
  /// essa regra, e ela é fácil de assumir olhando meia dúzia de exemplos. Mas
  /// 48 ícones têm distâncias de 2 a 33, e `cell-signal-none` e `wifi-none`
  /// simplesmente não têm segunda camada (o desenho é um traço só, sem área
  /// para preencher). Por isso o par vem lido do `:after` do CSS do duotone, e
  /// não calculado.
  ///
  /// `null` significa camada única: o glifo de [codepoint] é o ícone todo, em
  /// opacidade cheia.
  final int? duotoneFigure;

  /// O nome kebab do `core` (`arrow-square-out`).
  final String name;

  /// O JSON desta entrada, com as chaves em ordem alfabética.
  Map<String, Object?> toJson() => <String, Object?>{
    'aliases': aliases,
    'codepoint': codepoint,
    'duotoneFigure': duotoneFigure,
    'name': name,
  };
}

/// O catálogo inteiro, com o pin de onde ele veio.
final class PhosphorCatalog {
  /// Cria um catálogo.
  const PhosphorCatalog({
    required this.coreCommit,
    required this.icons,
    required this.webTag,
  });

  /// Lê o catálogo de [kCatalogPath].
  factory PhosphorCatalog.fromJson(Map<String, Object?> json) =>
      PhosphorCatalog(
        coreCommit: json['coreCommit']! as String,
        icons: <PhosphorIconEntry>[
          for (final Object? e in json['icons']! as List<Object?>)
            PhosphorIconEntry.fromJson(e! as Map<String, Object?>),
        ],
        webTag: json['webTag']! as String,
      );

  /// O commit de `phosphor-icons/core` que gerou este arquivo.
  final String coreCommit;

  /// Os ícones, em ordem de nome.
  final List<PhosphorIconEntry> icons;

  /// A tag de `phosphor-icons/web` que gerou este arquivo.
  final String webTag;

  /// O conteúdo exato que [kCatalogPath] deve ter, com a quebra final.
  String serialize() =>
      '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{
        'coreCommit': coreCommit,
        'icons': <Map<String, Object?>>[for (final PhosphorIconEntry i in icons) i.toJson()],
        'webTag': webTag,
      })}\n';
}

/// Lê o catálogo vendorizado a partir de [root] (a raiz do pacote).
///
/// Falha com a instrução de regenerar quando o arquivo não existe: quem clonou
/// o repositório precisa saber qual comando rodar, e não que um `null` viajou.
PhosphorCatalog readVendoredCatalog({String root = '.'}) {
  final File file = File('$root/$kCatalogPath');
  if (!file.existsSync()) {
    throw StateError('$kCatalogPath não existe. Rode `$kVendorCommand`.');
  }
  return PhosphorCatalog.fromJson(
    jsonDecode(file.readAsStringSync()) as Map<String, Object?>,
  );
}
