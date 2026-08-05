import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppRichText]. Registrado em `flocksCatalog`.
const AppComponentMeta appRichTextMeta = AppComponentMeta(
  id: 'app_rich_text',
  name: 'AppRichText',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  since: 'flocks@0.1.0',
  summary: LocalizedText(
    en: 'Text with multiple inline styles, theme-adapted and selectable.',
    pt: 'Texto com múltiplos estilos inline, adaptado ao tema e selecionável.',
  ),
  description: LocalizedText(
    en: 'Wraps the widgets-layer `Text.rich` to compose inline styles (bold, color, link) from an `AppTextSpan`, enabling native mouse selection. The styles come from the caller — derive them from the theme.',
    pt:
        'Envolve o `Text.rich` da camada widgets para compor estilos inline '
        '(negrito, cor, link) a partir de um `AppTextSpan`, habilitando seleção '
        'nativa por mouse. Os estilos vêm do chamador — derive-os do tema.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Sentences with pointed emphasis: a highlighted value, a bold word, an inline link.',
    ],
    pt: <String>[
      'Frases com ênfase pontual: valor destacado, palavra em negrito, link inline.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Text in a single style → use AppText.'],
    pt: <String>['Texto de estilo único → use AppText.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'data',
      type: 'AppTextSpan',
      isRequired: true,
      description: LocalizedText(
        en: 'The root span with a base `style` and styled `children`.',
        pt: 'O span raiz com `style` base e `children` estilizados.',
      ),
    ),
    PropMeta(name: 'maxLines', type: 'int?'),
    PropMeta(
      name: 'overflow',
      type: 'TextOverflow',
      defaultValue: 'TextOverflow.clip',
    ),
    PropMeta(
      name: 'textAlign',
      type: 'TextAlign',
      defaultValue: 'TextAlign.start',
    ),
    PropMeta(name: 'softWrap', type: 'bool', defaultValue: 'true'),
    PropMeta(
      name: 'semanticLabel',
      type: 'String?',
      description: LocalizedText(
        en: 'Accessibility label (defaults to data.text).',
        pt: 'Label de acessibilidade (default: data.text).',
      ),
    ),
  ],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Inline emphasis', pt: 'Destaque inline'),
      code:
          'AppRichText(AppTextSpan(style: base, children: <TextSpan>['
          "const TextSpan(text: 'Speed: '), "
          "TextSpan(text: '92 km/h', style: base.bold)]))",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Derive the colors and styles from the theme (do not hardcode a color in the spans).',
    ],
    pt: <String>[
      'Derive as cores/estilos do tema (não embuta cor fixa nos spans).',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for single-style text — use AppText.'],
    pt: <String>['Não use para texto de estilo único — use AppText.'],
  ),
  a11y: LocalizedText(
    en: 'Exposes semanticLabel (defaults to data.text); pass it explicitly when the root span has no text. The text is selectable and readable by screen readers.',
    pt:
        'Expõe semanticLabel (default = data.text); passe-o explícito quando o '
        'span-raiz não tiver text. O texto é selecionável e legível por leitores '
        'de tela.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_text', 'app_text_span'],
);
