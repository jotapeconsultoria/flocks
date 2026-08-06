import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppIcon]. Registrado em `flocksCatalog`.
const AppComponentMeta appIconMeta = AppComponentMeta(
  id: 'app_icon',
  name: 'AppIcon',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Design system SVG icon, loaded from the CDN with caching.',
    pt: 'Ícone SVG do design system, carregado da CDN com cache.',
  ),
  description: LocalizedText(
    en: 'Renders an SVG icon (from AppIcons) off the network with a local cache; applies color through a ColorFilter and size through AppIconSize.',
    pt:
        'Renderiza um ícone SVG (de AppIcons) da rede com cache local; aplica cor '
        'via ColorFilter e tamanho por AppIconSize.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Action, status and navigation icons from AppIconToken.'],
    pt: <String>[
      'Ícones de ação, status e navegação a partir de AppIconToken.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Large artwork → use AppIllustration.'],
    pt: <String>['Ilustrações grandes → use AppIllustration.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'icon',
      type: 'String',
      isRequired: true,
      description: LocalizedText(
        en: 'Icon slug (AppIconToken.*).',
        pt: 'Slug do ícone (AppIconToken.*).',
      ),
    ),
    PropMeta(
      name: 'color',
      type: 'Color?',
      description: LocalizedText(
        en: 'ColorFilter applied; null keeps the SVG\'s own colors.',
        pt: 'ColorFilter aplicado; null mantém as cores do SVG.',
      ),
    ),
    PropMeta(
      name: 'size',
      type: 'AppIconSize',
      defaultValue: 'AppIconSize.m',
      enumValues: <String>['s', 'm', 'l', 'xl'],
    ),
    PropMeta(name: 'customSize', type: 'double?'),
    PropMeta(
      name: 'semanticLabel',
      type: 'String?',
      description: LocalizedText(
        en: 'null = decorative; otherwise becomes Semantics(image, label).',
        pt: 'null = decorativo; senão vira Semantics(image, label).',
      ),
    ),
  ],
  states: <String>['loading', 'loaded', 'error'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Plain', pt: 'Simples'),
      code: 'AppIcon(AppIconToken.check, size: AppIconSize.l)',
    ),
    CodeExample(
      title: LocalizedText(en: 'With label', pt: 'Com rótulo'),
      code: "AppIcon(AppIconToken.alert, semanticLabel: 'Alerta')",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Pass semanticLabel when the icon carries meaning of its own.',
    ],
    pt: <String>[
      'Passe semanticLabel quando o ícone tiver significado próprio.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not pin a color outside the theme for meaningful icons.'],
    pt: <String>['Não fixe cor fora do tema para ícones significativos.'],
  ),
  a11y: LocalizedText(
    en: 'A null semanticLabel is decorative (ExcludeSemantics); with a label it becomes Semantics(image: true, label:).',
    pt:
        'semanticLabel null = decorativo (ExcludeSemantics); com label vira '
        'Semantics(image: true, label:).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_illustration'],
);
