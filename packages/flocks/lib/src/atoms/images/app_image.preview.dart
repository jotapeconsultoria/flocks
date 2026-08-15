import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_image.dart';

// Previews nativos (Regra 5). No previewer da IDE a imagem de rede carrega; sem
// rede (ou no golden) cai no fallback `surfaceContainer` — os dois casos
// respeitam o raio do tema.

// PNG 8×8 opaco (74 bytes) — a mesma amostra canônica do golden e do
// widgetbook (duplicada porque lib/ não importa test/ e vice-versa).
const String _kSamplePngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAEUlEQVR42mNgYGD4TwCPBAUAgkg/wZV0VGcAAAAASUVORK5CYII=';

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const AppImage.network(
    'https://picsum.photos/240/160',
    width: 240,
    height: 160,
    semanticLabel: 'Exemplo de imagem',
  ),
);

Widget _memorySample(AppThemeData data) => AppTheme(
  data: data,
  child: AppImage.memory(
    AppImage.decodeBase64(_kSamplePngBase64)!,
    width: 160,
    height: 120,
    semanticLabel: 'Bytes decodificados',
  ),
);

@Preview(name: 'AppImage • claro')
Widget appImageLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppImage • escuro')
Widget appImageDarkPreview() => _sample(AppThemeData.dark);

@Preview(name: 'AppImage.memory • claro')
Widget appImageMemoryLightPreview() => _memorySample(AppThemeData.light);

@Preview(name: 'AppImage.memory • escuro')
Widget appImageMemoryDarkPreview() => _memorySample(AppThemeData.dark);
