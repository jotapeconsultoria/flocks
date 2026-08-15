import 'dart:typed_data';

import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: child),
    ),
  ),
);

// PNG 8×8 opaco (74 bytes) — amostra canônica, duplicada do preview/widgetbook
// (lib/ e test/ não se importam).
const String _kSamplePngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAEUlEQVR42mNgYGD4TwCPBAUAgkg/wZV0VGcAAAAASUVORK5CYII=';

void main() {
  testWidgets('recorta ao radius do tema', (tester) async {
    await tester.pumpWidget(
      _host(const AppImage.network('x', width: 20, height: 20)),
    );
    final ClipRRect clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(
      clip.borderRadius,
      AppThemeData.light.radiusTheme.resolve(size: const Size(20, 20)),
    );
  });

  testWidgets('cai no fallback custom em erro de rede', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppImage.network(
          'https://invalid.invalid/x.png',
          width: 60,
          height: 60,
          fallback: SizedBox(
            key: ValueKey<String>('fb'),
            width: 60,
            height: 60,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('fb')), findsOneWidget);
  });

  testWidgets('semanticLabel expõe imagem rotulada', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppImage.network(
          'x',
          width: 10,
          height: 10,
          semanticLabel: 'Foto',
        ),
      ),
    );
    final s = tester.getSemantics(find.byType(AppImage));
    expect(s.label, 'Foto');
    expect(s.flagsCollection.isImage, isTrue);
  });

  testWidgets('sem semanticLabel → decorativo', (tester) async {
    await tester.pumpWidget(
      _host(const AppImage.network('x', width: 10, height: 10)),
    );
    expect(find.byType(ExcludeSemantics), findsWidgets);
  });

  testWidgets('está no catálogo como migrado', (tester) async {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_image' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });

  group('AppImage.memory', () {
    testWidgets('decodifica e pinta a imagem', (tester) async {
      // A decodificação real só completa dentro de runAsync — fora dele o
      // binding congela no placeholder e o teste passaria por engano.
      final Uint8List bytes = AppImage.decodeBase64(_kSamplePngBase64)!;
      await tester.runAsync(() async {
        await tester.pumpWidget(
          _host(AppImage.memory(bytes, width: 40, height: 40)),
        );
        final Element el = tester.element(find.byType(AppImage));
        await precacheImage(MemoryImage(bytes), el);
      });
      await tester.pumpAndSettle();

      final Image img = tester.widget<Image>(find.byType(Image));
      expect(img.image, isA<MemoryImage>());
      expect(img.gaplessPlayback, isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('mostra o placeholder antes do primeiro frame', (tester) async {
      final Uint8List bytes = AppImage.decodeBase64(_kSamplePngBase64)!;
      await tester.pumpWidget(
        _host(AppImage.memory(bytes, width: 40, height: 40)),
      );
      await tester.pump();
      expect(find.byKey(const ValueKey<String>('loading')), findsOneWidget);
    });

    testWidgets('bytes corrompidos caem no fallback', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          _host(
            AppImage.memory(
              Uint8List.fromList(const <int>[1, 2, 3]),
              width: 60,
              height: 60,
              fallback: const SizedBox(
                key: ValueKey<String>('fb'),
                width: 60,
                height: 60,
              ),
            ),
          ),
        );
        // Dá tempo do codec falhar de verdade (fora do FakeAsync).
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await tester.pump();
      expect(find.byKey(const ValueKey<String>('fb')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Uint8List(0) cai no fallback sem construir Image', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          AppImage.memory(
            Uint8List(0),
            width: 60,
            height: 60,
            fallback: const SizedBox(
              key: ValueKey<String>('fb'),
              width: 60,
              height: 60,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey<String>('fb')), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('recorta ao radius do tema', (tester) async {
      await tester.pumpWidget(
        _host(
          AppImage.memory(
            AppImage.decodeBase64(_kSamplePngBase64)!,
            width: 20,
            height: 20,
          ),
        ),
      );
      final ClipRRect clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(
        clip.borderRadius,
        AppThemeData.light.radiusTheme.resolve(size: const Size(20, 20)),
      );
    });

    testWidgets('sem semanticLabel é decorativa', (tester) async {
      await tester.pumpWidget(
        _host(
          AppImage.memory(
            AppImage.decodeBase64(_kSamplePngBase64)!,
            width: 10,
            height: 10,
          ),
        ),
      );
      expect(find.byType(ExcludeSemantics), findsWidgets);
    });

    testWidgets('com semanticLabel expõe imagem rotulada', (tester) async {
      await tester.pumpWidget(
        _host(
          AppImage.memory(
            AppImage.decodeBase64(_kSamplePngBase64)!,
            width: 10,
            height: 10,
            semanticLabel: 'QR Code do PIX',
          ),
        ),
      );
      final s = tester.getSemantics(find.byType(AppImage));
      expect(s.label, 'QR Code do PIX');
      expect(s.flagsCollection.isImage, isTrue);
    });
  });

  group('AppImage.decodeBase64', () {
    test('base64 puro decodifica', () {
      expect(AppImage.decodeBase64(_kSamplePngBase64), isNotNull);
    });

    test('a amostra canônica atravessa intacta', () {
      expect(AppImage.decodeBase64(_kSamplePngBase64)!.length, 74);
    });

    test('tolera espaços e quebras de linha', () {
      final String noisy =
          '  ${_kSamplePngBase64.substring(0, 20)}\n'
          '${_kSamplePngBase64.substring(20)} \t';
      expect(AppImage.decodeBase64(noisy), isNotNull);
      expect(AppImage.decodeBase64(noisy)!.length, 74);
    });

    test('tolera prefixo data-URI', () {
      expect(
        AppImage.decodeBase64('data:image/png;base64,$_kSamplePngBase64'),
        isNotNull,
      );
    });

    test('tolera padding ausente', () {
      final String unpadded = _kSamplePngBase64.replaceAll('=', '');
      expect(AppImage.decodeBase64(unpadded), isNotNull);
      expect(AppImage.decodeBase64(unpadded)!.length, 74);
    });

    test('devolve null para inválido, vazio, whitespace e null', () {
      expect(AppImage.decodeBase64('não é base64!!'), isNull);
      expect(AppImage.decodeBase64(''), isNull);
      expect(AppImage.decodeBase64('   \n '), isNull);
      expect(AppImage.decodeBase64(null), isNull);
    });
  });
}
