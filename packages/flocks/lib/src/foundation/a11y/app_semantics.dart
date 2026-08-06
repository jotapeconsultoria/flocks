import 'package:flutter/semantics.dart' show Assertiveness, SemanticsService;
import 'package:flutter/widgets.dart';

/// Fábricas de acessibilidade do Flocks.
///
/// Padroniza o uso de [Semantics] (role + estado + label) para que nenhum
/// componente monte `Semantics` à mão. Fica sobre a camada `widgets`/
/// `semantics` (sem Material/Cupertino). Todo componente migrado descreve seu
/// comportamento de acessibilidade em `a11y.en`/`a11y.pt` no `.meta.dart`, e
/// `tool/component_conformance.dart` reprova quem deixar vazio (Regra 8).
sealed class AppSemantics {
  const AppSemantics._();

  /// Semântica de botão: role de botão + estado enabled + ação de tap. Faz
  /// merge do subtree em um nó único (evita leitura dupla de ícone+texto).
  static Widget button({
    required Widget child,
    String? label,
    bool enabled = true,
    bool loading = false,
    VoidCallback? onTap,
  }) {
    // Sem handler não há botão habilitado — só um retângulo que parece um.
    // Antes `active` ignorava o [onTap], então `AppButton(onPressed: null)`
    // pintava desabilitado e ANUNCIAVA "habilitado": o leitor de tela dizia que
    // dava para acionar, e o toque não fazia nada.
    final bool active = enabled && !loading && onTap != null;
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: active,
        label: label,
        onTap: active ? onTap : null,
        child: child,
      ),
    );
  }

  /// Semântica de toggle (checkbox/switch/radio): estado checked + enabled.
  static Widget toggle({
    required Widget child,
    required bool value,
    bool enabled = true,
    bool mutuallyExclusive = false,
    String? label,
    VoidCallback? onTap,
  }) {
    return MergeSemantics(
      child: Semantics(
        enabled: enabled,
        checked: value,
        inMutuallyExclusiveGroup: mutuallyExclusive ? true : null,
        label: label,
        onTap: enabled ? onTap : null,
        child: child,
      ),
    );
  }

  /// Semântica de campo de texto: role textField + label/value/hint. O texto de
  /// erro, quando existir, deve ser embrulhado com [liveRegion] no ponto de uso.
  static Widget textField({
    required Widget child,
    String? label,
    String? value,
    String? hint,
    bool enabled = true,
    bool readOnly = false,
    bool obscured = false,
    bool multiline = false,
    bool focused = false,
  }) {
    return Semantics(
      container: true,
      textField: true,
      label: label,
      value: value,
      hint: hint,
      enabled: enabled,
      readOnly: readOnly,
      obscured: obscured,
      multiline: multiline,
      focused: focused,
      child: child,
    );
  }

  /// Semântica do gatilho de um seletor que ABRE um painel (dropdown, picker
  /// ancorado, combobox).
  ///
  /// O que o diferencia de um botão comum é o [expanded]: sem ele o leitor de
  /// tela anuncia "botão" e o usuário não tem como saber se a lista está aberta
  /// nem que abrir é o que aquele controle faz — some a única pista de que há
  /// um painel do outro lado do toque. É requisito da Regra 8.
  ///
  /// [value] é a escolha corrente ("Banana", "3 selecionados"); sem ela o
  /// controle é anunciado sem dizer o que está valendo.
  static Widget expandable({
    required Widget child,
    required bool expanded,
    String? label,
    String? value,
    String? hint,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    return MergeSemantics(
      child: Semantics(
        container: true,
        button: true,
        expanded: expanded,
        label: label,
        value: value,
        hint: hint,
        enabled: enabled,
        onTap: enabled ? onTap : null,
        child: child,
      ),
    );
  }

  /// Célula selecionável de uma grade (dia de um calendário, valor de uma roda).
  ///
  /// Uma grade de células desenhadas é o pior caso do Gate 8: o dia "15" chega
  /// ao leitor de tela como o texto "15", sem dizer que é acionável, de que mês
  /// é, se está escolhido ou se está fora do intervalo permitido. Quem não
  /// enxerga a grade não tem nenhuma dessas informações.
  ///
  /// [label] deve ser o valor por EXTENSO ("15 de julho de 2026"), não o
  /// número: o número sozinho depende de o usuário lembrar o cabeçalho.
  static Widget gridCell({
    required Widget child,
    required String label,
    required bool selected,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    return MergeSemantics(
      child: Semantics(
        container: true,
        button: true,
        selected: selected,
        enabled: enabled,
        label: label,
        onTap: enabled ? onTap : null,
        // O número desenhado já está no [label]; deixá-lo mesclar faria o
        // leitor dizer "15 de julho de 2026 15".
        child: ExcludeSemantics(child: child),
      ),
    );
  }

  /// Fronteira de ROTA de uma superfície modal (dialog, bottom/side sheet).
  ///
  /// `scopesRoute` diz à camada de acessibilidade que ali começa uma rota: o
  /// leitor de tela passa a tratar o conteúdo como a tela corrente em vez de
  /// mais um pedaço da anterior. Sem isso o modal abre e o usuário de leitor
  /// continua navegando a tela DE BAIXO, sem saber que algo apareceu na frente.
  ///
  /// `explicitChildNodes` impede que o conteúdo inteiro colapse num nó só —
  /// numa sheet com formulário, isso viraria um parágrafo gigante.
  static Widget modalRoute({required Widget child}) =>
      Semantics(scopesRoute: true, explicitChildNodes: true, child: child);

  /// Marca [child] como cabeçalho de seção.
  ///
  /// Com [namesRoute], o texto também vira o NOME da rota — é o que faz o
  /// leitor anunciar "Excluir veículo?" ao abrir o modal, em vez de só dizer
  /// que uma tela nova apareceu.
  static Widget header(Widget child, {bool namesRoute = false}) =>
      Semantics(header: true, namesRoute: namesRoute, child: child);

  /// Contêiner de um menu de ações (agrupa os itens num nó rotulado).
  static Widget menu({required Widget child, String? label}) =>
      Semantics(container: true, label: label, child: child);

  /// Item de menu: role de botão + estado enabled + ação de tap (faz merge do
  /// subtree para não ler ícone+texto separados).
  static Widget menuItem({
    required Widget child,
    String? label,
    bool enabled = true,
    VoidCallback? onTap,
  }) => button(child: child, label: label, enabled: enabled, onTap: onTap);

  /// Marca [child] como região viva: mudanças no conteúdo são anunciadas por
  /// leitores de tela (alertas/erros).
  static Widget liveRegion(Widget child) =>
      Semantics(liveRegion: true, child: child);

  /// Região de status: um único [label] descreve o estado atual (ex.: progresso
  /// de etapas) e é anunciado quando muda. Exclui a semântica interna de [child]
  /// para não ler os elementos visuais de forma redundante.
  static Widget status({required Widget child, required String label}) =>
      Semantics(
        container: true,
        liveRegion: true,
        label: label,
        child: ExcludeSemantics(child: child),
      );

  /// Rótulo semântico único: expõe [child] como um nó rotulado por [label],
  /// substituindo a semântica interna (via [ExcludeSemantics]) para evitar
  /// leitura duplicada de números/ícones internos.
  static Widget label({required Widget child, required String label}) =>
      Semantics(
        container: true,
        label: label,
        child: ExcludeSemantics(child: child),
      );

  /// Dica de um alvo: expõe [message] no campo `tooltip` do nó de [child],
  /// **sem** substituir o rótulo que ele já tenha.
  ///
  /// É o par semântico do balão visual do `AppTooltip`. Sem isto a dica existe
  /// só para quem enxerga o hover — e num controle só-ícone, cuja dica É o
  /// nome dele (o item do rail colapsado, a alça de redimensionar), o leitor
  /// de tela anuncia um botão sem nome.
  ///
  /// Diferente de [label]: aquele SUBSTITUI a semântica interna; este
  /// acrescenta, porque a dica quase sempre convive com um rótulo próprio.
  static Widget tooltip({required String message, required Widget child}) =>
      message.trim().isEmpty
      ? child
      : Semantics(tooltip: message, child: child);

  /// Exclui [child] da árvore de semântica (ícones/ilustrações decorativos).
  static Widget decorative(Widget child) => ExcludeSemantics(child: child);

  /// Anuncia [message] para leitores de tela. Use [assertive] apenas para
  /// interrupções urgentes; o padrão é `polite`.
  static void announce(
    BuildContext context,
    String message, {
    bool assertive = false,
  }) {
    SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      Directionality.of(context),
      assertiveness: assertive ? Assertiveness.assertive : Assertiveness.polite,
    );
  }
}
