import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSwatch]. Registrado em `flocksCatalog`.
const AppComponentMeta appSwatchMeta = AppComponentMeta(
  id: 'app_swatch',
  name: 'AppSwatch',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Color swatch (rounded square or circle).',
    pt: 'Amostra de cor (quadrado arredondado ou círculo).',
  ),
  description: LocalizedText(
    en: 'Reusable leaf for showing a color in lists, grids and the color picker. A subtle border (outline) keeps light colors readable; square uses the global radius.',
    pt:
        'Folha reusável para exibir uma cor em listas, grids e no color picker. '
        'Borda sutil (outline) destaca cores claras; square usa o radius global.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Showing a color: a picker, a chart legend, a vehicle color, a palette.',
    ],
    pt: <String>[
      'Mostrar uma cor: seletor, legenda de gráfico, cor de veículo, paleta.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A status label → AppBadge.', 'An icon → AppIcon.'],
    pt: <String>['Rótulo de status → AppBadge.', 'Ícone → AppIcon.'],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'color',
      type: 'Color',
      isRequired: true,
      description: LocalizedText(en: 'The color shown.', pt: 'Cor exibida.'),
    ),
    PropMeta(name: 'size', type: 'double', defaultValue: '20'),
    PropMeta(
      name: 'shape',
      type: 'AppSwatchShape',
      defaultValue: 'AppSwatchShape.square',
      enumValues: <String>['square', 'circle'],
    ),
    PropMeta(
      name: 'borderColor',
      type: 'Color?',
      description: LocalizedText(
        en: 'Defaults to theme.colorTheme.outline.',
        pt: 'Default theme.colorTheme.outline.',
      ),
    ),
    PropMeta(name: 'semanticLabel', type: 'String?'),
  ],
  variants: <String>['square', 'circle'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'With label', pt: 'Com rótulo'),
      code: "AppSwatch(color: Color(0xFF1E88E5), semanticLabel: 'Azul')",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Pass semanticLabel with the name/hex when the color carries meaning.',
    ],
    pt: <String>[
      'Passe semanticLabel com o nome/hex quando a cor tiver sentido.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it for textual status — that is AppBadge.'],
    pt: <String>['Não use para status textual — é AppBadge.'],
  ),
  a11y: LocalizedText(
    en: 'semanticLabel==null → decorative; otherwise AppSemantics.label. Color must not be the only channel carrying information.',
    pt:
        'semanticLabel==null → decorativo; senão AppSemantics.label. Cor não deve '
        'ser o único canal de informação.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_badge', 'app_icon'],
);
