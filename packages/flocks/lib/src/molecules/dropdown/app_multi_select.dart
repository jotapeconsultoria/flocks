import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_field_size.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../../tokens/swatch_generator.dart';
import 'app_dropdown_option.dart';
import 'dropdown_internals.dart';

/// Dropdown de **seleção múltipla** (sem Material).
///
/// Trigger com chips dos selecionados; o overlay marca com ✓ e **não fecha** ao
/// selecionar (fecha ao clicar fora). Cores 100% do tema; reusa o core de
/// dropdown (trigger + overlay).
final class AppMultiSelect<T> extends StatefulWidget {
  /// Cria um [AppMultiSelect].
  const AppMultiSelect({
    required this.onChanged,
    required this.options,
    this.enabled = true,
    this.errorText,
    this.hasError = false,
    this.helperText,
    this.hintText,
    this.label,
    this.info,
    this.selectedValues = const <Never>[],
    this.style,
    this.size = AppFieldSize.m,
    this.multiline = false,
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

  /// Callback quando a lista muda.
  final ValueChanged<List<T>> onChanged;

  /// Opções disponíveis.
  final List<AppDropdownOption<T>> options;

  /// Valores selecionados.
  final List<T> selectedValues;

  /// Eixo global [AppStyle] do trigger. `null` segue o global do tema.
  final AppStyle? style;

  /// Tamanho do campo (altura fixa + métricas). Default [AppFieldSize.m].
  final AppFieldSize size;

  /// Quando `false` (default) os chips ficam em **1 linha com scroll horizontal**
  /// (o campo mantém a altura de [size], igual aos demais). Quando `true`, os
  /// chips quebram em várias linhas e o campo **cresce** (com padding vertical).
  final bool multiline;

  @override
  State<AppMultiSelect<T>> createState() => _AppMultiSelectState<T>();
}

class _AppMultiSelectState<T> extends State<AppMultiSelect<T>> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  int? _hoveredIndex;

  @override
  void didUpdateWidget(covariant AppMultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isOpen) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _overlayEntry?.markNeedsBuild(),
      );
    }
  }

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
                  selected: widget.selectedValues.contains(
                    widget.options[i].value,
                  ),
                  hovered: _hoveredIndex == i,
                  onTap: () => _toggleValue(widget.options[i].value),
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

  void _toggleValue(T value) {
    final List<T> next = List<T>.from(widget.selectedValues);
    next.contains(value) ? next.remove(value) : next.add(value);
    widget.onChanged(next);
    _overlayEntry?.markNeedsBuild();
  }

  void _removeValue(T value) {
    widget.onChanged(List<T>.from(widget.selectedValues)..remove(value));
  }

  String _labelFor(T value) {
    for (final AppDropdownOption<T> o in widget.options) {
      if (o.value == value) return o.label;
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool hasSelection = widget.selectedValues.isNotEmpty;
    final bool showClear =
        (widget.hasError || widget.errorText != null) &&
        widget.enabled &&
        hasSelection;
    return DropdownField(
      label: widget.label,
      // Chips não são texto: sem isto o leitor anuncia o controle sem dizer
      // NADA do que está marcado. Lista os rótulos, não a contagem — "3
      // selecionados" obriga a abrir o painel para saber quais.
      semanticValue: hasSelection
          ? widget.selectedValues.map(_labelFor).join(', ')
          : null,
      info: widget.info,
      enabled: widget.enabled,
      hasError: widget.hasError,
      errorText: widget.errorText,
      helperText: widget.helperText,
      isOpen: _isOpen,
      onTap: _toggle,
      onClear: showClear
          ? () {
              widget.onChanged(<T>[]);
              if (!_isOpen) _open();
            }
          : null,
      triggerKey: _triggerKey,
      layerLink: _layerLink,
      style: widget.style,
      size: widget.size,
      display: _chipsDisplay(theme, colors, hasSelection),
    );
  }

  /// Chips selecionados: 1 linha com scroll horizontal (default, altura de
  /// [AppMultiSelect.size]) ou multi-linha que cresce com padding vertical.
  Widget _chipsDisplay(
    AppThemeData theme,
    AppColorTheme colors,
    bool hasSelection,
  ) {
    if (!hasSelection) {
      return AppText(
        widget.hintText ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium.copyWith(
          color: colors.neutralPrimary.s600,
        ),
      );
    }
    final List<Widget> chips = <Widget>[
      for (final T value in widget.selectedValues) _chip(theme, colors, value),
    ];
    return widget.multiline
        ? Padding(
            padding: EdgeInsets.symmetric(
              vertical: widget.size.verticalPadding,
            ),
            child: Wrap(
              spacing: AppSpacings.s4,
              runSpacing: AppSpacings.s4,
              children: chips,
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacings.s4,
              children: chips,
            ),
          );
  }

  Widget _chip(AppThemeData theme, AppColorTheme colors, T value) {
    // Chip em tom de primary; texto/ícone num stop legível sobre o tom.
    final Color chipBg = colors.primary.s100;
    final Color chipFg = readableStopOn(colors.primary, chipBg, minRatio: 4.5);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: theme.radiusTheme.resolve(),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacings.s8,
          AppSpacings.s2,
          AppSpacings.s2,
          AppSpacings.s2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppText(
              _labelFor(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium.copyWith(color: chipFg),
            ),
            const SizedBox(width: AppSpacings.s2),
            if (widget.enabled)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _removeValue(value),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacings.s2),
                    child: AppIcon(
                      AppIconToken.cancel,
                      color: chipFg,
                      customSize: 14,
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(AppSpacings.s2),
                child: AppIcon(
                  AppIconToken.cancel,
                  color: colors.primary.s300,
                  customSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
