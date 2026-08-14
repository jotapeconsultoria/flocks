import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppSlider`. Registrado em `flocksCatalog`.
const AppComponentMeta appSliderMeta = AppComponentMeta(
  id: 'app_slider',
  name: 'AppSlider',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Horizontal slider for a value in a range, continuous or stepped.',
    pt: 'Slider horizontal para um valor num intervalo, contínuo ou por passo.',
  ),
  description: LocalizedText(
    en: 'The package\'s first public slider. Controlled (value + onChanged, state in the caller); onChanged: null disables while KEEPING the semantics node. step quantizes in domain units (1.0 = integers) instead of Material\'s divisions; formatValue is a single formatting source for the inline label (showValue) and the screen-reader values. The widget is at least 48px tall (born meeting tap-target guidelines) while the track stays thin; the thumb grows while dragging through the motion axis and the focus ring has no duration, surviving reduce-motion. Left/Right arrows step and mirror under RTL (Up/Down and Home/End do not), Home/End jump to the EXACT extremes, outside the quantization; onChangeEnd commits on release.',
    pt:
        'O primeiro slider público do pacote. Controlado (value + onChanged, '
        'estado no chamador); onChanged: null desabilita MANTENDO o nó '
        'semântico. step quantiza em unidades do domínio (1.0 = inteiros) em '
        'vez do divisions do Material; formatValue é fonte única de formatação '
        'para o rótulo inline (showValue) e para os valores do leitor de tela. '
        'O widget tem no mínimo 48px de altura (nasce cumprindo as diretrizes '
        'de alvo de toque) com o trilho fino; o polegar cresce no arraste pelo '
        'eixo de motion e o anel de foco não tem duração — sobrevive ao '
        'reduce-motion. Setas andam por passo (espelhadas em RTL), Home/End '
        'saltam aos extremos; onChangeEnd commita no soltar.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A numeric setting in a form (a rate, a percentage, a threshold).',
      'Continuous or stepped values where dragging beats typing.',
    ],
    pt: <String>[
      'Um ajuste numérico num formulário (ritmo, porcentagem, limite).',
      'Valores contínuos ou por passo onde arrastar ganha de digitar.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A handful of discrete labelled options → AppSegmentedButton.',
      'Exact numeric entry → AppInput with a numeric keyboard.',
    ],
    pt: <String>[
      'Poucas opções discretas com rótulo → AppSegmentedButton.',
      'Entrada numérica exata → AppInput com teclado numérico.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'value', type: 'double', isRequired: true),
    PropMeta(
      name: 'onChanged',
      type: 'ValueChanged<double>?',
      isRequired: true,
      description: LocalizedText(
        en: 'Continuous change during the drag. `null` disables the control.',
        pt: 'Mudança contínua durante o arraste. `null` desabilita o controle.',
      ),
    ),
    PropMeta(name: 'min', type: 'double', defaultValue: '0.0'),
    PropMeta(name: 'max', type: 'double', defaultValue: '1.0'),
    PropMeta(
      name: 'step',
      type: 'double?',
      description: LocalizedText(
        en: 'Quantization in domain units (1.0 = integers). `null` = continuous.',
        pt: 'Quantização em unidades do domínio (1.0 = inteiros). `null` = contínuo.',
      ),
    ),
    PropMeta(
      name: 'onChangeEnd',
      type: 'ValueChanged<double>?',
      description: LocalizedText(
        en: 'Commit on release and after each keyboard step.',
        pt: 'Commit no soltar e após cada passo de teclado.',
      ),
    ),
    PropMeta(
      name: 'formatValue',
      type: 'String Function(double)?',
      description: LocalizedText(
        en: 'One source of formatting for the visible label AND the screen reader.',
        pt: 'Fonte única de formatação para o rótulo visível E o leitor de tela.',
      ),
    ),
    PropMeta(name: 'showValue', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'semanticLabel', type: 'String?'),
    PropMeta(
      name: 'color',
      type: 'Color?',
      description: LocalizedText(
        en: 'Accent override. Default: readableStopOn(primary, surface).',
        pt: 'Override do acento. Default: readableStopOn(primary, surface).',
      ),
    ),
    PropMeta(
      name: 'trackThickness',
      type: 'double',
      defaultValue: 'AppSizes.s4',
    ),
    PropMeta(name: 'thumbSize', type: 'double', defaultValue: 'AppSizes.s16'),
  ],
  states: <String>[
    'rest',
    'dragging',
    'focused',
    'at-min',
    'at-max',
    'disabled',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Sending rate', pt: 'Ritmo de envio'),
      code:
          'AppSlider(value: ritmo, min: 1, max: 60, step: 1, showValue: true, '
          "formatValue: (v) => '\${v.round()}/min', "
          "semanticLabel: 'Ritmo de envio', "
          'onChanged: (v) => setState(() => ritmo = v))',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Give it bounded width (Expanded/SizedBox) — it fills what it gets.',
      'Pass semanticLabel: the node needs a name, not only a value.',
      'Use formatValue when the unit matters ("42/min", not "42").',
    ],
    pt: <String>[
      'Dê largura limitada (Expanded/SizedBox) — ele preenche o que recebe.',
      'Passe semanticLabel: o nó precisa de nome, não só de valor.',
      'Use formatValue quando a unidade importa ("42/min", não "42").',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not reach for it when typing is more precise — that is an input.',
      'Do not rebuild heavy work in onChanged; persist in onChangeEnd.',
    ],
    pt: <String>[
      'Não o use quando digitar é mais preciso — isso é um input.',
      'Não faça trabalho pesado no onChanged; persista no onChangeEnd.',
    ],
  ),
  a11y: LocalizedText(
    en: 'One slider node: label, value, increasedValue/decreasedValue (all through formatValue) and onIncrease/onDecrease for the adjust gesture. Left/Right arrows step and mirror under RTL (Up/Down and Home/End do not); Home/End jump to the exact extremes. Disabled keeps the node with enabled: false. The whole widget is a 48px-tall opaque hit area; the visible label is excluded from semantics so the value is not read twice.',
    pt:
        'Um nó slider: label, value, increasedValue/decreasedValue (tudo via '
        'formatValue) e onIncrease/onDecrease para o gesto de ajustar. Setas ←/→ '
        'andam por passo e espelham em RTL (↑/↓ e Home/End não); Home/End saltam aos extremos exatos. '
        'Desabilitado mantém o nó com enabled: false. O widget inteiro é área '
        'de toque opaca de 48px; o rótulo visível fica fora da semântica para '
        'o valor não ser lido duas vezes.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_rating', 'app_segmented_button', 'app_input'],
);
