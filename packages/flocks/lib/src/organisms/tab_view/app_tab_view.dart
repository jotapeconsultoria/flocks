import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

const _tabIndicatorAnimationDuration = AppDurations.normal;

/// Espessura do indicador da aba ativa — a MESMA da régua que corre por baixo
/// de toda a barra (`AppStrokes.s`). São a mesma linha: o que muda de uma aba
/// para a outra é a cor, não o peso. Com `AppStrokes.l` o trecho ativo ficava
/// quatro vezes mais grosso que o resto e a barra parecia quebrada em duas.
const _tabIndicatorHeight = AppStrokes.s;

/// Recuo interno do rótulo de cada aba.
///
/// O vertical vale para o rótulo INTEIRO (a pílula de hover é dele, e só dele —
/// o indicador ficou de fora), então é ele que dá altura de alvo à aba: com
/// `s4` a pílula abraçava o texto e ainda engolia o indicador, o que empurrava
/// o rótulo para cima dentro dela.
const _tabLabelPadding = EdgeInsets.symmetric(
  horizontal: AppSpacings.s8 + AppRadius.l,
  vertical: AppSpacings.s8,
);

/// Dados de cada aba do [AppTabView].
final class AppTabViewItem {
  const AppTabViewItem({required this.builder, required this.label});

  /// Construtor do conteúdo da aba.
  final WidgetBuilder builder;

  /// Texto exibido no cabeçalho da aba.
  final String label;
}

/// Componente de tabs com indicador na aba ativa e lazy load opcional.
final class AppTabView extends StatefulWidget {
  const AppTabView({
    required this.items,
    this.initialIndex = 0,
    this.lazyLoadOnFirstOpen = true,
    this.onTabChanged,
    this.background,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: AppSpacings.s8,
    ),
    super.key,
  }) : assert(items.length > 0, 'At least one tab is required'),
       assert(
         initialIndex >= 0 && initialIndex < items.length,
         'initialIndex must be inside items range',
       );

  /// Índice inicialmente ativo.
  final int initialIndex;

  /// Itens exibidos no componente.
  final List<AppTabViewItem> items;

  /// Se `true`, cada aba só cria seu conteúdo na primeira ativação.
  final bool lazyLoadOnFirstOpen;

  /// Callback ao trocar a aba ativa.
  final ValueChanged<int>? onTabChanged;

  /// Superfície em que as abas são pousadas — usada para escolher os stops de
  /// cor do rótulo ativo e do inativo.
  ///
  /// Default `surfaceContainer`: abas quase sempre vivem dentro de um cartão ou
  /// de uma sheet. É a superfície com MENOS folga de contraste das duas, então
  /// o stop escolhido por ela continua legível também sobre a `surface` — o
  /// contrário não vale, e era o que apagava o rótulo inativo dentro da sheet.
  /// Quem monta as abas direto sobre a `surface` passa a dela.
  final Color? background;

  /// Recuo lateral do CORPO da aba (o conteúdo, não a barra).
  ///
  /// Existe porque a área de conteúdo costuma ir de borda a borda de quem
  /// hospeda as abas — e numa side sheet a faixa de arraste mora exatamente ali,
  /// por cima do conteúdo.
  ///
  /// Ao aplicá-lo, o corpo **assume** o respiro lateral e consome o que a
  /// superfície hospedeira tenha publicado em `MediaQuery.padding` (ver
  /// [AppSideInset]) — senão os dois se somariam. É isso que traz a barra de
  /// rolagem de volta para a borda: ela se posiciona pelo `padding` do
  /// `MediaQuery`, e com os 24px da sheet ali ela era desenhada 24px para
  /// dentro, em cima do conteúdo.
  ///
  /// Consequência: numa borda com intrusão física (notch), quem escolhe o valor
  /// é este recuo — o do sistema não chega mais ao corpo.
  ///
  /// O véu de esmaecimento continua indo de ponta a ponta: ele veda o corte
  /// contra a barra de abas, que é larga como a sheet.
  final EdgeInsetsGeometry contentPadding;

  @override
  State<AppTabView> createState() => _AppTabViewState();
}

class _AppTabViewState extends State<AppTabView> {
  /// A barra de abas está sendo arrastada agora? Muda só o CURSOR.
  bool _draggingHeader = false;

  void _setDraggingHeader(bool value) {
    if (_draggingHeader == value || !mounted) return;
    setState(() => _draggingHeader = value);
  }

  late int _selectedTabIndex;
  late final Set<int> _visitedTabIndexes;

  /// Contextos das abas — necessários para rolar até a tocada.
  final Map<int, GlobalKey> _tabKeys = <int, GlobalKey>{};

  GlobalKey _keyFor(int index) => _tabKeys[index] ??= GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialIndex;
    _visitedTabIndexes = <int>{widget.initialIndex};
  }

  @override
  void didUpdateWidget(covariant AppTabView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.items.length < oldWidget.items.length) {
      _visitedTabIndexes.removeWhere((index) => index >= widget.items.length);
      if (_selectedTabIndex >= widget.items.length) {
        _selectedTabIndex = widget.items.length - 1;
        _visitedTabIndexes.add(_selectedTabIndex);
      }
    }

    if (widget.initialIndex != oldWidget.initialIndex &&
        widget.initialIndex < widget.items.length &&
        widget.initialIndex >= 0) {
      _selectedTabIndex = widget.initialIndex;
      _visitedTabIndexes.add(widget.initialIndex);
    }
  }

  bool _shouldBuildContentFor(int index) {
    if (!widget.lazyLoadOnFirstOpen) {
      return true;
    }

    return _visitedTabIndexes.contains(index);
  }

  /// Constrói o conteúdo da aba SEMPRE que o pai reconstrói.
  ///
  /// O lazy load é decidido por [_shouldBuildContentFor] (quais abas já foram
  /// abertas) — não por cache de Widget. Guardar a instância construída
  /// congelava as props do primeiro build: uma aba com conteúdo dinâmico
  /// (ex.: alternar leitura/edição) nunca via a mudança, porque o pai
  /// reconstruía e o [AppTabView] devolvia a árvore velha.
  ///
  /// O estado (`State`) das abas continua preservado: o subtree segue montado
  /// na mesma posição e com a mesma [ValueKey], então reconstruir o Widget não
  /// recria os elementos.
  Widget _buildTabContent(int index) => KeyedSubtree(
    key: ValueKey('app_tab_view_content_$index'),
    child: widget.items[index].builder(context),
  );

  /// Traz a aba [index] para a área visível da barra.
  ///
  /// Clicar numa aba parcialmente cortada deixava metade dela fora da tela: a
  /// barra rola, mas ninguém a rolava (revisão P1r9).
  void _revealTab(int index) {
    final BuildContext? tabContext = _keyFor(index).currentContext;
    if (tabContext == null) return;
    Scrollable.ensureVisible(
      tabContext,
      alignment: 0.5,
      duration: AppMotion.resolve(context, AppDurations.fast),
      curve: AppCurves.standard,
    );
  }

  void _onTabPressed(int index) {
    // Mesmo já ativa, a aba tocada tem de ficar visível.
    _revealTab(index);
    if (index == _selectedTabIndex) {
      return;
    }

    setState(() {
      _selectedTabIndex = index;
      _visitedTabIndexes.add(index);
    });
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final Color background =
        widget.background ?? theme.colorTheme.surfaceContainer;
    // Acento da aba ativa resolvido por contraste sobre a superfície (era
    // `secondary` cru — laranja borderline no claro sobre branco).
    final Color activeAccent = readableStopOn(
      theme.colorTheme.secondary,
      background,
    );
    // Aba INATIVA: era `neutralPrimary.s400` fixo — o mesmo stop nos dois temas,
    // que dentro de uma sheet escura sumia contra o fundo (o título da aba
    // ficava ilegível). Derivar o stop pela superfície resolve claro/escuro e as
    // marcas de uma vez, exatamente como o [AppWorkspaceTabs] já faz.
    final Color inactiveForeground = readableStopOn(
      theme.colorTheme.neutralPrimary,
      background,
      minRatio: kAaNormal,
    );

    // O véu daqui para baixo é NOSSO: quem esmaece o conteúdo é o véu de dentro
    // da aba, que começa logo abaixo da barra. O ancestral (a side sheet, por
    // exemplo) ouve a mesma rolagem, mas a "borda do conteúdo" para ele é o topo
    // da área inteira — e o degradê dele caía por cima das abas.
    return AppScrollEdgeFadeOwner(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Borda IGUAL à do [AppWorkspaceTabs]: `divider` (onSurface a 10%) com
          // `AppStrokes.s`. Era `outline` — um cinza sólido — com o dobro da
          // espessura, e as duas barras de aba apareciam na mesma tela com pesos
          // diferentes, como se fossem componentes de famílias distintas.
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorTheme.divider,
                  width: AppStrokes.s,
                ),
              ),
            ),
            // `dragDevices` com o mouse: no desktop, arrastar a barra rola as
            // abas. Sem isto só a roda do mouse funcionava, e numa barra estreita
            // não havia como alcançar as abas escondidas (revisão P1r9).
            child: MouseRegion(
              // `defer` fora do arraste: cada aba pede a própria mãozinha de
              // clique. Durante o arraste esta região VENCE e mostra a mão
              // fechada — sem isso o ponteiro voltava ao cursor padrão no meio
              // do gesto, como se nada estivesse acontecendo (revisão P1r10).
              // Mesmo tratamento das workspace tabs.
              cursor: _draggingHeader
                  ? SystemMouseCursors.grabbing
                  : MouseCursor.defer,
              child: NotificationListener<ScrollNotification>(
                // O arraste vem das notificações da própria rolagem: envolver num
                // GestureDetector roubaria o gesto do scrollable.
                onNotification: (ScrollNotification n) {
                  if (n is ScrollStartNotification && n.dragDetails != null) {
                    _setDraggingHeader(true);
                  } else if (n is ScrollEndNotification) {
                    _setDraggingHeader(false);
                  }
                  return false;
                },
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: <PointerDeviceKind>{
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus,
                    },
                    scrollbars: false,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    // Recuo lateral da FAIXA: com a aba dimensionada pelo
                    // conteúdo, o alvo de clique da primeira encostava na borda da
                    // tela. `s2` entre abas é o mesmo respiro das workspace tabs —
                    // sem ele dois alvos vizinhos se tocam e não há onde "errar".
                    //
                    // O recuo é o MESMO do conteúdo (`contentPadding`), e não um
                    // valor próprio: assim a pílula da primeira aba — e o
                    // indicador embaixo dela — começa exatamente onde começa a
                    // primeira seção do corpo. Com um valor fixo aqui, quem
                    // recuasse o conteúdo via `contentPadding` via o indicador
                    // sobrar para fora dele. (Default inalterado: `s8` dos dois
                    // lados.)
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.contentPadding
                          .resolve(Directionality.of(context))
                          .left,
                    ),
                    child: Row(
                      spacing: AppSpacings.s2,
                      children: [
                        for (
                          var index = 0;
                          index < widget.items.length;
                          index++
                        )
                          _AppTabViewHeader(
                            // A ValueKey é contrato público (testes e consumidores a
                            // usam para tocar uma aba); a GlobalKey da rolagem vai
                            // separada, por dentro.
                            key: ValueKey('app_tab_view_tab_$index'),
                            revealKey: _keyFor(index),
                            index: index,
                            label: widget.items[index].label,
                            selected: _selectedTabIndex == index,
                            activeAccent: activeAccent,
                            inactiveForeground: inactiveForeground,
                            onTap: () => _onTabPressed(index),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Degradê nas pontas do conteúdo, o MESMO que o side sheet aplica
          // (`side_sheet_surface.dart`). Sem ele o conteúdo era cortado a seco sob
          // a barra, e nada dizia que havia mais coisa acima ou abaixo.
          //
          // A cor acompanha o `background` da barra: um véu de cor diferente do
          // que está atrás aparece como FAIXA, não como esmaecimento.
          //
          // O `AppScrollEdgeFade` escuta `ScrollNotification`, então serve
          // qualquer scrollable que o consumidor devolva no `builder` — não exige
          // `ScrollController` nem conhecer a árvore do conteúdo.
          Expanded(
            child: AppScrollEdgeFade(
              color: background,
              // O recuo vai por DENTRO do véu: assim o conteúdo respira longe da
              // borda (e da faixa de arraste da sheet), mas o esmaecimento segue
              // cobrindo a largura toda — véu recuado deixaria dois cantinhos de
              // conteúdo cortados a seco contra a barra de abas.
              child: Padding(
                padding: widget.contentPadding,
                // O respiro lateral passa a ser NOSSO, então o publicado sai de
                // cena — ver `contentPadding`. Sem isto a barra de rolagem, que
                // se posiciona pelo `padding` do MediaQuery, era desenhada 24px
                // para dentro da sheet, em cima do cabeçalho das seções.
                child: MediaQuery.removePadding(
                  context: context,
                  removeLeft: true,
                  removeRight: true,
                  child: Stack(
                    children: [
                      for (var index = 0; index < widget.items.length; index++)
                        if (_shouldBuildContentFor(index))
                          Offstage(
                            offstage: _selectedTabIndex != index,
                            child: TickerMode(
                              enabled: _selectedTabIndex == index,
                              child: _buildTabContent(index),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cabeçalho de UMA aba do [AppTabView]: rótulo + indicador.
///
/// Widget próprio (e não um trecho do `build` do pai) porque tem estado: o
/// hover clareia o rótulo da aba inativa — o realce precisa ser sempre um passo
/// além do repouso, senão o alvo do ponteiro fica implícito.
final class _AppTabViewHeader extends StatefulWidget {
  const _AppTabViewHeader({
    required this.revealKey,
    required this.index,
    required this.label,
    required this.selected,
    required this.activeAccent,
    required this.inactiveForeground,
    required this.onTap,
    super.key,
  });

  /// Âncora usada para rolar a barra até esta aba.
  final GlobalKey revealKey;

  final int index;
  final String label;
  final bool selected;
  final Color activeAccent;
  final Color inactiveForeground;
  final VoidCallback onTap;

  @override
  State<_AppTabViewHeader> createState() => _AppTabViewHeaderState();
}

class _AppTabViewHeaderState extends State<_AppTabViewHeader> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final Color foreground = widget.selected
        ? widget.activeAccent
        : _hovered
        ? theme.colorTheme.onSurface
        : widget.inactiveForeground;

    // Pílula de hover na aba INATIVA, como nas workspace tabs: só trocar a cor
    // do texto é uma resposta fraca para um alvo de clique deste tamanho — o
    // usuário não sabe onde a aba começa e termina (revisão P1r10). A ativa não
    // recebe: ela já é destacada pelo acento e pelo sublinhado.
    final Color hoverFill = !widget.selected && _hovered
        ? theme.colorTheme.onSurface.customOpacity(0.08)
        : theme.colorTheme.transparent;

    return ConstrainedBox(
      key: widget.revealKey,
      constraints: const BoxConstraints(maxWidth: AppSpacings.s192),
      // Regra 8: a aba é um alvo SELECIONÁVEL, e a seleção precisa existir
      // fora do pixel. Sem `selected` o leitor de tela lê as abas como uma
      // fileira de botões iguais — a ativa se distingue só pelo acento e pelo
      // sublinhado, que ninguém ouve.
      child: Semantics(
        container: true,
        button: true,
        selected: widget.selected,
        onTap: widget.onTap,
        child: SelectionContainer.disabled(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacings.s4),
                // A aba tem a largura do CONTEÚDO (rótulo + padding), como a
                // workspace tab, e o sublinhado acompanha.
                //
                // Antes o indicador pedia `AppSpacings.infinity`, o que empurrava
                // a Column para o teto do `ConstrainedBox` e fixava TODA aba em
                // 192px, com o rótulo centralizado no meio do bloco. Era isso que
                // fazia a barra parecer apertada — não o padding, que nem chegava
                // a importar: mexer nele não movia nada.
                //
                // `IntrinsicWidth` é necessário: com `stretch` sozinho a Column
                // adota o MÁXIMO da restrição (os mesmos 192), não a largura dos
                // filhos. Ele mede o rótulo e é o que o `stretch` estica depois —
                // custo aceitável para meia dúzia de abas.
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // A pílula de hover é do RÓTULO: veste só o bloco de texto,
                      // com folga igual em cima e embaixo. Antes ela morava no
                      // container da aba inteira, então incluía o indicador — e o
                      // texto, que ocupava só a parte de cima, nascia visivelmente
                      // fora do centro dela.
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: hoverFill,
                          borderRadius: theme.radiusTheme.resolve(
                            size: const Size(double.infinity, AppSizes.s32),
                          ),
                        ),
                        child: Padding(
                          // Mesmo padding INTERNO das workspace tabs na variante
                          // `attached` (`AppSpacings.s8 + AppRadius.l`), que é a
                          // que convive com esta barra na mesma tela.
                          padding: _tabLabelPadding,
                          child: AppText(
                            widget.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium.withColor(
                              foreground,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        key: ValueKey('app_tab_view_indicator_${widget.index}'),
                        duration: AppMotion.resolve(
                          context,
                          _tabIndicatorAnimationDuration,
                        ),
                        curve: AppCurves.standard,
                        decoration: BoxDecoration(
                          color: widget.selected
                              ? widget.activeAccent
                              : theme.colorTheme.transparent,
                        ),
                        height: _tabIndicatorHeight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
