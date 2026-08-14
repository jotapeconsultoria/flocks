import 'package:flutter/widgets.dart';

import '../../foundation/app_route_topmost.dart';
import '../../molecules/buttons/app_button.dart';
import '../../molecules/buttons/app_button_color.dart';
import '../../molecules/footers/app_buttons_footer.dart';
import '../../molecules/footers/app_buttons_footer_style_enum.dart';
import '../../molecules/headers/app_close_side.dart';
import '../../theme/theme.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_style.dart';
import 'app_dialog.dart';
import 'app_dialog_content.dart';

/// Teto de largura de um confirm. Diverge de propósito do 448/640 do
/// [showAppDialog]: aquele piso de 448 é de formulário, e num telefone de 375px
/// ele estoura o `Padding(horizontal: s64)` da rota (375 - 128 = 247 < 448).
/// Um confirm é uma frase — sem piso, o card abraça o conteúdo e cabe.
const double _kConfirmMaxWidth = 480.0;

/// Confirmação sim/não num [AppDialog] modal. Devolve `true` **só** quando o
/// usuário aciona o botão de confirmar — e **nunca `null`**.
///
/// É o par de conveniência do [showAppDialog] para o diálogo mais repetido que
/// existe: título, uma frase, Confirmar/Cancelar. Sem ele cada chamador remonta
/// `showAppDialog` + [AppDialogContent] + [AppButtonsFooter] com dois
/// [AppButton] e escreve o `Navigator.pop(true/false)` na mão — cada um com a
/// sua cor de destrutivo.
///
/// **O `null` some aqui.** Barrier, botão "X" e Esc fecham a rota com `null`;
/// o helper normaliza para `false`, e o chamador escreve
/// `if (await showAppConfirm(...))` — sem `== true`, sem `?? false`. Essa
/// normalização é a razão de a função existir; um `Future<bool?>` devolveria o
/// problema ao chamador.
///
/// [destructive] é a chave de leitura, não uma cor: liga o papel `danger` no
/// botão de confirmar E tinge a ilustração com o MESMO acento (o contrato do
/// `accentRole` do [AppDialogContent]). [confirmColor] sobrescreve o papel sem
/// desligar a semântica.
///
/// Corpo: passe [message] (usa o [AppDialogContent] padrão, com [illustration]
/// opcional) OU [content] (corpo próprio — uma lista de itens a apagar, um
/// input de confirmação). Os dois juntos é erro de programação (assert).
///
/// Eixos globais e a barra de topo são repassados intactos ao [showAppDialog]:
/// motion (fade + reduce-motion), foco de rota, barrier e glass/style/raio já
/// vivem lá — este helper não reimplementa nada disso.
///
/// ```dart
/// if (await showAppConfirm(
///   context: context,
///   title: 'Excluir empresa',
///   message: 'Os usuários dela perdem o acesso. Não dá para desfazer.',
///   confirmLabel: 'Excluir',
///   destructive: true,
/// )) {
///   await controller.remove(account.id);
/// }
/// ```
Future<bool> showAppConfirm({
  required BuildContext context,
  required String title,
  String? message,
  Widget? content,
  String confirmLabel = 'Confirmar',
  String cancelLabel = 'Cancelar',
  bool destructive = false,
  AppButtonColor? confirmColor,
  String? illustration,
  bool barrierDismissible = true,
  bool showCloseButton = true,
  AppSheetCloseSide closeSide = AppSheetCloseSide.end,
  BoxConstraints? constraints,
  AppStyle? style,
  bool? glass,
  AppRadiusMode? radiusMode,
  BorderRadius? radius,
}) async {
  assert(
    (message == null) != (content == null),
    'showAppConfirm: passe `message` (corpo padrão) OU `content` (corpo '
    'próprio) — nunca os dois, nunca nenhum.',
  );

  final AppColorTheme colors = AppTheme.of(context).colorTheme;
  final AppButtonColor confirm =
      confirmColor ??
      (destructive ? AppButtonColor.danger : AppButtonColor.primary);

  // Fecha só se ESTA rota ainda é a de cima. Sem a guarda, dois toques rápidos
  // no mesmo botão dão dois pops e o segundo derruba a tela de baixo.
  void close(BuildContext ctx, bool value) {
    if (appRouteIsTopmost(ctx)) Navigator.of(ctx).pop(value);
  }

  final bool? result = await showAppDialog<bool>(
    context: context,
    title: title,
    showCloseButton: showCloseButton,
    closeSide: closeSide,
    barrierDismissible: barrierDismissible,
    constraints:
        constraints ?? const BoxConstraints(maxWidth: _kConfirmMaxWidth),
    style: style,
    glass: glass,
    radiusMode: radiusMode,
    radius: radius,
    child:
        content ??
        AppDialogContent(
          message: message!,
          illustration: illustration,
          // O acento da arte é o MESMO valor que o botão pinta — contrato já
          // documentado em AppDialogContent.accentRole.
          accentRole: confirm.role(colors),
        ),
    // `Builder`: precisa de um context ABAIXO da _AppDialogRoute para o pop
    // acertar a rota do diálogo, e não a de quem chamou.
    footer: Builder(
      builder: (BuildContext ctx) => AppButtonsFooter(
        style: AppButtonsFooterStyle.dialog,
        primary: AppButton(
          color: confirm,
          label: confirmLabel,
          onPressed: () => close(ctx, true),
        ),
        secondary: AppButton(
          style: AppStyle.outlined,
          color: AppButtonColor.neutral,
          label: cancelLabel,
          onPressed: () => close(ctx, false),
        ),
      ),
    ),
  );
  return result ?? false;
}
