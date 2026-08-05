import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppMenu — Playground (all knobs). The trigger IS the interaction (click opens
// the action menu), so there is NO CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppMenu)
Widget menuPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final placement = context.knobs.object.dropdown<AppOverlayPlacement>(
    label: 'placement',
    options: AppOverlayPlacement.values,
    initialOption: AppOverlayPlacement.bottomStart,
    labelBuilder: (p) => 'AppOverlayPlacement.${p.name}',
  );
  final secondary = context.knobs.boolean(
    label: 'openOnSecondaryTap',
    initialValue: false,
  );
  final minWidth = context.knobs.double.slider(
    label: 'minWidth',
    initialValue: 200,
    min: 120,
    max: 320,
  );
  final style = context.knobs.object.dropdown<AppStyle>(
    label: 'style',
    options: AppStyle.values,
    initialOption: AppStyle.elevated,
    labelBuilder: (e) => 'AppStyle.${e.name}',
  );
  final glass = wbGlassKnob(context);

  return wbUseCase(
    context,
    name: 'AppMenu',
    description:
        'Open the action menu from the trigger; items, a section, a '
        'divider and a destructive action.',
    child: AppMenu(
      placement: placement,
      openOnSecondaryTap: secondary,
      minWidth: minWidth,
      style: style,
      glass: glass,
      entries: <AppMenuEntry>[
        AppMenuItem(
          label: 'Edit',
          icon: AppIconToken.settings,
          onPressed: () {},
        ),
        AppMenuItem(
          label: 'Duplicate',
          icon: AppIconToken.copy,
          onPressed: () {},
        ),
        const AppMenuDivider(),
        AppMenuSection(
          title: 'Export',
          items: <AppMenuItem>[
            AppMenuItem(label: 'CSV', icon: AppIconToken.csv, onPressed: () {}),
            AppMenuItem(label: 'PDF', icon: AppIconToken.pdf, onPressed: () {}),
          ],
        ),
        const AppMenuItem(label: 'Unavailable', enabled: false),
        const AppMenuDivider(),
        AppMenuItem(
          label: 'Delete',
          icon: AppIconToken.remove,
          danger: true,
          onPressed: () {},
        ),
      ],
      trigger: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorTheme.primary,
          borderRadius: theme.radiusTheme.resolve(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s24,
            vertical: AppSpacings.s12,
          ),
          child: AppText(
            'Actions',
            style: theme.textTheme.titleMedium.withColor(
              theme.colorTheme.onPrimary,
            ),
          ),
        ),
      ),
    ),
  );
}

List<AppMenuEntry> _menuEntries() => <AppMenuEntry>[
  AppMenuItem(label: 'Edit', icon: AppIconToken.settings, onPressed: () {}),
  AppMenuItem(label: 'Duplicate', icon: AppIconToken.copy, onPressed: () {}),
  const AppMenuDivider(),
  AppMenuItem(
    label: 'Delete',
    icon: AppIconToken.remove,
    danger: true,
    onPressed: () {},
  ),
];

@widgetbook.UseCase(name: 'States', type: AppMenu)
Widget menuStates(BuildContext context) {
  final theme = AppTheme.of(context);
  Widget trigger(String label) => DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colorTheme.primary,
      borderRadius: theme.radiusTheme.resolve(),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s24,
        vertical: AppSpacings.s12,
      ),
      child: AppText(
        label,
        style: theme.textTheme.titleMedium.withColor(
          theme.colorTheme.onPrimary,
        ),
      ),
    ),
  );

  return wbUseCase(
    context,
    name: 'AppMenu',
    description: 'Each container style (open a trigger to compare).',
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s32,
      children: <Widget>[
        for (final AppStyle style in AppStyle.values)
          wbState(
            context,
            name: 'AppStyle.${style.name}',
            when: 'Open to compare',
            width: 160,
            child: AppMenu(
              style: style,
              entries: _menuEntries(),
              trigger: trigger(style.name),
            ),
          ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// AppMenu — Glass over backdrop. O painel do menu abre num Overlay LOCAL, sobre
// um feed colorido: é o único arranjo em que dá para julgar o vidro. Sobre o
// fundo chapado do host, glass e opaco são indistinguíveis — foi exatamente
// isso que fez o menu parecer que não aplicava o efeito.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Glass over backdrop', type: AppMenu)
Widget menuGlass(BuildContext context) {
  return wbUseCase(
    context,
    name: 'AppMenu · Glass',
    description:
        'Open the menu over the colorful feed: the panel frosts what is behind '
        'it. Falls back to an opaque elevated card when transparency is '
        'reduced (high contrast / invert colors, or the transparencyTheme flag).',
    panel: false,
    child: wbGlassStage(
      context,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacings.s32),
          child: AppMenu(
            glass: true,
            entries: <AppMenuEntry>[
              AppMenuItem(
                label: 'Edit',
                icon: AppIconToken.settings,
                onPressed: () {},
              ),
              AppMenuItem(
                label: 'Duplicate',
                icon: AppIconToken.copy,
                onPressed: () {},
              ),
              const AppMenuDivider(),
              AppMenuItem(
                label: 'Delete',
                icon: AppIconToken.remove,
                danger: true,
                onPressed: () {},
              ),
            ],
            trigger: const AppCard(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacings.s16,
                  vertical: AppSpacings.s8,
                ),
                child: AppText('Actions'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
