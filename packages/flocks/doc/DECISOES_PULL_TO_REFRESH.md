# Pull-to-refresh: as duas decisões que vêm antes do componente

O `AppRefreshIndicator` é o último dos seis bloqueantes que a migração do ZAPDESK
levantou, e o único que não foi implementado. Não por falta de spec — ela existe e
é detalhada — mas porque a revisão adversarial encontrou **duas decisões de
fundação** escondidas dentro dela. Este documento enuncia as duas, com o material
para decidir e uma recomendação. Nenhuma linha de `AppRefreshIndicator` existe no
repositório enquanto elas não forem respondidas.

Por que o componente é desejável, para não perder isso de vista: sem ele, o
adotante que quiser puxar-para-atualizar importa `package:flutter/material.dart`
só por causa do `RefreshIndicator` — e o `architecture_test` barra esse import em
`lib/src`, mas não no app de quem adota. O pacote perde a promessa de ser
suficiente exatamente no gesto mais comum de lista em celular.

---

## Decisão 1 — o pacote ganha uma fábrica de **ação semântica**?

**O problema.** Puxar não tem equivalente de teclado nem de leitor de tela.
Quem navega por leitor não arrasta: precisa de uma ação nomeada no nó da lista
("Atualizar") para disparar o mesmo `onRefresh`. Hoje `AppSemantics` tem 13
fábricas e **nenhuma** delas expressa isso — todas mapeiam para um **papel**
(botão, toggle, campo, cabeçalho, célula…), com o rótulo vindo do call site.

**O que a decisão abre.** Uma fábrica de ação custom é a primeira que aceitaria
um par *rótulo + callback* inventado pelo chamador, em vez de um papel fechado.
Isso muda o que `AppSemantics` é: de vocabulário fechado de papéis para
vocabulário fechado **mais** um saco de ações abertas. O custo não é de código —
é que o `semantics_census_test` deixa de conseguir raciocinar sobre o conjunto:
ele sabe cobrar "todo alvo tocável tem nome", mas não sabe julgar se
`CustomSemanticsAction(label: 'Puxar de novo aí')` é uma ação sensata.

Vale lembrar o que o dartdoc da classe promete hoje: *"para que nenhum
componente monte `Semantics` à mão"*. Uma fábrica genérica de ação custom
cumpre a letra e afrouxa o espírito.

**Quem mais quer isso.** O backlog tem um segundo candidato: `message-meta-acao`
("Reenviar" no rodapé de mensagem falhada), hoje classificado como recusado
justamente por não haver onde pendurar a ação. Se a fábrica nascer genérica, ele
volta à mesa; se nascer fechada, continua fora.

**Recomendação — fechada, não genérica.** Entrar como
`AppSemantics.refreshable({required Widget child, required String label, required VoidCallback onRefresh})`:
um **papel** novo ("esta região pode ser atualizada"), não um saco de ações. O
rótulo continua vindo do call site (é conteúdo, não vocabulário), mas o
significado é do pacote. Se um segundo caso real aparecer — e o `message-meta-acao`
é o candidato natural —, generaliza-se **com dois usuários na mão**, que é a régua
que este repositório usa em outros eixos.

---

## Decisão 2 — a regra da arena de gesto vira gate? Onde?

**A regra.** O indicador tem de **ouvir `ScrollNotification`** e não registrar
reconhecedor de gesto próprio. Um `GestureDetector` vertical em volta de uma
lista disputa a arena com o próprio scrollable e com qualquer gesto dentro dos
itens — e essa disputa não é hipótese: é exatamente o defeito que o `AppSlider`
teve nesta mesma rodada (emitia no `onPanDown`, pré-arena, e um arrasto de
rolagem por cima dele mudava e persistia o valor).

**Precedente no pacote.** Quatro arquivos de `lib/src` já ouvem rolagem por
notificação e nenhum deles registra gesto: `app_scroll_edge_fade.dart`,
`app_tab_view.dart`, `bottom_sheet_engine.dart` e o `app_chat_message_list.dart`
recém-virtualizado. A regra já é praticada — o que não existe é quem a cobre.

**Onde ela mora.** Três saídas, e a escolha tem custo visível:

| Saída | Custo |
|---|---|
| Suíte nova `gesture_arena_test.dart` | Muda o número de suítes de arquitetura, que é **gated** no README (`N suites`) e citado em duas páginas do site. Barato de escrever, caro de manter em prosa. |
| Regra dentro de `architecture_test.dart` | É onde já moram as proibições transversais (import de Material, `AppColors` fora de tokens, `dart.library.html`). Não mexe em contador nenhum. |
| Só teste de comportamento no componente | Prova o caso, não a regra: o próximo componente que puxar rolagem repete o erro sem nada reclamar. |

**Como se prova.** Regra estática sozinha é fraca — "não instancia
`GestureDetector`" passa vazio no dia em que alguém usar `RawGestureDetector`. O
par que prova de verdade é comportamental: (a) arrastar para baixo numa lista
real dispara `onRefresh`; (b) um arrasto **horizontal** dentro de um item **não**
é roubado pelo indicador. O (b) é o teste que o slider não tinha.

**Recomendação — regra em `architecture_test.dart` + o par comportamental no
teste do componente.** A regra estática: arquivo de `lib/src` que consome
`ScrollNotification` não pode instanciar `GestureDetector`/`RawGestureDetector`,
com allowlist nomeada e justificada (o `bottom_sheet_engine` é candidato a
entrada, e a entrada é a documentação do porquê).

---

## Terceiro ponto: não é decisão, é aviso de contrato

A API proposta na spec traz `bool? refreshing` **e**
`Future<void> Function() onRefresh`. São dois donos para o mesmo estado: o host
pode dizer "estou atualizando" enquanto o Future ainda não resolveu, e o
componente fica com duas verdades.

O idioma do pacote nos vizinhos é **controlado** — `AppSlider`, `AppRating` e
`AppNumberStepper` recebem `value` + `onChanged` e não guardam estado de valor.
A escolha coerente é uma das duas, não as duas:

- **Controlado:** `refreshing` (bool) + `onRefresh` como callback puro. O host
  liga e desliga o spinner. Combina com o resto do pacote e com apps que já têm
  estado de carregamento.
- **Não-controlado:** só o `Future`, e o componente segura o spinner até
  resolver. Menos código no call site, e é o idioma que o Material usa.

Recomendação: **controlado**, pelo mesmo motivo dos vizinhos — e porque uma lista
que atualiza costuma ter o estado de carregamento já modelado no app.

---

## O que acontece depois das respostas

Com as duas decididas, a spec do backlog (`flocks-backlog-zapdesk.md`, linhas
1537–1919) pode ser executada como está: ela já cobre física de overscroll,
tokens de motion, o gate de `material.dart` e os critérios de aceite. O trabalho
que sobra é implementação, não desenho.
