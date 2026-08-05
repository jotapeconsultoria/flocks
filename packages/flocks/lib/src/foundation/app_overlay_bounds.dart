import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Região a que um modal **local** se confina.
///
/// ## O problema
///
/// Um dialog cobre a tela inteira e escurece tudo. Isso está certo quando a
/// decisão é global ("sair da conta?"), e errado quando ela é local: configurar
/// as colunas de *uma* tabela apaga o rail, o assistente e as outras abas para
/// falar de um pedaço da tela.
///
/// ## Como resolve
///
/// Quem monta a área de trabalho embrulha o conteúdo num
/// [AppOverlayBoundsRegion]. Os modais **não recebem parâmetro nenhum**: quem
/// os abre a partir de um contexto dentro da região se confina a ela; quem
/// abre de fora (o assistente, a busca global do header) não encontra a região
/// e ocupa a tela toda.
///
/// A origem do gesto decide o alcance do modal — que é como o usuário já lê a
/// cena, sem precisar aprender uma regra.
/// A região medida, com a forma que ela tem.
@immutable
final class AppOverlayBoundsHandle {
  const AppOverlayBoundsHandle({required this.rect, this.borderRadius});

  /// Retângulo global da região, ou `null` enquanto não foi medida.
  ///
  /// É um listenable porque a região se move: recolher o menu, redimensionar a
  /// janela ou entrar em tela cheia mudam o retângulo com a sheet já aberta.
  final ValueListenable<Rect?> rect;

  /// Cantos da região. O modal confinado é recortado por eles — senão o
  /// escurecimento vaza pelas quinas de um cartão arredondado e o overlay
  /// aparece como um retângulo colado por cima, em vez de pertencer ao cartão.
  final BorderRadius? borderRadius;
}

final class AppOverlayBounds extends InheritedWidget {
  const AppOverlayBounds({
    required this.handle,
    required super.child,
    super.key,
  });

  final AppOverlayBoundsHandle handle;

  /// `null` fora de qualquer região — o modal então ocupa a tela toda.
  static AppOverlayBoundsHandle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppOverlayBounds>()?.handle;

  @override
  bool updateShouldNotify(AppOverlayBounds oldWidget) =>
      handle != oldWidget.handle;
}

/// Publica a própria área como [AppOverlayBounds] para a subárvore.
final class AppOverlayBoundsRegion extends StatefulWidget {
  const AppOverlayBoundsRegion({
    required this.child,
    this.borderRadius,
    super.key,
  });

  final Widget child;

  /// Cantos da região, repassados ao recorte do modal confinado.
  final BorderRadius? borderRadius;

  @override
  State<AppOverlayBoundsRegion> createState() => _AppOverlayBoundsRegionState();
}

class _AppOverlayBoundsRegionState extends State<AppOverlayBoundsRegion> {
  final GlobalKey _regionKey = GlobalKey();
  final ValueNotifier<Rect?> _bounds = ValueNotifier<Rect?>(null);
  AppOverlayBoundsHandle? _handle;

  @override
  void dispose() {
    _bounds.dispose();
    super.dispose();
  }

  /// Já há uma medição agendada para o fim deste frame?
  bool _scheduled = false;

  /// Agenda a medição para o fim do frame CORRENTE.
  ///
  /// Chamado depois de cada layout da região (ver [_MeasureAfterLayout]), e não
  /// só quando ela reconstrói: a região muda de tamanho por causa de coisas que
  /// acontecem em OUTRA parte da árvore — arrastar o painel do assistente muda
  /// o estado do painel, o `Row` do shell relayouta e o cartão encolhe **sem**
  /// que este widget reconstrua. Medindo só no build, o retângulo publicado
  /// ficava velho e a sheet aberta não acompanhava o shell (revisão P1r10).
  void _scheduleMeasure() {
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback(_measure);
  }

  /// Medido **depois** do frame: o retângulo só existe quando há layout, e
  /// publicar durante o layout reconstruiria ouvintes no meio do frame.
  void _measure(Duration _) {
    _scheduled = false;
    if (!mounted) return;
    final RenderObject? render = _regionKey.currentContext?.findRenderObject();
    if (render is! RenderBox || !render.hasSize) return;
    final Rect rect = render.localToGlobal(Offset.zero) & render.size;
    if (_bounds.value != rect) _bounds.value = rect;
  }

  @override
  Widget build(BuildContext context) {
    _scheduleMeasure();
    // O handle é memoizado: recriá-lo a cada build faria o
    // `updateShouldNotify` disparar sempre e reconstruir todo modal aberto.
    // `_handle == null` explícito: sem ele, uma região SEM raio nunca criaria
    // o handle (`null != null` é falso) e o `!` abaixo estouraria.
    if (_handle == null || _handle!.borderRadius != widget.borderRadius) {
      _handle = AppOverlayBoundsHandle(
        rect: _bounds,
        borderRadius: widget.borderRadius,
      );
    }
    return AppOverlayBounds(
      handle: _handle!,
      child: _MeasureAfterLayout(
        key: _regionKey,
        onLayout: _scheduleMeasure,
        child: widget.child,
      ),
    );
  }
}

/// Avisa [onLayout] toda vez que se dispõe.
///
/// Existe porque *layout* e *build* são coisas diferentes: a região pode mudar
/// de tamanho sem reconstruir (quem mudou foi um irmão), e é o layout — não o
/// build — que marca o instante em que a geometria publicada ficou velha.
/// Enquanto nada relayouta, isto não custa nada.
final class _MeasureAfterLayout extends SingleChildRenderObjectWidget {
  const _MeasureAfterLayout({
    required this.onLayout,
    required Widget super.child,
    super.key,
  });

  final VoidCallback onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureAfterLayout(onLayout);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMeasureAfterLayout renderObject,
  ) => renderObject.onLayout = onLayout;
}

class _RenderMeasureAfterLayout extends RenderProxyBox {
  _RenderMeasureAfterLayout(this.onLayout);

  VoidCallback onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout();
  }
}

/// Posiciona [child] dentro de [bounds] — ou o deixa em tela cheia se não há
/// região medida.
///
/// Usado pelas rotas modais tanto no conteúdo quanto no **barrier**: escurecer
/// a tela toda enquanto o painel ocupa só um pedaço seria a pior das duas
/// leituras.
final class AppConfinedToBounds extends StatelessWidget {
  const AppConfinedToBounds({
    required this.bounds,
    required this.child,
    super.key,
  });

  /// `null` quando a rota não nasceu dentro de uma região.
  final AppOverlayBoundsHandle? bounds;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AppOverlayBoundsHandle? handle = bounds;
    if (handle == null) return child;

    return ValueListenableBuilder<Rect?>(
      valueListenable: handle.rect,
      // O `child` atravessa o builder sem reconstruir: a sheet guarda estado
      // (aba aberta, formulário preenchido) e o retângulo muda a cada resize.
      child: child,
      builder: (BuildContext context, Rect? rect, Widget? child) {
        if (rect == null) return child!;
        final BorderRadius? radius = handle.borderRadius;
        final Widget confined = radius == null
            ? child!
            : ClipRRect(borderRadius: radius, child: child);
        return Stack(
          children: <Widget>[Positioned.fromRect(rect: rect, child: confined)],
        );
      },
    );
  }
}
