import 'package:flocks/flocks.dart';
import 'package:flutter/material.dart' show ReorderableListView;
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// list_tile — 2 estilos × variações ortogonais. Tocar o tile É a interação,
// então não há CTA.
// ---------------------------------------------------------------------------

AppListTileStyle _styleKnob(BuildContext context) =>
    context.knobs.object.dropdown<AppListTileStyle>(
      label: 'style',
      options: AppListTileStyle.values,
      initialOption: AppListTileStyle.grouped,
      labelBuilder: (s) => 'AppListTileStyle.${s.name}',
    );

@widgetbook.UseCase(name: 'Playground', type: AppTileInfo)
Widget tileInfoPlayground(BuildContext context) {
  final String title = context.knobs.string(
    label: 'title',
    initialValue: 'Identificador',
  );
  final String text = context.knobs.string(
    label: 'text',
    initialValue: 'TTS4G47',
  );
  return wbUseCase(
    context,
    name: 'AppTileInfo',
    description: 'Static label/value pair (dense grids).',
    child: SizedBox(
      width: 260,
      child: AppTileInfo(title: title, text: text),
    ),
  );
}

enum _Variant { navigation, checkbox, toggle, badge }

@widgetbook.UseCase(name: 'Playground', type: AppListTile)
Widget listTilePlayground(BuildContext context) {
  final AppListTileStyle style = _styleKnob(context);
  final _Variant variant = context.knobs.object.dropdown<_Variant>(
    label: 'variant',
    options: _Variant.values,
    initialOption: _Variant.navigation,
    labelBuilder: (v) => v.name,
  );
  final bool withLeading = context.knobs.boolean(
    label: 'leading',
    initialValue: true,
  );
  final bool withSubtitle = context.knobs.boolean(
    label: 'subtitle',
    initialValue: false,
  );
  final bool enabled = context.knobs.boolean(
    label: 'enabled',
    initialValue: true,
  );
  final bool draggable = context.knobs.boolean(
    label: 'draggable',
    initialValue: false,
  );
  return wbUseCase(
    context,
    name: 'AppListTile',
    description: 'Two styles × variations; open/toggle the tile.',
    child: SizedBox(
      width: 340,
      child: _TileDemo(
        style: style,
        variant: variant,
        withLeading: withLeading,
        withSubtitle: withSubtitle,
        enabled: enabled,
        draggable: draggable,
      ),
    ),
  );
}

class _TileDemo extends StatefulWidget {
  const _TileDemo({
    required this.style,
    required this.variant,
    required this.withLeading,
    required this.withSubtitle,
    required this.enabled,
    required this.draggable,
  });
  final AppListTileStyle style;
  final _Variant variant;
  final bool withLeading;
  final bool withSubtitle;
  final bool enabled;
  final bool draggable;

  @override
  State<_TileDemo> createState() => _TileDemoState();
}

class _TileDemoState extends State<_TileDemo> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    final Widget? leading = widget.withLeading
        ? const AppIcon(AppIconToken.support)
        : null;
    final String? subtitle = widget.withSubtitle ? 'Subtítulo opcional' : null;
    final int? reorderIndex = widget.draggable ? 0 : null;
    return switch (widget.variant) {
      _Variant.navigation => AppListTile.navigation(
        style: widget.style,
        leading: leading,
        title: 'Título',
        subtitle: subtitle,
        enabled: widget.enabled,
        reorderIndex: reorderIndex,
        reorderEnabled: false,
        onTap: () {},
      ),
      _Variant.checkbox => AppListTile.checkbox(
        style: widget.style,
        leading: leading,
        title: 'Título',
        subtitle: subtitle,
        enabled: widget.enabled,
        reorderIndex: reorderIndex,
        reorderEnabled: false,
        value: _value,
        onChanged: (v) => setState(() => _value = v),
      ),
      _Variant.toggle => AppListTile.toggle(
        style: widget.style,
        leading: leading,
        title: 'Título',
        subtitle: subtitle,
        enabled: widget.enabled,
        reorderIndex: reorderIndex,
        reorderEnabled: false,
        value: _value,
        onChanged: (v) => setState(() => _value = v),
      ),
      _Variant.badge => AppListTile.badge(
        style: widget.style,
        leading: leading,
        title: 'Título',
        subtitle: subtitle,
        enabled: widget.enabled,
        reorderIndex: reorderIndex,
        reorderEnabled: false,
        badge: '5',
        badgeColor: AppBadgeColor.danger,
      ),
    };
  }
}

@widgetbook.UseCase(name: 'Playground', type: AppListTileRadio)
Widget listTileRadioPlayground(BuildContext context) {
  final AppListTileStyle style = _styleKnob(context);
  return wbUseCase(
    context,
    name: 'AppListTileRadio',
    description: 'Single-select rows; tap to select.',
    child: SizedBox(width: 340, child: _RadioDemo(style: style)),
  );
}

class _RadioDemo extends StatefulWidget {
  const _RadioDemo({required this.style});
  final AppListTileStyle style;
  @override
  State<_RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<_RadioDemo> {
  String _group = 'a';
  @override
  Widget build(BuildContext context) => AppListTileGroup(
    style: widget.style,
    children: <Widget>[
      for (final (String v, String t) in const <(String, String)>[
        ('a', 'Polo Track 01'),
        ('b', 'Polo Track 02'),
        ('c', 'Polo Track 03'),
      ])
        AppListTileRadio<String>(
          style: widget.style,
          title: t,
          value: v,
          groupValue: _group,
          onChanged: (nv) => setState(() => _group = nv ?? _group),
        ),
    ],
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppListTileGroup)
Widget listTileGroupPlayground(BuildContext context) {
  final AppListTileStyle style = _styleKnob(context);
  return wbUseCase(
    context,
    name: 'AppListTileGroup',
    description: 'Stack of related rows in one card.',
    child: SizedBox(
      width: 340,
      child: AppListTileGroup(
        style: style,
        children: <Widget>[
          AppListTile.navigation(
            style: style,
            leading: const AppIcon(AppIconToken.support),
            title: 'Suporte',
            onTap: () {},
          ),
          AppListTile.navigation(
            style: style,
            leading: const AppIcon(AppIconToken.settings),
            title: 'Configurações',
            onTap: () {},
          ),
          AppListTile.navigation(
            style: style,
            leading: const AppIcon(AppIcons.logout),
            title: 'Sair',
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Cenários realistas — um por variação.
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Scenario — uma tela real, não cinco. As cinco cenas anteriores (Navigation /
// Checkbox / Switch / Draggable / Badges) mostravam a MESMA coisa que o knob
// `variant` do Playground já mostra; o que elas tinham de próprio era o tile
// EM GRUPO, e isso cabe numa cena só. Aqui as variantes convivem, que é como
// convivem numa tela de configurações de verdade.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Scenario', type: AppListTile)
Widget listTileScenario(BuildContext context) {
  final AppListTileStyle style = _styleKnob(context);
  return wbUseCase(
    context,
    name: 'AppListTile',
    description:
        'A settings-like screen: navigation, multi-select, on/off and count '
        'badges in groups, plus a reorderable list. Tapping the ROW toggles — '
        'the target is the row, not the 20px control at the end.',
    maxWidth: 820,
    panelPadding: AppSpacings.s32,
    child: _ScenarioDemo(style: style),
  );
}

class _ScenarioDemo extends StatefulWidget {
  const _ScenarioDemo({required this.style});
  final AppListTileStyle style;
  @override
  State<_ScenarioDemo> createState() => _ScenarioDemoState();
}

class _ScenarioDemoState extends State<_ScenarioDemo> {
  final Set<String> _selected = <String>{'Polo Track 01'};
  final Map<String, bool> _switches = <String, bool>{
    'Notificações': true,
    'Localização': false,
    'Modo escuro': true,
  };
  final List<String> _columns = <String>[
    'Coluna A',
    'Coluna B',
    'Coluna C',
    'Coluna D',
  ];
  final Set<String> _visible = <String>{'Coluna A'};

  @override
  Widget build(BuildContext context) {
    final AppListTileStyle style = widget.style;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s24,
      children: <Widget>[
        wbState(
          context,
          name: 'navigation',
          width: 340,
          child: AppListTileGroup(
            style: style,
            children: <Widget>[
              AppListTile.navigation(
                style: style,
                leading: const AppIcon(AppIconToken.support),
                title: 'Suporte',
                onTap: () {},
              ),
              AppListTile.navigation(
                style: style,
                leading: const AppIcon(AppIconToken.settings),
                title: 'Configurações',
                onTap: () {},
              ),
              AppListTile.navigation(
                style: style,
                leading: const AppIcon(AppIcons.logout),
                title: 'Sair',
                onTap: () {},
              ),
            ],
          ),
        ),
        wbState(
          context,
          name: 'multi select',
          width: 340,
          child: AppListTileGroup(
            style: style,
            children: <Widget>[
              for (final String v in const <String>[
                'Polo Track 01',
                'Polo Track 02',
                'Polo Track 03',
              ])
                AppListTile.checkbox(
                  style: style,
                  title: v,
                  value: _selected.contains(v),
                  onChanged: (bool on) => setState(
                    () => on ? _selected.add(v) : _selected.remove(v),
                  ),
                ),
            ],
          ),
        ),
        wbState(
          context,
          name: 'on/off',
          width: 340,
          child: AppListTileGroup(
            style: style,
            children: <Widget>[
              for (final MapEntry<String, bool> e in _switches.entries)
                AppListTile.toggle(
                  style: style,
                  title: e.key,
                  value: e.value,
                  onChanged: (bool v) => setState(() => _switches[e.key] = v),
                ),
            ],
          ),
        ),
        wbState(
          context,
          name: 'count badges',
          width: 340,
          child: AppListTileGroup(
            style: style,
            children: <Widget>[
              AppListTile.badge(
                style: style,
                title: 'Alertas',
                badge: '5',
                badgeColor: AppBadgeColor.danger,
              ),
              AppListTile.badge(
                style: style,
                title: 'Mensagens',
                badge: '12',
                badgeColor: AppBadgeColor.primary,
              ),
              AppListTile.badge(
                style: style,
                title: 'Concluídos',
                badge: '3',
                badgeColor: AppBadgeColor.success,
              ),
            ],
          ),
        ),
        wbState(
          context,
          name: 'reorderable',
          when: 'drag by the handle',
          width: 340,
          child: SizedBox(
            height: 260,
            // `ReorderableListView` é do Material — é a ÚNICA exceção do
            // catálogo (ver CONVENTIONS §R-imports). O `reorderIndex` do tile
            // existe para viver dentro de uma lista reordenável, e não há
            // equivalente na camada `widgets`: sem isto a alça apareceria sem
            // arrastar nada, que é pior que a exceção.
            child: ReorderableListView(
              buildDefaultDragHandles: false,
              onReorderItem: (int oldI, int newI) => setState(
                () => _columns.insert(newI, _columns.removeAt(oldI)),
              ),
              children: <Widget>[
                for (int i = 0; i < _columns.length; i++)
                  Padding(
                    key: ValueKey<String>(_columns[i]),
                    padding: const EdgeInsets.only(bottom: AppSpacings.s8),
                    child: AppListTile.checkbox(
                      style: style,
                      title: _columns[i],
                      value: _visible.contains(_columns[i]),
                      reorderIndex: i,
                      onChanged: (bool on) => setState(
                        () => on
                            ? _visible.add(_columns[i])
                            : _visible.remove(_columns[i]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

@widgetbook.UseCase(name: 'States', type: AppListTileGroup)
Widget listTileGroupStates(BuildContext context) {
  Widget column(AppListTileStyle style) => Column(
    mainAxisSize: MainAxisSize.min,
    spacing: AppSpacings.s24,
    children: <Widget>[
      AppListTileGroup(
        style: style,
        children: <Widget>[
          for (int i = 0; i < 3; i++)
            AppListTile.navigation(
              style: style,
              leading: const AppAvatar(size: AppAvatarSize.s, fallback: 'A'),
              title: 'Title',
              onTap: () {},
            ),
        ],
      ),
      AppListTileGroup(
        style: style,
        children: <Widget>[
          AppListTile.navigation(
            style: style,
            title: 'Title',
            subtitle: 'Details',
            onTap: () {},
          ),
          AppListTile.checkbox(
            style: style,
            title: 'Title',
            value: true,
            onChanged: (_) {},
          ),
          AppListTile.toggle(
            style: style,
            title: 'Title',
            value: true,
            onChanged: (_) {},
          ),
          const AppListTileRadio<int>(
            style: AppListTileStyle.grouped,
            title: 'Title',
            value: 1,
            groupValue: 1,
          ),
          const AppListTile.badge(
            style: AppListTileStyle.grouped,
            title: 'Title',
            badge: '5',
            badgeColor: AppBadgeColor.danger,
          ),
        ],
      ),
    ],
  );

  return wbUseCase(
    context,
    name: 'AppListTileGroup',
    description:
        'Every variation in both styles (grouped left, bordered right).',
    maxWidth: 760,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacings.s24,
      children: <Widget>[
        Expanded(child: column(AppListTileStyle.grouped)),
        Expanded(child: column(AppListTileStyle.bordered)),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// States — static grids per component.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: AppTileInfo)
Widget tileInfoStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppTileInfo',
  description: 'Label/value pairs at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Identifier',
        when: 'Code value',
        width: 240,
        child: const SizedBox(
          width: 240,
          child: AppTileInfo(title: 'Identificador', text: 'TTS4G47'),
        ),
      ),
      wbState(
        context,
        name: 'Plate',
        when: 'Short value',
        width: 240,
        child: const SizedBox(
          width: 240,
          child: AppTileInfo(title: 'Placa', text: 'ABC1D23'),
        ),
      ),
      wbState(
        context,
        name: 'Status',
        when: 'Word value',
        width: 240,
        child: const SizedBox(
          width: 240,
          child: AppTileInfo(title: 'Status', text: 'Online'),
        ),
      ),
    ],
  ),
);

Widget _tileCard(
  BuildContext context, {
  required String name,
  required String when,
  required Widget tile,
}) => wbState(
  context,
  name: name,
  when: when,
  width: 300,
  child: SizedBox(
    width: 300,
    child: AppListTileGroup(
      style: AppListTileStyle.bordered,
      children: <Widget>[tile],
    ),
  ),
);

@widgetbook.UseCase(name: 'States', type: AppListTile)
Widget listTileStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppListTile',
  description: 'Every variation plus the disabled state at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      _tileCard(
        context,
        name: 'Navigation',
        when: 'Opens a page',
        tile: AppListTile.navigation(
          style: AppListTileStyle.bordered,
          leading: const AppIcon(AppIconToken.support),
          title: 'Suporte',
          onTap: () {},
        ),
      ),
      _tileCard(
        context,
        name: 'Checkbox',
        when: 'Multi select',
        tile: AppListTile.checkbox(
          style: AppListTileStyle.bordered,
          title: 'Polo Track 01',
          value: true,
          onChanged: (_) {},
        ),
      ),
      _tileCard(
        context,
        name: 'Switch',
        when: 'On/off setting',
        tile: AppListTile.toggle(
          style: AppListTileStyle.bordered,
          title: 'Notificações',
          value: true,
          onChanged: (_) {},
        ),
      ),
      _tileCard(
        context,
        name: 'Badge',
        when: 'Count/status',
        tile: const AppListTile.badge(
          style: AppListTileStyle.bordered,
          title: 'Alertas',
          badge: '5',
          badgeColor: AppBadgeColor.danger,
        ),
      ),
      _tileCard(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        tile: AppListTile.navigation(
          style: AppListTileStyle.bordered,
          leading: const AppIcon(AppIconToken.settings),
          title: 'Configurações',
          enabled: false,
          onTap: () {},
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppListTileRadio)
Widget listTileRadioStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppListTileRadio',
  description: 'Selected, unselected and read-only at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Selected',
        when: 'The current choice',
        width: 300,
        child: SizedBox(
          width: 300,
          child: AppListTileGroup(
            style: AppListTileStyle.bordered,
            children: <Widget>[
              AppListTileRadio<String>(
                style: AppListTileStyle.bordered,
                title: 'Polo Track 01',
                value: 'a',
                groupValue: 'a',
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
      wbState(
        context,
        name: 'Unselected',
        when: 'Not chosen',
        width: 300,
        child: SizedBox(
          width: 300,
          child: AppListTileGroup(
            style: AppListTileStyle.bordered,
            children: <Widget>[
              AppListTileRadio<String>(
                style: AppListTileStyle.bordered,
                title: 'Polo Track 02',
                value: 'b',
                groupValue: 'a',
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
      wbState(
        context,
        name: 'Read-only',
        when: 'Not interactive',
        width: 300,
        child: const SizedBox(
          width: 300,
          child: AppListTileGroup(
            style: AppListTileStyle.bordered,
            children: <Widget>[
              AppListTileRadio<String>(
                style: AppListTileStyle.bordered,
                title: 'Polo Track 03',
                value: 'c',
                groupValue: 'c',
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// LEGACY: AppListTileAction / AppListTileCheckbox / AppListTileDraggableCheckbox
//
// Superseded by AppListTile's named constructors (2026-07-06). They are still
// here because tracked_shared_pkg re-exports them and the apps still consume
// them — the shared AppListTile is still the legacy implementation, so those
// call sites cannot reach the new constructors yet.
//
// The cases exist to make the ONE thing that does not survive the translation
// visible: the legacy pair puts the muted label ON TOP and the strong value
// below; AppListTile does the opposite. Every Playground pairs the legacy tile
// with its successor so the swap of emphasis is impossible to miss.
// ---------------------------------------------------------------------------

Widget _legacyNote(BuildContext context, String replacement) {
  final theme = AppTheme.of(context);
  return AppText(
    'Legacy — use $replacement in new code.',
    style: theme.textTheme.labelSmall.withColor(
      readableStopOn(
        theme.colorTheme.warning,
        theme.colorTheme.surfaceContainer,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppListTileAction)
Widget appListTileActionPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final title = context.knobs.string(label: 'title', initialValue: 'VEÍCULOS');
  final text = context.knobs.string(
    label: 'text',
    initialValue: '3 selecionados',
  );

  final trailing = AppIcon(
    AppIconToken.swapArrow,
    color: theme.colorTheme.secondary,
    size: AppIconSize.m,
  );

  return wbUseCase(
    context,
    name: 'AppListTileAction',
    description:
        'Clickable label/value row with a free trailing (not a chevron: in the '
        'mobile filters screen it is the swap icon). Superseded by AppListTile '
        '— compare below: the legacy tile emphasises the VALUE, the successor '
        'emphasises the label.',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _legacyNote(context, 'AppListTile'),
        const SizedBox(height: AppSpacings.s8),
        AppListTileAction(
          title: title,
          text: text,
          trailing: trailing,
          onPressed: () {},
        ),
        const SizedBox(height: AppSpacings.s16),
        AppListTile(
          title: title,
          subtitle: text,
          trailing: trailing,
          onTap: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppListTileAction)
Widget appListTileActionStates(BuildContext context) {
  final theme = AppTheme.of(context);
  Widget trailing() => AppIcon(
    AppIconToken.swapArrow,
    color: theme.colorTheme.secondary,
    size: AppIconSize.m,
  );

  return wbUseCase(
    context,
    name: 'AppListTileAction',
    description: 'Short value, long value (ellipsis) and a non-icon trailing.',
    maxWidth: 720,
    panelPadding: AppSpacings.s24,
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s24,
      children: [
        wbState(
          context,
          name: 'short value',
          width: 280,
          child: AppListTileAction(
            title: 'DATA',
            text: '15/07/2026',
            trailing: trailing(),
            onPressed: () {},
          ),
        ),
        wbState(
          context,
          name: 'long value (ellipsis)',
          width: 280,
          child: AppListTileAction(
            title: 'VEÍCULOS',
            text: 'Polo Track 01, Saveiro 02, Strada 03 e mais 4',
            trailing: trailing(),
            onPressed: () {},
          ),
        ),
        wbState(
          context,
          name: 'text trailing',
          width: 280,
          child: AppListTileAction(
            title: 'HORA INICIAL',
            text: '08:00',
            trailing: const AppText('Trocar'),
            onPressed: () {},
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppListTileCheckbox)
Widget appListTileCheckboxPlayground(BuildContext context) {
  final title = context.knobs.string(label: 'title', initialValue: 'TTS4G47');
  final text = context.knobs.string(
    label: 'text',
    initialValue: 'Polo Track 01',
  );
  final checked = context.knobs.boolean(label: 'checked', initialValue: true);
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);

  return wbUseCase(
    context,
    name: 'AppListTileCheckbox',
    description:
        'Label/value row with a checkbox. Tapping the WHOLE ROW toggles — the '
        'target is the row, not the 20px box. Superseded by '
        'AppListTile.checkbox, shown below for comparison.',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _legacyNote(context, 'AppListTile.checkbox'),
        const SizedBox(height: AppSpacings.s8),
        AppListTileCheckbox(
          title: title,
          text: text,
          checked: checked,
          enabled: enabled,
          onChanged: (_) {},
        ),
        const SizedBox(height: AppSpacings.s16),
        AppListTile.checkbox(
          title: text,
          subtitle: title,
          value: checked,
          enabled: enabled,
          onChanged: (_) {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppListTileCheckbox)
Widget appListTileCheckboxStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppListTileCheckbox',
  description:
      'Checked, unchecked, disabled and without the overline label. The value '
      'changes colour when checked — the state is not carried by the box alone.',
  maxWidth: 720,
  panelPadding: AppSpacings.s24,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'checked',
        width: 280,
        child: AppListTileCheckbox(
          title: 'TTS4G47',
          text: 'Polo Track 01',
          checked: true,
          onChanged: (_) {},
        ),
      ),
      wbState(
        context,
        name: 'unchecked',
        width: 280,
        child: AppListTileCheckbox(
          title: 'TTS4G48',
          text: 'Saveiro 02',
          checked: false,
          onChanged: (_) {},
        ),
      ),
      wbState(
        context,
        name: 'disabled',
        width: 280,
        child: const AppListTileCheckbox(
          title: 'TTS4G49',
          text: 'Strada 03',
          checked: false,
          enabled: false,
        ),
      ),
      wbState(
        context,
        name: 'no overline',
        width: 280,
        child: AppListTileCheckbox(
          text: 'Sem rótulo em cima',
          checked: true,
          onChanged: (_) {},
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'Playground', type: AppListTileDraggableCheckbox)
Widget appListTileDraggableCheckboxPlayground(BuildContext context) {
  final title = context.knobs.string(label: 'title', initialValue: 'Placa');
  final text = context.knobs.string(label: 'text');
  final checked = context.knobs.boolean(label: 'checked', initialValue: true);
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final reorderEnabled = context.knobs.boolean(
    label: 'reorderEnabled',
    initialValue: true,
  );

  return wbUseCase(
    context,
    name: 'AppListTileDraggableCheckbox',
    description:
        'The checkbox row plus a drag handle, for a ReorderableListView: '
        'picking WHICH columns and in WHAT order is one task, so it is one '
        'control. reorderEnabled: false keeps the row and drops the handle. '
        'Superseded by AppListTile.checkbox(reorderIndex:).',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _legacyNote(context, 'AppListTile.checkbox(reorderIndex:)'),
        const SizedBox(height: AppSpacings.s8),
        AppListTileDraggableCheckbox(
          reorderIndex: 0,
          title: title,
          text: text.isEmpty ? null : text,
          checked: checked,
          enabled: enabled,
          reorderEnabled: reorderEnabled,
          onChanged: (_) {},
        ),
        const SizedBox(height: AppSpacings.s16),
        AppListTile.checkbox(
          reorderIndex: 0,
          reorderEnabled: reorderEnabled,
          title: title,
          subtitle: text.isEmpty ? null : text,
          value: checked,
          enabled: enabled,
          onChanged: (_) {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppListTileDraggableCheckbox)
Widget appListTileDraggableCheckboxStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppListTileDraggableCheckbox',
  description:
      'With and without the handle, and disabled. reorderEnabled: false is for '
      'the list that can be ticked but not reordered.',
  maxWidth: 720,
  panelPadding: AppSpacings.s24,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'draggable',
        width: 280,
        child: AppListTileDraggableCheckbox(
          reorderIndex: 0,
          title: 'Placa',
          checked: true,
          onChanged: (_) {},
        ),
      ),
      wbState(
        context,
        name: 'reorderEnabled: false',
        width: 280,
        child: AppListTileDraggableCheckbox(
          reorderIndex: 1,
          title: 'Modelo',
          checked: true,
          reorderEnabled: false,
          onChanged: (_) {},
        ),
      ),
      wbState(
        context,
        name: 'disabled',
        width: 280,
        child: const AppListTileDraggableCheckbox(
          reorderIndex: 2,
          title: 'Motorista',
          checked: false,
          enabled: false,
        ),
      ),
    ],
  ),
);
