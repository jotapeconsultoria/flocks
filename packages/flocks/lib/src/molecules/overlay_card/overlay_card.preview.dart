import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_overlay_card.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const Padding(
    padding: EdgeInsets.all(AppSpacings.s16),
    child: SizedBox(
      width: 280,
      child: AppOverlayCard(child: AppText('Painel flutuante sobre o mapa')),
    ),
  ),
);

@Preview(name: 'AppOverlayCard • claro')
Widget appOverlayCardLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppOverlayCard • escuro')
Widget appOverlayCardDarkPreview() => _sample(AppThemeData.dark);
