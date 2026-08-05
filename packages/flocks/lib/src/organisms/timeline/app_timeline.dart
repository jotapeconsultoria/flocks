import 'package:flutter/widgets.dart';

import '../../atoms/surface/surface.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Uma linha do tempo CRONOLÓGICA: eventos que aconteceram, do mais recente
/// para o mais antigo.
///
/// # Por que não é o `AppStepper`
///
/// O stepper indica PROGRESSO num processo com começo, meio e fim conhecidos —
/// ele tem passo atual, passos futuros e a promessa de que se chega ao último.
/// Uma trilha de eventos não tem nada disso: ela não termina, não tem passo
/// "atual", e o que veio antes não habilita o que veio depois. Usar um pelo
/// outro faz a tela prometer uma sequência que não existe.
///
/// # Semântica
///
/// É uma LISTA semântica, navegável item a item (Screen Contract §11). O trilho
/// vertical é decoração e sai da árvore de acessibilidade — quem navega por
/// leitor de tela ouve os eventos, não a linha que os conecta.
///
/// ```dart
/// AppTimeline(
///   itemCount: eventos.length,
///   itemBuilder: (BuildContext context, int i) => AuditEventTile(eventos[i]),
///   footer: carregando ? const AppCircularLoading() : null,
/// )
/// ```
final class AppTimeline extends StatelessWidget {
  /// Cria um [AppTimeline].
  const AppTimeline({
    required this.itemBuilder,
    required this.itemCount,
    this.controller,
    this.footer,
    this.markerBuilder,
    this.padding,
    this.shrinkWrap = false,
    super.key,
  });

  /// Constrói o CONTEÚDO de cada evento. O trilho e o marcador são deste widget.
  final NullableIndexedWidgetBuilder itemBuilder;

  /// Quantos eventos.
  final int itemCount;

  /// Controlador de rolagem. Necessário para preservar a posição ao fechar o
  /// detalhe (Screen Contract §3).
  final ScrollController? controller;

  /// Slot do rodapé: "carregar mais", spinner de página seguinte, ou o aviso de
  /// fim da trilha. Fica DENTRO da rolagem, junto ao último item — fora dela,
  /// ele ficaria visível o tempo todo e a pessoa clicaria antes de chegar ao fim.
  final Widget? footer;

  /// Marcador de cada item. Default: um ponto. Um evento negado pode querer
  /// outro, e a cor não pode ser a única diferença (§11).
  final IndexedWidgetBuilder? markerBuilder;

  /// Padding externo da lista.
  final EdgeInsetsGeometry? padding;

  /// `true` quando a timeline vive dentro de outra rolagem.
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: ListView.builder(
        controller: controller,
        itemCount: itemCount + (footer == null ? 0 : 1),
        padding: padding ?? EdgeInsets.zero,
        shrinkWrap: shrinkWrap,
        itemBuilder: (BuildContext context, int index) {
          if (index >= itemCount) {
            return Padding(
              padding: const EdgeInsets.only(
                left: _railWidth,
                top: AppSpacings.s8,
                bottom: AppSpacings.s8,
              ),
              child: footer,
            );
          }
          return _TimelineRow(
            isFirst: index == 0,
            isLast: index == itemCount - 1,
            marker:
                markerBuilder?.call(context, index) ??
                _TimelineDot(color: theme.colorTheme.primary),
            child: itemBuilder(context, index) ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

/// Largura do trilho: marcador + respiro até o conteúdo.
const double _railWidth = AppSpacings.s32;

/// Uma linha: trilho à esquerda, conteúdo à direita.
///
/// # Por que Stack e não Row com stretch
///
/// O trilho precisa ter a ALTURA DO CONTEÚDO, que só é conhecida depois de
/// medi-lo. `Row` + `CrossAxisAlignment.stretch` parece resolver e não resolve:
/// dentro de um `ListView` a altura é ilimitada, o `stretch` propaga
/// `h=Infinity` para o trilho e o layout estoura. `IntrinsicHeight` resolveria,
/// e mede o filho DUAS vezes por item — numa trilha longa isso é custo por
/// linha.
///
/// Aqui o conteúdo é o filho NÃO posicionado, e portanto o que dimensiona o
/// `Stack`; o trilho é `Positioned` com `top`/`bottom`, e se estica sozinho até
/// a altura que o conteúdo determinou. Uma medição, um layout.
final class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.child,
    required this.isFirst,
    required this.isLast,
    required this.marker,
  });

  final Widget child;
  final bool isFirst;
  final bool isLast;
  final Widget marker;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);

    return Stack(
      children: <Widget>[
        // O trilho é decoração pura: sai da árvore semântica para não virar
        // ruído em leitor de tela, que precisa ouvir eventos e não linhas.
        //
        // `top` começa no centro do marcador no PRIMEIRO item e `bottom` para
        // lá no ÚLTIMO: sem isso, a linha sairia por cima do primeiro ponto e
        // continuaria abaixo do último, apontando para eventos que não existem.
        Positioned(
          left: _railWidth / 2,
          top: isFirst ? _markerCenter : 0,
          bottom: isLast ? null : 0,
          height: isLast ? _markerCenter : null,
          child: ExcludeSemantics(
            child: Container(width: 1, color: theme.colorTheme.divider),
          ),
        ),
        Positioned(
          left: 0,
          top: _markerTop,
          width: _railWidth,
          child: ExcludeSemantics(child: Center(child: marker)),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: _railWidth,
            bottom: AppSpacings.s12,
          ),
          child: child,
        ),
      ],
    );
  }
}

/// Alinhamento do marcador com a primeira linha de texto do conteúdo.
const double _markerTop = AppSpacings.s4;
const double _markerCenter = _markerTop + _dotSize / 2;
const double _dotSize = AppSpacings.s8;

/// O ponto padrão do trilho.
final class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => AppSurface(
    variant: AppSurfaceVariant.flat,
    style: AppStyle.filled,
    radius: BorderRadius.circular(999),
    color: color,
    child: const SizedBox(width: _dotSize, height: _dotSize),
  );
}
