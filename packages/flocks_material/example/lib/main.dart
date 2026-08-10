// Exemplo do `flocks_material` — o eixo de ícone sendo trocado, e nada mais
// mudando.
//
// O ponto do pacote é esse, e ele só aparece quando se compara: as constantes
// abaixo são `AppIconToken`, o contrato de 55 ícones do `flocks`. Este arquivo
// não sabe que existe Material. Quem sabe é a **única** linha que instala o
// provider — e trocá-la por `PhosphorIconProvider()` (do `flocks_phosphor`)
// muda os desenhos sem tocar em mais nada da árvore.
//
// É por isso que o adaptador mora fora do core: um `import 'material.dart'`
// dentro do `flocks` derrubaria a tese de zero Material para todo mundo, não só
// para quem quisesse os ícones do Google.
//
// Para rodar:
//
//   flutter run            # ou -d chrome
import 'package:flocks/flocks.dart';
import 'package:flocks_material/flocks_material.dart';
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
    // A linha inteira do pacote. Troque por `PhosphorIconProvider()` e os
    // mesmos dez tokens abaixo saem desenhados pelo Phosphor.
    iconProvider: const MaterialIconProvider(),
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
