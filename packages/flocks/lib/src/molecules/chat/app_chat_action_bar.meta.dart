import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppChatActionBar`. Registrado em `flocksCatalog`.
const AppComponentMeta appChatActionBarMeta = AppComponentMeta(
  id: 'app_chat_action_bar',
  name: 'AppChatActionBar',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@1.1.0',
  summary: LocalizedText(
    en: 'Row of icon actions for a message (copy/like/…).',
    pt: 'Linha de ações-ícone de uma mensagem (copiar/like/…).',
  ),
  description: LocalizedText(
    en: 'Actions under a reply: each AppChatAction becomes an AppInteraction (hover/press/focus, tooltip, button semantics). The active state tints the icon with the secondary role.',
    pt:
        'Ações abaixo de uma resposta: cada AppChatAction vira um AppInteraction '
        '(hover/press/foco, tooltip, semântica de botão). O estado ativo tinge o '
        'ícone pelo papel secondary.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Actions on the assistant\'s reply (copy, regenerate, feedback).',
    ],
    pt: <String>[
      'Ações da resposta do assistente (copiar, regenerar, feedback).',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'actions', type: 'List<AppChatAction>', isRequired: true),
    PropMeta(name: 'color', type: 'Color?'),
    PropMeta(
      name: 'iconSize',
      type: 'AppIconSize',
      defaultValue: 'AppIconSize.s',
    ),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Actions under the reply',
        pt: 'Ações abaixo da resposta',
      ),
      code:
          'AppChatActionBar(\n  actions: <AppChatAction>[\n    AppChatAction(icon: AppIconToken.copy, label: \'Copiar\', onPressed: _copy),\n    AppChatAction(icon: AppIconToken.refresh, label: \'Regenerar\', onPressed: _retry),\n  ],\n)',
    ),
  ],
  a11y: LocalizedText(
    en: 'Each action is a labelled button with a tooltip.',
    pt: 'Cada ação é um botão rotulado com tooltip.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
);
