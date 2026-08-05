import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppAlert]. Registrado em `flocksCatalog`.
const AppComponentMeta appAlertMeta = AppComponentMeta(
  id: 'app_alert',
  name: 'AppAlert',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.5.0',
  summary: LocalizedText(
    en: 'Alert card with a title, a description and a semantic icon.',
    pt: 'Card de alerta com título, descrição e ícone semântico.',
  ),
  description: LocalizedText(
    en: 'The alert CARD only (surfaceContainer tinted by the semantic color) with a title, a description (up to 3 lines) and an icon in the semantic color (info/success/warning/danger). The container follows the global AppStyle axis (filled = tone only; outlined = tone + border; elevated = tone + shadow). To show it somewhere on screen use the `showAppOverlay` helper (3×3 position without the center, maximum width, enter/exit animation). Colors 100% from the theme → AA contrast; announced (liveRegion).',
    pt:
        'Apenas o CARD de alerta (surfaceContainer tingido pela cor semântica) '
        'com título, descrição (até 3 linhas) e ícone na cor semântica (info/'
        'success/warning/danger). O container segue o eixo AppStyle global '
        '(filled = só o tom; outlined = tom + borda; elevated = tom + sombra). '
        'Para exibi-lo num ponto da tela use o helper `showAppOverlay` (posição '
        '3×3 sem o centro, largura máxima, animação de entrada/saída). Cores 100% '
        'do tema → contraste AA; anunciado (liveRegion).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Contextual feedback (notice, error, success) — inline on the page.',
      'Transient feedback (it disappears on its own) — through showAppOverlay with a duration.',
    ],
    pt: <String>[
      'Feedback contextual (aviso, erro, sucesso) — inline na página.',
      'Feedback transitório (some sozinho) — via showAppOverlay com duration.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A short status pill (no title or description) → AppBadge.',
      'A generic floating surface (free content) → AppCard.',
    ],
    pt: <String>[
      'Pílula curta de status (sem título/descrição) → AppBadge.',
      'Superfície flutuante genérica (conteúdo livre) → AppCard.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'description', type: 'String', isRequired: true),
    PropMeta(
      name: 'color',
      type: 'AppAlertColor',
      defaultValue: 'AppAlertColor.info',
      enumValues: <String>['info', 'success', 'warning', 'danger'],
    ),
    PropMeta(
      name: 'icon',
      type: 'String?',
      description: LocalizedText(
        en: 'Icon to the right of the title (defaults to the color\'s icon).',
        pt: 'Ícone à direita do título (default = ícone do color).',
      ),
    ),
  ],
  variants: <String>['info', 'success', 'warning', 'danger'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Error alert', pt: 'Alerta de erro'),
      code:
          "AppAlert(title: 'Sem conexão', description: '...', "
          'color: AppAlertColor.danger)',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Positioned on screen',
        pt: 'Posicionado na tela',
      ),
      code:
          'showAppOverlay(context: context, position: AppOverlayPosition.topRight, '
          'animation: AppOverlayAnimation.slide, maxWidth: 360, '
          "child: AppAlert(title: 'Salvo', description: '...'))",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use the semantic color that matches the message (danger for an error, and so on).',
      'Keep the title short (1 line).',
    ],
    pt: <String>[
      'Use a cor semântica que casa com a mensagem (danger para erro etc.).',
      'Mantenha o título curto (1 linha).',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not stack several overlays in the same corner at once.'],
    pt: <String>['Não empilhe vários overlays no mesmo canto ao mesmo tempo.'],
  ),
  a11y: LocalizedText(
    en: 'Wrapped in AppSemantics.liveRegion → announced when it appears. Title in onSurface and description in neutral s700 over the tinted background both pass AA; the border (when present, in the outlined style) and the icon (semantic color) are ≥ 3:1 against the surface.',
    pt:
        'Embrulhado em AppSemantics.liveRegion → anunciado ao surgir. Título '
        'onSurface e descrição neutro s700 sobre o fundo tingido passam AA; borda '
        '(quando presente, no estilo outlined) e ícone (cor semântica) ≥ 3:1 '
        'sobre a superfície.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_badge', 'app_card', 'app_tooltip'],
);
