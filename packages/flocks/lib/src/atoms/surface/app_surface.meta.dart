import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppSurface]. Registrado em `flocksCatalog`.
const AppComponentMeta appSurfaceMeta = AppComponentMeta(
  id: 'app_surface',
  name: 'AppSurface',
  category: ComponentCategory.atom,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Themeable base container (surface) with elevation by tone.',
    pt: 'Container-base temável (superfície) com elevação por tom.',
  ),
  description: LocalizedText(
    en: 'Standardizes the container pattern with surface color + radius + border, read from the theme. Elevation comes from the variant\'s tone (surface → surfaceContainer), not from a shadow.',
    pt:
        'Padroniza o padrão de container com cor de superfície + raio + borda, '
        'lido do tema. A elevação vem do variant por tom (surface → '
        'surfaceContainer), não por sombra.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A card, a panel, a menu item, the body of a sheet or dialog.',
    ],
    pt: <String>['Card, painel, item de menu, corpo de sheet/dialog.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Spacing alone with no background → Padding/Column.',
      'A clickable target → compose it with AppInteraction.',
    ],
    pt: <String>[
      'Só espaçamento sem fundo → Padding/Column.',
      'Alvo clicável → componha com AppInteraction.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'child',
      type: 'Widget',
      isRequired: true,
      description: LocalizedText(
        en: 'Surface content.',
        pt: 'Conteúdo da superfície.',
      ),
    ),
    PropMeta(
      name: 'variant',
      type: 'AppSurfaceVariant',
      defaultValue: 'AppSurfaceVariant.flat',
      description: LocalizedText(
        en: 'Elevation level by tone.',
        pt: 'Nível de elevação por tom.',
      ),
      enumValues: <String>['flat', 'raised', 'bordered'],
    ),
    PropMeta(
      name: 'padding',
      type: 'EdgeInsetsGeometry',
      defaultValue: 'EdgeInsets.zero',
    ),
    PropMeta(
      name: 'radius',
      type: 'BorderRadius?',
      description: LocalizedText(
        en: 'Default: the global radius (round mode), content-sized.',
        pt: 'Default: radius global (modo redondo), content-sized.',
      ),
    ),
    PropMeta(name: 'color', type: 'Color?'),
    PropMeta(name: 'border', type: 'BoxBorder?'),
    PropMeta(name: 'clip', type: 'Clip', defaultValue: 'Clip.antiAlias'),
  ],
  variants: <String>['flat', 'raised', 'bordered'],
  states: <String>['default'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Elevated card', pt: 'Card elevado'),
      code:
          'AppSurface(variant: AppSurfaceVariant.raised, '
          'padding: const EdgeInsets.all(AppSpacings.s16), child: content)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use raised to elevate; let the color come from the theme.',
      'Compose cards, menus and sheets on top of AppSurface.',
    ],
    pt: <String>[
      'Use raised para elevar; deixe a cor vir do tema.',
      'Componha cards/menus/sheets sobre AppSurface.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not add a boxShadow to elevate — raise the variant instead.',
    ],
    pt: <String>['Não adicione boxShadow para elevar — suba o variant.'],
  ),
  a11y: LocalizedText(
    en: 'Semantically neutral: it passes the child through. The tone separation of raised/bordered satisfies UI contrast.',
    pt:
        'Neutro em semântica: repassa o child. A separação de tom do '
        'raised/bordered satisfaz o contraste de UI.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_interaction', 'app_divider'],
);
