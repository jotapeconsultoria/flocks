import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../molecules/interactive/interactive.dart';
import '../../motion/app_motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_device.dart';
import '../../tokens/app_durations.dart';
import '../../tokens/app_sizes.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/contrast.dart';
import '../../tokens/swatch_generator.dart';

/// Layout dividido usado nas páginas de autenticação (login/OTP).
///
/// No **desktop** mostra um painel de marca (logo, título, subtítulo + o
/// formulário [child]) à esquerda e uma imagem de fundo à direita; no **mobile**
/// empilha o formulário num card centralizado sobre a imagem de fundo. A quebra
/// segue os breakpoints de [AppDevice]. Cores 100% do tema; cantos do card
/// mobile seguem o eixo de raio global; com [websiteUrl] o logo vira link, com
/// micro-interação de toque.
final class AppAuthSplitLayout extends StatelessWidget {
  /// Cria um [AppAuthSplitLayout].
  const AppAuthSplitLayout({
    required this.child,
    this.brandSubtitle,
    this.brandTitle,
    this.backgroundImageUrl,
    this.logoUrl,
    this.logo,
    this.logoSemanticLabel,
    this.websiteUrl,
    super.key,
  }) : assert(
         logo == null || logoUrl == null,
         'Passe UM logo: o Widget (logo) OU o slug (logoUrl), nunca os dois — '
         'duas marcas no mesmo painel é erro de montagem.',
       ),
       assert(
         logo == null || logoSemanticLabel != null,
         'logo (Widget) exige logoSemanticLabel: o slot entra na árvore de '
         'semântica e precisa nomear a marca ao leitor de tela.',
       ),
       assert(
         brandTitle != null || logoSemanticLabel != null,
         'A tela de auth precisa de identidade: informe brandTitle ou '
         'logoSemanticLabel (brandSubtitle sozinho não nomeia a marca).',
       );

  /// URL da imagem de fundo (opcional; PNG/JPG ou SVG).
  final String? backgroundImageUrl;

  /// Subtítulo da marca. Opcional: sem ele a linha (e o respiro dela) some.
  final String? brandSubtitle;

  /// Título da marca. Opcional desde que a identidade venha de outro lugar
  /// ([logoSemanticLabel]) — o assert fecha a tela de auth anônima.
  final String? brandTitle;

  /// Conteúdo do formulário de autenticação.
  final Widget child;

  /// Ícone/logo mostrado no topo do painel de marca. Opcional.
  ///
  /// `null` (app sem asset remoto) tira o logo **e** o link para o site junto
  /// com ele: um `AppInteraction` de tamanho zero seria um alvo fantasma,
  /// anunciado ao leitor de tela e sem nada para tocar.
  final String? logoUrl;

  /// Site que o logo abre ao ser tocado. Opcional.
  ///
  /// Vem por parâmetro, e não de um singleton de marca. O organism lia
  /// `AppBrand.current.websiteUrl` — era o único ponto de `lib/src` que
  /// alcançava a marca global para buscar um dado que já chegava por parâmetro
  /// ao seu lado ([brandSubtitle], [brandTitle], [logoUrl]). Um componente que
  /// lê um registry estático não é testável sem esse registry, não é reusável em
  /// duas marcas na mesma tela, e força o design system a ter opinião sobre onde
  /// o dado mora.
  ///
  /// `null` mantém o logo desenhado, mas sem link: ausência de site é um estado,
  /// não um erro. É a mesma decisão de [logoUrl] — só que aqui o que some é a
  /// interação, não a imagem.
  final String? websiteUrl;

  /// Marca como **widget** — o SVG/imagem que vive no bundle do app (o canal
  /// [logoUrl] exige provider de ícone). Mutuamente exclusivo com [logoUrl] e
  /// exige [logoSemanticLabel] (asserts).
  ///
  /// Semântica: o idioma é o do `AppImage` — a subárvore do widget é
  /// **substituída** por um nó de imagem nomeado por [logoSemanticLabel]
  /// (`ExcludeSemantics` por dentro), então a marca é anunciada UMA vez. Com
  /// [websiteUrl], o link mantém o rótulo fixo 'Abrir site da marca' como nó
  /// próprio dentro do nó da marca.
  final Widget? logo;

  /// Nome acessível da marca quando o logo vem por widget (ou para nomear o
  /// ícone de [logoUrl]). Obrigatório junto com [logo]; é também o que
  /// satisfaz a identidade quando [brandTitle] está ausente.
  final String? logoSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData? mediaQueryData = MediaQuery.maybeOf(context);
    final double viewportWidth =
        mediaQueryData?.size.width ?? AppDevice.tablet.breakpoint;
    final bool isMobile = viewportWidth < AppDevice.mobile.breakpoint;

    if (isMobile) {
      return _AuthMobileLayout(
        backgroundImageUrl: backgroundImageUrl,
        brandSubtitle: brandSubtitle,
        brandTitle: brandTitle,
        logoUrl: logoUrl,
        logo: logo,
        logoSemanticLabel: logoSemanticLabel,
        websiteUrl: websiteUrl,
        child: child,
      );
    }

    return _AuthDesktopLayout(
      backgroundImageUrl: backgroundImageUrl,
      brandSubtitle: brandSubtitle,
      brandTitle: brandTitle,
      logoUrl: logoUrl,
      logo: logo,
      logoSemanticLabel: logoSemanticLabel,
      websiteUrl: websiteUrl,
      child: child,
    );
  }
}

final class _AuthBackground extends StatelessWidget {
  const _AuthBackground({
    required this.fallbackColor,
    this.imageUrl,
    this.overlayColor,
  });

  final Color fallbackColor;
  final String? imageUrl;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    final String? resolvedImageUrl = imageUrl?.trim();
    final Widget backgroundChild =
        resolvedImageUrl == null || resolvedImageUrl.isEmpty
        ? ColoredBox(color: fallbackColor)
        : _AuthBackgroundImage(
            fallbackColor: fallbackColor,
            imageUrl: resolvedImageUrl,
          );

    return Stack(
      children: <Widget>[
        Positioned.fill(child: backgroundChild),
        if (overlayColor != null)
          Positioned.fill(child: ColoredBox(color: overlayColor!)),
      ],
    );
  }
}

final class _AuthBackgroundImage extends StatelessWidget {
  const _AuthBackgroundImage({
    required this.fallbackColor,
    required this.imageUrl,
  });

  final Color fallbackColor;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final bool isSvg = imageUrl.toLowerCase().endsWith('.svg');

    if (isSvg) {
      return SvgPicture.network(
        imageUrl,
        alignment: Alignment.center,
        excludeFromSemantics: true,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => ColoredBox(color: fallbackColor),
      );
    }

    return Image.network(
      imageUrl,
      alignment: Alignment.center,
      errorBuilder: (_, _, _) => ColoredBox(color: fallbackColor),
      excludeFromSemantics: true,
      fit: BoxFit.cover,
    );
  }
}

final class _AuthBrandPanel extends StatelessWidget {
  const _AuthBrandPanel({
    required this.brandSubtitle,
    required this.brandTitle,
    required this.child,
    required this.logoAlignment,
    required this.logoUrl,
    required this.logo,
    required this.logoSemanticLabel,
    required this.websiteUrl,
    this.padding = const EdgeInsets.all(AppSpacings.s32),
    this.useSafeArea = true,
  });

  final String? brandSubtitle;
  final String? brandTitle;
  final Widget child;
  final Alignment logoAlignment;
  final String? logoUrl;
  final Widget? logo;
  final String? logoSemanticLabel;
  final EdgeInsets padding;
  final bool useSafeArea;
  final String? websiteUrl;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    // Token de CARTÃO, não branco fixo: o painel é uma superfície elevada sobre
    // a foto de fundo. No claro isso continua branco; no escuro ele escurece
    // junto com o resto — antes ficava branco fixo e engolia os textos do tema
    // escuro (`onSurface` claro sobre painel branco).
    final Color panelColor = theme.colorTheme.surfaceContainer;
    final Widget panelContent = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Sem logo, o espaçador sai junto: senão o painel abre com 32px de
          // vazio inexplicável no lugar de simplesmente começar pelo título.
          if (logoUrl != null || logo != null) ...<Widget>[
            Align(
              alignment: logoAlignment,
              child: _AuthLogo(
                logoUrl: logoUrl,
                logo: logo,
                logoSemanticLabel: logoSemanticLabel,
                websiteUrl: websiteUrl,
              ),
            ),
            const SizedBox(height: AppSpacings.s32),
          ],
          // Collection-if sem respiro órfão: com os dois textos, a sequência é
          // a de sempre (título, s8, subtítulo, s8, child).
          if (brandTitle case final String title)
            AppText(
              title,
              textAlign: TextAlign.start,
              style: theme.textTheme.titleLarge.copyWith(
                // Stop legível sobre o painel: a marca crua serve ao painel
                // claro, mas no escuro o mesmo vermelho encosta no fundo
                // elevado.
                color: readableStopOn(
                  theme.colorTheme.primary,
                  panelColor,
                  minRatio: kAaNormal,
                ),
              ),
            ),
          if (brandTitle != null && brandSubtitle != null)
            const SizedBox(height: AppSpacings.s8),
          if (brandSubtitle case final String subtitle)
            AppText(
              subtitle,
              textAlign: TextAlign.start,
              style: theme.textTheme.bodyMedium.copyWith(
                color: readableStopOn(
                  theme.colorTheme.secondary,
                  panelColor,
                  minRatio: kAaNormal,
                ),
              ),
            ),
          if (brandTitle != null || brandSubtitle != null)
            const SizedBox(height: AppSpacings.s8),
          Expanded(child: child),
        ],
      ),
    );

    return ColoredBox(
      color: panelColor,
      child: useSafeArea ? SafeArea(child: panelContent) : panelContent,
    );
  }
}

final class _AuthDesktopLayout extends StatelessWidget {
  const _AuthDesktopLayout({
    required this.backgroundImageUrl,
    required this.brandSubtitle,
    required this.brandTitle,
    required this.child,
    required this.logoUrl,
    required this.logo,
    required this.logoSemanticLabel,
    required this.websiteUrl,
  });

  final String? backgroundImageUrl;
  final String? brandSubtitle;
  final String? brandTitle;
  final Widget child;
  final String? logoUrl;
  final Widget? logo;
  final String? logoSemanticLabel;
  final String? websiteUrl;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final Color overlayColor = theme.colorTheme.primary.customOpacity(.4);

    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _AuthBrandPanel(
            brandSubtitle: brandSubtitle,
            brandTitle: brandTitle,
            logoAlignment: Alignment.topLeft,
            logoUrl: logoUrl,
            logo: logo,
            logoSemanticLabel: logoSemanticLabel,
            websiteUrl: websiteUrl,
            child: child,
          ),
        ),
        Expanded(
          flex: 8,
          child: _AuthBackground(
            fallbackColor: theme.colorTheme.surface,
            imageUrl: backgroundImageUrl,
            overlayColor: overlayColor,
          ),
        ),
      ],
    );
  }
}

final class _AuthLogo extends StatelessWidget {
  const _AuthLogo({
    required this.logoUrl,
    required this.logo,
    required this.logoSemanticLabel,
    required this.websiteUrl,
  });

  final String? logoUrl;
  final Widget? logo;
  final String? logoSemanticLabel;
  final String? websiteUrl;

  @override
  Widget build(BuildContext context) {
    // Idioma do AppImage: com rótulo, a subárvore do widget sai da semântica e
    // quem fala é o nó de imagem nomeado — sem isso o rótulo mescla com o
    // texto interno e o leitor anuncia a marca duas vezes. O slug (AppIcon) já
    // é decorativo por construção.
    final Widget rawVisual = logo ?? AppIcon(logoUrl!, size: AppIconSize.l);
    final Widget visual = logoSemanticLabel != null && logo != null
        ? ExcludeSemantics(child: rawVisual)
        : rawVisual;
    final String? site = websiteUrl?.trim();
    // Sem site, o logo é imagem e nada mais. Envolvê-lo num `AppInteraction`
    // mesmo assim daria cursor de mão, rótulo de leitor de tela e um toque que
    // não leva a lugar nenhum — o alvo fantasma que a ausência de logo já evita
    // do outro lado.
    Widget core = visual;
    if (site != null && site.isNotEmpty) {
      final Uri websiteUri = Uri.parse(site);
      // O rótulo do link é FIXO (contrato de teste): a exclusão acima garante
      // que o merge do botão não concatena o texto interno do widget.
      core = AppInteraction(
        onTap: () => launchUrl(websiteUri, webOnlyWindowName: '_blank'),
        mouseCursor: SystemMouseCursors.click,
        semanticLabel: 'Abrir site da marca',
        child: visual,
      );
    }
    if (logoSemanticLabel == null) return core;
    return Semantics(
      image: true,
      label: logoSemanticLabel,
      container: true,
      child: core,
    );
  }
}

final class _AuthMobileLayout extends StatelessWidget {
  const _AuthMobileLayout({
    required this.backgroundImageUrl,
    required this.brandSubtitle,
    required this.brandTitle,
    required this.child,
    required this.logoUrl,
    required this.logo,
    required this.logoSemanticLabel,
    required this.websiteUrl,
  });

  static const double _mobileCardMaxHeight = 760;
  static const double _mobileCardMaxWidth = 520;

  final String? backgroundImageUrl;
  final String? brandSubtitle;
  final String? brandTitle;
  final Widget child;
  final String? logoUrl;
  final Widget? logo;
  final String? logoSemanticLabel;
  final String? websiteUrl;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData? mediaQueryData = MediaQuery.maybeOf(context);
    final AppThemeData theme = AppTheme.of(context);
    final Color overlayColor = theme.colorTheme.primary.customOpacity(.4);
    // Escala de superfície (24/48), NÃO o resolver genérico: o card é
    // content-sized, então `circular` cairia no sentinela e saturaria em metade
    // do lado menor — o card virava um círculo que cortava título e subtítulo.
    final BorderRadius cardRadius = BorderRadius.circular(
      theme.radiusTheme.surfaceCornerRadius(),
    );
    final double viewPaddingVertical =
        mediaQueryData?.viewPadding.vertical ?? AppSpacings.s0;
    final double viewInsetsBottom =
        mediaQueryData?.viewInsets.bottom ?? AppSpacings.s0;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableHeight = constraints.maxHeight;
        final double safeAreaHeight = math.max(
          AppSpacings.s0,
          availableHeight - viewPaddingVertical,
        );
        final double cardWidth = math.max(
          AppSpacings.s0,
          math.min(
            _mobileCardMaxWidth,
            constraints.maxWidth - (AppSpacings.s16 * 2),
          ),
        );
        final double minimumScrollHeight = math.max(
          AppSpacings.s0,
          safeAreaHeight - (AppSpacings.s16 * 2),
        );
        final double maxCardHeight = math.max(
          AppSpacings.s0,
          minimumScrollHeight - (AppSpacings.s32 * 2),
        );
        final double cardHeight = math.min(_mobileCardMaxHeight, maxCardHeight);

        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: _AuthBackground(
                fallbackColor: theme.colorTheme.surface,
                imageUrl: backgroundImageUrl,
                overlayColor: overlayColor,
              ),
            ),
            SafeArea(
              child: AnimatedPadding(
                duration: AppMotion.resolve(context, AppDurations.normal),
                padding: EdgeInsets.only(bottom: viewInsetsBottom),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacings.s16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: minimumScrollHeight),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacings.s32),
                        child: SizedBox(
                          height: cardHeight,
                          width: cardWidth,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  blurRadius: AppSizes.s32,
                                  color: theme.colorTheme.neutralBlack.s200
                                      .withValues(alpha: 0.30),
                                  offset: const Offset(
                                    AppSizes.s0,
                                    AppSizes.s8,
                                  ),
                                ),
                              ],
                              borderRadius: cardRadius,
                            ),
                            child: ClipRRect(
                              borderRadius: cardRadius,
                              child: _AuthBrandPanel(
                                brandSubtitle: brandSubtitle,
                                brandTitle: brandTitle,
                                logoAlignment: Alignment.topLeft,
                                logoUrl: logoUrl,
                                logo: logo,
                                logoSemanticLabel: logoSemanticLabel,
                                padding: const EdgeInsets.all(AppSpacings.s16),
                                useSafeArea: false,
                                websiteUrl: websiteUrl,
                                child: child,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
