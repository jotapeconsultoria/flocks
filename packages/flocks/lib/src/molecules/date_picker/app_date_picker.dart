import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'date_picker_core.dart';

/// Date picker com navegação por mês, seleção de ano/mês e hover.
///
/// Exibe um calendário com grid de dias, navegação por mês (chevrons),
/// seleção de ano e mês ao clicar na label do header,
/// e destaque do dia selecionado com quadrado arredondado.
///
/// Para seleção de intervalo, veja [AppDateRangePicker].
final class AppDatePicker extends StatefulWidget {
  const AppDatePicker({
    required this.initialDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.markToday = false,
    this.today,
    super.key,
  });

  /// Data mínima selecionável (default: 2026-01-01).
  final DateTime? firstDate;

  /// Data pré-selecionada.
  final DateTime initialDate;

  /// Data máxima selecionável (default: DateTime.now()).
  final DateTime? lastDate;

  /// Marca o dia atual com uma borda (default: `false`).
  final bool markToday;

  /// Callback quando uma data é selecionada.
  final ValueChanged<DateTime> onDateSelected;

  /// Sobrescreve "hoje" (para testes/goldens determinísticos). Default:
  /// `DateTime.now()`.
  @visibleForTesting
  final DateTime? today;

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  late DateTime _displayedMonth;
  late DateTime _firstDate;
  int? _hoveredDay;
  int? _hoveredMonth;
  int? _hoveredYear;
  late DateTime _lastDate;
  late DateTime _selectedDate;
  late DateTime _today;
  DatePickerView _view = DatePickerView.days;
  late int _yearRangeStart;

  /// Lado base de uma célula/coluna do grid (a text scale multiplica isto → o
  /// grid e o painel crescem juntos, cabendo até 2×).
  static const double _kDayCell = 40.0;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    // Reflete o text scale até 1.5 (além disso clampa). As colunas escalam com o
    // texto (`cell`) e o painel cresce (AppPickerAnchor usa minWidth), então o
    // grid de 7 colunas cabe sem headers quebrando nem células estourando.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.5,
      child: Builder(
        builder: (context) {
          final double cell = MediaQuery.textScalerOf(context).scale(_kDayCell);
          // Largura do calendário = 7 colunas (`cell` cada). Fixá-la dá base ao
          // header (spaceBetween) e casa headers/grid; cresce com o text scale.
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
    bool isSelected,
    DateTime date,
    double cell,
  ) {
    final isHovered = _hoveredDay == day;
    final isToday = widget.markToday && date == _today;
    final selectedFill = selectedDateFill(theme);

    final textColor = dateCellTextColor(
      theme,
      isFilled: isSelected,
      isEnabled: isEnabled,
      selectedFill: selectedFill,
    );
    final decoration = dateCellDecoration(
      theme,
      isFilled: isSelected,
      isHovered: isHovered,
      isEnabled: isEnabled,
      isToday: isToday,
      selectedFill: selectedFill,
    );

    // Célula quadrada que escala com o text scale (via `cell`); o realce
    // (decoration) preenche o quadrado com uma pequena folga.
    final child = SizedBox.square(
      dimension: cell,
      child: Padding(
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
      selected: isSelected,
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
      final isSelected = date == _selectedDate;
      final isEnabled = !date.isBefore(_firstDate) && !date.isAfter(_lastDate);
      cells.add(_buildDayCell(theme, day, isEnabled, isSelected, date, cell));
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
          // Colunas de largura fixa (`cell`) → o grid tem largura natural
          // (7×cell) que cresce com o text scale; sem Expanded (que travaria na
          // largura do painel e estouraria).
          child: Row(mainAxisSize: MainAxisSize.min, children: rowCells),
        ),
      );
    }

    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  Widget _buildMonthCell(AppThemeData theme, int monthIndex) {
    final month = monthIndex + 1;
    final isEnabled = _isMonthEnabled(month);
    final isCurrentMonth =
        _selectedDate.year == _displayedMonth.year &&
        _selectedDate.month == month;
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

    if (!isEnabled) {
      return child;
    }

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
        final monthIndex = row * 3 + col;
        rowCells.add(Expanded(child: _buildMonthCell(theme, monthIndex)));
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
    final isCurrentYear = _selectedDate.year == year;
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

    if (!isEnabled) {
      return child;
    }

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
    _selectedDate = dateOnly(widget.initialDate);
    _today = dateOnly(widget.today ?? DateTime.now());
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
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

  bool _isYearEnabled(int year) {
    return year >= _firstDate.year && year <= _lastDate.year;
  }

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
    setState(() => _selectedDate = day);
    widget.onDateSelected(day);
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
