import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

// Helpers de apresentação das use-cases (não são registrados como @UseCase).

/// Opção de **cor semântica** para os knobs do catálogo — papéis de cor do tema.
enum WbColorOption {
  /// Cor padrão do componente (não sobrescreve).
  padrao('Default'),
  primary('Primary'),
  secondary('Secondary'),
  tertiary('Tertiary'),
  danger('Danger'),
  info('Info'),
  success('Success'),
  warning('Warning'),
  neutral('Neutral');

  const WbColorOption(this.label);

  /// Rótulo exibido no dropdown.
  final String label;

  /// Resolve para a cor do tema, ou `null` = cor padrão do componente.
  Color? resolve(AppColorTheme t) => switch (this) {
    WbColorOption.padrao => null,
    WbColorOption.primary => t.primary,
    WbColorOption.secondary => t.secondary,
    WbColorOption.tertiary => t.tertiary,
    WbColorOption.danger => t.danger,
    WbColorOption.info => t.info,
    WbColorOption.success => t.success,
    WbColorOption.warning => t.warning,
    WbColorOption.neutral => t.neutralPrimary,
  };
}

/// Knob de **cor semântica**: dropdown dos papéis de cor do tema. Retorna a cor
/// escolhida, ou `null` (= mantém a cor padrão do componente).
///
/// Use nos átomos que aceitam uma cor arbitrária (ícone, loadings, texto,
/// destaque de ilustração). Átomos ligados ao `primary` (toggles/steppers) ou
/// sem sentido cromático (shimmer/overlay/avatar) **não** recebem esse knob.
Color? wbSemanticColorKnob(
  BuildContext context, {
  String label = 'color',
  WbColorOption initial = WbColorOption.padrao,
}) {
  final option = context.knobs.object.dropdown<WbColorOption>(
    label: label,
    options: WbColorOption.values,
    initialOption: initial,
    labelBuilder: (o) => o.label,
  );
  return option.resolve(AppTheme.of(context).colorTheme);
}

/// Cartão de estado: [child] + nome do estado + (opcional) quando usar.
Widget wbState(
  BuildContext context, {
  required String name,
  required Widget child,
  String? when,
  double width = 150,
}) {
  final theme = AppTheme.of(context);
  return SizedBox(
    width: width,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: AppSpacings.s8),
        AppText(
          name,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelMedium,
        ),
        if (when != null) ...[
          const SizedBox(height: AppSpacings.s2),
          AppText(
            when,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall.withColor(
              theme.colorTheme.neutralPrimary.s700,
            ),
          ),
        ],
      ],
    ),
  );
}

/// Tile de galeria/tamanho: [child] + nome + token (código).
Widget wbTile(
  BuildContext context, {
  required String name,
  required String token,
  required Widget child,
  double width = 110,
}) {
  final theme = AppTheme.of(context);
  return SizedBox(
    width: width,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: AppSpacings.s4),
        AppText(
          name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall,
        ),
        AppText(
          token,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall.withColor(
            theme.colorTheme.neutralPrimary.s600,
          ),
        ),
      ],
    ),
  );
}

// ===========================================================================
// Padrão do catálogo (WB standard). Toda use-case passa por [wbUseCase]:
// centralizada, com cabeçalho (nome + descrição em inglês), painel
// surfaceContainer opcional e um CTA opcional. Coleções de valores (ícones,
// ilustrações, tokens) usam [wbCatalog] + [wbSearch]. Ver CONVENTIONS.md.
// ===========================================================================

/// Standard frame for a single-component use case.
///
/// - Centers [child] on the canvas (survives TextScale 2.0 via a scroll view).
/// - Paints a rounded `surfaceContainer` panel behind [child] when [panel] is
///   `true` (the default) — mirrors how a component really sits on an elevated
///   surface. Turn it off for full-surface content (catalogs, empty-state
///   illustrations).
/// - Renders a header: the component [name] + an English [description] of what
///   the use case shows / when to use it.
/// - Renders an optional [cta] button beneath the component — build it with
///   [wbCta]. Only for cases that need an explicit action (advance a stepper,
///   replay a transition); never for selectors or hover/focus/press targets.
Widget wbUseCase(
  BuildContext context, {
  required String name,
  required String description,
  required Widget child,
  bool panel = true,
  Widget? cta,
  double panelPadding = AppSpacings.s64,
  double maxWidth = 520,
}) {
  final theme = AppTheme.of(context);
  Widget content = child;
  if (panel) {
    content = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorTheme.surfaceContainer,
        borderRadius: theme.radiusTheme.resolve(),
      ),
      child: Padding(padding: EdgeInsets.all(panelPadding), child: child),
    );
  }
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacings.s32),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _wbHeader(context, name: name, description: description),
            const SizedBox(height: AppSpacings.s32),
            content,
            if (cta != null) ...[const SizedBox(height: AppSpacings.s32), cta],
          ],
        ),
      ),
    ),
  );
}

/// Cabeçalho padrão: nome do componente + descrição do caso de uso (inglês).
Widget _wbHeader(
  BuildContext context, {
  required String name,
  required String description,
}) {
  final theme = AppTheme.of(context);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppText(
        name,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleMedium,
      ),
      const SizedBox(height: AppSpacings.s2),
      AppText(
        description,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall.withColor(
          theme.colorTheme.neutralPrimary.s700,
        ),
      ),
    ],
  );
}

/// A minimal primary button for use cases that need an explicit action
/// (advance a stepper, replay a transition). flocks exposes no button atom, so
/// this mirrors the DS look (`primary`/`onPrimary`) and dogfoods [AppScaleOnTap]
/// (no Material — passes the architecture test).
Widget wbCta(
  BuildContext context, {
  required String label,
  required VoidCallback onPressed,
}) {
  final theme = AppTheme.of(context);
  return AppScaleOnTap(
    onPressed: onPressed,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorTheme.primary,
        borderRadius: theme.radiusTheme.resolve(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s16,
          vertical: AppSpacings.s8,
        ),
        child: AppText(
          label,
          style: theme.textTheme.labelLarge.withColor(
            theme.colorTheme.onPrimary,
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Bar scenes — the harness for headers/footers on the glass axis.
// ---------------------------------------------------------------------------

/// Saturated palette for the mock feed. Deliberately vivid: glass re-saturates
/// what it blurs, so washed-out mock content cannot show the effect at all.
const List<Color> _wbFeedColors = <Color>[
  Color(0xFF6D28D9),
  Color(0xFF2563EB),
  Color(0xFF06B6D4),
  Color(0xFFDB2777),
  Color(0xFFF59E0B),
  Color(0xFF10B981),
];

/// Mock page content for glass scenes: **scrollable** and visually busy.
///
/// Busy is the whole point. A blur only reads as a blur when it has
/// high-frequency detail to destroy — a smooth gradient behind a bar looks
/// *identical* blurred and unblurred, so the old flat-gradient backdrop could
/// only ever show the tint, never the frost. This mixes text, photo-like
/// gradient blocks and hard-edged chips so both the blur and the re-saturation
/// are visible, and so dragging it under a bar actually changes what you see.
///
/// Pass a [controller] to drive the scroll programmatically.
Widget wbMockFeed(BuildContext context, {ScrollController? controller}) {
  final theme = AppTheme.of(context);
  final AppColorTheme colors = theme.colorTheme;

  Widget photo(int i) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: theme.radiusTheme.resolve(),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          _wbFeedColors[i % _wbFeedColors.length],
          _wbFeedColors[(i + 2) % _wbFeedColors.length],
          _wbFeedColors[(i + 4) % _wbFeedColors.length],
        ],
      ),
    ),
    child: const SizedBox(height: 132, width: double.infinity),
  );

  Widget chips(int i) => Row(
    children: <Widget>[
      for (int c = 0; c < 4; c++)
        Padding(
          padding: const EdgeInsets.only(right: AppSpacings.s8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _wbFeedColors[(i + c) % _wbFeedColors.length],
              shape: BoxShape.circle,
            ),
            child: const SizedBox.square(dimension: 36),
          ),
        ),
    ],
  );

  Widget paragraph(int i) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AppText('Section ${i + 1}', style: theme.textTheme.titleMedium),
      const SizedBox(height: AppSpacings.s4),
      AppText(
        'Filler content so the glass has something to blur. Scroll to see '
        'the text pass under the bar.',
        style: theme.textTheme.bodyMedium.withColor(colors.neutralPrimary.s600),
      ),
    ],
  );

  return ListView.separated(
    controller: controller,
    // Soma a reserva das barras sobrepostas (AppScaffold a publica em
    // MediaQuery.padding): com `padding` explícito o ListView não a consome
    // sozinho, e o 1º item nasceria escondido sob a barra.
    padding:
        const EdgeInsets.all(AppSpacings.s16) + MediaQuery.paddingOf(context),
    itemCount: 12,
    separatorBuilder: (_, _) => const SizedBox(height: AppSpacings.s16),
    itemBuilder: (BuildContext context, int i) => switch (i % 3) {
      0 => photo(i),
      1 => chips(i),
      _ => paragraph(i),
    },
  );
}

/// A phone-sized scene for header/footer use cases: **content that really
/// scrolls under the bar**, inside a real [AppScaffold].
///
/// Three things the previous ad-hoc `Stack` scenes could not do:
///
/// 1. **It scrolls.** The glass samples a live backdrop, so you can drag the
///    feed under the bar and watch the frost change — the only way to judge the
///    effect (a frozen backdrop hides every seam bug).
/// 2. **It has a fake safe area** ([topInset]/[bottomInset]). The widgetbook
///    canvas reports zero insets, so the safe-area plateau of the glass gradient
///    and `resolveBarExtent` never rendered at all in the catalog.
/// 3. **It goes through [AppScaffold].** The overlay contract (`overlaysContent`
///    plus the reserved content padding) runs for real instead of being faked by
///    a `Positioned`, so a regression there shows up here.
///
/// Use with `wbUseCase(..., panel: false)`: the frame *is* the panel.
Widget wbBarScene(
  BuildContext context, {
  Widget? header,
  Widget? footer,
  double width = 390,
  double height = 620,
  double topInset = 44,
  double bottomInset = 34,
}) {
  final theme = AppTheme.of(context);
  final EdgeInsets insets = EdgeInsets.only(top: topInset, bottom: bottomInset);
  return Center(
    child: SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacings.s32),
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacings.s32),
            border: Border.all(color: theme.colorTheme.outline),
          ),
          child: MediaQuery(
            // Safe-area falsa: sem ela o platô do gradiente é sempre 0.
            data: MediaQuery.of(
              context,
            ).copyWith(padding: insets, viewPadding: insets),
            child: AppScaffold(
              contentUnderBars: true,
              header: header,
              footer: footer,
              child: wbMockFeed(context),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Text search filter shown in the Knobs panel. Returns the lower-cased,
/// trimmed query (empty string = no filter). Feed the result into [wbCatalog].
String wbSearch(BuildContext context, {String label = 'Search'}) =>
    context.knobs.string(label: label, initialValue: '').trim().toLowerCase();

/// Centered, searchable gallery **body** (no scroll view of its own — wrap it in
/// [wbUseCase] with `panel: false`). Filters [items] by [search] using [nameOf],
/// lays survivors out in a centered [Wrap], and shows a `N of M` count plus an
/// empty state when nothing matches.
Widget wbCatalog<T>(
  BuildContext context, {
  required List<T> items,
  required String search,
  required String Function(T) nameOf,
  required Widget Function(BuildContext, T) tileBuilder,
  double spacing = AppSpacings.s32,
  double runSpacing = AppSpacings.s32,
}) {
  final theme = AppTheme.of(context);
  final filtered = search.isEmpty
      ? items
      : items.where((i) => nameOf(i).toLowerCase().contains(search)).toList();
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppText(
        '${filtered.length} of ${items.length}',
        style: theme.textTheme.labelSmall.withColor(
          theme.colorTheme.neutralPrimary.s600,
        ),
      ),
      const SizedBox(height: AppSpacings.s16),
      if (filtered.isEmpty)
        Padding(
          padding: const EdgeInsets.all(AppSpacings.s64),
          child: AppText(
            'No results for "$search"',
            style: theme.textTheme.bodyMedium.withColor(
              theme.colorTheme.neutralPrimary.s600,
            ),
          ),
        )
      else
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: spacing,
          runSpacing: runSpacing,
          children: [for (final it in filtered) tileBuilder(context, it)],
        ),
    ],
  );
}

/// Derives a searchable/display name from an icon or illustration URL:
/// `'https://.../battery-charging.svg'` -> `'battery-charging'`.
String wbAssetName(String url) => url.split('/').last.replaceAll('.svg', '');

// ===========================================================================
// Token knobs — quando um valor corresponde a um token do design system
// (size, spacing, stroke, radius, duration), o knob é um DROPDOWN de tokens
// (não um slider livre): o usuário escolhe da escala real. Ver CONVENTIONS.md.
// ===========================================================================

String _fmt(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

/// Escala de espaçamento/tamanho (AppSpacings == AppSizes).
const _spacingScale = <(String, double)>[
  ('s0', AppSpacings.s0),
  ('s1', AppSpacings.s1),
  ('s2', AppSpacings.s2),
  ('s4', AppSpacings.s4),
  ('s8', AppSpacings.s8),
  ('s12', AppSpacings.s12),
  ('s16', AppSpacings.s16),
  ('s24', AppSpacings.s24),
  ('s32', AppSpacings.s32),
  ('s48', AppSpacings.s48),
  ('s64', AppSpacings.s64),
  ('s128', AppSpacings.s128),
  ('s192', AppSpacings.s192),
];

const _strokeScale = <(String, double)>[
  ('none', AppStrokes.none),
  ('xs', AppStrokes.xs),
  ('s', AppStrokes.s),
  ('m', AppStrokes.m),
  ('l', AppStrokes.l),
  ('xl', AppStrokes.xl),
];

const _radiusScale = <(String, double)>[
  ('none', AppRadius.none),
  ('xs', AppRadius.xs),
  ('s', AppRadius.s),
  ('m', AppRadius.m),
  ('l', AppRadius.l),
  ('xl', AppRadius.xl),
];

const _durationScale = <(String, Duration)>[
  ('fast', AppDurations.fast),
  ('normal', AppDurations.normal),
  ('medium', AppDurations.medium),
  ('slow', AppDurations.slow),
  ('loop', AppDurations.loop),
  ('loopSlow', AppDurations.loopSlow),
];

double _scaleKnob(
  BuildContext context,
  List<(String, double)> scale,
  String label,
  double initial,
) {
  final selected = context.knobs.object.dropdown<(String, double)>(
    label: label,
    options: scale,
    initialOption: scale.firstWhere(
      (e) => e.$2 == initial,
      orElse: () => scale.first,
    ),
    labelBuilder: (e) => '${e.$1} (${_fmt(e.$2)})',
  );
  return selected.$2;
}

/// Dropdown da escala [AppSizes] (== [AppSpacings]) → valor escolhido.
double wbSizeKnob(
  BuildContext context, {
  String label = 'size',
  double initial = AppSizes.s16,
}) => _scaleKnob(context, _spacingScale, label, initial);

/// Dropdown da escala [AppSpacings] → valor escolhido.
double wbSpacingKnob(
  BuildContext context, {
  String label = 'spacing',
  double initial = AppSpacings.s8,
}) => _scaleKnob(context, _spacingScale, label, initial);

/// Dropdown da escala [AppStrokes] → largura de traço escolhida.
double wbStrokeKnob(
  BuildContext context, {
  String label = 'stroke',
  double initial = AppStrokes.m,
}) => _scaleKnob(context, _strokeScale, label, initial);

/// Dropdown da escala [AppRadius] → raio escolhido.
double wbRadiusKnob(
  BuildContext context, {
  String label = 'radius',
  double initial = AppRadius.m,
}) => _scaleKnob(context, _radiusScale, label, initial);

/// Dropdown da escala [AppDurations] → duração escolhida.
Duration wbDurationKnob(
  BuildContext context, {
  String label = 'duration',
  Duration initial = AppDurations.normal,
}) {
  final selected = context.knobs.object.dropdown<(String, Duration)>(
    label: label,
    options: _durationScale,
    initialOption: _durationScale.firstWhere(
      (e) => e.$2 == initial,
      orElse: () => _durationScale.first,
    ),
    labelBuilder: (e) => '${e.$1} (${e.$2.inMilliseconds}ms)',
  );
  return selected.$2;
}

/// Dropdown do override local de forma (`radiusMode`) de um componente.
/// `Global (inherit)` → `null` = segue o modo do addon **Radius**; os demais
/// forçam a forma só deste componente, vencendo o global.
AppRadiusMode? wbRadiusModeKnob(
  BuildContext context, {
  String label = 'radiusMode',
}) {
  const options = <(String, AppRadiusMode?)>[
    ('Global (inherit)', null),
    ('sharp', AppRadiusMode.reto),
    ('rounded', AppRadiusMode.redondo),
    ('circular', AppRadiusMode.circular),
    ('standard', AppRadiusMode.padrao),
  ];
  final selected = context.knobs.object.dropdown<(String, AppRadiusMode?)>(
    label: label,
    options: options,
    initialOption: options.first,
    labelBuilder: (e) => e.$1,
  );
  return selected.$2;
}

/// Dropdown do override local de estilo de container (`style`) de um componente.
/// A opção default (`null`) NÃO sobrescreve — o componente segue sua config
/// (o addon global **Style**, ou seu próprio default). Os demais forçam o
/// tratamento (filled/outlined/elevated) só deste componente, vencendo o global.
///
/// [nullLabel] rotula a opção "não sobrescrever": `Global (inherit)` para
/// componentes que seguem o addon global; ajuste (ex.: `Padrão (elevated)`) para
/// os que têm default próprio (menu/popover/menuStyle).
AppStyle? wbStyleKnob(
  BuildContext context, {
  String label = 'style',
  String nullLabel = 'Global (inherit)',
}) {
  final options = <(String, AppStyle?)>[
    (nullLabel, null),
    ('filled', AppStyle.filled),
    ('outlined', AppStyle.outlined),
    ('elevated', AppStyle.elevated),
  ];
  final selected = context.knobs.object.dropdown<(String, AppStyle?)>(
    label: label,
    options: options,
    initialOption: options.first,
    labelBuilder: (e) => e.$1,
  );
  return selected.$2;
}

/// Knob tri-estado do **eixo glass** de um componente da allow-list (overlays,
/// barras, FAB, Menu/Popover). `Global (inherit)` (null) segue o addon global
/// **Glass** (ou a marca); `On`/`Off` forçam só deste componente.
bool? wbGlassKnob(BuildContext context, {String label = 'glass'}) {
  final options = <(String, bool?)>[
    ('Global (inherit)', null),
    ('On', true),
    ('Off', false),
  ];
  final selected = context.knobs.object.dropdown<(String, bool?)>(
    label: label,
    options: options,
    initialOption: options.first,
    labelBuilder: (e) => e.$1,
  );
  return selected.$2;
}

/// Knob de tamanho de campo (`AppFieldSize`), na mesma linha do `AppButtonSize`.
/// Default M.
AppFieldSize wbFieldSizeKnob(BuildContext context, {String label = 'size'}) {
  final options = <(String, AppFieldSize)>[
    ('S (40)', AppFieldSize.s),
    ('M (48)', AppFieldSize.m),
    ('L (56)', AppFieldSize.l),
  ];
  final selected = context.knobs.object.dropdown<(String, AppFieldSize)>(
    label: label,
    options: options,
    initialOption: options[1],
    labelBuilder: (e) => e.$1,
  );
  return selected.$2;
}

/// Palco para provar o **eixo glass** de um painel que só aparece depois de uma
/// interação (menu, dropdown, picker).
///
/// Vidro sobre fundo chapado é indistinguível de um tint opaco — sem algo
/// colorido e variado ATRÁS, não há como julgar o efeito. Por isso o palco
/// empilha o [wbMockFeed] sob o [child].
///
/// O `Overlay` local é o detalhe que faz a prova valer: sem ele, o painel abre
/// no Overlay **raiz** do Widgetbook e flutua sobre a moldura da ferramenta em
/// vez do feed. `Overlay.of(context)` resolve para o mais próximo, então o
/// painel fica contido aqui — e o desfoque amostra exatamente o fundo colorido.
///
/// Use com `panel: false` no [wbUseCase] (o painel chapado do host anularia o
/// fundo). O [child] deve se posicionar sozinho (ex.: `Center`).
Widget wbGlassStage(
  BuildContext context, {
  required Widget child,
  double height = 380,
  double width = 460,
}) {
  final theme = AppTheme.of(context);
  return ClipRRect(
    borderRadius: theme.radiusTheme.resolve(),
    child: SizedBox(
      height: height,
      width: width,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (BuildContext context) => Stack(
              children: <Widget>[
                Positioned.fill(child: wbMockFeed(context)),
                Positioned.fill(child: child),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
