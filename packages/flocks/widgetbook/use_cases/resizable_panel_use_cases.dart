import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppResizablePanel — um painel com borda arrastável.
// ---------------------------------------------------------------------------

Widget _area(BuildContext context, String label) => ColoredBox(
  color: AppTheme.of(context).colorTheme.surfaceContainer,
  child: Center(child: AppText(label)),
);

/// O painel só faz sentido ao lado de algo que cede o espaço — daí o `Row` com
/// um `Expanded` fazendo o papel do conteúdo.
Widget _scene(
  BuildContext context, {
  required Widget panel,
  double height = 200,
}) => SizedBox(
  height: height,
  child: Row(
    children: <Widget>[
      Expanded(child: _area(context, 'Conteúdo')),
      panel,
    ],
  ),
);

@widgetbook.UseCase(name: 'Playground', type: AppResizablePanel)
Widget resizablePanelPlayground(BuildContext context) {
  final bool atEnd = context.knobs.boolean(label: 'edge = end');
  final double initialWidth = context.knobs.double.slider(
    label: 'initialWidth',
    initialValue: 180,
    min: 80,
    max: 320,
  );
  final double minWidth = context.knobs.double.slider(
    label: 'minWidth',
    initialValue: 120,
    min: 0,
    max: 200,
  );
  final double maxWidth = context.knobs.double.slider(
    label: 'maxWidth',
    initialValue: 320,
    min: 160,
    max: 420,
  );
  // A gutter é medida na escala de espaçamento (os limites já eram tokens):
  // slider livre aqui só produzia valores fora da escala.
  final double thickness = wbSpacingKnob(
    context,
    label: 'thickness',
    initial: AppSpacings.s16,
  );
  final String tooltip = context.knobs.string(
    label: 'tooltip',
    initialValue: 'Redimensionar',
  );

  final Widget panel = AppResizablePanel(
    edge: atEnd ? AppResizeEdge.end : AppResizeEdge.start,
    initialWidth: initialWidth,
    minWidth: minWidth,
    maxWidth: maxWidth,
    thickness: thickness,
    tooltip: tooltip.isEmpty ? null : tooltip,
    child: _area(context, 'Assistente'),
  );

  return wbUseCase(
    context,
    name: 'AppResizablePanel',
    description:
        'A single panel with a draggable edge, measured in pixels. Drag the '
        'handle, or double-tap it to reset. maxWidth comes from the caller; '
        'persistence too (onWidthChanged).',
    maxWidth: 560,
    child: atEnd
        ? SizedBox(
            height: 200,
            child: Row(
              children: <Widget>[
                panel,
                Expanded(child: _area(context, 'Conteúdo')),
              ],
            ),
          )
        : _scene(context, panel: panel),
  );
}

@widgetbook.UseCase(name: 'States', type: AppResizablePanel)
Widget resizablePanelStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppResizablePanel',
  description:
      'Handle on either edge, and a panel already pinned to its minWidth '
      '(dragging inwards no longer shrinks it).',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'edge: start',
        width: 320,
        child: _scene(
          context,
          panel: AppResizablePanel(
            initialWidth: 140,
            minWidth: 100,
            maxWidth: 220,
            child: _area(context, 'Assistente'),
          ),
        ),
      ),
      wbState(
        context,
        name: 'edge: end',
        width: 320,
        child: SizedBox(
          height: 200,
          child: Row(
            children: <Widget>[
              AppResizablePanel(
                edge: AppResizeEdge.end,
                initialWidth: 140,
                minWidth: 100,
                maxWidth: 220,
                child: _area(context, 'Navegação'),
              ),
              Expanded(child: _area(context, 'Conteúdo')),
            ],
          ),
        ),
      ),
      wbState(
        context,
        name: 'no piso (minWidth)',
        width: 320,
        child: _scene(
          context,
          panel: AppResizablePanel(
            initialWidth: 120,
            minWidth: 120,
            maxWidth: 240,
            child: _area(context, 'Assistente'),
          ),
        ),
      ),
    ],
  ),
);
