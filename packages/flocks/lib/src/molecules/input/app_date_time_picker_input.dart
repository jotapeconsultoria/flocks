import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../date_picker/app_date_picker.dart';
import '../pickers/pickers.dart';
import '../time_picker/app_time_picker.dart';
import 'app_input.dart';
import 'input_formatters.dart';

/// Campo de texto com date picker e time picker integrados.
///
/// Permite digitar data e hora no formato DD/MM/YYYY HH:mm (máscara automática
/// via [AppDateTimeMaskFormatter]) ou selecionar pelo calendário e rodas de
/// horário no overlay ([AppCard] elevado).
///
/// Exemplo:
/// ```dart
/// AppDateTimePickerInput(
///   label: 'Data e hora',
///   hintText: 'DD/MM/AAAA HH:mm',
///   onDateTimeSelected: (dt) => print(dt),
/// )
/// ```
final class AppDateTimePickerInput extends StatefulWidget {
  /// Cria um [AppDateTimePickerInput].
  const AppDateTimePickerInput({
    required this.onDateTimeSelected,
    this.enabled = true,
    this.errorText,
    this.firstDate,
    this.hasError = false,
    this.helperText,
    this.hintText,
    this.info,
    this.initialDateTime,
    this.label,
    this.lastDate,
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

  /// Data e hora inicial pré-preenchida.
  final DateTime? initialDateTime;

  /// Label exibida acima do campo.
  final String? label;

  /// Data máxima selecionável.
  final DateTime? lastDate;

  /// Callback quando uma data/hora válida é selecionada.
  final ValueChanged<DateTime> onDateTimeSelected;

  /// Eixo global [AppStyle] do campo. `null` segue o global do tema.
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste campo (vence o global).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio — vence [radiusMode] e o global.
  final BorderRadius? radius;

  /// Tamanho do campo (altura fixa + métricas). Default [AppFieldSize.m].
  final AppFieldSize size;

  @override
  State<AppDateTimePickerInput> createState() => _AppDateTimePickerInputState();
}

class _AppDateTimePickerInputState extends State<AppDateTimePickerInput> {
  late TextEditingController _controller;
  int _hour = 0;
  int _minute = 0;
  DateTime? _selectedDate;

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
        inputFormatters: const [AppDateTimeMaskFormatter()],
        keyboardType: TextInputType.number,
        label: widget.label,
        onChanged: _onTextChanged,
        onClear: widget.enabled
            ? () {
                setState(() {
                  _selectedDate = null;
                  _hour = 0;
                  _minute = 0;
                });
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
      panel: (context, handle) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppDatePicker(
            firstDate: widget.firstDate,
            initialDate: _selectedDate ?? DateTime.now(),
            lastDate: widget.lastDate,
            // Rebuilda o painel p/ o calendário refletir a data escolhida.
            onDateSelected: (date) {
              _onDateSelected(date);
              handle.rebuild();
            },
          ),
          const SizedBox(height: AppSpacings.s4),
          AppTimePicker(
            initialHour: _hour,
            initialMinute: _minute,
            onTimeSelected: _onTimeSelected,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDateTime() {
    if (_selectedDate == null) return '';
    final date = _selectedDate!;
    final d = date.day.toString().padLeft(2, '0');
    final mo = date.month.toString().padLeft(2, '0');
    final y = date.year.toString().padLeft(4, '0');
    final h = _hour.toString().padLeft(2, '0');
    final mi = _minute.toString().padLeft(2, '0');
    return '$d/$mo/$y $h:$mi';
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDateTime;
    _hour = widget.initialDateTime?.hour ?? 0;
    _minute = widget.initialDateTime?.minute ?? 0;

    _controller = TextEditingController(
      text: widget.initialDateTime != null ? _formatDateTime() : '',
    );
  }

  void _notifyChange() {
    if (_selectedDate == null) return;
    final dt = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _hour,
      _minute,
    );
    widget.onDateTimeSelected(dt);
  }

  void _onDateSelected(DateTime date) {
    _selectedDate = date;
    _controller.text = _formatDateTime();
    _notifyChange();
  }

  void _onTextChanged(String text) {
    final dt = _tryParseDateTime(text);
    if (dt == null) return;

    if (widget.firstDate != null && dt.isBefore(widget.firstDate!)) return;
    if (widget.lastDate != null && dt.isAfter(widget.lastDate!)) return;

    _selectedDate = DateTime(dt.year, dt.month, dt.day);
    _hour = dt.hour;
    _minute = dt.minute;
    widget.onDateTimeSelected(dt);
  }

  void _onTimeSelected(({int hour, int minute, int second}) time) {
    _hour = time.hour;
    _minute = time.minute;
    _controller.text = _formatDateTime();
    _notifyChange();
  }

  DateTime? _tryParseDateTime(String text) {
    // Formato esperado: DD/MM/YYYY HH:mm (16 caracteres)
    if (text.length != 16) return null;

    final parts = text.split(' ');
    if (parts.length != 2) return null;

    final date = _tryParseDate(parts[0]);
    if (date == null) return null;

    final time = _tryParseTime(parts[1]);
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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

  ({int hour, int minute})? _tryParseTime(String text) {
    if (text.length != 5) return null;
    final parts = text.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23) return null;
    if (minute < 0 || minute > 59) return null;
    return (hour: hour, minute: minute);
  }
}
