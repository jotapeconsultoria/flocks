import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppIllustration]. Registrado em `flocksCatalog`.
const AppComponentMeta appIllustrationMeta = AppComponentMeta(
  id: 'app_illustration',
  name: 'AppIllustration',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  since: 'flocks@0.2.0',
  summary: LocalizedText(
    en: 'Remote SVG illustration (cached), with theme-aware base/accent colors.',
    pt: 'Ilustração SVG remota (com cache), cores base/destaque theme-aware.',
  ),
  description: LocalizedText(
    en: 'Loads the SVG off the network with a local cache; shows a shimmer while loading and a "danger" circle on error. baseColor/accentColor, when omitted, resolve from the theme (neutralPrimary.s900 / secondary).',
    pt:
        'Carrega o SVG da rede com cache local; exibe shimmer no carregamento e '
        'um círculo "danger" no erro. baseColor/accentColor, quando omitidos, são '
        'resolvidos pelo tema (neutralPrimary.s900 / secondary).',
  ),
  whenToUse: LocalizedList(
    en: <String>['Empty states, onboarding, success/error with vector art.'],
    pt: <String>['Estados vazios, onboarding, sucesso/erro com arte vetorial.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Small UI icons → AppIcon.'],
    pt: <String>['Ícones pequenos de UI → AppIcon.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'illustration', type: 'String', isRequired: true),
    PropMeta(name: 'size', type: 'AppIllustrationSize', defaultValue: 'l'),
    PropMeta(name: 'baseColor', type: 'Color?'),
    PropMeta(name: 'accentColor', type: 'Color?'),
    PropMeta(name: 'semanticLabel', type: 'String?'),
  ],
  states: <String>['loading', 'loaded', 'error'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Empty state', pt: 'Estado vazio'),
      code:
          'AppIllustration(AppIllustrations.empty, size: AppIllustrationSize.xl)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Leave the colors at their defaults so they follow the theme and brand.',
    ],
    pt: <String>['Deixe as cores no default para acompanhar tema/marca.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for UI icons (prefer AppIcon).'],
    pt: <String>['Não use para ícones de UI (prefira AppIcon).'],
  ),
  a11y: LocalizedText(
    en: 'semanticLabel → image semantics with a label; decorative (excluded) when null.',
    pt:
        'semanticLabel → semântica de imagem com rótulo; decorativo (excluído) '
        'quando null.',
  ),
  crossPlatform: true,
  themeAware: true,
  // Único movimento é o shimmer do placeholder (AppShimmerLoading), que já
  // respeita reduce-motion.
  reducesMotion: true,
  related: <String>['app_icon', 'app_shimmer_loading'],
);
