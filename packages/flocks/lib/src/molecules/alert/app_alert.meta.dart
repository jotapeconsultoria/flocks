import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppAlert]. Registrado em `flocksCatalog`.
const AppComponentMeta appAlertMeta = AppComponentMeta(
  id: 'app_alert',
  name: 'AppAlert',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Alert card with a title, a description, a semantic icon — and slots for an action, a dismiss control and free content.',
    pt: 'Card de alerta com título, descrição, ícone semântico — e slots de ação, dispensar e conteúdo livre.',
  ),
  description: LocalizedText(
    en: 'The alert CARD only (surfaceContainer tinted by the semantic color) with a title, a description (up to maxLines lines, 3 by default) and an icon in the semantic color (info/success/warning/danger). It can carry an action inside the card (footer row by default, or at the end of the title row), a named dismiss control and free content below the description. The container follows the global AppStyle axis (filled = tone only; outlined = tone + border; elevated = tone + shadow). To show it somewhere on screen use the `showAppOverlay` helper (3×3 position without the center, maximum width, enter/exit animation). Colors 100% from the theme → AA contrast; announced (liveRegion) unless liveRegion is false.',
    pt:
        'Apenas o CARD de alerta (surfaceContainer tingido pela cor semântica) '
        'com título, descrição (até maxLines linhas, 3 por padrão) e ícone na '
        'cor semântica (info/success/warning/danger). Pode carregar uma ação '
        'DENTRO do card (rodapé por padrão, ou no fim da linha do título), um '
        'controle de dispensar nomeado e conteúdo livre abaixo da descrição. O '
        'container segue o eixo AppStyle global (filled = só o tom; outlined = '
        'tom + borda; elevated = tom + sombra). Para exibi-lo num ponto da tela '
        'use o helper `showAppOverlay` (posição 3×3 sem o centro, largura '
        'máxima, animação de entrada/saída). Cores 100% do tema → contraste AA; '
        'anunciado (liveRegion), salvo liveRegion false.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Contextual feedback (notice, error, success) — inline on the page.',
      'Transient feedback (it disappears on its own) — through showAppOverlay with a duration.',
    ],
    pt: <String>[
      'Feedback contextual (aviso, erro, sucesso) — inline na página.',
      'Feedback transitório (some sozinho) — via showAppOverlay com duration.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A short status pill (no title or description) → AppBadge.',
      'A generic floating surface (free content) → AppCard.',
    ],
    pt: <String>[
      'Pílula curta de status (sem título/descrição) → AppBadge.',
      'Superfície flutuante genérica (conteúdo livre) → AppCard.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'description', type: 'String', isRequired: true),
    PropMeta(
      name: 'color',
      type: 'AppAlertColor',
      defaultValue: 'AppAlertColor.info',
      enumValues: <String>['info', 'success', 'warning', 'danger'],
    ),
    PropMeta(
      name: 'icon',
      type: 'String?',
      description: LocalizedText(
        en: 'Icon to the right of the title (defaults to the color\'s icon).',
        pt: 'Ícone à direita do título (default = ícone do color).',
      ),
    ),
    PropMeta(
      name: 'action',
      type: 'Widget?',
      description: LocalizedText(
        en: 'Action slot inside the card (a button, a link). A widget slot rather than a label/callback pair: real cases need loading, two actions, a dropdown.',
        pt: 'Slot de ação dentro do card (botão, link). Slot de widget em vez de par label/callback: os casos reais precisam de loading, duas ações, um dropdown.',
      ),
    ),
    PropMeta(
      name: 'actionPlacement',
      type: 'AppAlertActionPlacement',
      defaultValue: 'AppAlertActionPlacement.footer',
      description: LocalizedText(
        en: 'Where the action sits: its own footer row aligned to the end (default), or at the end of the title row for the compact strip.',
        pt: 'Onde a ação repousa: rodapé próprio alinhado ao fim (default), ou no fim da linha do título, na faixa compacta.',
      ),
      enumValues: <String>['footer', 'trailing'],
    ),
    PropMeta(
      name: 'onDismiss',
      type: 'VoidCallback?',
      description: LocalizedText(
        en: 'Draws a named close control at the end of the title row. A pure callback: the caller owns visibility, the card never hides itself.',
        pt: 'Desenha um controle de fechar nomeado no fim da linha do título. Callback puro: a visibilidade é do chamador, o card nunca se esconde sozinho.',
      ),
    ),
    PropMeta(
      name: 'dismissSemanticLabel',
      type: 'String',
      defaultValue: "'Dispensar'",
      description: LocalizedText(
        en: 'Accessible name of the close control.',
        pt: 'Nome acessível do controle de fechar.',
      ),
    ),
    PropMeta(
      name: 'child',
      type: 'Widget?',
      description: LocalizedText(
        en: 'Free content below the description and above the action footer, inheriting the tinted background and padding.',
        pt: 'Conteúdo livre abaixo da descrição e acima do rodapé da ação, herdando o fundo tingido e o padding.',
      ),
    ),
    PropMeta(
      name: 'liveRegion',
      type: 'bool',
      defaultValue: 'true',
      description: LocalizedText(
        en: 'Announce the card as a live region. Turn it off when the alert is furniture (a permanent settings box): a live region re-announces the whole card whenever an inner control changes.',
        pt: 'Anuncia o card como região viva. Desligue quando o alerta é mobília (caixa permanente de configuração): região viva re-anuncia o card inteiro a cada mudança de um controle interno.',
      ),
    ),
    PropMeta(
      name: 'maxLines',
      type: 'int?',
      defaultValue: '3',
      description: LocalizedText(
        en: 'Line cap of the description (ellipsis). Null removes the cap and the text runs whole.',
        pt: 'Teto de linhas da descrição (ellipsis). Nulo remove o teto e o texto corre inteiro.',
      ),
    ),
  ],
  variants: <String>['info', 'success', 'warning', 'danger'],
  states: <String>['default', 'with-action', 'dismissible'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Error alert', pt: 'Alerta de erro'),
      code:
          "AppAlert(title: 'Sem conexão', description: '...', "
          'color: AppAlertColor.danger)',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Callout with an action',
        pt: 'Callout com ação',
      ),
      code:
          "AppAlert(title: 'Troca agendada', description: '...', "
          'color: AppAlertColor.warning, '
          "action: AppButton(label: 'Cancelar', size: AppButtonSize.s, "
          'style: AppStyle.outlined, onPressed: cancelar))',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Positioned on screen',
        pt: 'Posicionado na tela',
      ),
      code:
          'showAppOverlay(context: context, position: AppOverlayPosition.topRight, '
          'animation: AppOverlayAnimation.slide, maxWidth: 360, '
          "child: AppAlert(title: 'Salvo', description: '...'))",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use the semantic color that matches the message (danger for an error, and so on).',
      'Keep the title short (1 line).',
      'Small buttons in the trailing placement; two or more actions go to the footer.',
      'liveRegion: false when the alert is page furniture, not news.',
    ],
    pt: <String>[
      'Use a cor semântica que casa com a mensagem (danger para erro etc.).',
      'Mantenha o título curto (1 linha).',
      'Botão pequeno no trailing; duas ou mais ações vão para o footer.',
      'liveRegion: false quando o alerta é mobília da página, não notícia.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not stack several overlays in the same corner at once.',
      'Do not expect the card to hide itself on dismiss — the caller owns visibility.',
    ],
    pt: <String>[
      'Não empilhe vários overlays no mesmo canto ao mesmo tempo.',
      'Não espere o card se esconder sozinho ao dispensar — a visibilidade é do chamador.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Wrapped in AppSemantics.liveRegion → announced when it appears; liveRegion: false keeps title and description readable without re-announcing. The dismiss control is its own named tap target (dismissSemanticLabel) and adds a Tab stop, as does the action. Title in onSurface and description in neutral s700 over the tinted background both pass AA; the border (outlined) and the icon (semantic color) are ≥ 3:1 against the surface, and so is the close glyph composed over the tint.',
    pt:
        'Embrulhado em AppSemantics.liveRegion → anunciado ao surgir; '
        'liveRegion: false mantém título e descrição legíveis sem re-anúncio. O '
        'controle de dispensar é alvo próprio nomeado (dismissSemanticLabel) e '
        'acrescenta uma parada de Tab, como a ação. Título onSurface e descrição '
        'neutro s700 sobre o fundo tingido passam AA; borda (outlined) e ícone '
        '(cor semântica) ≥ 3:1 sobre a superfície, e o glifo de fechar composto '
        'sobre o tom também.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_badge', 'app_card', 'app_tooltip'],
);
