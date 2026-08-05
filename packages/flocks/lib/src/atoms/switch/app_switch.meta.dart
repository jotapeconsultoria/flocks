import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSwitch]. Registrado em `flocksCatalog`.
const AppComponentMeta appSwitchMeta = AppComponentMeta(
  id: 'app_switch',
  name: 'AppSwitch',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  since: 'flocks@0.2.0',
  summary: LocalizedText(
    en: 'On/off switch for a single option.',
    pt: 'Switch liga/desliga de uma única opção.',
  ),
  description: LocalizedText(
    en: 'Rebuilt on FlocksInteraction (focus/keyboard/hover/ring); the thumb animation runs through AppMotion (honors reduce-motion).',
    pt:
        'Reconstruído sobre FlocksInteraction (foco/teclado/hover/ring); a '
        'animação do thumb passa por AppMotion (respeita reduce-motion).',
  ),
  whenToUse: LocalizedList(
    en: <String>['Turning a setting on or off immediately.'],
    pt: <String>['Ligar/desligar imediatamente uma configuração.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'When confirmation is needed → use a button; for multiple selection → AppCheckbox.',
    ],
    pt: <String>['Confirmação necessária → use botão; múltipla → AppCheckbox.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'value', type: 'bool', isRequired: true),
    PropMeta(name: 'onChanged', type: 'ValueChanged<bool>?'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'semanticLabel', type: 'String?'),
    PropMeta(name: 'tooltip', type: 'String?'),
  ],
  states: <String>['on', 'off', 'disabled', 'focused', 'hovered'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Basic', pt: 'Básico'),
      code: 'AppSwitch(value: on, onChanged: set)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Apply the effect immediately on toggle.'],
    pt: <String>['Aplique o efeito imediatamente ao alternar.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for actions that require confirmation.'],
    pt: <String>['Não use para ações que exigem confirmação.'],
  ),
  a11y: LocalizedText(
    en: 'AppSemantics.toggle exposes toggled/enabled; focus/keyboard via FlocksInteraction.',
    pt: 'AppSemantics.toggle expõe toggled/enabled; foco/teclado via FlocksInteraction.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_checkbox'],
);
