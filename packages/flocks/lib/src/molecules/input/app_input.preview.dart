import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import 'app_input.dart';

// Previews nativos (Regra 5) — os estados que convivem num formulário real:
// repouso com ajuda, preenchido, erro (a mensagem SUBSTITUI a ajuda, não
// empilha) e desabilitado.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surface,
    child: const Padding(
      padding: EdgeInsets.all(AppSpacings.s24),
      child: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacings.s16,
          children: <Widget>[
            AppInput(
              label: 'E-mail',
              hintText: 'nome@dominio.com',
              prefixIcon: AppIconToken.user,
              helperText: 'Usamos seu e-mail só para login.',
            ),
            AppInput(label: 'Nome', initialValue: 'João Martins'),
            AppInput(
              label: 'Placa',
              initialValue: 'ABC',
              errorText: 'Placa incompleta.',
            ),
            AppInput(label: 'Conta', initialValue: 'Jotape', enabled: false),
          ],
        ),
      ),
    ),
  ),
);

@Preview(name: 'AppInput • claro')
Widget appInputLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppInput • escuro')
Widget appInputDarkPreview() => _sample(AppThemeData.dark);
