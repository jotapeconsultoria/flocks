import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppStepper]. Registrado em `flocksCatalog`.
const AppComponentMeta appStepperMeta = AppComponentMeta(
  id: 'app_stepper',
  name: 'AppStepper',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Labelled step indicator (numbered/checked circles + connecting lines).',
    pt: 'Indicador de etapas rotuladas (círculos numerados/check + linhas).',
  ),
  description: LocalizedText(
    en: 'Horizontal or vertical multi-step wizard/form. Completed steps show a check and can be tapped to go back; transitions run through AppMotion.',
    pt:
        'Wizard/formulário multi-etapa horizontal ou vertical. Passos concluídos '
        'mostram check e podem ser tocados para voltar; transições via AppMotion.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Forms and wizards with a title per step.'],
    pt: <String>['Formulários/wizards com títulos por etapa.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Only the position among pages, with no labels → AppDotsIndicator.',
    ],
    pt: <String>['Só posição entre páginas, sem rótulos → AppDotsIndicator.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'currentStep', type: 'int', isRequired: true),
    PropMeta(name: 'steps', type: 'List<AppStepData>', isRequired: true),
    PropMeta(name: 'axis', type: 'Axis', defaultValue: 'Axis.horizontal'),
    PropMeta(name: 'showLabels', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'onStepTapped', type: 'ValueChanged<int>?'),
    PropMeta(name: 'activeColor', type: 'Color?'),
    PropMeta(name: 'completedColor', type: 'Color?'),
    PropMeta(name: 'upcomingColor', type: 'Color?'),
  ],
  states: <String>['completed', 'active', 'upcoming'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Wizard', pt: 'Wizard'),
      code:
          'AppStepper(currentStep: 1, steps: [AppStepData(title: "Dados"), ...])',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Provide onStepTapped so completed steps can be revisited.'],
    pt: <String>[
      'Forneça onStepTapped para permitir voltar a etapas concluídas.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not let currentStep fall outside [0, steps.length).'],
    pt: <String>['Não deixe currentStep fora de [0, steps.length).'],
  ),
  a11y: LocalizedText(
    en: 'Every step is labelled (number + title + state); completed ones become buttons (go back) via AppSemantics.',
    pt:
        'Cada passo é rotulado (número + título + estado); concluídos viram botões '
        '(voltar) via AppSemantics.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_dots_indicator', 'app_icon', 'app_text'],
);
