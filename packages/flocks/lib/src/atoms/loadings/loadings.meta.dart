import '../../meta/app_component_meta.dart';

// Metadados MCP dos loadings (grupo). Registrados em `flocksCatalog`.

const AppComponentMeta appCircularLoadingMeta = AppComponentMeta(
  id: 'app_circular_loading',
  name: 'AppCircularLoading',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Circular progress ring (indeterminate or determinate).',
    pt: 'Anel de progresso circular (indeterminado ou determinado).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Indeterminate loading in buttons, overlays and lists.',
      'Determinate progress (a static arc) by passing value (0..1).',
    ],
    pt: <String>[
      'Carregamento indeterminado em botões, overlays, listas.',
      'Progresso determinado (arco estático) informando value (0..1).',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'value',
      type: 'double?',
      description: LocalizedText(
        en: 'null = indeterminate (spins). 0..1 draws a static arc — no animation, so it is the mode that survives reduce-motion.',
        pt:
            'null = indeterminado (gira). 0..1 desenha um arco estático — sem '
            'animação, então é o modo que sobrevive a reduce-motion.',
      ),
    ),
    PropMeta(
      name: 'size',
      type: 'double',
      defaultValue: 'AppSizes.s16',
      description: LocalizedText(en: 'Ring diameter.', pt: 'Diâmetro do anel.'),
    ),
    PropMeta(
      name: 'stroke',
      type: 'double',
      defaultValue: 'AppStrokes.xl',
      description: LocalizedText(
        en: 'Stroke thickness; the strokeCap follows the radius mode.',
        pt: 'Espessura do traço; o strokeCap segue o modo de raio.',
      ),
    ),
    PropMeta(
      name: 'color',
      type: 'Color?',
      description: LocalizedText(
        en: 'Arc color. Defaults to focusRing (the base primary disappears into the near-black of some brands).',
        pt:
            'Cor do arco. Default focusRing (o primary base some no '
            'quase-preto de algumas marcas).',
      ),
    ),
    PropMeta(
      name: 'backgroundColor',
      type: 'Color?',
      description: LocalizedText(
        en: 'Track behind the arc. Defaults to surfaceContainer.',
        pt: 'Trilho atrás do arco. Default surfaceContainer.',
      ),
    ),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Spinner', pt: 'Spinner'),
      code: 'AppCircularLoading(size: AppSizes.s32)',
    ),
    CodeExample(
      title: LocalizedText(en: 'Determinate', pt: 'Determinado'),
      code: 'AppCircularLoading(value: 0.7)',
    ),
  ],
  a11y: LocalizedText(
    en: 'A visual indicator; wrap it in AppSemantics.liveRegion + label wherever the loading state has to be announced.',
    pt:
        'Indicador visual; envolva com AppSemantics.liveRegion + label onde o '
        'estado de carregamento precise ser anunciado.',
  ),
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_linear_loading', 'app_shimmer_loading'],
);

const AppComponentMeta appLinearLoadingMeta = AppComponentMeta(
  id: 'app_linear_loading',
  name: 'AppLinearLoading',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Linear progress bar (indeterminate or determinate).',
    pt: 'Barra de progresso linear (indeterminada ou determinada).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Indeterminate progress at the top of an area or page.',
      'Determinate progress by passing value (0..1).',
    ],
    pt: <String>[
      'Progresso indeterminado no topo de uma área/página.',
      'Progresso determinado informando value (0..1).',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'value',
      type: 'double?',
      description: LocalizedText(
        en: 'null = indeterminate (a sliding bar). 0..1 fills from the left, static.',
        pt:
            'null = indeterminado (barra deslizante). 0..1 preenche da '
            'esquerda, estático.',
      ),
    ),
    PropMeta(
      name: 'height',
      type: 'double',
      defaultValue: 'AppSizes.s4',
      description: LocalizedText(
        en: 'Bar thickness; the end caps follow the global radius.',
        pt: 'Espessura da barra; as pontas seguem o raio global.',
      ),
    ),
    PropMeta(
      name: 'color',
      type: 'Color?',
      description: LocalizedText(
        en: 'Fill color.',
        pt: 'Cor do preenchimento.',
      ),
    ),
    PropMeta(
      name: 'backgroundColor',
      type: 'Color?',
      description: LocalizedText(
        en: 'Track. Defaults to surfaceContainer.',
        pt: 'Trilho. Default surfaceContainer.',
      ),
    ),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Indeterminate', pt: 'Indeterminada'),
      code: 'AppLinearLoading()',
    ),
    CodeExample(
      title: LocalizedText(en: 'Determinate', pt: 'Determinada'),
      code: 'AppLinearLoading(value: 0.7)',
    ),
  ],
  a11y: LocalizedText(
    en: 'A visual indicator; under reduce-motion it stays static.',
    pt: 'Indicador visual; sob reduce-motion fica estático.',
  ),
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_circular_loading'],
);

const AppComponentMeta appBorderProgressMeta = AppComponentMeta(
  id: 'app_border_progress',
  name: 'AppBorderProgress',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Animated progress border around a child.',
    pt: 'Borda de progresso animada ao redor de um filho.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Progress (driven by `progress`) or a timer (automatic, through `duration`).',
    ],
    pt: <String>[
      'Progresso (controlado por `progress`) ou timer (auto por `duration`).',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'child',
      type: 'Widget',
      isRequired: true,
      description: LocalizedText(
        en: 'What the border encircles.',
        pt: 'O que a borda circunda.',
      ),
    ),
    PropMeta(
      name: 'progress',
      type: 'double?',
      description: LocalizedText(
        en: 'Controlled mode (0..1). Mutually exclusive with duration.',
        pt: 'Modo controlado (0..1). Exclusivo com duration.',
      ),
    ),
    PropMeta(
      name: 'duration',
      type: 'Duration?',
      description: LocalizedText(
        en: 'Timer mode: the border closes on its own over this span. Under reduce-motion it starts at the final state.',
        pt:
            'Modo timer: a borda fecha sozinha nesse tempo. Sob '
            'reduce-motion nasce no estado final.',
      ),
    ),
    PropMeta(
      name: 'borderRadius',
      type: 'BorderRadius',
      defaultValue: 'BorderRadius.zero',
      description: LocalizedText(
        en: 'Stroke corners, concentric with the child.',
        pt: 'Cantos do traço, concêntricos ao filho.',
      ),
    ),
    PropMeta(name: 'strokeWidth', type: 'double', defaultValue: 'AppStrokes.l'),
    PropMeta(name: 'color', type: 'Color?'),
    PropMeta(
      name: 'backgroundColor',
      type: 'Color?',
      description: LocalizedText(en: 'Track.', pt: 'Trilho.'),
    ),
    PropMeta(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'false',
      description: LocalizedText(
        en: 'Timer mode only: restarts on completion.',
        pt: 'Só no modo timer: reinicia ao completar.',
      ),
    ),
    PropMeta(name: 'onComplete', type: 'VoidCallback?'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Controlled', pt: 'Controlado'),
      code: 'AppBorderProgress(progress: 0.5, child: child)',
    ),
  ],
  a11y: LocalizedText(
    en: 'A visual indicator; auto mode sits at the final state under reduce-motion.',
    pt: 'Indicador visual; auto-mode fica no estado final sob reduce-motion.',
  ),
  themeAware: true,
  reducesMotion: true,
);

const AppComponentMeta appOverlayLoadingMeta = AppComponentMeta(
  id: 'app_overlay_loading',
  name: 'AppOverlayLoading',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Loading overlay on top of a child (barrier + indicator).',
    pt: 'Overlay de carregamento sobre um filho (barrier + indicador).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Blocking an area while it loads, keeping the content visible.',
    ],
    pt: <String>['Bloquear uma área enquanto carrega, mantendo o conteúdo.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'isLoading',
      type: 'bool',
      isRequired: true,
      description: LocalizedText(
        en: 'Turns the barrier on. False mounts nothing on top.',
        pt: 'Liga o barrier. False não monta nada por cima.',
      ),
    ),
    PropMeta(
      name: 'overlay',
      type: 'Widget',
      isRequired: true,
      description: LocalizedText(
        en: 'The indicator shown over the content.',
        pt: 'O indicador mostrado sobre o conteúdo.',
      ),
    ),
    PropMeta(
      name: 'child',
      type: 'Widget',
      isRequired: true,
      description: LocalizedText(
        en: 'Content that stays visible underneath.',
        pt: 'Conteúdo que continua visível por baixo.',
      ),
    ),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Default', pt: 'Padrão'),
      code:
          'AppOverlayLoading(isLoading: true, overlay: AppCircularLoading(), child: form)',
    ),
  ],
  a11y: LocalizedText(
    en: 'Blocks interaction visually; pair it with "loading" semantics.',
    pt: 'Bloqueia interação visual; combine com semântica de "carregando".',
  ),
  themeAware: true,
  reducesMotion: true,
);

const AppComponentMeta appShimmerLoadingMeta = AppComponentMeta(
  id: 'app_shimmer_loading',
  name: 'AppShimmerLoading',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Skeleton placeholder with an animated sheen.',
    pt: 'Placeholder skeleton com brilho animado.',
  ),
  whenToUse: LocalizedList(
    en: <String>['A content skeleton while the data loads.'],
    pt: <String>['Skeleton de conteúdo enquanto os dados carregam.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'height',
      type: 'double',
      isRequired: true,
      description: LocalizedText(
        en: 'Height of the skeleton block.',
        pt: 'Altura do bloco de skeleton.',
      ),
    ),
    PropMeta(
      name: 'width',
      type: 'double',
      defaultValue: 'double.infinity',
      description: LocalizedText(
        en: 'Width; infinity fills the parent.',
        pt: 'Largura; infinity preenche o pai.',
      ),
    ),
    PropMeta(
      name: 'borderRadius',
      type: 'BorderRadius?',
      description: LocalizedText(
        en: 'Corners. Default: the theme\'s global radius.',
        pt: 'Cantos. Default: o raio global do tema.',
      ),
    ),
    PropMeta(
      name: 'color',
      type: 'Color?',
      description: LocalizedText(
        en: 'Base of the block.',
        pt: 'Base do bloco.',
      ),
    ),
    PropMeta(
      name: 'highlightColor',
      type: 'Color?',
      description: LocalizedText(
        en: 'Color of the sheen that sweeps across.',
        pt: 'Cor do brilho que passa.',
      ),
    ),
    PropMeta(name: 'margin', type: 'EdgeInsets?'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Default', pt: 'Padrão'),
      code: 'AppShimmerLoading(height: AppSizes.s16)',
    ),
  ],
  a11y: LocalizedText(
    en: 'A decorative placeholder; under reduce-motion it shows the static box.',
    pt: 'Placeholder decorativo; sob reduce-motion mostra o box estático.',
  ),
  themeAware: true,
  reducesMotion: true,
);
