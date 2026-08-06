import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppResizableSplit]. Registrado em `flocksCatalog`.
const AppComponentMeta appResizableSplitMeta = AppComponentMeta(
  id: 'app_resizable_split',
  name: 'AppResizableSplit',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Two panels with a draggable divider (horizontal or vertical).',
    pt: 'Dois painéis com divisor arrastável (horizontal ou vertical).',
  ),
  description: LocalizedText(
    en: 'A resizable-panel layout with a draggable divider between [first] and [second]. The split is a fraction (0..1) that scales with the window. **Persistence belongs to the caller** (DI): pass the restored value in initialFirstFraction and save new ones from onFractionChanged — the design system does not depend on storage. Double-tapping the divider resets it. Colors from the theme; the handle\'s hover runs on motion tokens (reduce-motion).',
    pt:
        'Layout de painéis redimensionáveis com um divisor arrastável entre '
        '[first] e [second]. O split é uma fração (0..1) que escala com a janela. '
        '**Persistência é do chamador** (DI): passe o valor restaurado em '
        'initialFirstFraction e salve os novos em onFractionChanged — o DS não '
        'depende de storage. Duplo-toque no divisor reseta. Cores do tema; hover '
        'do handle via tokens de motion (reduce-motion).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Sidebar + content (e.g. a list + a map) with an adjustable width.',
    ],
    pt: <String>[
      'Sidebar + conteúdo (ex.: lista + mapa) com largura ajustável.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A fixed division with no adjustment → a Row/Column with Expanded.',
      'A single panel with no sibling to divide → AppResizablePanel.',
    ],
    pt: <String>[
      'Divisão fixa sem ajuste → um Row/Column com Expanded.',
      'Um painel só, sem irmão para dividir → AppResizablePanel.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'first', type: 'Widget', isRequired: true),
    PropMeta(name: 'second', type: 'Widget', isRequired: true),
    PropMeta(name: 'direction', type: 'Axis', defaultValue: 'Axis.horizontal'),
    PropMeta(name: 'initialFirstFraction', type: 'double', defaultValue: '0.5'),
    PropMeta(
      name: 'onFractionChanged',
      type: 'ValueChanged<double>?',
      description: LocalizedText(
        en: 'Save the value here to persist it (persistence is yours).',
        pt: 'Salve o valor aqui para persistir (a persistência é sua).',
      ),
    ),
    PropMeta(name: 'minFirstSize', type: 'double?'),
    PropMeta(name: 'minSecondSize', type: 'double?'),
  ],
  states: <String>['idle', 'hovered', 'dragging'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Sidebar + map', pt: 'Sidebar + mapa'),
      code:
          'AppResizableSplit(initialFirstFraction: restored ?? 0.22, '
          'onFractionChanged: (f) => storage.write(key, f), '
          'first: sidebar, second: map)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Restore the fraction in the caller and pass it in initialFirstFraction.',
      'Use minFirstSize/minSecondSize so a panel cannot collapse.',
    ],
    pt: <String>[
      'Restaure a fração no chamador e passe em initialFirstFraction.',
      'Use minFirstSize/minSecondSize para não colapsar um painel.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not expect the component to persist anything by itself (that is the app\'s job).',
    ],
    pt: <String>['Não espere que o componente persista sozinho (é do app).'],
  ),
  a11y: LocalizedText(
    en: 'The divider has a tooltip (AppTooltip) and its own drag target; the handle\'s colors come from the theme (AA in light and dark).',
    pt:
        'O divisor tem tooltip (AppTooltip) e alvo de arraste próprio; cores do '
        'handle vêm do tema (AA em claro/escuro).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_scaffold', 'app_resizable_panel'],
);
