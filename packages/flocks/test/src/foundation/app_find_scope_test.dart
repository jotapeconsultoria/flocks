import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Uma "tela" com campo de busca, como as listagens.
final class _Screen extends StatefulWidget {
  const _Screen({required this.label});

  final String label;

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  final FocusNode _node = FocusNode();
  AppFindController? _controller;
  Object? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = AppFindScope.maybeOf(context);
    final token = AppFindTarget.maybeOf(context) ?? this;
    if (identical(controller, _controller) && token == _token) return;
    _controller?.unregister(_token!, _node);
    _controller = controller;
    _token = token;
    controller?.register(token, _node);
  }

  @override
  void dispose() {
    if (_token != null) _controller?.unregister(_token!, _node);
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => EditableText(
    controller: TextEditingController(text: widget.label),
    focusNode: _node,
    style: const TextStyle(),
    cursorColor: const Color(0xFF000000),
    backgroundCursorColor: const Color(0xFF000000),
  );
}

Future<void> _pumpTabs(
  WidgetTester tester,
  AppFindController controller, {
  required List<String> tokens,
  required int visible,
}) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: AppFindScope(
          controller: controller,
          child: IndexedStack(
            index: visible,
            children: [
              for (final token in tokens)
                AppFindTarget(
                  key: ValueKey(token),
                  token: token,
                  child: _Screen(label: token),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('AppFindController — alvo por token', () {
    testWidgets('foca a tela do token, não a primeira montada', (tester) async {
      final controller = AppFindController();
      await _pumpTabs(
        tester,
        controller,
        tokens: const ['/a', '/b', '/c'],
        visible: 2,
      );

      // As três abas estão MONTADAS ao mesmo tempo; só o token distingue.
      expect(controller.targetCount, 3);
      expect(controller.focus('/c'), isTrue);
      await tester.pump();

      final focused = tester.widget<EditableText>(
        find.byWidgetPredicate(
          (w) => w is EditableText && w.focusNode.hasPrimaryFocus,
        ),
      );
      expect(focused.controller.text, '/c');
    });

    testWidgets('token desconhecido não foca nada', (tester) async {
      final controller = AppFindController();
      await _pumpTabs(
        tester,
        controller,
        tokens: const ['/a', '/b'],
        visible: 0,
      );

      // Falso é o sinal para quem chama cair no fallback (a busca global) em
      // vez de focar uma aba invisível.
      expect(controller.focus('/inexistente'), isFalse);
    });

    testWidgets('sem token, cai no alvo único', (tester) async {
      final controller = AppFindController();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: AppFindScope(
              controller: controller,
              // Sem AppFindTarget: é o mobile, que não tem abas.
              child: const _Screen(label: 'única'),
            ),
          ),
        ),
      );

      expect(controller.focus(null), isTrue);
    });

    testWidgets('com vários alvos e sem token, não adivinha', (tester) async {
      final controller = AppFindController();
      await _pumpTabs(
        tester,
        controller,
        tokens: const ['/a', '/b'],
        visible: 0,
      );

      expect(controller.focus(null), isFalse);
    });

    testWidgets('aba fechada deixa de ser alvo', (tester) async {
      final controller = AppFindController();
      await _pumpTabs(
        tester,
        controller,
        tokens: const ['/a', '/b'],
        visible: 0,
      );
      await _pumpTabs(tester, controller, tokens: const ['/a'], visible: 0);

      expect(controller.targetCount, 1);
      expect(controller.focus('/b'), isFalse);
    });
  });
}
