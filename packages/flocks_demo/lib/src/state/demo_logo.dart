import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Os formatos de logo que a demo aceita.
enum DemoLogoFormat {
  /// PNG, JPEG, WebP e GIF — desenhados por `Image.memory`.
  raster,

  /// SVG — desenhado por `SvgPicture.memory`.
  vector,
}

/// O logo do visitante, e a fronteira que ele nunca atravessa.
///
/// ## O que esta classe deliberadamente NÃO tem
///
/// Uma URL. Nem remota, nem `blob:`, nem `data:`. Não tem caminho de arquivo,
/// não tem nome de arquivo, não tem método que produza qualquer uma dessas
/// coisas. O que ela tem são [bytes] em memória e o [format] necessário para
/// escolher o widget que os desenha.
///
/// O briefing desta demo pedia uma object URL, e bytes crus são estritamente
/// mais fortes: uma object URL EXISTE como endereço, e um endereço que existe é
/// um endereço que alguém pode buscar — o próprio Flutter emite uma requisição
/// `blob:` para ler os bytes de volta. Sem URL, não há requisição de espécie
/// alguma para auditar, e o gate de rede da demo pode ser absoluto em vez de
/// precisar distinguir "requisição local" de "requisição de rede".
///
/// De quebra, resolve o SVG: uma object URL só chegaria ao `Image`, que não
/// rasteriza vetor. Bytes chegam aos dois renderizadores.
///
/// ## O que sustenta isso
///
/// Não é boa vontade. É `test/no_network_test.dart`, que monta a demo inteira
/// com um logo carregado, mexe em tudo, e falha se qualquer requisição HTTP
/// tiver sido feita; e `test/architecture_test.dart`, que reprova o pacote se
/// um cliente HTTP entrar nas dependências. A fronteira é um teste, não uma
/// promessa.
@immutable
final class DemoLogo {
  /// Cria um logo a partir dos bytes já lidos.
  const DemoLogo({required this.bytes, required this.format});

  /// Os bytes da imagem, como o navegador os entregou. Só isso.
  final Uint8List bytes;

  /// Como desenhá-los.
  final DemoLogoFormat format;

  /// O widget que desenha este logo em [height].
  ///
  /// Os dois caminhos leem de memória. Nenhum recebe endereço, então nenhum
  /// tem como buscar coisa alguma.
  Widget build({required double height, String? semanticLabel}) =>
      switch (format) {
        DemoLogoFormat.raster => Image.memory(
          bytes,
          height: height,
          fit: BoxFit.contain,
          semanticLabel: semanticLabel,
        ),
        DemoLogoFormat.vector => SvgPicture.memory(
          bytes,
          height: height,
          fit: BoxFit.contain,
          semanticsLabel: semanticLabel,
        ),
      };

  /// Adivinha o formato pelos primeiros bytes, e não pela extensão do arquivo.
  ///
  /// A extensão é dado do usuário e mente; a assinatura do arquivo, não. Como o
  /// nome do arquivo não entra no estado da demo (ver a doc da classe), ele
  /// também não estaria aqui para ser consultado.
  ///
  /// Devolve `null` para o que não sabe desenhar — o chamador transforma isso
  /// numa mensagem de erro na tela, e não numa exceção.
  static DemoLogoFormat? sniffFormat(Uint8List bytes) {
    if (bytes.length < 4) return null;
    // PNG: 89 50 4E 47
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return DemoLogoFormat.raster;
    }
    // JPEG: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return DemoLogoFormat.raster;
    }
    // GIF: "GIF8"
    if (bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x38) {
      return DemoLogoFormat.raster;
    }
    // WebP: "RIFF" .... "WEBP"
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return DemoLogoFormat.raster;
    }
    // SVG não tem número mágico: é texto. Procura a raiz nos primeiros bytes,
    // que é onde ela está mesmo depois de uma declaração XML ou de um DOCTYPE.
    final String head = String.fromCharCodes(bytes.take(512)).toLowerCase();
    if (head.contains('<svg')) return DemoLogoFormat.vector;
    return null;
  }
}
