import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_assistant_panel.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    height: 420,
    width: 360,
    child: AppAssistantPanel(
      title: 'Atlas',
      statusLabel: 'Sempre online',
      alertBanner: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s16,
          vertical: AppSpacings.s8,
        ),
        child: AppText(
          '2 alertas não resolvidos',
          style: data.textTheme.bodySmall.withColor(data.colorTheme.warning),
        ),
      ),
      composer: Padding(
        padding: const EdgeInsets.all(AppSpacings.s16),
        child: AppText(
          'Pergunte ou digite / para comandos…',
          style: data.textTheme.bodySmall.withColor(
            data.colorTheme.neutralPrimary.s500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacings.s16),
        child: AppText(
          'Bom dia, João.',
          style: data.textTheme.bodyMedium.withColor(
            data.colorTheme.neutralPrimary.s900,
          ),
        ),
      ),
    ),
  ),
);

@Preview(name: 'AppAssistantPanel • claro')
Widget appAssistantPanelLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppAssistantPanel • escuro')
Widget appAssistantPanelDarkPreview() => _sample(AppThemeData.dark);
