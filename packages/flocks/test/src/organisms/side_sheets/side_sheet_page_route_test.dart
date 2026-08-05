import 'package:flocks/src/organisms/side_sheets/side_sheet_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

SideSheetPageRoute<void> _pageRoute({bool isDismissible = true}) =>
    SideSheetPageRoute<void>(
      builder: (_) => const SizedBox.shrink(),
      barrierColor: const Color(0x80000000),
      beginOffset: const Offset(1, 0),
      isDismissible: isDismissible,
    );

void main() {
  test('SideSheetPageRoute é um PageRoute (destino roteado de 1ª classe)', () {
    expect(_pageRoute(), isA<PageRoute<void>>());
  });

  test('SideSheetRoute continua sendo um PopupRoute (overlay efêmero)', () {
    final SideSheetRoute<void> route = SideSheetRoute<void>(
      builder: (_) => const SizedBox.shrink(),
      barrierColor: const Color(0x80000000),
      beginOffset: const Offset(1, 0),
    );
    expect(route, isA<PopupRoute<void>>());
  });

  test('page route: não-opaco, mantém estado, sem snapshot', () {
    final SideSheetPageRoute<void> route = _pageRoute();
    expect(route.opaque, isFalse);
    expect(route.maintainState, isTrue);
    expect(route.allowSnapshotting, isFalse);
  });

  test(
    'page route: sem delegatedTransition (painel lateral, sem efeito iOS)',
    () {
      expect(_pageRoute().delegatedTransition, isNull);
    },
  );

  test('page route: barrierDismissible segue isDismissible', () {
    expect(_pageRoute(isDismissible: true).barrierDismissible, isTrue);
    expect(_pageRoute(isDismissible: false).barrierDismissible, isFalse);
  });
}
