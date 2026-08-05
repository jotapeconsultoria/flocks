import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import 'app_timeline.dart';

// Previews nativos (Regra 5) — uma trilha curta, clara e escura.

const List<(String, String)> _eventos = <(String, String)>[
  ('Cliente encerrado', 'há 2 minutos · Ana Souza'),
  ('Retenção alterada', 'há 1 hora · Equipe Trackd'),
  ('Cliente criado', 'ontem · Ana Souza'),
];

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 420,
    height: 240,
    child: AppTimeline(
      itemCount: _eventos.length,
      itemBuilder: (BuildContext context, int i) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            _eventos[i].$1,
            style: AppTheme.of(context).textTheme.bodyMedium,
          ),
          AppText(
            _eventos[i].$2,
            style: AppTheme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  ),
);

@Preview(name: 'AppTimeline • claro')
Widget appTimelineLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppTimeline • escuro')
Widget appTimelineDarkPreview() => _sample(AppThemeData.dark);
