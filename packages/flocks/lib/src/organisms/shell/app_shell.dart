import 'package:flutter/widgets.dart';

import '../../foundation/app_overlay_bounds.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Margem padrão do cartão de conteúdo.
///
/// **Só inferior.** O respiro lateral já vem das margens internas do rail e do
/// painel do assistente; somar mais um vão horizontal abria uma calha vazia de
/// cada lado do cartão e encolhia a área útil sem ganho de leitura. No topo o
/// cartão encosta na barra superior — o degrau de cor (`surface` do header →
/// `surfaceContainer` do cartão) já separa os dois, e um vão ali só somava à
/// folga que o próprio header carrega. A margem inferior é o que faz o cartão
/// **não encostar** na base — é dela que vem a leitura de "flutuando sobre o
/// fundo".
const EdgeInsets kAppShellContentMargin = EdgeInsets.fromLTRB(
  AppSpacings.s0,
  AppSpacings.s0,
  AppSpacings.s0,
  AppSpacings.s16,
);

/// Esqueleto do workspace desktop: rail, header, conteúdo e painel lateral.
///
/// ## Geometria
///
/// ```
/// ┌──────────────────────────────────────┬────────┐
/// │ header                               │        │
/// ├────────┬─────────────────────────────┤ aside  │
/// │        │ ╭─────────────────────────╮ │        │
/// │  rail  │ │        content          │ │        │
/// │        │ ╰─────────────────────────╯ │        │
/// └────────┴─────────────────────────────┴────────┘
/// ```
///
/// * [aside] ocupa a **altura total**, da borda de cima à de baixo;
/// * [header] vai da borda esquerda **até** o [aside] — não é full-width;
/// * [rail] fica **abaixo** do header, não o atravessa;
/// * [content] é um **cartão flutuante**, com cantos arredondados em todos os
///   lados e margem que o afasta da base.
///
/// ## Continuidade por cor
///
/// Rail, header e aside compartilham a mesma superfície (`surface`) e não têm
/// divisórias entre si: a moldura em volta do conteúdo se lê como uma peça só.
/// O contraste vem do cartão (`surfaceContainer`), o único elemento destacado.
/// Isso funciona igual nos temas claro e escuro — o shell **não** fixa um modo.
///
/// ## Dimensões
///
/// O shell não impõe largura a [rail] nem a [aside]: cada um se dimensiona.
/// É o que permite ao chamador tornar o painel lateral arrastável sem que o
/// DS precise saber de persistência.
final class AppShell extends StatelessWidget {
  const AppShell({
    required this.content,
    this.rail,
    this.header,
    this.aside,
    this.fullscreen = false,
    this.contentMargin = kAppShellContentMargin,
    this.contentRadius,
    this.decoration,
    super.key,
  });

  /// Área de trabalho — vira o cartão flutuante.
  final Widget content;

  /// Navegação principal, à esquerda e abaixo do [header].
  final Widget? rail;

  /// Barra superior, da borda esquerda até o [aside].
  final Widget? header;

  /// Painel lateral de altura total (ex.: o assistente).
  final Widget? aside;

  /// Esconde rail, header e aside, deixando só o conteúdo em tela cheia.
  ///
  /// O [content] continua **no mesmo lugar da árvore**, então o estado das
  /// telas montadas sobrevive à alternância.
  final bool fullscreen;

  /// Margem entre o cartão e a moldura. Ver [kAppShellContentMargin].
  final EdgeInsets contentMargin;

  /// Raio do cartão. Por padrão, o eixo global de forma
  /// (`theme.radiusTheme`) resolvido como container — o mesmo do [AppCard].
  final BorderRadius? contentRadius;

  /// Fundo da moldura. Por padrão, `colorTheme.surface`.
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    // A moldura segue o eixo global de estilo quando não recebe `decoration`.
    // Raio zero: é a janela inteira; quem tem canto é o cartão de conteúdo.
    final resolvedDecoration =
        decoration ??
        styleBoxDecoration(
          style: theme.styleTheme.style,
          isDark: theme.brightness == AppBrightness.dark,
          radius: BorderRadius.zero,
          outline: theme.colorTheme.outline,
          surfaceContainer: theme.colorTheme.surfaceContainer,
          ownFill: theme.colorTheme.surface,
        );

    // A estrutura é a MESMA nos dois modos: os slots viram `SizedBox.shrink()`
    // em vez de sumirem da lista. Se a árvore mudasse de forma, o `content`
    // trocaria de posição entre irmãos, o Flutter recriaria o Element e todo o
    // estado montado (mapas, abas vivas) morreria ao entrar em fullscreen —
    // exatamente o que a GlobalKey compartilhada evitava no shell antigo.
    const hidden = SizedBox.shrink();

    return DecoratedBox(
      decoration: resolvedDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (fullscreen) hidden else header ?? hidden,
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (fullscreen) hidden else rail ?? hidden,
                      Expanded(
                        child: _AppShellContentCard(
                          margin: fullscreen ? EdgeInsets.zero : contentMargin,
                          radius: fullscreen
                              ? BorderRadius.zero
                              : contentRadius,
                          child: content,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (fullscreen) hidden else aside ?? hidden,
        ],
      ),
    );
  }
}

/// Marca que o conteúdo já está dentro do cartão do [AppShell].
///
/// Existe para páginas que pintam a própria superfície não pintarem de novo:
/// duas camadas de `surfaceContainer` com bordas e cantos no meio do cartão
/// desenham uma emenda que não deveria existir. A página consulta
/// [isInsideCard] e, quando `true`, entrega só o conteúdo.
///
/// É um marcador em vez de um parâmetro porque a página não sabe — nem deve
/// saber — em que shell foi montada: a mesma tela roda dentro do cartão no
/// desktop e solta no mobile.
final class AppShellContentScope extends InheritedWidget {
  const AppShellContentScope({required super.child, super.key});

  /// Há um cartão do [AppShell] acima?
  static bool isInsideCard(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppShellContentScope>() !=
      null;

  @override
  bool updateShouldNotify(AppShellContentScope oldWidget) => false;
}

/// O cartão: margem, cantos arredondados nos quatro lados e clip do conteúdo.
final class _AppShellContentCard extends StatelessWidget {
  const _AppShellContentCard({
    required this.child,
    required this.margin,
    this.radius,
  });

  final Widget child;
  final EdgeInsets margin;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    // Escada de superfície: o cartão ocupa a janela inteira, então a escada
    // geral em `circular` o transformaria numa elipse que corta a própria
    // página. Ver `contentSurfaceRadius`.
    final borderRadius = radius ?? theme.radiusTheme.contentSurfaceRadius();

    return Padding(
      padding: margin,
      child: DecoratedBox(
        decoration: styleBoxDecoration(
          style: theme.styleTheme.style,
          isDark: theme.brightness == AppBrightness.dark,
          radius: borderRadius,
          outline: theme.colorTheme.outline,
          surfaceContainer: theme.colorTheme.surfaceContainer,
          ownFill: theme.colorTheme.surfaceContainer,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          // O cartão publica a própria área: um modal aberto de DENTRO dele
          // (configurar colunas, importar, exportar) se confina aqui, em vez de
          // apagar o rail e o assistente para tratar de uma tabela. Aberto de
          // fora — pelo assistente ou pela busca do header — nada muda.
          child: AppOverlayBoundsRegion(
            // O mesmo raio do cartão: o barrier de um modal confinado é
            // recortado por ele, senão o escurecimento vaza pelas quinas e o
            // overlay lê como um retângulo colado por cima.
            borderRadius: borderRadius,
            child: AppShellContentScope(child: child),
          ),
        ),
      ),
    );
  }
}
