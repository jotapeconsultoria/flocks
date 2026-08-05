import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppOverlayAlert]. Registrado em `flocksCatalog`.
const AppComponentMeta appOverlayAlertMeta = AppComponentMeta(
  id: 'app_overlay_alert',
  name: 'AppOverlayAlert',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Alert card with a semantic color through a ColorSwatch (AppAlert\'s sibling).',
    pt:
        'Card de alerta com cor semântica via ColorSwatch (irmão do '
        'AppAlert).',
  ),
  description: LocalizedText(
    en: 'The alert variant that takes the semantic color as a ColorSwatch (color) instead of an enum. surfaceContainer tinted by the color, container on the AppStyle axis (elevated by default), shape from the radius axis. Colors 100% from the theme; announced (liveRegion). Prefer AppAlert whenever the role enum will do.',
    pt:
        'Variante do alerta que recebe a cor semântica como um ColorSwatch '
        '(color) em vez de um enum. surfaceContainer tingido pela cor, container '
        'no eixo AppStyle (default elevated), forma pelo eixo de raio. Cores 100% '
        'do tema; anunciado (liveRegion). Prefira AppAlert quando puder usar o '
        'enum de papéis.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'An alert when you already have the semantic swatch (not the enum).',
    ],
    pt: <String>['Alerta quando você já tem o swatch semântico (não o enum).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A known semantic role (info/success/warning/danger) → AppAlert.',
    ],
    pt: <String>[
      'Papel semântico conhecido (info/success/warning/danger) → AppAlert.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'description', type: 'String', isRequired: true),
    PropMeta(
      name: 'color',
      type: 'ColorSwatch<int>?',
      description: LocalizedText(
        en: 'Semantic swatch; null uses the theme\'s info.',
        pt: 'Swatch semântico; null usa info do tema.',
      ),
    ),
    PropMeta(name: 'icon', type: 'String?'),
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
      title: LocalizedText(en: 'Error alert', pt: 'Alerta de erro'),
      code:
          "AppOverlayAlert(title: 'Falha', description: '...', "
          'color: theme.colorTheme.danger)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use the semantic color that matches the message.'],
    pt: <String>['Use a cor semântica que casa com a mensagem.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not stack several in the same corner.'],
    pt: <String>['Não empilhe vários no mesmo canto.'],
  ),
  a11y: LocalizedText(
    en: 'Wrapped in AppSemantics.liveRegion → announced when it appears. Title in onSurface and description in neutral s700 both pass AA; border and icon ≥ 3:1.',
    pt:
        'Embrulhado em AppSemantics.liveRegion → anunciado ao surgir. Título '
        'onSurface e descrição neutro s700 passam AA; borda/ícone ≥ 3:1.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_alert', 'app_snackbar'],
);
