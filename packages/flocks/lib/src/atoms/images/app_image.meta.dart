import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppImage]. Registrado em `flocksCatalog`.
const AppComponentMeta appImageMeta = AppComponentMeta(
  id: 'app_image',
  name: 'AppImage',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  since: 'flocks@0.4.0',
  summary: LocalizedText(
    en: 'Raster image (network/asset) with standardized loading and fallback.',
    pt: 'Imagem raster (rede/asset) com loading e fallback padronizados.',
  ),
  description: LocalizedText(
    en: 'Complements AppIllustration (SVG) and AppAvatar (circular). Clips to the theme radius, cross-fades from the placeholder to the network image and falls back to a theme-aware box on error.',
    pt:
        'Complementa AppIllustration (SVG) e AppAvatar (circular). Recorta ao '
        'radius do tema, faz cross-fade do placeholder para a imagem na rede e cai '
        'num fallback theme-aware em erro.',
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
      type: 'String',
      isRequired: true,
      description: LocalizedText(
        en: 'Network URL or asset path.',
        pt: 'URL de rede ou caminho de asset.',
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
  variants: <String>['network', 'asset'],
  states: <String>['loading', 'loaded', 'error'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Network thumbnail', pt: 'Thumbnail de rede'),
      code: 'AppImage.network(event.thumbnailUrl, width: 96, height: 64)',
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
    en: 'semanticLabel==null → decorative; otherwise Semantics(image:true, label). The .network variant falls back when the network fails.',
    pt:
        'semanticLabel==null → decorativa; senão Semantics(image:true, label). A '
        'variante .network cai no fallback quando a rede falha.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_illustration', 'app_avatar', 'app_icon'],
);
