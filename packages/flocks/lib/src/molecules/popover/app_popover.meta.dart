import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppPopover]. Registrado em `flocksCatalog`.
const AppComponentMeta appPopoverMeta = AppComponentMeta(
  id: 'app_popover',
  name: 'AppPopover',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Rich-content overlay anchored to a trigger (click or hover).',
    pt: 'Overlay de conteúdo rico ancorado a um trigger (clique ou hover).',
  ),
  description: LocalizedText(
    en: 'No Material. Opens a panel (with a title, content and optional actions) anchored to the trigger through a LayerLink (transform-safe), with an arrow pointing at the target. Closes on an outside click or on Esc. Re-provides the theme inside the Overlay.',
    pt:
        'Sem Material. Abre um painel (com título, conteúdo e ações opcionais) '
        'ancorado ao trigger via LayerLink (transform-safe), com seta apontando '
        'para o alvo. Fecha ao clicar fora ou no Esc. Reprovê o tema dentro do '
        'Overlay.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Rich details or help that appear on demand (more than a tooltip).',
      'Small forms or light confirmations anchored to a control.',
    ],
    pt: <String>[
      'Detalhes/ajuda ricos que aparecem sob demanda (mais que um tooltip).',
      'Pequenos formulários ou confirmações leves ancorados a um controle.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Just a short piece of hover text → use AppTooltip.',
      'Selecting from a list of options → use AppDropdown.',
      'A menu\'s list of actions → use AppMenu.',
    ],
    pt: <String>[
      'Só um texto curto de hover → use AppTooltip.',
      'Seleção de uma lista de opções → use AppDropdown.',
      'Lista de ações de um menu → use AppMenu.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'trigger', type: 'Widget', isRequired: true),
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(name: 'title', type: 'String?'),
    PropMeta(name: 'actions', type: 'List<Widget>?'),
    PropMeta(
      name: 'placement',
      type: 'AppOverlayPlacement',
      defaultValue: 'bottomCenter',
      enumValues: <String>[
        'bottomStart',
        'bottomCenter',
        'bottomEnd',
        'topStart',
        'topCenter',
        'topEnd',
      ],
    ),
    PropMeta(name: 'showArrow', type: 'bool', defaultValue: 'true'),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      defaultValue: 'elevated',
      enumValues: <String>['filled', 'outlined', 'elevated'],
      description: LocalizedText(
        en: 'The balloon\'s container; defaults to elevated (it does not follow the global).',
        pt: 'Container do balão; default elevated (não segue o global).',
      ),
    ),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
    PropMeta(name: 'radius', type: 'BorderRadius?'),
    PropMeta(
      name: 'triggerMode',
      type: 'AppPopoverTrigger',
      defaultValue: 'click',
      enumValues: <String>['click', 'hover'],
    ),
    PropMeta(name: 'maxWidth', type: 'double?'),
    PropMeta(name: 'controller', type: 'AppPopoverController?'),
  ],
  states: <String>['closed', 'open'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Help anchored to an icon',
        pt: 'Ajuda ancorada a um ícone',
      ),
      code:
          'AppPopover(trigger: AppIcon(AppIconToken.info), title: "Score", '
          'child: AppText("Combina frenagens, curvas e velocidade."))',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use a passive trigger (an icon, some text); the popover is what makes it actionable.',
    ],
    pt: <String>[
      'Use um trigger passivo (ícone/texto); o popover é quem o torna acionável.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not put essential content only in a hover-mode popover (touch has no hover).',
    ],
    pt: <String>[
      'Não coloque conteúdo essencial só no popover no modo hover (toque não '
          'tem hover).',
    ],
  ),
  a11y: LocalizedText(
    en: 'The panel opens with a fade+pop and honors reduce-motion. Esc closes it. The trigger must carry its own semantics (e.g. an AppIcon with a semanticLabel).',
    pt:
        'O painel abre com fade+pop e respeita reduce-motion. Fecha no Esc. O '
        'trigger deve ter semântica própria (ex.: AppIcon com semanticLabel).',
  ),
  crossPlatform: false,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_tooltip', 'app_card', 'app_menu'],
);
