import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../pickers/pickers.dart';
import '../time_picker/app_time_picker.dart';
import 'app_input.dart';
import 'input_formatters.dart';

/// Campo de texto com time picker integrado.
///
/// Permite digitar um horário no formato HH:mm (máscara automática via
/// [AppTimeMaskFormatter]) ou selecionar pelo time picker (overlay ao clicar no
/// ícone). O overlay é um [AppCard] elevado, como o painel do [AppDropdown].
///
/// Exemplo:
/// ```dart
/// AppTimePickerInput(
///   label: 'Horário',
///   hintText: 'HH:mm',
///   onTimeSelected: (time) => print('${time.hour}:${time.minute}'),
/// )
/// ```
final class AppTimePickerInput extends StatefulWidget {
  /// Cria um [AppTimePickerInput].
  const AppTimePickerInput({
    required this.onTimeSelected,
    this.enabled = true,
    this.errorText,
    this.hasError = false,
    this.helperText,
    this.hintText,
    this.info,
    this.initialHour,
    this.initialMinute,
    this.initialSecond,
    this.label,
    this.minHour = 0,
    this.minMinute = 0,
    this.minSecond = 0,
    this.showSeconds = false,
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

  /// Se o campo está em estado de erro.
  final bool hasError;

  /// Texto auxiliar exibido abaixo do campo.
  final String? helperText;

  /// Texto de placeholder quando nada está selecionado.
  final String? hintText;

  /// Conteúdo livre de um popover de informação ao lado do label.
  final Widget? info;

  /// Hora inicial (0-23).
  final int? initialHour;

  /// Minuto inicial (0-59).
  final int? initialMinute;

  /// Segundo inicial (0-59).
  final int? initialSecond;

  /// Label exibida acima do campo.
  final String? label;

  /// Hora mínima permitida (0-23).
  final int minHour;

  /// Minuto mínimo permitido (0-59). Aplica-se quando hora == minHour.
  final int minMinute;

  /// Segundo mínimo permitido (0-59).
  final int minSecond;

  /// Callback quando um horário válido é selecionado (digitado ou via picker).
  final ValueChanged<({int hour, int minute, int second})> onTimeSelected;

  /// Se deve mostrar a coluna de segundos.
  final bool showSeconds;

  /// Eixo global [AppStyle] do campo. `null` segue o global do tema.
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste campo (vence o global).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio — vence [radiusMode] e o global.
  final BorderRadius? radius;

  /// Tamanho do campo (altura fixa + métricas). Default [AppFieldSize.m].
  final AppFieldSize size;

  @override
  State<AppTimePickerInput> createState() => _AppTimePickerInputState();
}

class _AppTimePickerInputState extends State<AppTimePickerInput> {
  late TextEditingController _controller;
  int _hour = 0;
  int _minute = 0;
  int _second = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppPickerAnchor(
      width: const AppPickerWidth.matchTrigger(min: 200),
      trigger: (context, handle) => AppInput(
        controller: _controller,
        enabled: widget.enabled,
        errorText: widget.errorText,
        hasError: widget.hasError,
        helperText: widget.helperText,
        hintText: widget.hintText,
        info: widget.info,
        inputFormatters: [
          AppTimeMaskFormatter(showSeconds: widget.showSeconds),
        ],
        keyboardType: TextInputType.number,
        label: widget.label,
        onChanged: _onTextChanged,
        onClear: widget.enabled
            ? () {
                setState(() {
                  _hour = widget.minHour;
                  _minute = widget.minMinute;
                  _second = widget.minSecond;
                });
                handle.open();
              }
            : null,
        onSuffixIconTap: widget.enabled ? handle.toggle : null,
        radius: widget.radius,
        radiusMode: widget.radiusMode,
        size: widget.size,
        style: widget.style,
        suffixIcon: AppIconToken.clock,
        suffixIconColor: handle.isOpen
            ? readableStopOn(
                theme.colorTheme.secondary,
                theme.colorTheme.surface,
              )
            : null,
      ),
      // O time picker permanece aberto ao ajustar as rodas (fecha só ao clicar
      // fora).
      panel: (context, handle) => AppTimePicker(
        initialHour: _hour,
        initialMinute: _minute,
        initialSecond: _second,
        minHour: widget.minHour,
        minMinute: widget.minMinute,
        minSecond: widget.minSecond,
        onTimeSelected: _selectTime,
        showSeconds: widget.showSeconds,
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
    _hour = widget.initialHour ?? 0;
    _minute = widget.initialMinute ?? 0;
    _second = widget.initialSecond ?? 0;

    final hasInitial = widget.initialHour != null;
    _controller = TextEditingController(text: hasInitial ? _formatTime() : '');
  }

  String _formatTime() {
    final h = _hour.toString().padLeft(2, '0');
    final m = _minute.toString().padLeft(2, '0');
    if (widget.showSeconds) {
      final s = _second.toString().padLeft(2, '0');
      return '$h:$m:$s';
    }
    return '$h:$m';
  }

  void _onTextChanged(String text) {
    final parsed = _tryParseTime(text);
    if (parsed == null) return;

    _hour = parsed.hour;
    _minute = parsed.minute;
    _second = parsed.second;
    widget.onTimeSelected((hour: _hour, minute: _minute, second: _second));
  }

  void _selectTime(({int hour, int minute, int second}) time) {
    _hour = time.hour;
    _minute = time.minute;
    _second = time.second;
    _controller.text = _formatTime();
    widget.onTimeSelected(time);
  }

  ({int hour, int minute, int second})? _tryParseTime(String text) {
    final expectedLength = widget.showSeconds ? 8 : 5;
    if (text.length != expectedLength) return null;

    final parts = text.split(':');
    final expectedParts = widget.showSeconds ? 3 : 2;
    if (parts.length != expectedParts) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    final second = widget.showSeconds ? int.tryParse(parts[2]) : 0;

    if (hour == null || minute == null || second == null) return null;
    if (hour < 0 || hour > 23) return null;
    if (minute < 0 || minute > 59) return null;
    if (second < 0 || second > 59) return null;

    return (hour: hour, minute: minute, second: second);
  }
}
