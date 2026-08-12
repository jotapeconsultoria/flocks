import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

/// Qual das duas telas a demo mostra.
///
/// São duas porque são as duas coisas que um design system precisa provar:
/// leitura densa (uma tela cheia de dado que ainda se lê) e escrita (um
/// formulário com validação, erro, vazio e carregando). Uma vitrine de botões
/// não prova nenhuma das duas.
enum DemoScreen {
  /// Leitura densa: KPIs, gráficos, tabela e filtros.
  dashboard,

  /// Escrita: lista, formulário com validação e os quatro estados.
  crud,
}

/// As fontes que a demo oferece — o catálogo é FECHADO, e de propósito.
///
/// As duas vêm empacotadas no `flocks` sob OFL. Puxar uma família do Google
/// Fonts contradiria em rede exatamente o que a demo demonstra na tela: que o
/// Flocks funciona sem CDN, sem conta de terceiro e sem primeira requisição.
enum DemoFont {
  /// A Poppins — padrão do pacote em toda a escala.
  poppins(AppFontFamilies.poppins),

  /// A Space Grotesk — a display da marca do próprio design system.
  spaceGrotesk(AppFontFamilies.spaceGrotesk);

  const DemoFont(this.family);

  /// A família como o `flocks` a endereça.
  final String family;
}

/// Todo o estado compartilhável da demo, e nada além dele.
///
/// ## O contrato
///
/// `/demo/?seed=4F46E5&style=outlined&radius=redondo&font=Poppins&dark=1&screen=crud`
///
/// Duas invariantes o sustentam, e as duas têm teste:
///
/// 1. **Parâmetro inválido cai no padrão, em silêncio.** Nunca um erro de tela.
///    Um link compartilhado é copiado, truncado por aplicativo de mensagem e
///    editado à mão; a demo que responde a isso com exceção é uma demo que o
///    visitante nunca vê.
/// 2. **Nenhum parâmetro carrega o logo.** Não é uma regra de estilo que se
///    lembra de seguir: os bytes do logo moram em outro objeto
///    ([DemoLogo]), que esta classe não referencia e [toUri] não recebe.
///    Não há como vazar o que não se alcança.
///
/// É deliberadamente Dart puro — sem `dart:html`, sem `package:web`. A ponte
/// com a barra de endereço mora em `browser.dart`, o que deixa todo o parse
/// testável no `flutter test` da VM.
@immutable
final class DemoConfig {
  /// Cria uma configuração. Todo campo tem o padrão do contrato.
  const DemoConfig({
    this.seed = kDefaultSeed,
    this.style = AppStyle.filled,
    this.radius = AppRadiusMode.padrao,
    this.font = DemoFont.poppins,
    this.dark = false,
    this.screen = DemoScreen.dashboard,
  });

  /// Lê uma configuração de [uri], caindo no padrão a cada campo inválido.
  ///
  /// Cada campo é lido isoladamente: um `style` corrompido não contamina o
  /// `seed` que veio bom ao lado dele. É o que faz um link meio quebrado
  /// continuar valendo pela parte que sobreviveu.
  factory DemoConfig.fromUri(Uri uri) {
    final Map<String, String> q = uri.queryParameters;
    return DemoConfig(
      seed: _parseSeed(q['seed']),
      style: _parseEnum(q['style'], AppStyle.values, AppStyle.filled),
      radius: _parseEnum(
        q['radius'],
        AppRadiusMode.values,
        AppRadiusMode.padrao,
      ),
      font: _parseFont(q['font']),
      dark: q['dark'] == '1',
      screen: _parseEnum(q['screen'], DemoScreen.values, DemoScreen.dashboard),
    );
  }

  /// O índigo da marca do próprio design system — o padrão do contrato.
  static const Color kDefaultSeed = Color(0xFF4F46E5);

  /// A semente de cor da marca do visitante.
  final Color seed;

  /// O eixo de estilo de container.
  final AppStyle style;

  /// O eixo de forma dos cantos.
  final AppRadiusMode radius;

  /// A família tipográfica, do catálogo fechado.
  final DemoFont font;

  /// Se o tema escuro está ativo. Não é campo de marca — é escolha de quem vê.
  final bool dark;

  /// Qual tela está aberta.
  final DemoScreen screen;

  /// Cópia com os campos informados sobrescritos.
  DemoConfig copyWith({
    bool? dark,
    DemoFont? font,
    AppRadiusMode? radius,
    DemoScreen? screen,
    Color? seed,
    AppStyle? style,
  }) => DemoConfig(
    dark: dark ?? this.dark,
    font: font ?? this.font,
    radius: radius ?? this.radius,
    screen: screen ?? this.screen,
    seed: seed ?? this.seed,
    style: style ?? this.style,
  );

  /// A semente como hex de 6 dígitos, sem `#` — como ela viaja na URL.
  String get seedHex => seed
      .toARGB32()
      .toRadixString(16)
      .toUpperCase()
      .padLeft(8, '0')
      .substring(2);

  /// Os parâmetros desta configuração, prontos para a barra de endereço.
  ///
  /// Emite **todos** os campos, inclusive os que estão no padrão. Um link
  /// compartilhado precisa ser imune ao dia em que o padrão da demo mudar: o
  /// que o visitante viu tem de continuar sendo o que o destinatário vê.
  Map<String, String> toQueryParameters() => <String, String>{
    'seed': seedHex,
    'style': style.name,
    'radius': radius.name,
    'font': font.family,
    'dark': dark ? '1' : '0',
    'screen': screen.name,
  };

  /// Esta configuração como URL compartilhável, a partir de [base].
  ///
  /// Note o que a assinatura NÃO recebe: o logo. Não é esquecimento nem
  /// disciplina — é a fronteira desenhada de forma que o descuido não alcance.
  Uri toUri({Uri? base}) => (base ?? Uri.parse('/demo/')).replace(
    queryParameters: toQueryParameters(),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DemoConfig &&
          other.seed == seed &&
          other.style == style &&
          other.radius == radius &&
          other.font == font &&
          other.dark == dark &&
          other.screen == screen;

  @override
  int get hashCode => Object.hash(seed, style, radius, font, dark, screen);
}

/// Lê um hex de 6 ou 8 dígitos, com ou sem `#`. Qualquer outra coisa é o padrão.
Color _parseSeed(String? raw) {
  if (raw == null) return DemoConfig.kDefaultSeed;
  final String hex = raw.replaceFirst('#', '').trim();
  if (hex.length != 6 && hex.length != 8) return DemoConfig.kDefaultSeed;
  final int? value = int.tryParse(hex, radix: 16);
  if (value == null) return DemoConfig.kDefaultSeed;
  // 6 dígitos vêm sem alfa: opaco. 8 já trazem o próprio — mas a demo ignora
  // transparência de marca, então o alfa é forçado para opaco de qualquer jeito.
  return Color(0xFF000000 | (value & 0xFFFFFF));
}

/// Lê o `.name` de um enum. Vale para os três eixos, porque os nomes do
/// contrato de URL são, de propósito, os nomes que os enums do `flocks` já têm
/// — não há tabela de tradução para sair de sincronia.
T _parseEnum<T extends Enum>(String? raw, List<T> values, T fallback) {
  if (raw == null) return fallback;
  for (final T value in values) {
    if (value.name == raw) return value;
  }
  return fallback;
}

/// A fonte vem pelo nome da FAMÍLIA (`Poppins`), não pelo nome do enum, porque
/// é o nome da família que o visitante reconhece num link.
DemoFont _parseFont(String? raw) {
  if (raw == null) return DemoFont.poppins;
  for (final DemoFont font in DemoFont.values) {
    if (font.family == raw) return font;
  }
  return DemoFont.poppins;
}
