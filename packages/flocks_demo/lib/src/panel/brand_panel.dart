import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

import '../state/brand_from_config.dart';
import '../state/demo_config.dart';
import '../state/demo_logo.dart';

/// O painel que veste a demo com a marca do visitante.
///
/// Ele é feito dos MESMOS componentes que a demo demonstra — o seletor de cor é
/// o `AppColorPickerInput`, os eixos são `AppDropdown`, o brilho é um
/// `AppSwitch`, o snippet sai num `AppCodeBlock` que já traz o botão de copiar.
/// Não é economia de trabalho: é o argumento. Um painel de controle construído
/// em Material, controlando componentes Flocks, contaria a história errada
/// sobre o que o pacote dá conta de fazer.
class BrandPanel extends StatelessWidget {
  /// Cria o painel.
  const BrandPanel({
    required this.config,
    required this.logo,
    required this.logoError,
    required this.onChanged,
    required this.onPickLogo,
    required this.onRemoveLogo,
    required this.pickingLogo,
    required this.shareUrl,
    super.key,
  });

  /// A configuração corrente.
  final DemoConfig config;

  /// O logo carregado, se houver.
  final DemoLogo? logo;

  /// A mensagem de erro do último upload, se ele falhou.
  final String? logoError;

  /// Chamado a cada mexida num eixo.
  final ValueChanged<DemoConfig> onChanged;

  /// Abre o seletor de arquivo.
  final VoidCallback onPickLogo;

  /// Descarta o logo da memória.
  final VoidCallback onRemoveLogo;

  /// Se o seletor de arquivo está aberto.
  final bool pickingLogo;

  /// O link que reproduz esta configuração — sem o logo.
  final String shareUrl;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppText(
            'Your brand',
            style: theme.textTheme.titleMedium.withColor(
              theme.colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacings.s4),
          AppText(
            'One hex seed dresses every component on the screen.',
            style: theme.textTheme.bodySmall.withColor(
              theme.colorTheme.neutralPrimary.s700,
            ),
          ),
          const SizedBox(height: AppSpacings.s16),

          AppColorPickerInput(
            label: 'Brand colour',
            // O campo fala hex, e o pacote já traz as duas pontas da conversão
            // — o mesmo par que o `seed` da URL usa.
            value: colorToHex(config.seed),
            onChanged: (String hex) => onChanged(
              config.copyWith(
                seed: parseHexColorOr(hex, DemoConfig.kDefaultSeed),
              ),
            ),
          ),
          const SizedBox(height: AppSpacings.s16),

          _LogoField(
            logo: logo,
            error: logoError,
            picking: pickingLogo,
            onPick: onPickLogo,
            onRemove: onRemoveLogo,
          ),
          const SizedBox(height: AppSpacings.s24),

          // Os três eixos saem em dropdown, e não em `AppSegmentedButton`.
          //
          // Um segmented dimensiona os segmentos pela largura INTRÍNSECA do
          // rótulo, e neste painel o rótulo muda de largura debaixo do layout:
          // a fonte é um dos eixos que o visitante controla, então trocar
          // Poppins por Space Grotesk estoura a linha que cabia um segundo
          // antes. Não é um número a ajustar — é um componente errado para um
          // painel estreito cuja tipografia é variável.
          //
          // Os segmented continuam na demo onde há largura para eles: o
          // seletor de período do dashboard e o de estado do CRUD.
          _Axis(
            label: 'Container style',
            child: AppDropdown<AppStyle>(
              selectedValue: config.style,
              options: <AppDropdownOption<AppStyle>>[
                for (final AppStyle style in AppStyle.values)
                  AppDropdownOption<AppStyle>(value: style, label: style.name),
              ],
              size: AppFieldSize.s,
              onChanged: (AppStyle? style) =>
                  onChanged(config.copyWith(style: style ?? config.style)),
            ),
          ),
          _Axis(
            label: 'Corner shape',
            child: AppDropdown<AppRadiusMode>(
              selectedValue: config.radius,
              options: <AppDropdownOption<AppRadiusMode>>[
                for (final AppRadiusMode mode in AppRadiusMode.values)
                  AppDropdownOption<AppRadiusMode>(
                    value: mode,
                    label: mode.name,
                  ),
              ],
              size: AppFieldSize.s,
              onChanged: (AppRadiusMode? mode) =>
                  onChanged(config.copyWith(radius: mode ?? config.radius)),
            ),
          ),
          _Axis(
            label: 'Typeface',
            child: AppDropdown<DemoFont>(
              selectedValue: config.font,
              options: const <AppDropdownOption<DemoFont>>[
                AppDropdownOption<DemoFont>(
                  value: DemoFont.poppins,
                  label: 'Poppins',
                ),
                AppDropdownOption<DemoFont>(
                  value: DemoFont.spaceGrotesk,
                  label: 'Space Grotesk',
                ),
              ],
              size: AppFieldSize.s,
              onChanged: (DemoFont? font) =>
                  onChanged(config.copyWith(font: font ?? config.font)),
            ),
          ),
          const SizedBox(height: AppSpacings.s8),
          Row(
            children: <Widget>[
              Expanded(
                child: AppText(
                  'Dark theme',
                  style: theme.textTheme.labelMedium.withColor(
                    theme.colorTheme.onSurface,
                  ),
                ),
              ),
              AppSwitch(
                value: config.dark,
                semanticLabel: 'Dark theme',
                onChanged: (bool dark) =>
                    onChanged(config.copyWith(dark: dark)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacings.s8),
          AppText(
            'Both themes come from the same seed — there is no second palette '
            'to keep in sync.',
            style: theme.textTheme.labelSmall.withColor(
              theme.colorTheme.neutralPrimary.s600,
            ),
          ),

          const SizedBox(height: AppSpacings.s24),
          const AppDivider(),
          const SizedBox(height: AppSpacings.s16),

          _ShareBlock(url: shareUrl, hasLogo: logo != null),
          const SizedBox(height: AppSpacings.s24),

          AppText(
            'Take it with you',
            style: theme.textTheme.titleSmall.withColor(
              theme.colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacings.s8),
          AppText(
            'This is the whole configuration. Paste it into an app that '
            'depends on flocks and it compiles.',
            style: theme.textTheme.bodySmall.withColor(
              theme.colorTheme.neutralPrimary.s700,
            ),
          ),
          const SizedBox(height: AppSpacings.s12),
          AppCodeBlock(
            code: brandFromConfig(config).toDartSnippet(dark: config.dark),
            language: 'dart',
            wrap: true,
          ),
        ],
      ),
    );
  }
}

class _Axis extends StatelessWidget {
  const _Axis({required this.child, required this.label});

  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacings.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppText(
            label,
            style: theme.textTheme.labelMedium.withColor(
              theme.colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacings.s8),
          child,
        ],
      ),
    );
  }
}

class _LogoField extends StatelessWidget {
  const _LogoField({
    required this.error,
    required this.logo,
    required this.onPick,
    required this.onRemove,
    required this.picking,
  });

  final String? error;
  final DemoLogo? logo;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final bool picking;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppText(
          'Logo',
          style: theme.textTheme.labelMedium.withColor(
            theme.colorTheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacings.s8),
        if (logo != null) ...<Widget>[
          AppCard(
            style: AppStyle.outlined,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: logo!.build(height: 32, semanticLabel: 'Your logo'),
                  ),
                ),
                AppButton(
                  label: 'Remove',
                  size: AppButtonSize.s,
                  style: AppStyle.outlined,
                  color: AppButtonColor.neutral,
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacings.s8),
        ] else
          AppButton(
            label: 'Upload a logo',
            icon: AppIconToken.imageLandscape,
            style: AppStyle.outlined,
            expandedWidth: true,
            loading: picking,
            onPressed: onPick,
          ),
        if (error != null) ...<Widget>[
          const SizedBox(height: AppSpacings.s8),
          AppText(
            error!,
            style: theme.textTheme.labelSmall.withColor(
              theme.colorTheme.danger,
            ),
          ),
        ],
        const SizedBox(height: AppSpacings.s8),
        // Não é rodapé de política: é a explicação de por que o link
        // compartilhável NÃO vai levar o logo junto. Dizer isso só no código
        // deixaria o visitante achando que é bug.
        AppText(
          'Your logo never leaves this tab. It is held in memory, never '
          'uploaded, and gone when you close the page.',
          style: theme.textTheme.labelSmall.withColor(
            theme.colorTheme.neutralPrimary.s600,
          ),
        ),
      ],
    );
  }
}

class _ShareBlock extends StatelessWidget {
  const _ShareBlock({required this.hasLogo, required this.url});

  final bool hasLogo;
  final String url;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: AppText(
                'Share this look',
                style: theme.textTheme.titleSmall.withColor(
                  theme.colorTheme.onSurface,
                ),
              ),
            ),
            AppCopyButton(
              value: url,
              copyTooltip: 'Copy link',
              copiedTooltip: 'Link copied',
            ),
          ],
        ),
        const SizedBox(height: AppSpacings.s8),
        AppText(
          hasLogo
              ? 'The link carries the colour, the typeface and the axes — but '
                    'not your logo. Whoever opens it sees your brand, without '
                    'your file.'
              : 'The link carries the colour, the typeface and the axes.',
          style: theme.textTheme.bodySmall.withColor(
            theme.colorTheme.neutralPrimary.s700,
          ),
        ),
      ],
    );
  }
}
