import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_assistant_status.dart';

// Previews nativos (Regra 5) — o rótulo de etapa do assistente, com indicador.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const AppAssistantStatus(label: 'Buscando dados da frota'),
);

@Preview(name: 'AppAssistantStatus • claro')
Widget appAssistantStatusLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppAssistantStatus • escuro')
Widget appAssistantStatusDarkPreview() => _sample(AppThemeData.dark);
