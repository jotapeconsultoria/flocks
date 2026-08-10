// Exemplo do `flocks` — a tese do pacote numa tela só.
//
// Não é uma vitrine de componentes: para isso existe o Widgetbook, em
// widgetbook.flocks.live. O que esta tela demonstra é o que a vitrine não
// consegue dizer em uma imagem — que **uma** configuração de marca e **dois**
// valores de tema restilizam tudo que está na tela, sem que nenhum componente
// receba cor, raio ou sombra por parâmetro.
//
// Repare no que NÃO aparece aqui: nenhum `Color` literal fora da semente,
// nenhum `BorderRadius`, nenhum `BoxShadow`. Os componentes leem o tema
// sozinhos — trocar `_style` de `filled` para `outlined` reescreve o botão e o
// card ao mesmo tempo, porque o eixo é global e não uma propriedade de cada um.
//
// Para rodar:
//
//   flutter run            # ou -d chrome
import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const ExampleApp());

/// A semente da marca. É o único valor de cor deste arquivo.
///
/// `swatchFromSeed` deriva dela a escala inteira (os stops de 50 a 950), e é a
/// mesma função que o pacote usa para as marcas reais — não uma aproximação de
/// exemplo. Troque este hex e a tela toda troca de marca.
const Color kSeed = Color(0xFF4F46E5);

/// O app de exemplo.
final class ExampleApp extends StatefulWidget {
  /// Cria o app.
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  bool _dark = false;
  AppStyle _style = AppStyle.filled;
  AppRadiusMode _radius = AppRadiusMode.padrao;

  /// A marca inteira, montada da semente e dos dois eixos que a tela alterna.
  ///
  /// `clientSlug` é só identificação — nomeia a configuração nos goldens e nos
  /// relatórios de contraste do pacote.
  AppBrandConfig get _brand => AppBrandConfig(
    clientSlug: 'example',
    primaryColor: swatchFromSeed(kSeed),
    styleTheme: AppStyleTheme(style: _style),
    radiusTheme: AppRadiusTheme(mode: _radius),
  );

  void _cycleStyle() => setState(() {
    const List<AppStyle> order = AppStyle.values;
    _style = order[(order.indexOf(_style) + 1) % order.length];
  });

  void _cycleRadius() => setState(() {
    const List<AppRadiusMode> order = AppRadiusMode.values;
    _radius = order[(order.indexOf(_radius) + 1) % order.length];
  });

  @override
  Widget build(BuildContext context) {
    // Uma marca + um booleano de brilho = o tema inteiro. Não há segunda
    // fonte: claro e escuro saem da MESMA semente, derivados, e não de duas
    // paletas escritas à mão que precisariam ser mantidas em sincronia.
    final AppThemeData theme = AppThemeData.forBrand(_brand, dark: _dark);

    return AppTheme(
      data: theme,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: theme.colorTheme.surface,
          child: Center(
            child: SizedBox(
              width: 360,
              child: AppCard(
                headerTitle: 'Flocks',
                headerLeading: const AppIcon(AppIconToken.settings),
                showDividers: true,
                footer: Wrap(
                  spacing: AppSpacings.s8,
                  runSpacing: AppSpacings.s8,
                  children: <Widget>[
                    AppButton(
                      icon: AppIconToken.settings,
                      label: 'Estilo: ${_style.name}',
                      onPressed: _cycleStyle,
                    ),
                    AppButton(
                      style: AppStyle.outlined,
                      label: 'Forma: ${_radius.name}',
                      onPressed: _cycleRadius,
                    ),
                    AppButton(
                      style: AppStyle.outlined,
                      color: AppButtonColor.neutral,
                      label: _dark ? 'Claro' : 'Escuro',
                      onPressed: () => setState(() => _dark = !_dark),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacings.s12,
                  ),
                  child: Text(
                    'Uma semente de cor, três eixos globais. Os botões e este '
                    'card leem o tema sozinhos — nenhum deles recebe cor, raio '
                    'ou sombra por parâmetro.',
                    style: theme.textTheme.bodyMedium.copyWith(
                      color: theme.colorTheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
