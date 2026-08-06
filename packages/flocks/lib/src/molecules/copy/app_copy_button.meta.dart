import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppCopyButton]. Registrado em `flocksCatalog`.
const AppComponentMeta appCopyButtonMeta = AppComponentMeta(
  id: 'app_copy_button',
  name: 'AppCopyButton',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Copy button with animated confirmation in the button itself (icon and tooltip).',
    pt:
        'Botão de copiar com confirmação animada no próprio botão (ícone e '
        'tooltip).',
  ),
  description: LocalizedText(
    en: 'Writes a value to the clipboard and confirms it under the cursor: the icon becomes a check in the success color and the tooltip changes from "Copy" to "Copied!", both with a smooth transition, returning to rest after 1.6 s. The tick is DRAWN (AppCheckmarkPainter), not downloaded: a network SVG that fails never retries, and the failure would become a permanent visual error at the very moment of confirmation.',
    pt:
        'Escreve um valor na área de transferência e confirma sob o cursor: o '
        'ícone vira um check na cor de sucesso e a tooltip troca de "Copiar" '
        'para "Copiado!", as duas com transição suave, voltando ao repouso após '
        '1,6 s. O tique é DESENHADO (AppCheckmarkPainter), não baixado: um SVG '
        'de rede que falha nunca retenta, e a falha viraria um erro visual '
        'permanente bem no momento da confirmação.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Copying an identifier next to its value (ID, tax number, integration code).',
      'Screens with several copy buttons, where snackbars would pile up.',
    ],
    pt: <String>[
      'Copiar um identificador ao lado do valor dele (ID, CNPJ, código de integração).',
      'Telas com vários botões de copiar, onde snackbars se empilhariam.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Copy as a menu item or a labelled action → AppMenuItem/AppButton.',
      'A trigger that is not an icon (a chip with text) → AppInteraction + Clipboard.',
    ],
    pt: <String>[
      'Copiar como item de menu ou ação com rótulo → AppMenuItem/AppButton.',
      'Trigger que não é um ícone (chip com texto) → AppInteraction + Clipboard.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'value',
      type: 'String',
      isRequired: true,
      description: LocalizedText(
        en: 'Text written to the clipboard.',
        pt: 'Texto escrito na área de transferência.',
      ),
    ),
    PropMeta(
      name: 'color',
      type: 'Color?',
      description: LocalizedText(
        en: 'Icon color at rest (null = onSurface).',
        pt: 'Cor do ícone em repouso (null = onSurface).',
      ),
    ),
    PropMeta(
      name: 'copiedDuration',
      type: 'Duration',
      defaultValue: 'kAppCopiedFeedback (1600ms)',
      description: LocalizedText(
        en: 'How long the copied state lasts.',
        pt: 'Quanto tempo o estado copiado dura.',
      ),
    ),
    PropMeta(name: 'copiedTooltip', type: 'String', defaultValue: "'Copiado!'"),
    PropMeta(name: 'copyTooltip', type: 'String', defaultValue: "'Copiar'"),
    PropMeta(
      name: 'enabled',
      type: 'bool',
      defaultValue: 'true',
      description: LocalizedText(
        en: 'When false, it does not react and dims the icon.',
        pt: 'Quando false, não reage e esmaece o ícone.',
      ),
    ),
    PropMeta(
      name: 'iconSize',
      type: 'AppIconSize',
      defaultValue: 'AppIconSize.s',
      description: LocalizedText(
        en: 'Icon size; together with the padding it sets the target\'s side.',
        pt: 'Tamanho do ícone; define o lado do alvo com o padding.',
      ),
      enumValues: <String>['s', 'm', 'l', 'xl'],
    ),
    PropMeta(
      name: 'onCopied',
      type: 'VoidCallback?',
      description: LocalizedText(
        en: 'Fired after writing to the clipboard.',
        pt: 'Disparado depois de escrever na área de transferência.',
      ),
    ),
    PropMeta(
      name: 'onCopyFailed',
      type: 'ValueChanged<Object>?',
      description: LocalizedText(
        en: 'Fired when the write fails; the button does not confirm in that case.',
        pt: 'Disparado quando a escrita falha; o botão não confirma nesse caso.',
      ),
    ),
    PropMeta(
      name: 'padding',
      type: 'EdgeInsetsGeometry',
      defaultValue: 'EdgeInsets.all(AppSpacings.s4)',
      description: LocalizedText(
        en: 'Symmetric inner gap between the highlight and the icon.',
        pt: 'Folga interna simétrica entre o realce e o ícone.',
      ),
    ),
    PropMeta(
      name: 'tooltipPosition',
      type: 'AppTooltipPosition',
      defaultValue: 'AppTooltipPosition.top',
      enumValues: <String>['top', 'bottom', 'left', 'right'],
    ),
  ],
  variants: <String>['s', 'm', 'l', 'xl'],
  states: <String>['hovered', 'focused', 'pressed', 'disabled', 'copied'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Copyable identifier',
        pt: 'Identificador copiável',
      ),
      code: 'AppCopyButton(value: account.integrationId)',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Its own label and telemetry',
        pt: 'Rótulo próprio e telemetria',
      ),
      code:
          "AppCopyButton(value: endpoint.path, copyTooltip: 'Copiar path', "
          "onCopied: () => analytics.track('path_copied'))",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Keep the spacing to its neighbours outside the button (the highlight wraps the whole child).',
      'Use onCopied to instrument or react to the copy.',
    ],
    pt: <String>[
      'Deixe o espaçamento com os vizinhos fora do botão (o realce envolve o child inteiro).',
      'Use onCopied para instrumentar ou reagir à cópia.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not stack a snackbar on top — the inline feedback is already the confirmation.',
      'Do not swap AppCheckmarkPainter for AppIconToken.check: that puts the network back in the exact moment of confirmation, and an SvgPicture that fails never tries again.',
    ],
    pt: <String>[
      'Não empilhe um snackbar por cima — o feedback inline já é a confirmação.',
      'Não troque o AppCheckmarkPainter por AppIconToken.check: volta a depender da '
          'rede no exato momento da confirmação, e um SvgPicture que falha nunca '
          'tenta de novo.',
    ],
  ),
  a11y: LocalizedText(
    en: 'A button role (AppSemantics.button) with the semanticLabel following the tooltip, so the screen reader announces "Copied!" after the action. The inner icons are decorative. Enter/Space activate it when focused; under reduce-motion the swap is instant.',
    pt:
        'Role de botão (AppSemantics.button) com semanticLabel acompanhando a '
        'tooltip, então o leitor de tela anuncia "Copiado!" após a ação. Os '
        'ícones internos são decorativos. Enter/Space acionam quando focado; sob '
        'reduce-motion a troca é instantânea.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_interaction', 'app_tooltip', 'app_code_block'],
);
