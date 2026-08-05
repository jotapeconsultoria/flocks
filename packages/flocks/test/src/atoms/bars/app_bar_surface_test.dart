import 'package:flocks/flocks.dart';
import 'package:flocks/src/atoms/bars/app_bar_surface.dart';
import 'package:flocks/src/atoms/glass/app_glass_surface.dart';
import 'package:flocks/src/atoms/glass/app_progressive_blur.dart';
import 'package:flocks/src/foundation/app_overlay_bar.dart' show BarEdge;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// AppBarSurface: fundo de barra com semântica própria por AppStyle —
// filled (fill), outlined (borda 1-lado na aresta interna), elevated (sombra
// 1-lado na cor do fill) e glass em DOIS sabores: band (rampa de sigma que
// dissolve no conteúdo, sem rim) e flutuante (vidro uniforme com rim).

Widget _host(
  Widget child, {
  AppThemeData? theme,
  MediaQueryData media = const MediaQueryData(),
}) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: media,
    child: Stack(
      children: <Widget>[
        const Positioned.fill(child: ColoredBox(color: Color(0xFF3366CC))),
        AppTheme(data: theme ?? AppThemeData.light, child: child),
      ],
    ),
  ),
);

/// Sigmas dos `BackdropFilter` da barra, **em ordem de cima para baixo**.
///
/// O sigma não é legível pela API do `ImageFilter` (é opaco), mas o `toString`
/// do filtro composto expõe `blur(<sigma>, <sigma>, …)` — é o que dá para
/// afirmar sobre a *rampa* em vez de só contar camadas.
List<double> _blurSigmas(WidgetTester tester) => tester
    .widgetList<BackdropFilter>(find.byType(BackdropFilter))
    .map(
      (BackdropFilter f) => double.parse(
        RegExp(r'blur\(([\d.]+)').firstMatch('${f.filter}')!.group(1)!,
      ),
    )
    .toList();

Iterable<BoxDecoration> _decos(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(AppBarSurface),
        matching: find.byType(DecoratedBox),
      ),
    )
    .map((DecoratedBox d) => d.decoration as BoxDecoration);

void main() {
  const Color kFill = Color(0xFF112233);

  testWidgets('filled: cor do fill, sem borda nem sombra', (tester) async {
    await tester.pumpWidget(
      _host(
        const AppBarSurface(
          style: AppStyle.filled,
          contentEdge: BarEdge.bottom,
          fill: kFill,
          child: SizedBox(width: 300, height: 56),
        ),
      ),
    );
    final List<BoxDecoration> decos = _decos(tester).toList();
    expect(decos.any((BoxDecoration d) => d.color == kFill), isTrue);
    expect(
      decos.every((BoxDecoration d) => d.boxShadow == null && d.border == null),
      isTrue,
    );
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets('outlined (header): borda só embaixo (aresta interna)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppBarSurface(
          style: AppStyle.outlined,
          contentEdge: BarEdge.bottom,
          child: SizedBox(width: 300, height: 56),
        ),
      ),
    );
    final Border border = _decos(
      tester,
    ).map((BoxDecoration d) => d.border).whereType<Border>().first;
    expect(border.bottom.width, AppStrokes.s);
    expect(border.top, BorderSide.none);
  });

  testWidgets('outlined (footer): borda só em cima (aresta interna)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppBarSurface(
          style: AppStyle.outlined,
          contentEdge: BarEdge.top,
          child: SizedBox(width: 300, height: 56),
        ),
      ),
    );
    final Border border = _decos(
      tester,
    ).map((BoxDecoration d) => d.border).whereType<Border>().first;
    expect(border.top.width, AppStrokes.s);
    expect(border.bottom, BorderSide.none);
  });

  testWidgets('elevated: sombra 1-lado na cor do fill (não preta)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppBarSurface(
          style: AppStyle.elevated,
          contentEdge: BarEdge.bottom,
          fill: kFill,
          child: SizedBox(width: 300, height: 56),
        ),
      ),
    );
    final BoxShadow shadow = _decos(tester)
        .where((BoxDecoration d) => d.boxShadow != null)
        .expand((BoxDecoration d) => d.boxShadow!)
        .first;
    // Mesma cor do fill (RGB), com alpha < 1 → não é sombra preta.
    expect(shadow.color.r, kFill.r);
    expect(shadow.color.g, kFill.g);
    expect(shadow.color.b, kFill.b);
    expect(shadow.color.a, lessThan(1.0));
    // Header → sombra empurrada para baixo (aresta interna).
    expect(shadow.offset.dy, greaterThan(0));
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets('glass band: rampa de sigma, do forte na aresta externa a ~0', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppBarSurface(
          style: AppStyle.elevated,
          glass: true,
          contentEdge: BarEdge.bottom,
          child: SizedBox(width: 300, height: 56),
        ),
      ),
    );
    // Band dissolve: são VÁRIOS filtros (as fatias da rampa), não um só.
    expect(find.byType(AppProgressiveBlur), findsOneWidget);
    final List<double> sigmas = _blurSigmas(tester);
    expect(sigmas.length, greaterThan(1));
    // Header → forte no topo, caindo até quase zero na costura.
    expect(sigmas.first, closeTo(AppGlass.blurSigma, AppGlass.blurSigma * 0.1));
    expect(sigmas.last, lessThan(AppGlass.blurSigma * 0.2));
    for (int i = 1; i < sigmas.length; i++) {
      expect(sigmas[i], lessThan(sigmas[i - 1]), reason: 'fatia $i');
    }
  });

  testWidgets('glass band (footer): rampa invertida — forte embaixo', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppBarSurface(
          style: AppStyle.elevated,
          glass: true,
          contentEdge: BarEdge.top,
          child: SizedBox(width: 300, height: 56),
        ),
      ),
    );
    // De cima para baixo o sigma CRESCE (a aresta externa é a de baixo).
    final List<double> sigmas = _blurSigmas(tester);
    expect(sigmas.first, lessThan(sigmas.last));
  });

  testWidgets('glass band: sem rim — a band não tem quina para brilhar', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppBarSurface(
          style: AppStyle.elevated,
          glass: true,
          contentEdge: BarEdge.bottom,
          child: SizedBox(width: 300, height: 56),
        ),
      ),
    );
    expect(_decos(tester).every((BoxDecoration d) => d.border == null), isTrue);
  });

  testWidgets('glass flutuante: vidro uniforme (AppGlassSurface) com rim', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppBarSurface(
          style: AppStyle.elevated,
          glass: true,
          floating: true,
          contentEdge: BarEdge.top,
          borderRadius: BorderRadius.circular(28),
          child: const SizedBox(width: 300, height: 56),
        ),
      ),
    );
    // Cápsula = vidro das superfícies, não a rampa da band.
    expect(find.byType(AppGlassSurface), findsOneWidget);
    expect(find.byType(AppProgressiveBlur), findsNothing);
    expect(_blurSigmas(tester).length, 1);
    // O rim mora na ESTRUTURA (é a inversão que estávamos consertando).
    expect(_decos(tester).any((BoxDecoration d) => d.border != null), isTrue);
  });

  testWidgets('glass + highContrast: sem BackdropFilter (fallback opaco)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const AppBarSurface(
          style: AppStyle.elevated,
          glass: true,
          contentEdge: BarEdge.bottom,
          fill: kFill,
          child: SizedBox(width: 300, height: 56),
        ),
        media: const MediaQueryData(highContrast: true),
      ),
    );
    expect(find.byType(BackdropFilter), findsNothing);
    // Fallback é elevated → tem sombra.
    expect(
      _decos(tester).any((BoxDecoration d) => d.boxShadow != null),
      isTrue,
    );
  });

  testWidgets('glass flutuante + highContrast: fallback opaco também', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppBarSurface(
          style: AppStyle.elevated,
          glass: true,
          floating: true,
          contentEdge: BarEdge.top,
          borderRadius: BorderRadius.circular(28),
          fill: kFill,
          child: const SizedBox(width: 300, height: 56),
        ),
        media: const MediaQueryData(highContrast: true),
      ),
    );
    expect(find.byType(BackdropFilter), findsNothing);
  });
}
