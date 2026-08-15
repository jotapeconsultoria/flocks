import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppImage]. Registrado em `flocksCatalog`.
const AppComponentMeta appImageMeta = AppComponentMeta(
  id: 'app_image',
  name: 'AppImage',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Raster image (network/asset/memory) with standardized loading and fallback.',
    pt: 'Imagem raster (rede/asset/memória) com loading e fallback padronizados.',
  ),
  description: LocalizedText(
    en: 'Complements AppIllustration (SVG) and AppAvatar (circular). Clips to the theme radius, cross-fades from the placeholder to the decoded image and falls back to a theme-aware box on error. The .memory variant paints bytes already in memory (an API payload, a decoded base64 QR code) with gapless playback.',
    pt:
        'Complementa AppIllustration (SVG) e AppAvatar (circular). Recorta ao '
        'radius do tema, faz cross-fade do placeholder para a imagem decodificada '
        'e cai num fallback theme-aware em erro. A variante .memory pinta bytes '
        'já em memória (payload de API, um QR em base64 decodificado) com '
        'gapless playback.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Raster photo/thumbnail/banner (camera event, preview, portrait).',
    ],
    pt: <String>[
      'Foto/thumbnail/banner raster (evento de câmera, preview, portrait).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Vector (SVG) → AppIcon/AppIllustration.',
      'Circular profile photo → AppAvatar.',
    ],
    pt: <String>[
      'Vetor (SVG) → AppIcon/AppIllustration.',
      'Foto de perfil circular → AppAvatar.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'src',
      type: 'String?',
      description: LocalizedText(
        en: 'Network URL or asset path. Null on the .memory variant.',
        pt: 'URL de rede ou caminho de asset. Nulo na variante .memory.',
      ),
    ),
    PropMeta(
      name: 'bytes',
      type: 'Uint8List?',
      description: LocalizedText(
        en: 'Already decoded image bytes (.memory). Use AppImage.decodeBase64 for a base64 payload.',
        pt: 'Bytes já decodificados da imagem (.memory). Use AppImage.decodeBase64 para payload base64.',
      ),
    ),
    PropMeta(name: 'fit', type: 'BoxFit', defaultValue: 'BoxFit.cover'),
    PropMeta(name: 'width', type: 'double?'),
    PropMeta(name: 'height', type: 'double?'),
    PropMeta(
      name: 'radius',
      type: 'BorderRadius?',
      description: LocalizedText(
        en: 'Default: the global radius (round mode), proportional to the box.',
        pt: 'Default: radius global (modo redondo), proporcional à caixa.',
      ),
    ),
    PropMeta(name: 'semanticLabel', type: 'String?'),
    PropMeta(
      name: 'fallback',
      type: 'Widget?',
      description: LocalizedText(
        en: 'Shown on error (default: a surfaceContainer box).',
        pt: 'Exibido em erro (default: caixa surfaceContainer).',
      ),
    ),
    PropMeta(
      name: 'loading',
      type: 'AppImageLoading',
      defaultValue: 'AppImageLoading.spinner',
      description: LocalizedText(
        en: 'Placeholder while the network image loads.',
        pt: 'Placeholder de carregamento de rede.',
      ),
      enumValues: <String>['spinner', 'skeleton'],
    ),
  ],
  variants: <String>['network', 'asset', 'memory'],
  states: <String>['loading', 'loaded', 'error'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Network thumbnail', pt: 'Thumbnail de rede'),
      code: 'AppImage.network(event.thumbnailUrl, width: 96, height: 64)',
    ),
    CodeExample(
      title: LocalizedText(en: 'PIX QR from base64', pt: 'QR do PIX em base64'),
      code:
          'final Uint8List? qr = AppImage.decodeBase64(res.pixQrBase64);\n'
          "if (qr != null) AppImage.memory(qr, width: 200, height: 200, semanticLabel: 'QR Code do PIX')",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Give it width/height (most uses have a fixed box).',
      'Pass semanticLabel when the image carries meaning.',
    ],
    pt: <String>[
      'Informe width/height (a maioria dos usos tem caixa fixa).',
      'Passe semanticLabel quando a imagem tiver significado.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for vectors (SVG) — that is AppIllustration.'],
    pt: <String>['Não use para vetor (SVG) — é AppIllustration.'],
  ),
  a11y: LocalizedText(
    en:
        'semanticLabel==null → decorative; otherwise Semantics(image:true, label). '
        'The .network variant falls back when the network fails. The .memory '
        'variant usually carries meaning (a QR code, a chart): label it, and pair '
        'a QR with its copyable code as text — a screen reader cannot read a QR.',
    pt:
        'semanticLabel==null → decorativa; senão Semantics(image:true, label). A '
        'variante .network cai no fallback quando a rede falha. A variante '
        '.memory quase sempre tem significado (QR, gráfico): rotule-a, e '
        'acompanhe o QR do código copiável em texto — leitor de tela não lê QR.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_illustration', 'app_avatar', 'app_icon'],
);
