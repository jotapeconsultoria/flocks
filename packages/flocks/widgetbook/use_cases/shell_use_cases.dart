import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// The three organisms that live at the top of a real screen — the shell that
// arranges them, the global search that sits in its header, and the assistant
// column beside the content. panel: false is not used here: each one is a
// single component and sits on the standard panel, just wider than usual.
// ---------------------------------------------------------------------------

Widget _pane(BuildContext context, String label, {double? height}) {
  final theme = AppTheme.of(context);
  return SizedBox(
    height: height,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorTheme.surfaceContainer,
        borderRadius: theme.radiusTheme.resolve(),
      ),
      child: Center(child: AppText(label)),
    ),
  );
}

// ---------------------------------------------------------------------------
// AppShell
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppShell)
Widget appShellPlayground(BuildContext context) {
  final rail = context.knobs.boolean(label: 'rail', initialValue: true);
  final header = context.knobs.boolean(label: 'header', initialValue: true);
  final aside = context.knobs.boolean(label: 'aside');
  final fullscreen = context.knobs.boolean(label: 'fullscreen');
  // `contentMargin` é um EdgeInsets assimétrico (o cartão encosta menos no
  // topo). O knob dá o token e a assimetria é preservada como no default.
  final margin = wbSpacingKnob(
    context,
    label: 'contentMargin',
    initial: AppSpacings.s12,
  );
  final radius = wbRadiusKnob(context, label: 'contentRadius');

  return wbUseCase(
    context,
    name: 'AppShell',
    description:
        'The frame of a desktop screen: rail, header, content and an optional '
        'aside. fullscreen drops the chrome and hands the whole viewport to '
        'the content — for a map or a kiosk, where the frame is the thing in '
        'the way.',
    maxWidth: 760,
    panelPadding: AppSpacings.s24,
    child: SizedBox(
      height: 320,
      child: AppShell(
        fullscreen: fullscreen,
        contentMargin: EdgeInsets.all(margin),
        contentRadius: BorderRadius.circular(radius),
        rail: rail ? SizedBox(width: 80, child: _pane(context, 'rail')) : null,
        header: header
            ? SizedBox(height: 56, child: _pane(context, 'header'))
            : null,
        aside: aside
            ? SizedBox(width: 220, child: _pane(context, 'aside'))
            : null,
        content: _pane(context, 'content'),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppShell)
Widget appShellStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppShell',
  description:
      'Which regions are mounted — and fullscreen, which is not "one more '
      'region off" but a different mode: the content takes the viewport.',
  maxWidth: 900,
  panelPadding: AppSpacings.s24,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'rail + header',
        width: 260,
        child: SizedBox(
          height: 180,
          child: AppShell(
            rail: SizedBox(width: 56, child: _pane(context, 'rail')),
            header: SizedBox(height: 40, child: _pane(context, 'header')),
            content: _pane(context, 'content'),
          ),
        ),
      ),
      wbState(
        context,
        name: 'with aside',
        width: 260,
        child: SizedBox(
          height: 180,
          child: AppShell(
            rail: SizedBox(width: 56, child: _pane(context, 'rail')),
            header: SizedBox(height: 40, child: _pane(context, 'header')),
            aside: SizedBox(width: 72, child: _pane(context, 'aside')),
            content: _pane(context, 'content'),
          ),
        ),
      ),
      wbState(
        context,
        name: 'fullscreen',
        width: 260,
        child: SizedBox(
          height: 180,
          child: AppShell(
            fullscreen: true,
            rail: SizedBox(width: 56, child: _pane(context, 'rail')),
            header: SizedBox(height: 40, child: _pane(context, 'header')),
            content: _pane(context, 'content'),
          ),
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppOmniSearch
// ---------------------------------------------------------------------------

Future<AppOmniSearchResult> _search(String term) async => AppOmniSearchResult(
  groups: <AppOmniSearchGroup>[
    AppOmniSearchGroup(
      label: 'Veículos',
      items: <AppOmniSearchItem>[
        AppOmniSearchItem(
          id: 'v1',
          title: 'ABC1D23 · Fiat Strada',
          subtitle: 'Grupo Sul',
          onSelected: () {},
        ),
        AppOmniSearchItem(
          id: 'v2',
          title: 'ABC4E56 · VW Saveiro',
          subtitle: 'Grupo Norte',
          onSelected: () {},
        ),
      ],
    ),
    AppOmniSearchGroup(
      label: 'Chips',
      items: <AppOmniSearchItem>[
        AppOmniSearchItem(
          id: 's1',
          title: '8955 1701 2345 6789 012',
          subtitle: 'Allcom · ativo',
          onSelected: () {},
        ),
      ],
    ),
  ],
);

@widgetbook.UseCase(name: 'Playground', type: AppOmniSearch)
Widget appOmniSearchPlayground(BuildContext context) {
  final hintText = context.knobs.string(
    label: 'hintText',
    initialValue: 'Buscar veículo, chip ou motorista',
  );
  final helperText = context.knobs.string(label: 'helperText');
  final emptyLabel = context.knobs.string(
    label: 'emptyLabel',
    initialValue: 'Nada encontrado',
  );
  final withShortcut = context.knobs.boolean(
    label: 'shortcut',
    initialValue: true,
  );
  final size = context.knobs.object.dropdown<AppFieldSize>(
    label: 'size',
    options: AppFieldSize.values,
    initialOption: AppFieldSize.m,
    labelBuilder: (v) => v.name,
  );
  final debounce = wbDurationKnob(
    context,
    label: 'debounce',
    initial: kAppOmniSearchDebounce,
  );
  final panelMaxHeight = context.knobs.double.slider(
    label: 'panelMaxHeight',
    initialValue: kAppOmniSearchPanelMaxHeight,
    min: 120,
    max: 480,
  );

  return wbUseCase(
    context,
    name: 'AppOmniSearch',
    description:
        'Type to see the grouped results: the group label is what keeps a list '
        'mixing plates and ICCIDs readable. A term starting with "/" never '
        'reaches onSearch — it resolves locally against the command registry, '
        'so commands stay instant and "/logout" is not shipped to a server.',
    maxWidth: 560,
    child: AppOmniSearch(
      hintText: hintText,
      helperText: helperText.isEmpty ? null : helperText,
      emptyLabel: emptyLabel,
      size: size,
      debounce: debounce,
      panelMaxHeight: panelMaxHeight,
      shortcut: withShortcut ? const AppShortcut('/') : null,
      onSearch: _search,
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppOmniSearch)
Widget appOmniSearchStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppOmniSearch',
  description:
      'The resting field across the size scale, with and without the shortcut '
      'badge — a shortcut nobody sees is a shortcut nobody uses.',
  maxWidth: 620,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    spacing: AppSpacings.s16,
    children: [
      for (final size in AppFieldSize.values)
        AppOmniSearch(
          size: size,
          hintText: 'size.${size.name}',
          shortcut: const AppShortcut('/'),
          onSearch: _search,
        ),
      const AppOmniSearch(hintText: 'no shortcut badge', onSearch: _search),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppAssistantPanel
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppAssistantPanel)
Widget appAssistantPanelPlayground(BuildContext context) {
  final title = context.knobs.string(label: 'title', initialValue: 'Atlas');
  final statusLabel = context.knobs.string(
    label: 'statusLabel',
    initialValue: 'Sempre online',
  );
  final isOnline = context.knobs.boolean(label: 'isOnline', initialValue: true);
  final withBanner = context.knobs.boolean(label: 'alertBanner');
  final withComposer = context.knobs.boolean(
    label: 'composer',
    initialValue: true,
  );

  return wbUseCase(
    context,
    name: 'AppAssistantPanel',
    description:
        'A column beside the content, never an overlay: an assistant that '
        'covers the screen forces a choice between seeing the data and asking '
        'about it. alertBanner is pinned between header and conversation — a '
        'card inside the scroll is gone on the first swipe.',
    maxWidth: 520,
    panelPadding: AppSpacings.s24,
    child: SizedBox(
      width: 360,
      height: 420,
      child: AppAssistantPanel(
        title: title,
        statusLabel: statusLabel.isEmpty ? null : statusLabel,
        isOnline: isOnline,
        alertBanner: withBanner
            ? const AppAlert(
                title: 'Alerta',
                description: '2 veículos sem sinal há mais de 1h.',
                color: AppAlertColor.warning,
              )
            : null,
        composer: withComposer
            ? const Padding(
                padding: EdgeInsets.all(AppSpacings.s12),
                child: AppText('composer'),
              )
            : null,
        body: const Padding(
          padding: EdgeInsets.all(AppSpacings.s16),
          child: AppText('conversa'),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppAssistantPanel)
Widget appAssistantPanelStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppAssistantPanel',
  description: 'Presence dot and the pinned alert banner.',
  maxWidth: 760,
  panelPadding: AppSpacings.s24,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      for (final (String name, bool online, bool banner)
          in <(String, bool, bool)>[
            ('online', true, false),
            ('offline', false, false),
            ('with alert', true, true),
          ])
        wbState(
          context,
          name: name,
          width: 220,
          child: SizedBox(
            height: 260,
            child: AppAssistantPanel(
              title: 'Atlas',
              statusLabel: online ? 'Sempre online' : 'Offline',
              isOnline: online,
              alertBanner: banner
                  ? const AppAlert(
                      title: 'Alerta',
                      description: '2 veículos sem sinal.',
                      color: AppAlertColor.warning,
                    )
                  : null,
              body: const Padding(
                padding: EdgeInsets.all(AppSpacings.s16),
                child: AppText('conversa'),
              ),
            ),
          ),
        ),
    ],
  ),
);
