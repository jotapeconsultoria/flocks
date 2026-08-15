import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import 'app_badge.dart';

// Previews nativos (Regra 5) — renderizam no previewer da IDE (Flutter 3.44+).
// As cores vêm dos papéis semânticos do tema, então claro e escuro diferem.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const Wrap(
    spacing: AppSpacings.s8,
    runSpacing: AppSpacings.s8,
    children: <Widget>[
      AppBadge('Neutral'),
      AppBadge('Info', color: AppBadgeColor.info),
      AppBadge('Success', color: AppBadgeColor.success),
      AppBadge('Warning', color: AppBadgeColor.warning),
      AppBadge('Danger', color: AppBadgeColor.danger),
      AppBadge('Janela', icon: AppIconToken.clock, color: AppBadgeColor.info),
    ],
  ),
);

@Preview(name: 'AppBadge • claro')
Widget appBadgeLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppBadge • escuro')
Widget appBadgeDarkPreview() => _sample(AppThemeData.dark);

@Preview(name: 'AppBadge • tamanhos')
Widget appBadgeSizesPreview() => AppTheme(
  data: AppThemeData.light,
  child: const Wrap(
    spacing: AppSpacings.s8,
    runSpacing: AppSpacings.s8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      AppBadge('Small', color: AppBadgeColor.info, size: AppBadgeSize.s),
      AppBadge('Medium', color: AppBadgeColor.info),
      AppBadge('Large', color: AppBadgeColor.info, size: AppBadgeSize.l),
      AppBadge('Extra', color: AppBadgeColor.info, size: AppBadgeSize.xl),
    ],
  ),
);
