import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppButtonsFooter]. Registrado em `flocksCatalog`.
const AppComponentMeta appButtonsFooterMeta = AppComponentMeta(
  id: 'app_buttons_footer',
  name: 'AppButtonsFooter',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.5.0',
  summary: LocalizedText(
    en: 'Action footer: a primary button + an optional secondary one.',
    pt: 'Rodapé de ações: botão primário + secundário opcional.',
  ),
  description: LocalizedText(
    en: 'Primary and secondary in a row (default) or a column, over the `platform` surface (desktop=surfaceContainer, mobile=surface); rounding by `style` with the global radius. The bottom safe area is added. Colors from the theme.',
    pt:
        'Primário e secundário em linha (default) ou coluna, sobre a superfície '
        'de `platform` (desktop=surfaceContainer, mobile=surface); arredondamento '
        'por `style` com o radius global. Safe-area inferior somada. Cores do tema.',
  ),
  whenToUse: LocalizedList(
    en: <String>['The footer of a form, dialog or sheet with 1–2 actions.'],
    pt: <String>['Rodapé de formulário/dialog/sheet com 1–2 ações.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A bottom navigation bar → AppNavigationFooter.'],
    pt: <String>['Barra de navegação inferior → AppNavigationFooter.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'primary', type: 'Widget', isRequired: true),
    PropMeta(name: 'secondary', type: 'Widget?'),
    PropMeta(name: 'axis', type: 'Axis?'),
    PropMeta(
      name: 'alignment',
      type: 'AppButtonsFooterAlignment?',
      enumValues: <String>['start', 'center', 'end'],
    ),
    PropMeta(
      name: 'platform',
      type: 'AppButtonsPlatformStyle',
      defaultValue: 'AppButtonsPlatformStyle.desktop',
      enumValues: <String>['desktop', 'mobile'],
    ),
    PropMeta(
      name: 'style',
      type: 'AppButtonsFooterStyle',
      defaultValue: 'AppButtonsFooterStyle.page',
      enumValues: <String>['card', 'dialog', 'page', 'sheet'],
    ),
    PropMeta(name: 'constraints', type: 'BoxConstraints?'),
    PropMeta(name: 'decoration', type: 'BoxDecoration?'),
    PropMeta(name: 'padding', type: 'EdgeInsets?'),
  ],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Save/Cancel', pt: 'Salvar/Cancelar'),
      code:
          'AppButtonsFooter(primary: AppButton(...), '
          'secondary: AppButton(style: AppStyle.outlined, ...))',
    ),
  ],
  dos: LocalizedList(
    en: <String>['One primary action; the secondary one at lower emphasis.'],
    pt: <String>['1 ação primária; secundária de menor ênfase.'],
  ),
  donts: LocalizedList(
    en: <String>['Do not put more than 2 buttons in it.'],
    pt: <String>['Não coloque mais de 2 botões.'],
  ),
  a11y: LocalizedText(
    en: 'The actions inherit the semantics of the child buttons.',
    pt: 'As ações herdam a semântica dos botões filhos.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_fill_button', 'app_line_button', 'app_simple_footer'],
);
