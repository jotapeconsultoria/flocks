import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppFilterChip`. Registrado em `flocksCatalog`.
const AppComponentMeta appFilterChipMeta = AppComponentMeta(
  id: 'app_filter_chip',
  name: 'AppFilterChip',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Applied-filter chip with a remove affordance.',
    pt: 'Chip de filtro aplicado, com afordância de remover.',
  ),
  description: LocalizedText(
    en: 'Filled chip showing "field: value" for a filter currently applied, with its own "×" target to clear it. The sibling of AppSuggestionChip: that one invites, this one reports and undoes.',
    pt:
        'Chip preenchido com "campo: valor" de um filtro em vigor, e um alvo de '
        'toque PRÓPRIO para removê-lo. Irmão do AppSuggestionChip: aquele '
        'convida a aplicar, este mostra o que está aplicado e oferece tirar.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Filters applied above a list or a timeline.',
      'Any narrowing the reader needs to see and be able to undo.',
    ],
    pt: <String>[
      'Filtros aplicados acima de uma lista ou timeline.',
      'Todo recorte que quem lê precisa enxergar e poder desfazer.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A suggestion to be applied → AppSuggestionChip.',
      'A status label → AppBadge.',
    ],
    pt: <String>[
      'Sugestão a aplicar → AppSuggestionChip.',
      'Rótulo de status → AppBadge.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'value', type: 'String', isRequired: true),
    PropMeta(name: 'field', type: 'String?'),
    PropMeta(name: 'onRemove', type: 'VoidCallback?'),
    PropMeta(name: 'onTap', type: 'VoidCallback?'),
    PropMeta(name: 'style', type: 'AppStyle?', defaultValue: 'AppStyle.filled'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Filters applied over an audit feed',
        pt: 'Filtros aplicados sobre um feed de auditoria',
      ),
      code:
          'Wrap(spacing: 8, children: <Widget>[\n  AppFilterChip(field: \'Tipo\', value: \'client.created\', onRemove: _clearType),\n  AppFilterChip(field: \'Resultado\', value: \'Negado\', onRemove: _clearResult),\n])',
    ),
  ],
  a11y: LocalizedText(
    en: 'Two separate targets: the body opens the filter, the "×" removes it — announced as "Remove filter <label>".',
    pt:
        'Dois alvos separados: o corpo abre o filtro, o "×" remove — anunciado '
        'como "Remover filtro <rótulo>".',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
);
