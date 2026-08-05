import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSideInset]. Registrado em `flocksCatalog`.
const AppComponentMeta appSideInsetMeta = AppComponentMeta(
  id: 'app_side_inset',
  name: 'AppSideInset',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  since: 'flocks@0.8.0',
  summary: LocalizedText(
    en: 'Applies — and consumes — the side inset the host surface published in MediaQuery.padding.',
    pt:
        'Aplica — e consome — o respiro lateral que a superfície hospedeira '
        'publicou em MediaQuery.padding.',
  ),
  description: LocalizedText(
    en: 'A side sheet reserves a lateral strip (the drag gutter lives there). It PUBLISHES that reservation in MediaQuery.padding instead of insetting the content with a Padding, because insetting the whole strip would also inset the VIEWPORT of any scroll inside it — and the scrollbar, which lives at the viewport\'s edge, ended up floating far from the sheet\'s side. Published, whatever scrolls adds the inset to its own scrollable padding: the content breathes, the viewport reaches the edge, the scrollbar sits against it. This widget is the shortcut for content that does NOT scroll — it applies the same inset as ordinary padding and REMOVES it from the MediaQuery, so nothing below applies it twice.',
    pt:
        'O side sheet reserva uma faixa lateral (a gutter de arraste mora ali). '
        'Ele PUBLICA essa reserva em MediaQuery.padding em vez de recuar o '
        'conteúdo com um Padding, porque recuar a faixa inteira recuaria junto o '
        'VIEWPORT de qualquer rolagem lá dentro — e a barra de rolagem, que mora '
        'na borda do viewport, aparecia flutuando longe da lateral da sheet. '
        'Publicado, quem rola soma o recuo ao padding do próprio scrollable: o '
        'conteúdo respira, o viewport vai até a borda, a barra encosta. Este '
        'widget é o atalho para o conteúdo que NÃO rola — aplica o mesmo recuo '
        'como padding comum e o REMOVE do MediaQuery, para ninguém abaixo '
        'aplicar de novo.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Non-scrolling content inside a side sheet (header, footer, short form).',
    ],
    pt: <String>[
      'Conteúdo não-rolável dentro de um side sheet (cabeçalho, rodapé, form curto).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Content that SCROLLS → add MediaQuery.paddingOf(context) to the scrollable\'s padding; otherwise the scrollbar detaches from the side.',
      'Fixed layout breathing room → a Padding with an AppSpacings token.',
    ],
    pt: <String>[
      'Conteúdo que ROLA → some MediaQuery.paddingOf(context) ao padding do '
          'scrollable; senão a barra de rolagem descola da lateral.',
      'Respiro fixo de layout → Padding com token de AppSpacings.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'child',
      type: 'Widget',
      isRequired: true,
      description: LocalizedText(
        en: 'Non-scrollable content that takes the side inset.',
        pt: 'Conteúdo não-rolável que recebe o recuo lateral.',
      ),
    ),
  ],
  states: <String>[
    'no-published-inset (pass-through)',
    'with-inset (applies and consumes)',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Footer of a side sheet',
        pt: 'Rodapé de um side sheet',
      ),
      code: 'AppSideInset(child: AppButtonsFooter(primary: saveButton))',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'What to do when the content scrolls',
        pt: 'O que fazer quando o conteúdo rola',
      ),
      code:
          '// NÃO use AppSideInset aqui:\n'
          'ListView(\n'
          '  padding: EdgeInsets.symmetric(\n'
          '    horizontal: MediaQuery.paddingOf(context).left,\n'
          '  ),\n'
          '  children: rows,\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use it on content that does not scroll; let the scrollable add the padding itself.',
    ],
    pt: <String>[
      'Use em conteúdo que não rola; deixe o scrollable somar o padding sozinho.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not nest two: the outer one consumes the inset and the inner one becomes a no-op — silent, but a sign the layout is duplicating a responsibility.',
    ],
    pt: <String>[
      'Não aninhe dois: o de fora consome o recuo e o de dentro vira no-op — '
          'silencioso, mas sinal de que o layout está duplicando responsabilidade.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Does not change the semantics tree: it is only padding. Because it consumes the MediaQuery value, it avoids the doubled inset that would push touch targets outside the comfortable area.',
    pt:
        'Não muda a árvore semântica: é só padding. Como consome o valor do '
        'MediaQuery, evita o recuo dobrado que empurraria alvos de toque para '
        'fora da área confortável.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_side_sheet', 'app_scroll_edge_fade'],
);
