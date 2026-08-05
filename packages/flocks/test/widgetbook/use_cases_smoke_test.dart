import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../widgetbook/use_cases/foundation_use_cases.dart';

/// Hosts a knob-driven use-case builder. Use cases now read `context.knobs`,
/// so they need a [WidgetbookScope] in the tree — with an empty query group the
/// knobs resolve to their initial values. The rest mirrors a real canvas
/// (AppTheme + directionality + media query).
Widget _wbHost(WidgetBuilder builder) {
  final state = WidgetbookState(root: WidgetbookRoot(children: const []));
  return WidgetbookScope(
    state: state,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: AppTheme(
          data: AppThemeData.light,
          child: Builder(builder: builder),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('FlocksInteraction use case renders', (tester) async {
    await tester.pumpWidget(_wbHost(flocksInteractionPlayground));
    expect(find.byType(FlocksInteraction), findsOneWidget);
  });

  testWidgets('AppScaleOnTap use case renders', (tester) async {
    await tester.pumpWidget(_wbHost(appScaleOnTapPlayground));
    expect(find.byType(AppScaleOnTap), findsOneWidget);
  });
}
