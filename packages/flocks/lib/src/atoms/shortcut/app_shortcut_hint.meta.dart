import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppShortcutHint]. Registrado em `flocksCatalog`.
const AppComponentMeta appShortcutHintMeta = AppComponentMeta(
  id: 'app_shortcut_hint',
  name: 'AppShortcutHint',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Badge that SHOWS a keyboard shortcut, resolved per platform.',
    pt: 'Selo que MOSTRA um atalho de teclado, resolvido por plataforma.',
  ),
  description: LocalizedText(
    en: 'A shortcut nobody sees goes unused: the badge is what makes it discoverable without requiring documentation. It takes an AppShortcut (a platform-independent description) and resolves it at paint time — `usesPrimaryModifier` becomes ⌘ on macOS and Ctrl everywhere else, because teaching the wrong key is worse than showing nothing. It is DECORATIVE: it takes no pointer input; whoever wants the action clickable puts the badge inside the control itself. The color comes from a legible `secondary` stop against the surface it was told about — and, inside a painted control, from the AppShortcutHintColor that control installs with its own foreground.',
    pt:
        'Um atalho que ninguém vê não é usado: o selo é o que o torna descoberto '
        'sem exigir documentação. Recebe um AppShortcut (descrição independente '
        'de plataforma) e o resolve na hora de desenhar — `usesPrimaryModifier` '
        'vira ⌘ no macOS e Ctrl no resto, porque ensinar a tecla errada é pior '
        'do que não mostrar nada. É DECORATIVO: não recebe toque; quem quer a '
        'ação clicável põe o selo dentro do próprio controle. A cor sai de um '
        'stop legível de `secondary` contra a superfície informada — e, dentro '
        'de um controle pintado, do AppShortcutHintColor que o controle instala '
        'com o próprio foreground.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Showing the shortcut at the right edge of a field, button, tab or menu item.',
      'Teaching a new shortcut without needing a tour or documentation.',
    ],
    pt: <String>[
      'Mostrar o atalho no canto direito de um campo, botão, aba ou item de menu.',
      'Ensinar um atalho novo sem precisar de tour ou documentação.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Registering the actual shortcut → AppShortcutsScope/Shortcuts. The badge only draws.',
      'A generic label in a pill → AppBadge.',
    ],
    pt: <String>[
      'Registrar o atalho de verdade → AppShortcutsScope/Shortcuts. O selo só '
          'desenha.',
      'Rótulo genérico em pílula → AppBadge.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'shortcut',
      type: 'AppShortcut',
      isRequired: true,
      description: LocalizedText(
        en: 'Shortcut description (key + modifiers), independent of the OS.',
        pt: 'Descrição do atalho (tecla + modificadores), independente de SO.',
      ),
    ),
    PropMeta(
      name: 'size',
      type: 'AppShortcutHintSize',
      defaultValue: 'AppShortcutHintSize.s',
      enumValues: <String>['s', 'm'],
      description: LocalizedText(
        en: 's inside fields and chips; m in headers and bars.',
        pt: 's dentro de campos e chips; m em cabeçalhos e barras.',
      ),
    ),
    PropMeta(
      name: 'color',
      type: 'Color?',
      description: LocalizedText(
        en: 'Overrides the text and the badge. Default: a legible secondary stop.',
        pt: 'Override do texto e do selo. Default: stop legível de secondary.',
      ),
    ),
    PropMeta(
      name: 'background',
      type: 'Color?',
      description: LocalizedText(
        en: 'The surface the badge is set on — it is what picks the stop. Defaults to surfaceContainer; pass `surface` in the header and in the rail.',
        pt:
            'A superfície em que o selo é pousado — é ela que escolhe o stop. '
            'Default surfaceContainer; passe `surface` no header e no rail.',
      ),
    ),
  ],
  variants: <String>['s', 'm'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Platform shortcut in a search field',
        pt: 'Atalho de plataforma num campo de busca',
      ),
      code:
          'AppOmniSearch(\n'
          "  hintText: 'Buscar',\n"
          "  shortcut: const AppShortcut.primary('K'),\n"
          '  onSearch: search,\n'
          ')',
      description: LocalizedText(
        en: 'Shows ⌘K on macOS and Ctrl+K everywhere else.',
        pt: 'Mostra ⌘K no macOS e Ctrl+K no resto.',
      ),
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Badge over the surface (header/rail)',
        pt: 'Selo sobre a surface (header/rail)',
      ),
      code:
          'AppShortcutHint(\n'
          "  const AppShortcut('/'),\n"
          '  size: AppShortcutHintSize.m,\n'
          '  background: theme.colorTheme.surface,\n'
          ')',
      description: LocalizedText(
        en: 'Naming the real surface matters: the stop computed against surfaceContainer disappears when the badge sits on surface.',
        pt:
            'Informar a superfície real importa: o stop calculado contra a '
            'surfaceContainer some quando o selo está sobre a surface.',
      ),
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Pass `background` when the badge does not sit on surfaceContainer.',
      'Use AppShortcut.primary for the platform\'s modifier.',
    ],
    pt: <String>[
      'Passe `background` quando o selo não estiver sobre surfaceContainer.',
      'Use AppShortcut.primary para o modificador da plataforma.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not write "Ctrl+K" in a String: on a Mac it teaches the wrong key.',
      'Do not make the badge clickable — the action belongs to the control hosting it.',
    ],
    pt: <String>[
      'Não escreva "Ctrl+K" numa String: no Mac ensina a tecla errada.',
      'Não torne o selo clicável — a ação é do controle que o hospeda.',
    ],
  ),
  a11y: LocalizedText(
    en: 'A single node labelled "Shortcut: Command K" (excludeSemantics), with the modifier spelled out — a screen reader does not read the ⌘ glyph. The height is fixed per size, so the badge does not deform under text-scale.',
    pt:
        'Nó único rotulado "Atalho: Comando K" (excludeSemantics), com o '
        'modificador por extenso — o leitor de tela não lê o glifo ⌘. A altura '
        'é fixa por tamanho, então o selo não deforma com text-scale.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_omni_search', 'app_badge'],
);
