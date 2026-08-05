import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Rampa sintética: tons ~98, ~92, ~87, ~70, ~50 (do claro ao escuro).
const ColorSwatch<int> _ramp = ColorSwatch<int>(0xFFE4EBEC, <int, Color>{
  50: Color(0xFFF9FBFB),
  100: Color(0xFFF3F6F6),
  200: Color(0xFFE4EBEC),
  300: Color(0xFFD3DDDE),
  400: Color(0xFF9AAEB1),
  500: Color(0xFF697E82),
});

const Color _pagina = Color(0xFFD3DDDE); // tom 87.4
const Color _cartao = Color(0xFFF9FBFB); // tom 98.5
const Color _texto = Color(0xFF0F2529);

void main() {
  group('mostSeparatedStop', () {
    test('escolhe o mais SUAVE que serve, não o mais separado', () {
      final c = mostSeparatedStop(
        _ramp,
        surfaces: const [_pagina, _cartao],
        content: _texto,
      );

      // s400 separaria muito mais, mas seria um cinza médio. O contrato é
      // "discreto e ainda visível".
      expect(c, _ramp[200]);
    });

    test('descarta stops que colidem com qualquer uma das superfícies', () {
      final c = mostSeparatedStop(
        _ramp,
        surfaces: const [_pagina, _cartao],
        content: _texto,
      );

      // s50 é o cartão e s300 é a página: escolher qualquer um deles some.
      expect(c, isNot(_ramp[50]));
      expect(c, isNot(_ramp[300]));
    });

    test('legibilidade do conteúdo vem antes da separação', () {
      // Texto claro: os stops claros separam bem das superfícies, mas engolem
      // o texto. A busca tem de descer a rampa.
      final c = mostSeparatedStop(
        _ramp,
        surfaces: const [_pagina, _cartao],
        content: const Color(0xFFFFFFFF),
      );

      expect(contrastRatio(const Color(0xFFFFFFFF), c), greaterThan(4.0));
    });

    test('piso de separação mais alto empurra para um stop mais forte', () {
      final suave = mostSeparatedStop(
        _ramp,
        surfaces: const [_pagina, _cartao],
        content: _texto,
      );
      final forte = mostSeparatedStop(
        _ramp,
        surfaces: const [_pagina, _cartao],
        content: _texto,
        minSeparation: 15,
      );

      expect(forte, isNot(suave));
      expect(toneDelta(forte, _pagina), greaterThan(toneDelta(suave, _pagina)));
    });
  });
}
