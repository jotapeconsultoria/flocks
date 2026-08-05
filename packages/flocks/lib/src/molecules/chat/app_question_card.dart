import 'package:flutter/widgets.dart';

import '../../atoms/checkbox/checkbox.dart';
import '../../atoms/radio/radio.dart';
import '../../atoms/surface/surface.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../buttons/buttons.dart';
import '../input/input.dart';
import '../interactive/interactive.dart';

/// Papel semântico de um [AppQuestionCard] — tinge a casca e o botão de ação.
enum AppQuestionCardRole {
  /// Perigo/irreversível (vermelho).
  danger,

  /// Informativo (azul).
  info,

  /// Ação genérica da marca.
  primary,

  /// Sucesso (verde).
  success,

  /// Atenção (âmbar) — default de confirmações.
  warning;

  /// Papel de cor do tema.
  Color color(AppColorTheme t) => switch (this) {
    AppQuestionCardRole.danger => t.danger,
    AppQuestionCardRole.info => t.info,
    AppQuestionCardRole.primary => t.primary,
    AppQuestionCardRole.success => t.success,
    AppQuestionCardRole.warning => t.warning,
  };

  /// Acento **legível** do papel sobre a superfície ([readableStopOn]): a base de
  /// `primary` é escura demais no tema escuro e o tint/borda do card sumiam.
  Color accentOn(AppColorTheme t) => switch (this) {
    AppQuestionCardRole.danger => readableStopOn(t.danger, t.surface),
    AppQuestionCardRole.info => readableStopOn(t.info, t.surface),
    AppQuestionCardRole.primary => readableStopOn(t.primary, t.surface),
    AppQuestionCardRole.success => readableStopOn(t.success, t.surface),
    AppQuestionCardRole.warning => readableStopOn(t.warning, t.surface),
  };

  /// Cor equivalente do [AppButton] de ação.
  AppButtonColor get buttonColor => switch (this) {
    AppQuestionCardRole.danger => AppButtonColor.danger,
    AppQuestionCardRole.info => AppButtonColor.info,
    AppQuestionCardRole.primary => AppButtonColor.primary,
    AppQuestionCardRole.success => AppButtonColor.success,
    AppQuestionCardRole.warning => AppButtonColor.warning,
  };
}

enum _QuestionType { confirmation, singleChoice, multipleChoice }

/// Card de **pergunta** dentro do fluxo do chat — a IA pede algo ao usuário e
/// recebe a resposta inline. Vem em três tipos (construtores nomeados):
///
/// - [AppQuestionCard.confirmation]: título/subtítulo + detalhe opcional +
///   ações confirmar/cancelar (generaliza o antigo card de ação pendente).
/// - [AppQuestionCard.singleChoice]: até 8 opções em **radio** + resposta livre
///   opcional; um botão envia a escolha.
/// - [AppQuestionCard.multipleChoice]: até 8 opções em **checkbox** + resposta
///   livre opcional; um botão envia a seleção.
///
/// **Todos** têm um botão **Cancelar** (um *text button*) quando [onCancel] é
/// passado. A casca usa um **shade sólido** do papel (não translúcido) para a
/// sombra do `elevated` não vazar pelo fundo.
///
/// ```dart
/// AppQuestionCard.singleChoice(
///   title: 'Qual relatório você quer?',
///   options: <String>['Resumo do dia', 'Veículos parados', 'Alertas'],
///   onSingleSelected: (answer) => cubit.reply(answer),
///   onCancel: cubit.dismiss,
/// )
/// ```
final class AppQuestionCard extends StatefulWidget {
  /// Card de confirmação: detalhe opcional + confirmar/cancelar.
  const AppQuestionCard.confirmation({
    required this.title,
    this.subtitle,
    this.detail,
    this.role = AppQuestionCardRole.warning,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
    this.onConfirm,
    this.onCancel,
    this.enabled = true,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  }) : _type = _QuestionType.confirmation,
       options = const <String>[],
       allowCustom = false,
       customLabel = '',
       customHint = null,
       submitLabel = '',
       maximumSelections = 1,
       minimumSelections = 1,
       onSingleSelected = null,
       onMultipleSubmit = null;

  /// Card de escolha única: até 3 [options] em radio (+ opção livre opcional).
  const AppQuestionCard.singleChoice({
    required this.title,
    required this.options,
    this.subtitle,
    this.role = AppQuestionCardRole.info,
    this.allowCustom = true,
    this.customLabel = 'Outra resposta…',
    this.customHint,
    this.submitLabel = 'Enviar',
    this.cancelLabel = 'Cancelar',
    this.onSingleSelected,
    this.onCancel,
    this.enabled = true,
    this.maximumSelections = 1,
    this.minimumSelections = 1,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  }) : assert(options.length <= 8, 'singleChoice aceita no máximo 8 opções.'),
       _type = _QuestionType.singleChoice,
       detail = null,
       confirmLabel = '',
       onConfirm = null,
       onMultipleSubmit = null;

  /// Card de escolha múltipla: até 3 [options] em checkbox (+ opção livre).
  const AppQuestionCard.multipleChoice({
    required this.title,
    required this.options,
    this.subtitle,
    this.role = AppQuestionCardRole.info,
    this.allowCustom = true,
    this.customLabel = 'Outra resposta…',
    this.customHint,
    this.submitLabel = 'Enviar',
    this.cancelLabel = 'Cancelar',
    this.onMultipleSubmit,
    this.onCancel,
    this.enabled = true,
    this.maximumSelections,
    this.minimumSelections = 1,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  }) : assert(options.length <= 8, 'multipleChoice aceita no máximo 8 opções.'),
       _type = _QuestionType.multipleChoice,
       detail = null,
       confirmLabel = '',
       onConfirm = null,
       onSingleSelected = null;

  /// Título do card.
  final String title;

  /// Subtítulo opcional.
  final String? subtitle;

  /// Papel semântico.
  final AppQuestionCardRole role;

  /// Se os controles/ações estão habilitados.
  final bool enabled;

  /// Máximo de respostas selecionáveis. `null` não limita.
  final int? maximumSelections;

  /// Mínimo de respostas necessárias para habilitar o envio.
  final int minimumSelections;

  /// Estilo de container. Default: global.
  final AppStyle? style;

  /// Override local do modo de forma.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (px).
  final double? radius;

  /// Rótulo do botão de cancelar (text button). Presente em todos os tipos.
  final String cancelLabel;

  /// Cancela/dispensa o card. `null` = sem botão de cancelar.
  final VoidCallback? onCancel;

  // --- confirmation ---
  /// Slot de detalhe opcional (confirmation).
  final Widget? detail;

  /// Rótulo do confirmar (confirmation).
  final String confirmLabel;

  /// Confirma (confirmation). `null` = sem botão de confirmar.
  final VoidCallback? onConfirm;

  // --- choice ---
  /// Opções (single/multiple), no máximo 3.
  final List<String> options;

  /// Se acrescenta a 4ª opção de resposta livre.
  final bool allowCustom;

  /// Rótulo da opção de resposta livre.
  final String customLabel;

  /// Placeholder do campo de resposta livre.
  final String? customHint;

  /// Rótulo do botão de enviar (single/multiple).
  final String submitLabel;

  /// Envia a escolha única (opção ou texto livre).
  final ValueChanged<String>? onSingleSelected;

  /// Envia a seleção múltipla (opções + texto livre, se houver).
  final ValueChanged<List<String>>? onMultipleSubmit;

  final _QuestionType _type;

  @override
  State<AppQuestionCard> createState() => _AppQuestionCardState();
}

class _AppQuestionCardState extends State<AppQuestionCard> {
  int? _singleIndex;
  final Set<int> _multiSelected = <int>{};
  final TextEditingController _customController = TextEditingController();
  final FocusNode _customFocus = FocusNode();

  int get _customIndex => widget.options.length;
  bool get _singleCustomActive =>
      widget.allowCustom && _singleIndex == _customIndex;
  bool get _multiCustomActive =>
      widget.allowCustom && _multiSelected.contains(_customIndex);
  bool get _customTextEmpty => _customController.text.trim().isEmpty;

  @override
  void dispose() {
    _customController.dispose();
    _customFocus.dispose();
    super.dispose();
  }

  /// Foca o campo de resposta livre no próximo frame (após ele aparecer).
  void _focusCustom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _customFocus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    // Acento legível do papel sobre a superfície (a base de `primary` é escura
    // demais no escuro): usado no tint e na borda, mantendo o tratamento
    // translúcido histórico (12% / 40%).
    final Color accent = widget.role.accentOn(colors);
    final BorderRadius br = widget.radius != null
        ? BorderRadius.circular(widget.radius!)
        : theme.radiusTheme.tileRadius(widget.radiusMode);

    // Shade SÓLIDO do papel (não translúcido): a sombra do `elevated` não vaza
    // pelo fundo. Achatamos o tint sobre a `surface` (opaca).
    final Color fill = Color.alphaBlend(
      accent.customOpacity(0.12),
      colors.surface,
    );
    final Color borderColor = Color.alphaBlend(accent.customOpacity(0.4), fill);

    final Widget body = switch (widget._type) {
      _QuestionType.confirmation => _confirmationBody(theme),
      _QuestionType.singleChoice => _singleChoiceBody(theme),
      _QuestionType.multipleChoice => _multipleChoiceBody(theme),
    };

    return AppSurface(
      variant: AppSurfaceVariant.flat,
      style: widget.style,
      color: fill,
      border: Border.all(color: borderColor, width: AppStrokes.s),
      radius: br,
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppText(
            widget.title,
            style: theme.textTheme.titleMedium.withColor(colors.onSurface),
          ),
          if (widget.subtitle != null) ...<Widget>[
            const SizedBox(height: AppSpacings.s4),
            AppText(
              widget.subtitle!,
              style: theme.textTheme.bodyLarge.withColor(
                colors.onSurface.customOpacity(0.7),
              ),
            ),
          ],
          const SizedBox(height: AppSpacings.s12),
          body,
        ],
      ),
    );
  }

  // --- Confirmation -------------------------------------------------------

  Widget _confirmationBody(AppThemeData theme) {
    final bool hasActions = widget.onConfirm != null || widget.onCancel != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.detail != null) ...<Widget>[
          widget.detail!,
          const SizedBox(height: AppSpacings.s12),
        ],
        if (hasActions)
          _actionsRow(
            theme,
            primary: widget.onConfirm == null
                ? null
                : _primaryButton(
                    widget.confirmLabel,
                    widget.onConfirm!,
                    enabled: true,
                  ),
          ),
      ],
    );
  }

  // --- Single choice ------------------------------------------------------

  bool get _canSubmitSingle =>
      _singleIndex != null && (!_singleCustomActive || !_customTextEmpty);

  void _selectSingle(int i) {
    setState(() => _singleIndex = i);
    if (widget.allowCustom && i == _customIndex) _focusCustom();
  }

  void _submitSingle() {
    if (!_canSubmitSingle) return;
    final String value = _singleCustomActive
        ? _customController.text.trim()
        : widget.options[_singleIndex!];
    widget.onSingleSelected?.call(value);
  }

  Widget _singleChoiceBody(AppThemeData theme) {
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < widget.options.length; i++) {
      rows.add(
        _choiceRow(
          theme,
          control: AppRadio<int>(
            groupValue: _singleIndex,
            value: i,
            enabled: widget.enabled,
            onChanged: (_) => _selectSingle(i),
          ),
          text: widget.options[i],
          onTap: () => _selectSingle(i),
        ),
      );
    }
    if (widget.allowCustom) {
      rows.add(
        _choiceRow(
          theme,
          control: AppRadio<int>(
            groupValue: _singleIndex,
            value: _customIndex,
            enabled: widget.enabled,
            onChanged: (_) => _selectSingle(_customIndex),
          ),
          text: widget.customLabel,
          onTap: () => _selectSingle(_customIndex),
        ),
      );
      if (_singleCustomActive) rows.add(_customInput(theme));
    }
    rows.add(const SizedBox(height: AppSpacings.s12));
    rows.add(
      _actionsRow(
        theme,
        primary: _primaryButton(
          widget.submitLabel,
          _submitSingle,
          enabled: _canSubmitSingle,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }

  // --- Multiple choice ----------------------------------------------------

  bool get _canSubmitMulti {
    final count = _multiSelected.length;
    final maximum = widget.maximumSelections;
    return count >= widget.minimumSelections &&
        (maximum == null || count <= maximum) &&
        (!_multiCustomActive || !_customTextEmpty);
  }

  void _toggleMulti(int i) {
    setState(() {
      if (_multiSelected.remove(i)) return;
      final maximum = widget.maximumSelections;
      if (maximum == null || _multiSelected.length < maximum) {
        _multiSelected.add(i);
      }
    });
    if (widget.allowCustom && i == _customIndex && _multiSelected.contains(i)) {
      _focusCustom();
    }
  }

  void _submitMulti() {
    if (!_canSubmitMulti) return;
    final List<String> values = <String>[
      for (int i = 0; i < widget.options.length; i++)
        if (_multiSelected.contains(i)) widget.options[i],
      if (_multiCustomActive && !_customTextEmpty)
        _customController.text.trim(),
    ];
    widget.onMultipleSubmit?.call(values);
  }

  Widget _multipleChoiceBody(AppThemeData theme) {
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < widget.options.length; i++) {
      rows.add(
        _choiceRow(
          theme,
          control: AppCheckbox(
            checked: _multiSelected.contains(i),
            enabled: widget.enabled,
            onChanged: (_) => _toggleMulti(i),
          ),
          text: widget.options[i],
          onTap: () => _toggleMulti(i),
        ),
      );
    }
    if (widget.allowCustom) {
      rows.add(
        _choiceRow(
          theme,
          control: AppCheckbox(
            checked: _multiSelected.contains(_customIndex),
            enabled: widget.enabled,
            onChanged: (_) => _toggleMulti(_customIndex),
          ),
          text: widget.customLabel,
          onTap: () => _toggleMulti(_customIndex),
        ),
      );
      if (_multiCustomActive) rows.add(_customInput(theme));
    }
    rows.add(const SizedBox(height: AppSpacings.s12));
    rows.add(
      _actionsRow(
        theme,
        primary: _primaryButton(
          widget.submitLabel,
          _submitMulti,
          enabled: _canSubmitMulti,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }

  // --- Shared bits --------------------------------------------------------

  Widget _choiceRow(
    AppThemeData theme, {
    required Widget control,
    required String text,
    required VoidCallback onTap,
  }) {
    return AppInteraction(
      onTap: widget.enabled ? onTap : null,
      motion: AppMotionPreset.none,
      radius: theme.radiusTheme.resolve(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s4,
        vertical: AppSpacings.s8,
      ),
      child: Row(
        children: <Widget>[
          control,
          const SizedBox(width: AppSpacings.s12),
          Expanded(
            child: AppText(
              text,
              style: theme.textTheme.bodyMedium.withColor(
                theme.colorTheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Campo de resposta livre: **ponta a ponta** (sem recuo) e com **autofocus**
  /// ao aparecer.
  Widget _customInput(AppThemeData theme) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacings.s4),
    child: AppInput(
      controller: _customController,
      focusNode: _customFocus,
      enabled: widget.enabled,
      hintText: widget.customHint ?? 'Digite sua resposta…',
      size: AppFieldSize.s,
      onChanged: (_) => setState(() {}),
    ),
  );

  /// Linha de ações: **Cancelar** (text button, esquerda) + o botão primário
  /// (direita).
  Widget _actionsRow(AppThemeData theme, {required Widget? primary}) {
    return Row(
      children: <Widget>[
        if (widget.onCancel != null) _cancelButton(theme),
        const Spacer(),
        ?primary,
      ],
    );
  }

  /// Cancelar como **text button** (texto clicável, sem fundo/borda).
  Widget _cancelButton(AppThemeData theme) => AppInteraction(
    onTap: widget.enabled ? widget.onCancel : null,
    enabled: widget.enabled,
    semanticLabel: widget.cancelLabel,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacings.s12,
      vertical: AppSpacings.s8,
    ),
    child: AppText(
      widget.cancelLabel,
      style: theme.textTheme.labelLarge.withColor(
        theme.colorTheme.onSurface.customOpacity(0.7),
      ),
    ),
  );

  Widget _primaryButton(
    String label,
    VoidCallback onPressed, {
    required bool enabled,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      color: widget.role.buttonColor,
      size: AppButtonSize.m,
      enabled: widget.enabled && enabled,
    );
  }
}
