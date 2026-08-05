import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// Controllers de demo (criados uma vez).
final TextEditingController _searchController = TextEditingController();
final TextEditingController _chatController = TextEditingController();

const List<(String, String, String)> _navDefs = <(String, String, String)>[
  (AppIconToken.dashboard, 'Início', '/home'),
  (AppIconToken.car, 'Veículos', '/vehicles'),
  (AppIconToken.settings, 'Ajustes', '/settings'),
];

// ---------------------------------------------------------------------------
// Footers — Playgrounds (com knobs de style/radius etc.).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppButtonsFooter)
Widget buttonsFooterPlayground(BuildContext context) {
  final bool withSecondary = context.knobs.boolean(
    label: 'secondary',
    initialValue: true,
  );
  final AppStyle? barStyle = wbStyleKnob(context, label: 'barStyle');
  final bool? glass = wbGlassKnob(context);
  final (String, bool?) expandedOpt = context.knobs.object
      .dropdown<(String, bool?)>(
        label: 'expanded',
        options: const <(String, bool?)>[
          ('auto', null),
          ('true', true),
          ('false', false),
        ],
        initialOption: const ('auto', null),
        labelBuilder: (e) => e.$1,
      );
  final Axis axis =
      context.knobs.boolean(label: 'vertical', initialValue: false)
      ? Axis.vertical
      : Axis.horizontal;
  final AppButtonsPlatformStyle platform = context.knobs.object
      .dropdown<AppButtonsPlatformStyle>(
        label: 'platform',
        options: AppButtonsPlatformStyle.values,
        initialOption: AppButtonsPlatformStyle.desktop,
        labelBuilder: (p) => 'AppButtonsPlatformStyle.${p.name}',
      );
  final AppButtonsFooterStyle cornerStyle = context.knobs.object
      .dropdown<AppButtonsFooterStyle>(
        label: 'style (corners)',
        options: AppButtonsFooterStyle.values,
        initialOption: AppButtonsFooterStyle.page,
        labelBuilder: (s) => 'AppButtonsFooterStyle.${s.name}',
      );
  return wbUseCase(
    context,
    name: 'AppButtonsFooter',
    description:
        'Action footer — barStyle (incl. glass) + expanded/192 reflow.',
    maxWidth: 640,
    panel: false,
    child: wbBarScene(
      context,
      footer: AppButtonsFooter(
        barStyle: barStyle ?? AppStyle.filled,
        glass: glass,
        expanded: expandedOpt.$2,
        axis: axis,
        platform: platform,
        style: cornerStyle,
        primary: AppButton(label: 'Salvar', onPressed: () {}),
        secondary: withSecondary
            ? AppButton(
                style: AppStyle.outlined,
                label: 'Cancelar',
                onPressed: () {},
              )
            : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppSimpleFooter)
Widget simpleFooterPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final AppStyle? style = wbStyleKnob(context);
  final bool? glass = wbGlassKnob(context);
  final String text = context.knobs.string(
    label: 'text',
    initialValue: '© 2026 Tracked',
  );
  return wbUseCase(
    context,
    name: 'AppSimpleFooter',
    description: 'Simple footer band — style axis incl. glass over content.',
    maxWidth: 640,
    panel: false,
    child: wbBarScene(
      context,
      footer: AppSimpleFooter(
        style: style ?? AppStyle.filled,
        glass: glass,
        child: AppText(text, style: theme.textTheme.bodyMedium),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppNavigationFooter)
Widget navigationFooterPlayground(BuildContext context) {
  final int active = context.knobs.int.slider(
    label: 'active index',
    initialValue: 1,
    min: 0,
    max: 2,
    divisions: 2,
  );
  final AppStyle? style = wbStyleKnob(context);
  final bool? glass = wbGlassKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final bool withFab = context.knobs.boolean(label: 'fab', initialValue: false);
  final AppNavFooterFabAlignment fabAlignment = context.knobs.object
      .dropdown<AppNavFooterFabAlignment>(
        label: 'fabAlignment',
        options: AppNavFooterFabAlignment.values,
        initialOption: AppNavFooterFabAlignment.end,
        labelBuilder: (a) => 'AppNavFooterFabAlignment.${a.name}',
      );
  return wbUseCase(
    context,
    name: 'AppNavigationFooter',
    description:
        'Floating bottom nav — sliding indicator, glass, isolated FAB.',
    maxWidth: 640,
    panel: false,
    child: wbBarScene(
      context,
      footer: AppNavigationFooter(
        style: style ?? AppStyle.filled,
        glass: glass,
        radiusMode: radiusMode,
        fabAlignment: fabAlignment,
        fab: withFab
            ? AppFloatingButton(
                icon: AppIconToken.add,
                style: style ?? AppStyle.filled,
                onPressed: () {},
                semanticsLabel: 'Adicionar',
              )
            : null,
        getCurrentRoute: (_) => _navDefs[active].$3,
        items: <AppNavigationFooterItemData>[
          for (final (String icon, String title, String route) in _navDefs)
            AppNavigationFooterItemData(
              icon: icon,
              title: title,
              route: route,
              onPressed: (_, _) {},
            ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppSearchFooter)
Widget searchFooterPlayground(BuildContext context) {
  final AppStyle? style = wbStyleKnob(context);
  final bool? glass = wbGlassKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final AppFieldSize size = wbFieldSizeKnob(context);
  final String hint = context.knobs.string(
    label: 'hint',
    initialValue: 'Buscar',
  );
  final bool withMic = context.knobs.boolean(label: 'mic', initialValue: true);
  final bool withFab = context.knobs.boolean(
    label: 'trailing FAB',
    initialValue: true,
  );
  return wbUseCase(
    context,
    name: 'AppSearchFooter',
    description:
        'Floating search capsule (Notes-style) — style axis incl. glass.',
    maxWidth: 640,
    panel: false,
    child: wbBarScene(
      context,
      footer: AppSearchFooter(
        controller: _searchController,
        style: style ?? AppStyle.filled,
        glass: glass,
        radiusMode: radiusMode,
        size: size,
        hintText: hint,
        suffixIcon: withMic ? AppIconToken.microphone : null,
        onSuffixIconTap: withMic ? () {} : null,
        trailing: withFab
            ? AppFloatingButton(
                icon: AppIconToken.add,
                style: style ?? AppStyle.filled,
                onPressed: () {},
                semanticsLabel: 'Compor',
              )
            : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppChatFooter)
Widget chatFooterPlayground(BuildContext context) {
  final AppStyle? style = wbStyleKnob(context);
  final bool? glass = wbGlassKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final bool busy = context.knobs.boolean(label: 'busy', initialValue: false);
  final bool floating = context.knobs.boolean(
    label: 'floating',
    initialValue: false,
  );
  final String hint = context.knobs.string(
    label: 'hint',
    initialValue: 'Pergunte alguma coisa…',
  );
  return wbUseCase(
    context,
    name: 'AppChatFooter',
    description: 'Chat composer footer — safe-area + style axis incl. glass.',
    maxWidth: 640,
    panel: false,
    child: wbBarScene(
      context,
      footer: AppChatFooter(
        controller: _chatController,
        style: style ?? AppStyle.filled,
        glass: glass,
        radiusMode: radiusMode,
        floating: floating,
        busy: busy,
        hintText: hint,
        onSend: () {},
        onStop: () {},
        onAttach: () {},
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// States — one grid per footer type.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'States', type: AppButtonsFooter)
Widget buttonsFooterStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppButtonsFooter',
  description: 'Auto/expanded widths, one and two actions.',
  maxWidth: 640,
  panelPadding: AppSpacings.s32,
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Auto (192)',
        when: 'Primary + secondary',
        width: 460,
        child: SizedBox(
          width: 460,
          child: AppButtonsFooter(
            primary: AppButton(label: 'Salvar', onPressed: () {}),
            secondary: AppButton(
              style: AppStyle.outlined,
              label: 'Cancelar',
              onPressed: () {},
            ),
          ),
        ),
      ),
      wbState(
        context,
        name: 'Expanded',
        when: 'Full width',
        width: 460,
        child: SizedBox(
          width: 460,
          child: AppButtonsFooter(
            expanded: true,
            primary: AppButton(label: 'Salvar', onPressed: () {}),
            secondary: AppButton(
              style: AppStyle.outlined,
              label: 'Cancelar',
              onPressed: () {},
            ),
          ),
        ),
      ),
      wbState(
        context,
        name: 'Primary only',
        when: 'Single action',
        width: 460,
        child: SizedBox(
          width: 460,
          child: AppButtonsFooter(
            primary: AppButton(label: 'Salvar', onPressed: () {}),
          ),
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppSimpleFooter)
Widget simpleFooterStates(BuildContext context) {
  final theme = AppTheme.of(context);
  return wbUseCase(
    context,
    name: 'AppSimpleFooter',
    description: 'A simple band hosting arbitrary footer content.',
    maxWidth: 640,
    panelPadding: AppSpacings.s32,
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s32,
      children: <Widget>[
        wbState(
          context,
          name: 'Copyright',
          when: 'Legal line',
          width: 460,
          child: SizedBox(
            width: 460,
            child: AppSimpleFooter(
              child: AppText(
                '© 2026 Tracked',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
        wbState(
          context,
          name: 'Signature',
          when: 'Credits line',
          width: 460,
          child: SizedBox(
            width: 460,
            child: AppSimpleFooter(
              child: AppText(
                'Feito pela Jotape Tecnologia',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppNavigationFooter)
Widget navigationFooterStates(BuildContext context) {
  Widget bar(int active) => SizedBox(
    width: 460,
    child: AppNavigationFooter(
      getCurrentRoute: (_) => _navDefs[active].$3,
      items: <AppNavigationFooterItemData>[
        for (final (String icon, String title, String route) in _navDefs)
          AppNavigationFooterItemData(
            icon: icon,
            title: title,
            route: route,
            onPressed: (_, _) {},
          ),
      ],
    ),
  );

  return wbUseCase(
    context,
    name: 'AppNavigationFooter',
    description: 'Each item as the active one.',
    maxWidth: 640,
    panelPadding: AppSpacings.s32,
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s32,
      children: <Widget>[
        wbState(
          context,
          name: 'first active',
          when: 'First active',
          width: 460,
          child: bar(0),
        ),
        wbState(
          context,
          name: 'second active',
          when: 'Middle active',
          width: 460,
          child: bar(1),
        ),
        wbState(
          context,
          name: 'Ajustes',
          when: 'Last active',
          width: 460,
          child: bar(2),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppSearchFooter)
Widget searchFooterStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSearchFooter',
  description: 'Filled capsule and glass capsule over content.',
  maxWidth: 640,
  panel: false,
  child: wbBarScene(
    context,
    footer: AppSearchFooter(
      controller: _searchController,
      hintText: 'Buscar',
      suffixIcon: AppIconToken.microphone,
      onSuffixIconTap: () {},
      trailing: AppFloatingButton(
        icon: AppIconToken.add,
        onPressed: () {},
        semanticsLabel: 'Compor',
      ),
    ),
  ),
);

@widgetbook.UseCase(name: 'States', type: AppChatFooter)
Widget chatFooterStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppChatFooter',
  description: 'Docked composer band; idle and busy.',
  maxWidth: 640,
  panel: false,
  child: wbBarScene(
    context,
    footer: AppChatFooter(
      controller: _chatController,
      hintText: 'Pergunte alguma coisa…',
      onSend: () {},
      onStop: () {},
      onAttach: () {},
    ),
  ),
);
