import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppChartShell]. Registrado em `flocksCatalog`.
const AppComponentMeta appChartShellMeta = AppComponentMeta(
  id: 'app_chart_shell',
  name: 'AppChartShell',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Chart frame: title, legend and states.',
    pt: 'Moldura de gráfico: título, legenda e estados.',
  ),
  description: LocalizedText(
    en: 'Title, subtitle, summary, legend and the loading and empty states around the plot area. It is a content card: it follows the global style (AppStyle) and shape axes, like AppCard.',
    pt: 'Título, subtítulo, resumo, legenda e os estados de carregando e vazio em volta da área de plotagem. É um cartão de conteúdo: segue os eixos globais de estilo (AppStyle) e de forma, como o AppCard.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Giving a chart its chrome (title, legend, empty, loading).'],
    pt: <String>[
      'Dar cromo a um gráfico (título, legenda, vazio, carregando).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A bare chart inside a card that already has a title.'],
    pt: <String>['Gráfico solto dentro de um card que já tem título.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'child', type: 'Widget', isRequired: true),
    PropMeta(name: 'title', type: 'String?'),
    PropMeta(name: 'subtitle', type: 'String?'),
    PropMeta(name: 'summary', type: 'Widget?'),
    PropMeta(name: 'legendItems', type: 'List<AppChartLegendItem>'),
    PropMeta(name: 'onLegendTap', type: 'void Function(AppChartLegendItem)?'),
    PropMeta(name: 'isEmpty', type: 'bool'),
    PropMeta(name: 'isLoading', type: 'bool'),
    PropMeta(name: 'emptyChild', type: 'Widget?'),
    PropMeta(name: 'expandChart', type: 'bool'),
    PropMeta(name: 'chartConstraints', type: 'BoxConstraints'),
    PropMeta(name: 'constraints', type: 'BoxConstraints?'),
    PropMeta(name: 'style', type: 'AppStyle?'),
  ],
  states: <String>['default', 'loading', 'empty'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Frame with a title', pt: 'Moldura com título'),
      code: 'AppChartShell(title: "Consumo", child: chart)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use the legend to name the series — color alone carries nothing.',
    ],
    pt: <String>[
      'Use a legenda para nomear as séries — a cor sozinha não informa.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not repeat the card\'s title in the frame.'],
    pt: <String>['Não repita o título do card na moldura.'],
  ),
  a11y: LocalizedText(
    en: 'Legend items are keyboard-navigable toggles whose state is announced.',
    pt: 'Itens de legenda são toggles navegáveis por teclado, com estado anunciado.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_bar_chart', 'app_line_chart'],
);
