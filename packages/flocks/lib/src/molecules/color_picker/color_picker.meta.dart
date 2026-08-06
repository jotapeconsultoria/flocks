import '../../meta/app_component_meta.dart';

// Metadados MCP do seletor de cor. Registrados em `flocksCatalog`.

/// Descritor MCP do [AppColorPickerInput]. Registrado em `flocksCatalog`.
const AppComponentMeta appColorPickerInputMeta = AppComponentMeta(
  id: 'app_color_picker_input',
  name: 'AppColorPickerInput',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Color field: a painted swatch + an editable hex, with the HSV panel in an overlay.',
    pt:
        'Campo de cor: amostra pintada + hex editável, com o painel HSV num '
        'overlay.',
  ),
  description: LocalizedText(
    en: 'Three ways of saying the same color, because people arrive by different routes: pasting the hex from a brand guide, picking a preset, or hunting through the spectrum. The field ALWAYS emits the normalized hex \'#RRGGBB\' (or \'\' when cleared), ready to persist — the consumer never receives `#abc`, `abc` or `#AABBCCDD` to normalize later. The swatch sits in the prefix, not the suffix: it is the field\'s value, not an action.',
    pt:
        'Três formas de dizer a mesma cor, porque quem usa chega por caminhos '
        'diferentes: colar o hex da identidade visual, pegar um preset, ou '
        'caçar no espectro. O campo emite SEMPRE o hex normalizado '
        "'#RRGGBB' (ou '' quando esvaziado), pronto para persistir — o "
        'consumidor nunca recebe `#abc`, `abc` ou `#AABBCCDD` para normalizar '
        'depois. A amostra fica no prefixo, não no sufixo: é o valor do campo, '
        'não uma ação.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The color of a product entity (group, geofence, category).',
      'Any form where the color is data, not decoration.',
    ],
    pt: <String>[
      'Cor de uma entidade do produto (grupo, geocerca, categoria).',
      'Qualquer formulário em que a cor é dado, não decoração.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Choosing among a few fixed colors → AppDropdown with AppSwatch.',
      'Showing a color without editing it → AppSwatch.',
    ],
    pt: <String>[
      'Escolher entre poucas cores fixas → AppDropdown com AppSwatch.',
      'Mostrar uma cor sem editar → AppSwatch.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'onChanged',
      type: 'ValueChanged<String>',
      isRequired: true,
      description: LocalizedText(
        en: 'Receives the normalized hex \'#RRGGBB\', or \'\' if cleared.',
        pt: "Recebe o hex normalizado '#RRGGBB', ou '' se esvaziado.",
      ),
    ),
    PropMeta(
      name: 'value',
      type: 'String?',
      description: LocalizedText(en: 'Current hex.', pt: 'Hex atual.'),
    ),
    PropMeta(name: 'label', type: 'String?'),
    PropMeta(name: 'hintText', type: 'String?'),
    PropMeta(name: 'helperText', type: 'String?'),
    PropMeta(name: 'errorText', type: 'String?'),
    PropMeta(name: 'hasError', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'info', type: 'Widget?'),
    PropMeta(
      name: 'fallbackColor',
      type: 'Color?',
      description: LocalizedText(
        en: 'What the swatch paints while the hex is invalid/empty.',
        pt: 'O que a amostra pinta enquanto o hex é inválido/vazio.',
      ),
    ),
    PropMeta(
      name: 'shape',
      type: 'AppSwatchShape',
      defaultValue: 'AppSwatchShape.square',
      enumValues: <String>['square', 'circle'],
    ),
    PropMeta(
      name: 'presets',
      type: 'List<Color>?',
      description: LocalizedText(
        en: 'Replaces the suggested palette.',
        pt: 'Substitui a paleta sugerida.',
      ),
    ),
    PropMeta(name: 'showSuggestedColors', type: 'bool', defaultValue: 'true'),
    PropMeta(
      name: 'size',
      type: 'AppFieldSize',
      defaultValue: 'AppFieldSize.m',
      enumValues: <String>['s', 'm', 'l'],
    ),
    PropMeta(name: 'style', type: 'AppStyle?'),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
    PropMeta(name: 'radius', type: 'BorderRadius?'),
  ],
  states: <String>[
    'empty',
    'valid-hex',
    'invalid-hex (error)',
    'disabled',
    'panel-open',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Color for a client group',
        pt: 'Cor de um grupo de clientes',
      ),
      code:
          'AppColorPickerInput(\n'
          "  label: 'Cor',\n"
          '  value: group.colorHex,\n'
          '  onChanged: (String hex) => form.setColor(hex),\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Pass presets when the domain\'s palette is fixed (map categories).',
    ],
    pt: <String>[
      'Passe presets quando a paleta do domínio for fixa (categorias de mapa).',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not normalize the hex again on the outside: it already arrives canonical.',
    ],
    pt: <String>[
      'Não normalize o hex de novo do lado de fora: ele já chega canônico.',
    ],
  ),
  a11y: LocalizedText(
    en: 'The field is a textField with the hex as its content — color is never the ONLY channel: the textual value always accompanies the swatch. The panel\'s trigger is a labelled button.',
    pt:
        'O campo é textField com o hex como conteúdo — a cor nunca é o ÚNICO '
        'canal: o valor textual sempre acompanha a amostra. O gatilho do painel '
        'é botão rotulado.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_color_picker_panel', 'app_swatch', 'app_input'],
);

/// Descritor MCP do [AppColorPickerPanel]. Registrado em `flocksCatalog`.
const AppComponentMeta appColorPickerPanelMeta = AppComponentMeta(
  id: 'app_color_picker_panel',
  name: 'AppColorPickerPanel',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Visual HSV picker: a saturation/value area, a hue bar and presets.',
    pt: 'Seletor visual HSV: área de saturação/valor, barra de matiz e presets.',
  ),
  description: LocalizedText(
    en: 'The bare panel, with no field and no overlay — AppColorPickerInput opens it anchored, but it serves anywhere that needs a visual color choice. The literal colors here (the hue spectrum, the gradient stops) are NOT an exception to the token rule: they are the color space itself. Tokenizing the spectrum\'s pure red would deform the tool, which exists precisely to navigate outside the palette.',
    pt:
        'O painel nu, sem campo nem overlay — o AppColorPickerInput o abre '
        'ancorado, mas ele serve a qualquer lugar que precise de escolha visual '
        'de cor. As cores literais aqui (o espectro de matiz, os stops do '
        'gradiente) NÃO são exceção à regra de tokens: são o espaço de cor em '
        'si. Tokenizar o vermelho puro do espectro deformaria a ferramenta, que '
        'existe justamente para navegar fora da paleta.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Free color choice kept visible on a screen.',
      'The panel of a hand-assembled color field.',
    ],
    pt: <String>[
      'Escolha livre de cor sempre visível numa tela.',
      'Painel de um campo de cor montado à mão.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A form → AppColorPickerInput (it brings the hex, validation and normalization).',
      'A small fixed palette → a row of AppSwatch.',
    ],
    pt: <String>[
      'Formulário → AppColorPickerInput (traz hex, validação e normalização).',
      'Paleta pequena e fixa → uma fileira de AppSwatch.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'color', type: 'Color', isRequired: true),
    PropMeta(
      name: 'onColorChanged',
      type: 'ValueChanged<Color>',
      isRequired: true,
      description: LocalizedText(
        en: 'Emits continuously while the user drags.',
        pt: 'Emite continuamente enquanto o usuário arrasta.',
      ),
    ),
    PropMeta(
      name: 'presets',
      type: 'List<Color>?',
      description: LocalizedText(
        en: 'Replaces the suggested palette (distinguishable map colors).',
        pt: 'Substitui a paleta sugerida (cores de mapa distinguíveis).',
      ),
    ),
    PropMeta(name: 'showSuggestedColors', type: 'bool', defaultValue: 'true'),
  ],
  states: <String>['dragging-in-area', 'dragging-hue', 'preset-active'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Fixed panel', pt: 'Painel fixo'),
      code:
          'AppColorPickerPanel(\n'
          '  color: current,\n'
          '  onColorChanged: (Color c) => setState(() => current = c),\n'
          ')',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use domain presets when the colors have to be distinguishable from each other (map categories).',
    ],
    pt: <String>[
      'Use presets do domínio quando as cores precisam ser distinguíveis entre '
          'si (categorias no mapa).',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not treat onColorChanged as confirmation: it fires while the user drags.',
    ],
    pt: <String>[
      'Não trate onColorChanged como confirmação: ele dispara durante o arraste.',
    ],
  ),
  a11y: LocalizedText(
    en: 'The saturation/value area and the hue bar respond to the keyboard; the presets are buttons labelled with the hex, so the choice does not depend on seeing the difference between two near-identical tones.',
    pt:
        'A área de saturação/valor e a barra de matiz respondem a teclado; os '
        'presets são botões rotulados com o hex, para a escolha não depender só '
        'de enxergar a diferença entre dois tons próximos.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_color_picker_input', 'app_swatch'],
);
