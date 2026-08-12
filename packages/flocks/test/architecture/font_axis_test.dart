import 'dart:io';

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// O eixo de fonte: o que o `pubspec.yaml` declara existe, é carregado nos
/// testes e viaja com a licença que a OFL exige.
///
/// Três armadilhas já documentadas em comentário, e nenhuma cobrada até aqui:
///
/// - **arquivo ausente**: `flutter_test_config.dart` pula com `existsSync` em
///   silêncio, então uma entrada obsoleta "só renderiza fallback e estraga o
///   golden sem dizer por quê";
/// - **espelho torto**: `_loadFonts()` repete a seção `fonts:` à mão. Família
///   declarada e não carregada = golden com a fonte errada, e nada acusa;
/// - **licença solta**: o `pubspec.yaml` manda pôr o texto ao lado do arquivo
///   ("a Neutrek saiu daqui por ser Personal Use Only"), e isso era só prosa.
void main() {
  final Map<String, List<String>> declaradas = _fontesDoPubspec();

  test('o pubspec declara as três famílias empacotadas', () {
    expect(declaradas.keys, <String>[
      AppFontFamilies.poppins,
      AppFontFamilies.spaceGrotesk,
      AppFontFamilies.ibmPlexMono,
    ]);
  });

  test('todo `asset:` declarado existe em disco', () {
    final List<String> ausentes = declaradas.values
        .expand((List<String> assets) => assets)
        .where((String path) => !File(path).existsSync())
        .toList();
    expect(
      ausentes,
      isEmpty,
      reason:
          'O carregador dos testes pula arquivo ausente em silêncio: o golden '
          'sai com a fonte errada e a suíte passa. Ausentes: $ausentes',
    );
  });

  test('o carregador dos testes espelha a seção `fonts:` do pubspec', () {
    final String config = File(
      'test/flutter_test_config.dart',
    ).readAsStringSync();
    for (final MapEntry<String, List<String>> familia in declaradas.entries) {
      expect(
        config,
        contains("'packages/flocks/${familia.key}'"),
        reason:
            'A família ${familia.key} está no pubspec e não é carregada em '
            '`flutter_test_config.dart` — os goldens dela saem em fallback.',
      );
      for (final String asset in familia.value) {
        expect(
          config,
          contains(asset.replaceFirst('assets/fonts', r'$_fontsRoot')),
          reason:
              'O arquivo $asset é declarado no pubspec e não é registrado no '
              'carregador dos testes.',
        );
      }
    }
  });

  test('o texto da licença viaja no diretório da família que ele cobre', () {
    // A OFL 1.1 exige o aviso em toda cópia redistribuída, e o pacote inteiro é
    // redistribuído a cada `dart pub publish`. Publicar a fonte sem ele seria
    // redistribuir sem atribuição — foi o defeito que a 0.1.0 já corrigiu uma
    // vez para a Poppins e a Space Grotesk.
    for (final String familia in declaradas.keys) {
      final File licenca = File('assets/fonts/$familia/OFL.txt');
      expect(
        licenca.existsSync(),
        isTrue,
        reason: 'Falta `assets/fonts/$familia/OFL.txt`.',
      );
      expect(
        licenca.readAsStringSync(),
        contains('SIL OPEN FONT LICENSE Version 1.1'),
        reason:
            'O `OFL.txt` de $familia não é o texto da licença — atribuição '
            'incompleta num pacote publicado.',
      );
    }
  });

  testWidgets('o código chega à mono empacotada, e não a uma do sistema', (
    WidgetTester tester,
  ) async {
    late AppContentStyle folha;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AppTheme(
          data: AppThemeData.light,
          child: Builder(
            builder: (BuildContext context) {
              folha = AppContentStyle.resolve(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    expect(folha.code.fontFamily, 'packages/flocks/IBMPlexMono');
    expect(
      folha.code.fontFamilyFallback,
      isNull,
      reason:
          'Uma pilha de famílias não registradas é o que fazia o CanvasKit '
          'baixar uma Noto de símbolos por causa de um acento (PR #20).',
    );
  });
}

/// Lê a seção `flutter: fonts:` do `pubspec.yaml` como família → assets.
///
/// À mão, e não com `package:yaml`: o pacote não tem essa dependência, e o
/// repositório já lê o pubspec por linha em `architecture_test.dart`.
Map<String, List<String>> _fontesDoPubspec() {
  final List<String> linhas = File('pubspec.yaml').readAsLinesSync();
  final Map<String, List<String>> saida = <String, List<String>>{};
  String? atual;
  bool dentro = false;

  for (final String linha in linhas) {
    final String limpa = linha.trimLeft();
    if (limpa.startsWith('#') || limpa.isEmpty) {
      continue;
    }
    if (linha == '  fonts:') {
      dentro = true;
      continue;
    }
    if (!dentro) {
      continue;
    }
    // Fim da seção: qualquer chave que não esteja indentada dentro dela.
    if (!linha.startsWith('    ')) {
      break;
    }
    if (limpa.startsWith('- family:')) {
      atual = limpa.substring('- family:'.length).trim();
      saida[atual] = <String>[];
    } else if (limpa.startsWith('- asset:') && atual != null) {
      saida[atual]!.add(limpa.substring('- asset:'.length).trim());
    }
  }
  return saida;
}
