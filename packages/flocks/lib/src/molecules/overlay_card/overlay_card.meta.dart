import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppOverlayCard]. Registrado em `flocksCatalog`.
const AppComponentMeta appOverlayCardMeta = AppComponentMeta(
  id: 'app_overlay_card',
  name: 'AppOverlayCard',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Floating card that intercepts the pointer (for floating over maps).',
    pt:
        'Card flutuante que intercepta o ponteiro (para flutuar sobre '
        'mapas).',
  ),
  description: LocalizedText(
    en: 'Like AppCard, but it wraps the content in a PointerInterceptor — it stops clicks from leaking to a platform view underneath (e.g. a map on the web). A surfaceContainer surface on the AppStyle (elevated by default) and AppRadiusMode axes; colors 100% from the theme.',
    pt:
        'Como o AppCard, mas embrulha o conteúdo num PointerInterceptor — bloqueia '
        'cliques de vazarem para uma platform view embaixo (ex.: mapa no web). '
        'Superfície surfaceContainer nos eixos AppStyle (default elevated) e '
        'AppRadiusMode; cores 100% do tema.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A card or panel that floats over a map or a video (web) and must not leak clicks.',
    ],
    pt: <String>[
      'Card/painel que flutua sobre um mapa ou vídeo (web) e não pode vazar clique.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'An ordinary card, with no platform view underneath → AppCard.',
    ],
    pt: <String>['Card comum, sem platform view embaixo → AppCard.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(name: 'accentColor', type: 'Color?'),
    PropMeta(name: 'padding', type: 'EdgeInsetsGeometry?'),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      defaultValue: 'AppStyle.elevated',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
  ],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Panel over the map', pt: 'Painel sobre o mapa'),
      code: 'AppOverlayCard(child: filterPanel)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it over platform views (a map, a video) on the web.'],
    pt: <String>['Use sobre platform views (mapa/vídeo) no web.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it when there is nothing to intercept (AppCard).'],
    pt: <String>['Não use quando não há nada para interceptar (AppCard).'],
  ),
  a11y: LocalizedText(
    en: 'The theme\'s surface (surfaceContainer/outline) passes AA in light and dark. The interceptor does not alter the content\'s semantics.',
    pt:
        'Superfície do tema (surfaceContainer/outline) passa AA em claro/escuro. '
        'O interceptor não altera a semântica do conteúdo.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_card', 'app_overlay_alert'],
);
