import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppQuestionCard`. Registrado em `flocksCatalog`.
const AppComponentMeta appQuestionCardMeta = AppComponentMeta(
  id: 'app_question_card',
  name: 'AppQuestionCard',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@1.1.0',
  summary: LocalizedText(
    en: 'Inline question card: confirmation, single choice or multiple choice.',
    pt: 'Card de pergunta inline: confirmação, escolha única ou múltipla.',
  ),
  description: LocalizedText(
    en: 'The AI asks the user for something and gets the answer inline. Three kinds: confirmation (detail + confirm/cancel — it generalizes the pending-action card), singleChoice (up to 3 radio options + a free answer) and multipleChoice (up to 3 checkbox options + a free answer). Tinted by role (info/warning/danger/success).',
    pt:
        'A IA pede algo ao usuário e recebe a resposta inline. Três tipos: '
        'confirmation (detalhe + confirmar/cancelar — generaliza o card de ação '
        'pendente), singleChoice (até 3 opções em radio + resposta livre) e '
        'multipleChoice (até 3 opções em checkbox + resposta livre). Tingido por '
        'papel (info/warning/danger/success).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Confirming an action or tool call from the AI.',
      'Asking the user for a choice (one or several) inside the chat flow.',
    ],
    pt: <String>[
      'Confirmar uma ação/tool-call da IA.',
      'Pedir uma escolha (uma ou várias) ao usuário no fluxo do chat.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A notice with no answer → use AppAlert.'],
    pt: <String>['Aviso sem resposta → use AppAlert.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'subtitle', type: 'String?'),
    PropMeta(
      name: 'role',
      type: 'AppQuestionCardRole',
      enumValues: <String>['info', 'warning', 'danger', 'success'],
    ),
    PropMeta(
      name: 'detail',
      type: 'Widget?',
      description: LocalizedText(en: 'confirmation', pt: 'confirmation'),
    ),
    PropMeta(
      name: 'onConfirm',
      type: 'VoidCallback?',
      description: LocalizedText(en: 'confirmation', pt: 'confirmation'),
    ),
    PropMeta(
      name: 'onCancel',
      type: 'VoidCallback?',
      description: LocalizedText(en: 'confirmation', pt: 'confirmation'),
    ),
    PropMeta(
      name: 'options',
      type: 'List<String>',
      description: LocalizedText(en: 'choice (max 3)', pt: 'choice (máx 3)'),
    ),
    PropMeta(name: 'allowCustom', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'onSingleSelected', type: 'ValueChanged<String>?'),
    PropMeta(name: 'onMultipleSubmit', type: 'ValueChanged<List<String>>?'),
  ],
  variants: <String>['confirmation', 'singleChoice', 'multipleChoice'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Confirming a destructive action',
        pt: 'Confirmar uma ação destrutiva',
      ),
      code:
          'AppQuestionCard.confirmation(\n  title: \'Apagar a rota?\',\n  role: AppQuestionCardRole.danger,\n  onConfirm: _delete,\n)',
    ),
    CodeExample(
      title: LocalizedText(en: 'Single choice', pt: 'Escolha única'),
      code:
          'AppQuestionCard.singleChoice(\n  title: \'Qual conta usar?\',\n  options: accounts,\n  onSubmit: _pick,\n)',
    ),
  ],
  a11y: LocalizedText(
    en: 'Design system radios/checkboxes and buttons (labelled, keyboard-ready).',
    pt: 'Radios/checkboxes e botões do DS (rotulados, teclado).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
);
