import 'package:flutter/widgets.dart';

import '../../atoms/illustrations/illustrations.dart';
import '../../atoms/texts/texts.dart';
import '../../molecules/buttons/button_state_colors.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_spacings.dart';

/// Conteúdo padrão de um [AppBottomSheet]: título, mensagem e ilustração.
///
/// É o corpo mais comum de um bottom sheet (aviso/detalhe), **rolável**. Vai no
/// `child:` de um bottom sheet **não-arrastável** (ex.: `showAppBottomSheet`
/// padrão), normalmente com um rodapé de ações — como o corpo rola sozinho, não
/// serve para sheets arrastáveis (que exigem corpo não-rolável).
///
/// Todas as cores vêm do tema. [accentRole] é o **papel** de cor da peça (o
/// mesmo do botão de ação): a ilustração é tingida com o acento desse papel —
/// o valor que o botão pinta — em vez da base crua do swatch. `null` mantém
/// `secondary`.
final class AppBottomSheetContent extends StatelessWidget {
  /// Cria um [AppBottomSheetContent].
  const AppBottomSheetContent({
    required this.illustration,
    required this.message,
    required this.title,
    this.accentRole,
    this.illustrationSize = AppIllustrationSize.l,
    this.messageTextAlign,
    super.key,
  });

  /// Papel de cor da peça — o mesmo do botão de ação. `null` usa `secondary`.
  ///
  /// Recebe o **swatch** (`theme.colorTheme.danger`), não uma cor pronta.
  final ColorSwatch<int>? accentRole;

  /// URL/caminho da ilustração (SVG).
  final String illustration;

  /// Tamanho da ilustração no conteúdo.
  final AppIllustrationSize illustrationSize;

  /// Mensagem descritiva (`bodyLarge`).
  final String message;

  /// Alinhamento opcional da mensagem.
  final TextAlign? messageTextAlign;

  /// Título em destaque (`titleLarge`).
  final String title;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: AppSpacings.s32 + AppSpacings.s8),
            AppText(
              title,
              semanticLabel: title,
              style: theme.textTheme.titleLarge.copyWith(
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacings.s16),
            AppText(
              message,
              semanticLabel: message,
              textAlign: messageTextAlign ?? TextAlign.start,
              style: theme.textTheme.bodyLarge.copyWith(
                color: colors.neutralPrimary.s700,
              ),
            ),
            const SizedBox(height: AppSpacings.s64),
            Center(
              child: AppIllustration(
                illustration,
                accentColor: appRoleAccent(
                  colors,
                  accentRole ?? colors.secondary,
                ),
                size: illustrationSize,
              ),
            ),
            const SizedBox(height: AppSpacings.s64),
          ],
        ),
      ),
    );
  }
}
