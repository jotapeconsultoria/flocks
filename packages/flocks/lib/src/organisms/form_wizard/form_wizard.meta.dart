import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppFormWizard]. Registrado em `flocksCatalog`.
const AppComponentMeta appFormWizardMeta = AppComponentMeta(
  id: 'app_form_wizard',
  name: 'AppFormWizard',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Multi-step form with an indicator (at the side on desktop, on top on mobile).',
    pt:
        'Formulário multi-passo com indicador (lateral no desktop, topo no '
        'mobile).',
  ),
  description: LocalizedText(
    en: 'A step wizard: a progress indicator (at the side on desktop, on top on mobile, through AppDevice) + the current step\'s panel (lazy). Each step (AppFormWizardStep) has a title, an optional subtitle/icon, a content builder and a validator. Colors 100% from the theme; the panel transition runs on motion tokens.',
    pt:
        'Wizard de passos: indicador de progresso (lateral no desktop, topo no '
        'mobile, via AppDevice) + o painel do passo atual (lazy). Cada passo '
        '(AppFormWizardStep) tem título, subtítulo/ícone opcionais, builder do '
        'conteúdo e validador. Cores 100% do tema; transição do painel via tokens '
        'de motion.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A registration or flow split into steps with visible progress.',
    ],
    pt: <String>['Cadastro/fluxo dividido em etapas com progresso visível.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Parallel tabs with no order or progress → AppTabView.'],
    pt: <String>['Abas paralelas sem ordem/progresso → AppTabView.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'currentStep', type: 'int', isRequired: true),
    PropMeta(name: 'steps', type: 'List<AppFormWizardStep>', isRequired: true),
    PropMeta(name: 'onStepTapped', type: 'ValueChanged<int>?'),
    PropMeta(name: 'showIndicator', type: 'bool', defaultValue: 'true'),
  ],
  states: <String>['step-active', 'step-done', 'step-pending'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: '3-step wizard', pt: 'Wizard de 3 passos'),
      code:
          'AppFormWizard(currentStep: step, steps: steps, '
          'onStepTapped: cubit.goTo)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Validate each step before advancing (step.validator).'],
    pt: <String>['Valide cada passo antes de avançar (step.validator).'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for navigation with no order (AppTabView).'],
    pt: <String>['Não use para navegação sem ordem (AppTabView).'],
  ),
  a11y: LocalizedText(
    en: 'The indicator reflects the active/completed/pending step by color (all from the theme, AA). The step\'s panel is focusable in reading order.',
    pt:
        'O indicador reflete o passo ativo/concluído/pendente por cor (todas do '
        'tema, AA). O painel do passo é focável na ordem de leitura.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_tab_view', 'app_stepper'],
);
