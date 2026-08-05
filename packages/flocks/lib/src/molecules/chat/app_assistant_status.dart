import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../atoms/texts/texts.dart';
import '../../foundation/foundation.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_typing_indicator.dart';

/// Rótulo de **status do assistente** ("Entendendo o pedido" → "Buscando dados"
/// → "Organizando a resposta"), com efeito de **máquina de escrever**: o texto
/// novo aparece sendo digitado, caractere a caractere, e o anterior some sendo
/// apagado (backspace) antes.
///
/// O app dirige qual é o [label] atual (o timing/ciclo é do consumidor); este
/// componente anima a transição e, opcionalmente, prefixa um
/// [AppTypingIndicator]. Anuncia o [label] completo como região de status (a11y)
/// e respeita reduce-motion (troca instantânea, sem digitar/apagar).
///
/// ```dart
/// AppAssistantStatus(label: 'Buscando dados')
/// ```
final class AppAssistantStatus extends StatefulWidget {
  /// Cria um [AppAssistantStatus].
  const AppAssistantStatus({
    required this.label,
    this.style,
    this.showIndicator = true,
    this.color,
    this.charDuration = const Duration(milliseconds: 45),
    super.key,
  });

  /// Rótulo atual da etapa. Trocar o valor dispara a transição (apaga → digita).
  final String label;

  /// Estilo do texto. Default `bodyMedium` em `onSurface`.
  final TextStyle? style;

  /// Se prefixa um [AppTypingIndicator] antes do texto. Default `true`.
  final bool showIndicator;

  /// Cor do texto/indicador. Default `onSurface`.
  final Color? color;

  /// Tempo por caractere ao **digitar**. O apagar usa ~55% disto (mais rápido).
  final Duration charDuration;

  @override
  State<AppAssistantStatus> createState() => _AppAssistantStatusState();
}

class _AppAssistantStatusState extends State<AppAssistantStatus> {
  String _shown = '';
  late String _target = widget.label;
  Timer? _timer;

  Duration get _typeStep => widget.charDuration;
  Duration get _eraseStep => widget.charDuration * 0.55;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.enabled(context)) {
      _timer?.cancel();
      _timer = null;
      if (_shown != _target) setState(() => _shown = _target);
    } else if (_timer == null && _shown != _target) {
      _tick();
    }
  }

  @override
  void didUpdateWidget(covariant AppAssistantStatus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.label == _target) return;
    _target = widget.label;
    if (!AppMotion.enabled(context)) {
      _timer?.cancel();
      _timer = null;
      setState(() => _shown = _target);
    } else if (_timer == null) {
      _tick();
    }
  }

  /// Um passo: digita o próximo caractere se [_shown] for prefixo de [_target];
  /// senão apaga o último (backspace) até virar prefixo. Assim distintos apagam
  /// por completo e reescrevem; com prefixo comum, só o sufixo diverge.
  void _tick() {
    final bool typing = _target.startsWith(_shown);
    if (typing) {
      if (_shown.length >= _target.length) {
        _timer = null;
        return;
      }
      _shown = _target.substring(0, _shown.length + 1);
    } else {
      _shown = _shown.substring(0, _shown.length - 1);
    }

    if (!mounted) return;
    setState(() {});

    if (_shown == _target) {
      _timer = null;
      return;
    }
    _timer = Timer(typing ? _typeStep : _eraseStep, _tick);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final Color textColor = widget.color ?? theme.colorTheme.onSurface;
    final TextStyle textStyle =
        widget.style ?? theme.textTheme.bodyMedium.withColor(textColor);

    final Widget row = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.showIndicator) ...<Widget>[
          AppTypingIndicator(color: textColor.customOpacity(0.6)),
          const SizedBox(width: AppSpacings.s8),
        ],
        Flexible(child: AppText(_shown, style: textStyle)),
      ],
    );

    return AppSemantics.status(label: widget.label, child: row);
  }
}
