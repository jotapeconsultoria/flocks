import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSnackbar]. Registrado em `flocksCatalog`.
const AppComponentMeta appSnackbarMeta = AppComponentMeta(
  id: 'app_snackbar',
  name: 'AppSnackbar',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Temporary feedback card (success/error/info/warning).',
    pt: 'Card de feedback temporário (sucesso/erro/info/aviso).',
  ),
  description: LocalizedText(
    en: 'A card with a description, an optional title and a semantic icon (error/info/success/warning) over a surfaceContainer tinted by the kind\'s color. With no title it is the one-line toast most screens want. The container follows the AppStyle axis (`elevated` by default); the shape follows the radius axis. Show it through `showAppSnackbar` (auto-dismiss, single instance, slide-in; `position` picks the corner, bottom-right by default). Colors 100% from the theme; announced (liveRegion).',
    pt:
        'Card com descrição, título opcional e ícone semântico '
        '(error/info/success/warning) sobre surfaceContainer tingido pela cor do '
        'tipo. Sem título é o toast de uma frase que a maioria das telas quer. '
        'Container segue o eixo AppStyle (default `elevated`); forma pelo eixo '
        'de raio. Exiba via `showAppSnackbar` (auto-dismiss, instância única, '
        'slide-in; `position` escolhe o canto, inferior direito por padrão). '
        'Cores 100% do tema; anunciado (liveRegion).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Confirming a quick action (saved, deleted) without blocking the flow.',
      'Warning about a transient operation error.',
    ],
    pt: <String>[
      'Confirmar uma ação rápida (salvo, excluído) sem bloquear o fluxo.',
      'Avisar de um erro transitório de operação.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Feedback that requires acknowledgement or an action → AppDialog.',
      'A persistent inline notice on the page → AppAlert.',
    ],
    pt: <String>[
      'Feedback que exige reconhecimento/ação → AppDialog.',
      'Aviso inline persistente na página → AppAlert.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'title',
      type: 'String?',
      description: LocalizedText(
        en: 'Optional heading. Null renders the one-line toast: the title row disappears and the icon centers with the message.',
        pt: 'Título opcional. Nulo vira o toast de uma frase: a linha do título some e o ícone centraliza com a mensagem.',
      ),
    ),
    PropMeta(name: 'description', type: 'String', isRequired: true),
    PropMeta(
      name: 'type',
      type: 'AppSnackbarType',
      defaultValue: 'AppSnackbarType.info',
      description: LocalizedText(
        en: 'Semantic kind (color + icon). Errors MUST pass error explicitly: color and icon are the only failure signal.',
        pt: 'Tipo semântico (cor + ícone). Erro DEVE passar error explicitamente: cor e ícone são o único sinal da falha.',
      ),
      enumValues: <String>['error', 'info', 'success', 'warning'],
    ),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      defaultValue: 'AppStyle.elevated',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
  ],
  variants: <String>['error', 'info', 'success', 'warning'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Success', pt: 'Sucesso'),
      code:
          "showAppSnackbar(context: context, title: 'Salvo', "
          "description: '...', type: AppSnackbarType.success)",
    ),
    CodeExample(
      title: LocalizedText(en: 'One-line toast', pt: 'Toast de uma frase'),
      code: "showAppSnackbar(context: context, description: 'Link copiado.')",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Short messages; the card disappears on its own after the duration.',
      'Use the kind that matches the message (error/info/success/warning).',
    ],
    pt: <String>[
      'Mensagens curtas; o card some sozinho após a duração.',
      'Use o tipo que casa com a mensagem (error/info/success/warning).',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not stack several snackbars (a new one replaces the previous).',
      'Do not leave an error on the default kind — pass AppSnackbarType.error.',
    ],
    pt: <String>[
      'Não empilhe várias snackbars (a nova substitui a anterior).',
      'Não deixe erro no tipo default — passe AppSnackbarType.error.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Wrapped in AppSemantics.liveRegion → announced when it appears, with or without a title. Title in onSurface and description in neutral s700 over the tinted background both pass AA (a title-less message uses onSurface); border and icon (semantic color) ≥ 3:1.',
    pt:
        'Embrulhado em AppSemantics.liveRegion → anunciado ao surgir, com ou sem '
        'título. Título onSurface e descrição neutro s700 sobre o fundo tingido '
        'passam AA (mensagem sem título usa onSurface); borda e ícone (cor '
        'semântica) ≥ 3:1.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_alert', 'app_dialog'],
);
