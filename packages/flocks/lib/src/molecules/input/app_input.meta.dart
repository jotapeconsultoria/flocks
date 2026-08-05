import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppInput]. Registrado em `flocksCatalog`.
const AppComponentMeta appInputMeta = AppComponentMeta(
  id: 'app_input',
  name: 'AppInput',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@1.0.0',
  summary: LocalizedText(
    en: 'Design system text field (built on a bare EditableText).',
    pt: 'Campo de texto do design system (sobre EditableText cru).',
  ),
  description: LocalizedText(
    en: 'A text field with no Material and no Cupertino. It takes part in the global style (AppStyle: outlined by default, filled, elevated) and shape (AppRadiusMode) axes. State colors (rest/focus/error/disabled) are resolved by inputFieldColors — the same recipe as the dropdown trigger. Native mouse selection (double/triple-tap, context menu) through AppTextSelectionGestures. With onTap it becomes an action field (pickers).',
    pt:
        'Campo de texto sem Material/Cupertino. Participa do eixo global de '
        'estilo (AppStyle: outlined default, filled, elevated) e de forma '
        '(AppRadiusMode). Cores de estado (repouso/foco/erro/desabilitado) '
        'resolvidas por inputFieldColors — mesma receita do trigger do dropdown. '
        'Seleção nativa de mouse (double/triple-tap, menu de contexto) via '
        'AppTextSelectionGestures. Com onTap vira campo de ação (pickers).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Single-line or multiline text input (up to 5 lines).',
      'The base for action fields (date/time/color pickers) through onTap.',
    ],
    pt: <String>[
      'Entrada de texto de linha única ou multilinha (até 5 linhas).',
      'Base para campos de ação (date/time/color pickers) via onTap.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Choosing among options → AppDropdown.',
      'Picking a date or time → AppDatePickerInput/AppTimePickerInput.',
    ],
    pt: <String>[
      'Escolha entre opções → AppDropdown.',
      'Seleção de data/hora → AppDatePickerInput/AppTimePickerInput.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'controller', type: 'TextEditingController?'),
    PropMeta(name: 'initialValue', type: 'String?'),
    PropMeta(name: 'label', type: 'String?'),
    PropMeta(name: 'hintText', type: 'String?'),
    PropMeta(name: 'helperText', type: 'String?'),
    PropMeta(name: 'errorText', type: 'String?'),
    PropMeta(name: 'prefixIcon', type: 'String?'),
    PropMeta(name: 'suffixIcon', type: 'String?'),
    PropMeta(name: 'info', type: 'Widget?'),
    PropMeta(name: 'onClear', type: 'VoidCallback?'),
    PropMeta(
      name: 'style',
      type: 'AppStyle',
      defaultValue: 'AppStyle.outlined',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
    PropMeta(name: 'radius', type: 'BorderRadius?'),
    PropMeta(name: 'background', type: 'Color?'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'hasError', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'obscureText', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'readOnly', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'maxLines', type: 'int', defaultValue: '1'),
    PropMeta(name: 'maxLength', type: 'int?'),
    PropMeta(name: 'showCounter', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'onChanged', type: 'void Function(String)?'),
    PropMeta(name: 'onSubmitted', type: 'void Function(String)?'),
    PropMeta(name: 'onTap', type: 'VoidCallback?'),
  ],
  variants: <String>['outlined', 'filled', 'elevated'],
  states: <String>['enabled', 'focused', 'error', 'disabled', 'read-only'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Basic', pt: 'Básico'),
      code:
          "AppInput(label: 'E-mail', hintText: 'nome@dominio.com', "
          'onChanged: set)',
    ),
    CodeExample(
      title: LocalizedText(en: 'Error', pt: 'Erro'),
      code: "AppInput(label: 'Nome', errorText: 'Obrigatório', hasError: true)",
    ),
    CodeExample(
      title: LocalizedText(en: 'Info (popover)', pt: 'Info (popover)'),
      code: "AppInput(label: 'E-mail', info: AppText('Usamos só para login.'))",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use label + hintText for clarity.',
      'Use errorText for validation feedback.',
      'Pass info to explain the field in a popover beside the label.',
    ],
    pt: <String>[
      'Use label + hintText para clareza.',
      'Use errorText para feedback de validação.',
      'Passe info para explicar o campo num popover ao lado do label.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it to choose among options (use AppDropdown).'],
    pt: <String>['Não use para escolher entre opções (use AppDropdown).'],
  ),
  a11y: LocalizedText(
    en: 'Native mouse/keyboard selection; border/accent in a legible stop ≥ 3:1; error in a legible danger.',
    pt:
        'Seleção nativa de mouse/teclado; borda/acento em stop legível ≥ 3:1; '
        'erro em danger legível.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_dropdown',
    'app_date_picker_input',
    'app_color_picker_input',
  ],
);
