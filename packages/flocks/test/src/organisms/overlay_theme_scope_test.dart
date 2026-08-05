import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Reproduz o cenário do Widgetbook (e de qualquer app que proveja o AppTheme
// ABAIXO do Navigator): uma rota modal (showAppDialog/showAppBottomSheet) renderiza
// no overlay do Navigator, que fica ACIMA do AppTheme local do gatilho. Sem o
// AppOverlayScope, `AppTheme.of` estoura ("No AppTheme found in context") ao abrir.
//
// Estrutura: WidgetsApp (cria o Navigator) → home → AppTheme LOCAL → gatilho.
Widget _appThemeBelowNavigator({
  required void Function(BuildContext themedContext) onTap,
}) => WidgetsApp(
  color: const Color(0xFF000000),
  pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
      PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (BuildContext context, _, _) => builder(context),
      ),
  // O AppTheme NÃO é provido aqui (acima do Navigator) — só localmente no home,
  // para que a rota empurrada escape dele.
  home: Builder(
    builder: (BuildContext _) => AppTheme(
      data: AppThemeData.light,
      child: Builder(
        builder: (BuildContext themedContext) => GestureDetector(
          onTap: () => onTap(themedContext),
          child: const Text('abrir', textDirection: TextDirection.ltr),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets(
    'showAppDialog abre sem "No AppTheme" (tema abaixo do Navigator)',
    (tester) async {
      await tester.pumpWidget(
        _appThemeBelowNavigator(
          onTap: (BuildContext context) => showAppDialog<void>(
            context: context,
            child: const Text('conteúdo', textDirection: TextDirection.ltr),
          ),
        ),
      );

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(AppDialog), findsOneWidget);
      expect(find.text('conteúdo'), findsOneWidget);
    },
  );

  testWidgets(
    'showAppBottomSheet abre sem "No AppTheme" (tema abaixo do Navigator)',
    (tester) async {
      await tester.pumpWidget(
        _appThemeBelowNavigator(
          onTap: (BuildContext context) => showAppBottomSheet<void>(
            context: context,
            footer: const Text('ok', textDirection: TextDirection.ltr),
            child: const Text('conteúdo', textDirection: TextDirection.ltr),
          ),
        ),
      );

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(AppBottomSheet), findsOneWidget);
      expect(find.text('conteúdo'), findsOneWidget);
    },
  );
}
