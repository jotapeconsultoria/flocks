import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'date_picker_core.dart';

/// Bandas que uma célula de dia pode receber ao compor o intervalo contínuo.
enum _RangeBand {
  /// Sem banda.
  none,

  /// Banda cobrindo a célula inteira (dia interior do intervalo).
  full,

  /// Metade esquerda (dia final: o intervalo vem da esquerda).
  leading,

  /// Metade direita (dia inicial: o intervalo segue para a direita).
  trailing,
}

/// Date picker de **intervalo**: toque no início, depois no fim.
///
/// Calendário de mês único (navegue entre meses com as setas). O primeiro toque
/// define o início; o segundo, o fim (tocar antes do início recomeça a
/// seleção). Início e fim recebem o pill preenchido e os dias entre eles uma
/// banda contínua. Para seleção de data única, veja [AppDatePicker].
final class AppDateRangePicker extends StatefulWidget {
  const AppDateRangePicker({
    required this.onRangeSelected,
    this.initialRange,
    this.firstDate,
    this.lastDate,
    this.markToday = false,
    this.today,
    super.key,
  });

  /// Data mínima selecionável (default: 2026-01-01).
  final DateTime? firstDate;

  /// Intervalo pré-selecionado (opcional).
  final AppDateRange? initialRange;

  /// Data máxima selecionável (default: DateTime.now()).
  final DateTime? lastDate;

  /// Marca o dia atual com uma borda (default: `false`).
  final bool markToday;

  /// Callback quando um intervalo completo (início + fim) é selecionado.
  final ValueChanged<AppDateRange> onRangeSelected;

  /// Sobrescreve "hoje" (para testes/goldens determinísticos). Default:
  /// `DateTime.now()`.
  @visibleForTesting
  final DateTime? today;

  @override
  State<AppDateRangePicker> createState() => _AppDateRangePickerState();
}

class _AppDateRangePickerState extends State<AppDateRangePicker> {
  late DateTime _displayedMonth;
  late DateTime _firstDate;
  int? _hoveredDay;
  int? _hoveredMonth;
  int? _hoveredYear;
  late DateTime _lastDate;
  DateTime? _rangeEnd;
  DateTime? _rangeStart;
  late DateTime _today;
  DatePickerView _view = DatePickerView.days;
  late int _yearRangeStart;

  static const double _kDayCell = 40.0;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.5,
      child: Builder(
        builder: (context) {
          final double cell = MediaQuery.textScalerOf(context).scale(_kDayCell);
          return SizedBox(
            width: 7 * cell,
            child: SelectionContainer.disabled(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarHeader(
                    theme: theme,
                    cell: cell,
                    label: _headerLabel,
                    canGoBack: _canGoBack,
                    canGoForward: _canGoForward,
                    onBack: _goBack,
                    onForward: _goForward,
                    onLabelTap: _onHeaderLabelTap,
                  ),
                  const SizedBox(height: AppSpacings.s8),
                  switch (_view) {
                    DatePickerView.days => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildWeekDayHeaders(theme, cell),
                        const SizedBox(height: AppSpacings.s4),
                        _buildDaysGrid(theme, cell),
                      ],
                    ),
                    DatePickerView.months => _buildMonthsGrid(theme),
                    DatePickerView.years => _buildYearsGrid(theme),
                  },
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayCell(
    AppThemeData theme,
    int day,
    bool isEnabled,
    DateTime date,
    double cell,
  ) {
    final isHovered = _hoveredDay == day;
    final isToday = widget.markToday && date == _today;

    final isStart = _rangeStart != null && date == _rangeStart;
    final isEnd = _rangeEnd != null && date == _rangeEnd;
    final isEndpoint = isStart || isEnd;
    final band = _bandFor(date);

    final selectedFill = selectedDateFill(theme);
    final textColor = dateCellTextColor(
      theme,
      isFilled: isEndpoint,
      isEnabled: isEnabled,
      selectedFill: selectedFill,
    );
    final decoration = dateCellDecoration(
      theme,
      isFilled: isEndpoint,
      isHovered: isHovered,
      isEnabled: isEnabled,
      isToday: isToday,
      selectedFill: selectedFill,
    );

    final child = SizedBox.square(
      dimension: cell,
      child: Stack(
        children: [
          if (band != _RangeBand.none)
            Positioned.fill(child: _rangeBand(theme, cell, band, selectedFill)),
          Padding(
            padding: EdgeInsets.all(cell * 0.08),
            child: AnimatedContainer(
              duration: dateCellAnimation(context),
              curve: AppCurves.decelerate,
              alignment: Alignment.center,
              decoration: decoration,
              child: AppText(
                '$day',
                style: theme.textTheme.labelLarge.withColor(textColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );

    // Dia FORA do intervalo continua na árvore semântica: some do toque, não
    // da leitura. Sem isto o leitor pula a célula e o usuário conclui que o mês
    // tem menos dias — em vez de entender que aquele está indisponível.
    if (!isEnabled) {
      return AppSemantics.gridCell(
        label: dayCellSemanticLabel(date),
        selected: false,
        enabled: false,
        child: child,
      );
    }

    return AppSemantics.gridCell(
      label: dayCellSemanticLabel(date),
      // No intervalo, "selecionado" é a EXTREMIDADE (o que o usuário escolheu),
      // não todo dia coberto pela banda: marcar 30 dias como selecionados faz o
      // leitor anunciar seleção em cada um deles.
      selected: isEndpoint,
      onTap: () => _selectDay(date),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hoveredDay = day),
        onExit: (_) => setState(() => _hoveredDay = null),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _selectDay(date),
          child: child,
        ),
      ),
    );
  }

  Widget _buildDaysGrid(AppThemeData theme, double cell) {
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;
    final firstWeekday =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday % 7;

    final cells = <Widget>[];
    for (var i = 0; i < firstWeekday; i++) {
      cells.add(SizedBox(width: cell));
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
      final isEnabled = !date.isBefore(_firstDate) && !date.isAfter(_lastDate);
      cells.add(_buildDayCell(theme, day, isEnabled, date, cell));
    }

    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += 7) {
      final end = (i + 7 > cells.length) ? cells.length : i + 7;
      final rowCells = cells.sublist(i, end);
      while (rowCells.length < 7) {
        rowCells.add(SizedBox(width: cell));
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacings.s1),
          child: Row(mainAxisSize: MainAxisSize.min, children: rowCells),
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  /// A banda contínua desenhada atrás dos dias do intervalo. Pintada em largura
  /// cheia (interior) ou meia (pontas), sem inset horizontal, para ligar-se aos
  /// vizinhos da mesma linha da semana; quebra nas bordas da semana.
  Widget _rangeBand(
    AppThemeData theme,
    double cell,
    _RangeBand band,
    Color selectedFill,
  ) {
    final bar = Padding(
      padding: EdgeInsets.symmetric(vertical: cell * 0.08),
      child: ColoredBox(color: selectedFill.customOpacity(.18)),
    );
    return switch (band) {
      _RangeBand.full => bar,
      _RangeBand.leading => Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(widthFactor: 0.5, child: bar),
      ),
      _RangeBand.trailing => Align(
        alignment: Alignment.centerRight,
        child: FractionallySizedBox(widthFactor: 0.5, child: bar),
      ),
      _RangeBand.none => const SizedBox.shrink(),
    };
  }

  /// Que banda a célula [date] recebe dentro de um intervalo completo.
  _RangeBand _bandFor(DateTime date) {
    final start = _rangeStart;
    final end = _rangeEnd;
    if (start == null || end == null || start == end) return _RangeBand.none;
    if (date == start) return _RangeBand.trailing;
    if (date == end) return _RangeBand.leading;
    if (date.isAfter(start) && date.isBefore(end)) return _RangeBand.full;
    return _RangeBand.none;
  }

  Widget _buildMonthCell(AppThemeData theme, int monthIndex) {
    final month = monthIndex + 1;
    final isEnabled = _isMonthEnabled(month);
    final anchor = _rangeStart;
    final isCurrentMonth =
        anchor != null &&
        anchor.year == _displayedMonth.year &&
        anchor.month == month;
    final isHovered = _hoveredMonth == monthIndex;
    final selectedFill = selectedDateFill(theme);

    final textColor = dateCellTextColor(
      theme,
      isFilled: isCurrentMonth,
      isEnabled: isEnabled,
      selectedFill: selectedFill,
    );
    final decoration = dateCellDecoration(
      theme,
      isFilled: isCurrentMonth,
      isHovered: isHovered,
      isEnabled: isEnabled,
      isToday: false,
      selectedFill: selectedFill,
    );

    final child = AnimatedContainer(
      duration: dateCellAnimation(context),
      curve: AppCurves.decelerate,
      alignment: Alignment.center,
      decoration: decoration,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s4,
        vertical: AppSpacings.s4,
      ),
      child: AppText(
        monthAbbreviations[monthIndex],
        style: theme.textTheme.labelLarge.withColor(textColor),
        textAlign: TextAlign.center,
      ),
    );

    if (!isEnabled) return child;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredMonth = monthIndex),
      onExit: (_) => setState(() => _hoveredMonth = null),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _selectMonth(month),
        child: child,
      ),
    );
  }

  Widget _buildMonthsGrid(AppThemeData theme) {
    final rows = <Widget>[];
    for (var row = 0; row < 4; row++) {
      final rowCells = <Widget>[];
      for (var col = 0; col < 3; col++) {
        rowCells.add(Expanded(child: _buildMonthCell(theme, row * 3 + col)));
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacings.s4),
          child: Row(children: rowCells),
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  Widget _buildYearCell(AppThemeData theme, int year) {
    final isEnabled = _isYearEnabled(year);
    final anchor = _rangeStart;
    final isCurrentYear = anchor != null && anchor.year == year;
    final isHovered = _hoveredYear == year;
    final selectedFill = selectedDateFill(theme);

    final textColor = dateCellTextColor(
      theme,
      isFilled: isCurrentYear,
      isEnabled: isEnabled,
      selectedFill: selectedFill,
    );
    final decoration = dateCellDecoration(
      theme,
      isFilled: isCurrentYear,
      isHovered: isHovered,
      isEnabled: isEnabled,
      isToday: false,
      selectedFill: selectedFill,
    );

    final child = AnimatedContainer(
      duration: dateCellAnimation(context),
      curve: AppCurves.decelerate,
      alignment: Alignment.center,
      decoration: decoration,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s4,
        vertical: AppSpacings.s4,
      ),
      child: AppText(
        '$year',
        style: theme.textTheme.labelLarge.withColor(textColor),
        textAlign: TextAlign.center,
      ),
    );

    if (!isEnabled) return child;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredYear = year),
      onExit: (_) => setState(() => _hoveredYear = null),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _selectYear(year),
        child: child,
      ),
    );
  }

  Widget _buildYearsGrid(AppThemeData theme) {
    final rows = <Widget>[];
    for (var row = 0; row < 4; row++) {
      final rowCells = <Widget>[];
      for (var col = 0; col < 3; col++) {
        final year = _yearRangeStart + row * 3 + col;
        rowCells.add(Expanded(child: _buildYearCell(theme, year)));
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacings.s4),
          child: Row(children: rowCells),
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  bool get _canGoBack {
    switch (_view) {
      case DatePickerView.days:
        final prevMonth = DateTime(
          _displayedMonth.year,
          _displayedMonth.month - 1,
        );
        final lastDayOfPrev = DateTime(prevMonth.year, prevMonth.month + 1, 0);
        return !lastDayOfPrev.isBefore(_firstDate);
      case DatePickerView.months:
        return _displayedMonth.year - 1 >= _firstDate.year;
      case DatePickerView.years:
        return _yearRangeStart > _firstDate.year;
    }
  }

  bool get _canGoForward {
    switch (_view) {
      case DatePickerView.days:
        final nextMonth = DateTime(
          _displayedMonth.year,
          _displayedMonth.month + 1,
        );
        return !nextMonth.isAfter(
          DateTime(_lastDate.year, _lastDate.month + 1),
        );
      case DatePickerView.months:
        return _displayedMonth.year + 1 <= _lastDate.year;
      case DatePickerView.years:
        return _yearRangeStart + yearsPerPage - 1 < _lastDate.year;
    }
  }

  void _goBack() {
    if (!_canGoBack) return;
    setState(() {
      _resetHovers();
      switch (_view) {
        case DatePickerView.days:
          _displayedMonth = DateTime(
            _displayedMonth.year,
            _displayedMonth.month - 1,
          );
        case DatePickerView.months:
          _displayedMonth = DateTime(
            _displayedMonth.year - 1,
            _displayedMonth.month,
          );
        case DatePickerView.years:
          _yearRangeStart -= yearsPerPage;
      }
    });
  }

  void _goForward() {
    if (!_canGoForward) return;
    setState(() {
      _resetHovers();
      switch (_view) {
        case DatePickerView.days:
          _displayedMonth = DateTime(
            _displayedMonth.year,
            _displayedMonth.month + 1,
          );
        case DatePickerView.months:
          _displayedMonth = DateTime(
            _displayedMonth.year + 1,
            _displayedMonth.month,
          );
        case DatePickerView.years:
          _yearRangeStart += yearsPerPage;
      }
    });
  }

  String get _headerLabel => switch (_view) {
    DatePickerView.days =>
      '${monthNames[_displayedMonth.month - 1]}, ${_displayedMonth.year}',
    DatePickerView.months => '${_displayedMonth.year}',
    DatePickerView.years =>
      '$_yearRangeStart - ${_yearRangeStart + yearsPerPage - 1}',
  };

  @override
  void initState() {
    super.initState();
    final initial = widget.initialRange;
    _rangeStart = initial != null ? dateOnly(initial.start) : null;
    _rangeEnd = initial?.end != null ? dateOnly(initial!.end!) : null;
    _today = dateOnly(widget.today ?? DateTime.now());
    final anchor = _rangeStart ?? _today;
    _displayedMonth = DateTime(anchor.year, anchor.month);
    _firstDate = widget.firstDate != null
        ? dateOnly(widget.firstDate!)
        : DateTime(2026);
    _lastDate = widget.lastDate != null
        ? dateOnly(widget.lastDate!)
        : dateOnly(DateTime.now());
    _yearRangeStart = (_displayedMonth.year ~/ yearsPerPage) * yearsPerPage;
  }

  bool _isMonthEnabled(int month) {
    final year = _displayedMonth.year;
    final firstDayOfMonth = DateTime(year, month);
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    return !lastDayOfMonth.isBefore(_firstDate) &&
        !firstDayOfMonth.isAfter(_lastDate);
  }

  bool _isYearEnabled(int year) =>
      year >= _firstDate.year && year <= _lastDate.year;

  void _onHeaderLabelTap() {
    setState(() {
      _resetHovers();
      switch (_view) {
        case DatePickerView.days:
        case DatePickerView.months:
          _yearRangeStart =
              (_displayedMonth.year ~/ yearsPerPage) * yearsPerPage;
          _view = DatePickerView.years;
        case DatePickerView.years:
          _view = DatePickerView.days;
      }
    });
  }

  void _resetHovers() {
    _hoveredDay = null;
    _hoveredMonth = null;
    _hoveredYear = null;
  }

  void _selectDay(DateTime day) {
    setState(() {
      if (_rangeStart == null || _rangeEnd != null) {
        // Sem seleção, ou intervalo completo → recomeça pelo início.
        _rangeStart = day;
        _rangeEnd = null;
      } else if (day.isBefore(_rangeStart!)) {
        // Toque antes do início → o novo toque vira o início.
        _rangeStart = day;
        _rangeEnd = null;
      } else {
        _rangeEnd = day;
      }
    });
    if (_rangeStart != null && _rangeEnd != null) {
      widget.onRangeSelected(AppDateRange(_rangeStart!, _rangeEnd));
    }
  }

  void _selectMonth(int month) {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, month);
      _view = DatePickerView.days;
      _resetHovers();
    });
  }

  void _selectYear(int year) {
    setState(() {
      _displayedMonth = DateTime(year, _displayedMonth.month);
      _view = DatePickerView.months;
      _resetHovers();
    });
  }
}
