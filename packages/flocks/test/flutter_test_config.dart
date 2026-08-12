import 'dart:async';
import 'dart:io';

import 'package:flocks/flocks.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Prepara o ambiente de teste antes de cada suíte: carrega as fontes reais
/// (para os goldens saírem com a tipografia certa) e instala uma costura de
/// ícone determinística (para goldens de componentes com ícone).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  _installIconStub();
  await _loadFonts();
  return testMain();
}

/// Substitui o carregamento de ícones (CDN + `flutter_cache_manager`) por um
/// glifo síncrono. Sem isso, `AppIcon` tenta `path_provider`/`sqflite`/rede — que
/// estouram `MissingPluginException` no sandbox de `flutter_test` — e os ícones
/// saem invisíveis (ou não-determinísticos) nos goldens. O glifo é um quadrado
/// arredondado tingido pela cor pedida (ou um neutro quando o ícone herdaria a
/// própria cor): o bastante para provar presença, tamanho e cor sem tocar a rede.
void _installIconStub() {
  AppIcon.debugIconBuilder =
      (BuildContext context, String icon, Color? color, double size) {
        return SizedBox(
          width: size,
          height: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color ?? const Color(0xFF9E9E9E),
              borderRadius: BorderRadius.all(Radius.circular(size * 0.22)),
            ),
          ),
        );
      };
}

const String _fontsRoot = 'assets/fonts';

Future<void> _loadFonts() async {
  // Tem de espelhar a seção `fonts:` do `pubspec.yaml`. Um arquivo ausente é
  // pulado em silêncio logo abaixo (`existsSync`), então entrada obsoleta aqui
  // não dá erro — só renderiza fallback e estraga o golden sem dizer por quê.
  final Map<String, List<String>> families = <String, List<String>>{
    'packages/flocks/Poppins': <String>[
      '$_fontsRoot/Poppins/Poppins-Regular.ttf',
      '$_fontsRoot/Poppins/Poppins-Medium.ttf',
      '$_fontsRoot/Poppins/Poppins-SemiBold.ttf',
    ],
    'packages/flocks/SpaceGrotesk': <String>[
      '$_fontsRoot/SpaceGrotesk/SpaceGrotesk-Regular.ttf',
      '$_fontsRoot/SpaceGrotesk/SpaceGrotesk-Medium.ttf',
    ],
    // A mono de `AppContentStyle.code`. Antes de ela ser empacotada, este
    // arquivo registrava a Poppins sob o nome `SF Mono` para o bloco de código
    // não sair como tofu — os goldens de código mostravam uma proporcional.
    'packages/flocks/IBMPlexMono': <String>[
      '$_fontsRoot/IBMPlexMono/IBMPlexMono-Regular.ttf',
      '$_fontsRoot/IBMPlexMono/IBMPlexMono-SemiBold.ttf',
    ],
  };

  for (final MapEntry<String, List<String>> entry in families.entries) {
    final FontLoader loader = FontLoader(entry.key);
    for (final String path in entry.value) {
      final File file = File(path);
      if (file.existsSync()) {
        loader.addFont(
          Future<ByteData>.value(file.readAsBytesSync().buffer.asByteData()),
        );
      }
    }
    await loader.load();
  }
}
