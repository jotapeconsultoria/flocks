import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppCard — Playground (all knobs) + Variants (os arquétipos header/child/
// footer). Container estático, sem CTA embutido.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppCard)
Widget cardPlayground(BuildContext context) {
  final theme = AppTheme.of(context);
  final String headerTitle = context.knobs.string(
    label: 'headerTitle',
    initialValue: 'Localização',
  );
  final bool leading = context.knobs.boolean(
    label: 'headerLeading',
    initialValue: false,
  );
  final bool trailing = context.knobs.boolean(
    label: 'headerTrailing',
    initialValue: true,
  );
  final bool footer = context.knobs.boolean(
    label: 'footer',
    initialValue: false,
  );
  final bool showDividers = context.knobs.boolean(
    label: 'showDividers',
    initialValue: false,
  );
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final Color? accent = wbSemanticColorKnob(context, label: 'accentColor');

  return wbUseCase(
    context,
    name: 'AppCard',
    description:
        'Structured card: optional header (leading/title/trailing), '
        'child and footer. style/radius follow the addons unless overridden.',
    child: SizedBox(
      width: 340,
      child: AppCard(
        headerTitle: headerTitle.isEmpty ? null : headerTitle,
        headerLeading: leading
            ? AppIcon(
                AppIcons.geoArea,
                customSize: 20,
                color: theme.colorTheme.onSurface,
              )
            : null,
        headerTrailing: trailing
            ? AppText(
                'Ver no mapa',
                style: theme.textTheme.labelLarge.withColor(
                  theme.colorTheme.primary,
                ),
              )
            : null,
        footer: footer
            ? Align(
                alignment: Alignment.centerRight,
                child: wbCta(context, label: 'Action', onPressed: () {}),
              )
            : null,
        showDividers: showDividers,
        style: style,
        radiusMode: radiusMode,
        accentColor: accent,
        child: AppText(
          'Av. Quintino Bocaiúva, 61 — São Francisco, Niterói/RJ.',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Scenario', type: AppCard)
Widget cardVariants(BuildContext context) {
  final theme = AppTheme.of(context);

  Widget metric(String label, String value, {Color? color}) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AppText(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall.withColor(
          theme.colorTheme.neutralPrimary.s600,
        ),
      ),
      const SizedBox(height: AppSpacings.s2),
      AppText(
        value,
        style: theme.textTheme.titleMedium.withColor(
          color ?? theme.colorTheme.onSurface,
        ),
      ),
    ],
  );

  return wbUseCase(
    context,
    name: 'AppCard',
    description:
        'The header/child/footer archetypes: a location panel, a summary '
        'header, a ranking with dividers, and an error with a footer action.',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 1 — header (title + trailing action) + child.
          AppCard(
            headerTitle: 'Localização',
            headerTrailing: AppText(
              'Ver no mapa',
              style: theme.textTheme.labelLarge.withColor(
                theme.colorTheme.primary,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppText(
                  'Av. Quintino Bocaiúva, 61 — São Francisco, Niterói/RJ',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacings.s16),
                Row(
                  children: <Widget>[
                    Expanded(child: metric('Velocidade', '0 km/h')),
                    Expanded(
                      child: metric(
                        'Ignição',
                        'Desligada',
                        color: theme.colorTheme.danger,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacings.s24),

          // 2 — header (leading icon + title + trailing summary) + child.
          AppCard(
            headerLeading: AppIcon(
              AppIconToken.car,
              customSize: 20,
              color: theme.colorTheme.onSurface,
            ),
            headerTitle: 'Temperatura do motor',
            headerTrailing: AppText(
              'máx 90 °C',
              style: theme.textTheme.titleMedium.withColor(
                theme.colorTheme.onSurface,
              ),
            ),
            child: AppText(
              'Média de 83 °C na última viagem.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacings.s24),

          // 3 — header (leading + title + trailing) + child, com divisórias.
          AppCard(
            showDividers: true,
            headerLeading: AppIcon(
              AppIconToken.calendar,
              customSize: 20,
              color: theme.colorTheme.onSurface,
            ),
            headerTitle: 'Abril',
            headerTrailing: AppIcon(
              AppIcons.driverRanking,
              customSize: 20,
              color: theme.colorTheme.onSurface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (final (String pos, String pts) in <(String, String)>[
                  ('1º', '755,15'),
                  ('2º', '300,00'),
                  ('3º', '210,40'),
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacings.s4,
                    ),
                    child: Row(
                      children: <Widget>[
                        AppText(pos, style: theme.textTheme.bodyMedium),
                        const SizedBox(width: AppSpacings.s16),
                        Expanded(
                          child: AppText(
                            'João Pedro dos Santos Martins',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        AppText(pts, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacings.s24),

          // 4 — header (leading + title) + child + footer, com divisórias.
          AppCard(
            showDividers: true,
            headerLeading: AppIcon(
              AppIconToken.errorCircle,
              customSize: 20,
              color: theme.colorTheme.danger,
            ),
            headerTitle: 'Erro inesperado',
            footer: Align(
              alignment: Alignment.centerRight,
              child: wbCta(context, label: 'Try again', onPressed: () {}),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppText(
                  'Ocorreu um erro!',
                  style: theme.textTheme.titleMedium.withColor(
                    theme.colorTheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacings.s8),
                AppText(
                  'Não se preocupe. Espere uns minutos e tente novamente.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppCard)
Widget cardStates(BuildContext context) {
  final theme = AppTheme.of(context);
  Widget body(String text) => AppText(text, style: theme.textTheme.bodyMedium);

  return wbUseCase(
    context,
    name: 'AppCard',
    description: 'Every container style plus the divider and accent variants.',
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s32,
      children: <Widget>[
        wbState(
          context,
          name: 'Filled',
          when: 'Default surface',
          width: 300,
          child: AppCard(
            style: AppStyle.filled,
            headerTitle: 'Localização',
            child: body('Av. Quintino Bocaiúva, 61 — Niterói/RJ.'),
          ),
        ),
        wbState(
          context,
          name: 'Outlined',
          when: 'On a busy surface',
          width: 300,
          child: AppCard(
            style: AppStyle.outlined,
            headerTitle: 'Localização',
            child: body('Av. Quintino Bocaiúva, 61 — Niterói/RJ.'),
          ),
        ),
        wbState(
          context,
          name: 'Elevated',
          when: 'Raised emphasis',
          width: 300,
          child: AppCard(
            style: AppStyle.elevated,
            headerTitle: 'Localização',
            child: body('Av. Quintino Bocaiúva, 61 — Niterói/RJ.'),
          ),
        ),
        wbState(
          context,
          name: 'Dividers',
          when: 'Separate sections',
          width: 300,
          child: AppCard(
            style: AppStyle.outlined,
            showDividers: true,
            headerTitle: 'Abril',
            child: body('755,15 pontos no ranking.'),
          ),
        ),
        wbState(
          context,
          name: 'Accent',
          when: 'Highlight a card',
          width: 300,
          child: AppCard(
            style: AppStyle.outlined,
            accentColor: theme.colorTheme.danger,
            headerLeading: AppIcon(
              AppIconToken.errorCircle,
              customSize: 20,
              color: theme.colorTheme.danger,
            ),
            headerTitle: 'Erro inesperado',
            child: body('Espere uns minutos e tente novamente.'),
          ),
        ),
      ],
    ),
  );
}
