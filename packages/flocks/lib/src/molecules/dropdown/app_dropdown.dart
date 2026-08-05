import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_field_size.dart';
import '../../tokens/app_style.dart';
import 'app_dropdown_option.dart';
import 'dropdown_internals.dart';

/// Dropdown de **seleção única** (sem Material).
///
/// Campo trigger que abre um overlay com as opções; a escolha fecha o overlay.
/// Trigger com foco-Tab (via `FlocksInteraction`), chevron animado (`AppMotion`)
/// e cores 100% do tema (acentos em stop legível). Overlay reusa `AppCard`.
///
/// ```dart
/// AppDropdown<String>(
///   label: 'Fruta',
///   options: <AppDropdownOption<String>>[AppDropdownOption(value: 'b', label: 'Banana')],
///   selectedValue: v, onChanged: (nv) => setState(() => v = nv),
/// )
/// ```
final class AppDropdown<T> extends StatefulWidget {
  /// Cria um [AppDropdown].
  const AppDropdown({
    required this.onChanged,
    required this.options,
    this.enabled = true,
    this.errorText,
    this.hasError = false,
    this.helperText,
    this.hintText,
    this.label,
    this.info,
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

  /// Placeholder quando nada selecionado.
  final String? hintText;

  /// Label acima do campo.
  final String? label;

  /// Conteúdo livre de um popover de informação ao lado do label.
  final Widget? info;

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
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  int? _hoveredIndex;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggle() => _isOpen ? _close() : _open();

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
          builder: (BuildContext context) => DropdownPanel(
            layerLink: _layerLink,
            triggerWidth: width,
            onDismiss: _close,
            options: <Widget>[
              for (int i = 0; i < widget.options.length; i++)
                dropdownOptionRow(
                  context,
                  label: widget.options[i].label,
                  selected: widget.options[i].value == widget.selectedValue,
                  hovered: _hoveredIndex == i,
                  onTap: () {
                    widget.onChanged(widget.options[i].value);
                    _close();
                  },
                  onHover: (bool h) {
                    _hoveredIndex = h ? i : null;
                    _overlayEntry?.markNeedsBuild();
                  },
                ),
            ],
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _close() {
    _removeOverlay();
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
      display: selected != null
          ? AppText(
              selected,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge.copyWith(
                color: colors.onSurface,
              ),
            )
          : AppText(
              widget.hintText ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium.copyWith(
                color: colors.neutralPrimary.s600,
              ),
            ),
    );
  }
}
