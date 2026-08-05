import 'package:flutter/services.dart';

/// Formatters compartilhados pelos campos de hex do color picker
/// ([AppColorPickerInput] e a edição inline do [AppColorPickerPanel]).
///
/// Aceita apenas dígitos hex, limita a 6 caracteres e mantém em maiúsculas.
List<TextInputFormatter> hexFieldFormatters() => [
  FilteringTextInputFormatter.allow(RegExp('[0-9a-fA-F]')),
  LengthLimitingTextInputFormatter(6),
  const UpperCaseTextFormatter(),
];

/// Formatter que mantém o texto em maiúsculas (hex canônico).
class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
