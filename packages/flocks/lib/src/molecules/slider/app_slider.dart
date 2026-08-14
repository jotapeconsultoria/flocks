import 'dart:math' as math;

import 'package:flutter/services.dart'
    show KeyEvent, KeyUpEvent, LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/swatch_generator.dart';

/// Controle deslizante **horizontal** para escolher um valor num intervalo.
///
/// Idioma controlado: [value] + [onChanged], estado no chamador (o molde do
/// [AppRating]). `onChanged: null` desabilita — o parâmetro é obrigatório para
/// a decisão ser explícita, como no `AppButton.onPressed`.
///
/// [step] quantiza em **unidades do domínio** (`1.0` = inteiros) — e não em
/// `divisions` à la Material: o caso de uso é "de 1 em 1 msg/min", e
/// `divisions = (max - min) / step` é aritmética que todo call site erraria.
///
/// [formatValue] é UMA fonte de formatação para o pixel ([showValue]) e para o
/// leitor de tela (value/increased/decreased) — um `semanticFormatter`
/// separado criaria exatamente a divergência que a Regra 8 existe para
/// impedir. O rótulo visível é inline e persistente; sem tooltip flutuante
/// (overlay é indeterminismo de golden e custo de motion que este controle não
/// precisa pagar).
///
/// Acessível de fábrica: nó `slider` com value/increased/decreased e
/// onIncrease/onDecrease; setas do teclado (espelhadas em RTL), Home/End; alvo
/// de toque com altura mínima de 48px (o trilho continua fino — a área de
/// toque é que é generosa). Desabilitado MANTÉM o nó e anuncia o estado, como
/// o AppButton.
///
/// ```dart
/// AppSlider(
///   value: ritmo,
///   min: 1,
///   max: 60,
///   step: 1,
///   showValue: true,
///   formatValue: (v) => '${v.round()}/min',
///   semanticLabel: 'Ritmo de envio',
///   onChanged: (v) => setState(() => ritmo = v),
/// )
/// ```
final class AppSlider extends StatefulWidget {
  /// Cria um [AppSlider].
  const AppSlider({
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.step,
    this.onChangeEnd,
    this.formatValue,
    this.showValue = false,
    this.semanticLabel,
    this.color,
    this.trackThickness = AppSizes.s4,
    this.thumbSize = AppSizes.s16,
    super.key,
  }) : assert(min < max, 'min deve ser < max'),
       assert(value >= min && value <= max, 'value deve estar em [min, max]'),
       assert(step == null || step > 0, 'step deve ser > 0');

  /// Valor atual, em unidades do domínio (ex.: msg/min). Controlado.
  final double value;

  /// Notifica a mudança contínua (durante o arraste). `null` = desabilitado.
  final ValueChanged<double>? onChanged;

  /// Extremos do intervalo, em unidades do domínio.
  final double min;

  /// Ver [min].
  final double max;

  /// Quantização em unidades do domínio (`1.0` = inteiros). `null` = contínuo.
  final double? step;

  /// Commit no soltar (fim do pan) e após cada passo de teclado — para o
  /// chamador que persiste o valor e não quer fazê-lo a cada pixel.
  final ValueChanged<double>? onChangeEnd;

  /// Formata o valor para humanos ("42/min"). `null` = numérico.
  final String Function(double value)? formatValue;

  /// Exibe o rótulo de valor à direita do trilho (`labelMedium`), inline.
  final bool showValue;

  /// Nome do controle para o leitor de tela (ex.: 'Ritmo de envio').
  final String? semanticLabel;

  /// Cor do acento (trilho ativo + polegar). Default:
  /// `readableStopOn(colors.primary, colors.surface)` — legível nos 2 temas.
  final Color? color;

  /// Espessura do trilho. Default [AppSizes.s4].
  final double trackThickness;

  /// Diâmetro do polegar. Default [AppSizes.s16]; cresce +4px no arraste.
  final double thumbSize;

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  bool _dragging = false;

  /// Último valor emitido no gesto corrente — o que o [AppSlider.onChangeEnd]
  /// entrega no soltar (o `widget.value` pode não ter voltado ainda: o
  /// componente é controlado e o rebuild é do chamador).
  double? _pending;

  bool get _interactive => widget.onChanged != null;
  double get _span => widget.max - widget.min;
  double get _keyStep => widget.step ?? _span / 20;

  double _quantize(double v) {
    double result = v;
    if (widget.step case final double s) {
      result = widget.min + ((v - widget.min) / s).round() * s;
    }
    return result.clamp(widget.min, widget.max);
  }

  void _emit(double v) {
    final double q = _quantize(v);
    _pending = q;
    widget.onChanged?.call(q);
  }

  void _commit() {
    final double v = _pending ?? widget.value;
    _pending = null;
    widget.onChangeEnd?.call(v);
  }

  void _step(double direction) {
    if (!_interactive) return;
    _emit(widget.value + direction * _keyStep);
    _commit();
  }

  double _valueAtDx(double dx, double width, TextDirection dir) {
    double t = (dx / width).clamp(0.0, 1.0);
    if (dir == TextDirection.rtl) t = 1 - t;
    return widget.min + t * _span;
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_interactive || event is KeyUpEvent) return KeyEventResult.ignored;
    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowRight:
        _step(rtl ? -1 : 1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft:
        _step(rtl ? 1 : -1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _step(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowDown:
        _step(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.home:
        _emit(widget.min);
        _commit();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.end:
        _emit(widget.max);
        _commit();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  String _fmt(double v) => widget.formatValue?.call(v) ?? _num(v);

  static String _num(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final Color accent =
        widget.color ?? readableStopOn(colors.primary, colors.surface);
    // Desabilitado esmaece tudo pelo mesmo fator — o "muted" do pacote.
    final double alpha = _interactive ? 1.0 : 0.38;
    final Color active = accent.customOpacity(alpha);
    final Color track = accent.customOpacity(0.18 * alpha);

    final double t = _span == 0 ? 0 : (widget.value - widget.min) / _span;
    final double height = math.max(
      AppSizes.s48,
      widget.thumbSize + AppSpacings.s8,
    );

    final Widget slider = SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          assert(
            constraints.hasBoundedWidth,
            'AppSlider precisa de largura limitada (Expanded/SizedBox) — num '
            'Row cru ele não tem como medir o trilho.',
          );
          final double width = constraints.maxWidth;
          final TextDirection dir = Directionality.of(context);

          final Widget rail = Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              // Trilho inativo, de ponta a ponta.
              Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: track,
                    // Meio-cabo do próprio trilho: não é canto de superfície
                    // que o eixo de forma governa — é a espessura da linha.
                    borderRadius: BorderRadius.circular(
                      widget.trackThickness / 2,
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: widget.trackThickness,
                  ),
                ),
              ),
              // Trilho ativo, do início ao valor.
              Center(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FractionallySizedBox(
                    widthFactor: t,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: active,
                        borderRadius: BorderRadius.circular(
                          widget.trackThickness / 2,
                        ),
                      ),
                      child: SizedBox(height: widget.trackThickness),
                    ),
                  ),
                ),
              ),
              // Polegar: -1..1 na direção de leitura, sempre inteiro dentro.
              Align(
                alignment: AlignmentDirectional(t * 2 - 1, 0),
                child: _thumb(context, active),
              ),
            ],
          );

          if (!_interactive) return rail;

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (DragDownDetails d) {
                setState(() => _dragging = true);
                _emit(_valueAtDx(d.localPosition.dx, width, dir));
              },
              onPanUpdate: (DragUpdateDetails d) =>
                  _emit(_valueAtDx(d.localPosition.dx, width, dir)),
              onPanEnd: (_) {
                setState(() => _dragging = false);
                _commit();
              },
              onPanCancel: () {
                setState(() => _dragging = false);
                _commit();
              },
              child: rail,
            ),
          );
        },
      ),
    );

    final Widget content = widget.showValue
        ? Row(
            children: <Widget>[
              Expanded(child: slider),
              const SizedBox(width: AppSpacings.s8),
              // Decorativo: o nó slider já anuncia o valor — repetir num Text
              // faria o leitor dizer o número duas vezes.
              ExcludeSemantics(
                child: AppText(
                  _fmt(widget.value),
                  style: theme.textTheme.labelMedium.copyWith(
                    color: colors.onSurface.customOpacity(alpha),
                  ),
                ),
              ),
            ],
          )
        : slider;

    return Semantics(
      container: true,
      slider: true,
      enabled: _interactive,
      label: widget.semanticLabel,
      value: _fmt(widget.value),
      increasedValue: _fmt(_quantize(widget.value + _keyStep)),
      decreasedValue: _fmt(_quantize(widget.value - _keyStep)),
      onIncrease: _interactive ? () => _step(1) : null,
      onDecrease: _interactive ? () => _step(-1) : null,
      child: Focus(
        canRequestFocus: _interactive,
        skipTraversal: !_interactive,
        onKeyEvent: _onKey,
        child: content,
      ),
    );
  }

  /// O polegar circular; cresce +4px no arraste e ganha o anel de foco SEM
  /// duração (o anel sobrevive a reduce-motion — a Regra 10 encurta transição,
  /// nunca apaga estado).
  Widget _thumb(BuildContext context, Color fill) {
    final AppColorTheme colors = AppTheme.of(context).colorTheme;
    final double side = widget.thumbSize + (_dragging ? 4 : 0);

    final Widget core = AnimatedContainer(
      duration: AppMotion.resolve(context, AppDurations.fast),
      curve: AppCurves.decelerate,
      width: side,
      height: side,
      decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
    );
    if (!_interactive) return core;

    // `Focus.of` registra dependência: o Builder rebuilda sozinho quando o
    // foco muda — nenhum campo `_focused` (Regra 1).
    return Builder(
      builder: (BuildContext ctx) {
        final bool focused = Focus.of(ctx).hasFocus;
        if (!focused) return core;
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.focusRing, width: AppStrokes.m),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppStrokes.m),
            child: core,
          ),
        );
      },
    );
  }
}
