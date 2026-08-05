import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppRadio]. Registrado em `flocksCatalog`.
const AppComponentMeta appRadioMeta = AppComponentMeta(
  id: 'app_radio',
  name: 'AppRadio',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  since: 'flocks@0.2.0',
  summary: LocalizedText(
    en: 'Radio button for single selection within a mutually exclusive group.',
    pt: 'Radio button de seleção única em grupo mutuamente exclusivo.',
  ),
  description: LocalizedText(
    en: 'Generic AppRadio<T>. Rebuilt on FlocksInteraction (focus/keyboard/ring) with mutually exclusive toggle semantics.',
    pt:
        'Genérico AppRadio<T>. Reconstruído sobre FlocksInteraction (foco/teclado/'
        'ring) com semântica de toggle mutuamente exclusivo.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Choosing one option among several mutually exclusive ones.'],
    pt: <String>['Escolha de uma opção entre várias mutuamente exclusivas.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Multiple selections → AppCheckbox; on/off → AppSwitch.'],
    pt: <String>['Múltiplas seleções → AppCheckbox; liga/desliga → AppSwitch.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'value', type: 'T', isRequired: true),
    PropMeta(name: 'groupValue', type: 'T?', isRequired: true),
    PropMeta(name: 'onChanged', type: 'ValueChanged<T?>?'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'semanticLabel', type: 'String?'),
  ],
  states: <String>['default', 'selected', 'disabled', 'focused', 'hovered'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Group', pt: 'Grupo'),
      code:
          'AppRadio<Plan>(value: Plan.basic, groupValue: sel, onChanged: pick)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it inside a group sharing the same groupValue.'],
    pt: <String>['Use dentro de um grupo com o mesmo groupValue.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for a standalone on/off (use AppSwitch).'],
    pt: <String>['Não use para liga/desliga isolado (use AppSwitch).'],
  ),
  a11y: LocalizedText(
    en: 'AppSemantics.toggle(mutuallyExclusive: true) exposes checked plus the group; focus/keyboard/ring via FlocksInteraction.',
    pt:
        'AppSemantics.toggle(mutuallyExclusive: true) expõe checked + grupo; foco/'
        'teclado/ring via FlocksInteraction.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_checkbox', 'app_switch'],
);
