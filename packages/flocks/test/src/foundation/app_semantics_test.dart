import 'package:flocks/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: Center(child: child),
  ),
);

void main() {
  testWidgets('button() expõe role de botão + label + enabled + tap', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppSemantics.button(
          label: 'Salvar',
          onTap: () {},
          child: const SizedBox(width: 48, height: 48),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(SizedBox)),
      isSemantics(
        label: 'Salvar',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('button(loading) fica não-enabled e sem tap', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppSemantics.button(
          label: 'Enviando',
          loading: true,
          onTap: () {},
          child: const SizedBox(width: 48, height: 48),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(SizedBox)),
      isSemantics(
        label: 'Enviando',
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
      ),
    );
    handle.dispose();
  });

  testWidgets('toggle() expõe checked + enabled + tap', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppSemantics.toggle(
          value: true,
          label: 'Ativo',
          onTap: () {},
          child: const SizedBox(width: 48, height: 48),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(SizedBox)),
      isSemantics(
        label: 'Ativo',
        hasCheckedState: true,
        isChecked: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('textField() expõe role de campo de texto', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        AppSemantics.textField(
          label: 'Nome',
          value: 'João',
          child: const SizedBox(width: 120, height: 48),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(SizedBox)),
      isSemantics(label: 'Nome', value: 'João', isTextField: true),
    );
    handle.dispose();
  });
}
