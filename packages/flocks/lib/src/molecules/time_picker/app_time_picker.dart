import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Time picker com scroll finito (rodas) para seleção de hora.
///
/// Formato 24h. Suporta horas (00-23), minutos (00-59) e opcionalmente segundos.
/// Item selecionado: titleMedium secondary. Adjacentes: titleMedium neutralPrimary.s900.
/// Valores abaixo do mínimo ficam desabilitados (neutralPrimary.s200).
final class AppTimePicker extends StatefulWidget {
  const AppTimePicker({
    required this.onTimeSelected,
    this.initialHour = 0,
    this.initialMinute = 0,
    this.initialSecond = 0,
    this.minHour = 0,
    this.minMinute = 0,
    this.minSecond = 0,
    this.showSeconds = false,
    super.key,
  });

  /// Hora inicial (0-23).
  final int initialHour;

  /// Minuto inicial (0-59).
  final int initialMinute;

  /// Segundo inicial (0-59).
  final int initialSecond;

  /// Hora mínima permitida (0-23).
  final int minHour;

  /// Minuto mínimo permitido (0-59). Aplica-se quando hora == minHour.
  final int minMinute;

  /// Segundo mínimo permitido (0-59). Aplica-se quando hora == minHour e minuto == minMinute.
  final int minSecond;

  /// Callback quando o tempo muda.
  final ValueChanged<({int hour, int minute, int second})> onTimeSelected;

  /// Se deve mostrar a coluna de segundos.
  final bool showSeconds;

  @override
  State<AppTimePicker> createState() => _AppTimePickerState();
}

class _AppTimePickerState extends State<AppTimePicker> {
  static const _itemExtent = 48.0;

  late FixedExtentScrollController _hourController;
  late int _hourSelectedIndex;
  late FixedExtentScrollController _minuteController;
  late int _minuteSelectedIndex;
  late FixedExtentScrollController _secondController;
  late int _secondSelectedIndex;

  late int _hour;
  late int _minute;
  late int _second;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialHour;
    _minute = widget.initialMinute;
    _second = widget.initialSecond;

    _hourSelectedIndex = _hour;
    _minuteSelectedIndex = _minute;
    _secondSelectedIndex = _second;

    _hourController = FixedExtentScrollController(
      initialItem: _hourSelectedIndex,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _minuteSelectedIndex,
    );
    _secondController = FixedExtentScrollController(
      initialItem: _secondSelectedIndex,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onTimeSelected((hour: _hour, minute: _minute, second: _second));
  }

  bool _isHourDisabled(int h) => h < widget.minHour;

  bool _isMinuteDisabled(int m) {
    if (_hour > widget.minHour) return false;
    if (_hour < widget.minHour) return true;
    return m < widget.minMinute;
  }

  bool _isSecondDisabled(int s) {
    if (_hour > widget.minHour) return false;
    if (_hour < widget.minHour) return true;
    if (_minute > widget.minMinute) return false;
    if (_minute < widget.minMinute) return true;
    return s < widget.minSecond;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    // Reflete o text scale até 1.5 (além disso clampa) para as rodas não
    // estourarem.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.5,
      child: Builder(
        builder: (context) {
          // Largura definida que escala com o texto: limita o Row(Expanded) e
          // torna o picker content-sized (cabe num painel que cresce, ex.: ao
          // lado do calendário no datetime picker).
          final double w = MediaQuery.textScalerOf(
            context,
          ).scale(widget.showSeconds ? 260.0 : 200.0);
          return SelectionContainer.disabled(
            child: SizedBox(
              width: w,
              height: _itemExtent * 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Horas
                  Expanded(
                    child: _buildWheel(
                      theme: theme,
                      controller: _hourController,
                      itemCount: 24,
                      selectedIndex: _hourSelectedIndex,
                      isDisabled: _isHourDisabled,
                      onChanged: (index, value) {
                        if (_isHourDisabled(value)) {
                          // Auto-snap para hora mínima (respeita reduce-motion).
                          if (AppMotion.enabled(context)) {
                            _hourController.animateToItem(
                              widget.minHour,
                              duration: AppDurations.normal,
                              curve: AppCurves.decelerate,
                            );
                          } else {
                            _hourController.jumpToItem(widget.minHour);
                          }
                          return;
                        }
                        setState(() {
                          _hourSelectedIndex = index;
                          _hour = value;

                          // Se mudou para minHour, validar minuto e segundo
                          if (_hour == widget.minHour) {
                            if (_minute < widget.minMinute) {
                              _minute = widget.minMinute;
                              _minuteSelectedIndex = widget.minMinute;
                              _minuteController.jumpToItem(widget.minMinute);
                            }
                            if (_minute == widget.minMinute &&
                                _second < widget.minSecond) {
                              _second = widget.minSecond;
                              _secondSelectedIndex = widget.minSecond;
                              _secondController.jumpToItem(widget.minSecond);
                            }
                          }
                        });
                        _notifyChange();
                      },
                    ),
                  ),
                  _buildSeparator(theme),
                  // Minutos
                  Expanded(
                    child: _buildWheel(
                      theme: theme,
                      controller: _minuteController,
                      itemCount: 60,
                      selectedIndex: _minuteSelectedIndex,
                      isDisabled: _isMinuteDisabled,
                      onChanged: (index, value) {
                        if (_isMinuteDisabled(value)) {
                          // Auto-snap para minuto mínimo (respeita reduce-motion).
                          if (AppMotion.enabled(context)) {
                            _minuteController.animateToItem(
                              widget.minMinute,
                              duration: AppDurations.normal,
                              curve: AppCurves.decelerate,
                            );
                          } else {
                            _minuteController.jumpToItem(widget.minMinute);
                          }
                          return;
                        }
                        setState(() {
                          _minuteSelectedIndex = index;
                          _minute = value;

                          // Se hora == minHour e minuto == minMinute, validar segundo
                          if (_hour == widget.minHour &&
                              _minute == widget.minMinute &&
                              _second < widget.minSecond) {
                            _second = widget.minSecond;
                            _secondSelectedIndex = widget.minSecond;
                            _secondController.jumpToItem(widget.minSecond);
                          }
                        });
                        _notifyChange();
                      },
                    ),
                  ),
                  if (widget.showSeconds) ...[
                    _buildSeparator(theme),
                    // Segundos
                    Expanded(
                      child: _buildWheel(
                        theme: theme,
                        controller: _secondController,
                        itemCount: 60,
                        selectedIndex: _secondSelectedIndex,
                        isDisabled: _isSecondDisabled,
                        onChanged: (index, value) {
                          if (_isSecondDisabled(value)) {
                            // Auto-snap para segundo mínimo (respeita reduce-motion).
                            if (AppMotion.enabled(context)) {
                              _secondController.animateToItem(
                                widget.minSecond,
                                duration: AppDurations.normal,
                                curve: AppCurves.decelerate,
                              );
                            } else {
                              _secondController.jumpToItem(widget.minSecond);
                            }
                            return;
                          }
                          setState(() {
                            _secondSelectedIndex = index;
                            _second = value;
                          });
                          _notifyChange();
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeparator(AppThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s4),
      child: AppText(
        ':',
        style: theme.textTheme.titleMedium.withColor(
          readableStopOn(theme.colorTheme.secondary, theme.colorTheme.surface),
        ),
      ),
    );
  }

  Widget _buildWheel({
    required AppThemeData theme,
    required FixedExtentScrollController controller,
    required int itemCount,
    required void Function(int index, int value) onChanged,
    required int selectedIndex,
    required bool Function(int) isDisabled,
  }) {
    return Stack(
      children: [
        // Highlight do item selecionado
        Positioned.fill(
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: readableStopOn(
                      theme.colorTheme.secondary,
                      theme.colorTheme.surface,
                    ),
                    width: AppStrokes.m,
                  ),
                ),
              ),
              child: const SizedBox(
                height: _itemExtent,
                width: AppSpacings.infinity,
              ),
            ),
          ),
        ),
        // Wheel
        ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: _itemExtent,
          onSelectedItemChanged: (index) => onChanged(index, index),
          physics: const FixedExtentScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: itemCount,
            builder: (context, index) {
              final isSelected = index == selectedIndex;
              final disabled = isDisabled(index);

              Color textColor;
              if (disabled) {
                textColor = theme.colorTheme.neutralPrimary.s200;
              } else if (isSelected) {
                textColor = readableStopOn(
                  theme.colorTheme.secondary,
                  theme.colorTheme.surface,
                );
              } else {
                textColor = theme.colorTheme.neutralPrimary.s900;
              }

              return Center(
                child: AppText(
                  index.toString().padLeft(2, '0'),
                  style: theme.textTheme.titleMedium.withColor(textColor),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
