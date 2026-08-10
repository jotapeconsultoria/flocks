import 'package:flutter/widgets.dart';

import '../theme/app_themes.dart';
import '../tokens/app_font_families.dart';
import '../tokens/swatch_generator.dart';
import 'app_brand_config.dart';
import 'app_brand_typography.dart';

/// Escreve uma [AppBrandConfig] como código Dart colável.
///
/// ## Por que existe
///
/// Uma demo de white-label que só mostra a marca do visitante na tela é vitrine:
/// ele vê e vai embora. Com isto ela vira onboarding — ele leva o arquivo que
/// reproduz exatamente o que viu, e a distância entre "gostei" e "está no meu
/// app" passa a ser um Ctrl+V.
///
/// ## Por que uma extension, e não um método
///
/// [AppBrandConfig] documenta no próprio dartdoc o que ela deliberadamente NÃO
/// guarda, e gerar código Dart não é responsabilidade de uma classe de
/// configuração. Como extension, a chamada continua parecendo um método
/// (descobrível no autocomplete) sem que a classe engorde.
///
/// E não é um `Codec`: o nome vem de `dart:convert` e promete um `decode`
/// simétrico que nunca vai existir aqui — o decode desta serialização é o
/// compilador Dart.
extension AppBrandConfigSnippet on AppBrandConfig {
  /// A configuração como um arquivo Dart que compila colado num app que já
  /// dependa do `flocks`.
  ///
  /// Emite **só o que difere do padrão**: um eixo em `standard` não aparece, e
  /// um papel de cor ausente também não. É o que mantém a saída legível — quem
  /// lê é humano, e um dump dos 11 stops de cada papel não se revisa.
  ///
  /// Cada swatch sai pela função que o reconstrói ([swatchFromSeed],
  /// [neutralSwatchFromSeed], [flippedSwatch]) sempre que a semente o
  /// reconstrói de fato — o gerador CONFERE isso antes de escolher a forma
  /// curta. Um swatch escrito à mão (as marcas cliente do pacote) não tem
  /// semente que o descreva, então sai como literal de 11 stops: feio, e o
  /// único jeito de a saída continuar fiel ao que entrou.
  ///
  /// [clientSlug] sobrescreve o slug na saída — a demo usa isso para nomear a
  /// marca do visitante sem tocar na configuração que está na tela. [dark]
  /// decide só o comentário final, porque brilho não é campo de marca: a mesma
  /// configuração serve aos dois temas.
  String toDartSnippet({String? clientSlug, bool dark = false}) {
    final String slug = clientSlug ?? this.clientSlug;
    final List<String> args = <String>[];

    // Vira `false` assim que um swatch precisa de uma chamada de função, que
    // não é `const`. Com todos literais a declaração inteira pode ser `const`,
    // e emiti-la como `final` acionaria `prefer_const_declarations` no projeto
    // de quem colou.
    bool allConst = true;

    String swatchCode(String field, ColorSwatch<int> swatch) {
      final _SwatchForm form = _describeSwatch(swatch);
      // O literal já é `const`; só a forma por semente precisa de runtime.
      if (form.head == null) return '$field: ${form.literal!}';
      allConst = false;
      return _call(field, form.head!, form.args);
    }

    void addSwatch(String field, ColorSwatch<int>? swatch) {
      if (swatch == null) return;
      args.add(swatchCode(field, swatch));
    }

    args.add("clientSlug: '${_escapeSingleQuoted(slug)}'");
    args.add(swatchCode('primaryColor', primaryColor));
    addSwatch('onPrimaryColor', onPrimaryColor);
    addSwatch('secondaryColor', secondaryColor);
    addSwatch('onSecondaryColor', onSecondaryColor);
    addSwatch('tertiaryColor', tertiaryColor);
    addSwatch('onTertiaryColor', onTertiaryColor);
    addSwatch('neutralLightColor', neutralLightColor);
    addSwatch('neutralDarkColor', neutralDarkColor);
    addSwatch('successColor', successColor);
    addSwatch('warningColor', warningColor);
    addSwatch('dangerColor', dangerColor);
    addSwatch('infoColor', infoColor);

    if (radiusTheme != AppRadiusTheme.standard) {
      args.add(
        'radiusTheme: const AppRadiusTheme(mode: '
        'AppRadiusMode.${radiusTheme.mode.name})',
      );
    }
    if (animationTheme != AppAnimationTheme.standard) {
      args.add(
        'animationTheme: const AppAnimationTheme('
        'enabled: ${animationTheme.enabled})',
      );
    }
    if (styleTheme != AppStyleTheme.standard) {
      args.add(
        'styleTheme: const AppStyleTheme(style: '
        'AppStyle.${styleTheme.style.name})',
      );
    }
    if (glassTheme != AppGlassTheme.standard) {
      args.add(
        'glassTheme: const AppGlassTheme(enabled: ${glassTheme.enabled})',
      );
    }
    if (typography != AppBrandTypography.standard) {
      args.add(
        _call(
          'typography',
          'const AppBrandTypography',
          _typographyFields(typography),
        ),
      );
    }

    final StringBuffer out = StringBuffer()
      ..writeln('// Marca gerada em flocks.live/demo.')
      ..writeln('//')
      ..writeln(
        '// Cole num app que já dependa do `flocks`. Uma semente por papel de '
        'cor,',
      )
      ..writeln('// e só os eixos que saem do padrão do design system.')
      ..writeln()
      ..writeln("import 'package:flocks/flocks.dart';")
      ..writeln("import 'package:flutter/widgets.dart';")
      ..writeln()
      ..writeln(
        '${allConst ? 'const' : 'final'} AppBrandConfig '
        '${_variableName(slug)} = AppBrandConfig(',
      );
    for (final String arg in args) {
      out.writeln('  $arg,');
    }
    out
      ..writeln(');')
      ..writeln()
      ..writeln(
        '// O tema: AppThemeData.forBrand(${_variableName(slug)}, '
        'dark: $dark).',
      );
    return out.toString();
  }
}

/// Como escrever um swatch: uma chamada ([head] + [args]) ou um [literal].
///
/// São excludentes — [head] nulo significa literal, que é a forma sem semente
/// que o descreva. A chamada vem partida em cabeça e argumentos, e não pronta,
/// porque é o emissor que decide se ela cabe em uma linha (ver [_call]).
typedef _SwatchForm = ({String? head, List<String> args, String? literal});

/// Escolhe como escrever [swatch]: pela semente que o reconstrói, ou literal.
///
/// A ordem das tentativas importa. A rampa cromática e a neutra saem da mesma
/// semente com escadas de tom diferentes, e o espelhamento preserva o `value` —
/// então um swatch pode casar com mais de uma forma só por coincidência de
/// semente. Tentar da mais comum para a mais rara mantém a saída previsível.
_SwatchForm _describeSwatch(ColorSwatch<int> swatch) {
  // O `value` de um swatch gerado É a semente (ver `swatchFromSeed`): é isso
  // que torna a ida e a volta possíveis sem guardar a semente à parte.
  final Color seed = Color(swatch.toARGB32());
  final String hex = 'const Color(${_hex(seed)})';

  _SwatchForm call(String head, String arg) =>
      (head: head, args: <String>[arg], literal: null);

  if (swatchFromSeed(seed) == swatch) return call('swatchFromSeed', hex);
  if (neutralSwatchFromSeed(seed) == swatch) {
    return call('neutralSwatchFromSeed', hex);
  }
  if (flippedSwatch(neutralSwatchFromSeed(seed)) == swatch) {
    return call('flippedSwatch', 'neutralSwatchFromSeed($hex)');
  }
  if (flippedSwatch(swatchFromSeed(seed)) == swatch) {
    return call('flippedSwatch', 'swatchFromSeed($hex)');
  }
  return (head: null, args: const <String>[], literal: _literalSwatch(swatch));
}

/// Escreve `campo: Chamada(args)` numa linha, ou partido se não couber.
///
/// O snippet vive versionado neste repo (`test/support/`), então ele passa pelo
/// mesmo `dart format --set-exit-if-changed` que todo o resto — e um gerador que
/// emitisse linhas de 84 colunas colocaria o gate de formatação em rota de
/// colisão com o gate de frescor, que exige o arquivo byte a byte igual à saída.
/// Emitir já quebrado no ponto em que o formatador quebraria evita a briga.
String _call(String field, String head, List<String> args) {
  final String oneLine = '$field: $head(${args.join(', ')})';
  // +2 da indentação do argumento, +1 da vírgula que o emissor acrescenta.
  if (oneLine.length + 3 <= 80) return oneLine;
  final StringBuffer out = StringBuffer('$field: $head(\n');
  for (final String arg in args) {
    out.writeln('    $arg,');
  }
  out.write('  )');
  return out.toString();
}

/// O swatch stop a stop. Só para quem não tem semente que o descreva.
String _literalSwatch(ColorSwatch<int> swatch) {
  final StringBuffer out = StringBuffer()
    ..writeln(
      'ColorSwatch<int>(${_hex(Color(swatch.toARGB32()))}, <int, Color>{',
    );
  for (final int stop in kSwatchStops) {
    final Color? color = swatch[stop];
    if (color == null) continue;
    out.writeln('    $stop: Color(${_hex(color)}),');
  }
  out.write('  })');
  return out.toString();
}

List<String> _typographyFields(AppBrandTypography typography) {
  const AppBrandTypography standard = AppBrandTypography.standard;
  final List<String> fields = <String>[];
  if (typography.bodyFamily != null) {
    fields.add('bodyFamily: ${_familyCode(typography.bodyFamily!)}');
  }
  if (typography.bodyFontPackage != standard.bodyFontPackage) {
    fields.add(
      'bodyFontPackage: ${_nullableString(typography.bodyFontPackage)}',
    );
  }
  if (typography.displayFamily != null) {
    fields.add('displayFamily: ${_familyCode(typography.displayFamily!)}');
  }
  if (typography.displayFontPackage != standard.displayFontPackage) {
    fields.add(
      'displayFontPackage: ${_nullableString(typography.displayFontPackage)}',
    );
  }
  return fields;
}

/// As duas famílias que vêm no pacote saem pelo token; uma fonte do app sai
/// como string, que é como ela é declarada no `pubspec.yaml` de quem a usa.
String _familyCode(String family) => switch (family) {
  AppFontFamilies.poppins => 'AppFontFamilies.poppins',
  AppFontFamilies.spaceGrotesk => 'AppFontFamilies.spaceGrotesk',
  _ => "'${_escapeSingleQuoted(family)}'",
};

String _nullableString(String? value) =>
    value == null ? 'null' : "'${_escapeSingleQuoted(value)}'";

String _hex(Color color) =>
    '0x${color.toARGB32().toRadixString(16).toUpperCase().padLeft(8, '0')}';

String _escapeSingleQuoted(String value) => value
    .replaceAll(r'\', r'\\')
    .replaceAll("'", r"\'")
    .replaceAll(r'$', r'\$')
    .replaceAll('\n', r'\n');

/// Acentos latinos para o ASCII correspondente, em pares fonte→destino.
///
/// Um identificador Dart não aceita acento, e o público desta serialização
/// escreve em português: `Açaí` precisa virar `acai`, não `aA` — que é no que
/// dá tratar o acento como separador de palavra.
const Map<String, String> _deaccentPairs = <String, String>{
  'àáâãäåÀÁÂÃÄÅ': 'a',
  'çÇ': 'c',
  'èéêëÈÉÊË': 'e',
  'ìíîïÌÍÎÏ': 'i',
  'ñÑ': 'n',
  'òóôõöøÒÓÔÕÖØ': 'o',
  'ùúûüÙÚÛÜ': 'u',
  'ýÿÝ': 'y',
};

String _deaccent(String value) {
  String out = value;
  for (final MapEntry<String, String> entry in _deaccentPairs.entries) {
    out = out.replaceAll(RegExp('[${entry.key}]'), entry.value);
  }
  return out;
}

/// O slug como identificador Dart em lowerCamelCase, sufixado por `Brand`.
///
/// O slug é texto livre — nome de empresa, com acento, espaço e pontuação — e
/// vira nome de variável no arquivo que o visitante cola. Um slug que não
/// sobrevive à limpeza (vazio, só símbolos, começando por dígito) cai em
/// `myBrand`: um snippet que não compila é pior que um snippet com nome
/// genérico.
String _variableName(String slug) {
  final List<String> words = _deaccent(slug)
      .split(RegExp('[^A-Za-z0-9]+'))
      .where((String word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty || words.first.startsWith(RegExp('[0-9]'))) {
    return 'myBrand';
  }
  final StringBuffer name = StringBuffer(words.first.toLowerCase());
  for (final String word in words.skip(1)) {
    name
      ..write(word[0].toUpperCase())
      ..write(word.substring(1).toLowerCase());
  }
  name.write('Brand');
  return name.toString();
}
