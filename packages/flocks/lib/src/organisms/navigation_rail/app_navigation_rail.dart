import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../atoms/atoms.dart';
import '../../molecules/interactive/interactive.dart';
import '../../molecules/tooltip/tooltip.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

const _animationCurve = AppCurves.standard;
const _animationDuration = AppDurations.medium;
const _collapsedWidth = 81.0;
const _itemInnerPadding = 12.0;
const _expandedWidth = 288.0;

/// Altura de um tile do rail (mais compacto que o antigo 48).
const _itemHeight = 40.0;

/// Inset lateral que centra o quadrado de [_itemHeight] no rail colapsado.
///
/// Exposto para o [AppNavigationRailFilter] usar o mesmo valor: as duas linhas
/// precisam de área clicável idêntica quando só o ícone aparece.
const double kAppNavigationRailCollapsedInset =
    (_collapsedWidth - _itemHeight) / 2;

const _collapsedInset = kAppNavigationRailCollapsedInset;

/// Tamanho do quadrado clicável no estado colapsado.
const double kAppNavigationRailCollapsedTile = _itemHeight;

/// Distância da borda do rail até o CONTEÚDO de um item expandido.
///
/// É a soma da margem da pílula com o padding interno dela. Exposta para quem
/// precisa alinhar algo ao ícone dos itens — a logo do header, por exemplo:
/// mirar na borda do rail deixaria a marca 12px à esquerda dos ícones.
const double kAppNavigationRailItemContentInset =
    AppSpacings.s16 + _itemInnerPadding;

/// Larguras do rail, para quem precisa alinhar algo à coluna do conteúdo.
const double kAppNavigationRailCollapsedWidth = _collapsedWidth;
const double kAppNavigationRailExpandedWidth = _expandedWidth;

/// Diâmetro do chevron flutuante que colapsa/expande o rail (borda direita).
const _floatingToggleSize = 28.0;

/// Gutter reservado à direita para o chevron flutuante ficar metade sobre o
/// rail e metade fora, mas ainda dentro do footprint do componente (clicável
/// por inteiro e sem ser coberto pelo conteúdo ao lado).
const _railGutter = _floatingToggleSize / 2;

/// Altura do bloco de header (logo).
const _headerHeight = 56.0;

/// Altura da logo expandida (SVG) e tamanho da marca colapsada (ícone).
const _expandedLogoHeight = 32.0;
const _collapsedLogoSize = 40.0;

/// Size in logical pixels for the leading icon of a navigation rail item.
const _itemIconSize = 20.0;

/// Largura mínima do conteúdo de um tile (ícone + folga p/ trailing). Serve de
/// piso quando o rail está estreito (transição colapsar↔expandir) para a linha
/// não estourar; o excedente é cortado pelo clip do rail e a pílula continua do
/// tamanho real (é do container externo).
const _itemMinContentWidth = _itemIconSize + AppSpacings.s16;

/// Expõe o estado colapsado do rail para os descendentes (footer, perfil,
/// itens no slot de footer) — assim o conteúdo do footer colapsa sozinho sem o
/// consumidor precisar propagar `isCollapsed`.
final class AppNavigationRailScope extends InheritedWidget {
  const AppNavigationRailScope({
    required this.isCollapsed,
    required super.child,
    this.onToggleCollapsed,
    super.key,
  });

  /// Rail está no modo colapsado (estreito, só ícones).
  final bool isCollapsed;

  /// Alterna o colapso. Disponível para o slot `footer`, que é construído pelo
  /// app e portanto não alcança o `State` do rail.
  final VoidCallback? onToggleCollapsed;

  /// Lê o estado colapsado do rail ancestral (`false` se não houver um).
  static bool isCollapsedOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppNavigationRailScope>();
    return scope?.isCollapsed ?? false;
  }

  /// Alternador de colapso do rail ancestral (`null` se não houver um).
  ///
  /// É o que permite pôr "Recolher menu" como um item do rodapé, em vez do
  /// chevron flutuante na aresta.
  static VoidCallback? toggleOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppNavigationRailScope>();
    return scope?.onToggleCollapsed;
  }

  @override
  bool updateShouldNotify(AppNavigationRailScope oldWidget) =>
      isCollapsed != oldWidget.isCollapsed ||
      onToggleCollapsed != oldWidget.onToggleCollapsed;
}

/// Dados de um item do rail de navegação.
final class AppNavigationRailItemData {
  const AppNavigationRailItemData({
    required this.icon,
    required this.onPressed,
    required this.route,
    this.activeIcon,
    this.children,
    this.title,
  });

  /// Subitens agrupados (opcional); se não nulo, o item abre nível interno.
  final List<AppNavigationRailItemData>? children;

  /// Ícone do item.
  final String icon;

  /// Ícone alternativo exibido **enquanto o item está selecionado** (ex.: a
  /// variante preenchida de [icon]). `null` = [icon] serve aos dois estados.
  /// Fora da seleção, [icon] continua sendo o slug renderizado — [activeIcon]
  /// nunca aparece em item não selecionado. Num item-pai ([children]), vale
  /// quando o pai OU qualquer filho casa com a rota — o mesmo sinal que pinta
  /// ícone e título com o accent.
  final String? activeIcon;

  /// Callback ao pressionar (context, route).
  final void Function(BuildContext context, String route) onPressed;

  /// Rota associada ao item.
  final String route;

  /// Título (usado como tooltip).
  final String? title;
}

/// Item do rail de navegação (ícone + título no modo expandido).
final class AppNavigationRailItem extends StatefulWidget {
  const AppNavigationRailItem({
    required this.icon,
    required this.onPressed,
    this.activeIcon,
    this.isCollapsed,
    this.isSelected = false,
    this.showSelectedBackground = true,
    this.title,
    this.trailing,
    super.key,
  });

  /// Ícone do item.
  final String icon;

  /// Ícone alternativo exibido enquanto [isSelected] é verdadeiro (ex.: a
  /// variante preenchida de [icon]). `null` = [icon] serve aos dois estados.
  final String? activeIcon;

  /// Item está no modo colapsado. Quando `null`, lê do
  /// [AppNavigationRailScope] ancestral (útil para itens no slot de footer).
  final bool? isCollapsed;

  /// Item está selecionado.
  final bool isSelected;

  /// Quando `false`, o background da pill não pinta mesmo com `isSelected`.
  /// As cores de ícone/texto/trailing continuam refletindo a seleção.
  /// Usado pelo header do tile pai para destacar pela cor (não pelo pill).
  final bool showSelectedBackground;

  /// Callback ao pressionar.
  final VoidCallback onPressed;

  /// Tooltip (opcional).
  final String? title;

  /// Widget opcional à direita (ex.: chevron de expansão).
  final Widget? trailing;

  @override
  State<AppNavigationRailItem> createState() => _AppNavigationRailItemState();
}

class _AppNavigationRailItemState extends State<AppNavigationRailItem> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isCollapsed =
        widget.isCollapsed ?? AppNavigationRailScope.isCollapsedOf(context);
    // Acento ativo = token oficial de accent (resolve `primary`/`primary.s400`
    // por brightness), correto para cada brand/tema (era `secondary` cru).
    final activeColor = theme.colorTheme.primaryAccent(
      isDark: theme.brightness == AppBrightness.dark,
    );
    final inactiveColor = theme.colorTheme.neutralPrimary.s500;
    final label = widget.title ?? '';
    final iconWidget = AppIcon(
      widget.isSelected ? (widget.activeIcon ?? widget.icon) : widget.icon,
      color: widget.isSelected ? activeColor : inactiveColor,
      customSize: _itemIconSize,
    );

    final showSolidBg = widget.isSelected && widget.showSelectedBackground;
    final hoverColor = widget.isSelected
        ? activeColor.customOpacity(.075)
        : inactiveColor.customOpacity(.075);
    final backgroundColor = showSolidBg
        ? activeColor.customOpacity(.15)
        : _isHovered
        ? hoverColor
        : theme.colorTheme.transparent;

    final child = SelectionContainer.disabled(
      child: AnimatedContainer(
        curve: _animationCurve,
        duration: AppMotion.resolve(context, _animationDuration),
        height: _itemHeight,
        // Colapsado, a pílula vira um QUADRADO centrado no rail: a área
        // clicável (e o hover) fica idêntica em todas as linhas, inclusive nas
        // que têm duas linhas de texto quando expandidas. Esticar até as
        // margens deixaria retângulos de larguras diferentes conforme o
        // conteúdo — visível assim que o ponteiro passa.
        width: isCollapsed ? _itemHeight : null,
        margin: EdgeInsets.symmetric(
          horizontal: isCollapsed ? _collapsedInset : AppSpacings.s16,
          vertical: AppSpacings.s2,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isCollapsed ? AppSpacings.s0 : _itemInnerPadding,
        ),
        decoration: BoxDecoration(
          // Pill de hover/seleção segue o eixo de raio global (reto/redondo/
          // circular) em vez de um raio fixo.
          borderRadius: theme.radiusTheme.resolve(
            size: const Size(double.infinity, _itemHeight),
          ),
          color: backgroundColor,
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => _setHovered(true),
          onExit: (_) => _setHovered(false),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onPressed,
            // No quadrado colapsado o ícone fica centrado; alinhá-lo à
            // esquerda o deixaria fora do eixo da pílula.
            child: isCollapsed
                ? Center(
                    child: SizedBox.square(
                      dimension: _itemIconSize,
                      child: iconWidget,
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final double contentWidth =
                          constraints.maxWidth > _itemMinContentWidth
                          ? constraints.maxWidth
                          : _itemMinContentWidth;
                      return OverflowBox(
                        minWidth: contentWidth,
                        maxWidth: contentWidth,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox.square(
                              dimension: _itemIconSize,
                              child: iconWidget,
                            ),
                            _AppNavigationRailAnimatedLabel(
                              isCollapsed: isCollapsed,
                              label: label,
                              spacing: AppSpacings.s16,
                              style: theme.textTheme.bodyMedium.copyWith(
                                color: widget.isSelected
                                    ? activeColor
                                    : inactiveColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (widget.trailing != null)
                              _AppNavigationRailAnimatedTrailing(
                                isCollapsed: isCollapsed,
                                child: widget.trailing!,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );

    if (isCollapsed && widget.title != null && widget.title!.isNotEmpty) {
      return AppTooltip(message: widget.title!, child: child);
    }
    return child;
  }
}

/// Item pai expansível do rail: header reusa [AppNavigationRailItem] e
/// renderiza os filhos abaixo com animação push-down (AnimatedSize +
/// heightFactor), espelhando o padrão do [AppExpansionTile].
final class _AppNavigationRailParentItem extends StatelessWidget {
  const _AppNavigationRailParentItem({
    required this.icon,
    required this.isCollapsed,
    required this.isExpanded,
    required this.isSelected,
    required this.onHeaderPressed,
    required this.children,
    this.activeIcon,
    this.title,
  });

  final String icon;
  final String? activeIcon;
  final bool isCollapsed;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onHeaderPressed;
  final List<Widget> children;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final chevronColor = isSelected
        ? theme.colorTheme.primaryAccent(
            isDark: theme.brightness == AppBrightness.dark,
          )
        : theme.colorTheme.neutralPrimary.s500;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppNavigationRailItem(
          icon: icon,
          activeIcon: activeIcon,
          isCollapsed: isCollapsed,
          isSelected: isSelected,
          showSelectedBackground: false,
          onPressed: onHeaderPressed,
          title: title,
          trailing: AnimatedRotation(
            curve: _animationCurve,
            duration: AppMotion.resolve(context, _animationDuration),
            turns: isExpanded ? .5 : 0,
            child: AppIcon(
              AppIconToken.chevronDown,
              color: chevronColor,
              size: AppIconSize.s,
            ),
          ),
        ),
        ClipRect(
          child: AnimatedSize(
            alignment: Alignment.topCenter,
            curve: _animationCurve,
            duration: AppMotion.resolve(context, _animationDuration),
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: isExpanded && !isCollapsed ? 1 : 0,
              child: isExpanded && !isCollapsed
                  ? Padding(
                      padding: const EdgeInsets.only(left: AppSpacings.s16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: children,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}

final class _AppNavigationRailAnimatedLabel extends StatelessWidget {
  const _AppNavigationRailAnimatedLabel({
    required this.isCollapsed,
    required this.label,
    required this.spacing,
    required this.style,
  });

  final bool isCollapsed;
  final String label;
  final double spacing;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TweenAnimationBuilder<double>(
        curve: _animationCurve,
        duration: AppMotion.resolve(context, _animationDuration),
        tween: Tween<double>(begin: 0, end: isCollapsed ? 0 : 1),
        child: AppText(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: style,
        ),
        builder: (context, value, child) {
          return ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: Opacity(
                opacity: value,
                child: Padding(
                  padding: EdgeInsets.only(left: spacing * value),
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

final class _AppNavigationRailAnimatedTrailing extends StatelessWidget {
  const _AppNavigationRailAnimatedTrailing({
    required this.isCollapsed,
    required this.child,
  });

  final bool isCollapsed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: _animationCurve,
      duration: AppMotion.resolve(context, _animationDuration),
      tween: Tween<double>(begin: 0, end: isCollapsed ? 0 : 1),
      child: child,
      builder: (context, value, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.centerRight,
            widthFactor: value,
            child: Opacity(opacity: value, child: child),
          ),
        );
      },
    );
  }
}

/// Chevron circular flutuante na borda direita do rail (metade dentro, metade
/// fora) que colapsa/expande. Substitui o antigo botão do footer e é a única
/// marca de borda depois que a `BorderSide` direita foi removida.
final class _AppNavigationRailFloatingToggle extends StatelessWidget {
  const _AppNavigationRailFloatingToggle({
    required this.isCollapsed,
    required this.onPressed,
  });

  final bool isCollapsed;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isDark = theme.brightness == AppBrightness.dark;
    final label = isCollapsed ? 'Expandir menu' : 'Recolher menu';

    return SelectionContainer.disabled(
      child: AppInteraction(
        onTap: onPressed,
        tooltip: isCollapsed ? 'Abrir' : 'Fechar',
        semanticLabel: label,
        radius: BorderRadius.circular(_floatingToggleSize),
        child: SizedBox.square(
          dimension: _floatingToggleSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorTheme.surfaceContainer,
              border: Border.all(
                color: theme.colorTheme.divider,
                width: AppStrokes.m,
              ),
              boxShadow: AppElevation.symmetricShadows(isDark),
            ),
            child: Center(
              child: AppIcon(
                isCollapsed
                    ? AppIconToken.chevronRight
                    : AppIconToken.chevronLeft,
                color: theme.colorTheme.neutralPrimary.s600,
                size: AppIconSize.s,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rail de navegação lateral (vertical) para desktop.
///
/// Itens com `children` expandem os filhos abaixo (push-down) em modo
/// accordion: abrir um pai fecha o anterior. Quando o rail está colapsado,
/// tocar num pai expande o rail e abre o tile.
///
/// ## Colapso
///
/// Por padrão vem o chevron circular flutuante na borda direita. Um shell que
/// prefira oferecer o colapso como uma linha do rodapé ("Recolher menu") passa
/// `showFloatingToggle: false` e chama [AppNavigationRailScope.toggleOf] de
/// dentro do [footer].
///
/// ## Logo
///
/// Dois canais, mutuamente exclusivos: os slugs/URLs legados ([logoCollapsed]/
/// [logoExpanded]) ou os slots de widget ([logo]/[logoCompact] +
/// [logoSemanticLabel]). Sem nenhum dos dois, o bloco de logo some e os itens
/// sobem — use quando o shell põe a marca no header.
final class AppNavigationRail extends StatefulWidget {
  const AppNavigationRail({
    required this.getCurrentRoute,
    required this.items,
    this.logoCollapsed,
    this.decoration,
    this.footer,
    this.logoExpanded,
    this.logo,
    this.logoCompact,
    this.logoSemanticLabel,
    this.showFooterDivider = true,
    this.showFloatingToggle = true,
    this.initiallyCollapsed = false,
    this.onCollapsedChanged,
    super.key,
  }) : assert(
         (logo == null && logoCompact == null) ||
             (logoCollapsed == null && logoExpanded == null),
         'Use UM canal de logo: os slots Widget (logo/logoCompact) OU os '
         'slugs legados (logoCollapsed/logoExpanded), nunca os dois.',
       ),
       assert(
         (logo == null && logoCompact == null) || logoSemanticLabel != null,
         'logo/logoCompact exigem logoSemanticLabel: o slot Widget entra na '
         'árvore de semântica e precisa nomear a marca ao leitor de tela.',
       );

  /// Estado do rail enquanto o usuário não mexer nele.
  ///
  /// Não é "só no primeiro build": quem fornece este valor costuma carregá-lo
  /// de forma **assíncrona** (uma preferência salva), e no primeiro build ainda
  /// está o padrão. Ignorar a chegada do valor real faria a preferência nunca
  /// valer.
  ///
  /// A partir do primeiro toque do usuário no colapso, ele manda — mudanças
  /// posteriores daqui são ignoradas, senão um `⌘B` seria desfeito.
  final bool initiallyCollapsed;

  /// Avisa quando o colapso muda.
  ///
  /// O shell usa isto para alinhar a barra superior à coluna do conteúdo: sem
  /// saber a largura do rail, a busca ficaria fora do eixo ao colapsar.
  final ValueChanged<bool>? onCollapsedChanged;

  /// Exibe o chevron circular flutuante que alterna o colapso.
  ///
  /// `false` quando o colapso é oferecido de outro jeito (ex.: item no rodapé).
  final bool showFloatingToggle;

  /// Decoração do container (opcional).
  final BoxDecoration? decoration;

  /// Slot de footer genérico, renderizado abaixo dos itens (ex.: Suporte +
  /// linha de perfil). O conteúdo lê o estado colapsado via
  /// [AppNavigationRailScope]. `null` = sem footer.
  final Widget? footer;

  /// Função que retorna a rota atual (path).
  final String Function(BuildContext context) getCurrentRoute;

  /// Itens do rail.
  final List<AppNavigationRailItemData> items;

  /// Logo exibida quando o rail está colapsado.
  ///
  /// `null` remove o bloco de logo — use quando a marca vive no header do
  /// shell e o rail começa direto nos itens.
  final String? logoCollapsed;

  /// Logo exibida quando o rail está expandido (opcional).
  ///
  /// Se não informada, usa [logoCollapsed] também no estado expandido.
  final String? logoExpanded;

  /// Marca como **widget**, para o SVG/imagem que vive no bundle do app (o
  /// canal de slug exige provider de ícone; o de URL, rede). Usada no rail
  /// expandido; colapsado cai em [logoCompact] ?? [logo] — fallback simétrico
  /// de propósito: dois widgets são intercambiáveis, e "declarei a marca e o
  /// rail a esconde ao colapsar" seria armadilha.
  ///
  /// Semântica: o idioma é o do [AppImage] — a subárvore do widget é
  /// **substituída** pelo nó de imagem nomeado por [logoSemanticLabel]
  /// (`ExcludeSemantics` por dentro). Um leitor anuncia a marca uma vez, sem
  /// duplicar com o texto interno do widget; logo interativo não pertence a
  /// este slot (é caso do header do shell). O slot espera widget com tamanho
  /// intrínseco (imagem, SVG, texto): ele é encaixado por
  /// `FittedBox(scaleDown)` na faixa de 56px do header — maior encolhe, menor
  /// fica intacto.
  final Widget? logo;

  /// Variante compacta da marca (a marca quadrada) para o rail colapsado.
  /// Expandido sem [logo], é ela que aparece ([logo] ?? [logoCompact]).
  final Widget? logoCompact;

  /// Nome acessível da marca quando o logo vem por widget. Obrigatório junto
  /// com [logo]/[logoCompact] (assert) — é a regra da casa: slot de widget só
  /// entra com o rótulo semântico como parâmetro.
  final String? logoSemanticLabel;

  /// Mostra um [AppDivider] entre os itens e o [footer]. Ignorado sem footer.
  final bool showFooterDivider;

  @override
  State<AppNavigationRail> createState() => AppNavigationRailState();
}

/// Estado do [AppNavigationRail].
final class AppNavigationRailState extends State<AppNavigationRail> {
  /// Route do único pai atualmente expandido (accordion). `null` se nenhum.
  String? _expandedRoute;

  /// Controla colapso/expansão visual da rail.
  late bool _isCollapsed = widget.initiallyCollapsed;

  @override
  void didUpdateWidget(AppNavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Adota o valor novo só enquanto o usuário não tomou o controle. É o que
    // deixa uma preferência carregada depois do primeiro frame chegar ao rail.
    if (_didUserInteract) return;
    if (widget.initiallyCollapsed == oldWidget.initiallyCollapsed) return;
    setState(() => _isCollapsed = widget.initiallyCollapsed);
    // Pós-frame: `didUpdateWidget` roda DENTRO do build do pai, e avisar ali
    // faria o pai chamar `setState` durante o próprio build.
    final bool collapsed = _isCollapsed;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onCollapsedChanged?.call(collapsed);
    });
  }

  /// O usuário já mexeu no rail (abriu/fechou grupo, colapsou)?
  ///
  /// Enquanto for `false`, o rail continua tentando semear o grupo a partir da
  /// rota. Isso conserta um bug real do deep-link: o primeiro build costuma
  /// acontecer **antes** da sessão carregar, quando [AppNavigationRail.items]
  /// ainda reflete o papel mais restrito e a rota atual não casa com nenhum
  /// item visível. Antes o rail marcava "já semeei" nesse instante e o grupo
  /// nunca mais abria — abrir o app por link direto deixava o menu fechado,
  /// sem indicar onde o usuário estava. Agora a semeadura reavalia quando os
  /// itens mudam, e só para quando o usuário assume o controle.
  bool _didUserInteract = false;

  /// Grupo semeado na última avaliação, para não relançar à toa.
  String? _seededRoute;

  bool _isParentSelected(AppNavigationRailItemData item, String currentRoute) {
    if (_isRouteSelected(currentRoute, item.route)) return true;
    final children = item.children;
    if (children == null) return false;
    for (final child in children) {
      if (_isRouteSelected(currentRoute, child.route)) return true;
    }
    return false;
  }

  bool _isRouteSelected(String currentRoute, String route) {
    if (currentRoute == route) return true;
    return currentRoute.startsWith('$route/');
  }

  /// Abre o grupo que contém [currentRoute], enquanto o usuário não interferiu.
  ///
  /// Idempotente: só mexe no estado quando encontra um grupo diferente do já
  /// semeado, para não brigar com o accordion a cada build.
  void _seedExpandedFromRoute(String currentRoute) {
    if (_didUserInteract) return;

    for (final item in widget.items) {
      final hasChildren = item.children?.isNotEmpty ?? false;
      if (hasChildren && _isParentSelected(item, currentRoute)) {
        if (_seededRoute == item.route) return;
        _seededRoute = item.route;
        _expandedRoute = item.route;
        final wasCollapsed = _isCollapsed;
        _isCollapsed = false;
        if (wasCollapsed) {
          // Fora do build: o shell reage à largura nova no frame seguinte.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) widget.onCollapsedChanged?.call(false);
          });
        }
        return;
      }
    }
  }

  void _onItemPressed(AppNavigationRailItemData item) {
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    if (hasChildren) {
      setState(() {
        _didUserInteract = true;
        if (_isCollapsed) {
          _isCollapsed = false;
          _expandedRoute = item.route;
        } else if (_expandedRoute == item.route) {
          _expandedRoute = null;
        } else {
          _expandedRoute = item.route;
        }
      });
      return;
    }
    item.onPressed(context, item.route);
  }

  /// Alterna o colapso do rail.
  ///
  /// Público porque o colapso pode ser acionado de fora — pelo item "Recolher
  /// menu" no rodapé, via [AppNavigationRailController].
  void toggleCollapsed() => _toggleCollapsed();

  /// O rail está colapsado?
  bool get isCollapsed => _isCollapsed;

  void _toggleCollapsed() {
    setState(() {
      _didUserInteract = true;
      final nextCollapsed = !_isCollapsed;
      _isCollapsed = nextCollapsed;
      if (nextCollapsed) {
        _expandedRoute = null;
      }
    });
    widget.onCollapsedChanged?.call(_isCollapsed);
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = widget.getCurrentRoute(context);
    _seedExpandedFromRoute(currentRoute);
    final theme = AppTheme.of(context);
    final railWidth = _isCollapsed ? _collapsedWidth : _expandedWidth;
    final realDecoration =
        widget.decoration ??
        BoxDecoration(
          // Superfície elevada (`surfaceContainer`), igual ao painel de conteúdo
          // do shell. A borda direita foi removida — o chevron flutuante marca a
          // aresta.
          color: theme.colorTheme.surfaceContainer,
        );

    final railBody = AnimatedContainer(
      curve: _animationCurve,
      decoration: realDecoration,
      duration: AppMotion.resolve(context, _animationDuration),
      clipBehavior: Clip.hardEdge,
      width: railWidth,
      child: AppNavigationRailScope(
        isCollapsed: _isCollapsed,
        onToggleCollapsed: _toggleCollapsed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacings.s16),
            // Sem logo (marca no header do shell) o bloco inteiro some e os
            // itens sobem — não fica um vão de 56px.
            if (widget.logoCollapsed != null ||
                widget.logo != null ||
                widget.logoCompact != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacings.s16,
                ),
                child: SizedBox(
                  height: _headerHeight,
                  child: Center(
                    child: widget.logoCollapsed != null
                        // Canal legado (slug/URL) — byte a byte o de sempre.
                        ? (_isCollapsed || widget.logoExpanded == null
                              ? AppIcon(
                                  widget.logoCollapsed!,
                                  customSize: _collapsedLogoSize,
                                )
                              : SvgPicture.network(
                                  widget.logoExpanded!,
                                  height: _expandedLogoHeight,
                                  fit: BoxFit.fitHeight,
                                ))
                        // Canal Widget: nó de imagem nomeado no idioma do
                        // AppImage (ExcludeSemantics por dentro — sem isso o
                        // rótulo mescla com o texto interno e o leitor anuncia
                        // a marca duas vezes). O FittedBox garante que a marca
                        // não estoura a faixa de 56px.
                        : Semantics(
                            image: true,
                            label: widget.logoSemanticLabel,
                            container: true,
                            child: ExcludeSemantics(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: _isCollapsed
                                    ? (widget.logoCompact ?? widget.logo!)
                                    : (widget.logo ?? widget.logoCompact!),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacings.s16),
            ],
            Expanded(
              child: ListView(
                children: widget.items.map((item) {
                  final hasChildren =
                      item.children != null && item.children!.isNotEmpty;
                  final isSelected = _isParentSelected(item, currentRoute);
                  if (hasChildren) {
                    final isExpanded = _expandedRoute == item.route;
                    return _AppNavigationRailParentItem(
                      icon: item.icon,
                      activeIcon: item.activeIcon,
                      isCollapsed: _isCollapsed,
                      isExpanded: isExpanded,
                      isSelected: isSelected,
                      onHeaderPressed: () => _onItemPressed(item),
                      title: item.title,
                      children: item.children!.map((child) {
                        return AppNavigationRailItem(
                          icon: child.icon,
                          activeIcon: child.activeIcon,
                          isCollapsed: _isCollapsed,
                          isSelected: _isRouteSelected(
                            currentRoute,
                            child.route,
                          ),
                          onPressed: () => _onItemPressed(child),
                          title: child.title,
                        );
                      }).toList(),
                    );
                  }
                  return AppNavigationRailItem(
                    icon: item.icon,
                    activeIcon: item.activeIcon,
                    isCollapsed: _isCollapsed,
                    isSelected: isSelected,
                    onPressed: () => _onItemPressed(item),
                    title: item.title,
                  );
                }).toList(),
              ),
            ),
            if (widget.footer != null) ...[
              if (widget.showFooterDivider)
                // Recuado dos dois lados: encostado nas bordas o traço parecia
                // cortar o rail em dois, em vez de separar dois blocos dele.
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.s4),
                  child: AppDivider(),
                ),
              // Sem padding horizontal: os filhos do footer (itens/perfil) já
              // trazem a mesma margem `s16` dos tiles do corpo, então o avatar/
              // ícone alinha com os ícones da lista.
              const SizedBox(height: AppSpacings.s8),
              widget.footer!,
              const SizedBox(height: AppSpacings.s12),
            ],
          ],
        ),
      ),
    );

    // O rail ocupa `railWidth`; o `_railGutter` à direita hospeda o chevron
    // flutuante (Stack dimensiona-se ao filho não-posicionado). Clip.none só
    // para a sombra do botão não ser cortada. Centralizado na vertical.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          // O gutter só existe para o chevron transbordar a aresta; sem ele o
          // rail encosta no conteúdo e a continuidade de superfície fica limpa.
          padding: EdgeInsets.only(
            right: widget.showFloatingToggle ? _railGutter : 0,
          ),
          child: railBody,
        ),
        if (widget.showFloatingToggle)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Center(
              child: RepaintBoundary(
                child: _AppNavigationRailFloatingToggle(
                  isCollapsed: _isCollapsed,
                  onPressed: _toggleCollapsed,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
