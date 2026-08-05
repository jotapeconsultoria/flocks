import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'workspace_tab_shape.dart';

/// Altura da barra de abas.
const _barHeight = 46.0;

/// Largura máxima de cada aba.
///
/// Subiu de 192 para 260 quando o teto de abas caiu de 10 para 5: com metade
/// das abas, cabe mais título antes de precisar do fade.
const _tabMaxWidth = 260.0;

/// Largura reservada ao slot [AppWorkspaceTabs.leading] no cálculo da largura
/// das abas. Sem descontá-la, as abas pediriam a linha inteira e a última
/// estouraria.
///
/// Sobra folga de propósito: o conteúdo é centrado nela, e com a reserva justa
/// o slot encostava na borda do cartão enquanto a aba seguinte trazia 16px de
/// padding interno — dois pesos visuais diferentes de cada lado.
const _leadingSlotWidth = 70.0;

/// Espaço horizontal entre abas adjacentes.
const _tabGap = AppSpacings.s2; // 2.0

/// Padding horizontal do componente (em cada lado).
///
/// Zero no [AppWorkspaceTabsVariant.attached]: ali a barra é o topo do próprio
/// cartão, e qualquer recuo abriria uma faixa de fundo entre a aba e a borda —
/// o oposto de "colada". No [AppWorkspaceTabsVariant.inset] as abas são pílulas
/// soltas dentro de um cartão, e aí o recuo é o que as descola da borda.
const _barHorizontalPaddingAttached = AppSpacings.s0;
const _barHorizontalPaddingInset = AppSpacings.s32; // 32.0

/// Padding vertical interno do conteúdo de cada aba.
///
/// A altura clicável já vem do `stretch` da linha — a aba ocupa a barra
/// inteira. Este padding só afasta o texto das bordas, e com 8px sobrava
/// espaço morto acima e abaixo do título.
const _tabVerticalPadding = AppSpacings.s4; // 4.0

/// Largura (px) do degradê de fade aplicado na borda direita do título quando o
/// texto transborda (requisito 5).
const _titleFadeWidth = 20.0;

/// Raio dos cantos superiores da aba ativa.
const _activeTopRadius = 12.0;

/// Raio das asas côncavas na base da aba ativa (ver [WorkspaceTabShape]).
const _activeWingRadius = AppRadius.l; // 8.0

const _hoverAnimationDuration = AppDurations.fast;

/// Largura mínima antes de a barra passar a rolar.
///
/// Sem um piso, 10 abas em 1280px ficavam com ~90px cada — largura em que
/// ícone, título e botão de fechar não cabem e a aba vira um borrão.
const double kAppWorkspaceTabMinWidth = 132.0;

/// Como a barra se relaciona com o conteúdo abaixo dela.
enum AppWorkspaceTabsVariant {
  /// Aba ativa **encosta** no conteúdo: cantos arredondados só no topo e base
  /// aberta, estilo navegador. Pressupõe que o conteúdo comece logo abaixo,
  /// na mesma superfície.
  attached,

  /// Aba ativa como **pílula preenchida**, sem se prender a nada embaixo.
  /// É a variante para barras que vivem *dentro* de um cartão de cantos
  /// arredondados, onde "colar no conteúdo" não faz sentido.
  inset,
}

/// Dados de uma aba exibida no [AppWorkspaceTabs].
final class AppWorkspaceTabItem {
  const AppWorkspaceTabItem({
    required this.id,
    required this.title,
    required this.icon,
  });

  /// Identificador único da aba.
  final String id;

  /// Título exibido.
  final String title;

  /// Ícone (constante de `AppIcons`).
  final String icon;
}

/// Tab strip "browser-like" do workspace desktop: lista horizontal de abas com
/// ícone, título e botão de fechar. Componente **controlado** — o estado das
/// abas vive fora (no `TabsCubit`).
///
/// A barra é transparente (sem cor de fundo). Apenas a aba ATIVA tem
/// preenchimento, usando a cor `tertiary` (tom claro no fundo, tom forte no
/// texto/ícone), com cantos arredondados só no topo e base reta encostando no
/// conteúdo. As abas inativas ficam sem fundo (transparentes). O conteúdo é
/// afastado das laterais por um padding horizontal de 32px.
final class AppWorkspaceTabs extends StatefulWidget {
  const AppWorkspaceTabs({
    required this.tabs,
    required this.activeId,
    required this.onSelect,
    required this.onClose,
    this.decoration,
    this.variant = AppWorkspaceTabsVariant.attached,
    this.minTabWidth = kAppWorkspaceTabMinWidth,
    this.showIndexHint = false,
    this.leading,
    this.onReorder,
    super.key,
  });

  /// Reordenação por arraste. `null` desliga o arraste.
  ///
  /// Recebe `(origem, destino)` com o destino **já ajustado** para a remoção —
  /// é a semântica do `onReorderItem`. Quem trata não precisa descontar nada.
  ///
  /// **Exige `Overlay` e `Localizations` acima** — o primeiro é onde o proxy do
  /// arraste é pintado, o segundo alimenta os anúncios de acessibilidade. Num
  /// app com `WidgetsApp`/`MaterialApp` os dois já estão lá.
  ///
  /// Ligado, a tira passa a rolar sozinha e ganha **auto-scroll** quando o
  /// ponteiro chega na borda durante o arraste — sem isso, reordenar seria
  /// impossível com mais abas do que cabem na largura.
  final void Function(int oldIndex, int newIndex)? onReorder;

  /// Slot à **esquerda da primeira aba** (ex.: o histórico de abas fechadas).
  ///
  /// Fica fora do scroll: some da vista junto com a primeira aba não seria
  /// aceitável para um controle permanente.
  final Widget? leading;

  /// Mostra o atalho da posição (1..N) no fim da aba.
  ///
  /// É o que torna a tecla **descoberta**: sem ela, o atalho fica só na
  /// documentação. Vai à esquerda do botão de fechar, onde o olho já procura
  /// por afordâncias secundárias.
  final bool showIndexHint;

  /// Relação com o conteúdo abaixo. Ver [AppWorkspaceTabsVariant].
  final AppWorkspaceTabsVariant variant;

  /// Piso de largura da aba. Abaixo dele a barra rola horizontalmente em vez
  /// de continuar espremendo.
  final double minTabWidth;

  /// Abas a exibir, na ordem.
  final List<AppWorkspaceTabItem> tabs;

  /// Id da aba ativa.
  final String? activeId;

  /// Chamado ao selecionar uma aba (recebe o id da aba clicada).
  final ValueChanged<String> onSelect;

  /// Chamado ao fechar uma aba (recebe o id da aba a fechar).
  final ValueChanged<String> onClose;

  /// Decoração do container (opcional). Quando informada, substitui o fundo e a
  /// linha separadora padrão.
  final BoxDecoration? decoration;

  @override
  State<AppWorkspaceTabs> createState() => _AppWorkspaceTabsState();
}

class _AppWorkspaceTabsState extends State<AppWorkspaceTabs> {
  /// Há uma aba sendo arrastada agora?
  ///
  /// Só para o cursor: durante o arraste ele vira "mão fechada". Sem isto o
  /// ponteiro continua com a mãozinha de clique enquanto a aba se move, e o
  /// gesto não confirma que está acontecendo.
  bool _isDragging = false;

  void _setDragging(bool value) {
    if (_isDragging == value) return;
    setState(() => _isDragging = value);
  }

  @override
  Widget build(BuildContext context) {
    // Com uma única aba, esconde o botão de fechar (sempre ≥ 1 aba aberta).
    final showClose = widget.tabs.length > 1;
    final theme = AppTheme.of(context);
    final colors = theme.colorTheme;
    final isAttached = widget.variant == AppWorkspaceTabsVariant.attached;

    // A linha que separa as abas do conteúdo. `DecoratedBox` e não `Container`:
    // a borda de um `Container` **recua o filho**, e a aba ativa passaria a
    // flutuar acima da linha em vez de interrompê-la. Pintada atrás, ela é
    // coberta pelo fundo opaco da aba ativa — é daí que vem a continuidade
    // entre a aba e a página.
    final barDecoration =
        widget.decoration ??
        (isAttached
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colors.divider,
                    width: AppStrokes.s,
                  ),
                ),
              )
            : const BoxDecoration());

    return MouseRegion(
      // `defer` fora do arraste: cada filho decide o seu cursor (a aba pede a
      // mãozinha de clique, o botão de fechar também). Durante o arraste esta
      // região vence e mostra a mão fechada — sem isso o ponteiro continua
      // dizendo "clique" enquanto a aba se move.
      cursor: _isDragging ? SystemMouseCursors.grabbing : MouseCursor.defer,
      child: DecoratedBox(
        decoration: barDecoration,
        child: SizedBox(
          height: _barHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabCount = widget.tabs.length;
              // Sem abas: nada a desenhar (evita divisão por zero abaixo).
              if (tabCount == 0) return const SizedBox.shrink();

              // Espaço útil descontando o padding horizontal e os gaps entre abas.
              final barPadding = isAttached
                  ? _barHorizontalPaddingAttached
                  : _barHorizontalPaddingInset;
              final horizontalPadding = barPadding * 2;
              final totalGaps = _tabGap * (tabCount - 1);
              final maxWidth = widget.leading == null
                  ? constraints.maxWidth
                  : constraints.maxWidth - _leadingSlotWidth;
              final available = maxWidth.isFinite
                  ? math.max(0.0, maxWidth - horizontalPadding - totalGaps)
                  : _tabMaxWidth * tabCount;

              // Cada aba parte de 192px e encolhe para caber — mas só até
              // [widget.minTabWidth]. Abaixo desse piso o texto vira um borrão, então a
              // barra passa a rolar em vez de continuar espremendo.
              final fittedWidth = math.min(_tabMaxWidth, available / tabCount);
              final needsScroll = fittedWidth < widget.minTabWidth;
              final tabWidth = needsScroll ? widget.minTabWidth : fittedWidth;

              Widget chipAt(int index) {
                final tab = widget.tabs[index];
                return SizedBox(
                  key: ValueKey(tab.id),
                  width: tabWidth,
                  child: _WorkspaceTabChip(
                    item: tab,
                    isActive: tab.id == widget.activeId,
                    showClose: showClose,
                    variant: widget.variant,
                    indexHint: widget.showIndexHint ? index + 1 : null,
                    onSelect: () => widget.onSelect(tab.id),
                    onClose: () => widget.onClose(tab.id),
                  ),
                );
              }

              final chips = <Widget>[
                for (int i = 0; i < tabCount; i++) chipAt(i),
              ];

              final padding = EdgeInsets.symmetric(horizontal: barPadding);

              // Com arraste, a tira vira uma lista reordenável horizontal. Ela
              // já rola sozinha — inclusive AUTO-SCROLL quando o ponteiro chega
              // na borda durante o arraste, que é o que salva a reordenação
              // quando as abas não cabem na largura.
              final Widget strip = widget.onReorder != null
                  ? ReorderableList(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: barPadding),
                      itemCount: tabCount,
                      onReorderItem: widget.onReorder!,
                      onReorderStart: (_) => _setDragging(true),
                      onReorderEnd: (_) => _setDragging(false),
                      // O proxy do arraste é pintado no OVERLAY, que fica acima
                      // desta árvore — e portanto fora do `AppTheme`. Reprover o
                      // tema capturado aqui é a mesma receita do `AppOverlayScope`
                      // nos dialogs; sem ela a aba arrastada não acha o tema.
                      // Sem decoração do Material: a aba arrastada é ela mesma,
                      // só destacada por opacidade.
                      proxyDecorator: (child, index, animation) => AppTheme(
                        data: theme,
                        child: Opacity(opacity: 0.85, child: child),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final Widget chip = chipAt(index);
                        return ReorderableDragStartListener(
                          key: chip.key,
                          index: index,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index == tabCount - 1 ? 0 : _tabGap,
                            ),
                            child: chip,
                          ),
                        );
                      },
                    )
                  : needsScroll
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: padding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: _tabGap,
                        children: chips,
                      ),
                    )
                  : Padding(
                      padding: padding,
                      // Alinhadas à esquerda: a sobra de espaço fica à direita
                      // (requisito 6 — sem centralizar nem esticar).
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: _tabGap,
                        children: [
                          // `Flexible` com `FlexFit.loose` impede qualquer
                          // overflow: a aba pede `tabWidth`, mas nunca excede o
                          // espaço da Row.
                          for (final chip in chips) Flexible(child: chip),
                        ],
                      ),
                    );

              if (widget.leading == null) return strip;

              // Fora do scroll: um controle permanente não pode sumir de vista
              // junto com a primeira aba.
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // `Center` e não o filho direto: o `SizedBox` impõe largura
                  // FIRME, e sem ele o conteúdo do slot esticava para os
                  // 60px — a área clicável ficava maior que o desenho.
                  SizedBox(
                    width: _leadingSlotWidth,
                    child: Center(child: widget.leading),
                  ),
                  Expanded(child: strip),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WorkspaceTabChip extends StatefulWidget {
  const _WorkspaceTabChip({
    required this.item,
    required this.isActive,
    required this.showClose,
    required this.variant,
    required this.indexHint,
    required this.onSelect,
    required this.onClose,
  });

  final AppWorkspaceTabItem item;
  final bool isActive;
  final bool showClose;
  final AppWorkspaceTabsVariant variant;

  /// Número da posição (1..N), ou `null` para não exibir.
  final int? indexHint;
  final VoidCallback onSelect;
  final VoidCallback onClose;

  @override
  State<_WorkspaceTabChip> createState() => _WorkspaceTabChipState();
}

class _WorkspaceTabChipState extends State<_WorkspaceTabChip> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colorTheme;
    final isActive = widget.isActive;

    // Todas as cores são resolvidas contra o `surfaceContainer`: a barra de
    // abas vive DENTRO do cartão, e é ele que está atrás tanto do texto das
    // inativas quanto do fundo da ativa.
    //
    // O inativo era `neutralPrimary.s500` fixo — o mesmo stop nos dois temas
    // (tom 51.3 em ambos). Sobre a `surface` funcionava; sobre o cartão dava
    // 4.12 no claro e **2.02** no escuro, ou seja, título de aba ilegível.
    // Derivar resolve os dois temas e as duas marcas de uma vez.
    // O hover é `onSurface`, o extremo da rampa. Era `neutralPrimary.s700` —
    // e derivar o inativo passou a cair EXATAMENTE nesse stop, então o hover
    // deixaria de ter efeito. O realce precisa ser sempre um passo além do
    // repouso, não um valor fixo que por acaso o ultrapassava.
    final Color foreground = isActive
        ? readableStopOn(
            colors.tertiary,
            colors.surfaceContainer,
            minRatio: kAaNormal,
          )
        : _isHovered
        ? colors.onSurface
        : readableStopOn(
            colors.neutralPrimary,
            colors.surfaceContainer,
            minRatio: kAaNormal,
          );

    // Só a aba ATIVA tem preenchimento: fundo = `surfaceContainer`, a mesma
    // superfície elevada do painel de conteúdo do shell, para a aba encostar/
    // conectar na página. Inativas transparentes.
    // `attached` usa `surfaceContainer` para a aba continuar o painel abaixo.
    // `inset` já vive SOBRE `surfaceContainer`, então precisa de um tom que se
    // destaque dele — senão a aba ativa some no fundo do cartão.
    // Inativa em hover ganha um fundo translúcido — na MESMA silhueta que a
    // borda da ativa desenha, já que a forma é a mesma nos dois estados. Só o
    // texto clareando deixava o alvo do ponteiro implícito; com o fundo, o
    // realce tem a área que o clique tem.
    final Color backgroundColor = !isActive
        ? (_isHovered
              ? colors.onSurface.customOpacity(0.08)
              : colors.transparent)
        : widget.variant == AppWorkspaceTabsVariant.attached
        ? colors.surfaceContainer
        : colors.neutralPrimary.s500.customOpacity(0.10);

    final isAttached = widget.variant == AppWorkspaceTabsVariant.attached;

    // A silhueta de navegador vale para ATIVA E INATIVA no `attached`. Duas
    // formas diferentes trariam dois problemas: a geometria mudaria no clique
    // (a aba parecia encolher ao ser selecionada) e o `AnimatedContainer` não
    // interpola entre `ShapeDecoration` e `BoxDecoration` — a cor e a borda
    // saltavam em vez de aparecer.
    final Decoration decoration = isAttached
        ? ShapeDecoration(
            color: backgroundColor,
            shape: WorkspaceTabShape(
              radius: _activeTopRadius,
              wingRadius: _activeWingRadius,
              // `divider` (onSurface@10%), igual ao painel do shell e à nav
              // rail. Transparente na inativa: some sem mudar a forma, então a
              // transição é só de cor.
              side: BorderSide(
                color: isActive ? colors.divider : colors.transparent,
                width: AppStrokes.s,
              ),
            ),
          )
        : BoxDecoration(
            color: backgroundColor,
            borderRadius: theme.radiusTheme.resolve(),
          );

    // Desativa a seleção de texto dentro da aba (há um SelectionArea ancestral):
    // sem isso, clicar/arrastar no título seleciona o texto em vez de selecionar
    // a aba. Mesmo padrão da AppNavigationRail e dos footers.
    // Regra 8: a aba é SELECIONÁVEL, e a seleção precisa existir fora do
    // pixel. Sem `selected` o leitor lê a barra como botões iguais — a ativa
    // se distingue só pela cor e pelas asas, que ninguém ouve.
    return Semantics(
      container: true,
      button: true,
      selected: isActive,
      onTap: widget.onSelect,
      child: SelectionContainer.disabled(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => _setHovered(true),
          onExit: (_) => _setHovered(false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onSelect,
            child: AnimatedContainer(
              duration: AppMotion.resolve(context, _hoverAnimationDuration),
              // Folga de 4px em cima: colada na borda do cartão a aba perdia o
              // arredondamento contra o canto arredondado dele. Embaixo depende
              // da VARIANTE, nunca do estado: no `attached` as asas precisam
              // alcançar a linha do conteúdo, no `inset` a pílula flutua. Se
              // dependesse da seleção, a aba mudaria de altura no clique.
              margin: EdgeInsets.only(
                top: AppSpacings.s4,
                bottom: isAttached ? AppSpacings.s0 : AppSpacings.s2,
              ),
              // Padding interno: horizontal para respiro lateral e vertical maior
              // para uma área clicável mais alta (requisito 3).
              // Horizontal maior no formato de aba (as asas consomem as pontas),
              // mas IGUAL nos dois estados: quando dependia da seleção, o texto
              // perdia 16px de largura ao clicar e a aba parecia encolher.
              padding: EdgeInsets.symmetric(
                horizontal: isAttached
                    ? AppSpacings.s8 + _activeWingRadius
                    : AppSpacings.s8,
                vertical: _tabVerticalPadding,
              ),
              decoration: decoration,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  AppIcon(
                    widget.item.icon,
                    color: foreground,
                    size: AppIconSize.s,
                  ),
                  const SizedBox(width: AppSpacings.s4),
                  // O título é o único elemento que encolhe e faz fade; ícone e X
                  // permanecem sempre visíveis.
                  Expanded(
                    child: _FadingTitle(
                      text: widget.item.title,
                      style: theme.textTheme.bodyMedium.copyWith(
                        color: foreground,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  // Atalho antes do fechar: a tecla que traz esta aba.
                  if (widget.indexHint != null) ...[
                    const SizedBox(width: AppSpacings.s8),
                    AppShortcutHint(AppShortcut('${widget.indexHint}')),
                  ],
                  if (widget.showClose) ...[
                    const SizedBox(width: AppSpacings.s8),
                    _CloseButton(color: foreground, onTap: widget.onClose),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Título de aba em uma única linha. Quando — e somente quando — o texto
/// transborda a largura disponível, aplica um degradê de opaco para
/// transparente na borda direita (fade) em vez de reticências (requisito 5),
/// via [ShaderMask] com [BlendMode.dstIn]. Sem overflow, renderiza o texto puro
/// (evitando o custo de uma camada de `saveLayer`).
class _FadingTitle extends StatelessWidget {
  const _FadingTitle({required this.text, required this.style});

  final String text;
  final TextStyle style;

  /// Mede a largura intrínseca de [text] com [style] para decidir se ele
  /// transborda o espaço de [maxWidth].
  bool _overflows(double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    final overflows = painter.width > maxWidth;
    painter.dispose();
    return overflows;
  }

  @override
  Widget build(BuildContext context) {
    final label = AppText(
      text,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.clip,
      style: style,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Só aplica o fade quando o título realmente não cabe (requisito 5).
        if (!width.isFinite || width <= 0 || !_overflows(width)) {
          return label;
        }

        // Fração final do texto que recebe o degradê. Limitada para não "comer"
        // o título inteiro quando a aba está bem estreita.
        final fadeFraction = (_titleFadeWidth / width).clamp(0.0, 0.5);
        final fadeStart = 1.0 - fadeFraction;

        return ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, fadeStart, 1.0],
              colors: const [
                Color(0xFFFFFFFF), // opaco
                Color(0xFFFFFFFF), // opaco até o início do fade
                Color(0x00FFFFFF), // transparente na borda direita
              ],
            ).createShader(bounds);
          },
          child: label,
        );
      },
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTheme colors = AppTheme.of(context).colorTheme;

    // O X é só-ícone: sem `label` explícito ele chegaria mudo ao leitor de
    // tela, e "fechar" é justamente a ação que não se descobre tateando.
    return AppSemantics.button(
      label: 'Fechar aba',
      enabled: true,
      onTap: onTap,
      // O primitivo tem gesto PRÓPRIO: clicar no X não dispara o onSelect da
      // aba embaixo. E, de quebra, o X passa a ser alcançável por Tab.
      child: FlocksInteraction(
        onPressed: onTap,
        builder: (BuildContext context, Set<WidgetState> states) {
          final bool hovered = states.contains(WidgetState.hovered);
          final bool pressed = states.contains(WidgetState.pressed);
          return AnimatedContainer(
            duration: AppMotion.resolve(context, _hoverAnimationDuration),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pressed
                  ? color.customOpacity(0.22)
                  : hovered
                  ? color.customOpacity(0.14)
                  : colors.transparent,
            ),
            // Anel por cima: a borda de um Container entra no layout e
            // engordaria o X, empurrando o título da aba.
            foregroundDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: states.contains(WidgetState.focused)
                    ? colors.focusRing
                    : colors.transparent,
                width: AppStrokes.m,
              ),
            ),
            padding: const EdgeInsets.all(AppSpacings.s2),
            child: AppIcon(AppIconToken.cancel, color: color, customSize: 14),
          );
        },
      ),
    );
  }
}
