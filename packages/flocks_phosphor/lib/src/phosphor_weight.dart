/// Os seis pesos do Phosphor.
///
/// É uma dimensão de marca que o Flocks não tinha: o mesmo conjunto de ícones
/// lido mais leve ou mais firme muda a percepção da interface tanto quanto a
/// família tipográfica. Trocar o peso é trocar o provider — o eixo de ícone já
/// existe, isto só o alimenta.
///
/// Cada peso é uma **família de fonte própria**, não um `fontWeight` de uma
/// família só: os desenhos são independentes, e o `fill` não é um `regular`
/// mais gordo. Por isso são seis TTFs e seis famílias declaradas no `pubspec`.
///
/// A ordem aqui é a da escala (mais leve → mais firme), e não alfabética: é uma
/// rampa, e lê-la fora de ordem esconde o que ela é.
///
/// Este arquivo é **Dart puro, sem importar Flutter**, de propósito — quem o lê
/// não é só a biblioteca, é também `tool/generate_icons.dart`, que roda na VM do
/// Dart. É isto que mantém a lista de pesos num lugar só.
enum PhosphorWeight {
  /// O mais leve. Some em tamanho pequeno; use de 24px para cima.
  thin(fileName: 'Phosphor-Thin.ttf', fontFamily: 'Phosphor-Thin'),

  /// Leve, ainda legível em 20px.
  light(fileName: 'Phosphor-Light.ttf', fontFamily: 'Phosphor-Light'),

  /// O padrão do Phosphor, e o que o design system usa.
  regular(fileName: 'Phosphor.ttf', fontFamily: 'Phosphor'),

  /// Firme. Boa escolha quando o ícone concorre com texto em peso 500+.
  bold(fileName: 'Phosphor-Bold.ttf', fontFamily: 'Phosphor-Bold'),

  /// Sólido, sem contorno. Marca estado ativo sem precisar de cor.
  fill(fileName: 'Phosphor-Fill.ttf', fontFamily: 'Phosphor-Fill'),

  /// Dois tons no mesmo desenho, com a segunda camada em opacidade menor.
  ///
  /// **É o único peso que não é 1:1 com um glifo.** Ver
  /// `PhosphorDuotoneIconData`: são dois codepoints sobrepostos, e tratá-lo
  /// como os outros cinco desenha metade do ícone.
  duotone(fileName: 'Phosphor-Duotone.ttf', fontFamily: 'Phosphor-Duotone');

  const PhosphorWeight({required this.fileName, required this.fontFamily});

  /// O arquivo em `assets/fonts/`, com o nome que o Phosphor publica.
  final String fileName;

  /// A família declarada no `pubspec` — o que vai no `IconData.fontFamily`.
  final String fontFamily;
}
