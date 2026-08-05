import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_shell.dart';

// Previews nativos (Regra 5) — claro e escuro.

Widget _band(AppThemeData data, String label, {double? width}) => SizedBox(
  width: width,
  child: Padding(
    padding: const EdgeInsets.all(AppSpacings.s16),
    child: AppText(
      label,
      style: data.textTheme.bodySmall.withColor(
        data.colorTheme.neutralPrimary.s600,
      ),
    ),
  ),
);

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    height: 320,
    width: 640,
    child: AppShell(
      header: _band(data, 'header'),
      rail: _band(data, 'rail', width: 120),
      aside: _band(data, 'aside', width: 140),
      content: Center(
        child: AppText(
          'content',
          style: data.textTheme.titleMedium.withColor(
            data.colorTheme.neutralPrimary.s900,
          ),
        ),
      ),
    ),
  ),
);

Widget _fullscreenSample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    height: 320,
    width: 640,
    child: AppShell(
      fullscreen: true,
      header: _band(data, 'header'),
      rail: _band(data, 'rail', width: 120),
      aside: _band(data, 'aside', width: 140),
      content: Center(
        child: AppText(
          'content em fullscreen',
          style: data.textTheme.titleMedium.withColor(
            data.colorTheme.neutralPrimary.s900,
          ),
        ),
      ),
    ),
  ),
);

@Preview(name: 'AppShell • claro')
Widget appShellLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppShell • escuro')
Widget appShellDarkPreview() => _sample(AppThemeData.dark);

@Preview(name: 'AppShell • fullscreen')
Widget appShellFullscreenPreview() => _fullscreenSample(AppThemeData.light);
