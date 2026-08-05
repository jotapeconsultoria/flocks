import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppAvatar]. Registrado em `flocksCatalog`.
const AppComponentMeta appAvatarMeta = AppComponentMeta(
  id: 'app_avatar',
  name: 'AppAvatar',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  since: 'flocks@0.2.0',
  summary: LocalizedText(
    en: 'Circular avatar with a network image and a fallback (text or icon).',
    pt: 'Avatar circular com imagem de rede e fallback (texto ou ícone).',
  ),
  description: LocalizedText(
    en: 'Loads the image through Image.network (an AppCircularLoading spinner while it downloads) and falls back to text/icon when the URL is empty or fails.',
    pt:
        'Carrega a imagem via Image.network (spinner AppCircularLoading enquanto '
        'baixa) e cai no fallback textual/ícone quando a URL é vazia ou falha.',
  ),
  whenToUse: LocalizedList(
    en: <String>['A user\'s or entity\'s photo in lists, headers and menus.'],
    pt: <String>['Foto de usuário/entidade em listas, cabeçalhos e menus.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A plain icon that does not stand for a person → AppIcon.'],
    pt: <String>['Ícone puro sem representar pessoa → AppIcon.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'size',
      type: 'AppAvatarSize',
      defaultValue: 'AppAvatarSize.m',
      enumValues: <String>['s', 'm', 'l', 'xl'],
      description: LocalizedText(
        en: 'Diameter derived from the text (grows with text-scale). Use AppAvatar.custom(diameter:) for exact pixels.',
        pt:
            'Diâmetro derivado do texto (cresce com o text-scale). '
            'Use AppAvatar.custom(diameter:) para pixels exatos.',
      ),
    ),
    PropMeta(name: 'imageUrl', type: 'String?'),
    PropMeta(name: 'fallback', type: 'String?'),
    PropMeta(name: 'semanticLabel', type: 'String?'),
    PropMeta(name: 'onTap', type: 'VoidCallback?'),
    PropMeta(
      name: 'effect',
      type: 'AppAvatarEffect',
      defaultValue: 'AppAvatarEffect.scale',
      enumValues: <String>['none', 'scale', 'lift'],
    ),
    PropMeta(
      name: 'statesController',
      type: 'FlocksStatesController?',
      description: LocalizedText(
        en: 'Drives states manually (e.g. dragged inside a Draggable). Only with onTap.',
        pt:
            'Dirige estados manualmente (ex.: dragged num Draggable). '
            'Só com onTap.',
      ),
    ),
  ],
  states: <String>[
    'image',
    'loading',
    'fallback-text',
    'fallback-icon',
    'hovered',
    'pressed',
    'focused',
    'dragged',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'With fallback', pt: 'Com fallback'),
      code: 'AppAvatar(size: AppAvatarSize.m, imageUrl: url, fallback: "JP")',
    ),
    CodeExample(
      title: LocalizedText(en: 'Exact diameter', pt: 'Diâmetro exato'),
      code: 'AppAvatar.custom(diameter: 120, imageUrl: url, fallback: "JP")',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Pass semanticLabel (the name) when the avatar is the only cue.',
    ],
    pt: <String>[
      'Passe semanticLabel (nome) quando o avatar for a única pista.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not use it for decorative icons with no person behind them.',
    ],
    pt: <String>['Não use para ícones decorativos sem pessoa.'],
  ),
  a11y: LocalizedText(
    en: 'Always labelled (image/button semantics). Effective label: semanticLabel › fallback text › "Avatar".',
    pt:
        'Sempre rotulado (semântica de imagem/botão). Rótulo efetivo: '
        'semanticLabel › texto do fallback › "Avatar".',
  ),
  crossPlatform: true,
  themeAware: true,
  // Escala/sombra (hover/press/dragged) e o spinner de loading são gated por
  // AppMotion; o anel de foco e o realce (UX) permanecem com movimento off.
  reducesMotion: true,
  related: <String>['app_icon', 'app_circular_loading', 'app_text'],
);
