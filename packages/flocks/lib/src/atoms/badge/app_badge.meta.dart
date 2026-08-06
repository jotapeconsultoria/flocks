import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppBadge]. Registrado em `flocksCatalog`.
const AppComponentMeta appBadgeMeta = AppComponentMeta(
  id: 'app_badge',
  name: 'AppBadge',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Compact status pill, tinted by a semantic color role.',
    pt: 'Pill compacta de status, tingida por papel de cor semântico.',
  ),
  description: LocalizedText(
    en: 'Shows short text in a semantic role\'s full color over a background of the same color at 10%. Sized by a named step (s/m/l/xl); adapts to light/dark and to the brand. Read-only by default; with onTap it becomes an interactive pill (hover/press/focus + ring + button role).',
    pt:
        'Mostra um texto curto com a cor cheia de um papel semântico sobre um '
        'fundo da mesma cor a 10%. Dimensionada por um passo nomeado (s/m/l/xl); '
        'adapta a claro/escuro e marca. Somente-leitura por padrão; com onTap '
        'vira uma pill interativa (hover/press/foco + anel + role de botão).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'State or category label: alert status, severity, a short tag.',
      'With onTap: an actionable filter/chip (e.g. toggling a list filter).',
    ],
    pt: <String>[
      'Rótulo de estado/categoria: status de alerta, severidade, tag curta.',
      'Com onTap: filtro/chip acionável (ex.: alternar um filtro de lista).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Primary action/CTA → use a button (the badge is a label pill).',
    ],
    pt: <String>[
      'Ação primária/CTA → use um botão (o badge é uma pill de rótulo).',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'label',
      type: 'String',
      isRequired: true,
      description: LocalizedText(
        en: 'Short text shown in the pill.',
        pt: 'Texto curto exibido na pill.',
      ),
    ),
    PropMeta(
      name: 'color',
      type: 'AppBadgeColor',
      defaultValue: 'AppBadgeColor.neutral',
      description: LocalizedText(
        en: 'Semantic color role.',
        pt: 'Papel de cor semântico.',
      ),
      enumValues: <String>[
        'neutral',
        'primary',
        'info',
        'success',
        'warning',
        'danger',
      ],
    ),
    PropMeta(
      name: 'size',
      type: 'AppBadgeSize',
      defaultValue: 'AppBadgeSize.m',
      description: LocalizedText(
        en: 'Size step: drives the padding and the text role.',
        pt: 'Passo de tamanho: dirige o padding e o papel de texto.',
      ),
      enumValues: <String>['s', 'm', 'l', 'xl'],
    ),
    PropMeta(
      name: 'onTap',
      type: 'VoidCallback?',
      description: LocalizedText(
        en: 'Makes the pill interactive (hover/press/focus + button role). Null = read-only.',
        pt:
            'Torna a pill interativa (hover/press/foco + role de botão). Nulo = '
            'somente-leitura.',
      ),
    ),
    PropMeta(
      name: 'effect',
      type: 'AppBadgeEffect',
      defaultValue: 'AppBadgeEffect.scale',
      description: LocalizedText(
        en: 'Hover/press micro-animation (only when onTap != null).',
        pt: 'Micro-animação de hover/press (só quando onTap != null).',
      ),
      enumValues: <String>['none', 'scale', 'lift'],
    ),
  ],
  variants: <String>[
    'neutral',
    'primary',
    'info',
    'success',
    'warning',
    'danger',
  ],
  states: <String>['default', 'hovered', 'pressed', 'focused', 'dragged'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Alert status', pt: 'Status de alerta'),
      code: "AppBadge('Pendente', color: AppBadgeColor.warning)",
    ),
    CodeExample(
      title: LocalizedText(en: 'Neutral', pt: 'Neutro'),
      code: "AppBadge('Resolvido')",
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Interactive (filter)',
        pt: 'Interativa (filtro)',
      ),
      code: "AppBadge('Ativos', color: AppBadgeColor.info, onTap: _toggle)",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Pick the semantic role by meaning.',
      'Keep the text short (1–2 words).',
      'Use onTap only when the pill stands for an action or a filter.',
    ],
    pt: <String>[
      'Escolha o papel semântico pelo significado.',
      'Mantenha o texto curto (1–2 palavras).',
      'Use onTap só quando a pill representa uma ação/filtro.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not use it as a primary CTA; do not hardcode a color (use AppBadgeColor).',
    ],
    pt: <String>[
      'Não use como CTA primário; não embuta cor fixa (use AppBadgeColor).',
    ],
  ),
  a11y: LocalizedText(
    en: 'Read-only: exposes label as a single labelled node (AppSemantics.label), excluding the inner semantics. With onTap: becomes a button role (AppSemantics.button), keyboard-activatable (Enter/Space) with a focus ring. Do not rely on color alone: the label carries the state.',
    pt:
        'Somente-leitura: expõe label como nó rotulado único (AppSemantics.label), '
        'excluindo a semântica interna. Com onTap: vira role de botão '
        '(AppSemantics.button), ativável por teclado (Enter/Espaço) com anel de '
        'foco. Não dependa só da cor: o label carrega o estado.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_text', 'app_avatar'],
);
