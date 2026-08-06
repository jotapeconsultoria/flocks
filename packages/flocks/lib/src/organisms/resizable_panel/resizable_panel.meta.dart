import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppResizablePanel]. Registrado em `flocksCatalog`.
const AppComponentMeta appResizablePanelMeta = AppComponentMeta(
  id: 'app_resizable_panel',
  name: 'AppResizablePanel',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Panel whose width is dragged (in px) from one of its edges.',
    pt: 'Painel com largura arrastável (px) por uma das bordas.',
  ),
  description: LocalizedText(
    en: 'The sibling of a lone AppResizableSplit panel: when there are not two panels to divide — the case of AppShell\'s aside slot, which needs full height beside the header — the split does not serve, but the affordance is the same (both share the gutter internally). The measure is absolute (px), not a fraction: it expresses "a floor of 380px and the user chooses upward from there". **maxWidth is required and comes from the caller**: as a non-flexible child of a Row the panel receives an unbounded constraint, so the ceiling cannot be inferred through a LayoutBuilder. The width is re-clamped on every build, accommodating a restored value larger than the current ceiling. **Persistence belongs to the caller** (DI): restore into initialWidth and save from onWidthChanged. Double-tapping the handle resets it.',
    pt:
        'O irmão de um painel só do AppResizableSplit: quando não há dois '
        'painéis para dividir — o caso do slot aside do AppShell, que precisa de '
        'altura total ao lado do header — o split não serve, mas a afordância é '
        'a mesma (as duas compartilham a calha internamente). A medida é '
        'absoluta (px), não fração: expressa "piso de 380px e o usuário escolhe '
        'daí para cima". **maxWidth é obrigatório e vem do chamador**: como '
        'filho não flexível de um Row o painel recebe constraint unbounded, '
        'então não dá para inferir o teto por LayoutBuilder. A largura é '
        'reclampada a cada build, acomodando um valor restaurado maior que o '
        'teto atual. **Persistência é do chamador** (DI): restaure em '
        'initialWidth e salve em onWidthChanged. Duplo-toque na alça reseta.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A side panel whose width the user sets, with no sibling to divide (e.g. the assistant in AppShell\'s aside).',
      'When the rule is an absolute floor in px, not a proportion of the window.',
    ],
    pt: <String>[
      'Painel lateral com largura definida pelo usuário e sem irmão para dividir '
          '(ex.: o assistente no aside do AppShell).',
      'Quando a regra é um piso absoluto em px, não uma proporção da janela.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Two sibling panels sharing the space → AppResizableSplit.',
      'A fixed width with no adjustment → SizedBox.',
    ],
    pt: <String>[
      'Dois painéis irmãos dividindo o espaço → AppResizableSplit.',
      'Largura fixa sem ajuste → SizedBox.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(
      name: 'initialWidth',
      type: 'double',
      isRequired: true,
      description: LocalizedText(
        en: 'Initial width, and the double-tap target (reset).',
        pt: 'Largura inicial e alvo do duplo-toque (reset).',
      ),
    ),
    PropMeta(
      name: 'maxWidth',
      type: 'double',
      isRequired: true,
      description: LocalizedText(
        en: 'Ceiling — compute it at the source (e.g. MediaQuery); it cannot be inferred.',
        pt: 'Teto — calcule na origem (ex.: MediaQuery), não é inferível.',
      ),
    ),
    PropMeta(name: 'minWidth', type: 'double', defaultValue: '0'),
    PropMeta(
      name: 'edge',
      type: 'AppResizeEdge',
      defaultValue: 'AppResizeEdge.start',
      description: LocalizedText(
        en: 'Edge the handle sits on: start = left in LTR.',
        pt: 'Borda da alça: start = esquerda no LTR.',
      ),
    ),
    PropMeta(
      name: 'onWidthChanged',
      type: 'ValueChanged<double>?',
      description: LocalizedText(
        en: 'Save the value here to persist it (persistence is yours).',
        pt: 'Salve o valor aqui para persistir (a persistência é sua).',
      ),
    ),
    PropMeta(
      name: 'thickness',
      type: 'double',
      defaultValue: 'AppSpacings.s16',
    ),
    PropMeta(name: 'tooltip', type: 'String?', defaultValue: "'Redimensionar'"),
  ],
  // Alça na borda inicial (painel ancorado à direita) ou final (à esquerda).
  variants: <String>['edge.start', 'edge.end'],
  states: <String>['idle', 'hovered', 'dragging'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Assistant in the shell\'s aside',
        pt: 'Assistente no aside do shell',
      ),
      code:
          'AppResizablePanel(initialWidth: restored ?? 380, minWidth: 380, '
          'maxWidth: MediaQuery.sizeOf(context).width / 2, '
          'onWidthChanged: (w) => storage.write(key, w), child: assistant)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Restore the width in the caller and pass it in initialWidth.',
      'Compute maxWidth from the window — the panel cannot infer it.',
      'Give it a bounded height: the content is stretched on the cross axis.',
    ],
    pt: <String>[
      'Restaure a largura no chamador e passe em initialWidth.',
      'Calcule maxWidth a partir da janela — o painel não consegue inferir.',
      'Dê altura limitada: o conteúdo é esticado no eixo cruzado.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not expect the component to persist anything by itself (that is the app\'s job).',
      'Do not use it to divide two panels — that is AppResizableSplit.',
    ],
    pt: <String>[
      'Não espere que o componente persista sozinho (é do app).',
      'Não use para dividir dois painéis — isso é AppResizableSplit.',
    ],
  ),
  a11y: LocalizedText(
    en: 'The gutter has a tooltip (AppTooltip), a resizeColumn cursor and its own drag target; the handle\'s color comes from the theme (AA in light and dark).',
    pt:
        'A calha tem tooltip (AppTooltip), cursor resizeColumn e alvo de arraste '
        'próprio; a cor da alça vem do tema (AA em claro/escuro).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_resizable_split', 'app_shell', 'app_assistant_panel'],
);
