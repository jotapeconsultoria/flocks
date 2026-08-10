import 'dart:typed_data';

import 'package:flocks/flocks.dart';
// Interno: é ele que compõe o AppCard nos menus/dropdowns/pickers.
import 'package:flocks/src/molecules/card/app_overlay_panel.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Uma SUPERFÍCIE grande em modo `circular` não pode cortar o próprio conteúdo.
///
/// `AppRadiusMode.circular` significa, na escada geral, "metade do lado menor".
/// Num chip ou num botão isso é a pílula que se espera — a caixa tem uma linha
/// de altura e o raio acompanha. Numa superfície ALTA (um card de gráfico de
/// 400px) a mesma regra vira uma elipse de 180px de raio, e o canto passa por
/// cima do texto: o header "Recurring revenue" foi visto como "urring revenue".
///
/// O teste é geométrico, não tipográfico: a superfície recebe um filho opaco
/// que preenche a área de conteúdo, e o teste exige que os QUATRO cantos dessa
/// área continuem pintados. Não depende de fonte, de tema nem de baseline —
/// só do clip. Um raio que invade o padding falha aqui.
const double _kSide = 360;
const double _kTall = 400;

AppThemeData _circular() {
  final AppThemeData base = AppThemeData.light;
  return AppThemeData(
    brightness: base.brightness,
    colorTheme: base.colorTheme,
    textTheme: base.textTheme,
    radiusTheme: const AppRadiusTheme(mode: AppRadiusMode.circular),
  );
}

/// `true` se o pixel em ([x], [y]) foi pintado (alfa > 0).
bool _painted(ByteData data, int width, int x, int y) =>
    data.getUint8((y * width + x) * 4 + 3) > 0;

void main() {
  /// Monta [surface] com 360×400 sob o modo `circular` e devolve os pixels.
  Future<ByteData> shoot(WidgetTester tester, Widget surface) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: AppTheme(
            data: _circular(),
            child: Align(
              alignment: Alignment.topLeft,
              child: RepaintBoundary(
                key: const Key('shot'),
                child: SizedBox(width: _kSide, height: _kTall, child: surface),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final RenderRepaintBoundary boundary =
        tester.renderObject(find.byKey(const Key('shot')))
            as RenderRepaintBoundary;
    late final ByteData data;
    await tester.runAsync(() async {
      data = (await (await boundary.toImage()).toByteData())!;
    });
    return data;
  }

  /// Exige que os quatro cantos da área de conteúdo (o retângulo da superfície
  /// deflacionado por [pad]) tenham sobrevivido ao clip.
  void expectContentCornersSurvive(
    ByteData data, {
    required double pad,
    required String label,
  }) {
    const int w = _kSide ~/ 1;
    final int lo = pad.ceil();
    final int right = (_kSide - pad).floor() - 1;
    final int bottom = (_kTall - pad).floor() - 1;

    final Map<String, List<int>> corners = <String, List<int>>{
      'superior esquerdo': <int>[lo, lo],
      'superior direito': <int>[right, lo],
      'inferior esquerdo': <int>[lo, bottom],
      'inferior direito': <int>[right, bottom],
    };

    for (final MapEntry<String, List<int>> c in corners.entries) {
      expect(
        _painted(data, w, c.value[0], c.value[1]),
        isTrue,
        reason:
            '$label: o canto ${c.key} da área de conteúdo foi comido pelo '
            'clip da superfície em AppRadiusMode.circular. Uma superfície '
            'resolve o canto por contentSurfaceRadius/surfaceCornerRadius — '
            'a escada geral (resolve) satura em metade do lado menor e vira '
            'uma elipse que corta o próprio conteúdo.',
      );
    }
  }

  testWidgets('AppCard alto em circular não corta o conteúdo', (tester) async {
    final ByteData data = await shoot(
      tester,
      const AppCard(
        padding: EdgeInsets.all(AppSpacings.s16),
        child: _OpaqueFill(),
      ),
    );
    expectContentCornersSurvive(data, pad: AppSpacings.s16, label: 'AppCard');
  });

  testWidgets('AppOverlayCard alto em circular não corta o conteúdo', (
    tester,
  ) async {
    final ByteData data = await shoot(
      tester,
      const AppOverlayCard(
        glass: false,
        padding: EdgeInsets.all(AppSpacings.s16),
        child: _OpaqueFill(),
      ),
    );
    expectContentCornersSurvive(
      data,
      pad: AppSpacings.s16,
      label: 'AppOverlayCard',
    );
  });

  testWidgets('AppOverlayPanel alto em circular não corta o conteúdo', (
    tester,
  ) async {
    final ByteData data = await shoot(
      tester,
      const AppOverlayPanel(
        glass: false,
        padding: EdgeInsets.all(AppSpacings.s16),
        child: _OpaqueFill(),
      ),
    );
    expectContentCornersSurvive(
      data,
      pad: AppSpacings.s16,
      label: 'AppOverlayPanel',
    );
  });
}

/// Bloco opaco que preenche a área de conteúdo — a "tinta" que o clip ou
/// preserva ou come.
final class _OpaqueFill extends StatelessWidget {
  const _OpaqueFill();

  @override
  Widget build(BuildContext context) =>
      const SizedBox.expand(child: ColoredBox(color: Color(0xFF000000)));
}
