import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppInteraction]. Registrado em `flocksCatalog`.
const AppComponentMeta appInteractionMeta = AppComponentMeta(
  id: 'app_interaction',
  name: 'AppInteraction',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@0.4.0',
  summary: LocalizedText(
    en: 'Interaction wrapper (InkWell-like) that makes any widget clickable.',
    pt: 'Wrapper de interação (tipo InkWell) para tornar qualquer widget clicável.',
  ),
  description: LocalizedText(
    en: 'Wraps any child with gestures (tap/double-tap/long-press), states (hover/focus/press/disabled + keyboard), a background highlight, a preset micro-animation, a loading state and an optional tooltip — all driven by tokens and by reduce-motion. Replaces the old AppTextButton/AppIconButton.',
    pt:
        'Envolve qualquer child com gestos (tap/double-tap/long-press), estados '
        '(hover/foco/press/disabled + teclado), realce de fundo, uma micro-animação '
        'pré-setada, loading e tooltip opcional — tudo dirigido por tokens e '
        'reduce-motion. Substitui os antigos AppTextButton/AppIconButton.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Making an icon, a piece of text or a card clickable with standard hover/press/tooltip.',
      'Replacing "clickable text"/"clickable icon" (the former AppTextButton/AppIconButton).',
    ],
    pt: <String>[
      'Tornar clicável um ícone, texto ou card com hover/press/tooltip padrão.',
      'Substituir "texto clicável"/"ícone clicável" (ex-AppTextButton/AppIconButton).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A primary action with a background and a label → use AppButton.',
    ],
    pt: <String>['Ação primária com fundo/rótulo → use AppButton.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'child',
      type: 'Widget',
      isRequired: true,
      description: LocalizedText(
        en: 'Content made interactive.',
        pt: 'Conteúdo tornado interativo.',
      ),
    ),
    PropMeta(name: 'onTap', type: 'VoidCallback?'),
    PropMeta(name: 'onDoubleTap', type: 'VoidCallback?'),
    PropMeta(name: 'onLongPress', type: 'VoidCallback?'),
    PropMeta(
      name: 'tooltip',
      type: 'String?',
      description: LocalizedText(
        en: 'Tooltip text on hover/focus (null = none).',
        pt: 'Texto do tooltip no hover/foco (null = sem).',
      ),
    ),
    PropMeta(
      name: 'motion',
      type: 'AppMotionPreset',
      defaultValue: 'AppMotionPreset.scale',
      description: LocalizedText(
        en: 'Hover/press micro-animation.',
        pt: 'Micro-animação de hover/press.',
      ),
      enumValues: <String>['none', 'scale', 'lift', 'pop', 'rotate'],
    ),
    PropMeta(
      name: 'highlight',
      type: 'bool',
      defaultValue: 'true',
      description: LocalizedText(
        en: 'Translucent background highlight on hover/press.',
        pt: 'Realce de fundo translúcido no hover/press.',
      ),
    ),
    PropMeta(
      name: 'radius',
      type: 'BorderRadius?',
      description: LocalizedText(
        en: 'Radius of the highlight and focus ring (default: the global radius, round mode).',
        pt: 'Raio do realce/anel de foco (default: radius global, modo redondo).',
      ),
    ),
    PropMeta(
      name: 'padding',
      type: 'EdgeInsetsGeometry',
      defaultValue: 'EdgeInsets.zero',
      description: LocalizedText(
        en: 'Inner gap between the highlight and the child.',
        pt: 'Folga interna entre realce e child.',
      ),
    ),
    PropMeta(
      name: 'enabled',
      type: 'bool',
      defaultValue: 'true',
      description: LocalizedText(
        en: 'When false, it does not react and dims the child.',
        pt: 'Quando false, não reage e esmaece o child.',
      ),
    ),
    PropMeta(
      name: 'loading',
      type: 'bool',
      defaultValue: 'false',
      description: LocalizedText(
        en: 'Blocks interaction and shows a spinner over the child.',
        pt: 'Bloqueia a interação e mostra um spinner sobre o child.',
      ),
    ),
    PropMeta(name: 'semanticLabel', type: 'String?'),
  ],
  variants: <String>['none', 'scale', 'lift', 'pop', 'rotate'],
  states: <String>['hovered', 'focused', 'pressed', 'disabled', 'loading'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Clickable icon with a tooltip',
        pt: 'Ícone clicável com tooltip',
      ),
      code:
          "AppInteraction(tooltip: 'Adicionar', onTap: add, "
          'padding: const EdgeInsets.all(AppSpacings.s8), child: AppIcon(AppIconToken.plus))',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use it to give icons and text a standard click, hover and tooltip.',
      'Add padding for the feel of an icon button.',
    ],
    pt: <String>[
      'Use para dar clique/hover/tooltip padrão a ícones e textos.',
      'Adicione padding para o feel de botão de ícone.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not use it for a primary action with a background and a label — use AppButton.',
    ],
    pt: <String>[
      'Não use para ação primária com fundo/rótulo — use AppButton.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Applies a button role (AppSemantics.button) with a semanticLabel; activation with Enter/Space when focused; a focus ring on the highlight. Focus disappears on touch (FocusHighlightMode).',
    pt:
        'Aplica role de botão (AppSemantics.button) com semanticLabel; ativação '
        'por Enter/Space quando focado; anel de foco no highlight. O foco some no '
        'toque (FocusHighlightMode).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_scale_on_tap',
    'app_interactive_motion',
    'app_tooltip',
  ],
);
