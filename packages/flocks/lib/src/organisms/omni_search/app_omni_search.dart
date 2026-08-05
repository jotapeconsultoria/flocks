import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../foundation/app_command_registry.dart';
import '../../molecules/card/anchored_overlay.dart';
import '../../molecules/input/input.dart';
import '../../molecules/interactive/interactive.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_omni_search_models.dart';

/// Espera antes de disparar a busca, para não bater no servidor a cada tecla.
const Duration kAppOmniSearchDebounce = Duration(milliseconds: 260);

/// Altura máxima do painel de resultados.
const double kAppOmniSearchPanelMaxHeight = 420.0;

/// Assinatura da busca. Recebe o termo já aparado e não vazio.
typedef AppOmniSearchCallback =
    Future<AppOmniSearchResult> Function(String term);

/// Busca global com autocomplete e comandos `/`.
///
/// ## Duas fontes, um campo
///
/// Um termo comum vai para [onSearch] (assíncrono, com debounce). Um termo que
/// começa com `/` **não** vai: é resolvido localmente pelo
/// [AppCommandRegistry] do [AppCommandScope] ancestral. Isso mantém o comando
/// instantâneo e evita mandar "/sair" para o servidor.
///
/// ## Teclado
///
/// `↑`/`↓` andam pelos resultados atravessando os grupos, `Enter` escolhe o
/// item em foco e `Esc` fecha o painel. O campo continua com o foco o tempo
/// todo — o painel nunca o rouba, senão a digitação pararia.
final class AppOmniSearch extends StatefulWidget {
  const AppOmniSearch({
    required this.onSearch,
    this.controller,
    this.focusNode,
    this.hintText = 'Buscar',
    this.helperText,
    this.shortcut,
    this.size = AppFieldSize.m,
    this.debounce = kAppOmniSearchDebounce,
    this.panelMaxHeight = kAppOmniSearchPanelMaxHeight,
    this.emptyLabel = 'Nada encontrado',
    super.key,
  });

  /// Executa a busca de um termo comum.
  final AppOmniSearchCallback onSearch;

  final TextEditingController? controller;

  /// Passe o seu para focar o campo de fora (ex.: pelo atalho `/`).
  final FocusNode? focusNode;

  final String hintText;

  /// Dica fixa abaixo do campo (ex.: por quais campos dá para buscar).
  final String? helperText;

  /// Atalho exibido no sufixo do campo. Sempre visível: é o que ensina a
  /// tecla sem precisar de documentação.
  final AppShortcut? shortcut;

  /// Altura do campo. Um shell com barra enxuta usa [AppFieldSize.s].
  final AppFieldSize size;

  final Duration debounce;

  final double panelMaxHeight;

  /// Texto de "a busca rodou e não achou nada".
  final String emptyLabel;

  @override
  State<AppOmniSearch> createState() => _AppOmniSearchState();
}

class _AppOmniSearchState extends State<AppOmniSearch> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  final AnchoredOverlayController _overlay = AnchoredOverlayController();

  Timer? _debounceTimer;

  /// Sequência da busca em voo, para descartar resposta fora de ordem.
  int _requestId = 0;

  String _term = '';
  bool _isLoading = false;
  AppOmniSearchResult _result = const AppOmniSearchResult();
  List<AppCommand> _commands = const [];
  int _highlighted = 0;

  bool get _isCommandMode => AppCommandRegistry.isCommandInput(_term);

  /// Itens navegáveis, achatados na ordem em que aparecem.
  List<AppOmniSearchItem> get _flatItems => [
    for (final group in _result.nonEmptyGroups) ...group.items,
  ];

  int get _optionCount => _isCommandMode ? _commands.length : _flatItems.length;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    _overlay.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) return;
    if (_term.isNotEmpty) _openPanel();
  }

  void _onTextChanged() {
    final value = _controller.text;
    if (value == _term) return;
    _term = value;
    _highlighted = 0;

    if (value.trim().isEmpty) {
      _debounceTimer?.cancel();
      _requestId++;
      setState(() {
        _isLoading = false;
        _result = const AppOmniSearchResult();
        _commands = const [];
      });
      _closePanel();
      return;
    }

    if (_isCommandMode) {
      // Comando é local: sem debounce e sem ida ao servidor.
      _debounceTimer?.cancel();
      _requestId++;
      setState(() {
        _isLoading = false;
        _commands = AppCommandScope.of(context).search(value);
        _result = const AppOmniSearchResult();
      });
      _openPanel();
      return;
    }

    setState(() {
      _isLoading = true;
      _commands = const [];
    });
    _openPanel();
    _scheduleSearch(value.trim());
  }

  void _scheduleSearch(String term) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounce, () => _runSearch(term));
  }

  Future<void> _runSearch(String term) async {
    final requestId = ++_requestId;
    try {
      final result = await widget.onSearch(term);
      // Resposta atrasada de um termo antigo não pode sobrescrever a atual.
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _isLoading = false;
        _result = result;
        _highlighted = 0;
      });
    } catch (error) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _isLoading = false;
        _result = AppOmniSearchResult.failed('$error');
      });
    }
    _overlay.rebuild();
  }

  void _openPanel() {
    if (_overlay.isOpen) {
      _overlay.rebuild();
      return;
    }
    _overlay.open(
      context,
      placement: AppOverlayPlacement.bottomStart,
      // Sem autofocus: o painel não pode roubar o foco do campo, senão a
      // digitação para no primeiro resultado.
      autofocus: false,
      builder: (_) => _buildPanel(),
    );
  }

  void _closePanel() => _overlay.close();

  void _moveHighlight(int delta) {
    if (_optionCount == 0) return;
    setState(() {
      _highlighted = (_highlighted + delta) % _optionCount;
      if (_highlighted < 0) _highlighted += _optionCount;
    });
    _overlay.rebuild();
  }

  void _activateHighlighted() {
    if (_optionCount == 0) return;
    if (_isCommandMode) {
      _runCommand(_commands[_highlighted]);
      return;
    }
    _selectItem(_flatItems[_highlighted]);
  }

  void _selectItem(AppOmniSearchItem item) {
    _closePanel();
    item.onSelected();
  }

  void _runCommand(AppCommand command) {
    _closePanel();
    _controller.clear();
    command.run(context);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        _moveHighlight(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _moveHighlight(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
        if (!_overlay.isOpen || _optionCount == 0) {
          return KeyEventResult.ignored;
        }
        _activateHighlighted();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        if (!_overlay.isOpen) return KeyEventResult.ignored;
        _closePanel();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return CompositedTransformTarget(
      link: _overlay.link,
      child: TapRegion(
        groupId: _overlay.groupId,
        onTapOutside: (_) => _closePanel(),
        child: Focus(
          onKeyEvent: _onKey,
          skipTraversal: true,
          canRequestFocus: false,
          child: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              AppInput(
                controller: _controller,
                focusNode: _focusNode,
                hintText: widget.hintText,
                helperText: widget.helperText,
                prefixIcon: AppIconToken.search,
                suffixIcon: _term.isNotEmpty ? AppIconToken.cancel : null,
                onSuffixIconTap: _term.isNotEmpty ? _clear : null,
                size: widget.size,
                style: theme.styleTheme.style,
              ),
              // O selo cede o lugar ao ✕ assim que há texto: os dois no mesmo
              // canto brigariam pelo espaço.
              if (widget.shortcut != null && _term.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacings.s12),
                  child: AppShortcutHint(widget.shortcut!),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _clear() {
    _controller.clear();
    _focusNode.requestFocus();
  }

  Widget _buildPanel() {
    // Largura do campo, via `leaderSize` do LayerLink (mesmo truque do
    // AppPickerAnchor, dispensa GlobalKey). Sem largura definida o ListView
    // do painel recebe restrição horizontal infinita e estoura o layout.
    final width = _overlay.link.leaderSize?.width;
    final panel = _AppOmniSearchPanel(
      maxHeight: widget.panelMaxHeight,
      isLoading: _isLoading,
      term: _term,
      emptyLabel: widget.emptyLabel,
      result: _result,
      commands: _commands,
      isCommandMode: _isCommandMode,
      highlighted: _highlighted,
      onSelectItem: _selectItem,
      onRunCommand: _runCommand,
    );
    return width == null ? panel : SizedBox(width: width, child: panel);
  }
}

/// Painel ancorado: grupos de resultados ou lista de comandos.
final class _AppOmniSearchPanel extends StatelessWidget {
  const _AppOmniSearchPanel({
    required this.maxHeight,
    required this.isLoading,
    required this.term,
    required this.emptyLabel,
    required this.result,
    required this.commands,
    required this.isCommandMode,
    required this.highlighted,
    required this.onSelectItem,
    required this.onRunCommand,
  });

  final double maxHeight;
  final bool isLoading;
  final String term;
  final String emptyLabel;
  final AppOmniSearchResult result;
  final List<AppCommand> commands;
  final bool isCommandMode;
  final int highlighted;
  final ValueChanged<AppOmniSearchItem> onSelectItem;
  final ValueChanged<AppCommand> onRunCommand;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final children = <Widget>[];
    var index = 0;

    if (isCommandMode) {
      if (commands.isNotEmpty) {
        children.add(const _GroupLabel(label: 'Comandos'));
        for (final command in commands) {
          final isHighlighted = index == highlighted;
          children.add(
            _CommandRow(
              command: command,
              isHighlighted: isHighlighted,
              onTap: () => onRunCommand(command),
            ),
          );
          index++;
        }
      }
    } else {
      for (final group in result.nonEmptyGroups) {
        children.add(_GroupLabel(label: group.label));
        for (final item in group.items) {
          final isHighlighted = index == highlighted;
          children.add(
            _ItemRow(
              item: item,
              term: term,
              isHighlighted: isHighlighted,
              onTap: () => onSelectItem(item),
            ),
          );
          index++;
        }
      }
    }

    final Widget body;
    if (isLoading && children.isEmpty) {
      body = const Padding(
        padding: EdgeInsets.all(AppSpacings.s24),
        child: Center(child: AppCircularLoading(size: AppSizes.s24)),
      );
    } else if (result.hasError) {
      body = _Message(text: result.error!, color: theme.colorTheme.danger);
    } else if (children.isEmpty) {
      body = _Message(
        text: emptyLabel,
        color: theme.colorTheme.neutralPrimary.s600,
      );
    } else {
      body = ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: AppSpacings.s8),
        children: children,
      );
    }

    // Painel SEMPRE `elevated`, independente do eixo global: isto flutua sobre
    // o conteúdo, e sem sombra ele lê como um bloco empurrando a página em vez
    // de uma camada por cima dela. Mesma decisão dos outros overlays do DS.
    final StyleDecoration deco = resolveStyleDecoration(
      style: AppStyle.elevated,
      isDark: theme.brightness == AppBrightness.dark,
      outline: theme.colorTheme.divider,
      surfaceContainer: theme.colorTheme.surfaceContainer,
    );

    // Painel largo: `containedMode()` clampa `circular` para `redondo` — a
    // pílula cortaria a primeira e a última linha da lista de resultados.
    final BorderRadius panelRadius = theme.radiusTheme.resolve(
      override: theme.radiusTheme.containedMode(),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: deco.color,
          borderRadius: panelRadius,
          border: Border.all(color: theme.colorTheme.divider),
          boxShadow: deco.boxShadow,
        ),
        child: ClipRRect(borderRadius: panelRadius, child: body),
      ),
    );
  }
}

final class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.s16,
        AppSpacings.s8,
        AppSpacings.s16,
        AppSpacings.s4,
      ),
      child: AppText(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall.withColor(
          theme.colorTheme.neutralPrimary.s500,
        ),
      ),
    );
  }
}

final class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.item,
    required this.term,
    required this.isHighlighted,
    required this.onTap,
  });

  final AppOmniSearchItem item;
  final String term;
  final bool isHighlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final strong = theme.colorTheme.neutralPrimary.s900;
    final muted = theme.colorTheme.neutralPrimary.s600;

    return _Row(
      isHighlighted: isHighlighted,
      onTap: onTap,
      semanticLabel: item.subtitle == null
          ? item.title
          : '${item.title}, ${item.subtitle}',
      icon: item.icon,
      trailing: item.trailing,
      child: Row(
        children: [
          Flexible(
            child: _HighlightedText(
              text: item.title,
              term: term,
              baseStyle: theme.textTheme.bodyMedium.copyWith(
                color: strong,
                fontWeight: FontWeight.w500,
              ),
              matchColor: theme.colorTheme.primaryAccent(
                isDark: theme.brightness == AppBrightness.dark,
              ),
            ),
          ),
          if (item.subtitle != null) ...[
            const SizedBox(width: AppSpacings.s8),
            Flexible(
              child: AppText(
                item.subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: theme.textTheme.bodySmall.withColor(muted),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

final class _CommandRow extends StatelessWidget {
  const _CommandRow({
    required this.command,
    required this.isHighlighted,
    required this.onTap,
  });

  final AppCommand command;
  final bool isHighlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final accent = theme.colorTheme.primaryAccent(
      isDark: theme.brightness == AppBrightness.dark,
    );

    return _Row(
      isHighlighted: isHighlighted,
      onTap: onTap,
      semanticLabel: '${command.token} ${command.label}',
      icon: command.icon,
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: accent.customOpacity(0.12),
              borderRadius: theme.radiusTheme.resolve(
                size: const Size.square(AppSizes.s24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacings.s4,
                vertical: AppSpacings.s2,
              ),
              child: AppText(
                command.token,
                style: theme.textTheme.labelSmall.withColor(accent),
              ),
            ),
          ),
          const SizedBox(width: AppSpacings.s8),
          Flexible(
            child: AppText(
              command.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: theme.textTheme.bodyMedium.withColor(
                theme.colorTheme.neutralPrimary.s900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Linha comum a resultado e comando: realce, ícone e trailing.
final class _Row extends StatelessWidget {
  const _Row({
    required this.isHighlighted,
    required this.onTap,
    required this.semanticLabel,
    required this.child,
    this.icon,
    this.trailing,
  });

  final bool isHighlighted;
  final VoidCallback onTap;
  final String semanticLabel;
  final Widget child;
  final String? icon;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final muted = theme.colorTheme.neutralPrimary.s600;

    // O realce do teclado usa a mesma cor do hover: uma linha "em foco" não
    // pode parecer diferente conforme se chegou nela por mouse ou por seta.
    final highlightColor = isHighlighted
        ? theme.colorTheme.neutralPrimary.s500.customOpacity(0.075)
        : theme.colorTheme.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: highlightColor,
          // Linha da lista: mesmo tratamento de forma dos tiles.
          borderRadius: theme.radiusTheme.tileRadius(),
        ),
        child: AppInteraction(
          onTap: onTap,
          semanticLabel: semanticLabel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s8,
            vertical: AppSpacings.s8,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                AppIcon(icon!, color: muted, customSize: 18),
                const SizedBox(width: AppSpacings.s8),
              ],
              Expanded(child: child),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacings.s8),
                AppText(
                  trailing!,
                  style: theme.textTheme.labelSmall.withColor(muted),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Título com o trecho que casa com o termo em destaque.
final class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.term,
    required this.baseStyle,
    required this.matchColor,
  });

  final String text;
  final String term;
  final TextStyle baseStyle;
  final Color matchColor;

  @override
  Widget build(BuildContext context) {
    final needle = term.trim().toLowerCase();
    final start = needle.isEmpty ? -1 : text.toLowerCase().indexOf(needle);

    if (start < 0) {
      return AppText(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: baseStyle,
      );
    }

    final end = start + needle.length;
    return AppRichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      semanticLabel: text,
      AppTextSpan(
        style: baseStyle,
        children: [
          if (start > 0) TextSpan(text: text.substring(0, start)),
          TextSpan(
            text: text.substring(start, end),
            style: baseStyle.copyWith(
              color: matchColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (end < text.length) TextSpan(text: text.substring(end)),
        ],
      ),
    );
  }
}

final class _Message extends StatelessWidget {
  const _Message({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacings.s24),
      child: Center(
        child: AppText(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall.withColor(color),
        ),
      ),
    );
  }
}
