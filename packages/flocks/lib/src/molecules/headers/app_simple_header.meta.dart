import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSimpleHeader]. Registrado em `flocksCatalog`.
const AppComponentMeta appSimpleHeaderMeta = AppComponentMeta(
  id: 'app_simple_header',
  name: 'AppSimpleHeader',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Simple page header (a band over the surface holding one child).',
    pt: 'Cabeçalho simples de página (faixa sobre surface com um child).',
  ),
  description: LocalizedText(
    en: 'A band over `surface` wrapping one child, adding the top safe area. Color from the theme; marked as a header (AppSemantics.header).',
    pt:
        'Faixa sobre `surface` que envolve um child, somando a safe-area do topo. '
        'Cor do tema; marcado como cabeçalho (AppSemantics.header).',
  ),
  whenToUse: LocalizedList(
    en: <String>['The top of a page with free content (a title, and so on).'],
    pt: <String>['Topo de uma página com um conteúdo livre (título etc.).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A header with leading/child/trailing → AppPrimaryHeader.'],
    pt: <String>['Cabeçalho com leading/child/trailing → AppPrimaryHeader.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(name: 'decoration', type: 'BoxDecoration?'),
    PropMeta(name: 'constraints', type: 'BoxConstraints?'),
    PropMeta(name: 'padding', type: 'EdgeInsets?'),
  ],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Title', pt: 'Título'),
      code: "AppSimpleHeader(child: AppText('Título'))",
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it for a lean page top.'],
    pt: <String>['Use para um topo de página enxuto.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not put many elements in it — use AppPrimaryHeader.'],
    pt: <String>['Não coloque muitos elementos — use AppPrimaryHeader.'],
  ),
  a11y: LocalizedText(
    en: 'Marked as a header (AppSemantics.header); the content comes from the child.',
    pt: 'Marcado como header (AppSemantics.header); conteúdo vem do child.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_primary_header'],
);
