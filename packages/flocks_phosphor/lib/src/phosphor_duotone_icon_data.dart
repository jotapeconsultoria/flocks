import 'package:flutter/widgets.dart';

/// Um ícone `duotone`: dois glifos sobrepostos — quase sempre.
///
/// O `duotone` é o único peso do Phosphor que não é 1:1 com um codepoint. O
/// desenho é montado empilhando dois glifos da fonte:
///
/// - [ground] é a mancha cheia, por baixo, pintada a
///   [kPhosphorDuotoneGroundOpacity];
/// - [figure] é o contorno, por cima e opaco.
///
/// Este tipo existe em vez de mais um `IconData` porque, com um campo só, o
/// compilador aceitaria `FlocksPhosphorDuotone.acorn` desenhando metade do
/// ícone — uma mancha sem contorno — e o defeito só apareceria na tela. Aqui,
/// quem tem um duotone tem o par inteiro ou não compila.
///
/// **O segundo glifo não é `codepoint + 1`.** É o que mais parece, e 1.462 dos
/// 1.512 ícones seguem essa regra — mas 48 têm distâncias de 2 a 33, então a
/// aritmética desenharia o contorno de outro ícone por cima da mancha certa. O
/// par vem lido do CSS que o Phosphor publica ao lado da fonte, nunca
/// calculado. Ver `tool/phosphor_catalog.dart`.
///
/// **Os `IconData` precisam ser `const`.** O `--tree-shake-icons` monta a fonte
/// final a partir dos `IconData` constantes que encontra no código; um
/// codepoint calculado em execução não seria visto, sairia da fonte, e o
/// contorno sumiria só no build de release. Pior: uma instância não-constante
/// de `IconData` em qualquer lugar do pacote faz o build de release **falhar**
/// para todo mundo que dependa dele. Ver
/// `test/architecture/const_icon_data_test.dart`.
@immutable
final class PhosphorDuotoneIconData {
  /// Cria o par de glifos de um ícone duotone.
  ///
  /// [ground] ausente é o caso de camada única — ver o campo.
  const PhosphorDuotoneIconData({required this.figure, this.ground});

  /// O contorno. Desenhado por cima, opaco.
  ///
  /// Num ícone de camada única é o desenho inteiro.
  final IconData figure;

  /// A mancha cheia, por baixo, a [kPhosphorDuotoneGroundOpacity].
  ///
  /// `null` em `cell-signal-none` e `wifi-none`, os dois ícones que o Phosphor
  /// publica com uma camada só: o desenho é um traço, sem área para preencher,
  /// e o CSS do upstream não emite `::after` para eles. Tratá-los como os
  /// outros 1.510 desenharia o ícone a 20% de opacidade, apagado.
  final IconData? ground;

  @override
  bool operator ==(Object other) =>
      other is PhosphorDuotoneIconData &&
      other.figure == figure &&
      other.ground == ground;

  @override
  int get hashCode => Object.hash(figure, ground);

  @override
  String toString() => ground == null
      ? 'PhosphorDuotoneIconData($figure)'
      : 'PhosphorDuotoneIconData($ground + $figure)';
}

/// A opacidade da camada de fundo de um ícone duotone.
///
/// 0,2 é o valor que o próprio Phosphor publica — está no `opacity` do SVG de
/// cada duotone e na regra `.ph-duotone::before` do CSS. Não é escolha nossa;
/// mudá-lo desalinha o pacote do desenho original.
const double kPhosphorDuotoneGroundOpacity = 0.2;
