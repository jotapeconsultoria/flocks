import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppDivider]. Registrado em `flocksCatalog`.
const AppComponentMeta appDividerMeta = AppComponentMeta(
  id: 'app_divider',
  name: 'AppDivider',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Thin rule that separates content, adapted to the theme.',
    pt: 'Régua fina que separa conteúdo, adaptada ao tema.',
  ),
  description: LocalizedText(
    en: 'Horizontal or vertical hairline whose color comes from the theme (`outline` by default). Fills the cross axis of a bounded parent and is decorative (outside the semantics tree).',
    pt:
        'Linha hairline horizontal ou vertical com cor vinda do tema (`outline` '
        'por padrão). Preenche o eixo cruzado de um pai de dimensão limitada e é '
        'decorativa (fora da semântica).',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Separating sections of a list or column (horizontal).',
      'Separating items in a bar or row (vertical, AppDivider.vertical).',
    ],
    pt: <String>[
      'Separar seções de uma lista/coluna (horizontal).',
      'Separar itens numa barra/linha (vertical, AppDivider.vertical).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'As a container\'s border → use BoxDecoration.border.',
      'For spacing with no line → use SizedBox/AppSpacings.',
    ],
    pt: <String>[
      'Como borda de um container → use BoxDecoration.border.',
      'Para espaçamento sem linha → use SizedBox/AppSpacings.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'thickness',
      type: 'double',
      defaultValue: 'AppStrokes.s',
      description: LocalizedText(
        en: 'Line thickness (an AppStrokes token).',
        pt: 'Espessura da linha (token de AppStrokes).',
      ),
    ),
    PropMeta(
      name: 'indent',
      type: 'double',
      defaultValue: '0',
      description: LocalizedText(
        en: 'Inset before the line (left/top).',
        pt: 'Recuo antes da linha (esquerda/topo).',
      ),
    ),
    PropMeta(
      name: 'endIndent',
      type: 'double',
      defaultValue: '0',
      description: LocalizedText(
        en: 'Inset after the line (right/bottom).',
        pt: 'Recuo depois da linha (direita/base).',
      ),
    ),
    PropMeta(
      name: 'color',
      type: 'Color?',
      description: LocalizedText(
        en: 'Overrides the color (default: theme.colorTheme.outline).',
        pt: 'Sobrescreve a cor (default: theme.colorTheme.outline).',
      ),
    ),
    PropMeta(
      name: 'radius',
      type: 'double?',
      description: LocalizedText(
        en: 'End-cap radius (default: the global radius in round mode, clamped to the thickness).',
        pt:
            'Raio das pontas (default: radius global no modo redondo, '
            'clampado à espessura).',
      ),
    ),
  ],
  variants: <String>['horizontal', 'vertical'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Between rows', pt: 'Entre linhas'),
      code: 'AppDivider(indent: 8, endIndent: 8)',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Vertical inside a bar',
        pt: 'Vertical numa barra',
      ),
      code: 'SizedBox(height: 16, child: AppDivider.vertical())',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Let the color come from the theme (outline).'],
    pt: <String>['Deixe a cor vir do tema (outline).'],
  ),
  donts: LocalizedList(
    en: <String>['Do not use it as a card border; do not hardcode a color.'],
    pt: <String>['Não use como borda de card; não embuta cor fixa.'],
  ),
  a11y: LocalizedText(
    en: 'Decorative: excluded from the semantics tree (AppSemantics.decorative), never read by screen readers.',
    pt:
        'Decorativo: excluído da árvore de semântica (AppSemantics.decorative), '
        'não é lido por leitores de tela.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_text'],
);
