/// Phosphor Icons como `AppIconProvider` do Flocks.
///
/// Os 1.512 ícones do [Phosphor](https://phosphoricons.com) nos 6 pesos, em
/// **fonte** — seis TTFs de ~500 KB, de uma versão fixada do upstream, com os
/// codepoints que o próprio Phosphor publica.
///
/// Ser fonte é a questão inteira do pacote. O Flutter **não** faz tree-shaking
/// de asset: enquanto isto aqui eram 9.072 SVGs, todo adotante levava 35 MB
/// para o bundle usando vinte ícones. Fonte ele sabe podar — o
/// `--tree-shake-icons` remonta cada TTF só com os glifos que o app cita. É a
/// mesma razão pela qual `flocks_material` nunca teve o problema: ícone do
/// Material é fonte, e vem dentro do Flutter.
///
/// Duas portas de entrada, e a diferença entre elas é o que preserva o ganho:
///
/// - o [PhosphorIconProvider], que serve os 55 `AppIconToken` — o contrato — e
///   é o que faz o design system inteiro desenhar;
/// - as classes por peso ([FlocksPhosphorRegular], [FlocksPhosphorBold], …),
///   para os outros 1.457, uma constante de cada vez.
///
/// É também a implementação de referência do eixo de ícone — um
/// `flocks_material` ou um `flocks_lucide` tem esta mesma forma.
library;

export 'src/flocks_to_phosphor.dart';
export 'src/generated/flocks_phosphor_bold.dart';
export 'src/generated/flocks_phosphor_duotone.dart';
export 'src/generated/flocks_phosphor_fill.dart';
export 'src/generated/flocks_phosphor_light.dart';
export 'src/generated/flocks_phosphor_regular.dart';
export 'src/generated/flocks_phosphor_thin.dart';
export 'src/generated/phosphor_contract.dart';
export 'src/phosphor_duotone_icon_data.dart';
export 'src/phosphor_icon.dart';
export 'src/phosphor_icon_provider.dart';
export 'src/phosphor_weight.dart';
