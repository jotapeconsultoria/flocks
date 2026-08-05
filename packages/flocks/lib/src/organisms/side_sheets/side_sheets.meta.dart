import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSideSheet]. Registrado em `flocksCatalog`.
const AppComponentMeta appSideSheetMeta = AppComponentMeta(
  id: 'app_side_sheet',
  name: 'AppSideSheet',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.7.0',
  summary: LocalizedText(
    en: 'Floating side panel (the bottom sheet\'s horizontal sibling), responsive.',
    pt: 'Painel lateral flutuante (irmão horizontal do bottom sheet), responsivo.',
  ),
  description: LocalizedText(
    en: 'A detached card that slides in from the `side` edge (start/end, end = right by default) and grows toward the center. Show it through `showAppSideSheet`; with `draggable: true` it resizes by dragging the inner edge with responsive snaps (screens > 1024: 40% → 70% → full; <= 1024: 70% → full) and morphs to edge-to-edge at full (leaving a peek on the opposite edge). A top bar with an optional title and a close button (a chip; by default in the inner corner, through `closeSide`). `alwaysClose` closes it when shrinking from full. It follows the AppStyle (its own `elevated` default), radius and motion axes; colors 100% from the theme.',
    pt:
        'Um card destacado que desliza da borda `side` (start/end, default end = '
        'direita) e cresce em direção ao centro. Exiba via `showAppSideSheet`; com '
        '`draggable: true` redimensiona por arraste da borda interna com snaps '
        'responsivos (telas > 1024: 40% → 70% → full; <= 1024: 70% → full) e morph '
        'para edge-to-edge no full (deixando um peek na borda oposta). Barra de topo '
        'com título opcional e botão de fechar (chip; default no canto interno via '
        '`closeSide`). `alwaysClose` fecha ao encolher da full. Segue os eixos '
        'AppStyle (default próprio `elevated`) / raio / motion; cores 100% do tema.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A detail or an edit beside the main content (desktop/tablet: a map + a panel).',
      'A contextual form or list that benefits from resizing (40/70/full).',
    ],
    pt: <String>[
      'Detalhe/edição ao lado do conteúdo principal (desktop/tablet: mapa + painel).',
      'Formulário ou lista contextual que se beneficia de redimensionar (40/70/full).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A panel that rises from the bottom on mobile → AppBottomSheet.',
      'A blocking central confirmation → AppDialog.',
    ],
    pt: <String>[
      'Painel que sobe da base no mobile → AppBottomSheet.',
      'Confirmação central bloqueante → AppDialog.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(
      name: 'side',
      type: 'AppSheetSide',
      defaultValue: 'AppSheetSide.end',
      enumValues: <String>['start', 'end'],
    ),
    PropMeta(name: 'title', type: 'Widget?'),
    PropMeta(name: 'footer', type: 'Widget?'),
    PropMeta(name: 'draggable', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'alwaysClose', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'showHandle', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'showCloseButton', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'onCloseButton', type: 'VoidCallback?'),
    PropMeta(name: 'onClose', type: 'VoidCallback?'),
    PropMeta(
      name: 'closeSide',
      type: 'AppSheetCloseSide?',
      description: LocalizedText(
        en: 'null → the inner corner, according to side.',
        pt: 'null → canto interno conforme side.',
      ),
      enumValues: <String>['start', 'end'],
    ),
    PropMeta(name: 'mediumFraction', type: 'double', defaultValue: '0.40'),
    PropMeta(name: 'largeFraction', type: 'double', defaultValue: '0.70'),
    PropMeta(
      name: 'initialSnap',
      type: 'AppSideSheetSnap',
      defaultValue: 'AppSideSheetSnap.rest',
      description: LocalizedText(
        en: 'The snap the sheet opens at. `full` for content that needs the whole width (two columns, wide tables).',
        pt:
            'Snap em que a sheet abre. `full` para conteúdo que precisa da '
            'largura toda (duas colunas, tabelas largas).',
      ),
      enumValues: <String>['rest', 'full'],
    ),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      defaultValue: 'AppStyle.elevated',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(
      name: 'radiusMode',
      type: 'AppRadiusMode?',
      enumValues: <String>['reto', 'redondo', 'circular', 'padrao'],
    ),
  ],
  variants: <String>['filled', 'outlined', 'elevated'],
  states: <String>['rest', 'full'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Draggable detail on the right',
        pt: 'Detalhe arrastável à direita',
      ),
      code:
          'showAppSideSheet<void>(\n'
          '  context: context,\n'
          '  draggable: true,\n'
          '  showHandle: true,\n'
          "  title: 'Veículo',\n"
          '  child: details,\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use draggable + showHandle to resize it (40/70/full).',
      'Use side to choose the edge (start/end).',
    ],
    pt: <String>[
      'Use draggable + showHandle para redimensionar (40/70/full).',
      'Use side para escolher a borda (start/end).',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not use it on mobile for a panel that rises (that is AppBottomSheet).',
    ],
    pt: <String>[
      'Não use no mobile para painel que sobe (isso é AppBottomSheet).',
    ],
  ),
  a11y: LocalizedText(
    en: 'Shown through the Navigator (a PopupRoute): focus and its return are managed by the route; the barrier and the close button are labelled "Close". The theme\'s colors pass AA.',
    pt:
        'Exibido via Navigator (PopupRoute): foco e devolução geridos pela rota; '
        'barrier e botão de fechar com rótulo "Fechar". Cores do tema passam AA.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_bottom_sheet', 'app_dialog', 'app_resizable_split'],
);

/// Descritor MCP do [AppSideSheetPage]. Registrado em `flocksCatalog`.
const AppComponentMeta appSideSheetPageMeta = AppComponentMeta(
  id: 'app_side_sheet_page',
  name: 'AppSideSheetPage',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@0.8.0',
  summary: LocalizedText(
    en: 'The same surface as AppSideSheet, shown by a PERSISTENT route (SideSheetPageRoute) instead of an ephemeral one.',
    pt:
        'A mesma superfície do AppSideSheet, exibida por uma rota PERSISTENTE '
        '(SideSheetPageRoute) em vez de uma efêmera.',
  ),
  description: LocalizedText(
    en: 'Visually it is IDENTICAL to AppSideSheet — same surface, same snaps (40/70/full), same chrome, same engine. What changes is the route\'s class. That matters when the panel is a first-class "page": heavy, with state of its own, that has to survive and still be able to host an ephemeral sheet ON TOP (the Vehicle Record is the case that motivated it). An ephemeral route does not stack that way: the second sheet would close the first. Choose by the nature of the content, not by the look.',
    pt:
        'Visualmente é IDÊNTICO ao AppSideSheet — mesma superfície, mesmos snaps '
        '(40/70/full), mesmo chrome, mesmo motor. O que muda é a classe da rota. '
        'Isso importa quando o painel é uma "página" de primeira classe: pesada, '
        'com estado próprio, que precisa sobreviver e ainda poder hospedar um '
        'sheet efêmero POR CIMA (a Ficha do Veículo é o caso que motivou). Uma '
        'rota efêmera não empilha assim: o segundo sheet fecharia o primeiro. '
        'Escolha pela natureza do conteúdo, não pela aparência.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A destination panel with state of its own, opened by URL or route.',
      'A panel that has to host another sheet on top without closing.',
    ],
    pt: <String>[
      'Painel-destino com estado próprio, aberto por URL/rota.',
      'Painel que precisa hospedar outro sheet por cima sem se fechar.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'An aside that closes right away → AppSideSheet (an ephemeral route).',
      'A panel that rises from the bottom on mobile → AppBottomSheetPage.',
    ],
    pt: <String>[
      'Aparte que se fecha logo → AppSideSheet (rota efêmera).',
      'Painel que sobe da base no mobile → AppBottomSheetPage.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(
      name: 'side',
      type: 'AppSheetSide',
      defaultValue: 'AppSheetSide.end',
      enumValues: <String>['start', 'end'],
    ),
    PropMeta(name: 'title', type: 'String?'),
    PropMeta(
      name: 'titleWidget',
      type: 'Widget?',
      description: LocalizedText(
        en: 'Escape hatch for a title that does not fit in a String.',
        pt: 'Escape hatch para o título que não cabe numa String.',
      ),
    ),
    PropMeta(name: 'footer', type: 'Widget?'),
    PropMeta(name: 'showHandle', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'showCloseButton', type: 'bool', defaultValue: 'true'),
    PropMeta(
      name: 'closeSide',
      type: 'AppSheetCloseSide?',
      description: LocalizedText(
        en: 'null resolves to the INNER corner.',
        pt: 'null resolve para o canto INTERNO.',
      ),
      enumValues: <String>['start', 'end'],
    ),
    PropMeta(name: 'onCloseButton', type: 'VoidCallback?'),
    PropMeta(name: 'style', type: 'AppStyle?'),
    PropMeta(name: 'glass', type: 'bool?'),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
  ],
  states: <String>['rest', 'resizing', 'with-ephemeral-sheet-above'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Record opened as a page',
        pt: 'Ficha aberta como página',
      ),
      code:
          'showAppSideSheetPage<void>(\n'
          '  context: context,\n'
          "  title: 'Ficha do veículo',\n"
          '  draggable: true,\n'
          '  child: VehicleProfile(id: id),\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use it when the panel has to survive another sheet opening on top of it.',
    ],
    pt: <String>[
      'Use quando o painel precisa sobreviver a outro sheet aberto por cima.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not choose by appearance: it is the same as AppSideSheet\'s.',
    ],
    pt: <String>['Não escolha pela aparência: ela é a mesma do AppSideSheet.'],
  ),
  a11y: LocalizedText(
    en: 'A persistent route: focus and its return are managed by the Navigator, and the panel stays in the tree when an ephemeral sheet opens over it — the screen reader returns to where it was when that sheet closes. The close button is labelled "Close".',
    pt:
        'Rota persistente: foco e devolução são geridos pelo Navigator, e o '
        'painel continua na árvore quando um sheet efêmero abre por cima — o '
        'leitor de tela volta para onde estava ao fechá-lo. Botão de fechar '
        'rotulado "Fechar".',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_side_sheet', 'app_bottom_sheet_page'],
);
