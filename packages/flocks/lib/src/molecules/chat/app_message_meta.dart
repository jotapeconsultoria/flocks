import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Estado de entrega de uma mensagem enviada — o "tick" do WhatsApp.
enum AppMessageStatus {
  /// Sem indicador (mensagem recebida, ou meta só com horário).
  none,

  /// Enviando (relógio).
  sending,

  /// Enviada ao servidor (um tique).
  sent,

  /// Entregue ao destinatário (dois tiques).
  delivered,

  /// Lida (dois tiques tingidos).
  read,

  /// Falha no envio (círculo de erro).
  failed,
}

/// Meta de uma mensagem — horário + (opcional) status de entrega, no rodapé de
/// uma [AppChatBubble].
///
/// Somente-leitura e compacto (papel `labelSmall`). O status vira um par de
/// ícones tingido por papel semântico ([AppMessageStatus]); `read` usa o papel
/// `info`, `failed` usa `danger`. Nunca dependa só da cor — o [status] também é
/// exposto como rótulo semântico.
///
/// ```dart
/// AppMessageMeta(time: '10:32', status: AppMessageStatus.read)
/// ```
final class AppMessageMeta extends StatelessWidget {
  /// Cria um [AppMessageMeta].
  const AppMessageMeta({
    this.time,
    this.status = AppMessageStatus.none,
    this.edited = false,
    this.color,
    super.key,
  }) : assert(
         time != null || status != AppMessageStatus.none,
         'AppMessageMeta precisa de time ou de um status != none — sem os '
         'dois o rodapé renderiza vazio (edited sozinho não é meta).',
       );

  /// Horário já formatado (ex.: "10:32"). O DS não formata datas.
  ///
  /// `null` = meta só de status (a célula de tabela, o marcador compacto) —
  /// exige `status != none` (assert).
  final String? time;

  /// Status de entrega. Default [AppMessageStatus.none] (sem tique).
  final AppMessageStatus status;

  /// Se mostra o rótulo "editada" antes do horário.
  final bool edited;

  /// Sobrescreve a cor do texto/tique neutro (default: `onSurface` esmaecido).
  final Color? color;

  static const double _tickSize = 14;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final Color muted = color ?? colors.onSurface.customOpacity(0.55);
    final TextStyle textStyle = theme.textTheme.labelSmall.withColor(muted);

    final Widget? statusWidget = _buildStatus(colors, muted);

    // Os gaps são dos VIZINHOS seguintes (não trailing do anterior): com time
    // nulo não sobra respiro órfão entre "editada" e o tique. Com time
    // presente, a sequência resultante é a mesma de sempre.
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (edited) AppText('editada', style: textStyle),
        if (time case final String t) ...<Widget>[
          if (edited) const SizedBox(width: AppSpacings.s4),
          AppText(t, style: textStyle),
        ],
        if (statusWidget != null) ...<Widget>[
          if (edited || time != null) const SizedBox(width: AppSpacings.s4),
          statusWidget,
        ],
      ],
    );
  }

  Widget? _buildStatus(AppColorTheme colors, Color muted) {
    switch (status) {
      case AppMessageStatus.none:
        return null;
      case AppMessageStatus.sending:
        return _singleIcon(AppIconToken.clock, muted, 'enviando');
      case AppMessageStatus.sent:
        return _singleIcon(AppIconToken.check, muted, 'enviada');
      case AppMessageStatus.delivered:
        return _doubleCheck(muted, 'entregue');
      case AppMessageStatus.read:
        return _doubleCheck(colors.info, 'lida');
      case AppMessageStatus.failed:
        return _singleIcon(AppIconToken.errorCircle, colors.danger, 'falhou');
    }
  }

  Widget _singleIcon(String icon, Color color, String label) =>
      AppIcon(icon, color: color, customSize: _tickSize, semanticLabel: label);

  /// Dois tiques sobrepostos (entregue/lida) — desenhados a partir de dois
  /// `AppIconToken.check`, já que o set não traz um glifo de duplo-tique.
  Widget _doubleCheck(Color color, String label) => SizedBox(
    width: _tickSize + 5,
    height: _tickSize,
    child: Semantics(
      label: label,
      image: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            left: 5,
            child: AppIcon(
              AppIconToken.check,
              color: color,
              customSize: _tickSize,
            ),
          ),
          Positioned(
            left: 0,
            child: AppIcon(
              AppIconToken.check,
              color: color,
              customSize: _tickSize,
            ),
          ),
        ],
      ),
    ),
  );
}
