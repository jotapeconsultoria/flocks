import 'package:flutter/widgets.dart';

import '../../atoms/illustrations/illustrations.dart';
import '../../atoms/texts/texts.dart';
import '../../molecules/buttons/button_state_colors.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_spacings.dart';
import 'app_dialog.dart';

/// Conteúdo padrão de um [AppDialog]: título, mensagem e ilustração central.
///
/// É o corpo mais comum de um dialog (confirmar/avisar). Vai dentro do
/// [AppDialog] (`child:`), normalmente acompanhado de um rodapé de ações.
///
/// Todas as cores vêm do tema. [accentRole] é o **papel** de cor da peça (o
/// mesmo do botão de ação no rodapé): a ilustração é tingida com o acento desse
/// papel — literalmente o valor que o botão pinta — para que os dois não
/// apareçam em vermelhos/laranjas diferentes no mesmo dialog. `null` mantém
/// `secondary`.
///
/// ```dart
/// AppDialog(
///   child: AppDialogContent(
///     title: 'Tudo certo!',
///     message: 'As alterações foram salvas.',
///     illustration: 'assets/success.svg',
///   ),
///   footer: okFooter,
/// )
/// ```
final class AppDialogContent extends StatelessWidget {
  /// Cria um [AppDialogContent].
  const AppDialogContent({
    required this.message,
    this.illustration,
    this.title,
    this.accentRole,
    super.key,
  });

  /// Papel de cor da peça — o mesmo do botão de ação. `null` usa `secondary`.
  ///
  /// Recebe o **swatch** (`theme.colorTheme.danger`), não uma cor pronta: quem
  /// escolhe o stop é o DS, pela mesma regra do botão.
  final ColorSwatch<int>? accentRole;

  /// URL/caminho da ilustração (SVG). `null` = **sem ilustração**: o bloco
  /// inteiro (os dois respiros de 64 e a arte) sai do layout, e o corpo fecha
  /// com um respiro de 32 antes do rodapé.
  ///
  /// Existe para o diálogo de confirmação puro, que é maioria: passar `null`
  /// direto ao [AppIllustration] (que já desenha nada) deixaria 128px de vão
  /// morto entre a mensagem e os botões.
  final String? illustration;

  /// Mensagem descritiva (`bodyLarge`).
  final String message;

  /// Título em destaque (`titleLarge`), no corpo.
  ///
  /// Opcional: quando o dialog já leva o título na **barra de topo**
  /// (`AppDialog.title`), deixe `null` aqui para não repetir.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    // Com a barra de topo por cima, o respiro cheio viraria vão duplo.
    final bool hasTopBar = AppDialogChrome.hasTopBarOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: hasTopBar ? AppSpacings.s8 : AppSpacings.s32),
          if (title case final String t) ...<Widget>[
            AppText(
              t,
              semanticLabel: t,
              style: theme.textTheme.titleLarge.copyWith(
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacings.s16),
          ],
          AppText(
            message,
            semanticLabel: message,
            style: theme.textTheme.bodyLarge.copyWith(
              color: colors.neutralPrimary.s700,
            ),
          ),
          if (illustration case final String art) ...<Widget>[
            const SizedBox(height: AppSpacings.s64),
            Center(
              child: AppIllustration(
                art,
                accentColor: appRoleAccent(
                  colors,
                  accentRole ?? colors.secondary,
                ),
                size: AppIllustrationSize.l,
              ),
            ),
            const SizedBox(height: AppSpacings.s64),
          ] else
            const SizedBox(height: AppSpacings.s32),
        ],
      ),
    );
  }
}
