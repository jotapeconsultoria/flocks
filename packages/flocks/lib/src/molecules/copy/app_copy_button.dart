import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../foundation/painters/app_checkmark_painter.dart';
import '../../motion/widgets/app_value_builder.dart';
import '../../theme/theme.dart';
import '../../tokens/app_curves.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import '../interactive/app_interaction.dart';
import '../tooltip/app_tooltip.dart';

/// Quanto tempo o [AppCopyButton] fica no estado "copiado" antes de voltar.
const Duration kAppCopiedFeedback = Duration(milliseconds: 1600);

/// Fração da transição gasta apagando o ícone de copiar. O tique só começa a
/// ser traçado depois disso — os dois nunca aparecem sobrepostos.
const double _fadeOutFraction = 0.45;

/// Botão de copiar: escreve [value] na área de transferência e confirma **no
/// próprio botão**.
///
/// Ao clicar, o ícone de cópia dá lugar a um check na cor de sucesso e a
/// tooltip troca de [copyTooltip] para [copiedTooltip] — as duas com transição
/// suave. Depois de [copiedDuration] tudo volta ao repouso sozinho.
///
/// É o feedback certo para copiar identificadores numa lista de campos: fica
/// sob o cursor, onde o olho já está, e copiar cinco IDs seguidos não empilha
/// cinco snackbars. Quem precisar reagir à cópia (telemetria, snackbar próprio)
/// usa [onCopied].
///
/// ```dart
/// AppCopyButton(value: account.integrationId)
/// ```
final class AppCopyButton extends StatefulWidget {
  /// Cria um [AppCopyButton].
  const AppCopyButton({
    required this.value,
    this.color,
    this.copiedDuration = kAppCopiedFeedback,
    this.copiedTooltip = 'Copiado!',
    this.copyTooltip = 'Copiar',
    this.enabled = true,
    this.iconSize = AppIconSize.s,
    this.onCopied,
    this.onCopyFailed,
    this.padding = const EdgeInsets.all(AppSpacings.s4),
    this.tooltipPosition = AppTooltipPosition.top,
    super.key,
  });

  /// Cor do ícone em repouso. `null` usa `onSurface`. O estado copiado usa
  /// sempre a cor de sucesso do tema — é semântica, não decoração.
  final Color? color;

  /// Quanto tempo o estado copiado dura antes de voltar ao repouso.
  final Duration copiedDuration;

  /// Tooltip logo após copiar.
  final String copiedTooltip;

  /// Tooltip em repouso.
  final String copyTooltip;

  /// Quando `false`, não reage e esmaece o ícone.
  final bool enabled;

  /// Tamanho do ícone. Define também o lado do alvo (ícone + [padding] · 2).
  final AppIconSize iconSize;

  /// Disparado depois de escrever na área de transferência.
  final VoidCallback? onCopied;

  /// Disparado quando a escrita falha (o botão **não** confirma nesse caso).
  /// `null` engole o erro — sem ele, a falha viraria exceção solta no zone.
  final ValueChanged<Object>? onCopyFailed;

  /// Folga interna entre o realce e o ícone. Mantenha simétrica: o realce do
  /// [AppInteraction] envolve o child inteiro, então um padding torto sai como
  /// um alvo torto. O espaçamento em relação aos vizinhos é de quem posiciona.
  final EdgeInsetsGeometry padding;

  /// Posição da tooltip em relação ao botão.
  final AppTooltipPosition tooltipPosition;

  /// Texto escrito na área de transferência.
  final String value;

  @override
  State<AppCopyButton> createState() => _AppCopyButtonState();
}

class _AppCopyButtonState extends State<AppCopyButton> {
  bool _copied = false;
  Timer? _resetTimer;

  @override
  Widget build(BuildContext context) {
    final AppColorTheme colors = AppTheme.of(context).colorTheme;
    final String label = _copied ? widget.copiedTooltip : widget.copyTooltip;

    return AppInteraction(
      enabled: widget.enabled,
      onTap: _copy,
      padding: widget.padding,
      semanticLabel: label,
      tooltip: label,
      tooltipPosition: widget.tooltipPosition,
      // O tique é DESENHADO ([AppCheckmarkPainter]), não é um ícone de rede.
      // Com `AppIconToken.check` a confirmação dependia de um download que só
      // acontecia naquele instante — e um `SvgPicture` que falha nunca tenta de
      // novo, então uma falha de rede virava um erro visual permanente
      // exatamente no momento em que o usuário precisa da confirmação. O traço
      // também pode ser animado, que é o que o `progress` faz aqui.
      //
      // O ícone de copiar vai no slot `child` do builder: assim a instância é
      // constante entre os frames da animação e o SVG dele não é rebaixado nem
      // re-buscado a cada quadro.
      child: SizedBox.square(
        dimension: widget.iconSize.value,
        child: AppValueBuilder(
          curve: AppCurves.emphasized,
          value: _copied ? 1 : 0,
          // Sem `semanticLabel` no ícone: o rótulo vive no [AppInteraction],
          // senão o leitor de tela anuncia "Copiar, Copiado!".
          child: AppIcon(
            AppIconToken.copy,
            color: widget.color ?? colors.onSurface,
            size: widget.iconSize,
          ),
          builder: (BuildContext context, double t, Widget? icon) => Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Opacity(
                opacity: (1 - t / _fadeOutFraction).clamp(0.0, 1.0),
                child: icon,
              ),
              CustomPaint(
                painter: AppCheckmarkPainter(
                  color: colors.success,
                  progress: ((t - _fadeOutFraction) / (1 - _fadeOutFraction))
                      .clamp(0.0, 1.0),
                  strokeWidth: widget.iconSize.value / 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    // Escrever na área de transferência PODE falhar: no navegador,
    // `navigator.clipboard.writeText` rejeita sem gesto do usuário, fora de
    // contexto seguro ou com a permissão negada, e o Flutter transforma isso
    // num `PlatformException`.
    //
    // Nesse caso NÃO confirmamos: mostrar o check sem ter copiado é mentir
    // para quem vai colar em outro lugar. O erro também não pode virar exceção
    // solta no zone — quem quiser reagir usa [onCopyFailed].
    try {
      await Clipboard.setData(ClipboardData(text: widget.value));
    } on Object catch (error) {
      widget.onCopyFailed?.call(error);
      return;
    }
    widget.onCopied?.call();
    if (!mounted) return;
    setState(() => _copied = true);
    _resetTimer?.cancel();
    _resetTimer = Timer(widget.copiedDuration, () {
      if (mounted) setState(() => _copied = false);
    });
  }
}
