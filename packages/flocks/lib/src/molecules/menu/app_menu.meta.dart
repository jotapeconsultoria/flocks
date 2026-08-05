import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppMenu]. Registrado em `flocksCatalog`.
const AppComponentMeta appMenuMeta = AppComponentMeta(
  id: 'app_menu',
  name: 'AppMenu',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.4.0',
  summary: LocalizedText(
    en: 'Anchored action menu (popup / context menu), through the Overlay.',
    pt: 'Menu de ações ancorado (popup / context menu), via Overlay.',
  ),
  description: LocalizedText(
    en: 'No Material. A list of actions (AppMenuItem) with an optional icon, sections, dividers and destructive items, anchored to the trigger by a LayerLink. Distinct from AppDropdown (which is a form select).',
    pt:
        'Sem Material. Lista de ações (AppMenuItem) com ícone opcional, seções, '
        'divisórias e itens destrutivos, ancorada ao trigger por LayerLink. '
        'Distinto do AppDropdown (que é um select de formulário).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Contextual actions for an element (edit/duplicate/delete).',
      'An overflow menu (⋯) or a right-click menu.',
    ],
    pt: <String>[
      'Ações contextuais de um elemento (editar/duplicar/excluir).',
      'Menu de overflow (⋯) ou menu de clique-direito.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Choosing a value in a form → use AppDropdown.',
      'Rich content (text, fields) → use AppPopover.',
    ],
    pt: <String>[
      'Escolher um valor de um formulário → use AppDropdown.',
      'Conteúdo rico (texto/campos) → use AppPopover.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'trigger', type: 'Widget', isRequired: true),
    PropMeta(name: 'entries', type: 'List<AppMenuEntry>', isRequired: true),
    PropMeta(
      name: 'placement',
      type: 'AppOverlayPlacement',
      defaultValue: 'bottomStart',
    ),
    PropMeta(name: 'openOnSecondaryTap', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'minWidth', type: 'double', defaultValue: '176'),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      defaultValue: 'elevated',
      enumValues: <String>['filled', 'outlined', 'elevated'],
      description: LocalizedText(
        en: 'The panel\'s container; defaults to elevated (it does not follow the global).',
        pt: 'Container do painel; default elevated (não segue o global).',
      ),
    ),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
    PropMeta(name: 'radius', type: 'BorderRadius?'),
    PropMeta(name: 'controller', type: 'AppMenuController?'),
    PropMeta(name: 'onOpenChanged', type: 'ValueChanged<bool>?'),
  ],
  states: <String>['closed', 'open'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Action menu with a destructive item',
        pt: 'Menu de ações com item destrutivo',
      ),
      code:
          'AppMenu(trigger: AppIcon(AppIconToken.settings), entries: <AppMenuEntry>['
          'AppMenuItem(label: "Editar", onPressed: edit), AppMenuDivider(), '
          'AppMenuItem(label: "Excluir", danger: true, onPressed: remove)])',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use a passive trigger; mark destructive actions with danger.',
    ],
    pt: <String>[
      'Use um trigger passivo; marque ações destrutivas com danger.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it as a form select (that is AppDropdown).'],
    pt: <String>['Não use como select de formulário (isso é o AppDropdown).'],
  ),
  a11y: LocalizedText(
    en: 'Each item is a button (AppSemantics.menuItem) that merges icon and text. Navigation with Tab and the ↑/↓ arrows; Esc closes it. The panel enters with a fade+pop that honors reduce-motion.',
    pt:
        'Cada item é um botão (AppSemantics.menuItem) com merge de ícone+texto. '
        'Navegação por Tab e setas ↑/↓; fecha no Esc. O painel entra com fade+pop '
        'respeitando reduce-motion.',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_dropdown', 'app_popover', 'app_split_button'],
);
