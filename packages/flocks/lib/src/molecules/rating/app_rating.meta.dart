import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppRating]. Registrado em `flocksCatalog`.
const AppComponentMeta appRatingMeta = AppComponentMeta(
  id: 'app_rating',
  name: 'AppRating',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.4.0',
  summary: LocalizedText(
    en: 'Star rating (display and input), with an optional half step.',
    pt: 'Avaliação por estrelas (display e input), com meio-passo opcional.',
  ),
  description: LocalizedText(
    en: 'The star is painted (CustomPainter) — deterministic, with no network icon. Read-only when onChanged is null; otherwise click and keyboard set the value.',
    pt:
        'A estrela é pintada (CustomPainter) — determinística, sem ícone de rede. '
        'Somente-leitura quando onChanged é nulo; senão clique/teclado definem o '
        'valor.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Showing or capturing a score (satisfaction, quality, a 0–5 rating).',
    ],
    pt: <String>[
      'Mostrar ou capturar uma nota (satisfação, qualidade, score de 0–5).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A wide numeric scale → use a slider or a numeric field.',
      'Progress or measurement → use a determinate AppLinearLoading.',
    ],
    pt: <String>[
      'Escala numérica ampla → use um slider ou campo numérico.',
      'Progresso/medição → use AppLinearLoading determinado.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'value', type: 'double', isRequired: true),
    PropMeta(name: 'onChanged', type: 'ValueChanged<double>?'),
    PropMeta(name: 'count', type: 'int', defaultValue: '5'),
    PropMeta(name: 'allowHalf', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'iconSize', type: 'double', defaultValue: 'AppSizes.s24'),
    PropMeta(name: 'spacing', type: 'double', defaultValue: 'AppSpacings.s2'),
    PropMeta(name: 'color', type: 'Color?'),
  ],
  states: <String>['empty', 'partial', 'full', 'read-only'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Input with half stars',
        pt: 'Input com meia-estrela',
      ),
      code:
          'AppRating(value: 3.5, allowHalf: true, onChanged: (v) => setRating(v))',
    ),
    CodeExample(
      title: LocalizedText(en: 'Read-only', pt: 'Somente-leitura'),
      code: 'AppRating(value: 4)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use it for short scores (0–5); turn allowHalf on for granularity.',
    ],
    pt: <String>[
      'Use para notas curtas (0–5); ative allowHalf p/ granularidade.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for large scales or for progress.'],
    pt: <String>['Não use para escalas grandes nem progresso.'],
  ),
  a11y: LocalizedText(
    en: 'Read-only exposes the value as a label. Interactive, it is a slider (onIncrease/onDecrease) driven by the arrow keys. The star is painted, with no network dependency.',
    pt:
        'Somente-leitura expõe o valor como rótulo. Interativo é um slider '
        '(onIncrease/onDecrease) com setas do teclado. Estrela pintada, sem '
        'dependência de rede.',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_linear_loading'],
);
