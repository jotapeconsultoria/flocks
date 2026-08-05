import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppPickerAnchor — a máquina de overlay dos pickers, desacoplada do input.
// Aqui um BOTÃO (não um AppInput) abre um AppDatePicker, provando o reuso fora
// do campo. O trigger É a interação → sem CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppPickerAnchor)
Widget pickerAnchorPlayground(BuildContext context) {
  final placement = context.knobs.object.dropdown<AppOverlayPlacement>(
    label: 'placement',
    options: AppOverlayPlacement.values,
    initialOption: AppOverlayPlacement.bottomStart,
    labelBuilder: (p) => 'AppOverlayPlacement.${p.name}',
  );
  return wbUseCase(
    context,
    name: 'AppPickerAnchor',
    description:
        'Reusable trigger → anchored panel. Here a button (not an input) opens '
        'a date picker; the panel closes on pick.',
    child: _PickerAnchorDemo(placement: placement),
  );
}

class _PickerAnchorDemo extends StatefulWidget {
  const _PickerAnchorDemo({required this.placement});

  final AppOverlayPlacement placement;

  @override
  State<_PickerAnchorDemo> createState() => _PickerAnchorDemoState();
}

class _PickerAnchorDemoState extends State<_PickerAnchorDemo> {
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    final String label = _date == null
        ? 'Escolher data'
        : '${_date!.day.toString().padLeft(2, '0')}/'
              '${_date!.month.toString().padLeft(2, '0')}/${_date!.year}';
    return AppPickerAnchor(
      placement: widget.placement,
      width: const AppPickerWidth.matchTrigger(min: 300),
      trigger: (context, handle) =>
          AppButton(label: label, onPressed: handle.toggle),
      panel: (context, handle) => AppDatePicker(
        initialDate: _date ?? DateTime(2026, 7, 14),
        onDateSelected: (d) {
          setState(() => _date = d);
          handle.close();
        },
      ),
    );
  }
}

@widgetbook.UseCase(name: 'States', type: AppPickerAnchor)
Widget pickerAnchorStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppPickerAnchor',
  description:
      'The same trigger anchored on different sides (open to compare).',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Bottom start',
        when: 'Opens below-left',
        width: 200,
        child: const _PickerAnchorDemo(
          placement: AppOverlayPlacement.bottomStart,
        ),
      ),
      wbState(
        context,
        name: 'Bottom end',
        when: 'Opens below-right',
        width: 200,
        child: const _PickerAnchorDemo(
          placement: AppOverlayPlacement.bottomEnd,
        ),
      ),
      wbState(
        context,
        name: 'Top start',
        when: 'Opens above-left',
        width: 200,
        child: const _PickerAnchorDemo(placement: AppOverlayPlacement.topStart),
      ),
    ],
  ),
);

// ---------------------------------------------------------------------------
// AppPickerAnchor — Glass over backdrop. Cobre por tabela todos os *PickerInput
// (date/time/date-time/color), que pintam o painel por este âncora.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Glass over backdrop', type: AppPickerAnchor)
Widget pickerAnchorGlass(BuildContext context) {
  final theme = AppTheme.of(context);
  return wbUseCase(
    context,
    name: 'AppPickerAnchor · Glass',
    description:
        'Open the panel over the colorful feed: it frosts what is behind it. '
        'This anchor paints the surface for every *PickerInput (date, time, '
        'date-time, color), so they all inherit the glass axis from here.',
    panel: false,
    child: wbGlassStage(
      context,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacings.s32),
          child: SizedBox(
            width: 240,
            child: AppPickerAnchor(
              panelGlass: true,
              trigger: (context, handle) => GestureDetector(
                onTap: handle.toggle,
                child: const AppCard(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacings.s12),
                    child: AppText('Open the panel'),
                  ),
                ),
              ),
              panel: (context, handle) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AppText('Panel content', style: theme.textTheme.titleSmall),
                  const SizedBox(height: AppSpacings.s8),
                  const AppText('The blur samples the feed underneath.'),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
