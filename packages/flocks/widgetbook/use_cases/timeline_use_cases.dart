import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// AppTimeline — Playground (contagem e rodapé) + Catalog (a trilha do jeito que
// ela aparece: eventos heterogêneos, um deles negado).
//
// O Catalog carrega um evento NEGADO de propósito: o marcador padrão é um ponto
// só, e é aqui que se vê se "negado" continua legível quando a cor não pode ser
// a única diferença (Regra 8).
// ---------------------------------------------------------------------------

const List<(String, String, bool)> _eventos = <(String, String, bool)>[
  ('Cliente encerrado', 'há 2 minutos · Ana Souza', false),
  ('Tentativa de encerrar negada', 'há 30 minutos · Ana Souza', true),
  ('Retenção alterada', 'há 1 hora · Equipe Trackd', false),
  ('Carteira trocada', 'ontem · Bruno Lima', false),
  ('Cliente criado', 'há 3 dias · Ana Souza', false),
];

Widget _linha(BuildContext context, (String, String, bool) e) {
  final AppThemeData theme = AppTheme.of(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          Flexible(child: AppText(e.$1, style: theme.textTheme.bodyMedium)),
          if (e.$3) ...<Widget>[
            const SizedBox(width: AppSpacings.s8),
            const AppBadge('Negado', color: AppBadgeColor.danger),
          ],
        ],
      ),
      AppText(e.$2, style: theme.textTheme.bodySmall),
    ],
  );
}

@widgetbook.UseCase(name: 'Playground', type: AppTimeline)
Widget appTimelinePlayground(BuildContext context) {
  final count = context.knobs.int.slider(
    label: 'itemCount',
    initialValue: 5,
    min: 1,
    max: 5,
  );
  final withFooter = context.knobs.boolean(
    label: 'footer (carregar mais)',
    initialValue: true,
  );
  return wbUseCase(
    context,
    name: 'AppTimeline',
    description:
        'A chronological trail. The footer lives inside the scroll, next to '
        'the last item — outside it, "load more" would be clickable before '
        'reaching the end.',
    child: SizedBox(
      width: 480,
      height: 320,
      child: AppTimeline(
        itemCount: count,
        itemBuilder: (BuildContext c, int i) => _linha(c, _eventos[i]),
        footer: withFooter
            ? const Align(
                alignment: Alignment.centerLeft,
                child: AppCircularLoading(),
              )
            : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Catalog', type: AppTimeline)
Widget appTimelineCatalog(BuildContext context) => wbUseCase(
  context,
  name: 'AppTimeline',
  description:
      'Heterogeneous events, one of them denied. "Denied" must stay readable '
      'without colour being the only difference.',
  child: SizedBox(
    width: 480,
    height: 340,
    child: AppTimeline(
      itemCount: _eventos.length,
      itemBuilder: (BuildContext c, int i) => _linha(c, _eventos[i]),
    ),
  ),
);
