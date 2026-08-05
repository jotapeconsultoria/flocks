import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_message_meta.dart';

// Previews nativos (Regra 5) — todos os status de entrega (o tique do WhatsApp).

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: const Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AppMessageMeta(time: '10:30', status: AppMessageStatus.sending),
      SizedBox(height: AppSpacings.s4),
      AppMessageMeta(time: '10:31', status: AppMessageStatus.sent),
      SizedBox(height: AppSpacings.s4),
      AppMessageMeta(time: '10:32', status: AppMessageStatus.delivered),
      SizedBox(height: AppSpacings.s4),
      AppMessageMeta(time: '10:33', status: AppMessageStatus.read),
      SizedBox(height: AppSpacings.s4),
      AppMessageMeta(
        time: '10:34',
        edited: true,
        status: AppMessageStatus.failed,
      ),
    ],
  ),
);

@Preview(name: 'AppMessageMeta • claro')
Widget appMessageMetaLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppMessageMeta • escuro')
Widget appMessageMetaDarkPreview() => _sample(AppThemeData.dark);
