import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ilustração do dialog tem que sair na MESMA cor que o botão de ação pinta.
///
/// O teste mira o valor resolvido, não o parâmetro: é o que impede a ilustração
/// de voltar a usar a base crua do swatch (sempre mais saturada) enquanto o
/// botão usa o stop legível.
void main() {
  final List<(String, AppButtonColor)> roles = <(String, AppButtonColor)>[
    ('danger', AppButtonColor.danger),
    ('secondary', AppButtonColor.secondary),
    ('primary', AppButtonColor.primary),
    ('warning', AppButtonColor.warning),
    ('success', AppButtonColor.success),
    ('info', AppButtonColor.info),
  ];

  for (final AppBrandConfig brand in <AppBrandConfig>[
    zxtrackBrand,
    jotapeBrand,
  ]) {
    for (final bool dark in <bool>[false, true]) {
      // Resolvido AQUI a partir da marca do laço. Antes vinha de
      // `AppThemeData.light/dark`, que lê o singleton `AppBrand.current` —
      // e como o `setBrand` só rodava DENTRO do corpo do teste, o tema era o
      // da marca anterior. O teste media a marca errada em silêncio.
      final AppThemeData theme = AppThemeData.forBrand(brand, dark: dark);
      final String label = '${brand.clientSlug} ${dark ? 'escuro' : 'claro'}';

      test('$label: acento da ilustração == preenchimento do botão', () {
        final AppColorTheme colors = theme.colorTheme;

        for (final (String name, AppButtonColor role) in roles) {
          final Color botao = appFilledButtonColors(
            colors,
            role.role(colors),
            role.onRole(colors),
            hovered: false,
            pressed: false,
            disabled: false,
          ).background;

          final Color ilustracao = appRoleAccent(colors, role.role(colors));

          expect(
            ilustracao,
            botao,
            reason:
                'papel "$name" em $label: a ilustração saiu em $ilustracao e o '
                'botão em $botao',
          );
        }
      });
    }
  }

  testWidgets('AppDialogContent tinge a ilustração com o papel informado', (
    WidgetTester tester,
  ) async {
    final AppThemeData theme = AppThemeData.forBrand(zxtrackBrand, dark: true);
    final Color esperado = appRoleAccent(
      theme.colorTheme,
      theme.colorTheme.danger,
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AppTheme(
          data: theme,
          child: AppDialogContent(
            accentRole: theme.colorTheme.danger,
            illustration: AppIllustrations.delete,
            message: 'O device será excluído permanentemente.',
            title: 'Excluir device?',
          ),
        ),
      ),
    );

    final AppIllustration ilustracao = tester.widget<AppIllustration>(
      find.byType(AppIllustration),
    );
    expect(ilustracao.accentColor, esperado);
    // E não a base crua do swatch, que é o defeito que motivou a regra.
    expect(ilustracao.accentColor, isNot(theme.colorTheme.danger));
  });
}
