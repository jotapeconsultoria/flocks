import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSegmentedButton]. Registrado em `flocksCatalog`.
const AppComponentMeta appSegmentedButtonMeta = AppComponentMeta(
  id: 'app_segmented_button',
  name: 'AppSegmentedButton',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Segmented button for single selection (2–4 options in a pill).',
    pt: 'Botão segmentado de seleção única (2–4 opções numa pílula).',
  ),
  description: LocalizedText(
    en: 'Mutually exclusive options of equal width: the selected one is a sliding pill (filled primary) that slides underneath the text when it changes. Inset style; in filled the track is a recessed well that stands out from the host surface.',
    pt:
        'Opções mutuamente exclusivas de largura igual: a selecionada é uma '
        'pílula deslizante (filled primary) que desliza por baixo do texto ao '
        'trocar. Estilo inset; no filled o trilho é um poço recuado que destaca '
        'da superfície-hospedeira.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Switching between a few views or modes (Day/Week/Month, Streets/Satellite).',
      'A binary or ternary filter that stays visible.',
    ],
    pt: <String>[
      'Alternar entre poucas visões/modos (Dia/Semana/Mês, Ruas/Satélite).',
      'Filtro binário/ternário sempre visível.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Many options (>4) → use AppDropdown.',
      'Multiple selection → use AppMultiSelect or checkboxes.',
    ],
    pt: <String>[
      'Muitas opções (>4) → use AppDropdown.',
      'Seleção múltipla → use AppMultiSelect ou checkboxes.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'segments', type: 'List<AppSegment<T>>', isRequired: true),
    PropMeta(name: 'value', type: 'T', isRequired: true),
    PropMeta(name: 'onChanged', type: 'ValueChanged<T>', isRequired: true),
    PropMeta(name: 'size', type: 'AppButtonSize', defaultValue: 'm'),
    PropMeta(name: 'enabled', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'expanded', type: 'bool', defaultValue: 'false'),
  ],
  states: <String>['selected', 'unselected', 'hovered', 'focused', 'disabled'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Map mode', pt: 'Modo do mapa'),
      code:
          'AppSegmentedButton<MapMode>(value: mode, onChanged: setMode, '
          'segments: [AppSegment(value: MapMode.street, label: "Ruas"), '
          'AppSegment(value: MapMode.satellite, label: "Satélite")])',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use 2–4 short options; a label and/or an icon per segment.'],
    pt: <String>['Use 2–4 opções curtas; rótulo e/ou ícone por segmento.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for multiple selection or for long lists.'],
    pt: <String>['Não use para seleção múltipla nem listas longas.'],
  ),
  a11y: LocalizedText(
    en: 'Each segment is a mutually exclusive toggle (AppSemantics.toggle). Keyboard: Tab and the ←/→ arrows navigate; Enter/Space selects. The pill slides while honoring reduce-motion.',
    pt:
        'Cada segmento é um toggle mutuamente exclusivo (AppSemantics.toggle). '
        'Teclado: Tab e setas ←/→ navegam; Enter/Espaço seleciona. A pílula '
        'desliza respeitando reduce-motion.',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_button', 'app_radio', 'app_dropdown'],
);
