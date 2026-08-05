import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../texts/texts.dart';

/// Um atalho de teclado, para ser **exibido**.
///
/// Descreve o atalho de forma independente de plataforma: [usesPrimaryModifier]
/// vira `⌘` no macOS e `Ctrl` no resto. Mostrar `Ctrl` para quem usa Mac
/// (ou vice-versa) ensina a tecla errada.
@immutable
final class AppShortcut {
  const AppShortcut(
    this.key, {
    this.usesPrimaryModifier = false,
    this.shift = false,
    this.alt = false,
  });

  /// Atalho com o modificador principal da plataforma (`⌘` / `Ctrl`).
  const AppShortcut.primary(String key, {bool shift = false, bool alt = false})
    : this(key, usesPrimaryModifier: true, shift: shift, alt: alt);

  /// A tecla em si, já como se lê (`K`, `1`, `/`, `Esc`).
  final String key;

  final bool usesPrimaryModifier;
  final bool shift;
  final bool alt;

  /// As teclas na ordem em que se pressionam, já resolvidas para a plataforma.
  List<String> resolve({TargetPlatform? platform}) {
    final target = platform ?? defaultTargetPlatform;
    final isApple =
        target == TargetPlatform.macOS || target == TargetPlatform.iOS;
    return [
      if (usesPrimaryModifier) isApple ? '⌘' : 'Ctrl',
      if (alt) isApple ? '⌥' : 'Alt',
      if (shift) isApple ? '⇧' : 'Shift',
      key,
    ];
  }

  /// Forma legível para leitor de tela (`Comando K`, `Control K`).
  String semanticsLabel({TargetPlatform? platform}) {
    final target = platform ?? defaultTargetPlatform;
    final isApple =
        target == TargetPlatform.macOS || target == TargetPlatform.iOS;
    return [
      if (usesPrimaryModifier) isApple ? 'Comando' : 'Control',
      if (alt) isApple ? 'Option' : 'Alt',
      if (shift) 'Shift',
      key,
    ].join(' ');
  }
}

/// Cor imposta aos [AppShortcutHint] de uma subárvore.
///
/// Existe porque o selo escolhe a própria cor por contraste contra a
/// SUPERFÍCIE — e, quando ele vive DENTRO de um controle pintado (o `trailing`
/// de um botão preenchido), a superfície não é mais a do tema: é o fundo do
/// botão. Sem isto, o selo dentro de um botão primário calculava contraste
/// contra a `surfaceContainer` e sumia sobre o preenchimento (revisão P1r9).
///
/// Quem pinta o controle instala o escopo com o próprio *foreground*; o selo o
/// consome quando não recebeu [AppShortcutHint.color] explícito.
final class AppShortcutHintColor extends InheritedWidget {
  const AppShortcutHintColor({
    required this.color,
    required super.child,
    super.key,
  });

  /// Cor do texto e do selo — normalmente o foreground do controle anfitrião.
  final Color color;

  static Color? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppShortcutHintColor>()?.color;

  @override
  bool updateShouldNotify(AppShortcutHintColor oldWidget) =>
      color != oldWidget.color;
}

/// Tamanhos do selo de atalho.
enum AppShortcutHintSize {
  /// Dentro de campos e chips.
  s,

  /// Em cabeçalhos e barras.
  m,
}

/// Selo que **mostra** um atalho de teclado.
///
/// Um atalho que ninguém vê não é usado — este selo é o que o torna
/// descoberto, sem exigir documentação. Fica sempre no extremo direito do
/// elemento a que pertence (sufixo/trailing), onde o olho já procura por
/// afordâncias secundárias.
///
/// É **decorativo**: não recebe toque. Quem quiser a ação clicável põe o selo
/// dentro do próprio controle.
final class AppShortcutHint extends StatelessWidget {
  const AppShortcutHint(
    this.shortcut, {
    this.size = AppShortcutHintSize.s,
    this.color,
    this.background,
    super.key,
  });

  final AppShortcut shortcut;
  final AppShortcutHintSize size;

  /// Cor do texto e do selo. Por padrão, um stop legível de `secondary`.
  final Color? color;

  /// Superfície em que o selo é pousado — usada para escolher o stop.
  ///
  /// Default `surfaceContainer` (cartões, sheets, composer, abas). Quem põe o
  /// selo sobre a `surface` (o header, o rail) passa a dela: o mesmo stop não
  /// serve às duas, e a diferença entre elas é justamente a separação que o
  /// tema garante.
  final Color? background;

  double get _fontSize => size == AppShortcutHintSize.s ? 11 : 12;
  double get _horizontalPadding =>
      size == AppShortcutHintSize.s ? AppSpacings.s4 : AppSpacings.s8;

  /// Altura **fixa** do selo.
  ///
  /// Sem ela a caixa seguiria a métrica da fonte e mudaria de tamanho conforme
  /// a tecla — o `⌘` sobe mais que um dígito. Vários selos lado a lado (as
  /// abas) ficariam desalinhados.
  double get _height => size == AppShortcutHintSize.s ? 20.0 : 24.0;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    // `secondary` e não o cinza: o atalho é novidade no produto e precisa ser
    // notado. O stop é escolhido pela superfície — um valor fixo dava 3.88 no
    // claro e 1.61 no escuro em algumas combinações.
    final resolved =
        color ??
        // Dentro de um controle pintado, a cor vem de quem pinta (o foreground
        // do botão) — só fora dele o stop é derivado da superfície do tema.
        AppShortcutHintColor.maybeOf(context) ??
        readableStopOn(
          theme.colorTheme.secondary,
          background ?? theme.colorTheme.surfaceContainer,
          minRatio: kAaNormal,
        );
    final keys = shortcut.resolve();
    final textStyle = theme.textTheme.labelSmall.copyWith(
      color: resolved,
      fontSize: _fontSize,
      fontWeight: FontWeight.w600,
      height: 1.0,
    );

    return Semantics(
      label: 'Atalho: ${shortcut.semanticsLabel()}',
      excludeSemantics: true,
      child: ConstrainedBox(
        // Piso quadrado: `1` é bem mais estreito que `3` na fonte, e sem um
        // mínimo cada aba mostraria um selo de largura diferente.
        constraints: BoxConstraints(minWidth: _height, minHeight: _height),
        child: DecoratedBox(
          // O selo é uma tecla: caixa com fill próprio. O eixo é ADITIVO —
          // no `filled` (default) o resultado é o mesmo fill de sempre; o
          // `outlined` acrescenta a borda e o `elevated`, a sombra.
          decoration: styleBoxDecoration(
            style: theme.styleTheme.style,
            isDark: theme.brightness == AppBrightness.dark,
            radius: theme.radiusTheme.resolve(
              size: const Size.square(AppSizes.s16),
            ),
            outline: theme.colorTheme.outline,
            surfaceContainer: theme.colorTheme.surfaceContainer,
            ownFill: resolved.customOpacity(0.08),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final (int index, String key) in keys.indexed) ...[
                  // Sem `+` entre as teclas — `⌘K` é como o atalho se escreve —
                  // mas com um respiro, senão o modificador cola na letra.
                  if (index > 0) const SizedBox(width: AppSpacings.s2),
                  AppText(key, maxLines: 1, softWrap: false, style: textStyle),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
