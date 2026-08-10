// Lê a tabela `cmap` de uma TTF: quais codepoints a fonte de fato desenha.
//
// Existe para que o gate de cobertura pergunte à FONTE, e não ao catálogo que
// gerou o código. Conferir o gerado contra o catálogo prova só que o gerador
// funciona; conferir contra a `cmap` prova a coisa que interessa — que o
// codepoint escrito no Dart tem glifo no arquivo que vai para o bundle.
//
// É o par que fecha a deriva entre os dois repositórios do upstream: os nomes
// e codepoints vêm de `phosphor-icons/core`, as fontes vêm de
// `phosphor-icons/web`, e nada garante que casem além de terem sido fixados
// juntos. Este leitor é quem verifica.
import 'dart:io';
import 'dart:typed_data';

/// Os codepoints que [file] sabe desenhar.
///
/// Só o suficiente do formato TrueType para responder isso: a tabela de
/// diretório, a `cmap`, e as subtabelas de formato 4 (BMP) e 12 (completa). Os
/// codepoints do Phosphor vivem na área de uso privado (U+E000–U+F8FF), então
/// na prática é sempre a de formato 4 — a 12 está aqui porque a fonte pode
/// mudar de formato numa atualização sem avisar ninguém, e falhar por "formato
/// não suportado" é melhor do que responder um conjunto vazio.
Set<int> readCmapCodepoints(File file) {
  final ByteData data = ByteData.sublistView(file.readAsBytesSync());

  final int numTables = data.getUint16(4);
  int? cmapOffset;
  for (int i = 0; i < numTables; i++) {
    final int record = 12 + i * 16;
    final String tag = String.fromCharCodes(<int>[
      for (int b = 0; b < 4; b++) data.getUint8(record + b),
    ]);
    if (tag == 'cmap') {
      cmapOffset = data.getUint32(record + 8);
      break;
    }
  }
  if (cmapOffset == null) {
    throw StateError('${file.path}: sem tabela cmap.');
  }

  // Entre as subtabelas, a de Unicode. `(3, 1)` é Windows/BMP e `(3, 10)` é
  // Windows/UCS-4; `(0, *)` é Unicode puro. A última que casa vence, o que
  // prefere a de cobertura maior quando existem as duas.
  final int subtableCount = data.getUint16(cmapOffset + 2);
  int? best;
  for (int i = 0; i < subtableCount; i++) {
    final int record = cmapOffset + 4 + i * 8;
    final int platform = data.getUint16(record);
    final int encoding = data.getUint16(record + 2);
    final bool unicode =
        platform == 0 || (platform == 3 && (encoding == 1 || encoding == 10));
    if (unicode) {
      best = cmapOffset + data.getUint32(record + 4);
    }
  }
  if (best == null) {
    throw StateError('${file.path}: cmap sem subtabela Unicode.');
  }

  return switch (data.getUint16(best)) {
    4 => _format4(data, best),
    12 => _format12(data, best),
    final int format => throw StateError(
      '${file.path}: subtabela cmap de formato $format não suportada. '
      'A fonte mudou de formato — estenda `readCmapCodepoints`, e não confie '
      'num conjunto vazio.',
    ),
  };
}

Set<int> _format4(ByteData data, int start) {
  final int segCount = data.getUint16(start + 6) ~/ 2;
  final int endCodes = start + 14;
  final int startCodes = endCodes + segCount * 2 + 2;
  final int idDeltas = startCodes + segCount * 2;
  final int idRangeOffsets = idDeltas + segCount * 2;

  final Set<int> codepoints = <int>{};
  for (int s = 0; s < segCount; s++) {
    final int end = data.getUint16(endCodes + s * 2);
    final int begin = data.getUint16(startCodes + s * 2);
    if (begin > end || begin == 0xFFFF) {
      continue;
    }
    final int delta = data.getInt16(idDeltas + s * 2);
    final int rangeOffset = data.getUint16(idRangeOffsets + s * 2);

    for (int c = begin; c <= end; c++) {
      final int glyph;
      if (rangeOffset == 0) {
        glyph = (c + delta) & 0xFFFF;
      } else {
        // O `idRangeOffset` é um deslocamento em bytes a partir da PRÓPRIA
        // posição dele — a indireção mais fácil de errar deste formato.
        final int index =
            idRangeOffsets + s * 2 + rangeOffset + (c - begin) * 2;
        if (index + 1 >= data.lengthInBytes) {
          continue;
        }
        final int raw = data.getUint16(index);
        glyph = raw == 0 ? 0 : (raw + delta) & 0xFFFF;
      }
      if (glyph != 0) {
        codepoints.add(c);
      }
    }
  }
  return codepoints;
}

Set<int> _format12(ByteData data, int start) {
  final int groups = data.getUint32(start + 12);
  final Set<int> codepoints = <int>{};
  for (int g = 0; g < groups; g++) {
    final int record = start + 16 + g * 12;
    final int begin = data.getUint32(record);
    final int end = data.getUint32(record + 4);
    for (int c = begin; c <= end; c++) {
      codepoints.add(c);
    }
  }
  return codepoints;
}
