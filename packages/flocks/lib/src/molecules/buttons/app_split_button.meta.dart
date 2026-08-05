import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSplitButton]. Registrado em `flocksCatalog`.
const AppComponentMeta appSplitButtonMeta = AppComponentMeta(
  id: 'app_split_button',
  name: 'AppSplitButton',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.4.0',
  summary: LocalizedText(
    en: 'Primary action + a caret that opens an AppMenu of secondary actions.',
    pt: 'Ação primária + caret que abre um AppMenu de ações secundárias.',
  ),
  description: LocalizedText(
    en: 'Follows AppButton\'s global rules: it varies along the AppStyle axis (filled/outlined/elevated) and reuses the design system\'s button color model. The primary segment fires the default action; the caret opens the alternatives in an AppMenu.',
    pt:
        'Segue as regras globais do AppButton: varia pelo eixo AppStyle '
        '(filled/outlined/elevated) e reusa o modelo de cor dos botões do DS. '
        'O segmento primário dispara a ação padrão; o caret abre as ações '
        'alternativas num AppMenu.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'One default action with related variations (Save / Save and exit).',
      'Cutting the visual noise of several actions from the same group.',
    ],
    pt: <String>[
      'Uma ação padrão com variações relacionadas (Salvar / Salvar e sair).',
      'Reduzir a poluição visual de várias ações de mesmo grupo.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Unrelated actions → use separate buttons or an AppMenu.',
      'A single action → use AppButton.',
    ],
    pt: <String>[
      'Ações não relacionadas → use botões separados ou um AppMenu.',
      'Uma única ação → use AppButton.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'label', type: 'String', isRequired: true),
    PropMeta(name: 'onPressed', type: 'VoidCallback?', isRequired: true),
    PropMeta(name: 'menuEntries', type: 'List<AppMenuEntry>', isRequired: true),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(name: 'color', type: 'AppButtonColor', defaultValue: 'primary'),
    PropMeta(name: 'size', type: 'AppButtonSize', defaultValue: 'l'),
    PropMeta(name: 'icon', type: 'String?'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'loading', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
    PropMeta(name: 'radius', type: 'BorderRadius?'),
  ],
  variants: <String>['filled', 'outlined', 'elevated'],
  states: <String>[
    'enabled',
    'hovered',
    'pressed',
    'focused',
    'disabled',
    'loading',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Save with variations',
        pt: 'Salvar com variações',
      ),
      code:
          'AppSplitButton(label: "Salvar", onPressed: save, menuEntries: ['
          'AppMenuItem(label: "Salvar e sair", onPressed: saveAndExit)])',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use the caret for variations of the SAME primary action.'],
    pt: <String>['Use o caret para variações da MESMA ação primária.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not put unrelated actions in the caret.'],
    pt: <String>['Não junte ações não relacionadas no caret.'],
  ),
  a11y: LocalizedText(
    en: 'Two button nodes (primary + a "More actions" caret), both real FlocksInteraction: Tab focus with a dedicated ring, Enter/Space activate. The caret opens an AppMenu with keyboard navigation and Esc. Press-scale and highlight honor reduce-motion.',
    pt:
        'Dois nós de botão (primário + caret "Mais ações"), ambos FlocksInteraction '
        'reais: foco por Tab com anel dedicado, Enter/Space acionam. O caret abre '
        'um AppMenu com navegação por teclado e Esc. Press-scale/realce respeitam '
        'reduce-motion.',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_button', 'app_menu'],
);
