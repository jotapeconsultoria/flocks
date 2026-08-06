import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppScrollEdgeFade]. Registrado em `flocksCatalog`.
const AppComponentMeta appScrollEdgeFadeMeta = AppComponentMeta(
  id: 'app_scroll_edge_fade',
  name: 'AppScrollEdgeFade',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Fades the edge of scrolling content, so the cut against a fixed bar is not a hard line.',
    pt:
        'Esmaece a borda do conteúdo que rola, para o corte contra uma barra '
        'fixa não ser uma linha seca.',
  ),
  description: LocalizedText(
    en: 'The veil runs from the surface color (100%) to transparent (0%), and only on the side where hidden content actually exists: when no scrolling is possible nothing is painted — a permanent gradient would suggest content that is not there, which is the opposite of what the affordance is for. It is passive (IgnorePointer over the veil), so touches still reach the content underneath. A descendant that already handles its own veil announces itself with AppScrollEdgeFadeOwner and switches this one off.',
    pt:
        'O véu vai da cor da superfície (100%) até transparente (0%), e só do '
        'lado em que existe conteúdo escondido: quando não há rolagem possível, '
        'nada é pintado — um degradê permanente sugeriria conteúdo que não '
        'existe, que é o oposto do que a affordance serve para dizer. É passivo '
        '(IgnorePointer sobre o véu), então o toque continua chegando ao '
        'conteúdo por baixo. Um descendente que já cuide do próprio véu se '
        'anuncia com AppScrollEdgeFadeOwner e desliga este.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Scrollable content cut off by a fixed header/footer (sheets, panels).',
      'Horizontal lists that continue past the visible edge.',
    ],
    pt: <String>[
      'Conteúdo rolável cortado por um header/footer fixo (sheets, painéis).',
      'Listas horizontais que continuam além da borda visível.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'An explicit separation between regions → AppDivider.',
      'Content that does not scroll: the veil never appears, but the wrapper is dead weight.',
    ],
    pt: <String>[
      'Separação explícita entre regiões → AppDivider.',
      'Conteúdo que não rola: o véu não nasce, mas o wrapper é peso morto.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'child',
      type: 'Widget',
      isRequired: true,
      description: LocalizedText(
        en: 'The scrollable content.',
        pt: 'O conteúdo rolável.',
      ),
    ),
    PropMeta(
      name: 'color',
      type: 'Color?',
      description: LocalizedText(
        en: 'The color the gradient starts from. Defaults to surfaceContainer (cards, sheets, panels) — pass the real one when the surface differs, or the veil fades to the wrong color.',
        pt:
            'Cor de onde o degradê parte. Default surfaceContainer (cartões, '
            'sheets, painéis) — passe a real quando a superfície for outra, '
            'senão o véu desbota para a cor errada.',
      ),
    ),
    PropMeta(
      name: 'extent',
      type: 'double',
      defaultValue: 'AppSpacings.s24',
      description: LocalizedText(
        en: 'Height (or width) of the veil.',
        pt: 'Altura (ou largura) do véu.',
      ),
    ),
    PropMeta(
      name: 'axis',
      type: 'Axis',
      defaultValue: 'Axis.vertical',
      description: LocalizedText(
        en: 'Axis of the observed scroll.',
        pt: 'Eixo da rolagem observada.',
      ),
    ),
  ],
  states: <String>[
    'no-scroll (nothing painted)',
    'top-hidden',
    'bottom-hidden',
    'both',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Body of a sheet', pt: 'Corpo de uma sheet'),
      code: 'AppScrollEdgeFade(child: SingleChildScrollView(child: body))',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Over the surface, not over the card',
        pt: 'Sobre a surface, não sobre o cartão',
      ),
      code:
          'AppScrollEdgeFade(\n'
          '  color: theme.colorTheme.surface,\n'
          '  child: list,\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Pass `color` when the surface is not surfaceContainer.',
      'Use AppScrollEdgeFadeOwner when something deeper already fades.',
    ],
    pt: <String>[
      'Informe `color` quando a superfície não for surfaceContainer.',
      'Use AppScrollEdgeFadeOwner quando algo mais fundo já esmaece.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not stack two veils on the same scroll — the outer one lands in the wrong place.',
    ],
    pt: <String>[
      'Não empilhe dois véus no mesmo scroll — o de fora cai no lugar errado.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Purely visual and non-interactive (IgnorePointer): it neither enters the semantics tree nor intercepts touches, so keyboard and screen-reader scrolling behave exactly as before.',
    pt:
        'Puramente visual e não interativo (IgnorePointer): não entra na árvore '
        'semântica nem intercepta toque, então a rolagem por teclado e por leitor '
        'de tela continua igual.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_scroll_edge_fade_owner', 'app_divider'],
);

/// Descritor MCP do [AppScrollEdgeFadeOwner]. Registrado em `flocksCatalog`.
const AppComponentMeta appScrollEdgeFadeOwnerMeta = AppComponentMeta(
  id: 'app_scroll_edge_fade_owner',
  name: 'AppScrollEdgeFadeOwner',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Takes over the veil for its own area: switches off the ancestor AppScrollEdgeFade while it is mounted.',
    pt:
        'Assume o véu da própria área: desliga o AppScrollEdgeFade ancestral '
        'enquanto estiver montado.',
  ),
  description: LocalizedText(
    en: 'A component that scrolls internally (tabs, stacked panels) already fades its own content — but the outer AppScrollEdgeFade keeps listening to the SAME scroll and paints its veil at the edge of the whole area, which is not the edge of the content there: in a sheet with tabs, the gradient fell over the tab bar. This marker says "from here inward the veil is mine". With no AppScrollEdgeFade above, it is a pass-through — mounting it on its own is not an error.',
    pt:
        'Um componente que rola por dentro (abas, painéis empilhados) já '
        'esmaece o próprio conteúdo — mas o AppScrollEdgeFade de fora continua '
        'ouvindo a MESMA rolagem e pinta o véu dele na borda da área inteira, '
        'que ali não é a borda do conteúdo: numa sheet com abas, o degradê caía '
        'por cima da barra de abas. Este marcador diz "daqui para dentro o véu é '
        'meu". Sem um AppScrollEdgeFade acima, é um passa-through — montá-lo '
        'solto não é erro.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Inside an AppScrollEdgeFade, when the subtree has a veil of its own.',
      'Components with tabs or stacked panels that scroll independently.',
    ],
    pt: <String>[
      'Dentro de um AppScrollEdgeFade, quando a subárvore tem o próprio véu.',
      'Componentes com abas ou painéis empilhados que rolam por conta própria.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'To hide the veil because you dislike it: if it is in the wrong place, the problem is where the AppScrollEdgeFade was mounted.',
    ],
    pt: <String>[
      'Para esconder o véu por gosto: se ele está no lugar errado, o problema é '
          'onde o AppScrollEdgeFade foi montado.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'child',
      type: 'Widget',
      isRequired: true,
      description: LocalizedText(
        en: 'Content that handles its own fading.',
        pt: 'Conteúdo que cuida do próprio esmaecimento.',
      ),
    ),
  ],
  states: <String>[
    'with-ancestor (switches off)',
    'without-ancestor (pass-through)',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Tabs inside a sheet',
        pt: 'Abas dentro de uma sheet',
      ),
      code:
          'AppScrollEdgeFadeOwner(\n'
          '  child: Column(\n'
          '    children: <Widget>[\n'
          '      tabBar,\n'
          '      Expanded(child: AppScrollEdgeFade(child: content)),\n'
          '    ],\n'
          '  ),\n'
          ')',
      description: LocalizedText(
        en: 'Switches off the outer veil (which would fall over the tab bar) and lets the inner one handle the real content.',
        pt:
            'Desliga o véu de fora (que cairia sobre a barra de abas) e deixa o '
            'de dentro cuidar do conteúdo real.',
      ),
    ),
  ],
  dos: LocalizedList(
    en: <String>['Mount it as high as possible inside the region it covers.'],
    pt: <String>[
      'Monte-o o mais alto possível dentro da região que ele cobre.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not use it as a way to switch the veil off without replacing it.',
    ],
    pt: <String>['Não use como forma de desligar o véu sem substituí-lo.'],
  ),
  a11y: LocalizedText(
    en: 'Renders nothing: it is pure coordination between two veils, so it does not alter the semantics tree.',
    pt:
        'Não renderiza nada: é só coordenação entre dois véus, então não altera '
        'a árvore semântica.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_scroll_edge_fade'],
);
