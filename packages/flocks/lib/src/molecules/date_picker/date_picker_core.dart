import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Intervalo de datas selecionado por [AppDateRangePicker].
///
/// [end] é `null` enquanto o usuário escolheu o início e ainda aguarda o fim
/// (estado intermediário que `DateTimeRange` do Material não expressa — e que
/// permitiria manter este primitivo do DS livre de `flutter/material`).
@immutable
final class AppDateRange {
  const AppDateRange(this.start, [this.end]);

  /// Primeiro dia do intervalo (sempre presente).
  final DateTime start;

  /// Último dia do intervalo, ou `null` enquanto o fim não foi escolhido.
  final DateTime? end;

  /// `true` se o intervalo está completo e [day] está entre [start] e [end]
  /// (inclusive nas pontas).
  bool contains(DateTime day) =>
      end != null && !day.isBefore(start) && !day.isAfter(end!);

  @override
  bool operator ==(Object other) =>
      other is AppDateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'AppDateRange($start, $end)';
}

/// Normaliza uma data para meia-noite (dia sem hora).
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Cor de texto de células/chevrons desabilitados, sensível ao brilho.
///
/// No dark theme `neutralPrimary.s200` fica escuro demais sobre a superfície;
/// um stop mais alto (`s400`) recupera contraste. No light mantém `s200`.
Color disabledDateColor(AppThemeData theme) =>
    theme.brightness == AppBrightness.dark
    ? theme.colorTheme.neutralPrimary.s400
    : theme.colorTheme.neutralPrimary.s200;

/// Fill do dia/mês/ano selecionado: um stop legível do `secondary` sobre a
/// superfície (contrasta em claro/escuro nas duas marcas).
Color selectedDateFill(AppThemeData theme) =>
    readableStopOn(theme.colorTheme.secondary, theme.colorTheme.surface);

/// Cor de texto de uma célula de calendário conforme seu estado.
Color dateCellTextColor(
  AppThemeData theme, {
  required bool isFilled,
  required bool isEnabled,
  required Color selectedFill,
}) {
  if (isFilled) return onColorFor(selectedFill);
  if (!isEnabled) return disabledDateColor(theme);
  return theme.colorTheme.neutralPrimary.s900;
}

/// Decoração (fill + hover + borda de "hoje") de uma célula de calendário.
///
/// [isFilled] pinta o pill selecionado; [isToday] compõe uma borda (que
/// convive com hover/in-range) exceto quando a célula já está preenchida.
BoxDecoration? dateCellDecoration(
  AppThemeData theme, {
  required bool isFilled,
  required bool isHovered,
  required bool isEnabled,
  required bool isToday,
  required Color selectedFill,
}) {
  final Color? fill = isFilled
      ? selectedFill
      : (isHovered && isEnabled)
      ? theme.colorTheme.neutralPrimary.s50.customOpacity(.5)
      : null;

  final Border? border = (isToday && !isFilled)
      ? Border.all(color: selectedFill, width: 1.5)
      : null;

  if (fill == null && border == null) return null;

  return BoxDecoration(
    borderRadius: theme.radiusTheme.resolve(),
    color: fill,
    border: border,
  );
}

/// Duração da micro-interação de seleção de uma célula do calendário.
///
/// Delega a decisão a [AppMotion.resolve]. A versão anterior recebia o
/// `AppThemeData` e consultava **só** `animationTheme.enabled` — o liga/desliga
/// do design system. Isso deixava de fora as duas fontes de *reduce motion* do
/// sistema operacional (`MediaQuery.disableAnimations` e
/// `accessibilityFeatures.reduceMotion`, esta última a única que o iOS seta):
/// com "Reduzir movimento" ligado, o calendário continuava animando.
Duration dateCellAnimation(BuildContext context) =>
    AppMotion.resolve(context, AppDurations.fast);

/// Header compartilhado do calendário: chevron ‹, label clicável, chevron ›.
///
/// Os três alvos são [FlocksInteraction]: hover, pressed, foco por teclado
/// (Tab + Enter/Space) e cursor de desabilitado saem do primitivo, e não de
/// `bool` paralelos no `State`. O `Row` é envolvido por um padding horizontal
/// de `cell * 0.08` para que as bordas externas das caixas dos chevrons
/// alinhem com a borda de conteúdo das colunas DOM/SAB do grid (mesmo inset
/// das células), evitando o overflow visual das setas.
class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    required this.theme,
    required this.cell,
    required this.label,
    required this.canGoBack,
    required this.canGoForward,
    required this.onBack,
    required this.onForward,
    required this.onLabelTap,
    super.key,
  });

  final bool canGoBack;
  final bool canGoForward;
  final double cell;
  final String label;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onLabelTap;
  final AppThemeData theme;

  @override
  Widget build(BuildContext context) {
    // Fixa o header na mesma largura do grid (7 colunas). Como o Column pai
    // centraliza, header e grid ficam alinhados mesmo quando o painel é forçado
    // a uma largura maior (ex.: AppPickerAnchor.matchTrigger) — sem isso o
    // `spaceBetween` espalharia os chevrons além do grid (o overflow relatado).
    return SizedBox(
      width: cell * 7,
      child: Padding(
        // O mesmo inset das células → borda externa do chevron alinha com a
        // borda de conteúdo das colunas DOM/SAB.
        padding: EdgeInsets.symmetric(horizontal: cell * 0.08),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _chevron(
              icon: AppIconToken.chevronLeft,
              semanticLabel: 'Mês anterior',
              enabled: canGoBack,
              onTap: onBack,
            ),
            _labelButton(),
            _chevron(
              icon: AppIconToken.chevronRight,
              semanticLabel: 'Próximo mês',
              enabled: canGoForward,
              onTap: onForward,
            ),
          ],
        ),
      ),
    );
  }

  /// Realce de hover/pressed comum aos três alvos do header.
  Color _overlay(Set<WidgetState> states) {
    final Color fill = theme.colorTheme.neutralPrimary.s50;
    if (states.contains(WidgetState.pressed)) return fill.customOpacity(.8);
    if (states.contains(WidgetState.hovered)) return fill.customOpacity(.5);
    return theme.colorTheme.transparent;
  }

  /// Caixa animada compartilhada: realce, anel de foco e raio do eixo.
  Widget _surface(
    BuildContext context,
    Set<WidgetState> states, {
    required EdgeInsets padding,
    required Widget child,
  }) => AnimatedContainer(
    duration: AppMotion.resolve(context, AppDurations.fast),
    curve: AppCurves.standard,
    padding: padding,
    decoration: BoxDecoration(
      borderRadius: theme.radiusTheme.resolve(),
      color: _overlay(states),
    ),
    // O anel vai em `foregroundDecoration`, não em `border`: a borda de um
    // `Container` entra no LAYOUT e engordaria a caixa em 4px, empurrando o
    // grid inteiro e desalinhando os chevrons das colunas DOM/SAB — o
    // alinhamento que o padding de `cell * 0.08` existe para garantir.
    foregroundDecoration: BoxDecoration(
      borderRadius: theme.radiusTheme.resolve(),
      border: Border.all(
        color: states.contains(WidgetState.focused)
            ? theme.colorTheme.focusRing
            : theme.colorTheme.transparent,
        width: AppStrokes.m,
      ),
    ),
    child: child,
  );

  Widget _chevron({
    required String icon,
    required String semanticLabel,
    required bool enabled,
    required VoidCallback onTap,
  }) => AppSemantics.button(
    label: semanticLabel,
    enabled: enabled,
    onTap: enabled ? onTap : null,
    child: FlocksInteraction(
      enabled: enabled,
      onPressed: onTap,
      builder: (BuildContext context, Set<WidgetState> states) => _surface(
        context,
        states,
        padding: const EdgeInsets.all(AppSpacings.s8),
        child: AppIcon(
          icon,
          color: enabled ? selectedDateFill(theme) : disabledDateColor(theme),
          size: AppIconSize.s,
        ),
      ),
    ),
  );

  Widget _labelButton() => AppSemantics.button(
    label: label,
    enabled: true,
    onTap: onLabelTap,
    child: FlocksInteraction(
      onPressed: onLabelTap,
      builder: (BuildContext context, Set<WidgetState> states) => _surface(
        context,
        states,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s12,
          vertical: AppSpacings.s8,
        ),
        // O rótulo é o GATILHO da troca de mês/ano. Sem isto o
        // `SelectionContainer` ancestral ganha a arena do gesto e o toque
        // vira seleção de texto — a mesma armadilha do AppSurfaceTopBar.
        child: SelectionContainer.disabled(
          child: AppText(
            label,
            style: theme.textTheme.titleSmall.withColor(
              theme.colorTheme.neutralPrimary.s900,
            ),
          ),
        ),
      ),
    ),
  );
}

/// Linha de cabeçalhos dos dias da semana (DOM … SAB), colunas de `cell`.
Widget buildWeekDayHeaders(AppThemeData theme, double cell) {
  const weekDayHeaders = ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB'];
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: weekDayHeaders
        .map(
          (day) => SizedBox(
            width: cell,
            child: Center(
              child: AppText(
                day,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: theme.textTheme.labelSmall.withColor(
                  theme.colorTheme.tertiary.s300,
                ),
              ),
            ),
          ),
        )
        .toList(),
  );
}

/// Nomes curtos dos meses (JAN … DEZ), usados nos grids.
const monthAbbreviations = [
  'JAN',
  'FEV',
  'MAR',
  'ABR',
  'MAI',
  'JUN',
  'JUL',
  'AGO',
  'SET',
  'OUT',
  'NOV',
  'DEZ',
];

/// Nomes completos dos meses (JANEIRO … DEZEMBRO), usados na label do header.
const monthNames = [
  'JANEIRO',
  'FEVEREIRO',
  'MARÇO',
  'ABRIL',
  'MAIO',
  'JUNHO',
  'JULHO',
  'AGOSTO',
  'SETEMBRO',
  'OUTUBRO',
  'NOVEMBRO',
  'DEZEMBRO',
];

/// Quantos anos o grid de anos exibe por página.
const yearsPerPage = 12;

/// Modos de visualização de um calendário: dias, meses ou anos.
enum DatePickerView { days, months, years }

/// Rótulo de acessibilidade de um dia do calendário: "15 de julho de 2026".
///
/// O número sozinho não serve — na grade, "15" só faz sentido para quem está
/// vendo o cabeçalho do mês. Quem navega por leitor de tela chega na célula
/// direto, e precisa da data inteira ali.
String dayCellSemanticLabel(DateTime date) =>
    '${date.day} de ${monthNames[date.month - 1].toLowerCase()} '
    'de ${date.year}';
