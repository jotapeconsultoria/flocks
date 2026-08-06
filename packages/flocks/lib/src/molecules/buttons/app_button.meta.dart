import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppButton]. Registrado em `flocksCatalog`.
const AppComponentMeta appButtonMeta = AppComponentMeta(
  id: 'app_button',
  name: 'AppButton',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Action button (label/icon) that varies along the global AppStyle axis.',
    pt: 'Botão de ação (rótulo/ícone) que varia pelo eixo global AppStyle.',
  ),
  description: LocalizedText(
    en: 'The design system\'s only button with a label/icon. It varies along the AppStyle axis: filled (solid primary), outlined (bordered secondary) and elevated (solid + symmetric shadow). Background and content hold AA contrast in every state; hover/press deepen the background. Built on FlocksInteraction (focus/keyboard/ring), with press-scale through AppMotion, a loading state and the global radius. Replaces AppFillButton/AppLineButton.',
    pt:
        'Único botão com rótulo/ícone do DS. Varia pelo eixo AppStyle: filled '
        '(primária preenchida), outlined (secundária contornada) e elevated '
        '(preenchida + sombra simétrica). Fundo/conteúdo com contraste AA em '
        'todos os estados; hover/press aprofundam o fundo. Sobre FlocksInteraction '
        '(foco/teclado/anel), press-scale via AppMotion, loading e raio global. '
        'Substitui AppFillButton/AppLineButton.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Any action with a label or icon; pick the emphasis through style.',
    ],
    pt: <String>['Qualquer ação com rótulo/ícone; escolha a ênfase via style.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Icon only → AppIconButton.',
      'Tertiary/link (no container) → AppTextButton.',
      'An action plus a menu of actions → AppSplitButton.',
    ],
    pt: <String>[
      'Só ícone → AppIconButton.',
      'Terciária/link (sem container) → AppTextButton.',
      'Ação + menu de ações → AppSplitButton.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'onPressed', type: 'VoidCallback?', isRequired: true),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      defaultValue: 'theme.styleTheme.style',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(name: 'label', type: 'String?'),
    PropMeta(name: 'icon', type: 'String?'),
    PropMeta(
      name: 'color',
      type: 'AppButtonColor',
      defaultValue: 'AppButtonColor.primary',
      enumValues: <String>[
        'danger',
        'info',
        'neutral',
        'primary',
        'secondary',
        'success',
        'tertiary',
        'warning',
      ],
    ),
    PropMeta(
      name: 'size',
      type: 'AppButtonSize',
      defaultValue: 'AppButtonSize.l',
      enumValues: <String>['s', 'm', 'l'],
    ),
    PropMeta(name: 'loading', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'expandedWidth', type: 'bool?'),
    PropMeta(name: 'fixedWidth', type: 'double?'),
    PropMeta(
      name: 'radiusMode',
      type: 'AppRadiusMode?',
      enumValues: <String>['reto', 'redondo', 'circular', 'padrao'],
    ),
    PropMeta(name: 'radius', type: 'BorderRadius?'),
    PropMeta(name: 'semanticsLabel', type: 'String?'),
  ],
  variants: <String>[
    'filled',
    'outlined',
    'elevated',
    'icon+label',
    'icon-only',
  ],
  states: <String>[
    'default',
    'hovered',
    'pressed',
    'focused',
    'disabled',
    'loading',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Primary', pt: 'Primária'),
      code: "AppButton(label: 'Salvar', onPressed: save)",
    ),
    CodeExample(
      title: LocalizedText(en: 'Secondary', pt: 'Secundária'),
      code:
          "AppButton(style: AppStyle.outlined, label: 'Cancelar', onPressed: cancel)",
    ),
    CodeExample(
      title: LocalizedText(en: 'Elevated', pt: 'Elevada'),
      code:
          "AppButton(style: AppStyle.elevated, label: 'Publicar', onPressed: publish)",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'One primary button per screen; use outlined for the secondary one.',
    ],
    pt: <String>['1 botão primário por tela; use outlined para o secundário.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for plain text navigation (→ AppTextButton).'],
    pt: <String>['Não use para navegação de texto puro (→ AppTextButton).'],
  ),
  a11y: LocalizedText(
    en: 'AppSemantics.button (label defaults to label; enabled/loading reflected); Enter/Space; content ≥ AA against the background in every state and style.',
    pt:
        'AppSemantics.button (label default = label; enabled/loading refletidos); '
        'Enter/Space; conteúdo ≥ AA sobre o fundo em todos os estados/estilos.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_interaction', 'app_split_button'],
);
