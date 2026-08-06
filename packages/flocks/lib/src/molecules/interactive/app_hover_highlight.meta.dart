import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppHoverHighlight]. Registrado em `flocksCatalog`.
const AppComponentMeta appHoverHighlightMeta = AppComponentMeta(
  id: 'app_hover_highlight',
  name: 'AppHoverHighlight',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Purely visual hover highlight — no gesture, no focus, no Tab stop.',
    pt:
        'Realce de hover puramente visual — sem gesto, sem foco, sem parada de '
        'Tab.',
  ),
  description: LocalizedText(
    en: 'It exists for overlay triggers (AppMenu, AppPopover, AppPickerAnchor): they already install click and focus around the trigger, so wrapping the content in an AppInteraction would create TWO targets — a second Tab stop and the classic double-toggle, where the overlay opens on the inner gesture and closes on the outer one. This paints the same translucent highlight as AppInteraction (onSurface at 8%) and nothing else, giving the trigger the affordance of every other clickable item without fighting over the gesture with whoever already owns it.',
    pt:
        'Existe para os gatilhos de overlay (AppMenu, AppPopover, '
        'AppPickerAnchor): eles já instalam clique e foco em volta do trigger, '
        'então embrulhar o conteúdo num AppInteraction criaria DOIS alvos — uma '
        'segunda parada de Tab e o duplo-toggle clássico, em que o overlay abre '
        'no gesto de dentro e fecha no de fora. Este pinta o mesmo realce '
        'translúcido do AppInteraction (onSurface a 8%) e nada mais, dando ao '
        'gatilho a afordância dos outros itens clicáveis sem disputar o gesto '
        'com quem já o tem.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The content of an overlay trigger that already has a gesture and focus around it.',
      'A row highlight where the click belongs to an ancestor.',
    ],
    pt: <String>[
      'Conteúdo de um gatilho de overlay que já tem gesto e foco por fora.',
      'Realce de linha onde o clique é de um ancestral.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A genuinely clickable target → AppInteraction (it brings the gesture, the focus and the semantics).',
      'A button → AppButton.',
    ],
    pt: <String>[
      'Alvo clicável de verdade → AppInteraction (traz gesto, foco e semântica).',
      'Botão → AppButton.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'child',
      type: 'Widget',
      isRequired: true,
      description: LocalizedText(
        en: 'Highlighted content.',
        pt: 'Conteúdo realçado.',
      ),
    ),
    PropMeta(
      name: 'padding',
      type: 'EdgeInsetsGeometry',
      defaultValue: 'EdgeInsets.zero',
      description: LocalizedText(
        en: 'Breathing room between the highlight and the content — it is what gives the painted area its body; at zero the highlight clings to the text.',
        pt:
            'Respiro entre o realce e o conteúdo — é ele que dá corpo à área '
            'pintada; com zero o realce fica colado no texto.',
      ),
    ),
    PropMeta(
      name: 'borderRadius',
      type: 'BorderRadius?',
      description: LocalizedText(
        en: 'Shape of the highlight. Default: the theme\'s global radius.',
        pt: 'Forma do realce. Default: o raio global do tema.',
      ),
    ),
  ],
  states: <String>['rest', 'hover'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Trigger for a menu', pt: 'Gatilho de um menu'),
      code:
          'AppMenu(\n'
          '  entries: entries,\n'
          '  child: const AppHoverHighlight(\n'
          '    padding: EdgeInsets.symmetric(\n'
          '      horizontal: AppSpacings.s8,\n'
          '      vertical: AppSpacings.s4,\n'
          '    ),\n'
          "    child: AppText('Ações'),\n"
          '  ),\n'
          ')',
      description: LocalizedText(
        en: 'AppMenu already installs click and focus; only the affordance was missing.',
        pt: 'O AppMenu já instala clique e foco; aqui só falta a afordância.',
      ),
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Give it padding: without it the highlight clings to the text and disappears visually.',
    ],
    pt: <String>[
      'Dê padding: sem ele o realce nasce colado no texto e some visualmente.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not use it as a clickable target — it has no gesture, no focus and no semantics.',
      'Do not nest it inside an AppInteraction: the two highlights add up.',
    ],
    pt: <String>[
      'Não use como alvo clicável — ele não tem gesto, foco nem semântica.',
      'Não aninhe dentro de um AppInteraction: os dois realces somam.',
    ],
  ),
  a11y: LocalizedText(
    en: 'It stays out of the semantics tree on purpose: the role, the label and the focus belong to the trigger outside it. Not creating a second focusable node is precisely why it exists.',
    pt:
        'Não entra na árvore semântica de propósito: quem carrega papel, rótulo '
        'e foco é o gatilho por fora. É justamente por não criar um segundo nó '
        'focável que ele existe.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_interaction', 'app_menu', 'app_popover'],
);
