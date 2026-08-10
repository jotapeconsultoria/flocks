import 'package:flutter/widgets.dart';

/// Desenha um glifo do Lucide a partir de um [IconData].
///
/// Existe porque o `Icon` do Flutter é do Material, e o Flocks não importa
/// Material — a mesma regra que obriga `flocks_material` a ser um pacote
/// separado vale aqui.
///
/// É por aqui que se chega aos ícones **fora** do contrato de `AppIconToken`:
///
/// ```dart
/// const LucideIcon(FlocksLucide.storefront, size: 24)
/// ```
///
/// Escrever a constante direto, e não um seletor em tempo de execução, é o que
/// preserva o tree-shaking: o `--tree-shake-icons` embute na fonte final só os
/// codepoints que encontra escritos como constante. Uma API do tipo
/// `lucideIcon('storefront')` obrigaria a carregar o mapa dos 2.025 nomes e
/// levaria a fonte inteira junto.
final class LucideIcon extends StatelessWidget {
  /// Desenha [icon] com [size] de lado.
  const LucideIcon(
    this.icon, {
    this.color,
    this.semanticLabel,
    this.size = 24,
    super.key,
  });

  /// A cor do glifo. `null` herda a do [DefaultTextStyle] em volta.
  final Color? color;

  /// O glifo — um campo de `FlocksLucide`.
  final IconData icon;

  /// Rótulo de acessibilidade. `null` (padrão) marca o ícone como decorativo.
  final String? semanticLabel;

  /// O lado do ícone em pixels lógicos.
  final double size;

  @override
  Widget build(BuildContext context) => _semantics(
    semanticLabel,
    SizedBox.square(
      dimension: size,
      child: Center(
        child: lucideGlyph(context, color: color, icon: icon, size: size),
      ),
    ),
  );
}

/// A cor de texto em vigor, que é o que um ícone sem cor explícita deve herdar.
Color _inheritedColor(BuildContext context) =>
    DefaultTextStyle.of(context).style.color ?? const Color(0xFF000000);

/// Marca [child] como decorativo, ou o rotula quando [label] existe.
Widget _semantics(String? label, Widget child) => label == null
    ? ExcludeSemantics(child: child)
    : Semantics(image: true, label: label, child: child);

/// O glifo cru de [icon], sem caixa, semântica nem centralização.
///
/// Compartilhado pelo [LucideIcon] e pelo `LucideIconProvider`.
///
/// `inherit: false` é o detalhe que decide se o ícone assenta no lugar. Com a
/// herança ligada — o default de `Text` —, um `letterSpacing` ou um `height`
/// ambiente do [DefaultTextStyle] entra no estilo do glifo e o desloca dentro
/// da caixa. `height: 1` mais `leadingDistribution: even` centralizam o corpo
/// da fonte no quadrado, e `TextOverflow.visible` garante que um glifo que
/// transborde apareça em vez de ser cortado. É o que o `Icon` do Material faz,
/// pelas mesmas razões.
Widget lucideGlyph(
  BuildContext context, {
  required IconData icon,
  required double size,
  Color? color,
}) => RichText(
  overflow: TextOverflow.visible,
  text: TextSpan(
    text: String.fromCharCode(icon.codePoint),
    style: TextStyle(
      color: color ?? _inheritedColor(context),
      fontFamily: icon.fontFamily,
      fontFamilyFallback: icon.fontFamilyFallback,
      fontSize: size,
      height: 1,
      inherit: false,
      leadingDistribution: TextLeadingDistribution.even,
      package: icon.fontPackage,
    ),
  ),
  textDirection: TextDirection.ltr,
);
