import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppDotsIndicator]. Registrado em `flocksCatalog`.
const AppComponentMeta appDotsIndicatorMeta = AppComponentMeta(
  id: 'app_dots_indicator',
  name: 'AppDotsIndicator',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  since: 'flocks@0.2.0',
  summary: LocalizedText(
    en: 'Progress indicator as dots (current position among N pages).',
    pt: 'Indicador de progresso em "dots" (posição atual entre N páginas).',
  ),
  description: LocalizedText(
    en: 'A row of circles where the current step takes the accent color. For labelled steps with a title/icon, use AppStepper.',
    pt:
        'Fileira de círculos onde o passo atual recebe a cor de destaque. Para '
        'etapas rotuladas com título/ícone, use AppStepper.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Carousels and onboarding: the current position among a few pages.',
    ],
    pt: <String>['Carrosséis/onboarding: posição atual entre poucas páginas.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Steps with a label or title → AppStepper.'],
    pt: <String>['Etapas com rótulo/título → AppStepper.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'currentStep', type: 'int', isRequired: true),
    PropMeta(name: 'totalSteps', type: 'int', isRequired: true),
    PropMeta(name: 'activeColor', type: 'Color?'),
    PropMeta(name: 'inactiveColor', type: 'Color?'),
    PropMeta(name: 'size', type: 'double', defaultValue: 'AppSizes.s8'),
    PropMeta(name: 'spacing', type: 'double', defaultValue: 'AppSpacings.s4'),
  ],
  states: <String>['active-dot', 'inactive-dot'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Basic', pt: 'Básico'),
      code: 'AppDotsIndicator(currentStep: 0, totalSteps: 3)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it for 2–6 pages; above that prefer labels.'],
    pt: <String>['Use para 2–6 páginas; acima disso prefira rótulos.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it as a clickable navigation control.'],
    pt: <String>['Não use como controle de navegação clicável.'],
  ),
  a11y: LocalizedText(
    en: 'AppSemantics.status announces "Step X of Y" (a live region); the dots are decorative.',
    pt: 'AppSemantics.status anuncia "Passo X de Y" (região viva); dots decorativos.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_stepper'],
);
