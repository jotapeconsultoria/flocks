import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// dropdown family — one Playground per variant. Opening/selecting IS the
// interaction, so there is NO CTA.
// ---------------------------------------------------------------------------

const List<AppDropdownOption<String>> _opts = <AppDropdownOption<String>>[
  AppDropdownOption<String>(value: 'banana', label: 'Banana'),
  AppDropdownOption<String>(value: 'manga', label: 'Manga'),
  AppDropdownOption<String>(value: 'uva', label: 'Uva'),
  AppDropdownOption<String>(value: 'melancia', label: 'Melancia'),
];

_Knobs _knobs(BuildContext context) => (
  label: context.knobs.string(label: 'label', initialValue: 'Fruta'),
  hint: context.knobs.string(label: 'hintText', initialValue: 'Selecione'),
  enabled: context.knobs.boolean(label: 'enabled', initialValue: true),
  error: context.knobs.boolean(label: 'hasError', initialValue: false),
  info: context.knobs.boolean(label: 'info (popover)', initialValue: false),
  helper: context.knobs.string(label: 'helperText'),
  size: wbFieldSizeKnob(context),
  style: wbStyleKnob(context),
);

@widgetbook.UseCase(name: 'Playground', type: AppDropdown)
Widget dropdownPlayground(BuildContext context) {
  final k = _knobs(context);
  return wbUseCase(
    context,
    name: 'AppDropdown',
    description: 'Single select; open it and pick an option.',
    child: SizedBox(
      width: 300,
      child: _SingleDemo(knobs: k, searchable: false),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppSearchableDropdown)
Widget searchableDropdownPlayground(BuildContext context) {
  final k = _knobs(context);
  return wbUseCase(
    context,
    name: 'AppSearchableDropdown',
    description: 'Single select with a search filter in the overlay.',
    child: SizedBox(width: 300, child: _SingleDemo(knobs: k, searchable: true)),
  );
}

const List<AppDropdownOption<String>> _sectionedOpts =
    <AppDropdownOption<String>>[
      AppDropdownOption<String>(
        value: 'utc',
        label: 'UTC',
        section: 'Recomendados',
      ),
      AppDropdownOption<String>(
        value: 'sp',
        label: 'America/Sao_Paulo · BR',
        section: 'Recomendados',
      ),
      AppDropdownOption<String>(
        value: 'ny',
        label: 'America/New_York · US',
        section: 'Todos os fusos',
      ),
      AppDropdownOption<String>(
        value: 'lon',
        label: 'Europe/London · GB',
        section: 'Todos os fusos',
      ),
    ];

@widgetbook.UseCase(name: 'Scenario', type: AppSearchableDropdown)
Widget searchableDropdownSections(BuildContext context) => wbUseCase(
  context,
  name: 'AppSearchableDropdown',
  description:
      'A real timezone picker: section headers group the options, with a '
      'recommended block on top. Open it to see the "Recomendados" header — '
      'without the grouping, a list of 400 timezones is a wall.',
  child: SizedBox(
    width: 320,
    child: AppSearchableDropdown<String>(
      label: 'Timezone',
      hintText: 'Selecione',
      searchHintText: 'Buscar…',
      options: _sectionedOpts,
      onChanged: (_) {},
    ),
  ),
);

@widgetbook.UseCase(name: 'Playground', type: AppMultiSelect)
Widget multiSelectPlayground(BuildContext context) {
  final k = _knobs(context);
  final multiline = context.knobs.boolean(
    label: 'multiline (grows; otherwise 1 line + scroll)',
    initialValue: false,
  );
  return wbUseCase(
    context,
    name: 'AppMultiSelect',
    description: 'Multi select; chips + stays open on select.',
    child: SizedBox(
      width: 300,
      child: _MultiDemo(knobs: k, searchable: false, multiline: multiline),
    ),
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppSearchableMultiSelect)
Widget searchableMultiSelectPlayground(BuildContext context) {
  final k = _knobs(context);
  final multiline = context.knobs.boolean(
    label: 'multiline (grows; otherwise 1 line + scroll)',
    initialValue: false,
  );
  return wbUseCase(
    context,
    name: 'AppSearchableMultiSelect',
    description: 'Multi select with a search filter in the overlay.',
    child: SizedBox(
      width: 300,
      child: _MultiDemo(knobs: k, searchable: true, multiline: multiline),
    ),
  );
}

typedef _Knobs = ({
  String? label,
  String? hint,
  String? helper,
  bool enabled,
  bool error,
  bool info,
  AppFieldSize size,
  AppStyle? style,
});

/// Conteúdo do popover de info dos playgrounds (quando o knob está ligado).
Widget? _infoContent(_Knobs k) =>
    k.info ? const AppText('Escolha uma ou mais frutas.') : null;

class _SingleDemo extends StatefulWidget {
  const _SingleDemo({required this.knobs, required this.searchable});
  final _Knobs knobs;
  final bool searchable;
  @override
  State<_SingleDemo> createState() => _SingleDemoState();
}

class _SingleDemoState extends State<_SingleDemo> {
  String? _value;
  @override
  Widget build(BuildContext context) => widget.searchable
      ? AppSearchableDropdown<String>(
          label: widget.knobs.label,
          info: _infoContent(widget.knobs),
          hintText: widget.knobs.hint,
          searchHintText: 'Buscar…',
          options: _opts,
          selectedValue: _value,
          enabled: widget.knobs.enabled,
          hasError: widget.knobs.error,
          errorText: widget.knobs.error ? 'Campo obrigatório' : null,
          size: widget.knobs.size,
          helperText: widget.knobs.helper?.isEmpty ?? true
              ? null
              : widget.knobs.helper,
          style: widget.knobs.style,
          onChanged: (v) => setState(() => _value = v),
        )
      : AppDropdown<String>(
          label: widget.knobs.label,
          info: _infoContent(widget.knobs),
          hintText: widget.knobs.hint,
          options: _opts,
          selectedValue: _value,
          enabled: widget.knobs.enabled,
          hasError: widget.knobs.error,
          errorText: widget.knobs.error ? 'Campo obrigatório' : null,
          size: widget.knobs.size,
          helperText: widget.knobs.helper?.isEmpty ?? true
              ? null
              : widget.knobs.helper,
          style: widget.knobs.style,
          onChanged: (v) => setState(() => _value = v),
        );
}

class _MultiDemo extends StatefulWidget {
  const _MultiDemo({
    required this.knobs,
    required this.searchable,
    this.multiline = false,
  });
  final _Knobs knobs;
  final bool searchable;
  final bool multiline;
  @override
  State<_MultiDemo> createState() => _MultiDemoState();
}

class _MultiDemoState extends State<_MultiDemo> {
  List<String> _values = <String>[];
  @override
  Widget build(BuildContext context) => widget.searchable
      ? AppSearchableMultiSelect<String>(
          label: widget.knobs.label,
          info: _infoContent(widget.knobs),
          hintText: widget.knobs.hint,
          searchHintText: 'Buscar…',
          options: _opts,
          selectedValues: _values,
          enabled: widget.knobs.enabled,
          hasError: widget.knobs.error,
          errorText: widget.knobs.error ? 'Campo obrigatório' : null,
          size: widget.knobs.size,
          helperText: widget.knobs.helper?.isEmpty ?? true
              ? null
              : widget.knobs.helper,
          style: widget.knobs.style,
          multiline: widget.multiline,
          onChanged: (v) => setState(() => _values = v),
        )
      : AppMultiSelect<String>(
          label: widget.knobs.label,
          info: _infoContent(widget.knobs),
          hintText: widget.knobs.hint,
          options: _opts,
          selectedValues: _values,
          enabled: widget.knobs.enabled,
          hasError: widget.knobs.error,
          errorText: widget.knobs.error ? 'Campo obrigatório' : null,
          size: widget.knobs.size,
          helperText: widget.knobs.helper?.isEmpty ?? true
              ? null
              : widget.knobs.helper,
          style: widget.knobs.style,
          multiline: widget.multiline,
          onChanged: (v) => setState(() => _values = v),
        );
}

// ---------------------------------------------------------------------------
// States — placeholder / selected / error / disabled, static per variant.
// ---------------------------------------------------------------------------

Widget _stateCard(
  BuildContext context, {
  required String name,
  required String when,
  required Widget child,
}) => wbState(
  context,
  name: name,
  when: when,
  width: 280,
  child: SizedBox(width: 280, child: child),
);

@widgetbook.UseCase(name: 'States', type: AppDropdown)
Widget dropdownStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDropdown',
  description: 'Placeholder, selected, error and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      _stateCard(
        context,
        name: 'Placeholder',
        when: 'Nothing picked',
        child: AppDropdown<String>(
          label: 'Fruta',
          hintText: 'Selecione',
          options: _opts,
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Selected',
        when: 'A value is set',
        child: AppDropdown<String>(
          label: 'Fruta',
          options: _opts,
          selectedValue: 'banana',
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Error',
        when: 'Invalid value',
        child: AppDropdown<String>(
          label: 'Fruta',
          hintText: 'Selecione',
          options: _opts,
          hasError: true,
          errorText: 'Campo obrigatório',
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Error + selected',
        when: 'Suffix clears + reopens',
        child: AppDropdown<String>(
          label: 'Fruta',
          options: _opts,
          selectedValue: 'banana',
          hasError: true,
          errorText: 'Campo obrigatório',
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        child: AppDropdown<String>(
          label: 'Fruta',
          hintText: 'Selecione',
          options: _opts,
          enabled: false,
          onChanged: (_) {},
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppSearchableDropdown)
Widget searchableDropdownStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSearchableDropdown',
  description: 'Placeholder, selected, error and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      _stateCard(
        context,
        name: 'Placeholder',
        when: 'Nothing picked',
        child: AppSearchableDropdown<String>(
          label: 'Fruta',
          hintText: 'Selecione',
          searchHintText: 'Buscar…',
          options: _opts,
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Selected',
        when: 'A value is set',
        child: AppSearchableDropdown<String>(
          label: 'Fruta',
          searchHintText: 'Buscar…',
          options: _opts,
          selectedValue: 'uva',
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Error',
        when: 'Invalid value',
        child: AppSearchableDropdown<String>(
          label: 'Fruta',
          hintText: 'Selecione',
          searchHintText: 'Buscar…',
          options: _opts,
          hasError: true,
          errorText: 'Campo obrigatório',
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        child: AppSearchableDropdown<String>(
          label: 'Fruta',
          hintText: 'Selecione',
          searchHintText: 'Buscar…',
          options: _opts,
          enabled: false,
          onChanged: (_) {},
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppMultiSelect)
Widget multiSelectStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppMultiSelect',
  description: 'Empty, with chips, error and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      _stateCard(
        context,
        name: 'Empty',
        when: 'Nothing picked',
        child: AppMultiSelect<String>(
          label: 'Frutas',
          hintText: 'Selecione',
          options: _opts,
          selectedValues: const <String>[],
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Chips',
        when: 'Some selected',
        child: AppMultiSelect<String>(
          label: 'Frutas',
          options: _opts,
          selectedValues: const <String>['banana', 'uva'],
          multiline: true,
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Error',
        when: 'Invalid value',
        child: AppMultiSelect<String>(
          label: 'Frutas',
          hintText: 'Selecione',
          options: _opts,
          selectedValues: const <String>[],
          hasError: true,
          errorText: 'Campo obrigatório',
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Error + chips',
        when: 'Suffix clears + reopens',
        child: AppMultiSelect<String>(
          label: 'Frutas',
          options: _opts,
          selectedValues: const <String>['banana', 'uva'],
          hasError: true,
          errorText: 'Campo obrigatório',
          multiline: true,
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        child: AppMultiSelect<String>(
          label: 'Frutas',
          hintText: 'Selecione',
          options: _opts,
          selectedValues: const <String>['banana'],
          enabled: false,
          multiline: true,
          onChanged: (_) {},
        ),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppSearchableMultiSelect)
Widget searchableMultiSelectStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppSearchableMultiSelect',
  description: 'Empty, with chips, error and disabled at a glance.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      _stateCard(
        context,
        name: 'Empty',
        when: 'Nothing picked',
        child: AppSearchableMultiSelect<String>(
          label: 'Frutas',
          hintText: 'Selecione',
          searchHintText: 'Buscar…',
          options: _opts,
          selectedValues: const <String>[],
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Chips',
        when: 'Some selected',
        child: AppSearchableMultiSelect<String>(
          label: 'Frutas',
          searchHintText: 'Buscar…',
          options: _opts,
          selectedValues: const <String>['banana', 'uva'],
          multiline: true,
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Error',
        when: 'Invalid value',
        child: AppSearchableMultiSelect<String>(
          label: 'Frutas',
          hintText: 'Selecione',
          searchHintText: 'Buscar…',
          options: _opts,
          selectedValues: const <String>[],
          hasError: true,
          errorText: 'Campo obrigatório',
          onChanged: (_) {},
        ),
      ),
      _stateCard(
        context,
        name: 'Disabled',
        when: 'Unavailable',
        child: AppSearchableMultiSelect<String>(
          label: 'Frutas',
          hintText: 'Selecione',
          searchHintText: 'Buscar…',
          options: _opts,
          selectedValues: const <String>['banana'],
          enabled: false,
          multiline: true,
          onChanged: (_) {},
        ),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppDropdown — Glass over backdrop. O painel do dropdown segue o eixo glass
// GLOBAL (não tem override por instância): quem manda é o addon Glass / a marca.
// Antes de o painel adotar o AppOverlayPanel ele era sempre opaco, porque o
// AppCard ignora o eixo de propósito.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Glass over backdrop', type: AppDropdown)
Widget dropdownGlass(BuildContext context) {
  return wbUseCase(
    context,
    name: 'AppDropdown · Glass',
    description:
        'Open the select over the colorful feed: the options panel frosts what '
        'is behind it. Requires the global Glass addon (or a glass brand) — the '
        'panel follows the global axis and has no per-instance override.',
    panel: false,
    child: wbGlassStage(
      context,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacings.s32),
          child: SizedBox(
            width: 260,
            child: AppDropdown<String>(
              label: 'Fruit',
              hintText: 'Select',
              options: const <AppDropdownOption<String>>[
                AppDropdownOption<String>(value: 'banana', label: 'Banana'),
                AppDropdownOption<String>(value: 'mango', label: 'Mango'),
                AppDropdownOption<String>(value: 'melon', label: 'Melon'),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    ),
  );
}
