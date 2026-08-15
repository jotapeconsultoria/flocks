import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: AppTheme(
      data: AppThemeData.light,
      child: Center(child: SizedBox(width: 280, child: child)),
    ),
  ),
);

void main() {
  testWidgets('default: espectro (SV + matiz + preview) e presets presentes', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppColorPickerPanel(
          color: const Color(0xFF3366CC),
          onColorChanged: (_) {},
        ),
      ),
    );
    // O preview traz o swatch da cor atual + hex; os presets trazem o rótulo.
    expect(find.byType(AppSwatch), findsWidgets);
    expect(find.text('Cores sugeridas'), findsOneWidget);
    // A área SV existe (160px de altura fixa em algum descendente).
    final Iterable<Element> boxes = tester.elementList(
      find.descendant(
        of: find.byType(AppColorPickerPanel),
        matching: find.byType(SizedBox),
      ),
    );
    expect(
      boxes.any((Element e) => (e.widget as SizedBox).height == 160),
      isTrue,
    );
  });

  testWidgets('showSpectrum:false = só a paleta, sem vão órfão', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        AppColorPickerPanel(
          color: const Color(0xFF3366CC),
          showSpectrum: false,
          onColorChanged: (_) {},
        ),
      ),
    );
    expect(find.text('Cores sugeridas'), findsOneWidget);
    final Iterable<SizedBox> boxes = tester
        .widgetList<SizedBox>(
          find.descendant(
            of: find.byType(AppColorPickerPanel),
            matching: find.byType(SizedBox),
          ),
        )
        .where((SizedBox b) => b.height != null);
    // Sem a área SV (160) e sem o respiro de 16 que emoldurava o espectro.
    expect(boxes.map((SizedBox b) => b.height), isNot(contains(160.0)));
    expect(boxes.map((SizedBox b) => b.height), isNot(contains(16.0)));
  });

  testWidgets('só-presets continua emitindo onColorChanged no toque', (
    tester,
  ) async {
    Color? picked;
    await tester.pumpWidget(
      _host(
        AppColorPickerPanel(
          color: const Color(0xFF3366CC),
          showSpectrum: false,
          presets: const <Color>[Color(0xFFFF0000), Color(0xFF00FF00)],
          onColorChanged: (Color c) => picked = c,
        ),
      ),
    );
    await tester.tap(find.byType(AppSwatch).first);
    await tester.pump();
    expect(picked, const Color(0xFFFF0000));
  });

  testWidgets('assert: os dois desligados reprovam', (tester) async {
    expect(
      () => AppColorPickerPanel(
        color: const Color(0xFF3366CC),
        showSpectrum: false,
        showSuggestedColors: false,
        onColorChanged: (_) {},
      ),
      throwsAssertionError,
    );
  });
}
