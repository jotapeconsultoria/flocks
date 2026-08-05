import 'package:flutter/painting.dart';

/// Converte uma string hex (`'#RRGGBB'`, `'#RRGGBBAA'` ou sem `'#'`) em [Color].
///
/// Retorna `null` se a string for nula ou inválida. Usado para renderizar a cor
/// canônica de uma faixa (`band.color`) vinda da API.
Color? parseHexColor(String? hex) {
  if (hex == null) return null;
  var value = hex.trim().replaceFirst('#', '');
  if (value.length == 6) value = 'FF$value';
  if (value.length != 8) return null;
  final parsed = int.tryParse(value, radix: 16);
  return parsed == null ? null : Color(parsed);
}

/// Igual a [parseHexColor], mas retorna [fallback] quando a string é inválida.
Color parseHexColorOr(String? hex, Color fallback) =>
    parseHexColor(hex) ?? fallback;

/// Converte um [Color] em string hex `'#RRGGBB'` (maiúsculo, sem alpha).
///
/// Inverso de [parseHexColor]. Usado pelo color picker para emitir a cor
/// escolhida no formato canônico esperado pela API.
String colorToHex(Color color) {
  final rgb = color.toARGB32() & 0xFFFFFF;
  return '#${rgb.toRadixString(16).toUpperCase().padLeft(6, '0')}';
}
