// Exemplo do `flocks_phosphor` — e o harness com que o ganho foi medido.
//
// Usa ~20 ícones pelos dois caminhos que o pacote oferece, porque eles se
// comportam de forma diferente no tree-shaking e medir só um mentiria:
//
//  - pelo `AppIconProvider` do tema, que resolve os 55 `AppIconToken`. Basta
//    instalar o provider para os seis mapas do contrato ficarem alcançáveis, e
//    então os 55 glifos são retidos em cada peso, use a tela um ou cinquenta.
//  - pelas classes por peso, uma constante de cada vez. Aqui o custo é
//    exatamente o que se escreve.
//
// Para medir:
//
//   flutter build web --release                     # com tree-shaking (padrão)
//   flutter build web --release --no-tree-shake-icons
//   du -k build/web/assets/packages/flocks_phosphor/assets/fonts/*.ttf
//
// Vale medir também com `weight: PhosphorWeight.duotone` no provider abaixo: é
// o peso que já embarcou a fonte SEM nenhum glifo do contrato, porque o
// tree-shaker não enxergava `IconData` aninhado. Hoje o duotone sai com 106
// glifos (53 desenhos × 2 camadas); se voltar a 4, a regressão é essa.
import 'package:flocks/flocks.dart';
import 'package:flocks_phosphor/flocks_phosphor.dart';
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

/// Ícones de fora do contrato, escritos direto da classe do peso.
///
/// São os 1.457 que o provider não resolve por slug — e é assim que se chega
/// neles sem arrastar a fonte inteira.
const List<IconData> kDirectIcons = <IconData>[
  FlocksPhosphorRegular.airplaneTilt,
  FlocksPhosphorRegular.anchor,
  FlocksPhosphorRegular.barbell,
  FlocksPhosphorRegular.campfire,
  FlocksPhosphorRegular.storefront,
];

/// Os mesmos desenhos em `bold` — outra família, outra fonte.
const List<IconData> kBoldIcons = <IconData>[
  FlocksPhosphorBold.compass,
  FlocksPhosphorBold.lighthouse,
];

/// E em `duotone`, que são dois glifos por ícone.
const List<PhosphorDuotoneIconData> kDuotoneIcons = <PhosphorDuotoneIconData>[
  FlocksPhosphorDuotone.acorn,
  FlocksPhosphorDuotone.wifiNone, // camada única — o caso de borda
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
    iconProvider: const PhosphorIconProvider(),
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
                  PhosphorIcon(icon, color: theme.colorTheme.onSurface),
                for (final IconData icon in kBoldIcons)
                  PhosphorIcon(icon, color: theme.colorTheme.onSurface),
                for (final PhosphorDuotoneIconData icon in kDuotoneIcons)
                  PhosphorDuotoneIcon(icon, color: theme.colorTheme.onSurface),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
