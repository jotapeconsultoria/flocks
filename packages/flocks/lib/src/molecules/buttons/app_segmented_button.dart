import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_strokes.dart';
import '../../tokens/app_style.dart';
import '../../tokens/contrast.dart';
import '../../tokens/swatch_generator.dart' show elevatedSurface;
import 'app_button_color.dart';
import 'app_button_size.dart';
import 'button_state_colors.dart';

/// Um segmento de um [AppSegmentedButton]: um valor com rótulo e/ou ícone.
final class AppSegment<T> {
  /// Cria um [AppSegment]. Exige [label] e/ou [icon].
  const AppSegment({
    required this.value,
    this.label,
    this.icon,
    this.semanticLabel,
  }) : assert(
         label != null || icon != null,
         'AppSegment exige label e/ou icon',
       );

  /// Valor representado por este segmento.
  final T value;

  /// Rótulo textual (opcional).
  final String? label;

  /// URL do ícone (opcional), ex.: `AppIconToken.map`.
  final String? icon;

  /// Rótulo de acessibilidade (default: [label]).
  final String? semanticLabel;
}

/// Botão **segmentado** de seleção única (radio-like numa pílula).
///
/// 2–4 opções mutuamente exclusivas com **largura igual** (todas do tamanho do
/// maior rótulo). A opção selecionada é uma **pílula deslizante** única que
/// desliza por baixo do texto ao trocar de opção — o mesmo padrão de cores e
/// micro-interações do [AppButton]: pílula = filled primary (`readableStopOn`),
/// segmentos neutros com realce de hover/press, anel de foco e press-scale.
/// Estilo "inset" (a pílula flutua sobre o trilho, que no `filled` é um poço
/// recuado um degrau fora da `surface` — destaca da página e dos cards).
///
/// ```dart
/// AppSegmentedButton<MapMode>(
///   value: mode,
///   onChanged: (m) => setState(() => mode = m),
///   segments: const <AppSegment<MapMode>>[
///     AppSegment<MapMode>(value: MapMode.street, label: 'Ruas'),
///     AppSegment<MapMode>(value: MapMode.satellite, label: 'Satélite'),
///   ],
/// )
/// ```
final class AppSegmentedButton<T> extends StatelessWidget {
  /// Cria um [AppSegmentedButton].
  const AppSegmentedButton({
    required this.segments,
    required this.value,
    required this.onChanged,
    this.size = AppButtonSize.m,
    this.enabled = true,
    this.expanded = false,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  }) : assert(segments.length >= 2, 'Use ao menos 2 segmentos');

  /// Os segmentos (mínimo 2).
  final List<AppSegment<T>> segments;

  /// Valor selecionado.
  final T value;

  /// Notifica a troca de valor.
  final ValueChanged<T> onChanged;

  /// Tamanho (altura).
  final AppButtonSize size;

  /// Se está habilitado.
  final bool enabled;

  /// Se o controle preenche toda a largura disponível (segmentos dividem em
  /// partes iguais). Quando `false`, ajusta-se ao conteúdo — mas os segmentos
  /// continuam com **largura igual** (a do maior rótulo), para a pílula (largura
  /// constante) deslizar sem redimensionar.
  final bool expanded;

  /// Tratamento de container (borda/fundo/sombra) do eixo global [AppStyle].
  /// `null` (default) segue `theme.styleTheme.style`. Aplica-se ao TRILHO:
  /// `filled` = poço recuado um degrau fora da `surface` (destaca tanto da
  /// página quanto dos cards `surfaceContainer`), sem borda; `outlined` = trilho
  /// vazado (transparente) só com a borda `outline`; `elevated` = superfície + sombra
  /// — e a pílula selecionada acompanha a sombra (flutua). A pílula continua
  /// sendo o indicador sólido (filled primary).
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste controle (vence
  /// `theme.radiusTheme.mode`). Default do componente: [AppRadiusMode.redondo].
  /// Molda trilho e pílula de forma aninhada (a pílula encaixa no trilho).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio do TRILHO — vence [radiusMode] e o global. A pílula
  /// deriva o raio do mesmo eixo.
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final bool motionEnabled = AppMotion.enabled(context);

    // Eixo de estilo global (filled/outlined/elevated) aplicado ao TRILHO. Cada
    // estilo se separa da superfície-hospedeira por um mecanismo próprio:
    // `outlined` = trilho vazado + borda `outline`; `elevated` =
    // `surfaceContainer` + sombra (reaproveitada na pílula p/ o look flutuante);
    // `filled` = poço recuado num tom **um degrau** ([kMinSeparationLight]) fora
    // da `surface`. Esse degrau cai ENTRE `surface` e `surfaceContainer`, então
    // o poço destaca das duas superfícies-hospedeiras (a página `surface` e os
    // cards `surfaceContainer`) sem nunca se fundir — e mantém o forte contraste
    // dos rótulos `onSurface` (nunca clareia rumo à on-color como faria elevar o
    // `surfaceContainer`).
    final AppStyle style = this.style ?? theme.styleTheme.style;
    final Color filledTrack = elevatedSurface(
      colors.surface,
      isDark: isDark,
      deltaTone: kMinSeparationLight,
    );
    final StyleDecoration deco = resolveStyleDecoration(
      style: style,
      isDark: isDark,
      outline: colors.outline,
      surfaceContainer: colors.surfaceContainer,
      background: style == AppStyle.filled ? filledTrack : null,
    );

    // Forma segue o eixo de radius (default do componente: redondo). Trilho:
    // altura = pílula (`size.height`) + 2×padding (`s2`); pílula: `size.height`.
    // No `circular` a pílula encaixa concêntrica no trilho. `radius`/`radiusMode`
    // sobrescrevem.
    final AppRadiusMode mode = radiusMode ?? theme.radiusTheme.mode;
    final BorderRadius trackBR =
        radius ??
        appResolveRadius(
          mode: mode,
          componentDefault: AppRadiusMode.redondo,
          size: Size.square(size.height + 2 * AppSpacings.s2),
        );
    final BorderRadius pillBR = appResolveRadius(
      mode: mode,
      componentDefault: AppRadiusMode.redondo,
      size: Size.square(size.height),
    );

    // A pílula deslizante reutiliza as cores do AppButton filled primary (mesmo
    // acento legível, mesmo `deepen`). Estado base (o hover/press da seleção não
    // altera a pílula — só os segmentos neutros reagem); `disabled` apaga por tom.
    final ButtonColors pill = appFilledButtonColors(
      colors,
      AppButtonColor.primary.role(colors),
      AppButtonColor.primary.onRole(colors),
      hovered: false,
      pressed: false,
      disabled: !enabled,
    );

    final int n = segments.length;
    final int selectedIndex = segments.indexWhere(
      (AppSegment<T> s) => s.value == value,
    );

    // Largura igual: em `expanded`, cada célula é um `Expanded` (divide o pai);
    // caso contrário, todas ganham a largura do maior rótulo (medida abaixo),
    // para a pílula (largura constante = 1/n) deslizar sem redimensionar.
    final double? cellWidth = expanded ? null : _maxCellWidth(context, theme);

    final List<Widget> cells = <Widget>[
      for (int i = 0; i < n; i++)
        if (expanded)
          Expanded(
            child: _segment(
              context,
              theme,
              colors,
              segments[i],
              i == selectedIndex,
              pill.foreground,
              pillBR,
              motionEnabled,
            ),
          )
        else
          SizedBox(
            width: cellWidth,
            child: _segment(
              context,
              theme,
              colors,
              segments[i],
              i == selectedIndex,
              pill.foreground,
              pillBR,
              motionEnabled,
            ),
          ),
    ];

    // Pílula deslizante: um único indicador atrás dos rótulos. `FractionallySized`
    // (1/n) + `AnimatedAlign` (x mapeado de -1..1) → translação horizontal pura,
    // sem coordenadas em pixel. Renderiza já no alvo no primeiro build (sem
    // "slide de entrada"). `AppMotion.resolve` → snap quando reduce-motion.
    final Widget pillLayer = selectedIndex < 0
        ? const SizedBox.shrink()
        : Positioned.fill(
            child: AnimatedAlign(
              alignment: Alignment(_alignX(selectedIndex, n), 0),
              duration: AppMotion.resolve(context, AppDurations.normal),
              curve: AppCurves.standard,
              child: FractionallySizedBox(
                widthFactor: 1 / n,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: pill.background,
                    borderRadius: pillBR,
                    // Só != null no `elevated` — a pílula flutua junto do trilho.
                    boxShadow: deco.boxShadow,
                  ),
                ),
              ),
            ),
          );

    final Widget stack = Stack(
      children: <Widget>[
        pillLayer,
        Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          children: cells,
        ),
      ],
    );

    // Setas ←/→ navegam entre os segmentos (Tab também).
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
          child: stack,
        ),
      ),
    );

    // A borda do `outlined` vai DENTRO da decoração: `DecoratedBox` não insere a
    // borda no layout, e a pílula fica dentro do `Padding(all: s2)` — a borda
    // pinta na faixa de padding e nunca corta a pílula.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: deco.color,
        border: deco.border,
        boxShadow: deco.boxShadow,
        borderRadius: trackBR,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.s2),
        child: navigable,
      ),
    );
  }

  /// Alinhamento horizontal (-1..1) do centro da pílula (largura 1/n) sobre o
  /// segmento [i]. Deriva de `childLeft = (1 - 1/n)·(x+1)/2` resolvido para `x`.
  double _alignX(int i, int n) => n <= 1 ? 0 : -1 + 2 * i / (n - 1);

  /// Largura do maior segmento (padding + ícone + texto), para igualar todas as
  /// células no modo não-`expanded`. Medida com o mesmo `titleMedium` efetivo e
  /// o `TextScaler` ambiente que o [AppText] usa — síncrona, sem flicker.
  double _maxCellWidth(BuildContext context, AppThemeData theme) {
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    final TextStyle labelStyle = theme.textTheme.titleMedium;
    final TextStyle effective = labelStyle.inherit
        ? DefaultTextStyle.of(context).style.merge(labelStyle)
        : labelStyle;

    double maxW = 0;
    for (final AppSegment<T> segment in segments) {
      double w = 2 * AppSpacings.s16; // padding horizontal
      if (segment.icon != null) {
        w += AppIconSize.s.value + (segment.label != null ? AppSpacings.s8 : 0);
      }
      if (segment.label != null) {
        final TextPainter tp = TextPainter(
          text: TextSpan(text: segment.label, style: effective),
          textDirection: TextDirection.ltr,
          textScaler: textScaler,
          maxLines: 1,
        )..layout();
        w += tp.width;
        tp.dispose();
      }
      if (w > maxW) maxW = w;
    }
    // Arredonda para cima → sem elipse sub-pixel no maior rótulo, borda nítida.
    return maxW.ceilToDouble();
  }

  Widget _segment(
    BuildContext context,
    AppThemeData theme,
    AppColorTheme colors,
    AppSegment<T> segment,
    bool selected,
    Color selectedFg,
    BorderRadius pillBR,
    bool motionEnabled,
  ) {
    final Color content = selected
        ? selectedFg
        : enabled
        ? colors.onSurface
        : mutedForDisabled(colors.onSurface, colors.surfaceContainer);

    return AppSemantics.toggle(
      value: selected,
      enabled: enabled,
      mutuallyExclusive: true,
      label: segment.semanticLabel ?? segment.label,
      onTap: enabled ? () => onChanged(segment.value) : null,
      child: FlocksInteraction(
        onPressed: enabled ? () => onChanged(segment.value) : null,
        selected: selected,
        enabled: enabled,
        builder: (BuildContext context, Set<WidgetState> states) {
          final bool hovered = states.contains(WidgetState.hovered);
          final bool pressed = states.contains(WidgetState.pressed);
          final bool focused = states.contains(WidgetState.focused);

          // Realce dos segmentos NEUTROS (mesmas opacidades do AppButton ghost:
          // onSurface 8%/12%). O selecionado é a pílula — sem overlay próprio.
          final Color overlay = selected
              ? colors.transparent
              : pressed
              ? colors.onSurface.withValues(alpha: 0.12)
              : hovered
              ? colors.onSurface.withValues(alpha: 0.08)
              : colors.transparent;

          // Cor do conteúdo cruza suavemente ao ganhar/perder a pílula, em
          // sincronia com o slide (snap quando reduce-motion via AppMotion).
          final Widget label = TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: content),
            duration: AppMotion.resolve(context, AppDurations.normal),
            curve: AppCurves.standard,
            builder: (BuildContext context, Color? animated, _) =>
                _labelContent(theme, segment, animated ?? content),
          );

          final Widget cell = AnimatedContainer(
            duration: AppMotion.resolve(context, AppDurations.normal),
            curve: AppCurves.standard,
            height: size.height,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s16),
            decoration: BoxDecoration(color: overlay, borderRadius: pillBR),
            child: label,
          );

          // Anel de foco por fora do conteúdo (não desloca layout). `Inside`
          // (não `outside` como o botão) para não invadir a célula vizinha, já
          // que os segmentos são adjacentes. Some no toque via FlocksInteraction.
          final Widget ringed = DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: pillBR,
              border: Border.all(
                color: focused ? colors.focusRing : colors.transparent,
                width: AppStrokes.m,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: cell,
          );

          return AnimatedScale(
            scale: (motionEnabled && pressed) ? 0.97 : 1.0,
            duration: AppMotion.resolve(context, AppDurations.fast),
            curve: AppCurves.standard,
            child: ringed,
          );
        },
      ),
    );
  }

  Widget _labelContent(AppThemeData theme, AppSegment<T> segment, Color color) {
    return SelectionContainer.disabled(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacings.s8,
        children: <Widget>[
          if (segment.icon != null)
            AppIcon(segment.icon!, size: AppIconSize.s, color: color),
          if (segment.label != null)
            AppText(
              segment.label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium.copyWith(color: color),
            ),
        ],
      ),
    );
  }
}
