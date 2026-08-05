import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../../tokens/swatch_generator.dart';
import '../card/anchored_overlay.dart';
import '../card/app_overlay_panel.dart';

/// Estratégia de largura do painel de um [AppPickerAnchor].
sealed class AppPickerWidth {
  const AppPickerWidth();

  /// Largura MÍNIMA do painel = a do trigger (nunca menor que [min]); o painel
  /// **cresce** com o conteúdo (ex.: calendário sob text scale alto).
  const factory AppPickerWidth.matchTrigger({double min}) = _MatchTriggerWidth;

  /// Largura fixa do painel, em pixels lógicos.
  const factory AppPickerWidth.fixed(double width) = _FixedWidth;
}

class _MatchTriggerWidth extends AppPickerWidth {
  const _MatchTriggerWidth({this.min = 0});
  final double min;
}

class _FixedWidth extends AppPickerWidth {
  const _FixedWidth(this.width);
  final double width;
}

/// Controles do overlay entregues aos builders de [AppPickerAnchor.trigger] e
/// [AppPickerAnchor.panel].
class AppPickerHandle {
  const AppPickerHandle._(this._state);

  final _AppPickerAnchorState _state;

  /// Abre o painel ancorado ao trigger (no-op se já aberto).
  void open() => _state._open();

  /// Fecha o painel (idempotente).
  void close() => _state._controller.close();

  /// Abre se fechado; fecha se aberto.
  void toggle() => isOpen ? close() : open();

  /// Se o painel está aberto.
  bool get isOpen => _state._controller.isOpen;

  /// Reconstrói o painel aberto — para painéis que refletem ao vivo o estado do
  /// trigger (ex.: hex digitado, data escolhida antes da hora).
  void rebuild() => _state._controller.rebuild();
}

/// Âncora genérica de "picker": um [trigger] (qualquer widget) que abre um
/// [panel] flutuante ancorado logo abaixo, num [AppCard] elevado, fechando ao
/// clicar fora / `Esc`.
///
/// É a máquina de overlay dos pickers do DS, desacoplada do input — use no
/// `AppInput` (como os `*PickerInput`) **ou em qualquer outro widget** (um
/// botão, um chip…). Ambos os builders recebem um [AppPickerHandle] para
/// abrir/fechar/rebuildar.
///
/// ```dart
/// AppPickerAnchor(
///   width: const AppPickerWidth.matchTrigger(min: 300),
///   trigger: (context, h) => AppButton(label: 'Data', onPressed: h.open),
///   panel: (context, h) => AppDatePicker(
///     onDateSelected: (d) { setState(() => _date = d); h.close(); },
///   ),
/// )
/// ```
class AppPickerAnchor extends StatefulWidget {
  /// Cria um [AppPickerAnchor].
  const AppPickerAnchor({
    required this.trigger,
    required this.panel,
    this.width = const AppPickerWidth.matchTrigger(),
    this.placement = AppOverlayPlacement.bottomStart,
    this.panelStyle = AppStyle.elevated,
    this.panelGlass,
    this.panelAccentColor,
    this.panelPadding = const EdgeInsets.all(AppSpacings.s8),
    super.key,
  });

  /// Constrói o trigger. Envolvido pela âncora ([CompositedTransformTarget] +
  /// [TapRegion]); chame `handle.open/close/toggle` a partir dele.
  final Widget Function(BuildContext context, AppPickerHandle handle) trigger;

  /// Constrói o conteúdo do painel (ex.: `AppDatePicker`), dentro do [AppCard].
  final Widget Function(BuildContext context, AppPickerHandle handle) panel;

  /// Largura do painel. Default: casa com o trigger.
  final AppPickerWidth width;

  /// Posição do painel relativa ao trigger.
  final AppOverlayPlacement placement;

  /// Eixo [AppStyle] do painel no render **não-glass**. Default
  /// [AppStyle.elevated].
  final AppStyle panelStyle;

  /// Override do eixo glass só deste painel. `null` segue o global
  /// (`theme.glassTheme.enabled`).
  final bool? panelGlass;

  /// Cor de acento da borda do painel (render não-glass). Default: um stop
  /// legível do `secondary` sobre a superfície (`readableStopOn`) — contrasta em
  /// claro/escuro nas duas marcas.
  final Color? panelAccentColor;

  /// Padding interno do painel. Default `EdgeInsets.all(s8)`; passe
  /// `EdgeInsets.zero` quando o painel já traz o próprio padding.
  final EdgeInsetsGeometry panelPadding;

  @override
  State<AppPickerAnchor> createState() => _AppPickerAnchorState();
}

class _AppPickerAnchorState extends State<AppPickerAnchor> {
  late final AnchoredOverlayController _controller;
  late final AppPickerHandle _handle;

  @override
  void initState() {
    super.initState();
    _controller = AnchoredOverlayController();
    // Rebuilda o trigger quando abre/fecha (reflete `handle.isOpen`).
    _controller.addListener(_onOverlayChanged);
    _handle = AppPickerHandle._(this);
  }

  void _onOverlayChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onOverlayChanged);
    _controller.dispose();
    super.dispose();
  }

  void _open() {
    if (!mounted) return;
    _controller.open(
      context,
      placement: widget.placement,
      // Pickers têm o próprio campo/foco → não roubar o foco ao abrir.
      autofocus: false,
      builder: _buildPanel,
    );
  }

  /// Largura resolvida do painel (null = dimensiona pelo conteúdo).
  Widget _buildPanel(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final Widget card = AppOverlayPanel(
      style: widget.panelStyle,
      glass: widget.panelGlass,
      accentColor:
          widget.panelAccentColor ??
          readableStopOn(theme.colorTheme.secondary, theme.colorTheme.surface),
      padding: widget.panelPadding,
      child: widget.panel(context, _handle),
    );
    final AppPickerWidth w = widget.width;
    if (w is _FixedWidth) {
      return SizedBox(width: w.width, child: card);
    }
    if (w is _MatchTriggerWidth) {
      // `leaderSize` vem do trigger via LayerLink (dispensa GlobalKey). É uma
      // largura MÍNIMA (nunca menor que o trigger/`min`), mas o painel CRESCE
      // com o conteúdo — ex.: o calendário sob text scale alto fica mais largo.
      final double min = math.max(
        _controller.link.leaderSize?.width ?? w.min,
        w.min,
      );
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: min),
        child: card,
      );
    }
    return card;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _controller.link,
      // Mesmo `groupId` do painel → tocar no trigger não conta como "fora".
      child: TapRegion(
        groupId: _controller.groupId,
        child: widget.trigger(context, _handle),
      ),
    );
  }
}
