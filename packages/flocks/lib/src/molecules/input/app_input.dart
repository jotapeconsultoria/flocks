import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/selection/app_text_selection_controls.dart';
import '../../foundation/selection/app_text_selection_gestures.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'field_label.dart';
import 'input_internals.dart';

/// Campo de texto do design system, sobre um [EditableText] cru (sem
/// Material/Cupertino).
///
/// Participa do eixo global de estilo ([AppStyle]) e de forma ([AppRadiusMode]),
/// exatamente como [AppCard]/[AppDropdown]: `outlined` (default) desenha a borda
/// de estado (repouso/foco/erro/desabilitado); `filled`/`elevated` trocam o
/// tratamento do container. As cores de estado são resolvidas por
/// [inputFieldColors] (mesma receita do trigger do dropdown).
///
/// Recursos: label acima, helper/erro abaixo, ícones de prefixo/sufixo, contador
/// de caracteres, multilinha (até 5 linhas) e seleção nativa de mouse
/// (double/triple-tap, menu de contexto) via [AppTextSelectionGestures]. Quando
/// [onTap] é passado, vira um campo de ação (ex.: date/time picker): o toque
/// dispara a ação em vez de posicionar o caret.
///
/// Exemplo:
/// ```dart
/// AppInput(
///   label: 'E-mail',
///   hintText: 'nome@dominio.com',
///   prefixIcon: AppIconToken.mail,
///   helperText: 'Nunca compartilhamos seu e-mail',
/// )
/// ```
final class AppInput extends StatefulWidget {
  /// Cria um [AppInput].
  const AppInput({
    this.controller,
    this.initialValue,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconColor,
    this.onSuffixIconTap,
    this.info,
    this.onClear,
    this.enabled = true,
    this.hasError = false,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.background,
    this.focusNode,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.maxLength,
    this.showCounter = false,
    this.style,
    this.radiusMode,
    this.radius,
    this.size = AppFieldSize.m,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.isDense = false,
    @Deprecated('Use `background`. Removido numa limpeza futura.')
    this.fillColor,
    @Deprecated('Use `radius`/`radiusMode`. Removido numa limpeza futura.')
    this.borderRadius,
    super.key,
  });

  /// Controlador do texto.
  final TextEditingController? controller;

  /// Valor inicial (ignorado se [controller] for passado).
  final String? initialValue;

  /// Label acima do campo.
  final String? label;

  /// Placeholder dentro do campo.
  final String? hintText;

  /// Texto auxiliar abaixo do campo.
  final String? helperText;

  /// Texto de erro abaixo do campo (substitui [helperText]).
  final String? errorText;

  /// Ícone no início do campo.
  final String? prefixIcon;

  /// Ícone no fim do campo.
  final String? suffixIcon;

  /// Cor do ícone de sufixo (sobrescreve a cor computada).
  final Color? suffixIconColor;

  /// Callback ao tocar o ícone de sufixo.
  final VoidCallback? onSuffixIconTap;

  /// Conteúdo livre de um popover de informação ao lado do [label]. Quando
  /// não-nulo, mostra um ícone de info que abre o popover no clique.
  final Widget? info;

  /// Ação ao limpar o campo pelo ✕ do estado de erro. Quando não-nulo, é
  /// chamado no lugar do foco automático (ex.: pickers resetam o valor e
  /// reabrem o overlay). O texto já é limpo antes de chamar.
  final VoidCallback? onClear;

  /// Se o campo está habilitado.
  final bool enabled;

  /// Se o campo está em estado de erro.
  final bool hasError;

  /// Se oculta o texto (senhas).
  final bool obscureText;

  /// Se é somente leitura (ainda recebe [onTap], mas não abre teclado).
  final bool readOnly;

  /// Máximo de linhas (valores > 5 são limitados a 5 com scroll).
  final int maxLines;

  /// Cor de fundo do campo. Em `outlined`/`elevated` é o `ownFill` do container.
  final Color? background;

  /// Nó de foco.
  final FocusNode? focusNode;

  /// Ação do teclado.
  final TextInputAction? textInputAction;

  /// Tipo de teclado.
  final TextInputType? keyboardType;

  /// Formatadores de entrada.
  final List<TextInputFormatter>? inputFormatters;

  /// Callback quando o valor muda.
  final void Function(String)? onChanged;

  /// Callback ao submeter.
  final void Function(String)? onSubmitted;

  /// Callback ao tocar. Quando não-nulo, o campo vira um campo de ação (o toque
  /// dispara a ação em vez de posicionar o caret).
  final VoidCallback? onTap;

  /// Comprimento máximo do texto.
  final int? maxLength;

  /// Se mostra o contador de caracteres (requer [maxLength]).
  final bool showCounter;

  /// Tratamento de container do eixo global [AppStyle]. Quando `null` (default)
  /// segue o global `theme.styleTheme.style`. Passe
  /// [AppStyle.filled]/[AppStyle.outlined]/[AppStyle.elevated] para variar só
  /// deste campo.
  final AppStyle? style;

  /// Sobrescreve o modo de forma só deste campo (vence o global
  /// `theme.radiusTheme.mode`).
  final AppRadiusMode? radiusMode;

  /// Override cru do raio — vence [radiusMode] e o global.
  final BorderRadius? radius;

  /// Tamanho do campo (altura fixa + métricas), na mesma mecânica do
  /// `AppButton`. Default [AppFieldSize.m].
  final AppFieldSize size;

  /// Capitalização do teclado.
  final TextCapitalization textCapitalization;

  /// Alinhamento horizontal do texto digitado E do hint. Default
  /// [TextAlign.start] — o campo de sempre. `center` é o campo de código OTP;
  /// `end`/`right` alinham valor numérico. O estilo do texto continua do eixo
  /// de tipografia (não configurável).
  final TextAlign textAlign;

  /// Se usa padding vertical reduzido (metade do normal).
  final bool isDense;

  /// @nodoc
  @Deprecated('Use `background`. Removido numa limpeza futura.')
  final Color? fillColor;

  /// @nodoc
  @Deprecated('Use `radius`/`radiusMode`. Removido numa limpeza futura.')
  final double? borderRadius;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput>
    with AppTextSelectionGestures<AppInput> {
  static const _tapDragThreshold = 6.0;

  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;
  Offset? _pointerDownPosition;
  bool _pointerDragged = false;

  /// Seleção nativa só para campos de texto (`onTap == null`). Campos de ação
  /// (pickers que passam `onTap`) disparam a ação em vez de selecionar.
  /// Read-only continua selecionável para permitir copiar.
  @override
  bool get selectionEnabled => widget.enabled && widget.onTap == null;

  // Aliases de compatibilidade dos params `@Deprecated`.
  Color? get _effectiveBackground {
    // ignore: deprecated_member_use_from_same_package
    return widget.background ?? widget.fillColor;
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);

    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  void _onTextChange() {
    setState(() {
      // Rebuild para mostrar/esconder o hint e atualizar o contador.
    });
  }

  @override
  void didUpdateWidget(AppInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null &&
        widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      final nextValue = widget.initialValue ?? '';

      // Mantém o caret estável quando o pai normaliza/formata o valor.
      _controller.value = _controller.value.copyWith(
        composing: TextRange.empty,
        selection: TextSelection.collapsed(offset: nextValue.length),
        text: nextValue,
      );
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  /// Em erro + habilitado + preenchido, o sufixo vira um ✕ que limpa o campo
  /// (sobrepondo o [AppInput.suffixIcon] do chamador).
  bool get _showClear =>
      (widget.hasError || widget.errorText != null) &&
      widget.enabled &&
      _controller.text.isNotEmpty;

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
    if (widget.onClear != null) {
      widget.onClear!();
    } else {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colorTheme;
    final bool error = widget.hasError || widget.errorText != null;
    final InputFieldColors c = inputFieldColors(
      colors,
      enabled: widget.enabled,
      focused: _isFocused,
      error: error,
    );

    // Posicionamento do info quando NÃO há label: vira o sufixo do campo se não
    // houver sufixo; senão fica ao lado do input (encolhendo-o). Com label, o
    // info vai na row do label (via appFieldLabel).
    final bool infoBesideField =
        widget.info != null &&
        widget.label == null &&
        (widget.suffixIcon != null || _showClear);

    Widget field = _buildInputField(theme, c);
    if (infoBesideField) {
      field = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: field),
          const SizedBox(width: AppSpacings.s8),
          appFieldInfo(
            info: widget.info!,
            color: c.icon,
            iconSize: widget.size.iconSize,
            semanticLabel: widget.label ?? widget.hintText,
          ),
        ],
      );
    }

    // O campo publicava QUATRO nós irmãos soltos: rótulo, dica e erro como
    // texto avulso, e o `EditableText` — o único marcado como `textField` —
    // **sem nome nenhum**. Quem chegava nele por leitor de tela ouvia "campo
    // de texto" e mais nada; e o erro, sendo texto comum, nunca era anunciado
    // ao aparecer. Agora rótulo/dica viajam NO nó do campo, e o rótulo visual
    // sai da árvore para não ser lido duas vezes (a mesma duplicação que já
    // fez o AppButton anunciar "Salvar Salvar").
    field = AppSemantics.textField(
      label: widget.label ?? widget.hintText,
      hint: widget.label != null ? widget.hintText : null,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      obscured: widget.obscureText,
      multiline: widget.maxLines > 1,
      focused: _isFocused,
      child: field,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacings.s4),
            child: AppSemantics.decorative(
              appFieldLabel(
                label: widget.label!,
                style: theme.textTheme.labelLarge.withColor(c.label),
                infoIconSize: widget.size.iconSize,
                info: widget.info,
              ),
            ),
          ),
        ],

        field,

        if (widget.errorText != null ||
            widget.helperText != null ||
            widget.showCounter) ...[
          const SizedBox(height: AppSpacings.s4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildHelperText(theme, c)),
              if (widget.showCounter && widget.maxLength != null) ...[
                const SizedBox(width: AppSpacings.s8),
                _buildCharacterCounter(theme),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildInputField(AppThemeData theme, InputFieldColors c) {
    final colors = theme.colorTheme;
    final actualMaxLines = widget.maxLines > 5 ? 5 : widget.maxLines;
    final minLines = widget.maxLines > 1 ? 1 : null;

    // Raio: override cru > `borderRadius` (deprecated) > radiusMode local >
    // global.
    final BorderRadius radius =
        widget.radius ??
        // ignore: deprecated_member_use_from_same_package
        (widget.borderRadius != null
            // ignore: deprecated_member_use_from_same_package
            ? BorderRadius.circular(widget.borderRadius!)
            : theme.radiusTheme.resolve(override: widget.radiusMode));

    // Eixo global de style: override do campo > global do tema.
    final AppStyle style = widget.style ?? theme.styleTheme.style;
    final bool fillStyle =
        style == AppStyle.filled || style == AppStyle.elevated;
    final bool error = widget.hasError || widget.errorText != null;

    // Fill (surface) do campo por estado.
    //
    // O campo é **isento** da regra de separação: ele aparece tanto sobre a
    // página quanto dentro de um cartão, e nenhum stop do neutro satisfaz a
    // regra contra as duas sem virar um cinza médio. O que se exige aqui é
    // menos: não COLIDIR com a superfície que o hospeda.
    //
    // - desabilitado: mesmo fill do normal. Antes era `neutralPrimary.s50` —
    //   que É o `surfaceContainer` no tema claro e a `surface` no escuro, ou
    //   seja, ΔT = 0.0 contra uma superfície em cada tema: o campo sumia por
    //   completo. O estado já é comunicado pelo conteúdo apagado por tom
    //   (borda, label, ícone, texto), que é a receita do DS para disabled.
    // - erro + estilo preenchido: o stop de `danger` mais afastado das duas
    //   superfícies. Fixar `danger.s100` funcionava numa marca e não na outra
    //   (2.0 de separação na jotape clara contra 5.3 na zxtrack), porque as
    //   rampas de danger não distribuem os stops igual.
    // - senão: o `background` do chamador — outlined→transparente; filled/
    //   elevated caem para a surface `neutralPrimary.s200` (o "poço" dos demais
    //   componentes, ao invés de `surfaceContainer` que some sobre painéis).
    final Color? ownFill = (error && fillStyle && widget.enabled)
        ? mostSeparatedStop(
            colors.danger,
            surfaces: <Color>[colors.surface, colors.surfaceContainer],
            content: colors.onSurface,
          )
        : _effectiveBackground;

    final StyleDecoration deco = resolveStyleDecoration(
      style: style,
      isDark: theme.brightness == AppBrightness.dark,
      outline: c.border,
      // Derivado, não fixo: hoje resolve para `s200` nas duas marcas e nos
      // dois temas, mas se a rampa de uma marca mudar o campo acompanha em
      // vez de colidir em silêncio com a superfície.
      surfaceContainer: mostSeparatedStop(
        colors.neutralPrimary,
        surfaces: <Color>[colors.surface, colors.surfaceContainer],
        content: colors.onSurface,
      ),
      ownFill: ownFill,
      borderWidth: AppStrokes.m,
    );

    // A borda (outlined) vai em PRIMEIRO PLANO (foregroundDecoration): pintada
    // por cima, não entra no layout → alternar entre estilos não muda o tamanho
    // do campo nem o espaçamento interno.
    final content = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: deco.color,
        boxShadow: deco.boxShadow,
        borderRadius: radius,
      ),
      foregroundDecoration: deco.border == null
          ? null
          : BoxDecoration(border: deco.border, borderRadius: radius),
      child: _buildFieldRow(theme, c, actualMaxLines, minLines),
    );

    if (!widget.enabled) {
      return MouseRegion(cursor: SystemMouseCursors.basic, child: content);
    }

    // Campo de texto (editável ou read-only): seleção nativa via gestos do
    // Flutter. O builder também foca/abre o teclado no tap.
    if (widget.onTap == null) {
      return MouseRegion(
        cursor: SystemMouseCursors.text,
        child: buildTextSelectionGestures(child: content),
      );
    }

    final focusableContent = Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        _pointerDownPosition = event.position;
        _pointerDragged = false;
        if (!_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
      },
      onPointerMove: (event) {
        final start = _pointerDownPosition;
        if (start == null || _pointerDragged) {
          return;
        }
        if ((event.position - start).distance > _tapDragThreshold) {
          _pointerDragged = true;
        }
      },
      onPointerCancel: (_) {
        _pointerDownPosition = null;
        _pointerDragged = false;
      },
      onPointerUp: (_) {
        final canCallTap = widget.onTap != null && !_pointerDragged;
        _pointerDownPosition = null;
        _pointerDragged = false;
        if (canCallTap) {
          widget.onTap?.call();
        }
      },
      child: content,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: focusableContent,
    );
  }

  Widget _buildFieldRow(
    AppThemeData theme,
    InputFieldColors c,
    int maxLines,
    int? minLines,
  ) {
    final textStyle = theme.textTheme.bodyLarge.withColor(c.text);
    final minFieldHeight = _getMinFieldHeight();
    final bool multiline = maxLines > 1;

    // Sem label e sem sufixo próprio: o info ocupa o slot de sufixo do campo.
    final bool infoAsSuffix =
        widget.info != null &&
        widget.label == null &&
        widget.suffixIcon == null &&
        !_showClear;
    final bool hasSuffixSlot =
        widget.suffixIcon != null || _showClear || infoAsSuffix;

    final Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.prefixIcon != null) ...[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: _getVerticalPadding(),
            ),
            child: Center(child: _buildPrefixIcon(c)),
          ),
        ],
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: widget.prefixIcon == null ? _getHorizontalPadding() : 0,
              right: hasSuffixSlot ? 0 : _getHorizontalPadding(),
              top: _getVerticalPadding(),
              bottom: _getVerticalPadding(),
            ),
            child: _buildTextInput(theme, c, textStyle, maxLines, minLines),
          ),
        ),
        if (hasSuffixSlot) ...[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: _getVerticalPadding(),
            ),
            child: Center(
              child: infoAsSuffix
                  ? appFieldInfo(
                      info: widget.info!,
                      color: c.icon,
                      iconSize: widget.size.iconSize,
                      semanticLabel: widget.hintText,
                    )
                  : _buildSuffixIcon(c),
            ),
          ),
        ],
      ],
    );

    // `minHeight` (não altura fixa): no text scale padrão o campo é exatamente
    // `size.height`, mas CRESCE quando o texto escala (senão o conteúdo é
    // cortado). Multiline usa IntrinsicHeight para o crescimento vertical.
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minFieldHeight),
      child: multiline ? IntrinsicHeight(child: row) : row,
    );
  }

  Widget _buildTextInput(
    AppThemeData theme,
    InputFieldColors c,
    TextStyle textStyle,
    int maxLines,
    int? minLines,
  ) {
    final mouseCursor = widget.onTap != null
        ? SystemMouseCursors.click
        : SystemMouseCursors.text;
    final selectionControls = appTextSelectionControls;

    return Stack(
      children: [
        if (_controller.text.isEmpty && widget.hintText != null)
          Positioned.fill(
            // Fora da árvore de semântica: a dica já viaja no nó do campo
            // (`hint:`/`label:`). Deixá-la aqui a fazia ser absorvida pelo
            // rótulo do container E anunciada de novo como dica — o usuário
            // ouvia o placeholder duas vezes.
            // `SelectionContainer.disabled` porque a dica é decorativa e o
            // `IgnorePointer` acima NÃO a protege na web: todo `AppText` vira um
            // `AppSelectionRegion` quando existe `Overlay` ancestral, e na web um
            // `SelectableRegion` monta um platform view DOM (`Positioned.fill`)
            // cobrindo a região. Um elemento do DOM não participa do hit-test do
            // Flutter, então o `IgnorePointer` desaparece para o framework e
            // continua de pé para o navegador: o div ficava por cima da área
            // editável, oferecendo seleção e menu de contexto onde só devia haver
            // o campo. Desligar o registrar cai no guard que `AppSelectionRegion`
            // já tem e não cria região nenhuma.
            child: SelectionContainer.disabled(
              child: AppSemantics.decorative(
                IgnorePointer(
                  child: Align(
                    alignment: switch (widget.textAlign) {
                      TextAlign.center => Alignment.center,
                      TextAlign.end || TextAlign.right => Alignment.centerRight,
                      _ => Alignment.centerLeft,
                    },
                    child: AppText(
                      widget.hintText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium.withColor(c.hint),
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Delega TODO o tratamento de ponteiro ao TextSelectionGestureDetector
        // (como o TextField faz). Sem `rendererIgnoresPointer`, o RenderEditable
        // trata o tap sozinho e impede a contagem de cliques consecutivos —
        // quebrando duplo-clique (palavra) e triplo-clique (linha).
        EditableText(
          key: editableTextKey,
          rendererIgnoresPointer: true,
          controller: _controller,
          focusNode: _focusNode,
          style: textStyle,
          cursorColor: c.cursor,
          backgroundCursorColor: c.cursor,
          cursorRadius: const Radius.circular(AppRadius.xs),
          cursorOpacityAnimates: true,
          selectionColor: theme.colorTheme.primary.s300.withValues(alpha: 0.34),
          selectionControls: selectionControls,
          maxLines: maxLines,
          minLines: minLines,
          mouseCursor: mouseCursor,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          keyboardAppearance: theme.brightness == AppBrightness.dark
              ? Brightness.dark
              : Brightness.light,
          inputFormatters: _getInputFormatters(),
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          obscureText: widget.obscureText,
          textAlign: widget.textAlign,
          textDirection: TextDirection.ltr,
          autocorrect: false,
          enableSuggestions: true,
          cursorWidth: 2.0,
          cursorHeight: textStyle.fontSize,
          showCursor: widget.enabled && !widget.readOnly,
          expands: false,
          textCapitalization: widget.textCapitalization,
          scrollPadding: EdgeInsets.zero,
          readOnly: widget.readOnly || !widget.enabled,
          enableInteractiveSelection: selectionEnabled,
        ),
      ],
    );
  }

  Widget _buildPrefixIcon(InputFieldColors c) {
    return AppIcon(
      widget.prefixIcon!,
      customSize: widget.size.iconSize,
      color: c.icon,
    );
  }

  Widget _buildSuffixIcon(InputFieldColors c) {
    // Erro + preenchido: ✕ que limpa (sobrepõe o sufixo do chamador).
    if (_showClear) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _handleClear,
          child: AppIcon(
            AppIconToken.close,
            customSize: widget.size.iconSize,
            color: c.icon,
          ),
        ),
      );
    }

    final hasAction = widget.onSuffixIconTap != null || widget.onTap != null;
    return MouseRegion(
      cursor: hasAction
          ? SystemMouseCursors.click
          : widget.readOnly
          ? SystemMouseCursors.basic
          : SystemMouseCursors.text,
      child: GestureDetector(
        // Alvo de toque = a caixa inteira do ícone (não só os traços pintados
        // do SVG), senão toques no meio transparente do ícone erram.
        behavior: HitTestBehavior.opaque,
        onTap: widget.onSuffixIconTap,
        child: AppIcon(
          widget.suffixIcon!,
          customSize: widget.size.iconSize,
          color: widget.suffixIconColor ?? c.icon,
        ),
      ),
    );
  }

  Widget _buildHelperText(AppThemeData theme, InputFieldColors c) {
    final text = widget.errorText ?? widget.helperText;
    if (text == null) return const SizedBox.shrink();

    final bool error = widget.hasError || widget.errorText != null;
    final Widget label = AppText(
      text,
      style: error
          ? theme.textTheme.labelMedium.withColor(c.border)
          : theme.textTheme.bodySmall.withColor(
              theme.colorTheme.neutralPrimary.s700,
            ),
    );

    // Só o ERRO é live region. A mensagem de erro aparece DEPOIS que o usuário
    // agiu — validação no blur, resposta do servidor — e sem isto ela entra na
    // tela em silêncio, num ponto que o foco não visita. `helperText` é
    // estático e não interrompe leitura.
    return error ? AppSemantics.liveRegion(label) : label;
  }

  Widget _buildCharacterCounter(AppThemeData theme) {
    final currentLength = _controller.text.length;
    final maxLength = widget.maxLength!;

    return AppText(
      '$currentLength/$maxLength',
      style: theme.textTheme.labelSmall.withColor(
        theme.colorTheme.neutralPrimary.s700,
      ),
    );
  }

  double _getHorizontalPadding() =>
      widget.isDense ? AppSpacings.s4 : widget.size.horizontalPadding;

  double _getVerticalPadding() =>
      widget.isDense ? AppSpacings.s4 : widget.size.verticalPadding;

  /// Altura do campo é fixa por [AppInput.size] (single-line) e mínima no
  /// multiline — a borda em foreground não entra nesta conta.
  double _getMinFieldHeight() => widget.size.height;

  List<TextInputFormatter>? _getInputFormatters() {
    final formatters = <TextInputFormatter>[];

    if (widget.inputFormatters != null) {
      formatters.addAll(widget.inputFormatters!);
    }

    if (widget.maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }

    return formatters.isEmpty ? null : formatters;
  }
}
