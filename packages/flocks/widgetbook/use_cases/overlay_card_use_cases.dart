import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppOverlayCard — card flutuante que intercepta o ponteiro.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppOverlayCard)
Widget overlayCardPlayground(BuildContext context) {
  final String text = context.knobs.string(
    label: 'text',
    initialValue: 'Painel flutuante sobre o mapa',
  );
  final AppStyle? style = wbStyleKnob(context);
  final AppRadiusMode? radiusMode = wbRadiusModeKnob(context);
  final glass = wbGlassKnob(context);
  return wbUseCase(
    context,
    name: 'AppOverlayCard',
    description:
        'Floating card that intercepts pointer events (for panels over a map). '
        'Like AppCard + interception.',
    child: SizedBox(
      width: 280,
      child: AppOverlayCard(
        glass: glass,
        style: style,
        radiusMode: radiusMode,
        child: AppText(text),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppOverlayCard)
Widget overlayCardStates(BuildContext context) {
  final AppColorTheme colors = AppTheme.of(context).colorTheme;
  return wbUseCase(
    context,
    name: 'AppOverlayCard',
    description: 'Default (neutral) vs an accent border (outlined).',
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacings.s24,
      runSpacing: AppSpacings.s24,
      children: <Widget>[
        wbState(
          context,
          name: 'Elevated',
          width: 240,
          child: const AppOverlayCard(child: AppText('Elevado')),
        ),
        wbState(
          context,
          name: 'Outlined + accent',
          width: 240,
          child: AppOverlayCard(
            style: AppStyle.outlined,
            accentColor: colors.primary,
            child: const AppText('Com borda'),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Glass over backdrop', type: AppOverlayCard)
Widget overlayCardGlass(BuildContext context) {
  // `panel: false`: o vidro precisa de um fundo colorido/variado ATRÁS para o
  // frost (backdrop blur) ter o que desfocar — num painel chapado ele some.
  return wbUseCase(
    context,
    name: 'AppOverlayCard · Glass',
    description:
        'Frosted glass (glass axis) floating over a colorful backdrop — the '
        'blur samples what is painted behind it. Falls back to an opaque '
        'elevated surface when transparency is reduced (high contrast / invert '
        'colors, or the transparencyTheme flag).',
    panel: false,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 340,
        width: 420,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(child: wbMockFeed(context)),
            const SizedBox(
              width: 280,
              child: AppOverlayCard(
                glass: true,
                child: AppText(
                  'Frosted glass sobre o fundo — o desfoque amostra o que está '
                  'pintado atrás.',
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
