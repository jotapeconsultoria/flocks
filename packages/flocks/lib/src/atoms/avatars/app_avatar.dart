import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/foundation.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../icons/icons.dart';
import '../loadings/loadings.dart';
import '../texts/texts.dart';
import 'avatar_interaction.dart';

/// Tamanho nomeado do [AppAvatar] — específico do componente (espelha
/// [AppIconSize]).
///
/// O **diâmetro é derivado**, não fixo: `diameter = textScaler·contentSize + 2·padding`.
/// Isso significa que a casca **cresce junto com o text-scale** do sistema
/// (acessibilidade) enquanto o padding permanece constante — nada de texto
/// transbordando um círculo de tamanho fixo. Cada passo muda o tamanho do
/// **conteúdo** (texto/ícone); o padding fica fixo dentro do passo.
enum AppAvatarSize {
  /// Pequeno — 32px em escala 1.0 (ex.: leading de list tile).
  s,

  /// Médio — 48px em escala 1.0 (default).
  m,

  /// Grande — 64px em escala 1.0 (ex.: cabeçalhos).
  l,

  /// Extra-grande — 96px em escala 1.0 (ex.: destaque).
  xl;

  /// Tamanho do ícone-fallback deste passo.
  AppIconSize get iconSize => switch (this) {
    AppAvatarSize.s => AppIconSize.s,
    AppAvatarSize.m => AppIconSize.m,
    AppAvatarSize.l => AppIconSize.l,
    AppAvatarSize.xl => AppIconSize.xl,
  };

  /// Lado da região de conteúdo em escala 1.0 (== [iconSize]): 16/24/32/64.
  double get contentSize => iconSize.value;

  /// Padding interno **fixo** (não escala com o text-scale).
  double get padding => switch (this) {
    AppAvatarSize.s => AppSpacings.s8,
    AppAvatarSize.m => AppSpacings.s12,
    AppAvatarSize.l => AppSpacings.s16,
    AppAvatarSize.xl => AppSpacings.s16,
  };

  /// Diâmetro em escala 1.0 (`contentSize + 2·padding`): 32/48/64/96. Usado em
  /// docs/testes; o diâmetro real em runtime escala com o texto.
  double get baseDiameter => contentSize + 2 * padding;
}

/// Avatar genérico do design system.
///
/// Renderiza uma imagem de rede (quando [imageUrl] está disponível) ou um
/// fallback textual/ícone (ex.: inicial do nome). Não toma decisão sobre o
/// conteúdo do fallback — o consumidor escolhe.
///
/// É um **container** do DS: segue o radius global ([radius]) e o eixo de estilo
/// ([style]) como os demais (borda/fundo/sombra).
///
/// ## Tamanho dinâmico
/// O construtor padrão recebe um [AppAvatarSize] nomeado e **deriva** o diâmetro
/// do tamanho do texto: cresce com o text-scale do sistema, com padding fixo
/// (acessibilidade — sem overflow). Para um diâmetro em **pixels exatos** (ex.:
/// editores de foto de perfil que dimensionam overlays/botões irmãos pelo mesmo
/// valor), use [AppAvatar.custom] — caixa fixa como antes.
///
/// ## Estados (quando clicável)
/// Passe [onTap] para torná-lo clicável — ganha cursor, foco por teclado (anel),
/// semântica de botão e a micro-animação de [effect]. Trata Neutral / Hovered /
/// Pressed / Focused e o visual de **Dragged** (eleva: escala + sombra). O estado
/// `dragged` não é setado pelo próprio avatar (ele não é um `Draggable`) — dirija-o
/// via [statesController] ao montar, por exemplo, um `Draggable(feedback: ...)`.
/// As animações respeitam a regra global (`AppMotion`): com movimento desligado,
/// escala/sombra vão ao estado final instantaneamente, mas o anel de foco e o
/// realce (UX essencial) permanecem.
///
/// Exemplo:
/// ```dart
/// AppAvatar(
///   size: AppAvatarSize.xl,
///   imageUrl: user.pictureUrl,
///   fallback: user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
///   semanticLabel: user.name,
///   onTap: () => openProfile(user),
/// );
///
/// // Pixels exatos:
/// AppAvatar.custom(diameter: 120, imageUrl: user.pictureUrl, fallback: 'JP');
/// ```
final class AppAvatar extends StatelessWidget {
  /// Avatar de tamanho nomeado ([AppAvatarSize]) — diâmetro derivado do texto,
  /// cresce com o text-scale.
  const AppAvatar({
    this.size = AppAvatarSize.m,
    this.fallback,
    this.fallbackIcon,
    this.imageUrl,
    this.semanticLabel,
    this.style,
    this.background,
    this.radius,
    this.onTap,
    this.effect = AppAvatarEffect.scale,
    this.statesController,
    super.key,
  }) : _customDiameter = null;

  /// Avatar de **diâmetro exato em pixels** (caixa fixa). Para casos que
  /// dimensionam widgets irmãos pelo mesmo valor. Para um círculo garantido,
  /// passe `radius: BorderRadius.circular(diameter / 2)`.
  const AppAvatar.custom({
    required double diameter,
    this.fallback,
    this.fallbackIcon,
    this.imageUrl,
    this.semanticLabel,
    this.style,
    this.background,
    this.radius,
    this.onTap,
    this.effect = AppAvatarEffect.scale,
    this.statesController,
    super.key,
  }) : _customDiameter = diameter,
       size = AppAvatarSize.m;

  /// Texto curto exibido quando [imageUrl] está nulo, vazio ou falha ao carregar.
  final String? fallback;

  /// Slug de ícone do estado SEM imagem e SEM texto — quando [imageUrl] e
  /// [fallback] estão vazios. `null` = [AppIconToken.user], o glifo de sempre.
  /// O texto vence: com [fallback] presente, o ícone não aparece. A cor do
  /// glifo segue a do fallback (neutro `s700`), deliberadamente.
  final String? fallbackIcon;

  /// URL de rede da imagem. Quando nulo/vazio, exibe o fallback.
  final String? imageUrl;

  /// Tamanho nomeado (diâmetro derivado do texto). Ignorado por [AppAvatar.custom].
  final AppAvatarSize size;

  /// Diâmetro exato em px do [AppAvatar.custom]; `null` no construtor padrão.
  final double? _customDiameter;

  /// Rótulo de acessibilidade (ex.: nome do usuário). Quando `null`, o rótulo
  /// efetivo cai no texto do [fallback] e, na ausência dele, em `'Avatar'`.
  final String? semanticLabel;

  /// Estilo de container (borda/fundo/sombra). Default: global `theme.styleTheme.style`.
  final AppStyle? style;

  /// Sobrescreve o fundo do avatar. Default: `surfaceContainer`.
  final Color? background;

  /// Raio dos cantos. Default: global (modo redondo), proporcional ao diâmetro.
  /// É saturado internamente em `diâmetro/2` (um raio grande vira círculo).
  final BorderRadius? radius;

  /// Torna o avatar clicável. Quando != null, aplica [effect] no hover/press,
  /// cursor de clique, foco por teclado (anel) e semântica de botão.
  final VoidCallback? onTap;

  /// Micro-animação de hover/press quando clicável. Default [AppAvatarEffect.scale].
  final AppAvatarEffect effect;

  /// Controlador de estados externo, repassado ao [FlocksInteraction]. Permite
  /// dirigir estados manualmente (ex.: `dragged` num `Draggable`, ou forçar
  /// estados em testes/Widgetbook). **Só tem efeito quando clicável** ([onTap]
  /// != null). Quem cria o controlador é dono do `dispose`.
  final FlocksStatesController? statesController;

  bool get _isCustom => _customDiameter != null;

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Rótulo de a11y efetivo: [semanticLabel] › texto do [fallback] › `'Avatar'`.
  String get _semanticLabel {
    if (semanticLabel != null && semanticLabel!.trim().isNotEmpty) {
      return semanticLabel!;
    }
    final String text = fallback?.trim() ?? '';
    return text.isNotEmpty ? text : 'Avatar';
  }

  /// Diâmetro efetivo: fixo no [AppAvatar.custom]; derivado do text-scale no
  /// construtor nomeado (padding constante).
  double _diameter(BuildContext context) {
    if (_isCustom) return _customDiameter!;
    final TextScaler scaler = MediaQuery.textScalerOf(context);
    return scaler.scale(size.contentSize) + 2 * size.padding;
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool isDark = theme.brightness == AppBrightness.dark;
    final bool motionOn = AppMotion.enabled(context);
    final AppStyle s = style ?? theme.styleTheme.style;
    final double d = _diameter(context);
    final BorderRadius br = _clampCircle(
      radius ?? theme.radiusTheme.resolve(size: Size.square(d)),
      d / 2,
    );
    final StyleDecoration deco = resolveStyleDecoration(
      style: s,
      isDark: isDark,
      outline: colors.outline,
      surfaceContainer: colors.surfaceContainer,
      // Sem `ownFill`: cai no `surfaceContainer`, que é o token canônico de
      // superfície elevada e carrega a regra de separação de tom (ΔT ≥ 24 no
      // escuro). O `neutralPrimary.s100` que estava aqui é declaradamente
      // "preenchimento sutil/desabilitado", ISENTO dessa regra — daí o avatar
      // sumir contra a superfície no tema escuro.
      background: background,
    );

    // Conteúdo passivo à seleção: a inicial do fallback é um AppText (seleção via
    // AppSelectionRegion) que, num avatar clicável, ROUBARIA o clique — e, num
    // avatar decorativo, não faz sentido ser selecionável. SelectionContainer.disabled
    // desativa a seleção nesse subtree (mesma receita do ButtonCore).
    final Widget inner = SelectionContainer.disabled(
      child: _hasImage
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              // Cross-fade do spinner para a imagem quando termina de carregar.
              loadingBuilder: (context, child, progress) => AppCrossFade(
                child: progress == null
                    ? KeyedSubtree(key: const ValueKey('image'), child: child)
                    : Center(
                        key: const ValueKey('spinner'),
                        child: AppCircularLoading(size: d * 0.4),
                      ),
              ),
              errorBuilder: (context, error, stackTrace) =>
                  _buildFallback(context, theme),
            )
          : _buildFallback(context, theme),
    );

    // A "casca" visual: caixa `d×d` com a decoração do estilo. [shadow]/[overlay]
    // variam por estado; [animated] usa AnimatedContainer (motion-gated) no caminho
    // clicável.
    Widget box({
      List<BoxShadow>? shadow,
      Color? overlay,
      bool animated = false,
    }) {
      // A borda do estilo NÃO entra na decoração do Container — o Container insere
      // a borda p/ dentro (via decoration.padding) e encolheria o conteúdo. Fica
      // numa DecoratedBox por cima, que não afeta o layout: nem o texto nem o
      // tamanho do componente mudam com a borda. (Fica num raio distinto do anel
      // de foco, então ambos aparecem juntos.)
      final BoxDecoration decoration = BoxDecoration(
        color: deco.color,
        boxShadow: shadow,
        borderRadius: br,
      );
      final Widget child = overlay == null
          ? inner
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                inner,
                ColoredBox(color: overlay),
              ],
            );
      final Widget filled = animated
          ? AnimatedContainer(
              duration: AppMotion.resolve(context, AppDurations.fast),
              curve: AppCurves.standard,
              width: d,
              height: d,
              clipBehavior: Clip.antiAlias,
              decoration: decoration,
              child: child,
            )
          : Container(
              width: d,
              height: d,
              clipBehavior: Clip.antiAlias,
              decoration: decoration,
              child: child,
            );
      if (deco.border == null) return filled;
      return DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(border: deco.border, borderRadius: br),
        child: filled,
      );
    }

    if (onTap == null) {
      return Semantics(
        image: true,
        label: _semanticLabel,
        container: true,
        child: ExcludeSemantics(child: box(shadow: deco.boxShadow)),
      );
    }

    // Clicável: hover/press/dragged ([effect]) + realce + anel de foco + role de botão.
    return FlocksInteraction(
      onPressed: onTap,
      statesController: statesController,
      builder: (BuildContext context, Set<WidgetState> states) {
        final AvatarInteraction v = resolveAvatarInteraction(
          states: states,
          effect: effect,
          onSurface: colors.onSurface,
          isDark: isDark,
          motionEnabled: motionOn,
        );
        final bool focused = states.contains(WidgetState.focused);

        // A caixa anima o tamanho e a sombra de lift (motion-gated). O realce
        // (overlay) é state-driven e aparece instantaneamente.
        final Widget scaled = AnimatedScale(
          scale: v.scale,
          duration: AppMotion.resolve(context, AppDurations.fast),
          curve: AppCurves.standard,
          child: box(
            shadow: v.liftShadow ?? deco.boxShadow,
            overlay: v.overlay,
            animated: true,
          ),
        );

        // Anel de foco por fora (não desloca layout; some no toque). PLAIN (sem
        // duração) → sobrevive a reduce-motion.
        final Widget ringed = DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: br,
            border: Border.all(
              color: focused ? colors.focusRing : colors.transparent,
              width: AppStrokes.m,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: scaled,
        );

        return AppSemantics.button(
          label: _semanticLabel,
          enabled: true,
          onTap: onTap,
          child: ringed,
        );
      },
    );
  }

  Widget _buildFallback(BuildContext context, AppThemeData theme) {
    final String text = fallback?.trim() ?? '';
    final Color fg = theme.colorTheme.neutralPrimary.s700;

    if (_isCustom) {
      // Caixa fixa (o consumidor controla o px): comportamento herdado — não
      // escala com o text-scale, FittedBox garante que nunca transborda.
      final double d = _customDiameter!;
      final Widget content = text.isEmpty
          ? AppIcon(
              fallbackIcon ?? AppIconToken.user,
              color: fg,
              size: _iconSizeFor(d),
            )
          : AppText(
              text,
              maxLines: 1,
              style: theme.textTheme.titleLarge.withColor(fg),
            );
      return Center(
        child: Padding(
          padding: EdgeInsets.all(d * 0.16),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: MediaQuery.withNoTextScaling(child: content),
          ),
        ),
      );
    }

    // Caminho nomeado: a caixa já cresceu com o `scaler`, então o conteúdo
    // também cresce (sem `withNoTextScaling`) e o padding fixo é preservado.
    final TextScaler scaler = MediaQuery.textScalerOf(context);
    final Widget content = text.isEmpty
        ? AppIcon(
            fallbackIcon ?? AppIconToken.user,
            color: fg,
            customSize: scaler.scale(size.iconSize.value),
          )
        : FittedBox(
            fit: BoxFit.scaleDown,
            child: AppText(
              text,
              maxLines: 1,
              style: _fallbackTextStyle(theme).withColor(fg),
            ),
          );
    return Center(
      child: Padding(padding: EdgeInsets.all(size.padding), child: content),
    );
  }

  /// Papel de texto do fallback por passo nomeado (desacopla o enum do tema).
  TextStyle _fallbackTextStyle(AppThemeData theme) {
    final t = theme.textTheme;
    return switch (size) {
      AppAvatarSize.s => t.titleSmall,
      AppAvatarSize.m => t.titleLarge,
      AppAvatarSize.l => t.headlineMedium,
      AppAvatarSize.xl => t.displaySmall,
    };
  }

  /// Satura cada canto do raio em [maxRadius] (= diâmetro/2) — um raio grande
  /// vira um círculo perfeito. Precedente: `AppStepper._circle`.
  BorderRadius _clampCircle(BorderRadius br, double maxRadius) {
    Radius clamp(Radius r) =>
        Radius.elliptical(math.min(r.x, maxRadius), math.min(r.y, maxRadius));
    return BorderRadius.only(
      topLeft: clamp(br.topLeft),
      topRight: clamp(br.topRight),
      bottomLeft: clamp(br.bottomLeft),
      bottomRight: clamp(br.bottomRight),
    );
  }

  /// Bucket de [AppIconSize] a partir de um diâmetro em px (só [AppAvatar.custom]).
  AppIconSize _iconSizeFor(double diameter) {
    if (diameter >= 96) return AppIconSize.xl;
    if (diameter >= 56) return AppIconSize.l;
    if (diameter >= 32) return AppIconSize.m;
    return AppIconSize.s;
  }
}
