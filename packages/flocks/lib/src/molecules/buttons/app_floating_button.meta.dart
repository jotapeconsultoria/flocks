import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppFloatingButton]. Registrado em `flocksCatalog`.
const AppComponentMeta appFloatingButtonMeta = AppComponentMeta(
  id: 'app_floating_button',
  name: 'AppFloatingButton',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Floating action button (FAB) with a shadow that is always there; icon and/or label, circular by default.',
    pt:
        'Ação flutuante (FAB) com sombra sempre presente; ícone e/ou rótulo, '
        'circular por padrão.',
  ),
  description: LocalizedText(
    en: 'Floating action button. Takes an icon and/or a label (icon-only, text-only or extended). It floats above the content → it ALWAYS has a shadow, even outside the elevated style. It varies along the AppStyle axis: filled, outlined, elevated and glass (real blurred glass, through AppGlassSurface, degrading to opaque when transparency is reduced). Circular by default (it inherits the global shape; local reto/redondo/circular are honored). Delegates to ButtonCore: states, AA colors, focus ring, press-scale (AppMotion), loading and a11y.',
    pt:
        'Botão de ação flutuante. Aceita ícone e/ou rótulo (só-ícone, só-texto ou '
        'estendido). Paira sobre o conteúdo → tem sombra SEMPRE, mesmo fora do '
        'estilo elevated. Varia pelo eixo AppStyle: filled, outlined, elevated e '
        'glass (vidro real com blur, via AppGlassSurface, degradando para opaco '
        'quando a transparência é reduzida). Forma padrão circular (herda o global; '
        'reto/redondo/circular locais honrados). Delega a ButtonCore: estados, '
        'cores AA, anel de foco, press-scale (AppMotion), loading e a11y.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A persistent primary action floating over the content (e.g. create/new).',
    ],
    pt: <String>[
      'Ação primária persistente, flutuando sobre o conteúdo (ex.: criar/novo).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'An inline action in the flow (on the content\'s line, with a label) → AppButton.',
      'A secondary/tertiary action with no floating prominence → AppButton.',
    ],
    pt: <String>[
      'Ação inline no fluxo (na linha do conteúdo, com rótulo) → AppButton.',
      'Ação secundária/terciária sem destaque flutuante → AppButton.',
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
    PropMeta(
      name: 'glass',
      type: 'bool?',
      description: LocalizedText(
        en: 'Glass axis (real glass). null follows the global glassTheme.',
        pt: 'Eixo glass (vidro real). null segue o global glassTheme.',
      ),
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
      description: LocalizedText(
        en: 'Height/side (s=40/m=48/l=56) and the icon-only glyph (s→16/m→24/l→32).',
        pt: 'Altura/lado (s=40/m=48/l=56) e o glifo só-ícone (s→16/m→24/l→32).',
      ),
      enumValues: <String>['s', 'm', 'l'],
    ),
    PropMeta(name: 'loading', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(
      name: 'radiusMode',
      type: 'AppRadiusMode?',
      enumValues: <String>['reto', 'redondo', 'circular', 'padrao'],
    ),
    PropMeta(name: 'radius', type: 'BorderRadius?'),
    PropMeta(name: 'onLongPress', type: 'VoidCallback?'),
    PropMeta(name: 'semanticsLabel', type: 'String?'),
  ],
  variants: <String>[
    'filled',
    'outlined',
    'elevated',
    'glass',
    'icon-only',
    'text-only',
    'icon+label',
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
      title: LocalizedText(en: 'Circle (icon-only)', pt: 'Círculo (só-ícone)'),
      code: 'AppFloatingButton(icon: AppIconToken.add, onPressed: create)',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Extended (icon + label)',
        pt: 'Estendido (ícone + rótulo)',
      ),
      code:
          "AppFloatingButton(icon: AppIconToken.add, label: 'Novo', onPressed: create)",
    ),
    CodeExample(
      title: LocalizedText(en: 'Glass', pt: 'Vidro'),
      code:
          'AppFloatingButton(glass: true, icon: AppIconToken.add, onPressed: create)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'One FAB per screen; circular for icon-only, stadium when extended.',
    ],
    pt: <String>[
      '1 FAB por tela; forma circular para só-ícone, stadium quando estendido.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not use it for inline labelled actions in the flow (→ AppButton).',
    ],
    pt: <String>[
      'Não use para ações inline com rótulo no fluxo (→ AppButton).',
    ],
  ),
  a11y: LocalizedText(
    en: 'AppSemantics.button (label defaults to label or to the icon name; enabled/loading reflected); Enter/Space; content ≥ AA against the background in every state and style. Glass degrades to opaque when transparency is reduced, preserving contrast.',
    pt:
        'AppSemantics.button (label default = label ou nome do ícone; '
        'enabled/loading refletidos); Enter/Space; conteúdo ≥ AA sobre o fundo em '
        'todos os estados/estilos. Glass degrada para opaco quando a transparência '
        'é reduzida, preservando contraste.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_button', 'app_scaffold'],
);
