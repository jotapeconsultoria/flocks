import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_choice_chip.dart';
import 'app_choice_chip_bar.dart';

// Previews nativos (Regra 5) — o AppChoiceChip nos dois estados e um
// AppChoiceChipBar de filtros rolando numa viewport estreita, claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: Center(
    child: SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppChoiceChip(
                label: 'Novos',
                count: 8,
                selected: true,
                onChanged: (_) {},
              ),
              const SizedBox(width: 8),
              AppChoiceChip(
                label: 'Abertas',
                selected: false,
                onChanged: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppChoiceChipBar<String>(
            value: 'queue',
            onChanged: (_) {},
            semanticLabel: 'Filtrar por status',
            options: const <AppChoiceChipOption<String>>[
              AppChoiceChipOption(value: 'all', label: 'Todas'),
              AppChoiceChipOption(value: 'queue', label: 'Novos', count: 8),
              AppChoiceChipOption(value: 'open', label: 'Abertas', count: 3),
              AppChoiceChipOption(value: 'done', label: 'Resolvidas'),
            ],
          ),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppChoiceChip • claro')
Widget appChoiceChipLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppChoiceChip • escuro')
Widget appChoiceChipDarkPreview() => _sample(AppThemeData.dark);
