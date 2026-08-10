// Exemplo do `flocks_cupertino` — o eixo de ícone sendo trocado, e nada mais
// mudando.
//
// As constantes abaixo são `AppIconToken`, o contrato de 55 ícones do `flocks`.
// Este arquivo não sabe que existe Cupertino. Quem sabe é a **única** linha que
// instala o provider — e trocá-la por `MaterialIconProvider()` ou
// `LucideIconProvider()` muda os desenhos sem tocar em mais nada da árvore.
//
// Os glifos vêm da fonte MIT do pacote `cupertino_icons`, e não dos SF Symbols
// da Apple, que não podem ser redistribuídos. Ver o README do pacote.
//
// Para rodar:
//
//   flutter run            # ou -d chrome
import 'package:flocks/flocks.dart';
import 'package:flocks_cupertino/flocks_cupertino.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const ExampleApp());

/// Ícones do contrato — resolvidos por slug, pelo provider do tema.
///
/// São `AppIconToken`, não `IconData`: um `extension type` sobre `String`, que
/// é o que permite a um provider qualquer resolvê-los sem conhecer o set do
/// outro. Nome de fora do contrato cai num fallback visível, e não some.
const List<AppIconToken> kIcons = <AppIconToken>[
  AppIconToken.calendar,
  AppIconToken.check,
  AppIconToken.chevronRight,
  AppIconToken.close,
  AppIconToken.filter,
  AppIconToken.mail,
  AppIconToken.pencil,
  AppIconToken.search,
  AppIconToken.settings,
  AppIconToken.user,
];

/// Modo de tema fixo — o exemplo não tem preferência de usuário a observar.
final ValueNotifier<AppThemeMode> _mode = ValueNotifier<AppThemeMode>(
  AppThemeMode.light,
);

/// O app de exemplo.
final class ExampleApp extends StatelessWidget {
  /// Cria o app.
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => AppThemeScope(
    mode: _mode,
    // A linha inteira do pacote. Troque por `MaterialIconProvider()` e os
    // mesmos dez tokens abaixo saem desenhados pelo Material.
    iconProvider: const CupertinoIconProvider(),
    builder: (BuildContext context, AppThemeData theme) => AppTheme(
      data: theme,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: theme.colorTheme.surface,
          child: Center(
            child: Wrap(
              spacing: AppSpacings.s12,
              runSpacing: AppSpacings.s12,
              children: <Widget>[
                for (final AppIconToken token in kIcons)
                  AppIcon(token, size: AppIconSize.l),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
