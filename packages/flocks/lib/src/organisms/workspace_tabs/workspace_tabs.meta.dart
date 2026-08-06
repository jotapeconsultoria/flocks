import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppWorkspaceTabs]. Registrado em `flocksCatalog`.
const AppComponentMeta appWorkspaceTabsMeta = AppComponentMeta(
  id: 'app_workspace_tabs',
  name: 'AppWorkspaceTabs',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Browser-style tab bar (icon + title + close).',
    pt: 'Barra de abas estilo navegador (ícone + título + fechar).',
  ),
  description: LocalizedText(
    en: 'The desktop workspace\'s "browser-like" tab strip: tabs with an icon, a title and a close button. A **controlled** component (state lives outside). Only the active tab has a fill (a `tertiary` tone), with rounded top corners. Colors 100% from the theme; hover and fade on motion tokens (reduce-motion).',
    pt:
        'Tab strip "browser-like" do workspace desktop: abas com ícone, título e '
        'botão de fechar. Componente **controlado** (estado fora). Só a aba ativa '
        'tem preenchimento (tom `tertiary`), cantos arredondados no topo. Cores '
        '100% do tema; hover/fade via tokens de motion (reduce-motion).',
  ),
  whenToUse: LocalizedList(
    en: <String>['Workspace tabs on desktop (open/close/select).'],
    pt: <String>['Abas de workspace no desktop (abrir/fechar/selecionar).'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Content tabs within a section → AppTabView.'],
    pt: <String>['Abas de conteúdo de uma seção → AppTabView.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'tabs', type: 'List<AppWorkspaceTabItem>', isRequired: true),
    PropMeta(name: 'activeId', type: 'String?', isRequired: true),
    PropMeta(name: 'onSelect', type: 'ValueChanged<String>', isRequired: true),
    PropMeta(name: 'onClose', type: 'ValueChanged<String>', isRequired: true),
    PropMeta(name: 'decoration', type: 'BoxDecoration?'),
  ],
  states: <String>['tab-active', 'tab-inactive', 'tab-hovered'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Workspace tabs', pt: 'Abas do workspace'),
      code:
          'AppWorkspaceTabs(tabs: tabs, activeId: active, '
          'onSelect: cubit.select, onClose: cubit.close)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Keep the tabs\' state outside (a controlled component).'],
    pt: <String>['Mantenha o estado das abas fora (componente controlado).'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for content tabs (AppTabView).'],
    pt: <String>['Não use para abas de conteúdo (AppTabView).'],
  ),
  a11y: LocalizedText(
    en: 'The active tab is highlighted by color (tertiary, from the theme, AA). The close button has its own touch target.',
    pt:
        'A aba ativa é destacada por cor (tertiary, do tema, AA). O botão de '
        'fechar tem alvo de toque próprio.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_tab_view'],
);
