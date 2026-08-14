import 'package:flutter/services.dart' show TextCapitalization;
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/selection/app_text_selection_controls.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../interactive/interactive.dart';
import 'hex_field_formatters.dart';

/// Stops do espectro de matiz (hue) usados na barra do picker.
const _hueSpectrum = <Color>[
  Color(0xFFFF0000), // 0   vermelho
  Color(0xFFFFFF00), // 60  amarelo
  Color(0xFF00FF00), // 120 verde
  Color(0xFF00FFFF), // 180 ciano
  Color(0xFF0000FF), // 240 azul
  Color(0xFFFF00FF), // 300 magenta
  Color(0xFFFF0000), // 360 vermelho
];

/// Paleta sugerida (cores de mapa bem distinguíveis) usada por padrão.
const _defaultPresets = <Color>[
  Color(0xFFE53935), // vermelho
  Color(0xFFFF5B04), // laranja (brand)
  Color(0xFFFB8C00), // âmbar
  Color(0xFFFDD835), // amarelo
  Color(0xFF43A047), // verde
  Color(0xFF00897B), // teal
  Color(0xFF00ACC1), // ciano
  Color(0xFF1E88E5), // azul
  Color(0xFF3949AB), // índigo
  Color(0xFF8E24AA), // roxo
  Color(0xFFD81B60), // rosa
  Color(0xFF6D4C41), // marrom
  Color(0xFF757575), // cinza
  Color(0xFF000000), // preto
];

/// Painel visual de seleção de cor (HSV) — sem Material nem dependências.
///
/// Compõe uma área de saturação/brilho, uma barra de matiz e uma linha de
/// presets. É o conteúdo do overlay do [AppColorPickerInput], mas é público
/// para reuso (ex.: dentro de um diálogo).
final class AppColorPickerPanel extends StatefulWidget {
  const AppColorPickerPanel({
    required this.color,
    required this.onColorChanged,
    this.presets,
    this.showSuggestedColors = true,
    this.showSpectrum = true,
    super.key,
  }) : assert(
         showSpectrum || showSuggestedColors,
         'AppColorPickerPanel sem espectro e sem sugestões não tem o que '
         'mostrar.',
       );

  /// Cor inicial exibida.
  final Color color;

  /// Disparado a cada interação (arraste, clique na área ou em um preset).
  final ValueChanged<Color> onColorChanged;

  /// Presets exibidos; quando null usa a paleta padrão.
  final List<Color>? presets;

  /// Exibe a seção "Cores sugeridas" (presets). Default `true`.
  final bool showSuggestedColors;

  /// Exibe o espectro de edição livre — a área de saturação/brilho, a barra
  /// de matiz E o preview com hex (o hex pertence à edição livre). `false` =
  /// modo só-presets: o seletor de paleta fixa das etiquetas. Default `true`,
  /// o painel de sempre. Pelo menos um entre este e [showSuggestedColors]
  /// precisa estar ligado (assert).
  final bool showSpectrum;

  @override
  State<AppColorPickerPanel> createState() => _AppColorPickerPanelState();
}

class _AppColorPickerPanelState extends State<AppColorPickerPanel> {
  static const _satValHeight = 160.0;
  static const _hueHeight = 16.0;
  static const _thumbSize = 16.0;

  late HSVColor _hsv;

  /// Edição inline do hex na linha de preview (ativada pelo lápis).
  bool _editingHex = false;
  late final TextEditingController _hexController;
  late final FocusNode _hexFocus;

  static String _stripHash(String? hex) =>
      (hex ?? '').trim().replaceFirst('#', '');

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.color);
    _hexController = TextEditingController();
    _hexFocus = FocusNode()..addListener(_onHexFocusChange);
  }

  @override
  void didUpdateWidget(AppColorPickerPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ressincroniza com uma mudança externa, sem zerar a matiz quando a cor
    // resultante é a mesma (ex.: preto/cinza, onde a matiz é ambígua).
    if (widget.color != oldWidget.color &&
        colorToHex(widget.color) != colorToHex(_hsv.toColor())) {
      _hsv = HSVColor.fromColor(widget.color);
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    _hexFocus
      ..removeListener(_onHexFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onHexFocusChange() {
    // Sai do modo edição ao perder o foco (blur), voltando ao texto read-only.
    if (!_hexFocus.hasFocus && _editingHex) {
      setState(() => _editingHex = false);
    }
  }

  /// Emite [next]; [fromHexField] indica que a origem é o próprio campo de
  /// texto — nesse caso não reescrevemos o controller (evita brigar o cursor).
  void _emit(HSVColor next, {bool fromHexField = false}) {
    setState(() => _hsv = next);
    if (_editingHex && !fromHexField) {
      final digits = _stripHash(colorToHex(next.toColor()));
      _hexController.value = TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }
    widget.onColorChanged(next.toColor());
  }

  void _startEditingHex() {
    final digits = _stripHash(colorToHex(_hsv.toColor()));
    _hexController.value = TextEditingValue(
      text: digits,
      selection: TextSelection(baseOffset: 0, extentOffset: digits.length),
    );
    setState(() => _editingHex = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _hexFocus.requestFocus();
    });
  }

  void _onHexTextChanged(String text) {
    final digits = text.trim();
    if (digits.length != 6) return;
    final parsed = parseHexColor('#$digits');
    if (parsed != null) {
      _emit(HSVColor.fromColor(parsed), fromHexField: true);
    }
  }

  void _updateSatVal(Offset pos, double width) {
    final sat = (pos.dx / width).clamp(0.0, 1.0);
    final val = (1 - pos.dy / _satValHeight).clamp(0.0, 1.0);
    _emit(_hsv.withSaturation(sat).withValue(val));
  }

  void _updateHue(double dx, double width) {
    final hue = (dx / width).clamp(0.0, 1.0) * 360;
    _emit(_hsv.withHue(hue));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final presets = widget.presets ?? _defaultPresets;
    final currentColor = _hsv.toColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showSpectrum) ...[
          _buildSatValArea(theme),
          const SizedBox(height: AppSpacings.s8),
          _buildHueSlider(theme),
          const SizedBox(height: AppSpacings.s16),
          _buildPreview(theme, currentColor),
        ],
        if (widget.showSuggestedColors) ...[
          // O respiro só existe quando há espectro acima — só-presets abre
          // direto no rótulo, sem vão órfão.
          if (widget.showSpectrum) const SizedBox(height: AppSpacings.s16),
          AppText(
            'Cores sugeridas',
            style: theme.textTheme.labelMedium.withColor(
              theme.colorTheme.neutralPrimary,
            ),
          ),
          const SizedBox(height: AppSpacings.s8),
          _buildPresets(theme, presets, currentColor),
        ],
      ],
    );
  }

  Widget _buildSatValArea(AppThemeData theme) {
    final hueColor = HSVColor.fromAHSV(1, _hsv.hue, 1, 1).toColor();
    // circular/padrão → redondo: a área SV é grande e viraria um blob.
    final borderRadius = theme.radiusTheme.resolve(
      override: theme.radiusTheme.containedMode(),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final thumbLeft = (_hsv.saturation * width - _thumbSize / 2).clamp(
          0.0,
          width - _thumbSize,
        );
        final thumbTop = ((1 - _hsv.value) * _satValHeight - _thumbSize / 2)
            .clamp(0.0, _satValHeight - _thumbSize);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (d) => _updateSatVal(d.localPosition, width),
          onPanUpdate: (d) => _updateSatVal(d.localPosition, width),
          child: SizedBox(
            width: width,
            height: _satValHeight,
            child: Stack(
              children: [
                // Matiz base.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: hueColor,
                      borderRadius: borderRadius,
                    ),
                  ),
                ),
                // Saturação: branco -> transparente (horizontal).
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xFFFFFFFF),
                          const Color(0xFFFFFFFF).withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                // Brilho: transparente -> preto (vertical).
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF000000).withValues(alpha: 0),
                          const Color(0xFF000000),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: thumbLeft,
                  top: thumbTop,
                  child: _Thumb(fill: _hsv.toColor()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHueSlider(AppThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final thumbLeft = (_hsv.hue / 360 * width - _thumbSize / 2).clamp(
          0.0,
          width - _thumbSize,
        );
        final thumbFill = HSVColor.fromAHSV(1, _hsv.hue, 1, 1).toColor();

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (d) => _updateHue(d.localPosition.dx, width),
          onPanUpdate: (d) => _updateHue(d.localPosition.dx, width),
          child: SizedBox(
            width: width,
            height: _thumbSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: theme.radiusTheme.resolve(),
                    gradient: const LinearGradient(colors: _hueSpectrum),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: _hueHeight,
                  ),
                ),
                Positioned(
                  left: thumbLeft,
                  child: _Thumb(fill: thumbFill),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreview(AppThemeData theme, Color color) {
    return Row(
      children: [
        AppSwatch(color: color, size: 24),
        const SizedBox(width: AppSpacings.s8),
        Expanded(
          child: _editingHex
              ? _buildHexEditor(theme)
              : AppText(
                  colorToHex(color),
                  style: theme.textTheme.bodyLarge.withColor(
                    theme.colorTheme.onSurface,
                  ),
                ),
        ),
        if (!_editingHex) ...[
          const SizedBox(width: AppSpacings.s8),
          AppInteraction(
            tooltip: 'Editar',
            padding: const EdgeInsets.all(AppSpacings.s4),
            onTap: _startEditingHex,
            child: AppIcon(
              AppIconToken.pencil,
              size: AppIconSize.s,
              color: theme.colorTheme.neutralPrimary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHexEditor(AppThemeData theme) {
    final textStyle = theme.textTheme.bodyLarge.withColor(
      theme.colorTheme.onSurface,
    );
    final selectionControls = appTextSelectionControls;
    final accent = readableStopOn(
      theme.colorTheme.primary,
      theme.colorTheme.surface,
    );

    return Row(
      children: [
        AppText(
          '#',
          style: theme.textTheme.bodyLarge.withColor(
            theme.colorTheme.neutralPrimary.s400,
          ),
        ),
        const SizedBox(width: AppSpacings.s2),
        Expanded(
          child: EditableText(
            controller: _hexController,
            focusNode: _hexFocus,
            style: textStyle,
            cursorColor: accent,
            backgroundCursorColor: accent,
            cursorRadius: const Radius.circular(AppRadius.xs),
            cursorOpacityAnimates: true,
            cursorWidth: 2,
            cursorHeight: textStyle.fontSize,
            selectionColor: theme.colorTheme.primary.s300.withValues(
              alpha: 0.34,
            ),
            selectionControls: selectionControls,
            maxLines: 1,
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
            onChanged: _onHexTextChanged,
            onSubmitted: (_) => _hexFocus.unfocus(),
          ),
        ),
      ],
    );
  }

  Widget _buildPresets(
    AppThemeData theme,
    List<Color> presets,
    Color currentColor,
  ) {
    final currentHex = colorToHex(currentColor);

    return Wrap(
      spacing: AppSpacings.s8,
      runSpacing: AppSpacings.s8,
      children: [
        for (final preset in presets)
          _PresetButton(
            color: preset,
            selected: colorToHex(preset) == currentHex,
            onTap: () => _emit(HSVColor.fromColor(preset)),
          ),
      ],
    );
  }
}

/// Marcador (thumb) circular usado na área SV e na barra de matiz.
class _Thumb extends StatelessWidget {
  const _Thumb({required this.fill});

  final Color fill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            color: Color(0x40000000),
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

/// Botão de preset com destaque quando selecionado.
class _PresetButton extends StatelessWidget {
  const _PresetButton({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    // Uma amostra é um quadrado colorido e nada mais: sem rótulo o leitor de
    // tela anuncia um alvo sem nome, e a única informação que ela carrega — a
    // COR — é justamente a que não se ouve. O hex é o nome que existe.
    // `toggle` mutuamente exclusivo, e não `button`, porque exatamente uma
    // amostra é a atual: sem isso o leitor lê doze alvos idênticos.
    return AppSemantics.toggle(
      value: selected,
      mutuallyExclusive: true,
      label: colorToHex(color),
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AppSwatch(
            color: color,
            size: 22,
            borderColor: selected
                ? readableStopOn(
                    theme.colorTheme.secondary,
                    theme.colorTheme.surface,
                  )
                : theme.colorTheme.neutralPrimary.s100,
          ),
        ),
      ),
    );
  }
}
