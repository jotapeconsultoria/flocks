import 'package:flutter/services.dart';

/// Máscara de data no formato `DD/MM/YYYY` (só dígitos; barras inseridas
/// automaticamente). Usada pelo [AppDatePickerInput].
final class AppDateMaskFormatter extends TextInputFormatter {
  /// Cria um [AppDateMaskFormatter].
  const AppDateMaskFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 8) return oldValue;

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(text[i]);
    }

    return TextEditingValue(
      selection: TextSelection.collapsed(offset: buffer.length),
      text: buffer.toString(),
    );
  }
}

/// Máscara de horário `HH:mm` (ou `HH:mm:ss` quando [showSeconds]). Usada pelo
/// [AppTimePickerInput].
final class AppTimeMaskFormatter extends TextInputFormatter {
  /// Cria um [AppTimeMaskFormatter].
  const AppTimeMaskFormatter({this.showSeconds = false});

  /// Se inclui a coluna de segundos (`HH:mm:ss`).
  final bool showSeconds;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    final maxDigits = showSeconds ? 6 : 4;
    if (text.length > maxDigits) return oldValue;

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i == 2 || (showSeconds && i == 4)) buffer.write(':');
      buffer.write(text[i]);
    }

    return TextEditingValue(
      selection: TextSelection.collapsed(offset: buffer.length),
      text: buffer.toString(),
    );
  }
}

/// Máscara de data e hora `DD/MM/YYYY HH:mm`. Usada pelo
/// [AppDateTimePickerInput].
final class AppDateTimeMaskFormatter extends TextInputFormatter {
  /// Cria um [AppDateTimeMaskFormatter].
  const AppDateTimeMaskFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 12) return oldValue;

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      if (i == 8) buffer.write(' ');
      if (i == 10) buffer.write(':');
      buffer.write(text[i]);
    }

    return TextEditingValue(
      selection: TextSelection.collapsed(offset: buffer.length),
      text: buffer.toString(),
    );
  }
}
