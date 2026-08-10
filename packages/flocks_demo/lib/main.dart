// A demo de white-label do Flocks — o que roda em flocks.live/demo/.
//
// A tese que ela existe para provar cabe numa frase: UMA semente de cor e
// quatro eixos vestem um dashboard e um CRUD inteiros, e o visitante leva o
// código que reproduz o que viu.
//
// Repare no que NÃO há neste arquivo, nem em nenhum outro do pacote: nenhum
// `MaterialApp`, nenhum `Color` literal fora do que o visitante escolheu,
// nenhum `BoxShadow`. E nenhum cliente HTTP — o código da demo não faz uma
// única requisição, o que é ao mesmo tempo a tese do pacote ("funciona
// offline") e o que torna absoluto o gate que protege o logo do visitante.
//
// "O código da demo", e não "a página": o runtime do Flutter Web ainda busca a
// fonte Roboto do Google na inicialização do CanvasKit. Não toca o logo, e está
// documentado em TODO.md em vez de escondido atrás de uma frase mais bonita.
//
// Para rodar:
//
//   flutter run -d chrome
import 'package:flutter/widgets.dart';

import 'src/demo_app.dart';

void main() => runApp(const DemoApp());
