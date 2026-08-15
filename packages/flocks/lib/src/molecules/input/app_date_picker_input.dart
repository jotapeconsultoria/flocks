import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../date_picker/app_date_picker.dart';
import '../pickers/pickers.dart';
import 'app_input.dart';
import 'input_formatters.dart';

/// Campo de texto com date picker integrado.
///
/// Permite digitar uma data no formato DD/MM/YYYY (máscara automática via
/// [AppDateMaskFormatter]) ou selecionar uma data pelo date picker (overlay ao
/// clicar no ícone). O overlay é um [AppCard] elevado, como o painel do
/// [AppDropdown].
///
/// Exemplo:
/// ```dart
/// AppDatePickerInput(
///   label: 'Data',
///   hintText: 'DD/MM/AAAA',
///   onDateSelected: (date) => print(date),
/// )
/// ```
final class AppDatePickerInput extends StatefulWidget {
  /// Cria um [AppDatePickerInput].
  const AppDatePickerInput({
    required this.onDateSelected,
    this.enabled = true,
    this.errorText,
    this.firstDate,
    this.hasError = false,
    this.helperText,
    this.hintText,
    this.info,
    this.initialDate,
    this.label,
    this.lastDate,
    this.maxLength,
    this.onCleared,
    this.style,
    this.radiusMode,
    this.radius,
    this.size = AppFieldSize.m,
    super.key,
  });

  /// Se o campo está habilitado.
  final bool enabled;

  /// Texto de erro exibido abaixo do campo.
  final String? errorText;

  /// Data mínima selecionável.
  final DateTime? firstDate;

  /// Se o campo está em estado de erro.
  final bool hasError;

  /// Texto auxiliar exibido abaixo do campo.
  final String? helperText;

  /// Texto de placeholder quando nada está selecionado.
  final String? hintText;

  /// Conteúdo livre de um popover de informação ao lado do label.
  final Widget? info;

  /// Data inicial pré-preenchida.
  final DateTime? initialDate;

  /// Label exibida acima do campo.
  final String? label;

  /// Data máxima selecionável.
  final DateTime? lastDate;

  /// Limite máximo de caracteres digitados no campo.
  final int? maxLength;

  /// Disparado quando o usuário limpa o campo pelo ✕ — o valor selecionado
  /// volta a ser nenhum, e [onDateSelected] (que só anuncia valores válidos)
  /// não avisaria sozinho.
  ///
  /// O ✕ é o do [AppInput]: só existe com o campo **em erro**
  /// ([hasError]/[errorText]), habilitado e preenchido. Apagar o texto à mão
  /// (backspace) não notifica — texto parcial não é um valor.
  final VoidCallback? onCleared;

  /// Callback quando uma data válida é selecionada (digitada ou via picker).
  final ValueChanged<DateTime> onDateSelected;

  /// Eixo global [AppStyle] do campo. `null` segue o global do tema.
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste campo (vence o global).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio — vence [radiusMode] e o global.
  final BorderRadius? radius;

  /// Tamanho do campo (altura fixa + métricas). Default [AppFieldSize.m].
  final AppFieldSize size;

  @override
  State<AppDatePickerInput> createState() => _AppDatePickerInputState();
}

class _AppDatePickerInputState extends State<AppDatePickerInput> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  static String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString().padLeft(4, '0');
    return '$d/$m/$y';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppPickerAnchor(
      width: const AppPickerWidth.matchTrigger(min: 300),
      trigger: (context, handle) => AppInput(
        controller: _controller,
        enabled: widget.enabled,
        errorText: widget.errorText,
        hasError: widget.hasError,
        helperText: widget.helperText,
        hintText: widget.hintText,
        info: widget.info,
        inputFormatters: const [AppDateMaskFormatter()],
        keyboardType: TextInputType.number,
        label: widget.label,
        maxLength: widget.maxLength,
        onChanged: _onTextChanged,
        onClear: widget.enabled
            ? () {
                setState(() => _selectedDate = null);
                widget.onCleared?.call();
                handle.open();
              }
            : null,
        onSuffixIconTap: widget.enabled ? handle.toggle : null,
        radius: widget.radius,
        radiusMode: widget.radiusMode,
        size: widget.size,
        style: widget.style,
        suffixIcon: AppIconToken.calendar,
        suffixIconColor: handle.isOpen
            ? readableStopOn(
                theme.colorTheme.secondary,
                theme.colorTheme.surface,
              )
            : null,
      ),
      panel: (context, handle) => AppDatePicker(
        firstDate: widget.firstDate,
        initialDate: _selectedDate ?? DateTime.now(),
        lastDate: widget.lastDate,
        onDateSelected: (date) {
          _selectDate(date);
          handle.close();
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(
      text: widget.initialDate != null ? _formatDate(widget.initialDate!) : '',
    );
  }

  void _onTextChanged(String text) {
    final date = _tryParseDate(text);
    if (date == null) return;

    if (widget.firstDate != null && date.isBefore(widget.firstDate!)) return;
    if (widget.lastDate != null && date.isAfter(widget.lastDate!)) return;

    _selectedDate = date;
    widget.onDateSelected(date);
  }

  void _selectDate(DateTime date) {
    _selectedDate = date;
    _controller.text = _formatDate(date);
    widget.onDateSelected(date);
  }

  DateTime? _tryParseDate(String text) {
    if (text.length != 10) return null;
    final parts = text.split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    if (month < 1 || month > 12) return null;
    if (day < 1 || day > 31) return null;
    if (year < 1900) return null;
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }
}
