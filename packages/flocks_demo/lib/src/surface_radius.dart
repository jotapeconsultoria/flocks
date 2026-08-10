import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

/// O raio das superfícies GRANDES da demo — cartões de gráfico, tabela, lista.
///
/// ## Por que não deixar o eixo global resolver sozinho
///
/// `AppRadiusMode.circular` significa, literalmente, "metade do lado menor".
/// Num chip ou num botão isso é a pílula que se espera. Num cartão de gráfico de
/// 400 px de altura, é uma elipse de 200 px de raio que come o próprio título —
/// a demo mostrava "urring revenue" no lugar de "Recurring revenue".
///
/// O pacote já tem a escada certa para isto e a documenta: `surfaceCornerRadius`
/// pousa em `kSurfaceCircularRadius` (48) em vez de virar oval, e é o que o
/// `AppShell` aceita em `contentRadius`. O `AppCard`, porém, resolve pela escada
/// geral — então quem monta a tela é que precisa dizer que aquele cartão é uma
/// SUPERFÍCIE, e não um controle.
///
/// ## Isto não é furar o eixo
///
/// O valor continua vindo do tema, e trocar a forma continua mudando estes
/// cartões: 0 em `reto`, 24 em `redondo`/`padrao`, 48 em `circular`. O que ele
/// não faz mais é escalar com a altura da caixa. Nenhuma cor, sombra ou borda é
/// passada à mão em lugar nenhum da demo — este é o único parâmetro de forma que
/// a tela informa, e ele é derivado.
BorderRadius demoSurfaceRadius(BuildContext context) => BorderRadius.circular(
  AppTheme.of(context).radiusTheme.surfaceCornerRadius(),
);
