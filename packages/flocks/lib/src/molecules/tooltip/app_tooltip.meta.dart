import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppTooltip]. Registrado em `flocksCatalog`.
const AppComponentMeta appTooltipMeta = AppComponentMeta(
  id: 'app_tooltip',
  name: 'AppTooltip',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.2.0',
  summary: LocalizedText(
    en: 'Tooltip (hint balloon) shown on hover, through the Overlay.',
    pt: 'Tooltip (balão de dica) exibido ao passar o mouse, via Overlay.',
  ),
  description: LocalizedText(
    en: 'No Material. Shows a balloon carrying [message] on hover over the [child]; it renders through the Overlay so a parent container cannot clip it.',
    pt:
        'Sem Material. Mostra um balão com [message] no hover sobre o [child]; '
        'renderiza via Overlay para não ser cortado por containers pai.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A short hint on icons or actions with no visible label (desktop/web).',
    ],
    pt: <String>[
      'Dica curta em ícones/ações sem rótulo visível (desktop/web).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Essential content (hover does not exist on touch).'],
    pt: <String>['Conteúdo essencial (hover não existe em toque).'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(name: 'message', type: 'String', isRequired: true),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(
      name: 'position',
      type: 'AppTooltipPosition',
      defaultValue: 'top',
      enumValues: <String>['top', 'bottom', 'left', 'right'],
    ),
    PropMeta(
      name: 'size',
      type: 'AppTooltipSize',
      defaultValue: 'medium',
      enumValues: <String>['small', 'medium', 'large'],
    ),
    PropMeta(name: 'maxWidth', type: 'double?'),
    PropMeta(name: 'textStyle', type: 'TextStyle?'),
  ],
  states: <String>['hidden', 'visible'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'On an icon', pt: 'Em um ícone'),
      code:
          'AppTooltip(message: "Mês anterior", child: AppIcon(AppIconToken.chevronLeft))',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use short text; for navigation, do not rely on the tooltip alone.',
    ],
    pt: <String>['Use texto curto; para navegação, não dependa só do tooltip.'],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not put essential information only in the tooltip (touch has no hover).',
    ],
    pt: <String>[
      'Não coloque informação essencial só no tooltip (toque não tem hover).',
    ],
  ),
  a11y: LocalizedText(
    en: 'Affects the pointer only (hover); the [child] must carry its own semantics (e.g. an AppIcon with a semanticLabel).',
    pt:
        'Afeta apenas ponteiro (hover); o [child] deve ter semântica própria '
        '(ex.: AppIcon com semanticLabel).',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_icon'],
);
