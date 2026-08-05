import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../molecules/buttons/app_floating_button.dart';
import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import 'app_auth_split_layout.dart';
import 'app_scaffold.dart';

// Previews nativos (Regra 5) — header/conteúdo/footer sobre a surface do tema.

Widget _sample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 360,
    height: 240,
    child: AppScaffold(
      header: Padding(
        padding: const EdgeInsets.all(AppSpacings.s16),
        child: AppText('Veículos', style: data.textTheme.titleLarge),
      ),
      footer: Padding(
        padding: const EdgeInsets.all(AppSpacings.s16),
        child: AppText('Salvar', style: data.textTheme.titleMedium),
      ),
      floatingAction: AppFloatingButton(
        icon: AppIconToken.add,
        semanticsLabel: 'Novo',
        onPressed: () {},
      ),
      child: Center(
        child: AppText('Conteúdo', style: data.textTheme.bodyLarge),
      ),
    ),
  ),
);

@Preview(name: 'AppScaffold • claro')
Widget appScaffoldLightPreview() => _sample(AppThemeData.light);

@Preview(name: 'AppScaffold • escuro')
Widget appScaffoldDarkPreview() => _sample(AppThemeData.dark);

// O layout de autenticação: painel de marca à esquerda, formulário à direita.
// Precisa de largura de desktop — abaixo do breakpoint ele colapsa numa coluna
// só e o painel de marca some, que é justamente o que se quer ver aqui.
Widget _authSample(AppThemeData data) => AppTheme(
  data: data,
  child: SizedBox(
    width: 900,
    height: 520,
    child: AppAuthSplitLayout(
      logoUrl: 'assets/illustrations/logo.svg',
      brandTitle: 'Bem-vindo de volta',
      brandSubtitle: 'Acesse sua conta para continuar.',
      child: Center(
        child: AppText('formulário', style: data.textTheme.bodyLarge),
      ),
    ),
  ),
);

@Preview(name: 'AppAuthSplitLayout • claro')
Widget appAuthSplitLayoutLightPreview() => _authSample(AppThemeData.light);

@Preview(name: 'AppAuthSplitLayout • escuro')
Widget appAuthSplitLayoutDarkPreview() => _authSample(AppThemeData.dark);
