import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../molecules/interactive/interactive.dart';
import '../../molecules/tooltip/tooltip.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_navigation_rail.dart';

const _animationCurve = AppCurves.standard;
const _animationDuration = AppDurations.medium;

/// Inset horizontal do conteúdo, alinhando o ícone ao dos tiles do rail.
const _innerPadding = 12.0;

/// Tamanho do ícone — o mesmo dos tiles, para as colunas alinharem.
const _iconSize = 20.0;

/// Largura mínima do conteúdo, igual à dos tiles.
///
/// Durante a transição colapsar↔expandir o rail fica mais estreito que o
/// conteúdo; sem um piso, a linha estoura e o Flutter pinta a faixa de
/// overflow. O excedente é cortado pelo clip do próprio rail.
const _minContentWidth = _iconSize + AppSpacings.s16;

/// Altura da linha: rótulo + valor, mais o respiro vertical.
///
/// Fixa porque o [OverflowBox] que segura a largura mínima precisa de uma
/// altura limitada — dentro da `Column` do rail ele receberia infinito.
/// A MESMA altura do tile de menu (`_itemHeight`). O filtro tem duas linhas de
/// texto e por isso vinha mais alto — mas ele mora na mesma coluna que
/// "Suporte" e "Recolher menu", e a diferença aparecia como um degrau na pilha
/// (revisão P1r10). O par rótulo/valor é apertado logo abaixo para caber.
const _rowHeight = 40.0;

/// Rótulo padrão quando nenhum valor está selecionado.
const String kAppNavigationRailFilterAllLabel = 'Todos';

/// Linha de filtro para o rodapé do [AppNavigationRail]: ícone + nome do
/// filtro + valor selecionado.
///
/// É como um escopo global (conta, grupo, cliente) fica visível o tempo todo
/// sem ocupar a barra superior. O ícone é o **mesmo** que a entidade tem no
/// menu — quem olha reconhece na hora o que está filtrando.
///
/// Sem valor selecionado mostra [emptyLabel] ("Todos"), deixando explícito que
/// não há recorte em vigor — em vez de um espaço vazio ambíguo.
///
/// No modo colapsado sobra só o ícone, com o valor no tooltip. Lê o estado do
/// [AppNavigationRailScope] ancestral, como as outras linhas do rodapé.
final class AppNavigationRailFilter extends StatelessWidget {
  const AppNavigationRailFilter({
    required this.icon,
    required this.label,
    this.value,
    this.emptyLabel = kAppNavigationRailFilterAllLabel,
    this.onTap,
    this.enabled = true,
    this.isCollapsed,
    super.key,
  });

  /// Ícone da entidade filtrada — use o mesmo do item no menu.
  final String icon;

  /// Nome do filtro (ex.: "Grupo").
  final String label;

  /// Valor selecionado. `null` ou vazio mostra [emptyLabel].
  final String? value;

  /// Texto para "sem recorte". Ver [kAppNavigationRailFilterAllLabel].
  final String emptyLabel;

  /// Abre o seletor.
  final VoidCallback? onTap;

  /// `false` esmaece a linha e bloqueia o toque — para telas onde o filtro não
  /// se aplica (o valor exibido continua legível, explicando o estado).
  final bool enabled;

  /// Força o modo colapsado. `null` = lê do [AppNavigationRailScope].
  final bool? isCollapsed;

  bool get _hasValue => value != null && value!.trim().isNotEmpty;

  String get _displayValue => _hasValue ? value!.trim() : emptyLabel;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final collapsed =
        isCollapsed ?? AppNavigationRailScope.isCollapsedOf(context);
    // O rótulo ("Grupo") usa o MESMO cinza dos itens de menu, para a coluna
    // toda ler como uma família só. O valor — inclusive "Todos" — vai no tom
    // forte: é a informação que se procura ao bater o olho, e apagá-lo fazia
    // "Todos" desaparecer contra o rótulo.
    final labelIdle = theme.colorTheme.neutralPrimary.s500;
    final valueIdle = theme.colorTheme.neutralPrimary.s900;
    final disabled = theme.colorTheme.neutralPrimary.s400;

    final labelColor = enabled ? labelIdle : disabled;
    final valueColor = enabled ? valueIdle : disabled;

    final row = Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox.square(
          dimension: _iconSize,
          child: AppIcon(icon, color: labelColor, customSize: _iconSize),
        ),
        Expanded(
          child: _AnimatedReveal(
            isCollapsed: collapsed,
            spacing: AppSpacings.s12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  // `height` enxuto: o entrelinhas padrão abria um vão entre
                  // rótulo e valor que só fazia a linha crescer.
                  style: theme.textTheme.labelSmall
                      .withColor(labelColor)
                      .copyWith(height: 1.1),
                ),
                AppText(
                  _displayValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: theme.textTheme.bodyMedium.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    // Colapsado, a linha vira o MESMO quadrado dos tiles: sem isso, uma linha
    // de duas alturas de texto deixaria a área clicável maior que a dos itens
    // de menu — diferença que aparece assim que o ponteiro passa.
    final content = SelectionContainer.disabled(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: collapsed
              ? kAppNavigationRailCollapsedInset
              : AppSpacings.s16,
          vertical: AppSpacings.s2,
        ),
        child: AppInteraction(
          onTap: enabled ? onTap : null,
          semanticLabel: '$label: $_displayValue',
          // MESMO padding interno do tile de menu (que não tem vertical: a
          // altura fixa já dá o respiro). O `vertical` extra daqui era o que
          // fazia Conta/Grupo/Cliente ficarem mais altos que Suporte.
          padding: EdgeInsets.symmetric(
            horizontal: collapsed ? AppSpacings.s0 : _innerPadding,
          ),
          child: collapsed
              ? SizedBox.square(
                  dimension: kAppNavigationRailCollapsedTile,
                  child: Center(
                    child: AppIcon(
                      icon,
                      color: labelColor,
                      customSize: _iconSize,
                    ),
                  ),
                )
              // Expandido: piso de largura para a linha não estourar durante a
              // transição; o excedente é cortado pelo clip do rail.
              : SizedBox(
                  height: _rowHeight,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth > _minContentWidth
                          ? constraints.maxWidth
                          : _minContentWidth;
                      return OverflowBox(
                        minWidth: width,
                        maxWidth: width,
                        minHeight: _rowHeight,
                        maxHeight: _rowHeight,
                        alignment: Alignment.centerLeft,
                        child: row,
                      );
                    },
                  ),
                ),
        ),
      ),
    );

    // Colapsado só há o ícone: o tooltip é o único jeito de saber o recorte.
    if (!collapsed) return content;
    return AppTooltip(message: '$label: $_displayValue', child: content);
  }
}

/// Colapsa/expande um trecho horizontal, espelhando a animação dos tiles.
final class _AnimatedReveal extends StatelessWidget {
  const _AnimatedReveal({
    required this.isCollapsed,
    required this.spacing,
    required this.child,
  });

  final bool isCollapsed;
  final double spacing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: _animationCurve,
      duration: AppMotion.resolve(context, _animationDuration),
      tween: Tween<double>(begin: 0, end: isCollapsed ? 0 : 1),
      child: child,
      builder: (context, value, child) {
        if (value == 0) return const SizedBox.shrink();
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
    );
  }
}
