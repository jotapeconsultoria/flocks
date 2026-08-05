import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_side_inset.dart';

// Previews nativos (Regra 5). O recuo vem do MediaQuery, então o preview
// PUBLICA um, como faria o side sheet. As duas caixas mostram o antes e o
// depois: mesmo conteúdo, mesma largura, uma dentro do AppSideInset.

const EdgeInsets _published = EdgeInsets.only(left: 24, right: 24);

Widget _box(
  AppThemeData data, {
  required Widget child,
  required String label,
}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  spacing: AppSpacings.s8,
  children: <Widget>[
    AppText(label, style: data.textTheme.labelSmall),
    SizedBox(
      width: 220,
      height: 88,
      child: ColoredBox(color: data.colorTheme.surfaceContainer, child: child),
    ),
  ],
);

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: MediaQuery(
    // O que a superfície hospedeira publicaria.
    data: const MediaQueryData(padding: _published),
    child: ColoredBox(
      color: data.colorTheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.s24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacings.s24,
          children: <Widget>[
            _box(
              data,
              label: 'sem AppSideInset',
              child: const AppText('Encosta na borda'),
            ),
            _box(
              data,
              label: 'com AppSideInset',
              child: const AppSideInset(child: AppText('Respira 24px')),
            ),
          ],
        ),
      ),
    ),
  ),
);

@Preview(name: 'AppSideInset • claro')
Widget appSideInsetLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppSideInset • escuro')
Widget appSideInsetDarkPreview() => _sample(AppThemeData.dark);
