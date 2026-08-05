import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'resize_gutter.dart';

/// Em qual borda do painel fica a alça de arraste.
enum AppResizeEdge {
  /// Borda inicial — esquerda no LTR. Para painéis ancorados à direita.
  start,

  /// Borda final — direita no LTR. Para painéis ancorados à esquerda.
  end,
}

/// Um painel de largura ajustável pelo usuário, com uma alça de arraste em uma
/// das bordas.
///
/// É o irmão de um painel só do [AppResizableSplit]: quando não há dois painéis
/// para dividir — o caso do slot `aside` do `AppShell`, que precisa de altura
/// total ao lado do header — o split não serve, mas a afordância é a mesma
/// (as duas usam a mesma calha internamente).
///
/// ## Largura em px, não em fração
///
/// Diferente do split, aqui a medida é **absoluta**: o que se quer expressar é
/// "este painel tem um piso de 380px e o usuário escolhe daí para cima", não
/// uma proporção da janela. Quem encolhe é o vizinho, que fica com o resto.
///
/// ## [maxWidth] é obrigatório e vem de quem chama
///
/// O componente **não** consegue descobrir o teto sozinho: como filho não
/// flexível de um `Row`, ele recebe constraint de eixo principal *unbounded* —
/// um `LayoutBuilder` interno leria `infinity`. Calcule o teto na origem (ex.:
/// `MediaQuery.sizeOf(context).width / 2`) e passe aqui.
///
/// A largura é reclampada a cada build, então diminuir [maxWidth] (janela
/// encolhendo) acomoda um valor restaurado grande demais em vez de estourar.
///
/// Persistência é responsabilidade do chamador (o DS não depende de storage):
/// passe o valor restaurado em [initialWidth] e salve os novos por
/// [onWidthChanged]. Duplo-toque na alça volta para [initialWidth].
///
/// Precisa de **altura limitada** (é esticado no eixo cruzado), como o split.
///
/// Example:
/// ```dart
/// AppResizablePanel(
///   initialWidth: restoredWidth ?? 380,
///   minWidth: 380,
///   maxWidth: MediaQuery.sizeOf(context).width / 2,
///   onWidthChanged: (w) => storage.write('shell.assistant.width', w),
///   child: assistantPanel,
/// )
/// ```
final class AppResizablePanel extends StatefulWidget {
  const AppResizablePanel({
    required this.child,
    required this.initialWidth,
    required this.maxWidth,
    this.minWidth = 0,
    this.edge = AppResizeEdge.start,
    this.thickness = kResizeGutterThickness,
    this.handleLength = kResizeHandleLength,
    this.handleThickness = kResizeHandleThickness,
    this.tooltip = 'Redimensionar',
    this.onWidthChanged,
    super.key,
  }) : assert(initialWidth >= 0, 'initialWidth must not be negative'),
       assert(minWidth >= 0, 'minWidth must not be negative');

  /// O conteúdo do painel.
  final Widget child;

  /// Largura inicial (px) — o chamador restaura a persistência e passa aqui.
  /// Também é o alvo do duplo-toque.
  final double initialWidth;

  /// Teto da largura (px). Ver a nota da classe: é do chamador.
  final double maxWidth;

  /// Piso da largura (px).
  final double minWidth;

  /// Borda onde fica a alça.
  final AppResizeEdge edge;

  /// Lado curto da calha — sua largura. Também é a área de hover/hit.
  final double thickness;

  /// Comprimento da alça (ao longo da calha).
  final double handleLength;

  /// Espessura da alça (atravessando a calha).
  final double handleThickness;

  /// Tooltip no hover da alça. `null` desliga.
  final String? tooltip;

  /// Chamado com a nova largura a cada arraste (e no reset).
  final ValueChanged<double>? onWidthChanged;

  @override
  State<AppResizablePanel> createState() => _AppResizablePanelState();
}

class _AppResizablePanelState extends State<AppResizablePanel> {
  double? _width;

  /// Mantém a largura entre o piso e o teto. Quando os limites se cruzam
  /// (janela absurdamente estreita), o piso vence: um painel espremido a zero
  /// sumiria sem o usuário ter pedido.
  double _clampWidth(double width) {
    final double hi = math.max(widget.minWidth, widget.maxWidth);
    return width.clamp(widget.minWidth, hi);
  }

  void _onDragDelta(double delta, double currentWidth, bool isLtr) {
    // Arrastar "para fora" do painel cresce. Numa alça à esquerda (LTR), fora
    // é o -x; no RTL, ou com a alça à direita, o sinal se inverte.
    final bool growsOnNegative = (widget.edge == AppResizeEdge.start) == isLtr;
    final double signedDelta = growsOnNegative ? -delta : delta;
    final double next = _clampWidth(currentWidth + signedDelta);
    if (next == currentWidth) return;
    setState(() => _width = next);
    widget.onWidthChanged?.call(next);
  }

  void _onReset() {
    final double reset = _clampWidth(widget.initialWidth);
    setState(() => _width = reset);
    widget.onWidthChanged?.call(reset);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = Directionality.of(context) == TextDirection.ltr;
    // Reclampa a cada build: é o que acomoda uma largura restaurada maior que
    // o teto atual (janela menor do que na sessão em que foi salva).
    final double width = _clampWidth(_width ?? widget.initialWidth);

    // RepaintBoundary isola o conteúdo: hover na alça (ou o próprio arraste)
    // deixa de repintar o painel inteiro junto.
    final gutter = RepaintBoundary(
      child: ResizeGutter(
        direction: Axis.horizontal,
        onDragDelta: (delta) => _onDragDelta(delta, width, isLtr),
        onReset: _onReset,
        thickness: widget.thickness,
        handleLength: widget.handleLength,
        handleThickness: widget.handleThickness,
        tooltip: widget.tooltip,
      ),
    );
    final panel = SizedBox(
      width: width,
      child: RepaintBoundary(child: widget.child),
    );

    return Row(
      // `min` porque o uso típico é como filho não flexível de outro Row, que
      // dá constraint horizontal infinita — com `max` isso estouraria.
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.edge == AppResizeEdge.start
          ? <Widget>[gutter, panel]
          : <Widget>[panel, gutter],
    );
  }
}
