import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_image.dart';

// Previews nativos (Regra 5). No previewer da IDE a imagem de rede carrega; sem
// rede (ou no golden) cai no fallback `surfaceContainer` — os dois casos
// respeitam o raio do tema.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const AppImage.network(
    'https://picsum.photos/240/160',
    width: 240,
    height: 160,
    semanticLabel: 'Exemplo de imagem',
  ),
);

@Preview(name: 'AppImage • claro')
Widget appImageLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppImage • escuro')
Widget appImageDarkPreview() => _sample(AppThemeData.dark);
