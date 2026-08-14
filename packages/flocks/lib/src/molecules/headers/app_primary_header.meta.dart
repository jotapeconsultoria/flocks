import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppPrimaryHeader]. Registrado em `flocksCatalog`.
const AppComponentMeta appPrimaryHeaderMeta = AppComponentMeta(
  id: 'app_primary_header',
  name: 'AppPrimaryHeader',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Primary header: a centered child + optional leading/trailing.',
    pt: 'Cabeçalho primário: child central + leading/trailing opcionais.',
  ),
  description: LocalizedText(
    en: 'A centered child with optional leading/trailing slots, over `surface`, adding the top safe area. Color from the theme; marked as a header (AppSemantics.header). The legacy `style` (dead code) was removed.',
    pt:
        'Child centralizado com slots opcionais de leading/trailing, sobre '
        '`surface`, somando a safe-area do topo. Cor do tema; marcado como '
        'cabeçalho (AppSemantics.header). O `style` legado (dead code) foi '
        'removido.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The top of a page with a centered title and actions at the sides.',
    ],
    pt: <String>['Topo de página com título centralizado e ações laterais.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Just one child, with no slots → AppSimpleHeader.'],
    pt: <String>['Só um child, sem slots → AppSimpleHeader.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(name: 'leading', type: 'Widget?'),
    PropMeta(name: 'trailing', type: 'Widget?'),
    PropMeta(
      name: 'bottom',
      type: 'Widget?',
      description: LocalizedText(
        en: 'Extra row below the content strip, INSIDE the bar (a filter strip, tabs) — it inherits the bar surface and the glass.',
        pt: 'Linha extra abaixo da faixa de conteúdo, DENTRO da barra (faixa de filtros, abas) — herda a superfície da barra e o glass.',
      ),
    ),
    PropMeta(
      name: 'bottomHeight',
      type: 'double',
      defaultValue: '0',
      description: LocalizedText(
        en: 'Declared height of bottom; the bar extent adds exactly this value (asserted together with bottom).',
        pt: 'Altura declarada do bottom; a extensão da barra soma exatamente este valor (assert junto com bottom).',
      ),
    ),
    PropMeta(name: 'centerChild', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'decoration', type: 'BoxDecoration?'),
    PropMeta(name: 'constraints', type: 'BoxConstraints?'),
    PropMeta(name: 'padding', type: 'EdgeInsets?'),
  ],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'With back', pt: 'Com voltar'),
      code:
          'AppPrimaryHeader(leading: AppIconButton(...), '
          "child: AppText('Detalhes'))",
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use leading for navigation and trailing for one action.'],
    pt: <String>['Use leading para navegação e trailing para uma ação.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not pile many items into the trailing.'],
    pt: <String>['Não empilhe muitos itens no trailing.'],
  ),
  a11y: LocalizedText(
    en: 'Marked as a header; content and actions come from the slots.',
    pt: 'Marcado como header; conteúdo/ações vêm dos slots.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_simple_header', 'app_interaction'],
);
