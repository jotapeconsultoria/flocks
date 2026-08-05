import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppText]. Registrado em `flocksCatalog`.
const AppComponentMeta appTextMeta = AppComponentMeta(
  id: 'app_text',
  name: 'AppText',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  since: 'flocks@0.1.0',
  summary: LocalizedText(
    en: 'Design system text, theme-adapted and selectable.',
    pt: 'Texto do design system, adaptado ao tema e selecionável.',
  ),
  description: LocalizedText(
    en: 'Wraps the widgets-layer `Text`, applying the theme\'s typography and color (`onSurface` by default) and enabling native mouse selection.',
    pt:
        'Envolve o `Text` da camada widgets aplicando a tipografia e a cor do '
        'tema (`onSurface` por padrão) e habilitando seleção nativa por mouse.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Any UI text: labels, paragraphs, values.'],
    pt: <String>['Qualquer texto de UI: labels, parágrafos, valores.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['Text with multiple inline styles → use AppRichText.'],
    pt: <String>['Texto com múltiplos estilos inline → use AppRichText.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'data',
      type: 'String',
      isRequired: true,
      description: LocalizedText(en: 'The text shown.', pt: 'O texto exibido.'),
    ),
    PropMeta(
      name: 'style',
      type: 'TextStyle?',
      description: LocalizedText(
        en: 'Overrides the style (defaults to the theme\'s bodyMedium).',
        pt: 'Sobrescreve o estilo (default: bodyMedium do tema).',
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
    PropMeta(
      name: 'semanticLabel',
      type: 'String?',
      description: LocalizedText(
        en: 'Accessibility label (defaults to data).',
        pt: 'Label de acessibilidade (default: data).',
      ),
    ),
  ],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Plain', pt: 'Simples'),
      code: "AppText('Placa ABC-1234')",
    ),
    CodeExample(
      title: LocalizedText(en: 'Styled', pt: 'Com estilo'),
      code: "AppText('Título', style: AppTextStyles.titleLarge)",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Let the color come from the theme (do not pass a fixed color).',
    ],
    pt: <String>['Deixe a cor vir do tema (não passe cor fixa).'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for mixed-style text — use AppRichText.'],
    pt: <String>['Não use para texto com estilos mistos — use AppRichText.'],
  ),
  a11y: LocalizedText(
    en: 'Exposes semanticsLabel (defaults to data); the text is selectable and readable by screen readers.',
    pt:
        'Expõe semanticsLabel (default = data); o texto é selecionável e legível '
        'por leitores de tela.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_rich_text', 'app_text_span'],
);
