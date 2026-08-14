import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppDialog]. Registrado em `flocksCatalog`.
const AppComponentMeta appDialogMeta = AppComponentMeta(
  id: 'app_dialog',
  name: 'AppDialog',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'The central card of a modal dialog (the floating surface).',
    pt: 'Card central de um dialog modal (a superfície flutuante).',
  ),
  description: LocalizedText(
    en: 'A dialog\'s surface: a top bar, scrollable content and an optional footer. Show it as a modal (barrier + transition + focus) through the `showAppDialog` helper. For the most repeated dialog of all — a yes/no confirmation — use the `showAppConfirm` helper: it assembles body and footer and returns a `Future<bool>` that is NEVER null (barrier, "X" and Esc all resolve to `false`). The bar is the same one the sheets use — an optional title and a close button (on and to the right by default) — but with the title aligned to the START, and it sits outside the scroll, like the footer; with no title and no button it does not exist. Because it floats, the container follows the AppStyle axis with its own `elevated` default (a shadow), overridable per instance; the shape follows the global radius axis. Colors 100% from the theme → AA contrast.',
    pt:
        'A superfície de um dialog: uma barra de topo, conteúdo rolável e um '
        'rodapé opcional. Exiba-o como modal (barrier + transição + foco) via o '
        'helper `showAppDialog`. Para o dialog mais repetido de todos — a '
        'confirmação sim/não — use o helper `showAppConfirm`: ele monta corpo e '
        'rodapé e devolve um `Future<bool>` que NUNCA é nulo (barrier, "X" e Esc '
        'resolvem para `false`). A barra é a mesma das sheets — título opcional e '
        'botão de fechar (ligado e à direita por padrão) — mas com o título '
        'alinhado ao INÍCIO, e fica fora da rolagem, como o rodapé; sem título e '
        'sem botão ela não existe. Por ser flutuante, o container segue o eixo '
        'AppStyle com default próprio `elevated` (sombra), sobrescrevível por '
        'instância; a forma segue o eixo de raio global. Cores 100% do tema → '
        'contraste AA.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Confirming an action (delete, leave without saving) — blocking the flow.',
      'Showing a notice or a result that requires acknowledgement before moving on.',
    ],
    pt: <String>[
      'Confirmar uma ação (excluir, sair sem salvar) — bloqueando o fluxo.',
      'Mostrar um aviso/resultado que exige reconhecimento antes de seguir.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Transient, non-blocking feedback → AppAlert through showAppOverlay.',
      'A choice anchored to a trigger (a short list) → AppMenu/AppPopover.',
      'A long form on mobile rising from the bottom → AppBottomSheet.',
    ],
    pt: <String>[
      'Feedback transitório e não-bloqueante → AppAlert via showAppOverlay.',
      'Escolha ancorada a um gatilho (lista curta) → AppMenu/AppPopover.',
      'Formulário longo no mobile subindo de baixo → AppBottomSheet.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(
      name: 'footer',
      type: 'Widget?',
      description: LocalizedText(
        en: 'Action footer (e.g. AppButtonsFooter).',
        pt: 'Rodapé de ações (ex.: AppButtonsFooter).',
      ),
    ),
    PropMeta(
      name: 'title',
      type: 'Widget?',
      description: LocalizedText(
        en: 'Title in the top bar, aligned to the start. `null` leaves the bar with only the close button.',
        pt:
            'Título na barra de topo, alinhado ao início. `null` deixa a barra '
            'só com o botão de fechar.',
      ),
    ),
    PropMeta(
      name: 'showCloseButton',
      type: 'bool',
      defaultValue: 'true',
      description: LocalizedText(
        en: 'Circular close chip in the top bar. Turn it off in a `barrierDismissible: false` dialog only if the footer already offers a way out.',
        pt:
            'Chip circular de fechar na barra de topo. Desligue num dialog '
            '`barrierDismissible: false` só se o rodapé já oferecer uma saída.',
      ),
    ),
    PropMeta(
      name: 'closeSide',
      type: 'AppSheetCloseSide',
      defaultValue: 'AppSheetCloseSide.end',
      enumValues: <String>['start', 'end'],
      description: LocalizedText(
        en: 'Side of the close button. `end` = right in LTR.',
        pt: 'Lado do botão de fechar. `end` = direita em LTR.',
      ),
    ),
    PropMeta(
      name: 'onCloseButton',
      type: 'VoidCallback?',
      description: LocalizedText(
        en: 'The close button\'s action. `null` pops the route.',
        pt: 'Ação do botão de fechar. `null` dá pop na rota.',
      ),
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
    PropMeta(name: 'radius', type: 'BorderRadius?'),
  ],
  variants: <String>['filled', 'outlined', 'elevated'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Confirmation', pt: 'Confirmação'),
      code:
          'showAppDialog(context: context, '
          "title: const AppText('Excluir?'), "
          "child: const AppDialogContent(message: '...', "
          "illustration: 'assets/delete.svg'), "
          'footer: buttonsFooter)',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Yes/no confirmation (never null)',
        pt: 'Confirmação sim/não (nunca nula)',
      ),
      code:
          'if (await showAppConfirm(context: context, '
          "title: 'Excluir empresa', "
          "message: 'Não dá para desfazer.', "
          "confirmLabel: 'Excluir', destructive: true)) { await remove(); }",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use an AppButtonsFooter with a primary + a secondary action in the footer.',
      'Keep the content short; the body scrolls if it exceeds the height.',
      'Put the title in the bar\'s `title`, not in the body — in the body it scrolls away.',
    ],
    pt: <String>[
      'Use um AppButtonsFooter com ação primária + secundária no rodapé.',
      'Mantenha o conteúdo curto; o corpo rola se exceder a altura.',
      'Ponha o título no `title` da barra, não no corpo — no corpo ele rola.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not use it for passing feedback (that is AppAlert/overlay).',
      'Do not switch showCloseButton off in a barrierDismissible: false dialog without a way out in the footer — the user gets trapped.',
    ],
    pt: <String>[
      'Não use para feedback passageiro (isso é AppAlert/overlay).',
      'Não desligue o showCloseButton num dialog barrierDismissible: false sem '
          'uma saída no rodapé — o usuário fica preso.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Shown through the Navigator (a PopupRoute): the focus scope and returning focus to the trigger are managed by the route; the barrier is labelled "Close". The close button is the dialog\'s first focusable node and carries the same label; the bar\'s title is announced as a heading. In `showAppConfirm` the two footer buttons are named by their own labels, and every way of dismissing (barrier, "X", Esc) resolves the future to `false` — the caller never branches on null. The theme\'s colors (surfaceContainer/outline) pass AA in light and dark.',
    pt:
        'Exibido via Navigator (PopupRoute): escopo de foco e devolução de foco '
        'ao gatilho são geridos pela rota; o barrier tem rótulo "Fechar". O botão '
        'de fechar é o primeiro nó focável do dialog e tem o mesmo rótulo; o '
        'título da barra é anunciado como cabeçalho. No `showAppConfirm` os dois '
        'botões do rodapé são nomeados pelos próprios rótulos, e toda forma de '
        'dispensar (barrier, "X", Esc) resolve o future para `false` — o '
        'chamador nunca ramifica em nulo. Cores do tema '
        '(surfaceContainer/outline) passam AA em claro/escuro.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_dialog_content', 'app_bottom_sheet', 'app_alert'],
);

/// Descritor MCP do [AppDialogContent]. Registrado em `flocksCatalog`.
const AppComponentMeta appDialogContentMeta = AppComponentMeta(
  id: 'app_dialog_content',
  name: 'AppDialogContent',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Standard dialog body: title, message and illustration.',
    pt: 'Corpo padrão de um dialog: título, mensagem e ilustração.',
  ),
  description: LocalizedText(
    en: 'The most common body of an AppDialog (confirm/notify): a prominent title (optional), a message and an optional central illustration — with no `illustration` the art block leaves the layout entirely, which is the plain confirmation body. When the dialog already carries the title in its top bar, leave this `title` null so it is not repeated. The top breathing room shrinks on its own once the surface has drawn the bar. Colors from the theme; the illustration\'s accent color uses `secondary` when none is given.',
    pt:
        'O corpo mais comum de um AppDialog (confirmar/avisar): título em '
        'destaque (opcional), mensagem e uma ilustração central opcional — sem '
        '`illustration` o bloco da arte sai inteiro do layout, que é o corpo de '
        'confirmação puro. Quando o dialog '
        'já leva o título na barra de topo, deixe o `title` daqui nulo para não '
        'repetir. O respiro do topo encolhe sozinho quando a superfície desenhou '
        'a barra. Cores do tema; a cor de destaque da ilustração usa `secondary` '
        'quando não informada.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Filling a confirmation/notice AppDialog with the standard layout.',
    ],
    pt: <String>[
      'Preencher um AppDialog de confirmação/aviso com o layout padrão.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Custom content (a form, a list) → pass your own child.'],
    pt: <String>[
      'Conteúdo customizado (formulário, lista) → passe seu próprio child.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'title',
      type: 'String?',
      description: LocalizedText(
        en: 'Null when the title is already in the dialog\'s top bar.',
        pt: 'Nulo quando o título já está na barra de topo do dialog.',
      ),
    ),
    PropMeta(name: 'message', type: 'String', isRequired: true),
    PropMeta(
      name: 'illustration',
      type: 'String?',
      description: LocalizedText(
        en: 'SVG path. `null` draws no illustration at all: the art block and its two 64px breathers leave the layout, and the body closes 32px below the message. That is the plain confirmation dialog.',
        pt:
            'Caminho do SVG. `null` não desenha ilustração nenhuma: o bloco da '
            'arte e os dois respiros de 64 saem do layout, e o corpo fecha 32 '
            'abaixo da mensagem. É o diálogo de confirmação puro.',
      ),
    ),
    PropMeta(
      name: 'accentRole',
      type: 'ColorSwatch<int>?',
      description: LocalizedText(
        en: 'The piece\'s color role — pass the SAME one as the action button (e.g. theme.colorTheme.danger). The illustration is tinted with that role\'s accent, the very value the button paints. Defaults to secondary.',
        pt:
            'Papel de cor da peça — passe o MESMO do botão de ação '
            '(ex.: theme.colorTheme.danger). A ilustração é tingida com o acento '
            'desse papel, o mesmo valor que o botão pinta. Default = secondary.',
      ),
    ),
  ],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Success', pt: 'Sucesso'),
      code:
          "AppDialogContent(title: 'Tudo certo!', "
          "message: 'Alterações salvas.', illustration: 'assets/success.svg')",
    ),
  ],
  dos: LocalizedList(
    en: <String>['A short title (1 line) and a to-the-point message.'],
    pt: <String>['Título curto (1 linha) e mensagem objetiva.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not stack multiple illustrations.'],
    pt: <String>['Não empilhe múltiplas ilustrações.'],
  ),
  a11y: LocalizedText(
    en: 'Title and message forward semanticLabel. Title in onSurface and message in neutral s700 pass AA against the dialog\'s surface.',
    pt:
        'Título e mensagem repassam semanticLabel. Título onSurface e mensagem '
        'neutro s700 passam AA sobre a superfície do dialog.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_dialog'],
);
