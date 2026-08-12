import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../foundation/selection/app_text_selection_controls.dart';
import '../../foundation/selection/app_text_selection_gestures.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../input/field_label.dart';
import '../pickers/pickers.dart';
import 'app_color_picker_panel.dart';
import 'hex_field_formatters.dart';

/// Campo de seleção de cor (sem Material nem dependências externas).
///
/// Exibe um swatch pintado com a cor atual + o valor `#HEX` editável e, ao
/// clicar, abre um overlay com o [AppColorPickerPanel] (seletor visual HSV +
/// presets). Segue os tokens e o estilo de [AppInput]/[AppDropdown].
///
/// O [onChanged] emite o hex normalizado `'#RRGGBB'` (ou `''` quando o campo
/// é esvaziado), pronto para persistir.
///
/// Exemplo:
/// ```dart
/// AppColorPickerInput(
///   label: 'Cor',
///   value: '#FF5B04',
///   onChanged: (hex) => setState(() => _color = hex),
/// )
/// ```
final class AppColorPickerInput extends StatefulWidget {
  const AppColorPickerInput({
    required this.onChanged,
    this.value,
    this.label,
    this.info,
    this.hintText,
    this.helperText,
    this.errorText,
    this.hasError = false,
    this.enabled = true,
    this.fallbackColor,
    this.shape = AppSwatchShape.square,
    this.presets,
    this.showSuggestedColors = true,
    this.style,
    this.radiusMode,
    this.radius,
    this.size = AppFieldSize.m,
    super.key,
  });

  /// Emite o hex normalizado `'#RRGGBB'` (ou `''` quando vazio).
  final ValueChanged<String> onChanged;

  /// Hex atual (controlado). `null`/`''` mostram o swatch com [fallbackColor].
  final String? value;

  /// Label acima do campo.
  final String? label;

  /// Conteúdo livre de um popover de informação ao lado do label.
  final Widget? info;

  /// Placeholder exibido na área editável quando vazia (ex.: `'FF5B04'`).
  final String? hintText;

  /// Texto auxiliar abaixo do campo.
  final String? helperText;

  /// Texto de erro abaixo do campo (substitui o helper).
  final String? errorText;

  /// Se o campo está em estado de erro.
  final bool hasError;

  /// Se o campo está habilitado.
  final bool enabled;

  /// Cor do swatch quando [value] está vazio/inválido.
  ///
  /// `null` (padrão) resolve do tema (`colorTheme.secondary`), acompanhando a
  /// marca ativa. Era uma constante da marca Jotape, o que fazia toda marca
  /// sem `secondaryColor` própria exibir o laranja da Jotape.
  final Color? fallbackColor;

  /// Formato do swatch.
  final AppSwatchShape shape;

  /// Presets do painel; quando null usa a paleta padrão.
  final List<Color>? presets;

  /// Exibe a seção "Cores sugeridas" (presets) no painel. Default `true`.
  final bool showSuggestedColors;

  /// Eixo global [AppStyle] do campo. `null` segue o global do tema.
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste campo (vence o global).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio — vence [radiusMode] e o global.
  final BorderRadius? radius;

  /// Tamanho do campo (altura fixa + métricas). Default [AppFieldSize.m].
  final AppFieldSize size;

  @override
  State<AppColorPickerInput> createState() => _AppColorPickerInputState();
}

class _AppColorPickerInputState extends State<AppColorPickerInput>
    with AppTextSelectionGestures<AppColorPickerInput> {
  static const _panelWidth = 248.0;

  @override
  bool get selectionEnabled => widget.enabled;

  late TextEditingController _controller;
  late FocusNode _focusNode;
  AppPickerHandle? _handle;
  bool _isFocused = false;
  Color? _currentColor;

  /// Estado de abertura do overlay, delegado ao [AppPickerAnchor].
  bool get _isOpen => _handle?.isOpen ?? false;

  static String _stripHash(String? hex) =>
      (hex ?? '').trim().replaceFirst('#', '');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _stripHash(widget.value))
      ..addListener(_onControllerChanged);
    _focusNode = FocusNode()..addListener(_onFocusChange);
    _currentColor = parseHexColor(widget.value);
  }

  @override
  void didUpdateWidget(AppColorPickerInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Só ressincroniza quando a mudança vem de fora e o campo não está em
    // edição — evita brigar com o cursor enquanto o usuário digita.
    if (!_focusNode.hasFocus &&
        widget.value != oldWidget.value &&
        _stripHash(widget.value) != _controller.text) {
      final next = _stripHash(widget.value);
      _controller.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
      _currentColor = parseHexColor(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    // Rebuild para alternar a visibilidade do placeholder.
    setState(() {});
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _onTextChanged(String text) {
    final digits = text.trim();
    if (digits.isEmpty) {
      setState(() => _currentColor = null);
      widget.onChanged('');
      return;
    }
    final parsed = digits.length == 6 ? parseHexColor('#$digits') : null;
    setState(() => _currentColor = parsed);
    if (parsed != null) {
      widget.onChanged(colorToHex(parsed));
    }
  }

  void _applyColor(Color color) {
    final digits = _stripHash(colorToHex(color));
    _controller.value = TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
    setState(() => _currentColor = color);
    widget.onChanged(colorToHex(color));
    _handle?.rebuild();
  }

  /// Cor exibida no swatch: o valor atual, o fallback do call site, ou — o
  /// padrão — o `secondary` da marca ativa, resolvido do tema.
  Color get _displayColor =>
      _currentColor ??
      widget.fallbackColor ??
      AppTheme.of(context).colorTheme.secondary;

  void _toggle() {
    if (!widget.enabled) return;
    _handle?.toggle();
  }

  /// Erro + habilitado + preenchido: o chevron vira ✕ que limpa e reabre.
  bool get _showClear =>
      (widget.hasError || widget.errorText != null) &&
      widget.enabled &&
      _controller.text.isNotEmpty;

  void _handleClear() {
    _controller.clear();
    setState(() => _currentColor = null);
    widget.onChanged('');
    _handle?.open();
  }

  @override
  Widget build(BuildContext context) {
    return AppPickerAnchor(
      width: const AppPickerWidth.fixed(_panelWidth),
      panelPadding: const EdgeInsets.all(AppSpacings.s16),
      trigger: (context, handle) {
        _handle = handle;
        return _buildField(context);
      },
      panel: (context, handle) => AppColorPickerPanel(
        color: _displayColor,
        presets: widget.presets,
        showSuggestedColors: widget.showSuggestedColors,
        onColorChanged: _applyColor,
      ),
    );
  }

  Widget _buildField(BuildContext context) {
    final theme = AppTheme.of(context);

    // Eixos globais: radius (override cru > radiusMode local > global) e style
    // (override do campo > global do tema). O campo é um trigger comum: segue o
    // radius global normalmente (inclusive circular). Só o painel usa containedMode.
    final colors = theme.colorTheme;
    final BorderRadius radius =
        widget.radius ?? theme.radiusTheme.resolve(override: widget.radiusMode);
    final AppStyle style = widget.style ?? theme.styleTheme.style;
    final bool fillStyle =
        style == AppStyle.filled || style == AppStyle.elevated;
    final bool error = widget.hasError || widget.errorText != null;

    // Fill (surface) por estado, igual ao AppInput: desabilitado sutil, erro em
    // fundo danger nos estilos preenchidos, senão a surface `neutralPrimary.s200`.
    final Color? ownFill = !widget.enabled
        ? colors.neutralPrimary.s50
        : (error && fillStyle)
        ? colors.danger.s100
        : null;

    final StyleDecoration deco = resolveStyleDecoration(
      style: style,
      isDark: theme.brightness == AppBrightness.dark,
      outline: _getBorderColor(theme),
      // Derivado, não fixo: hoje resolve para `s200` nas duas marcas e nos
      // dois temas, mas se a rampa de uma marca mudar o campo acompanha em
      // vez de colidir em silêncio com a superfície.
      surfaceContainer: mostSeparatedStop(
        colors.neutralPrimary,
        surfaces: <Color>[colors.surface, colors.surfaceContainer],
        content: colors.onSurface,
      ),
      ownFill: ownFill,
      borderWidth: AppStrokes.m,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacings.s4),
            child: appFieldLabel(
              label: widget.label!,
              style: theme.textTheme.labelLarge.withColor(
                _getLabelColor(theme),
              ),
              info: widget.info,
              infoIconSize: widget.size.iconSize,
            ),
          ),
        ],
        // Borda em PRIMEIRO PLANO (foregroundDecoration) + altura fixa por
        // `size`: a borda não altera o tamanho nem o espaçamento interno. O
        // anchor do overlay é feito pelo AppPickerAnchor externo.
        _withBesideInfo(
          theme,
          Container(
            constraints: BoxConstraints(minHeight: widget.size.height),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: deco.color,
              boxShadow: deco.boxShadow,
              borderRadius: radius,
            ),
            foregroundDecoration: deco.border == null
                ? null
                : BoxDecoration(border: deco.border, borderRadius: radius),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.size.horizontalPadding,
              ),
              child: Row(
                children: [
                  _buildSwatchTrigger(),
                  const SizedBox(width: AppSpacings.s8),
                  AppText(
                    '#',
                    style: theme.textTheme.bodyLarge.withColor(
                      widget.enabled
                          ? theme.colorTheme.neutralPrimary.s400
                          : theme.colorTheme.onSurface.disabled(),
                    ),
                  ),
                  const SizedBox(width: AppSpacings.s2),
                  Expanded(child: _buildHexField(theme)),
                  const SizedBox(width: AppSpacings.s8),
                  _buildChevron(theme),
                ],
              ),
            ),
          ),
        ),
        if (widget.errorText != null || widget.helperText != null) ...<Widget>[
          const SizedBox(height: AppSpacings.s4),
          _buildHelperText(theme),
        ],
      ],
    );
  }

  /// Sem label, o info fica à direita do campo (que sempre tem o chevron como
  /// sufixo), encolhendo o input. Com label, o info vai na row do label.
  Widget _withBesideInfo(AppThemeData theme, Widget field) {
    if (widget.label != null || widget.info == null) return field;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: field),
        const SizedBox(width: AppSpacings.s8),
        appFieldInfo(
          info: widget.info!,
          color: _getLabelColor(theme),
          iconSize: widget.size.iconSize,
        ),
      ],
    );
  }

  Widget _buildSwatchTrigger() {
    final swatch = AppSwatch(
      color: _displayColor,
      shape: widget.shape,
      size: 22,
    );
    if (!widget.enabled) return swatch;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggle,
        child: swatch,
      ),
    );
  }

  Widget _buildChevron(AppThemeData theme) {
    // Erro + preenchido: ✕ que limpa e reabre o overlay (no lugar do chevron).
    if (_showClear) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _handleClear,
          child: AppIcon(
            AppIconToken.close,
            customSize: widget.size.iconSize,
            color: _getIconColor(theme),
          ),
        ),
      );
    }

    final icon = AppAnimatedRotation(
      turns: _isOpen ? 0.5 : 0,
      child: AppIcon(
        AppIconToken.chevronDown,
        customSize: widget.size.iconSize,
        color: _getIconColor(theme),
      ),
    );
    if (!widget.enabled) return icon;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggle,
        child: icon,
      ),
    );
  }

  Widget _buildHexField(AppThemeData theme) {
    final textStyle = theme.textTheme.bodyLarge.withColor(
      widget.enabled
          ? theme.colorTheme.onSurface
          : theme.colorTheme.onSurface.disabled(),
    );
    final selectionControls = appTextSelectionControls;

    final field = Stack(
      children: [
        if (_controller.text.isEmpty && widget.hintText != null)
          Positioned.fill(
            // Dica decorativa sobre área editável: `SelectionContainer.disabled`
            // pelo mesmo motivo detalhado em `molecules/input/app_input.dart` —
            // na web o `SelectableRegion` de um `AppText` monta um platform view
            // DOM que cancela o `mousedown` e o `IgnorePointer` não o alcança.
            child: SelectionContainer.disabled(
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    widget.hintText!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium.withColor(
                      theme.colorTheme.neutralPrimary.s400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        EditableText(
          key: editableTextKey,
          // Delega o tratamento de ponteiro ao TextSelectionGestureDetector
          // (igual ao TextField); habilita duplo/triplo-clique de seleção.
          rendererIgnoresPointer: true,
          controller: _controller,
          focusNode: _focusNode,
          style: textStyle,
          cursorColor: readableStopOn(
            theme.colorTheme.primary,
            theme.colorTheme.surface,
          ),
          backgroundCursorColor: readableStopOn(
            theme.colorTheme.primary,
            theme.colorTheme.surface,
          ),
          cursorRadius: const Radius.circular(AppRadius.xs),
          cursorOpacityAnimates: true,
          cursorWidth: 2,
          cursorHeight: textStyle.fontSize,
          selectionColor: theme.colorTheme.primary.s300.withValues(alpha: 0.34),
          selectionControls: selectionControls,
          maxLines: 1,
          readOnly: !widget.enabled,
          showCursor: widget.enabled,
          enableInteractiveSelection: widget.enabled,
          textAlign: TextAlign.start,
          textDirection: TextDirection.ltr,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.characters,
          keyboardAppearance: theme.brightness == AppBrightness.dark
              ? Brightness.dark
              : Brightness.light,
          scrollPadding: EdgeInsets.zero,
          inputFormatters: hexFieldFormatters(),
          onChanged: _onTextChanged,
        ),
      ],
    );

    if (!widget.enabled) return field;

    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: buildTextSelectionGestures(child: field),
    );
  }

  Widget _buildHelperText(AppThemeData theme) {
    final text = widget.errorText ?? widget.helperText;
    if (text == null) return const SizedBox.shrink();

    return AppText(
      text,
      style: widget.hasError || widget.errorText != null
          ? theme.textTheme.labelMedium.withColor(theme.colorTheme.danger)
          : theme.textTheme.bodySmall.withColor(
              theme.colorTheme.neutralPrimary,
            ),
    );
  }

  Color _getBorderColor(AppThemeData theme) {
    if (!widget.enabled) return theme.colorTheme.onSurface.disabled();
    if (widget.hasError || widget.errorText != null) {
      return theme.colorTheme.danger;
    }
    if (_isOpen || _isFocused) {
      return readableStopOn(theme.colorTheme.primary, theme.colorTheme.surface);
    }
    return theme.colorTheme.neutralPrimary;
  }

  Color _getLabelColor(AppThemeData theme) {
    if (!widget.enabled) return theme.colorTheme.onSurface.disabled();
    if (widget.hasError || widget.errorText != null) {
      return theme.colorTheme.danger;
    }
    if (_isOpen || _isFocused) {
      return readableStopOn(theme.colorTheme.primary, theme.colorTheme.surface);
    }
    return theme.colorTheme.onSurface;
  }

  Color _getIconColor(AppThemeData theme) {
    if (!widget.enabled) return theme.colorTheme.onSurface.customOpacity(.3);
    if (widget.hasError || widget.errorText != null) {
      return theme.colorTheme.danger;
    }
    if (_isOpen || _isFocused) {
      return readableStopOn(theme.colorTheme.primary, theme.colorTheme.surface);
    }
    return theme.colorTheme.onSurface;
  }
}
