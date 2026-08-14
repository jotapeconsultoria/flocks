import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppChoiceChip — the selectable chip (toggle semantics). Selected paints the
// SAME filled accent AppSegmentedButton uses, so "one of N" never drifts.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppChoiceChip)
Widget appChoiceChipPlayground(BuildContext context) {
  final String label = context.knobs.string(
    label: 'label',
    initialValue: 'Novos',
  );
  final bool selected = context.knobs.boolean(
    label: 'selected',
    initialValue: true,
  );
  final int count = context.knobs.double
      .slider(label: 'count (-1 = none)', initialValue: 8, min: -1, max: 99)
      .round();
  final bool withIcon = context.knobs.boolean(
    label: 'icon',
    initialValue: false,
  );
  final bool enabled = context.knobs.boolean(
    label: 'enabled',
    initialValue: true,
  );
  final bool mutuallyExclusive = context.knobs.boolean(
    label: 'mutuallyExclusive',
    initialValue: true,
  );
  final String semanticLabel = context.knobs.string(
    label: 'semanticLabel',
    initialValue: 'Novos, 8 conversas na fila',
  );
  final String tooltip = context.knobs.string(
    label: 'tooltip',
    initialValue: '',
  );
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);

  return wbUseCase(
    context,
    name: 'AppChoiceChip',
    description:
        'The selectable chip — one option of a set, with an optional count '
        'pill. Selection swaps fill AND label weight; the count pill sits at '
        'fg 18% so one formula serves both states.',
    child: AppChoiceChip(
      label: label,
      selected: selected,
      count: count < 0 ? null : count,
      icon: withIcon ? AppIconToken.check : null,
      enabled: enabled,
      mutuallyExclusive: mutuallyExclusive,
      semanticLabel: semanticLabel.isEmpty ? null : semanticLabel,
      tooltip: tooltip.isEmpty ? null : tooltip,
      style: style,
      radiusMode: radiusMode,
      onChanged: (_) {},
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppChoiceChip)
Widget appChoiceChipStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppChoiceChip',
  description:
      'Selected and unselected across the three AppStyle treatments, the '
      'count pill on both states, the icon variant and disabled.',
  maxWidth: 860,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: <Widget>[
      for (final AppStyle style in AppStyle.values) ...<Widget>[
        wbState(
          context,
          name: '${style.name} · selected',
          child: AppChoiceChip(
            label: 'Novos',
            count: 8,
            selected: true,
            style: style,
            onChanged: (_) {},
          ),
        ),
        wbState(
          context,
          name: '${style.name} · unselected',
          child: AppChoiceChip(
            label: 'Abertas',
            count: 3,
            selected: false,
            style: style,
            onChanged: (_) {},
          ),
        ),
      ],
      wbState(
        context,
        name: 'with icon',
        child: AppChoiceChip(
          label: 'Favoritas',
          icon: AppIconToken.check,
          selected: true,
          onChanged: (_) {},
        ),
      ),
      wbState(
        context,
        name: 'disabled',
        child: const AppChoiceChip(
          label: 'Arquivadas',
          selected: false,
          onChanged: null,
        ),
      ),
      wbState(
        context,
        name: 'disabled · selected',
        child: const AppChoiceChip(
          label: 'Fixas',
          selected: true,
          onChanged: null,
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppChoiceChipBar — the filter bar. Scrolls (with the edge veil) where
// AppSegmentedButton would overflow; arrows walk the chips.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppChoiceChipBar)
Widget appChoiceChipBarPlayground(BuildContext context) {
  final AppChoiceChipLayout layout = context.knobs.object
      .dropdown<AppChoiceChipLayout>(
        label: 'layout',
        options: AppChoiceChipLayout.values,
        initialOption: AppChoiceChipLayout.scroll,
        labelBuilder: (AppChoiceChipLayout v) => v.name,
      );
  final bool multi = context.knobs.boolean(
    label: 'multi (Set-based)',
    initialValue: false,
  );
  final bool enabled = context.knobs.boolean(
    label: 'enabled',
    initialValue: true,
  );
  final double spacing = wbSpacingKnob(
    context,
    label: 'spacing',
    initial: AppSpacings.s8,
  );
  final String semanticLabel = context.knobs.string(
    label: 'semanticLabel',
    initialValue: 'Filter by status',
  );
  final double width = context.knobs.double.slider(
    label: 'stage width',
    initialValue: 300,
    min: 200,
    max: 600,
  );
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);

  const List<AppChoiceChipOption<String>> options =
      <AppChoiceChipOption<String>>[
        AppChoiceChipOption(value: 'all', label: 'Todas'),
        AppChoiceChipOption(value: 'queue', label: 'Novos', count: 8),
        AppChoiceChipOption(value: 'open', label: 'Abertas', count: 3),
        AppChoiceChipOption(value: 'waiting', label: 'Aguardando'),
        AppChoiceChipOption(value: 'done', label: 'Resolvidas', count: 41),
        AppChoiceChipOption(value: 'archived', label: 'Arquivadas'),
      ];

  String single = 'queue';
  Set<String> selected = <String>{'queue', 'open'};
  return wbUseCase(
    context,
    name: 'AppChoiceChipBar',
    description:
        'Single or multiple selection over typed options. scroll keeps the '
        'bar one line tall with an edge veil; wrap grows downward. Arrow keys '
        'walk the chips and the focused one scrolls into view.',
    child: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => SizedBox(
        width: width,
        child: multi
            ? AppChoiceChipBar<String>.multi(
                values: selected,
                onChanged: (Set<String> next) =>
                    setState(() => selected = next),
                options: options,
                layout: layout,
                spacing: spacing,
                enabled: enabled,
                semanticLabel: semanticLabel,
                style: style,
                radiusMode: radiusMode,
              )
            : AppChoiceChipBar<String>(
                value: single,
                onChanged: (String v) => setState(() => single = v),
                options: options,
                layout: layout,
                spacing: spacing,
                enabled: enabled,
                semanticLabel: semanticLabel,
                style: style,
                radiusMode: radiusMode,
              ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Scenario', type: AppChoiceChipBar)
Widget appChoiceChipBarScenario(BuildContext context) {
  String filter = 'queue';
  return wbUseCase(
    context,
    name: 'AppChoiceChipBar',
    description:
        'The inbox case: six statuses of very different widths, with counts, '
        'scrolling inside a 320px phone-width stage — the line that would '
        'overflow an AppSegmentedButton.',
    child: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => SizedBox(
        width: 320,
        child: AppChoiceChipBar<String>(
          value: filter,
          onChanged: (String v) => setState(() => filter = v),
          semanticLabel: 'Filtrar por status',
          options: const <AppChoiceChipOption<String>>[
            AppChoiceChipOption(value: 'all', label: 'Todas'),
            AppChoiceChipOption(
              value: 'queue',
              label: 'Novas/abertas',
              count: 8,
            ),
            AppChoiceChipOption(value: 'mine', label: 'Minhas', count: 2),
            AppChoiceChipOption(value: 'waiting', label: 'Aguardando cliente'),
            AppChoiceChipOption(value: 'done', label: 'Resolvidas', count: 41),
            AppChoiceChipOption(value: 'archived', label: 'Arquivadas'),
          ],
        ),
      ),
    ),
  );
}
