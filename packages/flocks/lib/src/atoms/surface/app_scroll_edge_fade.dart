import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';

/// Esmaece a borda do conteúdo que ROLA, para o corte contra um cabeçalho ou
/// rodapé fixo não ser uma linha seca.
///
/// O véu vai da cor da superfície (100%) até transparente (0%) — só do lado em
/// que existe conteúdo escondido. Sem rolagem possível, nada é pintado: um
/// degradê permanente sugeriria conteúdo que não existe.
///
/// Passivo: [IgnorePointer] em cima do véu, então o toque continua chegando ao
/// conteúdo por baixo dele.
///
/// Um descendente que cuide do PRÓPRIO véu (o [AppScrollEdgeFade] de dentro de
/// um componente com abas, por exemplo) se anuncia com [AppScrollEdgeFadeOwner]
/// e desliga este — ver a doc de lá.
///
/// ```dart
/// AppScrollEdgeFade(child: SingleChildScrollView(child: ...))
/// ```
final class AppScrollEdgeFade extends StatefulWidget {
  const AppScrollEdgeFade({
    required this.child,
    this.color,
    this.extent = AppSpacings.s24,
    this.axis = Axis.vertical,
    super.key,
  });

  /// Conteúdo rolável.
  final Widget child;

  /// Cor de onde o degradê parte. Default: a superfície elevada do tema
  /// (`surfaceContainer`) — cartões, sheets e painéis.
  final Color? color;

  /// Altura (ou largura) do véu.
  final double extent;

  /// Eixo da rolagem.
  final Axis axis;

  @override
  State<AppScrollEdgeFade> createState() => _AppScrollEdgeFadeState();
}

class _AppScrollEdgeFadeState extends State<AppScrollEdgeFade> {
  bool _hasBefore = false;
  bool _hasAfter = false;

  /// Quantos [AppScrollEdgeFadeOwner] descendentes assumiram o véu desta área.
  /// Enquanto houver um, este véu não pinta nada.
  int _owners = 0;

  bool get _delegated => _owners > 0;

  void _addOwner() {
    _owners++;
    if (_owners == 1) _deferRebuild();
  }

  void _removeOwner() {
    _owners--;
    if (_owners == 0) _deferRebuild();
  }

  /// (Des)inscrição acontece no `didChangeDependencies` de um DESCENDENTE — ou
  /// seja, durante o build. Reconstruir agora seria `setState` em pleno build,
  /// então espera o frame fechar. Nada pisca: o véu só nasce depois da primeira
  /// medida da rolagem, que chega no mesmo frame ou depois.
  void _deferRebuild() {
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (mounted) setState(() {});
    });
  }

  bool _apply(ScrollMetrics m) {
    if (m.axis != widget.axis) return false;
    final bool before = m.extentBefore > 0.5;
    final bool after = m.extentAfter > 0.5;
    if (before == _hasBefore && after == _hasAfter) return false;
    setState(() {
      _hasBefore = before;
      _hasAfter = after;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Color color =
        widget.color ?? AppTheme.of(context).colorTheme.surfaceContainer;
    final bool vertical = widget.axis == Axis.vertical;

    return _AppScrollEdgeFadeScope(
      state: this,
      child: NotificationListener<ScrollMetricsNotification>(
        // A primeira medida chega ANTES de qualquer rolagem: sem ouvi-la, um
        // conteúdo já maior que a área nasceria sem véu até o usuário rolar.
        onNotification: (ScrollMetricsNotification n) {
          _apply(n.metrics);
          return false;
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification n) {
            _apply(n.metrics);
            return false;
          },
          child: Stack(
            children: <Widget>[
              widget.child,
              if (_hasBefore && !_delegated)
                _Veil(
                  color: color,
                  extent: widget.extent,
                  vertical: vertical,
                  atStart: true,
                ),
              if (_hasAfter && !_delegated)
                _Veil(
                  color: color,
                  extent: widget.extent,
                  vertical: vertical,
                  atStart: false,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Publica o [AppScrollEdgeFade] vigente para os descendentes.
final class _AppScrollEdgeFadeScope extends InheritedWidget {
  const _AppScrollEdgeFadeScope({required this.state, required super.child});

  final _AppScrollEdgeFadeState state;

  @override
  bool updateShouldNotify(_AppScrollEdgeFadeScope old) =>
      !identical(state, old.state);
}

/// Assume o véu da própria área: enquanto montado, o [AppScrollEdgeFade]
/// **ancestral** não pinta véu nenhum.
///
/// Existe porque um componente que rola por dentro (abas, painéis empilhados)
/// já esmaece o próprio conteúdo, mas o ancestral continua ouvindo a MESMA
/// rolagem — e pinta o véu dele na borda da área inteira, que ali não é a borda
/// do conteúdo: numa sheet com abas, o degradê caía por cima da barra de abas.
/// O véu tem de nascer de quem sabe onde o conteúdo realmente começa.
///
/// Sem [AppScrollEdgeFade] acima, é um passa-through — não é erro montá-lo
/// solto.
///
/// ```dart
/// AppScrollEdgeFadeOwner(          // desliga o véu de fora…
///   child: Column(children: [
///     tabBar,
///     Expanded(child: AppScrollEdgeFade(child: content)), // …e cuida do daqui
///   ]),
/// )
/// ```
final class AppScrollEdgeFadeOwner extends StatefulWidget {
  const AppScrollEdgeFadeOwner({required this.child, super.key});

  /// Conteúdo que cuida do próprio esmaecimento.
  final Widget child;

  @override
  State<AppScrollEdgeFadeOwner> createState() => _AppScrollEdgeFadeOwnerState();
}

class _AppScrollEdgeFadeOwnerState extends State<AppScrollEdgeFadeOwner> {
  _AppScrollEdgeFadeState? _ancestor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _AppScrollEdgeFadeState? next = context
        .dependOnInheritedWidgetOfExactType<_AppScrollEdgeFadeScope>()
        ?.state;
    if (identical(next, _ancestor)) return;
    _ancestor?._removeOwner();
    _ancestor = next;
    next?._addOwner();
  }

  @override
  void dispose() {
    _ancestor?._removeOwner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Um dos dois véus (início/fim do eixo).
final class _Veil extends StatelessWidget {
  const _Veil({
    required this.color,
    required this.extent,
    required this.vertical,
    required this.atStart,
  });

  final Color color;
  final double extent;
  final bool vertical;
  final bool atStart;

  @override
  Widget build(BuildContext context) {
    final Alignment begin = vertical
        ? (atStart ? Alignment.topCenter : Alignment.bottomCenter)
        : (atStart ? Alignment.centerLeft : Alignment.centerRight);
    final Alignment end = vertical
        ? (atStart ? Alignment.bottomCenter : Alignment.topCenter)
        : (atStart ? Alignment.centerRight : Alignment.centerLeft);

    return Positioned(
      top: vertical ? (atStart ? 0 : null) : 0,
      bottom: vertical ? (atStart ? null : 0) : 0,
      left: vertical ? 0 : (atStart ? 0 : null),
      right: vertical ? 0 : (atStart ? null : 0),
      height: vertical ? extent : null,
      width: vertical ? null : extent,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: <Color>[color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}
