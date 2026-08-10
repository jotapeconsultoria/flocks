// Exemplo do `flocks_lucide` — e o harness com que o ganho foi medido.
//
// Usa ~20 ícones pelos dois caminhos que o pacote oferece, porque eles se
// comportam de forma diferente no tree-shaking e medir só um mentiria:
//
//  - pelo `AppIconProvider` do tema, que resolve os 55 `AppIconToken`. Basta
//    instalar o provider para o mapa do contrato ficar alcançável, e então os
//    55 glifos são retidos, use a tela um ou cinquenta.
//  - pela classe `FlocksLucide`, uma constante de cada vez. Aqui o custo é
//    exatamente o que se escreve.
//
// Para medir:
//
//   flutter build web --release                     # com tree-shaking (padrão)
//   flutter build web --release --no-tree-shake-icons
//   du -k build/web/assets/packages/flocks_lucide/assets/fonts/lucide.ttf
import 'package:flocks/flocks.dart';
import 'package:flocks_lucide/flocks_lucide.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const ExampleApp());

/// Os ícones do contrato que a tela mostra — resolvidos por slug, pelo tema.
const List<AppIconToken> kContractIcons = <AppIconToken>[
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

/// Ícones de fora do contrato, escritos direto da classe.
///
/// São os que o provider não resolve por slug — e é assim que se chega neles
/// sem arrastar a fonte inteira.
const List<IconData> kDirectIcons = <IconData>[
  FlocksLucide.anchor,
  FlocksLucide.compass,
  FlocksLucide.dumbbell,
  FlocksLucide.store,
  FlocksLucide.tent,
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
    iconProvider: const LucideIconProvider(),
    builder: (BuildContext context, AppThemeData theme) => AppTheme(
      data: theme,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: theme.colorTheme.surface,
          child: Center(
            child: Wrap(
              children: <Widget>[
                for (final AppIconToken token in kContractIcons)
                  AppIcon(token, size: AppIconSize.l),
                for (final IconData icon in kDirectIcons)
                  LucideIcon(icon, color: theme.colorTheme.onSurface),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
