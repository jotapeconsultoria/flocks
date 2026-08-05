import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../theme/theme.dart';

/// O que se desenha quando um ícone não carrega: um disco do tamanho pedido.
///
/// Ocupa exatamente o espaço do ícone — um ícone que falha não pode reflowar a
/// tela em volta — e é visível de propósito. Um asset ausente é bug de quem
/// integra, e um espaço em branco esconde isso até a revisão de layout.
///
/// A cor pedida vence a de perigo: num ícone tingido pela marca, o disco segue
/// a marca em vez de espalhar vermelho pela interface.
///
/// Estava triplicado (no `AppIcon` e nos dois loaders); virou um lugar só ao
/// mesmo tempo em que o carregamento saiu do widget e foi para o provider.
@internal
Widget iconErrorPlaceholder(AppThemeData theme, double size, Color? color) =>
    SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          color: color ?? theme.colorTheme.danger,
        ),
      ),
    );
