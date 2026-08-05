import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_field_size.dart';
import '../../tokens/app_style.dart';
import 'app_dropdown_option.dart';
import 'dropdown_internals.dart';

/// Dropdown de **seleção única com busca**: um campo de filtro no topo do
/// overlay restringe as opções por texto. Reusa o core de dropdown.
final class AppSearchableDropdown<T> extends StatefulWidget {
  /// Cria um [AppSearchableDropdown].
  const AppSearchableDropdown({
    required this.onChanged,
    required this.options,
    this.enabled = true,
    this.errorText,
    this.hasError = false,
    this.helperText,
    this.hintText,
    this.label,
    this.info,
    this.searchHintText,
    this.selectedValue,
    this.style,
    this.size = AppFieldSize.m,
    super.key,
  });

  /// Se está habilitado.
  final bool enabled;

  /// Texto de erro.
  final String? errorText;

  /// Se está em erro.
  final bool hasError;

  /// Texto auxiliar.
  final String? helperText;

  /// Placeholder do trigger.
  final String? hintText;

  /// Label acima do campo.
  final String? label;

  /// Conteúdo livre de um popover de informação ao lado do label.
  final Widget? info;

  /// Placeholder do campo de busca.
  final String? searchHintText;

  /// Callback ao mudar o valor.
  final ValueChanged<T?> onChanged;

  /// Opções disponíveis.
  final List<AppDropdownOption<T>> options;

  /// Valor selecionado.
  final T? selectedValue;

  /// Eixo global [AppStyle] do trigger. `null` segue o global do tema.
  final AppStyle? style;

  /// Tamanho do campo (altura fixa + métricas). Default [AppFieldSize.m].
  final AppFieldSize size;

  @override
  State<AppSearchableDropdown<T>> createState() =>
      _AppSearchableDropdownState<T>();
}

class _AppSearchableDropdownState<T> extends State<AppSearchableDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  final TextEditingController _search = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _search.addListener(_onQuery);
  }

  @override
  void dispose() {
    _removeOverlay();
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onQuery() {
    _hoveredIndex = null;
    _overlayEntry?.markNeedsBuild();
  }

  void _toggle() => _isOpen ? _close() : _open();

  List<AppDropdownOption<T>> get _filtered {
    final String q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return widget.options;
    return widget.options
        .where((AppDropdownOption<T> o) => o.label.toLowerCase().contains(q))
        .toList();
  }

  void _open() {
    final RenderBox? box =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final double width = box.size.width;
    // O Overlay fica acima do provider de tema → capturar e reprovê AppTheme na
    // entry (senão DropdownPanel/dropdownOptionRow lançam "No AppTheme found").
    final AppThemeData theme = AppTheme.of(context);
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext _) => AppOverlayScope(
        theme: theme,
        textScaler: textScaler,
        child: Builder(
          builder: (BuildContext context) {
            final List<AppDropdownOption<T>> filtered = _filtered;
            return DropdownPanel(
              layerLink: _layerLink,
              triggerWidth: width,
              onDismiss: _close,
              emptyLabel: 'Nenhum resultado',
              search: DropdownSearchField(
                controller: _search,
                focusNode: _searchFocus,
                hint: widget.searchHintText,
              ),
              options: _buildOptionWidgets(context, filtered),
            );
          },
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _searchFocus.requestFocus(),
    );
  }

  void _close() {
    _removeOverlay();
    _search.clear();
    if (mounted) {
      setState(() {
        _isOpen = false;
        _hoveredIndex = null;
      });
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  /// Constrói as linhas do overlay a partir das opções filtradas, inserindo um
  /// cabeçalho antes do primeiro item de cada [AppDropdownOption.section]
  /// não-nula (sem cabeçalho quando `section` é `null`). O índice de hover segue
  /// referenciando a posição na lista filtrada, não a posição visual.
  List<Widget> _buildOptionWidgets(
    BuildContext context,
    List<AppDropdownOption<T>> filtered,
  ) {
    final List<Widget> widgets = <Widget>[];
    String? currentSection;
    for (int i = 0; i < filtered.length; i++) {
      final AppDropdownOption<T> option = filtered[i];
      if (option.section != currentSection) {
        currentSection = option.section;
        if (option.section != null) {
          widgets.add(dropdownSectionHeader(context, option.section!));
        }
      }
      widgets.add(
        dropdownOptionRow(
          context,
          label: option.label,
          selected: option.value == widget.selectedValue,
          hovered: _hoveredIndex == i,
          onTap: () {
            widget.onChanged(option.value);
            _close();
          },
          onHover: (bool h) {
            _hoveredIndex = h ? i : null;
            _overlayEntry?.markNeedsBuild();
          },
        ),
      );
    }
    return widgets;
  }

  String? get _selectedLabel {
    for (final AppDropdownOption<T> o in widget.options) {
      if (o.value == widget.selectedValue) return o.label;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final String? selected = _selectedLabel;
    final bool showClear =
        (widget.hasError || widget.errorText != null) &&
        widget.enabled &&
        widget.selectedValue != null;
    return DropdownField(
      label: widget.label,
      // O `display` é visual (texto truncado, hint apagado); o leitor precisa
      // do valor em texto para dizer o que está escolhido.
      semanticValue: selected,
      info: widget.info,
      enabled: widget.enabled,
      hasError: widget.hasError,
      errorText: widget.errorText,
      helperText: widget.helperText,
      isOpen: _isOpen,
      onTap: _toggle,
      onClear: showClear
          ? () {
              widget.onChanged(null);
              if (!_isOpen) _open();
            }
          : null,
      triggerKey: _triggerKey,
      layerLink: _layerLink,
      style: widget.style,
      size: widget.size,
      display: AppText(
        selected ?? (widget.hintText ?? ''),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: selected != null
            ? theme.textTheme.bodyLarge.copyWith(color: colors.onSurface)
            : theme.textTheme.bodyMedium.copyWith(
                color: colors.neutralPrimary.s600,
              ),
      ),
    );
  }
}
