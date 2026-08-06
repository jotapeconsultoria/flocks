import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppListEmpty]. Registrado em `flocksCatalog`.
const AppComponentMeta appListEmptyMeta = AppComponentMeta(
  id: 'app_list_empty',
  name: 'AppListEmpty',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'List empty state: illustration + message + optional action.',
    pt: 'Estado vazio de lista: ilustração + mensagem + ação opcional.',
  ),
  description: LocalizedText(
    en: 'A centered illustration, a message (onSurface) and an optional clear-filter action (a secondary AppTextButton). Colors from the theme; the illustration adapts to light/dark.',
    pt:
        'Ilustração centralizada, mensagem (onSurface) e uma ação opcional de '
        'limpar filtro (AppTextButton secundário). Cores do tema; ilustração '
        'adapta-se a claro/escuro.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A list or table with no items (empty, or no results for the filter).',
    ],
    pt: <String>['Lista/tabela sem itens (vazia ou sem resultados de filtro).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A load error → a dedicated error state.',
      'Loading → AppShimmerLoading / AppCircularLoading.',
    ],
    pt: <String>[
      'Erro de carregamento → estado de erro dedicado.',
      'Carregando → AppShimmerLoading / AppCircularLoading.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'illustration',
      type: 'String',
      isRequired: true,
      description: LocalizedText(
        en: 'Illustration URL (e.g. AppIllustrations.empty).',
        pt: 'URL da ilustração (ex.: AppIllustrations.empty).',
      ),
    ),
    PropMeta(name: 'text', type: 'String', isRequired: true),
    PropMeta(
      name: 'onClearFilter',
      type: 'VoidCallback?',
      description: LocalizedText(
        en: 'If != null, shows the "Clear" button.',
        pt: 'Se != null, mostra o botão "Limpar".',
      ),
    ),
  ],
  states: <String>['default', 'with-action'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'No results', pt: 'Sem resultados'),
      code:
          'AppListEmpty(illustration: AppIllustrations.empty, '
          "text: 'Nenhum resultado.', onClearFilter: clear)",
    ),
  ],
  dos: LocalizedList(
    en: <String>['Offer the clear action whenever a filter is active.'],
    pt: <String>['Ofereça a ação de limpar quando houver filtro ativo.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for errors — use an error state.'],
    pt: <String>['Não use para erros — use um estado de erro.'],
  ),
  a11y: LocalizedText(
    en: 'The message in onSurface over the surface (an AA pair). The illustration is decorative; the message describes the state.',
    pt:
        'Mensagem em onSurface sobre a surface (par AA). A ilustração é '
        'decorativa; a mensagem descreve o estado.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_illustration', 'app_interaction'],
);
