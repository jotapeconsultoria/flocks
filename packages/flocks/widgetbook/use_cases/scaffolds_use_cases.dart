import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppScaffold — layout de página (header · conteúdo · footer sobre a surface).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppScaffold)
Widget scaffoldPlayground(BuildContext context) {
  final bool withHeader = context.knobs.boolean(
    label: 'header',
    initialValue: true,
  );
  final bool withFooter = context.knobs.boolean(
    label: 'footer',
    initialValue: true,
  );

  return wbUseCase(
    context,
    name: 'AppScaffold',
    description:
        'Page layout: optional header on top, expanded content, optional '
        'footer at the bottom, over the theme surface.',
    maxWidth: 420,
    child: SizedBox(
      height: 280,
      child: AppScaffold(
        header: withHeader
            ? const AppSimpleHeader(child: AppText('Veículos'))
            : null,
        footer: withFooter
            ? const Padding(
                padding: EdgeInsets.all(AppSpacings.s16),
                child: AppText('Footer'),
              )
            : null,
        child: const Center(child: AppText('Conteúdo')),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Glass over backdrop', type: AppScaffold)
Widget scaffoldGlassOverlay(BuildContext context) {
  final theme = AppTheme.of(context);
  final bool? glass = wbGlassKnob(context);
  final AppStyle? style = wbStyleKnob(context);
  final bool glassOn = glass ?? theme.glassTheme.enabled;

  return wbUseCase(
    context,
    name: 'AppScaffold',
    description:
        'Header and footer over one scrolling page — the Notes effect end to '
        'end. Drag the feed to judge both seams at once.',
    maxWidth: 640,
    panel: false,
    child: wbBarScene(
      context,
      height: 680,
      header: AppPrimaryHeader(
        style: style ?? AppStyle.filled,
        glass: glass,
        leading: AppPrimaryHeader.action(
          context,
          icon: AppIconToken.chevronLeft,
          onTap: () {},
          glass: glassOn,
          semanticLabel: 'Voltar',
        ),
        trailing: AppPrimaryHeader.action(
          context,
          icon: AppIconToken.settings,
          onTap: () {},
          glass: glassOn,
          semanticLabel: 'Configurações',
        ),
        child: AppText('Detalhes', style: theme.textTheme.titleLarge),
      ),
      footer: AppNavigationFooter(
        style: style ?? AppStyle.filled,
        glass: glass,
        getCurrentRoute: (_) => '/vehicles',
        items: <AppNavigationFooterItemData>[
          AppNavigationFooterItemData(
            icon: AppIconToken.dashboard,
            title: 'Início',
            route: '/home',
            onPressed: (_, _) {},
          ),
          AppNavigationFooterItemData(
            icon: AppIconToken.car,
            title: 'Veículos',
            route: '/vehicles',
            onPressed: (_, _) {},
          ),
          AppNavigationFooterItemData(
            icon: AppIconToken.settings,
            title: 'Ajustes',
            route: '/settings',
            onPressed: (_, _) {},
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// AppAuthSplitLayout — layout das telas de autenticação (desktop/mobile).
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppAuthSplitLayout)
Widget authSplitLayoutPlayground(BuildContext context) {
  final String title = context.knobs.string(
    label: 'brandTitle (empty = none)',
    initialValue: 'Bem-vindo de volta',
  );
  final String subtitle = context.knobs.string(
    label: 'brandSubtitle (empty = none)',
    initialValue: 'Acesse sua conta para continuar.',
  );
  final bool widgetLogo = context.knobs.boolean(
    label: 'logo (widget channel)',
    initialValue: false,
  );
  final String? brandTitle = title.isEmpty ? null : title;

  return wbUseCase(
    context,
    name: 'AppAuthSplitLayout',
    description:
        'Auth screen layout: brand panel + form (desktop) / centered card '
        '(mobile). Resize the device frame to see the breakpoint switch.',
    maxWidth: 900,
    child: SizedBox(
      height: 520,
      child: AppAuthSplitLayout(
        // Identidade sempre presente: sem título, o rótulo da marca assume.
        brandTitle: brandTitle,
        brandSubtitle: subtitle.isEmpty ? null : subtitle,
        logoUrl: widgetLogo ? null : AppIconToken.infoCircle,
        logo: widgetLogo
            ? Builder(
                builder: (BuildContext context) => AppText(
                  'ACME',
                  style: AppTheme.of(context).textTheme.titleLarge,
                ),
              )
            : null,
        logoSemanticLabel: widgetLogo || brandTitle == null ? 'ACME' : null,
        child: const Center(child: AppText('formulário')),
      ),
    ),
  );
}

Widget _scaffoldSample({required bool header, required bool footer}) =>
    SizedBox(
      width: 240,
      height: 220,
      child: AppScaffold(
        header: header
            ? const AppSimpleHeader(child: AppText('Veículos'))
            : null,
        footer: footer
            ? const Padding(
                padding: EdgeInsets.all(AppSpacings.s16),
                child: AppText('Footer'),
              )
            : null,
        child: const Center(child: AppText('Conteúdo')),
      ),
    );

@widgetbook.UseCase(name: 'States', type: AppScaffold)
Widget scaffoldStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppScaffold',
  description: 'Header/footer slot combinations.',
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s32,
    children: <Widget>[
      wbState(
        context,
        name: 'Header + footer',
        width: 240,
        child: _scaffoldSample(header: true, footer: true),
      ),
      wbState(
        context,
        name: 'Header only',
        width: 240,
        child: _scaffoldSample(header: true, footer: false),
      ),
      wbState(
        context,
        name: 'Content only',
        width: 240,
        child: _scaffoldSample(header: false, footer: false),
      ),
    ],
  ),
);

@widgetbook.UseCase(name: 'States', type: AppAuthSplitLayout)
Widget authSplitLayoutStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppAuthSplitLayout',
  description:
      'Responsive layout: brand panel + form. Resize the device frame to see '
      'the desktop/mobile breakpoint switch.',
  maxWidth: 720,
  child: const SizedBox(
    height: 440,
    child: AppAuthSplitLayout(
      brandTitle: 'Bem-vindo de volta',
      brandSubtitle: 'Acesse sua conta para continuar.',
      logoUrl: AppIconToken.infoCircle,
      child: Center(child: AppText('formulário')),
    ),
  ),
);
