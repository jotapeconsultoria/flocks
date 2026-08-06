import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppCheckbox]. Registrado em `flocksCatalog`.
const AppComponentMeta appCheckboxMeta = AppComponentMeta(
  id: 'app_checkbox',
  name: 'AppCheckbox',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Multi-selection checkbox (check/uncheck).',
    pt: 'Checkbox de seleção múltipla (marcar/desmarcar).',
  ),
  description: LocalizedText(
    en: 'Rebuilt on FlocksInteraction (focus/keyboard/hover/ring) with toggle semantics. Checkmark via CustomPaint.',
    pt:
        'Reconstruído sobre FlocksInteraction (foco/teclado/hover/ring) com '
        'semântica de toggle. Checkmark via CustomPaint.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Independent options (multiple choice).'],
    pt: <String>['Opções independentes (múltipla escolha).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Exclusive single selection → AppRadio.'],
    pt: <String>['Seleção única exclusiva → AppRadio.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'checked', type: 'bool', isRequired: true),
    PropMeta(name: 'onChanged', type: 'ValueChanged<bool>?'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'semanticLabel', type: 'String?'),
    PropMeta(name: 'tooltip', type: 'String?'),
  ],
  states: <String>['default', 'checked', 'disabled', 'focused', 'hovered'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Basic', pt: 'Básico'),
      code: 'AppCheckbox(checked: v, onChanged: set)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Pass semanticLabel when there is no visible label beside it.',
    ],
    pt: <String>[
      'Passe semanticLabel quando não houver rótulo visível ao lado.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for a single choice (use AppRadio).'],
    pt: <String>['Não use para escolha única (use AppRadio).'],
  ),
  a11y: LocalizedText(
    en: 'AppSemantics.toggle exposes checked/enabled; focus/keyboard/ring via FlocksInteraction.',
    pt:
        'AppSemantics.toggle expõe checked/enabled; foco/teclado/ring via '
        'FlocksInteraction.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_switch', 'app_radio'],
);
