import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSnackbar]. Registrado em `flocksCatalog`.
const AppComponentMeta appSnackbarMeta = AppComponentMeta(
  id: 'app_snackbar',
  name: 'AppSnackbar',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.6.0',
  summary: LocalizedText(
    en: 'Temporary feedback card (success/error/info).',
    pt: 'Card de feedback temporário (sucesso/erro/info).',
  ),
  description: LocalizedText(
    en: 'A card with a title, a description and a semantic icon (error/info/success) over a surfaceContainer tinted by the kind\'s color. The container follows the AppStyle axis (`elevated` by default); the shape follows the radius axis. Show it through `showAppSnackbar` (bottom-right corner, auto-dismiss, single instance, slide-in). Colors 100% from the theme; announced (liveRegion).',
    pt:
        'Card com título, descrição e ícone semântico (error/info/success) sobre '
        'surfaceContainer tingido pela cor do tipo. Container segue o eixo '
        'AppStyle (default `elevated`); forma pelo eixo de raio. Exiba via '
        '`showAppSnackbar` (canto inferior direito, auto-dismiss, instância '
        'única, slide-in). Cores 100% do tema; anunciado (liveRegion).',
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
    PropMeta(name: 'title', type: 'String', isRequired: true),
    PropMeta(name: 'description', type: 'String', isRequired: true),
    PropMeta(
      name: 'type',
      type: 'AppSnackbarType',
      isRequired: true,
      enumValues: <String>['error', 'info', 'success'],
    ),
    PropMeta(
      name: 'style',
      type: 'AppStyle?',
      defaultValue: 'AppStyle.elevated',
      enumValues: <String>['filled', 'outlined', 'elevated'],
    ),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
  ],
  variants: <String>['error', 'info', 'success'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Success', pt: 'Sucesso'),
      code:
          "showAppSnackbar(context: context, title: 'Salvo', "
          "description: '...', type: AppSnackbarType.success)",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Short messages; the card disappears on its own after the duration.',
      'Use the kind that matches the message (error/info/success).',
    ],
    pt: <String>[
      'Mensagens curtas; o card some sozinho após a duração.',
      'Use o tipo que casa com a mensagem (error/info/success).',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not stack several snackbars (a new one replaces the previous).',
    ],
    pt: <String>['Não empilhe várias snackbars (a nova substitui a anterior).'],
  ),
  a11y: LocalizedText(
    en: 'Wrapped in AppSemantics.liveRegion → announced when it appears. Title in onSurface and description in neutral s700 over the tinted background both pass AA; border and icon (semantic color) ≥ 3:1.',
    pt:
        'Embrulhado em AppSemantics.liveRegion → anunciado ao surgir. Título '
        'onSurface e descrição neutro s700 sobre o fundo tingido passam AA; borda '
        'e ícone (cor semântica) ≥ 3:1.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_alert', 'app_dialog'],
);
