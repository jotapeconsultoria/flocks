import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../../atoms/surface/app_scroll_edge_fade.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import 'app_choice_chip.dart';

/// Uma opção de um [AppChoiceChipBar]. Não é widget — é dado, como
/// `AppSegment`.
final class AppChoiceChipOption<T> {
  /// Cria uma [AppChoiceChipOption].
  const AppChoiceChipOption({
    required this.value,
    required this.label,
    this.count,
    this.icon,
    this.semanticLabel,
    this.tooltip,
    this.enabled = true,
  });

  /// Valor que a opção representa.
  final T value;

  /// Rótulo visível.
  final String label;

  /// Número associado (ver `AppChoiceChip.count`).
  final int? count;

  /// Ícone opcional (`AppIconToken.*`).
  final String? icon;

  /// Rótulo anunciado, se o padrão não bastar.
  final String? semanticLabel;

  /// Dica no hover/long-press.
  final String? tooltip;

  /// Se esta opção específica aceita toque.
  final bool enabled;
}

/// Como a barra acomoda opções que não cabem na largura.
enum AppChoiceChipLayout {
  /// Rola na horizontal, com véu nas bordas ([AppScrollEdgeFade]). Default da
  /// seleção única: uma barra de filtros no topo de uma lista não pode crescer
  /// para baixo e empurrar o conteúdo.
  scroll,

  /// Quebra em linhas (`Wrap`). Default da multi-seleção: num formulário,
  /// crescer para baixo é aceitável e esconder opção não é.
  wrap,
}

/// Fila de [AppChoiceChip] com seleção única ou múltipla — a barra de filtros.
///
/// Existe porque o [AppSegmentedButton], o vizinho mais próximo, NÃO rola: ele
/// iguala as células pela largura do maior rótulo para a pílula deslizar sem
/// redimensionar; com 6 status de larguras muito diferentes isso estoura a
/// linha. Este componente troca a pílula deslizante pela rolagem: cada chip
/// tem a largura do próprio conteúdo.
///
/// Traz junto o que se perde ao montar a fila na mão: ←/→ andam pelos chips
/// (como no [AppSegmentedButton]), o chip focado é rolado até aparecer, e as
/// bordas do que rola ganham véu em vez de corte seco.
///
/// ```dart
/// AppChoiceChipBar<String>(
///   value: statusFilter,
///   onChanged: inbox.setStatusFilter,
///   options: <AppChoiceChipOption<String>>[
///     const AppChoiceChipOption<String>(value: 'all', label: 'Todas'),
///     AppChoiceChipOption<String>(value: 'queue', label: 'Novos', count: fila),
///   ],
/// )
/// ```
final class AppChoiceChipBar<T> extends StatelessWidget {
  /// Barra de seleção ÚNICA (radio-like). [value] `null` = nada escolhido.
  const AppChoiceChipBar({
    required this.options,
    required this._value,
    required ValueChanged<T> onChanged,
    this.layout = AppChoiceChipLayout.scroll,
    this.spacing = AppSpacings.s8,
    this.padding = EdgeInsets.zero,
    this.enabled = true,
    this.semanticLabel,
    this.fadeColor,
    this.controller,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  }) : _onSingle = onChanged,
       _values = null,
       _onMulti = null;

  /// Barra de seleção MÚLTIPLA. [values] é o conjunto atual; [onChanged]
  /// recebe um conjunto NOVO (a barra não muta o que recebeu).
  const AppChoiceChipBar.multi({
    required this.options,
    required Set<T> this._values,
    required ValueChanged<Set<T>> onChanged,
    this.layout = AppChoiceChipLayout.wrap,
    this.spacing = AppSpacings.s8,
    this.padding = EdgeInsets.zero,
    this.enabled = true,
    this.semanticLabel,
    this.fadeColor,
    this.controller,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  }) : _onMulti = onChanged,
       _value = null,
       _onSingle = null;

  /// As opções, na ordem de leitura.
  final List<AppChoiceChipOption<T>> options;

  /// Acomodação do excesso. Default [AppChoiceChipLayout.scroll] na única e
  /// [AppChoiceChipLayout.wrap] na múltipla.
  final AppChoiceChipLayout layout;

  /// Espaço entre chips. Default [AppSpacings.s8].
  final double spacing;

  /// Respiro em volta da fila (entra DENTRO do scroll, para o primeiro e o
  /// último chip não colarem na borda ao rolar).
  final EdgeInsets padding;

  /// Desabilita a barra inteira. Uma opção pode se desabilitar sozinha por
  /// [AppChoiceChipOption.enabled].
  final bool enabled;

  /// Nome do GRUPO para o leitor de tela ("Filtrar por status"). Sem ele o
  /// usuário ouve seis toggles soltos e não sabe do que são opção.
  final String? semanticLabel;

  /// Cor de onde parte o véu das bordas. Default `colorTheme.surface` — barra
  /// de filtro mora na página. Passe `surfaceContainer` quando ela morar num
  /// card.
  final Color? fadeColor;

  /// Controlador de rolagem externo (só no layout `scroll`).
  final ScrollController? controller;

  /// Repassado a cada chip (eixo AppStyle do não-selecionado).
  final AppStyle? style;

  /// Repassado a cada chip (modo de forma).
  final AppRadiusMode? radiusMode;

  /// Repassado a cada chip (raio cru, px).
  final double? radius;

  final T? _value;
  final ValueChanged<T>? _onSingle;
  final Set<T>? _values;
  final ValueChanged<Set<T>>? _onMulti;

  /// `true` quando a barra é multi-seleção.
  bool get isMulti => _onMulti != null;

  /// Se [value] está escolhido agora.
  ///
  /// Na seleção única, `_value == null` significa "nada escolhido" — por isso
  /// uma opção cujo `value` seja `null` (num `T` anulável) nunca aparece
  /// selecionada: os dois sentidos de `null` colidiriam.
  bool isSelected(T value) =>
      isMulti ? _values!.contains(value) : _value != null && _value == value;

  void _toggle(AppChoiceChipOption<T> option) {
    if (isMulti) {
      // CÓPIA, nunca mutação do Set recebido — o dono continua dono.
      final Set<T> next = Set<T>.of(_values!);
      if (!next.remove(option.value)) next.add(option.value);
      _onMulti!(next);
    } else {
      _onSingle!(option.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTheme colors = AppTheme.of(context).colorTheme;

    final List<Widget> chips = <Widget>[
      for (final AppChoiceChipOption<T> o in options)
        Builder(
          // O contexto DESTE chip, dentro do rolável: é o alvo do
          // ensureVisible quando o foco chega nele por teclado.
          builder: (BuildContext chipContext) => Focus(
            canRequestFocus: false,
            skipTraversal: true,
            onFocusChange: (bool focused) {
              if (!focused || layout != AppChoiceChipLayout.scroll) return;
              // Animação IMPERATIVA → duração do eixo de motion
              // (AppMotion.resolve); alignment 0.5 evita oscilar meio pixel
              // a cada Tab.
              Scrollable.ensureVisible(
                chipContext,
                alignment: 0.5,
                duration: AppMotion.resolve(chipContext, AppDurations.fast),
                curve: AppCurves.standard,
              );
            },
            child: AppChoiceChip(
              label: o.label,
              selected: isSelected(o.value),
              count: o.count,
              icon: o.icon,
              enabled: enabled && o.enabled,
              mutuallyExclusive: !isMulti,
              semanticLabel: o.semanticLabel,
              tooltip: o.tooltip,
              style: style,
              radiusMode: radiusMode,
              radius: radius,
              onChanged: enabled && o.enabled ? (_) => _toggle(o) : null,
            ),
          ),
        ),
    ];

    final Widget row = switch (layout) {
      AppChoiceChipLayout.scroll => AppScrollEdgeFade(
        axis: Axis.horizontal,
        color: fadeColor ?? colors.surface,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: controller,
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing,
            children: chips,
          ),
        ),
      ),
      AppChoiceChipLayout.wrap => Padding(
        padding: padding,
        child: Wrap(spacing: spacing, runSpacing: spacing, children: chips),
      ),
    };

    // ←/→ andam pelos chips — copiado do AppSegmentedButton, para as duas
    // barras navegarem igual.
    final Widget navigable = FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Actions(
        actions: <Type, Action<Intent>>{
          DirectionalFocusIntent: DirectionalFocusAction(),
        },
        child: Shortcuts(
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.arrowLeft):
                DirectionalFocusIntent(TraversalDirection.left),
            SingleActivator(LogicalKeyboardKey.arrowRight):
                DirectionalFocusIntent(TraversalDirection.right),
          },
          child: row,
        ),
      ),
    );

    // O grupo nomeado: sem ele, seis toggles chegam ao leitor de tela sem
    // dizer de que são opção.
    return AppSemantics.menu(label: semanticLabel, child: navigable);
  }
}
