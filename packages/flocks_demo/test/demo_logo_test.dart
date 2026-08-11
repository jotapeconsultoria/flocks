// O sniff de formato do logo, que é por onde o arquivo do visitante entra.
//
// `DemoLogo.sniffFormat` é a única função pura da demo no caminho crítico, e a
// única que decide algo a partir de bytes que vêm de fora. Antes deste arquivo
// ela não tinha teste próprio: `no_network_test.dart` injeta um PNG de 1×1 e
// portanto só exercitava o primeiro `if` de cinco, e o `architecture_test.dart`
// olha o arquivo como texto, não como comportamento.
//
// O que se testa aqui não é "reconhece PNG" — é o CONTRATO documentado no
// dartdoc da função, que tem três partes e nenhuma delas é óbvia:
//
// 1. decide pela ASSINATURA e nunca pela extensão, porque o nome do arquivo é
//    dado do usuário e nem chega a entrar no estado da demo;
// 2. devolve `null` para o que não sabe desenhar, e não lança — o chamador
//    transforma isso numa frase na tela, e uma exceção aqui viraria tela branca;
// 3. para SVG procura a raiz nos primeiros 512 bytes, porque SVG é texto e não
//    tem número mágico.
//
// Os casos de borda abaixo são o contrato, não curiosidades: cada um deles é uma
// decisão que alguém poderia "consertar" sem perceber que estava trocando o
// comportamento.
import 'dart:typed_data';

import 'package:flocks_demo/src/state/demo_logo.dart';
import 'package:flutter_test/flutter_test.dart';

/// Bytes a partir de uma lista de inteiros, do jeito que o `FileReader` entrega.
Uint8List bytes(List<int> values) => Uint8List.fromList(values);

/// Bytes a partir de texto ASCII, para os casos de SVG.
Uint8List ascii(String text) => Uint8List.fromList(text.codeUnits);

void main() {
  group('os formatos raster, pela assinatura', () {
    test('PNG', () {
      // 89 50 4E 47 — os quatro primeiros bytes do cabeçalho PNG.
      expect(
        DemoLogo.sniffFormat(bytes(<int>[0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A])),
        DemoLogoFormat.raster,
      );
    });

    test('JPEG', () {
      // FF D8 FF — só três bytes são conferidos, então o quarto é livre.
      expect(
        DemoLogo.sniffFormat(bytes(<int>[0xFF, 0xD8, 0xFF, 0xE0])),
        DemoLogoFormat.raster,
      );
    });

    test('GIF, nas duas versões', () {
      // A assinatura conferida é "GIF8", que é o prefixo comum de GIF87a e
      // GIF89a. As duas passam de propósito: são o mesmo desenho para quem só
      // precisa escolher entre `Image.memory` e `SvgPicture.memory`.
      expect(DemoLogo.sniffFormat(ascii('GIF87a...')), DemoLogoFormat.raster);
      expect(DemoLogo.sniffFormat(ascii('GIF89a...')), DemoLogoFormat.raster);
    });

    test('WebP, que precisa de 12 bytes e não de 4', () {
      // "RIFF" nos bytes 0-3 e "WEBP" nos 8-11, com o tamanho no meio. É o
      // único formato da lista cuja assinatura não cabe nos 4 primeiros bytes.
      expect(
        DemoLogo.sniffFormat(ascii('RIFF\x00\x00\x00\x00WEBPVP8 ')),
        DemoLogoFormat.raster,
      );
    });

    test('um RIFF que não é WebP não passa por WebP', () {
      // RIFF é contêiner genérico — um WAV começa igual. Aceitar pelo "RIFF"
      // sozinho entregaria áudio ao `Image.memory`.
      expect(
        DemoLogo.sniffFormat(ascii('RIFF\x00\x00\x00\x00WAVEfmt ')),
        isNull,
      );
    });
  });

  group('SVG, que é texto e não tem número mágico', () {
    test('a raiz nua', () {
      expect(
        DemoLogo.sniffFormat(
          ascii('<svg xmlns="http://www.w3.org/2000/svg"/>'),
        ),
        DemoLogoFormat.vector,
      );
    });

    test('depois de uma declaração XML', () {
      // O caso que motiva procurar em vez de comparar o começo: um SVG salvo
      // por editor quase sempre abre com o prólogo XML, e a raiz vem depois.
      expect(
        DemoLogo.sniffFormat(
          ascii('<?xml version="1.0" encoding="UTF-8"?>\n<svg width="10"/>'),
        ),
        DemoLogoFormat.vector,
      );
    });

    test('depois de um DOCTYPE', () {
      expect(
        DemoLogo.sniffFormat(
          ascii(
            '<?xml version="1.0"?>\n'
            '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "svg11.dtd">\n'
            '<svg/>',
          ),
        ),
        DemoLogoFormat.vector,
      );
    });

    test('maiúsculo passa, porque a busca é case-insensitive', () {
      // Consequência de `toLowerCase()` na cabeça da busca. Está aqui como
      // contrato, e não como acidente: XML é case-sensitive e `<SVG` não é uma
      // raiz válida, mas rejeitar um arquivo que todo navegador desenha seria
      // rigor às custas do visitante.
      expect(
        DemoLogo.sniffFormat(ascii('<SVG viewBox="0 0 1 1"/>')),
        DemoLogoFormat.vector,
      );
    });

    test('a raiz depois do byte 512 NÃO passa', () {
      // A janela é de 512 bytes, e este é o preço dela. Um comentário de licença
      // gigante antes da raiz empurra o `<svg` para fora e o arquivo é recusado.
      // É o limite certo — ler o arquivo inteiro procurando uma substring é como
      // um upload de 40 MB viraria trabalho —, mas é um limite, e fica pinado
      // para que a troca seja deliberada se alguém mexer.
      final String prologoLongo = '<!-- ${'x' * 600} -->\n<svg/>';
      expect(DemoLogo.sniffFormat(ascii(prologoLongo)), isNull);
    });

    test('um `<svg` dentro de comentário passa, e é aceitável', () {
      // A busca é por substring, então isto é falso positivo por construção. Não
      // vale endurecer: o custo de errar aqui é o `SvgPicture` recusar o
      // conteúdo, e não uma requisição nem um vazamento. Pinado para documentar
      // que a escolha foi vista.
      expect(
        DemoLogo.sniffFormat(ascii('<!-- <svg> era aqui --><html/>')),
        DemoLogoFormat.vector,
      );
    });
  });

  group('o que a função recusa devolvendo null', () {
    test('arquivo mais curto que a menor assinatura', () {
      // O guarda de `length < 4` vem antes de tudo, então nem um prefixo válido
      // salva um arquivo truncado — e é por isso que este caso usa FF D8 FF, que
      // seria JPEG se houvesse um quarto byte.
      expect(DemoLogo.sniffFormat(bytes(<int>[0xFF, 0xD8, 0xFF])), isNull);
      expect(DemoLogo.sniffFormat(bytes(<int>[0x89])), isNull);
      expect(DemoLogo.sniffFormat(bytes(<int>[])), isNull);
    });

    test('um `<sv` truncado não passa por SVG', () {
      expect(DemoLogo.sniffFormat(ascii('<sv')), isNull);
    });

    test('lixo binário devolve null, e não lança', () {
      // O caminho do SVG faz `String.fromCharCodes` nos primeiros bytes. Isso é
      // seguro por construção — elemento de `Uint8List` é 0-255, sempre um code
      // unit válido —, mas é a linha em que uma exceção viraria tela branca no
      // navegador do visitante, então fica coberta.
      final Uint8List ruido = Uint8List.fromList(
        List<int>.generate(64, (int i) => (i * 37 + 11) % 256),
      );
      expect(DemoLogo.sniffFormat(ruido), isNull);
    });

    test('todos os 256 valores de byte, um a um, sem exceção', () {
      // Varredura barata que fecha a classe inteira: qualquer byte repetido 16
      // vezes ou é reconhecido ou é null, e nunca lança.
      for (int b = 0; b <= 255; b++) {
        expect(
          () =>
              DemoLogo.sniffFormat(Uint8List.fromList(List<int>.filled(16, b))),
          returnsNormally,
          reason: 'byte 0x${b.toRadixString(16)} lançou',
        );
      }
    });

    test('um PDF, que é o erro de upload mais provável', () {
      // "%PDF-1.7". Quem tem um logo tem quase sempre um PDF do logo ao lado.
      expect(DemoLogo.sniffFormat(ascii('%PDF-1.7\n%%EOF')), isNull);
    });
  });
}
