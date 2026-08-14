# Backlog de adoção — o registro dos 95

Este arquivo existe para que "o que ficou aberto" não more só na memória de quem
participou. Ele é o estado dos **95 itens** que a migração do ZAPDESK levantou
contra este pacote — cada um com arquivo e linha dos dois lados, no documento de
origem — e o **motivo** de cada recusa.

A régua vale mais que a lista: sete dos oito motivos de recusa são a mesma classe
de fronteira, e responder a pergunta uma vez resolve o grupo inteiro. Ver a Fase G
do [`ROADMAP.md`](../../../ROADMAP.md).

| | |
|---|--:|
| Itens levantados | 95 |
| **Entregues** (2026-08-14) | **32** |
| Abertos, com motivo registrado | 62 |
| Bloqueado por decisão de fundação | 1 |

## Entregues

Um commit por item, agrupados em PRs por família. `git revert` por item continua
possível.

| Item | PR | O que entrou |
|---|:-:|---|
| `DS-A1` | #47 | A `AppChatMessageList` passa a virtualizar de verdade, cumprindo a preguiça que `itemCount`/`itemBuilder` já prometiam. API pública intacta |
| `DS-A2` | #48 (+56) | A sheet sobe com o teclado, e `showHandle` deixa de evaporar em silêncio no ramo não-arrastável — com o par de goldens que prova a diferença |
| `date-picker-clear-null` | #49 | O ✕ dos três picker inputs passa a avisar o chamador (`onCleared`), em vez de limpar por dentro e deixar o app com outro valor |
| `app-image-memory` | #41 | AppImage.memory(Uint8List) — terceiro construtor, para bytes já em memória. |
| `badge-slot-icone` | #51 | Slot de ícone à esquerda do rótulo do badge, como slug de AppIconToken — não como Widget. |
| `avatar-fallback-icone` | #51 | Escolher o ícone de fallback do avatar em vez de receber sempre AppIconToken.user. |
| `action-item-vertical` | #51 | Variante vertical do AppActionItem: ícone acima do rótulo, para grade de opções em folha. |
| `color-picker-presets-only` | #51 | Modo do AppColorPickerPanel que mostra só a paleta de presets, sem área de saturação/brilho, matiz e hex. |
| `segment-tooltip` | #51 | Campo tooltip no AppSegment, para rótulos abreviados explicarem o que são. |
| `list-tile-group-secao` | #52 | O grupo de tiles ganha um rótulo de seção opcional, com o mesmo desenho do título de seção do menu. |
| `tile-info-horizontal` | #52 | O par rótulo/valor ganha layout horizontal e ícone leading, apagando as larguras mágicas espalhadas pelo app. |
| `simple-table-column-widths` | #52 | Largura/peso por coluna no AppSimpleDataTable, hoje sempre repartida em partes iguais. |
| `snackbar-mensagem-unica` | #52 | Toast de uma frase só: title vira opcional e type ganha default info. |
| `snackbar-type-warning` | #52 | Acrescenta o papel âmbar ao snackbar, que já existe no tema e nos dois componentes irmãos. |
| `snackbar-posicao` | #52 | A posição do toast na tela vira parâmetro, escolhida no enum de 8 pontos que já é público. |
| `menu-item-subtitle` | #52 | O item de menu ganha uma segunda linha de texto opcional. |
| `alert-slot-acao` | #52 | O alerta ganha um slot de ação (botão dentro do card) e o botão de dispensar. |
| `alert-max-lines` | #52 | A descrição do alerta deixa de truncar em 3 linhas sem escape. |
| `composer-reply-slot` | #53 | Slot opcional de Widget acima do campo, para a prévia da mensagem sendo respondida. |
| `attachment-card-horizontal` | #53 | Variante de layout em linha (ícone + nome + subtítulo) para o AppChatAttachmentCard, hoje sempre quadrado. |
| `message-meta-time-opcional` | #53 | Torna `time` opcional para usar só o glifo de status (célula de tabela de entrega). |
| `DS-A4` | #54 | activeIcon opcional no item do rail: slug alternativo quando o item está selecionado. |
| `nav-rail-logo-widget` | #54 | Aceitar um Widget como logo do rail, em vez de só slug de ícone (colapsado) e URL de SVG (expandido). |
| `primary-header-bottom` | #54 | Slot opcional abaixo da faixa do AppPrimaryHeader (a barra de filtros que hoje vive no AppBar.bottom do Material). |
| `auth-split-layout` | #54 | Tornar brandTitle/brandSubtitle opcionais e aceitar um Widget de logo, em vez de só logoUrl remoto. |
| `input-text-align-style` | #54 (parcial) | Expor textAlign e o TextStyle do texto digitado no AppInput (caso do código OTP centralizado, 24px, letterSpacing 8). |
| `dialog-content-sem-ilustracao` | #42 | O corpo padrão de diálogo deixa de exigir uma ilustração que o pacote nem embarca. |
| `show-app-confirm` | #42 | Helper de confirmação sim/não sobre showAppDialog, devolvendo Future<bool> que nunca é null. |
| `app-pulse` | #50 | Widget de motion novo: pulso em laço (opacidade/escala respirando) para indicador ao vivo, gravando ou pendente de… |
| `quoted-message` | #50 | Bloco de citação de mensagem (autor + prévia + miniatura), o par que falta no subsistema de chat. |
| `app-slider` | #50 | Slider de valor contínuo/por passo, com rótulo do valor (ritmo de envio de 1 a 60). |
| `choice-chip` | #50 | Chip selecionável com contador — o terceiro chip, o único com estado de escolha. |

## Bloqueado por decisão de fundação

| Item | Estado |
|---|---|
| `refresh-indicator` | O componente **não deve ser escrito** antes de duas decisões: se o pacote ganha fábrica de ação semântica, e onde a regra da arena de gesto vira gate. Enunciado com recomendação em [`DECISOES_PULL_TO_REFRESH.md`](DECISOES_PULL_TO_REFRESH.md) (PR #55) |

## Abertos, por motivo

Nenhum destes é "não faz sentido". São pedidos reais de um app real que esbarram
numa fronteira do pacote — e a fronteira é que precisa de decisão, não o item.


### Cor crua onde o pacote fecha por papel semântico — 10 itens

| Item | O que o app pediu |
|---|---|
| `badge-cor-arbitraria` | AppBadge passaria a aceitar uma cor de conteúdo (texto+borda+tint) vinda de um Color arbitrário do chamador,… |
| `card-fundo-tingido` | AppCard aceita sobrescrever o fundo, hoje sempre surfaceContainer. |
| `card-surface-gradiente` | AppCard/AppSurface aceitariam gradiente (ou decoration) no fundo, para cabeçalho de cartão de preço. |
| `card-surface-selecionado` | Estado 'selecionado' que troca borda e fundo juntos em AppCard/AppSurface. |
| `scaffold-background` | AppScaffold aceitaria cor de fundo, hoje sempre colorTheme.surface. |
| `menu-item-cor` | Cor e fundo por item de menu, para ícones em círculos coloridos por tipo. |
| `action-item-cor` | AppActionItem escolhe o papel de cor da superfície/ícone, hoje sempre tingido de primário. |
| `input-oncolor` | Variante do AppInput desenhada sobre uma superfície colorida (AppBar da marca), com hint/texto/ícone/borda/cursor… |
| `composer-cor-capsula` | Pede background/fillColor no composer para tingir a cápsula inteira (a variante amarela de nota interna). |
| `bubble-color-nota-interna` | Pede um papel de atenção (âmbar) no AppChatBubbleColor, para a bolha de nota interna. |

### Semântica e a11y: move o rótulo do leitor de tela para o call site — 13 itens

| Item | O que o app pediu |
|---|---|
| `avatar-badge-slot` | Slot de selo/overlay sobre o AppAvatar (presença online, botão de editar foto). |
| `badge-anchor` | Componente novo AppBadgeAnchor: ancora um contador/ponto ao canto de um filho qualquer (sino com N, avatar com… |
| `list-tile-widget-slots` | Título e subtítulo do list-tile aceitam Widget composto sem que title deixe de ser String obrigatória. |
| `list-tile-trailing-nos-nomeados` | Permitir um trailing custom nos construtores nomeados, que hoje o fixam em null. |
| `list-tile-radio-trailing` | Slot de trailing no tile de radio, cujo trailing é ocupado pelo próprio radio. |
| `input-helper-widget` | Slot de Widget na linha auxiliar do AppInput, para dica com ícone abaixo do campo. |
| `message-meta-acao` | Pede slot de ação no AppMessageMeta para pendurar 'Reenviar' no estado failed. |
| `dropdown-option-rica` | AppDropdownOption com subtítulo, leading/trailing, enabled e builder de item. |
| `segment-child-widget` | Slot de child Widget no AppSegment, para segmentos com desenho próprio (4 diagramas de layout). |
| `DS-A3` | Pede arrasto entre containers distintos (kanban) — primitivos AppDraggable/AppDragTarget ou um organismo AppBoard. |
| `interaction-long-press-move` | AppInteraction/FlocksInteraction exporiam onLongPressMoveUpdate/onLongPressEnd, para gestos de arrastar-para-cancelar. |
| `swatch-selecionavel` | AppSwatch ganha `selected` + `onTap`, virando amostra de cor escolhível. |
| `otp-input` | Campo de código de verificação: N caixas por dígito, avanço/retrocesso automático, colar do teclado. |

### Muda a identidade do componente (segunda anatomia, contrato novo) — 13 itens

| Item | O que o app pediu |
|---|---|
| `alert-faixa-sem-titulo` | Uma segunda anatomia do alerta: faixa compacta de uma linha, sem título. |
| `list-empty-estado-generico` | Dá ao estado vazio título, ação com rótulo do chamador, ilustração opcional, modo compacto e um papel de erro. |
| `tabela-degrau-do-meio` | Tabela com ordenação e clique na linha, mas sem paginação — o degrau entre as duas que existem. |
| `simple-table-agrupamento` | Cabeçalho de grupo no AppSimpleDataTable (matriz de permissões agrupada por módulo). |
| `funnel-chart` | Gráfico de funil para conversão entre etapas do CRM. |
| `bar-chart-cor-por-ponto` | Cor por ponto no AppBarChart (opacidade proporcional ao volume, barra cinza para hora sem movimento). |
| `data-bar-row` | Barra proporcional em linha com rótulo e valor (etapa do funil, indicador de uso). |
| `stat-card` | Tile de KPI: ícone + rótulo + valor + legenda, com papel de cor semântica. |
| `split-responsivo` | Pede que o AppResizableSplit colapse para um painel só abaixo de um breakpoint, em vez de o app envolvê-lo num… |
| `chat-list-scroll-to-index` | Pede scrollToIndex/ensureVisible na lista de mensagens, para pular até a mensagem citada. |
| `dropdown-on-create-option` | Rodapé de 'criar nova opção' no dropdown com busca, quando o texto não casa com nada. |
| `campo-repetivel` | Lista dinâmica de campos com adicionar/remover/reordenar (1 a 3 botões de template, linhas de opção). |
| `app-form-validator` | Pluga AppInput/AppDropdown no contrato Form/FormField de widgets.dart e cria AppForm + AppFormController. |

### Eixo global ou contrato de tema — 10 itens

| Item | O que o app pediu |
|---|---|
| `text-theme-overline` | Um 16º papel tipográfico (overline: caixa alta, letterSpacing positivo) no AppTextTheme. |
| `theme-extensions` | Slot `extensions` em AppThemeData/AppColorTheme para o app pendurar tokens próprios no tema do DS. |
| `icon-token-slugs` | Aumentar o contrato garantido de ícones de 55 para 69 slugs, mais um `fallback` no AppAssetIconProvider para o que… |
| `ilustracoes-empacotadas` | Fechar a distância entre os 12 slugs anunciados e a 1 ilustração realmente empacotada, subindo o contrato de 1… |
| `inline-edit` | Campo sem moldura que vira editável no clique (renomear campanha, editar título de etapa). |
| `nav-rail-item-barra` | Pede uma variante de indicador de seleção em barra lateral (3px na cor da marca), no lugar da pílula tingida. |
| `segmented-rolagem-contador` | Rolagem horizontal e badge de contagem no AppSegmentedButton (barra de filtros com quantos esperam na fila). |
| `menu-abertura-por-offset` | Abrir o menu no ponto do cursor em vez de ancorado no trigger. |
| `nav-rail-flyout` | Pede que grupo com children abra em flyout ancorado, em vez do accordion push-down de hoje. |
| `shortcuts-scope-bindings` | Pede um mapa aberto de atalhos extras no AppShortcutsScope, hoje limitado aos callbacks fixos do shell. |

### Plugin nativo, asset licenciado ou política de locale — 5 itens

| Item | O que o app pediu |
|---|---|
| `file-field-upload` | Campo de upload com seletor de arquivo, dropzone e progresso. |
| `audio-player` | Pede um AppAudioPlayer (mensagem de voz) no catálogo. |
| `emoji-picker` | Pede uma grade de emojis (AppEmojiPicker) no pacote. |
| `composer-push-to-talk` | Pede botão de microfone, modo gravação, arrastar-para-cancelar e cadeado dentro do AppChatComposer. |
| `input-formatters-br` | Empacotar no flocks os formatters de telefone BR, CPF/CNPJ, CEP e moeda. |

### Estado "selecionado" pedindo par de cores novo — 3 itens

| Item | O que o app pediu |
|---|---|
| `badge-selected` | Realce persistente de badge escolhido (`selected`), além do read-only x interativo que existe hoje. |
| `button-selected` | AppButton ganharia estado ativo (`selected`) para botão de alternância. |
| `list-tile-selected` | Expor o estado selecionado do tile para destacar o item ativo em layouts mestre-detalhe. |

### Exportação de interno (a decisão já está escrita no fonte) — 3 itens

| Item | O que o app pediu |
|---|---|
| `export-button-variant-text` | Exportar button_core.dart no barril para o app alcançar ButtonVariant.text (ação terciária). |
| `export-field-label` | Exportar appFieldLabel (rótulo + popover de info) no barril de input. |
| `export-surface-top-bar` | Exportar a barra de topo compartilhada das superfícies flutuantes no barril de headers. |

### Peça de produto, não vocabulário de design system — 5 itens

| Item | O que o app pediu |
|---|---|
| `pane-grid` | Pede um AppPaneGrid novo, com grade configurável de 1 a 4 painéis. |
| `image-viewer` | Lightbox de tela cheia com zoom/pan e cabeçalho de fechar sobre uma imagem. |
| `async-view` | Wrapper que despacha carregando/vazio/erro/conteúdo numa peça só. |
| `message-status-replied` | Pede o valor `replied` no enum AppMessageStatus. |
| `button-onpressed-null` | Desacoplar o visual habilitado do botão da existência do callback, para que onPressed null não pinte desabilitado. |

## Como usar isto

- **Antes de reabrir um item**, leia o motivo: vários voltam à mesa só depois de
  uma decisão de eixo, e reabri-los isolados repete a discussão.
- **O grupo mais rentável é o primeiro.** Dez itens perguntam a mesma coisa —
  "posso passar um `Color`?" — e a resposta já existe em forma parcial no
  `badge-cor-arbitraria`: `seed` normalizado em vez de fill cru. Decidida uma vez,
  ela fecha os dez.
- **O grupo mais barato é o das exportações.** São três linhas de barril; o que
  falta não é trabalho, é confirmar (ou reverter) a decisão que o próprio fonte já
  registra em `@internal`.
- **Item derrubado por reverificação também fecha aqui**, com o porquê — fechado é
  entregue **ou** recusado com registro, nunca esquecido.

O documento de origem, com a evidência item a item, é
`flocks-backlog-zapdesk.md` (fora deste repo: ele descreve um app cliente).

