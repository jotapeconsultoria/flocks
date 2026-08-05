import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppCard]. Registrado em `flocksCatalog`.
const AppComponentMeta appCardMeta = AppComponentMeta(
  id: 'app_card',
  name: 'AppCard',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.5.0',
  summary: LocalizedText(
    en: 'Structured card (header/child/footer) on the AppStyle axis.',
    pt: 'Card estruturado (header/child/footer) no eixo AppStyle.',
  ),
  description: LocalizedText(
    en: 'A surfaceContainer surface that takes part in the AppStyle axis: filled (flat), outlined (outline border) or elevated (shadow, theme-aware). Like the other containers in the design system, the default follows the global styleTheme; the shape follows the global radius. It structures content through optional slots: header (leading/title/trailing), child and footer, with optional dividers (showDividers). accentColor emphasizes the outlined border. It does not intercept the pointer (that is the caller\'s responsibility over platform views).',
    pt:
        'Superfície surfaceContainer que participa do eixo AppStyle: filled '
        '(chapado), outlined (borda outline) ou elevated (sombra, theme-aware). '
        'Como os demais containers do DS, o default segue o global styleTheme; a '
        'forma segue o radius global. Estrutura o conteúdo via slots opcionais: '
        'header (leading/title/trailing), child e footer, com divisórias '
        'opcionais (showDividers). accentColor destaca a borda do outlined. Não '
        'intercepta ponteiro (responsabilidade do chamador sobre platform views).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A structured content panel (title, body, actions).',
      'A generic popover or floating panel over the UI (pin style: elevated).',
    ],
    pt: <String>[
      'Painel de conteúdo estruturado (título, corpo, ações).',
      'Popover/painel flutuante genérico sobre a UI (fixe style: elevated).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'An alert with a title and a semantic icon → AppAlert.',
      'A full-page modal → AppDialog (organism).',
    ],
    pt: <String>[
      'Alerta com título/ícone semântico → AppAlert.',
      'Modal de página inteira → AppDialog (organism).',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'child',
      type: 'Widget?',
      description: LocalizedText(
        en: 'Main content (optional).',
        pt: 'Conteúdo principal (opcional).',
      ),
    ),
    PropMeta(
      name: 'headerTitle',
      type: 'String?',
      description: LocalizedText(
        en: 'Header title (titleMedium/onSurface, 1 line).',
        pt: 'Título do header (titleMedium/onSurface, 1 linha).',
      ),
    ),
    PropMeta(name: 'headerLeading', type: 'Widget?'),
    PropMeta(name: 'headerTrailing', type: 'Widget?'),
    PropMeta(name: 'footer', type: 'Widget?'),
    PropMeta(
      name: 'showDividers',
      type: 'bool',
      defaultValue: 'false',
      description: LocalizedText(
        en: 'Divider between the sections present.',
        pt: 'Divisória entre as seções presentes.',
      ),
    ),
    PropMeta(
      name: 'accentColor',
      type: 'Color?',
      description: LocalizedText(
        en: 'Border color (defaults to the outline token).',
        pt: 'Cor da borda (default = token outline).',
      ),
    ),
    PropMeta(
      name: 'padding',
      type: 'EdgeInsetsGeometry?',
      description: LocalizedText(
        en: 'Padding per section (defaults to all s16).',
        pt: 'Padding por seção (default all s16).',
      ),
    ),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      enumValues: <String>['filled', 'outlined', 'elevated'],
      description: LocalizedText(
        en: 'Container; null follows the global styleTheme.',
        pt: 'Container; null segue o global styleTheme.',
      ),
    ),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
    PropMeta(name: 'radius', type: 'BorderRadius?'),
  ],
  states: <String>['filled', 'outlined', 'elevated'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Card with a header', pt: 'Card com header'),
      code: "AppCard(headerTitle: 'Localização', child: mapPreview)",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use the slots (headerTitle/leading/trailing, footer) to structure it; turn showDividers on to separate sections.',
      'Pin style: elevated on floating panels (menu/dropdown).',
    ],
    pt: <String>[
      'Use os slots (headerTitle/leading/trailing, footer) para estruturar; '
          'ligue showDividers para separar seções.',
      'Fixe style: elevated em painéis flutuantes (menu/dropdown).',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not count on built-in pointer interception over maps.'],
    pt: <String>[
      'Não conte com interceptação de ponteiro embutida sobre mapas.',
    ],
  ),
  a11y: LocalizedText(
    en: 'A visual container; the semantics come from the child. The outline border is ≥ 3:1 against the surface; the content inherits onSurface over surfaceContainer (an AA pair).',
    pt:
        'Container visual; a semântica vem do child. Borda outline ≥ 3:1 sobre a '
        'superfície; conteúdo herda onSurface sobre surfaceContainer (par AA).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_alert', 'app_surface', 'app_expansion_tile'],
);
