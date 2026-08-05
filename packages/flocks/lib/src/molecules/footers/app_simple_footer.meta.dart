import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSimpleFooter]. Registrado em `flocksCatalog`.
const AppComponentMeta appSimpleFooterMeta = AppComponentMeta(
  id: 'app_simple_footer',
  name: 'AppSimpleFooter',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.5.0',
  summary: LocalizedText(
    en: 'Simple footer: a band over the surface holding one child.',
    pt: 'Rodapé simples: faixa sobre surface com um child.',
  ),
  description: LocalizedText(
    en: 'A band over `surface` wrapping one child, adding the bottom safe area. Color from the theme.',
    pt:
        'Faixa sobre `surface` que envolve um child, somando a safe-area '
        'inferior. Cor do tema.',
  ),
  whenToUse: LocalizedList(
    en: <String>['A free-form footer (copyright, a note, a total).'],
    pt: <String>['Rodapé livre (copyright, uma nota, um total).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Primary actions → AppButtonsFooter.',
      'Navigation → AppNavigationFooter.',
    ],
    pt: <String>[
      'Ações primárias → AppButtonsFooter.',
      'Navegação → AppNavigationFooter.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(name: 'constraints', type: 'BoxConstraints?'),
    PropMeta(name: 'decoration', type: 'BoxDecoration?'),
    PropMeta(name: 'padding', type: 'EdgeInsets?'),
  ],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Note', pt: 'Nota'),
      code: "AppSimpleFooter(child: AppText('© 2026'))",
    ),
  ],
  dos: LocalizedList(
    en: <String>['Use it for a lean footer.'],
    pt: <String>['Use para um rodapé enxuto.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not put actions in it — use AppButtonsFooter.'],
    pt: <String>['Não coloque ações — use AppButtonsFooter.'],
  ),
  a11y: LocalizedText(
    en: 'The meaning comes from the child.',
    pt: 'O significado vem do child.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_buttons_footer'],
);
