import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'app_route_topmost.dart';

/// Focar a busca global.
final class AppFocusSearchIntent extends Intent {
  const AppFocusSearchIntent();
}

/// Focar o composer do assistente.
final class AppFocusAssistantIntent extends Intent {
  const AppFocusAssistantIntent();
}

/// Abrir o perfil do usuário.
final class AppOpenProfileIntent extends Intent {
  const AppOpenProfileIntent();
}

/// Devolver o foco ao conteúdo, saindo de busca/assistente.
final class AppDismissFocusIntent extends Intent {
  const AppDismissFocusIntent();
}

/// Alternar o colapso da navegação.
final class AppToggleNavigationIntent extends Intent {
  const AppToggleNavigationIntent();
}

/// Focar a busca da tela atual (a tabela), não a global.
final class AppFindInPageIntent extends Intent {
  const AppFindInPageIntent();
}

/// Ir para a aba de índice [index] (base zero).
final class AppSelectTabIntent extends Intent {
  const AppSelectTabIntent(this.index);

  final int index;
}

/// Quantas abas os atalhos numéricos alcançam.
///
/// Casa com o teto de abas abertas: um atalho para uma aba que não pode existir
/// seria uma tecla morta.
const int kAppTabShortcutCount = 5;

/// Instala os atalhos globais do shell.
///
/// ## Por que um handler global, e não `Shortcuts`
///
/// `Shortcuts` intercepta subindo a **árvore de foco**. Isso basta no mobile e
/// no desktop nativo, mas falha na web quando o foco está num campo de texto:
/// ali o Flutter usa um elemento de entrada real do navegador para IME, e a
/// tecla não percorre a árvore do framework — o atalho simplesmente não
/// dispara. Como este shell mantém o composer do assistente sempre montado (e
/// ele pede foco ao abrir), esse era o caso comum, não a exceção.
///
/// Por isso os atalhos são resolvidos num handler registrado direto no
/// [HardwareKeyboard], que recebe o evento antes de qualquer decisão de foco.
/// Devolver `true` também marca a tecla como consumida, o que evita o
/// comportamento padrão do navegador.
///
/// ## `/` só quando não se está digitando
///
/// A tecla `/` é um atalho **e** um caractere. Sequestrá-la dentro de um campo
/// quebraria desde a digitação de uma data até o próprio `/comando` do chat —
/// então ela só dispara quando o foco não edita texto, mesma regra do GitLab.
/// Os atalhos com modificador não têm esse conflito.
///
/// ## Por que as abas usam dígito sozinho
///
/// `Cmd/Ctrl + 1..9` é troca de aba do **navegador** em Chrome, Firefox, Safari
/// e Edge — resolvido antes de a página ver a tecla, sem `preventDefault` que
/// contorne. `Alt + número` colide com o Firefox no Windows/Linux. O dígito
/// puro é a única faixa que navegador nenhum reserva, e segue a mesma regra do
/// `/`: só vale fora de campo de texto.
final class AppShortcutsScope extends StatefulWidget {
  const AppShortcutsScope({
    required this.child,
    this.onFocusSearch,
    this.onFocusAssistant,
    this.onOpenProfile,
    this.onDismissFocus,
    this.onToggleNavigation,
    this.onSelectTab,
    this.onFindInPage,
    this.onOpenHistory,
    super.key,
  });

  final Widget child;

  /// `/` (fora de campo de texto) e `Cmd/Ctrl+K`.
  final VoidCallback? onFocusSearch;

  /// `Cmd/Ctrl+J`.
  ///
  /// `J` e não `I`: em várias fontes o `I` maiúsculo e o `l` minúsculo são o
  /// mesmo desenho, e o selo do atalho viraria adivinhação.
  final VoidCallback? onFocusAssistant;

  /// `Cmd/Ctrl+Shift+P`.
  final VoidCallback? onOpenProfile;

  /// `Esc`. Devolve `true` se **havia** foco para devolver.
  ///
  /// O retorno é o que decide se a tecla é consumida: com um campo focado, o
  /// `Esc` só tira o foco; sem nada focado, ele **passa adiante** e chega ao
  /// dialog/sheet aberto, que é o que se espera dele ali. Consumir sempre — o
  /// que este escopo fazia — deixava o `Esc` inerte no app inteiro.
  final bool Function()? onDismissFocus;

  /// `Cmd/Ctrl+B`.
  final VoidCallback? onToggleNavigation;

  /// `1` a `5` (fora de campo de texto). Recebe o índice base zero.
  final ValueChanged<int>? onSelectTab;

  /// `H` (fora de campo de texto).
  ///
  /// Tecla nua como os dígitos das abas: o histórico é vizinho delas, e mistura
  /// de convenções (dígito nu para aba, modificador para o histórico) faria o
  /// conjunto parecer arbitrário.
  final VoidCallback? onOpenHistory;

  /// `Cmd/Ctrl+F`.
  ///
  /// Assumir o `⌘F` não custa nada aqui: o app pinta em canvas (CanvasKit), e o
  /// "localizar" do navegador procura no DOM — ou seja, ele já não achava nada.
  /// Ao contrário de `⌘1..9` e `⌘W/T/N`, que o navegador resolve antes da
  /// página ver, o `⌘F` é cancelável, e devolver `true` aqui o cancela.
  final VoidCallback? onFindInPage;

  /// O foco atual está num campo que edita texto?
  ///
  /// Exposto para quem precise da mesma decisão fora deste escopo.
  static bool isEditingText() {
    final primary = FocusManager.instance.primaryFocus;
    if (primary == null) return false;
    // `EditableText` (e portanto todo campo do DS) instala um contexto cujo
    // widget responde por este tipo.
    return primary.context?.widget is EditableText ||
        primary.context?.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  @override
  State<AppShortcutsScope> createState() => _AppShortcutsScopeState();
}

class _AppShortcutsScopeState extends State<AppShortcutsScope> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKey);
    super.dispose();
  }

  static const List<LogicalKeyboardKey> _digitKeys = [
    LogicalKeyboardKey.digit1,
    LogicalKeyboardKey.digit2,
    LogicalKeyboardKey.digit3,
    LogicalKeyboardKey.digit4,
    LogicalKeyboardKey.digit5,
  ];

  static const List<LogicalKeyboardKey> _numpadKeys = [
    LogicalKeyboardKey.numpad1,
    LogicalKeyboardKey.numpad2,
    LogicalKeyboardKey.numpad3,
    LogicalKeyboardKey.numpad4,
    LogicalKeyboardKey.numpad5,
  ];

  bool get _hasModifier {
    final keyboard = HardwareKeyboard.instance;
    return keyboard.isMetaPressed || keyboard.isControlPressed;
  }

  /// Índice da aba pedido por [key], ou `null` se não for uma tecla de aba.
  int? _tabIndexFor(LogicalKeyboardKey key) {
    final digit = _digitKeys.indexOf(key);
    if (digit >= 0) return digit;
    final numpad = _numpadKeys.indexOf(key);
    return numpad >= 0 ? numpad : null;
  }

  bool _handleKey(KeyEvent event) {
    // Atalho global não age sob um diálogo/sheet: o teclado pertence a quem
    // está por cima (ver [appRouteIsTopmost]).
    if (!appRouteIsTopmost(context)) return false;
    if (event is! KeyDownEvent) return false;

    // Teclas sem modificador só valem fora de campo de texto — senão
    // sequestrariam a digitação.
    if (!_hasModifier && !AppShortcutsScope.isEditingText()) {
      if (event.logicalKey == LogicalKeyboardKey.slash) {
        if (widget.onFocusSearch == null) return false;
        widget.onFocusSearch!.call();
        return true;
      }

      final tabIndex = _tabIndexFor(event.logicalKey);
      if (tabIndex != null) {
        if (widget.onSelectTab == null) return false;
        widget.onSelectTab!.call(tabIndex);
        return true;
      }

      if (event.logicalKey == LogicalKeyboardKey.keyH) {
        if (widget.onOpenHistory == null) return false;
        widget.onOpenHistory!.call();
        return true;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (widget.onDismissFocus == null) return false;
      return widget.onDismissFocus!.call();
    }

    if (!_hasModifier) return false;

    final shift = HardwareKeyboard.instance.isShiftPressed;

    if (event.logicalKey == LogicalKeyboardKey.keyP && shift) {
      if (widget.onOpenProfile == null) return false;
      widget.onOpenProfile!.call();
      return true;
    }
    // Um atalho com Shift não deve cair nos casos sem Shift abaixo.
    if (shift) return false;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.keyK:
        if (widget.onFocusSearch == null) return false;
        widget.onFocusSearch!.call();
        return true;
      case LogicalKeyboardKey.keyJ:
        if (widget.onFocusAssistant == null) return false;
        widget.onFocusAssistant!.call();
        return true;
      case LogicalKeyboardKey.keyB:
        if (widget.onToggleNavigation == null) return false;
        widget.onToggleNavigation!.call();
        return true;
      case LogicalKeyboardKey.keyF:
        if (widget.onFindInPage == null) return false;
        widget.onFindInPage!.call();
        return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
