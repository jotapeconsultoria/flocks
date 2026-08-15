import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppNavigationRail — menu lateral colapsável. AppNavigationRailItem — o item.
// ---------------------------------------------------------------------------

List<AppNavigationRailItemData> _items({bool withActiveIcons = false}) =>
    <AppNavigationRailItemData>[
      AppNavigationRailItemData(
        icon: AppIconToken.infoCircle,
        activeIcon: withActiveIcons ? AppIconToken.checkCircle : null,
        route: '/inicio',
        title: 'Início',
        onPressed: (_, _) {},
      ),
      AppNavigationRailItemData(
        icon: AppIconToken.checkCircle,
        activeIcon: withActiveIcons ? AppIconToken.infoCircle : null,
        route: '/veiculos',
        title: 'Veículos',
        onPressed: (_, _) {},
      ),
      AppNavigationRailItemData(
        icon: AppIconToken.errorCircle,
        activeIcon: withActiveIcons ? AppIconToken.infoCircle : null,
        route: '/alertas',
        title: 'Alertas',
        onPressed: (_, _) {},
      ),
    ];

@widgetbook.UseCase(name: 'Playground', type: AppNavigationRail)
Widget navigationRailPlayground(BuildContext context) {
  final bool withActiveIcons = context.knobs.boolean(
    label: 'activeIcon',
    initialValue: false,
  );
  final bool widgetLogo = context.knobs.boolean(
    label: 'logo (widget channel)',
    initialValue: false,
  );
  return wbUseCase(
    context,
    name: 'AppNavigationRail',
    description:
        'Collapsable side menu with items and a generic footer slot (support '
        '+ profile). Collapse/expand from the floating chevron on the right '
        'edge. No right border.',
    maxWidth: 360,
    child: SizedBox(
      height: 480,
      child: AppNavigationRail(
        items: _items(withActiveIcons: withActiveIcons),
        logoCollapsed: widgetLogo ? null : AppIconToken.infoCircle,
        logo: widgetLogo
            ? Text('ACME', style: AppTheme.of(context).textTheme.titleLarge)
            : null,
        logoSemanticLabel: widgetLogo ? 'ACME' : null,
        getCurrentRoute: (_) => '/inicio',
        footer: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppNavigationRailItem(
              icon: AppIconToken.support,
              title: 'Suporte',
              onPressed: () {},
            ),
            const AppNavigationRailProfile(
              title: 'João Martins',
              subtitle: 'Operador',
              initials: 'JM',
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppNavigationRailProfile)
Widget navigationRailProfilePlayground(BuildContext context) {
  final bool isCollapsed = context.knobs.boolean(label: 'isCollapsed');
  return wbUseCase(
    context,
    name: 'AppNavigationRailProfile',
    description: 'Footer profile row: avatar + name/role + trailing chevron.',
    maxWidth: 320,
    child: SizedBox(
      width: isCollapsed ? 81 : 288,
      child: AppNavigationRailProfile(
        title: 'João Martins',
        subtitle: 'Operador',
        initials: 'JM',
        isCollapsed: isCollapsed,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppNavigationRailItem)
Widget navigationRailItemPlayground(BuildContext context) {
  final bool isCollapsed = context.knobs.boolean(label: 'isCollapsed');
  final bool isSelected = context.knobs.boolean(
    label: 'isSelected',
    initialValue: true,
  );
  final bool withActiveIcon = context.knobs.boolean(
    label: 'activeIcon',
    initialValue: false,
  );
  return wbUseCase(
    context,
    name: 'AppNavigationRailItem',
    description: 'A single rail row (icon + title) with selected/collapsed.',
    maxWidth: 320,
    child: SizedBox(
      width: 288,
      child: AppNavigationRailItem(
        icon: AppIconToken.infoCircle,
        activeIcon: withActiveIcon ? AppIconToken.checkCircle : null,
        title: 'Início',
        isCollapsed: isCollapsed,
        isSelected: isSelected,
        onPressed: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppNavigationRail)
Widget navigationRailStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppNavigationRail',
  description: 'Different active routes select different items.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      for (final String route in <String>['/inicio', '/veiculos', '/alertas'])
        wbState(
          context,
          name: route,
          width: 300,
          child: SizedBox(
            height: 320,
            child: AppNavigationRail(
              items: _items(),
              logoCollapsed: AppIconToken.infoCircle,
              getCurrentRoute: (_) => route,
            ),
          ),
        ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppNavigationRailItem)
Widget navigationRailItemStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppNavigationRailItem',
  description: 'Default, selected and collapsed (icon-only) rows.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Default',
        width: 288,
        child: AppNavigationRailItem(
          icon: AppIconToken.infoCircle,
          title: 'Início',
          isCollapsed: false,
          onPressed: () {},
        ),
      ),
      wbState(
        context,
        name: 'Selected',
        width: 288,
        child: AppNavigationRailItem(
          icon: AppIconToken.infoCircle,
          title: 'Início',
          isCollapsed: false,
          isSelected: true,
          onPressed: () {},
        ),
      ),
      wbState(
        context,
        name: 'Collapsed',
        width: 96,
        child: AppNavigationRailItem(
          icon: AppIconToken.infoCircle,
          title: 'Início',
          isCollapsed: true,
          isSelected: true,
          onPressed: () {},
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppNavigationRailFilter — the SCOPE row. It looks like an item but does not
// navigate: it narrows what the rest of the app shows. Its "filled" highlight
// has to read differently from an item's "selected" highlight, and the two
// live in the same column — hence the side-by-side States case.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppNavigationRailFilter)
Widget appNavigationRailFilterPlayground(BuildContext context) {
  final label = context.knobs.string(label: 'label', initialValue: 'Conta');
  final value = context.knobs.string(label: 'value', initialValue: 'Jotape');
  final emptyLabel = context.knobs.string(
    label: 'emptyLabel',
    initialValue: kAppNavigationRailFilterAllLabel,
  );
  final enabled = context.knobs.boolean(label: 'enabled', initialValue: true);
  final collapsed = context.knobs.boolean(label: 'isCollapsed');

  return wbUseCase(
    context,
    name: 'AppNavigationRailFilter',
    description:
        'The scope row of the rail. Clear "value" and it shows emptyLabel — a '
        'neutral state, not an empty one: the user must know they are seeing '
        'everything, not that they forgot to choose.',
    child: SizedBox(
      width: collapsed ? 96 : 240,
      child: AppNavigationRailFilter(
        icon: AppIconToken.filter,
        label: label,
        value: value.isEmpty ? null : value,
        emptyLabel: emptyLabel,
        enabled: enabled,
        isCollapsed: collapsed,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppNavigationRailFilter)
Widget appNavigationRailFilterStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppNavigationRailFilter',
  description:
      'Filled, empty, disabled and collapsed — plus a selected item for '
      'contrast. Both highlights share a column in the real rail, so they must '
      'not read as the same thing.',
  maxWidth: 760,
  panelPadding: AppSpacings.s24,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'with value',
        width: 220,
        child: AppNavigationRailFilter(
          icon: AppIconToken.filter,
          label: 'Conta',
          value: 'Jotape',
          onTap: () {},
        ),
      ),
      wbState(
        context,
        name: 'empty (neutral)',
        width: 220,
        child: AppNavigationRailFilter(
          icon: AppIconToken.filter,
          label: 'Grupo',
          onTap: () {},
        ),
      ),
      wbState(
        context,
        name: 'disabled',
        width: 220,
        child: const AppNavigationRailFilter(
          icon: AppIconToken.filter,
          label: 'Cliente',
          enabled: false,
        ),
      ),
      wbState(
        context,
        name: 'collapsed',
        width: 96,
        child: AppNavigationRailFilter(
          icon: AppIconToken.filter,
          label: 'Conta',
          value: 'Jotape',
          isCollapsed: true,
          onTap: () {},
        ),
      ),
      wbState(
        context,
        name: 'item (selected)',
        width: 220,
        child: AppNavigationRailItem(
          icon: AppIconToken.infoCircle,
          title: 'Início',
          isSelected: true,
          onPressed: () {},
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppNavigationRailProfile)
Widget appNavigationRailProfileStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppNavigationRailProfile',
  description:
      'Expanded vs collapsed, with initials and with a trailing action. '
      'Collapsed keeps ONLY the avatar: identity is the one thing that must '
      'survive the rail narrowing, because it is how the user knows which '
      'account they are operating.',
  maxWidth: 720,
  panelPadding: AppSpacings.s24,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'expanded',
        width: 240,
        child: const AppNavigationRailProfile(
          title: 'João Martins',
          subtitle: 'Operador',
          initials: 'JM',
        ),
      ),
      wbState(
        context,
        name: 'no subtitle',
        width: 240,
        child: const AppNavigationRailProfile(
          title: 'João Martins',
          initials: 'JM',
        ),
      ),
      wbState(
        context,
        name: 'with trailing',
        width: 240,
        child: AppNavigationRailProfile(
          title: 'João Martins',
          subtitle: 'Operador',
          initials: 'JM',
          trailing: const AppIcon(AppIconToken.chevronRight),
          onTap: () {},
        ),
      ),
      wbState(
        context,
        name: 'collapsed',
        width: 100,
        child: const AppNavigationRailProfile(
          title: 'João Martins',
          subtitle: 'Operador',
          initials: 'JM',
          isCollapsed: true,
        ),
      ),
    ],
  ),
);
