import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppFilterChip — Playground (todos os knobs) + Catalog (a fila de filtros
// aplicados, que é como ele aparece de verdade).
//
// O Catalog existe porque o chip sozinho não mostra o problema que ele resolve:
// é numa FILA deles que a leitura precisa cair sobre o valor, e é numa fila que
// dois alvos de toque por chip deixam de ser detalhe.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppFilterChip)
Widget appFilterChipPlayground(BuildContext context) {
  final field = context.knobs.string(label: 'field', initialValue: 'Tipo');
  final value = context.knobs.string(
    label: 'value',
    initialValue: 'client.created',
  );
  final removable = context.knobs.boolean(
    label: 'removable',
    initialValue: true,
  );
  return wbUseCase(
    context,
    name: 'AppFilterChip',
    description:
        'An applied filter, with its own remove target. Clear onRemove to '
        'make it informational only.',
    child: AppFilterChip(
      field: field.isEmpty ? null : field,
      value: value,
      onRemove: removable ? () {} : null,
      onTap: () {},
      style: wbStyleKnob(context, nullLabel: 'Default (filled)'),
      radiusMode: wbRadiusModeKnob(context),
    ),
  );
}

@widgetbook.UseCase(name: 'Catalog', type: AppFilterChip)
Widget appFilterChipCatalog(BuildContext context) => wbUseCase(
  context,
  name: 'AppFilterChip',
  description:
      'How it actually shows up: a row of applied filters above a list. Fast '
      'reading has to land on the value, not on the field name.',
  child: SizedBox(
    width: 520,
    child: Wrap(
      spacing: AppSpacings.s8,
      runSpacing: AppSpacings.s8,
      children: <Widget>[
        AppFilterChip(field: 'Tipo', value: 'client.created', onRemove: () {}),
        AppFilterChip(field: 'Resultado', value: 'Negado', onRemove: () {}),
        AppFilterChip(
          field: 'Período',
          value: 'últimos 7 dias',
          onRemove: () {},
        ),
        AppFilterChip(
          field: 'Correlação',
          value: 'c7f1a2b3-...-9e0d',
          onRemove: () {},
        ),
        const AppFilterChip(value: 'somente meus eventos'),
      ],
    ),
  ),
);
