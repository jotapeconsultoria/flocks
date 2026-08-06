import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppSuggestionChip`. Registrado em `flocksCatalog`.
const AppComponentMeta appSuggestionChipMeta = AppComponentMeta(
  id: 'app_suggestion_chip',
  name: 'AppSuggestionChip',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Tappable chip for a starter prompt or a quick reply.',
    pt: 'Chip tocável de prompt inicial / resposta rápida.',
  ),
  description: LocalizedText(
    en: 'Outlined chip (by default) with an optional icon + text, meant for a Wrap of suggestions. Reuses AppSurface (the shell) + AppInteraction (the touch).',
    pt:
        'Chip delineado (por padrão) com ícone opcional + texto, para entrar num '
        'Wrap de sugestões. Reusa AppSurface (casca) + AppInteraction (toque).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Prompt suggestions in an LLM chat.',
      'WhatsApp-style quick replies.',
    ],
    pt: <String>[
      'Sugestões de prompt de um chat com LLM.',
      'Respostas rápidas estilo WhatsApp.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A status label → use AppBadge.'],
    pt: <String>['Rótulo de status → use AppBadge.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'label', type: 'String', isRequired: true),
    PropMeta(name: 'icon', type: 'String?'),
    PropMeta(name: 'onTap', type: 'VoidCallback?'),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      defaultValue: 'AppStyle.outlined',
    ),
    PropMeta(name: 'maxLines', type: 'int', defaultValue: '2'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Suggested opening question',
        pt: 'Sugestão de primeira pergunta',
      ),
      code:
          'AppSuggestionChip(\n  label: \'Quais veículos estão sem sinal?\',\n  onTap: () => _ask(suggestion),\n)',
    ),
  ],
  a11y: LocalizedText(
    en: 'A button labelled by its label.',
    pt: 'Botão rotulado pelo label.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
);
