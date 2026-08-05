import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppApiMethodBadge]. Registrado em `flocksCatalog`.
const AppComponentMeta appApiMethodBadgeMeta = AppComponentMeta(
  id: 'app_api_method_badge',
  name: 'AppApiMethodBadge',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@1.4.0',
  summary: LocalizedText(
    en: 'HTTP verb pill, tinted by the method\'s semantic role.',
    pt: 'Pílula do verbo HTTP, tingida pelo papel semântico do método.',
  ),
  description: LocalizedText(
    en: 'A thin shell over AppBadge: uppercase, a color role per verb (GET info, POST success, PUT/PATCH warning, DELETE danger) and, by default, a fixed-width column so the paths in a list all start at the same abscissa.',
    pt:
        'Casca fina sobre o AppBadge: caixa alta, papel de cor por verbo (GET '
        'info, POST success, PUT/PATCH warning, DELETE danger) e, por padrão, uma '
        'coluna de largura fixa para os paths de uma lista começarem na mesma '
        'abscissa.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The header of an endpoint in a documentation list.',
      'A reference to a call inside a flow step.',
    ],
    pt: <String>[
      'Cabeçalho de um endpoint numa lista de documentação.',
      'Referência a uma chamada dentro de um passo de fluxo.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A response status (2xx/4xx) → AppBadge with the appropriate role.',
    ],
    pt: <String>[
      'Status de uma resposta (2xx/4xx) → AppBadge com o papel adequado.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'method',
      type: 'AppApiMethod',
      isRequired: true,
      enumValues: <String>[
        'get',
        'post',
        'put',
        'patch',
        'delete',
        'head',
        'options',
      ],
    ),
    PropMeta(
      name: 'size',
      type: 'AppBadgeSize',
      defaultValue: 'AppBadgeSize.s',
      enumValues: <String>['s', 'm', 'l', 'xl'],
    ),
    PropMeta(
      name: 'width',
      type: 'double?',
      defaultValue: 'kAppApiMethodBadgeWidth',
      description: LocalizedText(
        en: 'null = the pill\'s natural width.',
        pt: 'null = largura natural da pílula.',
      ),
    ),
  ],
  variants: <String>[
    'get',
    'post',
    'put',
    'patch',
    'delete',
    'head',
    'options',
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Verb', pt: 'Verbo'),
      code: 'AppApiMethodBadge(AppApiMethod.post)',
    ),
    CodeExample(
      title: LocalizedText(en: 'Natural width', pt: 'Largura natural'),
      code: 'AppApiMethodBadge(AppApiMethod.get, width: null)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Keep the default width in lists — it is what aligns the paths.',
    ],
    pt: <String>[
      'Mantenha a largura padrão em listas — é o que alinha os paths.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not recolor it from outside: the color IS the verb\'s information.',
    ],
    pt: <String>['Não recolora por fora: a cor É a informação do verbo.'],
  ),
  a11y: LocalizedText(
    en: 'Inherits AppBadge\'s single labelled node; the verb is read in uppercase.',
    pt: 'Herda o nó rotulado único do AppBadge; o verbo é lido em caixa alta.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_badge', 'app_api_endpoint_tile'],
);

/// Descritor MCP do [AppApiPath]. Registrado em `flocksCatalog`.
const AppComponentMeta appApiPathMeta = AppComponentMeta(
  id: 'app_api_path',
  name: 'AppApiPath',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@1.4.0',
  summary: LocalizedText(
    en: 'Endpoint path in mono, with the placeholders highlighted.',
    pt: 'Path de endpoint em mono, com os placeholders destacados.',
  ),
  description: LocalizedText(
    en: 'The segments in braces take the primary accent and a heavier weight — they are what the reader has to substitute, and highlighting them keeps {id} from being read as a literal part of the path. It uses AppContentStyle\'s mono family, so the path looks identical to the same path inside an AppCodeBlock.',
    pt:
        'Os segmentos entre chaves recebem o acento primário e peso maior — é o '
        'que o leitor precisa substituir, e destacá-los evita ler {id} como parte '
        'literal do path. Usa a família mono da AppContentStyle, então o path '
        'fica idêntico ao mesmo path dentro de um AppCodeBlock.',
  ),
  whenToUse: LocalizedList(
    en: <String>['The header of an endpoint; the line of a flow step.'],
    pt: <String>['Cabeçalho de um endpoint; linha de um passo de fluxo.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A clickable navigation URL → AppRichText with a link.'],
    pt: <String>['URL clicável de navegação → AppRichText com link.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'path', type: 'String', isRequired: true),
    PropMeta(
      name: 'prefix',
      type: 'String?',
      description: LocalizedText(
        en: 'Base shown before the path, dimmed.',
        pt: 'Base mostrada antes do path, esmaecida.',
      ),
    ),
    PropMeta(name: 'style', type: 'TextStyle?'),
    PropMeta(name: 'maxLines', type: 'int?', defaultValue: '1'),
    PropMeta(
      name: 'overflow',
      type: 'TextOverflow',
      defaultValue: 'TextOverflow.ellipsis',
    ),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Path', pt: 'Path'),
      code: "AppApiPath('/devices/{id}')",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Pass the prefix when the base URL matters for copy-and-paste.',
    ],
    pt: <String>[
      'Passe o prefix quando a base URL importar para copiar/colar.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not escape the braces: they are the highlight.'],
    pt: <String>['Não escape as chaves: elas são o destaque.'],
  ),
  a11y: LocalizedText(
    en: 'Exposes the full path (prefix included) as the semantic label.',
    pt: 'Expõe o path completo (prefixo incluído) como rótulo semântico.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_code_block', 'app_api_method_badge'],
);

/// Descritor MCP do [AppApiParamTable]. Registrado em `flocksCatalog`.
const AppComponentMeta appApiParamTableMeta = AppComponentMeta(
  id: 'app_api_param_table',
  name: 'AppApiParamTable',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@1.4.0',
  summary: LocalizedText(
    en: 'Request parameter table built on AppSimpleDataTable.',
    pt: 'Tabela de parâmetros de requisição sobre o AppSimpleDataTable.',
  ),
  description: LocalizedText(
    en: 'Columns Parameter / In / Type / Description. Name and type in mono; "In" and "required" as badges. No sorting and no pagination: the list is short and the order comes from the specification. It renders empty when there are no parameters, so the call site can include it without a conditional.',
    pt:
        'Colunas Parâmetro / Em / Tipo / Descrição. Nome e tipo em mono; "Em" e '
        '"obrigatório" como badges. Sem ordenação nem paginação: a lista é curta '
        'e a ordem vem da especificação. Renderiza vazio quando não há '
        'parâmetros, para o call site incluir sem condicional.',
  ),
  whenToUse: LocalizedList(
    en: <String>['The body of an endpoint card.'],
    pt: <String>['Corpo de um cartão de endpoint.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A nested body schema → AppApiSchemaTree.'],
    pt: <String>['Schema de corpo com aninhamento → AppApiSchemaTree.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'params', type: 'List<AppApiParam>', isRequired: true),
    PropMeta(name: 'showLocation', type: 'bool', defaultValue: 'true'),
  ],
  states: <String>['default', 'empty'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Query', pt: 'Query'),
      code: 'AppApiParamTable(endpoint.params)',
    ),
  ],
  dos: LocalizedList(
    en: <String>['Pass the parameters in the specification\'s order.'],
    pt: <String>['Passe os parâmetros na ordem da especificação.'],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not use it for the body: a nested body does not fit in a table.',
    ],
    pt: <String>['Não use para o corpo: um body aninhado não cabe em tabela.'],
  ),
  a11y: LocalizedText(
    en: 'Inherits AppSimpleDataTable\'s table semantics and selection.',
    pt: 'Herda a semântica de tabela e a seleção do AppSimpleDataTable.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_simple_data_table', 'app_api_schema_tree'],
);

/// Descritor MCP do [AppApiSchemaTree]. Registrado em `flocksCatalog`.
const AppComponentMeta appApiSchemaTreeMeta = AppComponentMeta(
  id: 'app_api_schema_tree',
  name: 'AppApiSchemaTree',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@1.4.0',
  summary: LocalizedText(
    en: 'Field tree for a schema, with nodes that open level by level.',
    pt: 'Árvore de campos de um schema, com nós abríveis por nível.',
  ),
  description: LocalizedText(
    en: 'Each row is name · type · required · description; fields with subfields become openable nodes (AppExpand). It starts open only down to initiallyExpandedDepth — keeping the deep levels closed is what stops a real schema (pagination + entity + relationships) from becoming a wall of text. The chevron occupies the same box on leaves, so the names do not dance horizontally.',
    pt:
        'Cada linha é nome · tipo · obrigatório · descrição; campos com subcampos '
        'viram nós abríveis (AppExpand). Nasce aberta só até '
        'initiallyExpandedDepth — manter os níveis fundos fechados é o que impede '
        'um schema real (paginação + entidade + relacionamentos) de virar parede '
        'de texto. O chevron ocupa a mesma caixa em folhas, para os nomes não '
        'dançarem na horizontal.',
  ),
  whenToUse: LocalizedList(
    en: <String>['An endpoint\'s request body and response body.'],
    pt: <String>['Corpo de requisição e corpo de resposta de um endpoint.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>['A flat list of parameters → AppApiParamTable.'],
    pt: <String>['Lista plana de parâmetros → AppApiParamTable.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'fields', type: 'List<AppApiField>', isRequired: true),
    PropMeta(
      name: 'initiallyExpandedDepth',
      type: 'int',
      defaultValue: '1',
      description: LocalizedText(
        en: 'Depth (0-based) down to which nodes start open.',
        pt: 'Profundidade (0-based) até a qual os nós nascem abertos.',
      ),
    ),
  ],
  states: <String>['collapsed', 'expanded', 'empty'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Request body', pt: 'Corpo da requisição'),
      code: 'AppApiSchemaTree(endpoint.requestFields)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Cut cycles and impose a depth ceiling BEFORE building the tree.',
    ],
    pt: <String>[
      'Corte ciclos e imponha teto de profundidade ANTES de montar a árvore.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not open everything by default: a real schema has dozens of fields.',
    ],
    pt: <String>[
      'Não abra tudo por padrão: o schema real tem dezenas de campos.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Nodes with children become buttons (AppSemantics.button) activatable by keyboard; leaves stay as selectable text.',
    pt:
        'Nós com filhos viram botões (AppSemantics.button) ativáveis por teclado; '
        'folhas ficam como texto selecionável.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_api_param_table', 'app_expansion_tile'],
);

/// Descritor MCP do [AppApiEndpointTile]. Registrado em `flocksCatalog`.
const AppComponentMeta appApiEndpointTileMeta = AppComponentMeta(
  id: 'app_api_endpoint_tile',
  name: 'AppApiEndpointTile',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@1.4.0',
  summary: LocalizedText(
    en: 'Collapsible endpoint card: verb, path, params, responses.',
    pt: 'Cartão colapsável de um endpoint: verbo, path, params, respostas.',
  ),
  description: LocalizedText(
    en: 'A header with the verb pill, the path in mono, a summary and copy-path; a body with authentication, tags, parameters, the request schema, the responses and a sample curl. Built on FlocksInteraction + AppExpand + AppAnimatedRotation (the same primitives as AppExpansionTile) because that one only accepts a String title and here the header is composed. Read-only: the curl carries a credential placeholder, never the session token.',
    pt:
        'Cabeçalho com pílula do verbo, path em mono, resumo e copiar-path; '
        'corpo com autenticação, tags, parâmetros, schema de requisição, '
        'respostas e um curl de exemplo. Construído sobre FlocksInteraction + '
        'AppExpand + AppAnimatedRotation (as mesmas primitivas do '
        'AppExpansionTile) porque aquele só aceita título String e aqui o '
        'cabeçalho é composto. Somente leitura: o curl traz placeholder de '
        'credencial, nunca o token da sessão.',
  ),
  whenToUse: LocalizedList(
    en: <String>['Listing the endpoints of a screen\'s context.'],
    pt: <String>['Listar os endpoints de um contexto de tela.'],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Executing the call — this component fires no request at all.',
    ],
    pt: <String>[
      'Executar a chamada — este componente não dispara request nenhum.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'endpoint', type: 'AppApiEndpoint', isRequired: true),
    PropMeta(name: 'baseUrl', type: 'String?'),
    PropMeta(name: 'initiallyExpanded', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'onExpansionChanged', type: 'ValueChanged<bool>?'),
    PropMeta(name: 'showCopyPath', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'style', type: 'AppStyle?'),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
  ],
  states: <String>['collapsed', 'expanded', 'hovered', 'focused'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Card', pt: 'Cartão'),
      code: 'AppApiEndpointTile(endpoint: e, baseUrl: doc.baseUrl)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Use the GlobalKey<AppApiEndpointTileState> to open a card from outside.',
    ],
    pt: <String>[
      'Use a GlobalKey<AppApiEndpointTileState> para abrir um cartão de fora.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Never put a real credential in the curl.'],
    pt: <String>['Nunca coloque credencial real no curl.'],
  ),
  a11y: LocalizedText(
    en: 'The header is a button (AppSemantics.button) labelled with the verb, the path and the summary, activatable by keyboard and with a focus ring.',
    pt:
        'O cabeçalho é um botão (AppSemantics.button) rotulado com verbo, path e '
        'resumo, ativável por teclado e com anel de foco.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_api_method_badge',
    'app_api_schema_tree',
    'app_code_block',
  ],
);

/// Descritor MCP do [AppApiFlow]. Registrado em `flocksCatalog`.
const AppComponentMeta appApiFlowMeta = AppComponentMeta(
  id: 'app_api_flow',
  name: 'AppApiFlow',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@1.4.0',
  summary: LocalizedText(
    en: 'A business flow as a numbered vertical timeline of calls.',
    pt: 'Fluxo de negócio como timeline vertical numerada de chamadas.',
  ),
  description: LocalizedText(
    en: 'It answers what the endpoint list does not: in what ORDER. Each step has a number, what the step does and — when it is a call — the verb + path line, clickable to reach the endpoint\'s card. The connector grows with the step\'s real height (IntrinsicHeight), otherwise steps of differing heights would leave gaps in the line.',
    pt:
        'Responde ao que a lista de endpoints não responde: em que ORDEM. Cada '
        'passo tem número, o que a etapa faz e — quando é uma chamada — a linha '
        'verbo + path, clicável para levar ao cartão do endpoint. O conector '
        'cresce com a altura real do passo (IntrinsicHeight), senão passos de '
        'alturas diferentes deixariam buracos na linha.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A required sequence of calls (register → associate → activate).',
    ],
    pt: <String>[
      'Sequência obrigatória de chamadas (cadastrar → associar → ativar).',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A form wizard in the application → AppStepper.',
      'A list of endpoints with no order between them → just the panel\'s groups.',
    ],
    pt: <String>[
      'Wizard de formulário na aplicação → AppStepper.',
      'Lista de endpoints sem ordem entre si → apenas os grupos do painel.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'flow', type: 'AppApiFlowData', isRequired: true),
    PropMeta(name: 'onStepTap', type: 'ValueChanged<AppApiFlowStep>?'),
    PropMeta(name: 'style', type: 'AppStyle?'),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Navigable timeline', pt: 'Timeline navegável'),
      code: 'AppApiFlow(flow: doc.flows.first, onStepTap: panel.reveal)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Write the step by its business effect, not by the HTTP verb.',
    ],
    pt: <String>[
      'Escreva o passo pelo efeito de negócio, não pelo verbo HTTP.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not repeat the endpoint\'s full documentation here.'],
    pt: <String>['Não repita aqui a documentação inteira do endpoint.'],
  ),
  a11y: LocalizedText(
    en: 'The verb + path line becomes a labelled AppInteraction ("See the … endpoint"), keyboard-focusable. The numbers are text, not color alone.',
    pt:
        'A linha verbo + path vira um AppInteraction rotulado ("Ver o endpoint …"), '
        'focável por teclado. Os números são texto, não só cor.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_api_docs_panel', 'app_stepper'],
);

/// Descritor MCP do [AppApiDocsPanel]. Registrado em `flocksCatalog`.
const AppComponentMeta appApiDocsPanelMeta = AppComponentMeta(
  id: 'app_api_docs_panel',
  name: 'AppApiDocsPanel',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@1.4.0',
  summary: LocalizedText(
    en: 'API documentation in the context of one screen, in a single flow.',
    pt: 'Documentação da API no contexto de uma tela, num só fluxo.',
  ),
  description: LocalizedText(
    en: 'A header (title, context, copyable base URL, a link to the full reference), search, business flows and endpoint groups. Tapping a flow step OPENS and SCROLLS to the endpoint\'s card — that is what stitches the narrative ("in what order") to the reference ("what each one does"). It does not scroll on its own: the sheet\'s contract is that the surface owns the scrolling. Purely presentational — it takes an already-resolved AppApiDoc and makes no network calls.',
    pt:
        'Cabeçalho (título, contexto, base URL copiável, link para a referência '
        'completa), busca, fluxos de negócio e grupos de endpoints. Tocar um '
        'passo de fluxo ABRE e ROLA até o cartão do endpoint — é o que costura a '
        'narrativa ("em que ordem") à referência ("o que cada um faz"). Não rola '
        'sozinho: o contrato do sheet é que a superfície cuida da rolagem. Puro '
        'de apresentação — recebe um AppApiDoc já resolvido e não faz rede.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The content of a screen\'s "API documentation" bottom/side sheet.',
    ],
    pt: <String>[
      'Conteúdo do bottom/side sheet de "documentação da API" de uma tela.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'The complete reference for the whole API → Swagger UI.',
      'Loading and error states: they belong to the host, not to the panel.',
    ],
    pt: <String>[
      'Referência completa da API inteira → Swagger UI.',
      'Estados de carregamento/erro: são do host, não do painel.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'doc', type: 'AppApiDoc', isRequired: true),
    PropMeta(name: 'onOpenExternal', type: 'VoidCallback?'),
    PropMeta(name: 'showSearch', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'searchHint', type: 'String'),
    PropMeta(name: 'emptyText', type: 'String'),
  ],
  states: <String>['default', 'filtered', 'empty'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'In the bottom sheet', pt: 'No bottom sheet'),
      code:
          'showAppBottomSheet(context: context, draggable: true, '
          'child: AppApiDocsPanel(doc: doc))',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Wrap it in a scroll when using it outside a sheet.',
      'Pass the base URL: it is what makes copy-path pasteable.',
    ],
    pt: <String>[
      'Embrulhe num scroll quando usar fora de um sheet.',
      'Passe a base URL: é o que torna o copiar-path colável.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not put the panel inside another scroll within the sheet.',
    ],
    pt: <String>[
      'Não coloque o painel dentro de outro scroll dentro do sheet.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Search is a labelled AppInput; each card is a focusable button; the copy chips expose their own semantic label.',
    pt:
        'Busca é um AppInput rotulado; cada cartão é um botão focável; os chips '
        'de copiar expõem rótulo semântico próprio.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_api_endpoint_tile',
    'app_api_flow',
    'app_bottom_sheet',
  ],
);

/// Descritor MCP do [AppEntityDocPanel]. Registrado em `flocksCatalog`.
const AppComponentMeta appEntityDocPanelMeta = AppComponentMeta(
  id: 'app_entity_doc_panel',
  name: 'AppEntityDocPanel',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@1.4.0',
  summary: LocalizedText(
    en: 'Conceptual documentation for an entity: what it is, what it relates to and who exchanges data with it.',
    pt:
        'Documentação conceitual de uma entidade: o que é, com quem se '
        'relaciona e quem troca dados com ela.',
  ),
  description: LocalizedText(
    en: 'The half the API reference does not cover. Free prose (the overview and the sections) comes in as Markdown, because lifecycle and business rules do not fit a fixed structure; relationships and integrations are structured as cards, because they are what the reader scans. Cardinality (1 → N) and the direction of an integration (receives/sends) come out as a label, not as color alone. It does not scroll on its own — the host provides the scroll.',
    pt:
        'A metade que a referência de API não cobre. Prosa livre (overview e '
        'seções) entra como Markdown, porque ciclo de vida e regra de negócio não '
        'cabem numa estrutura fixa; relações e integrações são estruturadas em '
        'cartões, porque são o que o leitor varre com o olho. Cardinalidade '
        '(1 → N) e sentido da integração (recebe/envia) saem como rótulo, não só '
        'como cor. Não rola sozinho — quem hospeda dá o scroll.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The left column of AppDocsWorkspace.',
      'Explaining a domain entity to whoever is going to integrate with it.',
    ],
    pt: <String>[
      'Coluna esquerda do AppDocsWorkspace.',
      'Explicar uma entidade do domínio para quem vai integrar com ela.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'An endpoint signature → AppApiDocsPanel.',
      'A free document with no entity structure → AppMarkdown directly.',
    ],
    pt: <String>[
      'Assinatura de endpoint → AppApiDocsPanel.',
      'Documento livre sem estrutura de entidade → AppMarkdown direto.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'doc', type: 'AppEntityDoc', isRequired: true),
    PropMeta(name: 'showHeader', type: 'bool', defaultValue: 'true'),
    PropMeta(
      name: 'relationsTitle',
      type: 'String',
      defaultValue: "'Relações'",
    ),
    PropMeta(
      name: 'integrationsTitle',
      type: 'String',
      defaultValue: "'Integrações'",
    ),
    PropMeta(name: 'onTapLink', type: 'void Function(String)?'),
  ],
  states: <String>['default', 'empty'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Concept column', pt: 'Coluna de conceito'),
      code: 'AppEntityDocPanel(doc: entity, showHeader: false)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Write the relationship by its business effect, not by the foreign key.',
    ],
    pt: <String>[
      'Escreva a relação pelo efeito de negócio, não pela chave estrangeira.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not repeat the endpoint\'s signature here: the column beside it already has it.',
    ],
    pt: <String>[
      'Não repita aqui a assinatura do endpoint: a coluna ao lado já a tem.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Cardinality and direction are text inside the AppBadge, so a screen reader and a colorblind reader get the same information the color carries.',
    pt:
        'Cardinalidade e sentido são texto dentro do AppBadge, então leitor de '
        'tela e daltônico recebem a mesma informação que a cor carrega.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_docs_workspace', 'app_markdown', 'app_api_docs_panel'],
);

/// Descritor MCP do [AppDocsWorkspace]. Registrado em `flocksCatalog`.
const AppComponentMeta appDocsWorkspaceMeta = AppComponentMeta(
  id: 'app_docs_workspace',
  name: 'AppDocsWorkspace',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@1.4.0',
  summary: LocalizedText(
    en: 'Documentation for one context in two columns: concept and API.',
    pt: 'Documentação de um contexto em duas colunas: conceito e API.',
  ),
  description: LocalizedText(
    en: 'The two halves answer different questions and the reader switches between them constantly ("what is a device?" and "how do I create one?"). Side by side, switching is eye movement; stacked, it would be scrolling. The divider is draggable (AppResizableSplit) and each column scrolls on its own, so reading a schema does not make the explanation disappear. Below kAppDocsWorkspaceStackBelow the columns stack into a single scroll. It requires a bounded height — which is what an AppSideSheet body provides.',
    pt:
        'As duas metades respondem perguntas diferentes e o leitor alterna entre '
        'elas o tempo todo ("o que é um dispositivo?" e "como eu crio um?"). Lado '
        'a lado, a alternância é o movimento dos olhos; empilhadas, seria scroll. '
        'A divisória é arrastável (AppResizableSplit) e cada coluna rola sozinha, '
        'para que ler um schema não faça a explicação sumir. Abaixo de '
        'kAppDocsWorkspaceStackBelow as colunas empilham num scroll único. Exige '
        'altura limitada — é o que o corpo de um AppSideSheet dá.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'The body of a screen\'s documentation side sheet, at the full snap.',
    ],
    pt: <String>[
      'Corpo do side sheet de documentação de uma tela, no snap full.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Inside a vertical scroll: the component needs a bounded height.',
      'Endpoints only, with no concept → AppApiDocsPanel directly.',
    ],
    pt: <String>[
      'Dentro de um scroll vertical: o componente precisa de altura limitada.',
      'Só endpoints, sem conceito → AppApiDocsPanel direto.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'entity',
      type: 'AppEntityDoc?',
      isRequired: true,
      description: LocalizedText(
        en: 'null hides the left column; the API takes everything.',
        pt: 'null esconde a coluna esquerda; a API ocupa tudo.',
      ),
    ),
    PropMeta(name: 'api', type: 'AppApiDoc', isRequired: true),
    PropMeta(
      name: 'entityTitle',
      type: 'String',
      defaultValue: "'Documentação'",
    ),
    PropMeta(name: 'apiTitle', type: 'String', defaultValue: "'API'"),
    PropMeta(name: 'onOpenEntityDocs', type: 'VoidCallback?'),
    PropMeta(name: 'onOpenApiDocs', type: 'VoidCallback?'),
    PropMeta(
      name: 'initialFirstFraction',
      type: 'double',
      defaultValue: '0.45',
      description: LocalizedText(
        en: 'Smaller than half: the API column carries tables and code.',
        pt: 'Menor que a metade: a coluna de API carrega tabelas e código.',
      ),
    ),
    PropMeta(name: 'onTapLink', type: 'void Function(String)?'),
  ],
  states: <String>['split', 'stacked', 'api-only'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'In the wide side sheet',
        pt: 'No side sheet largo',
      ),
      code:
          'showAppSideSheet(context: context, draggable: true, '
          'initialSnap: AppSideSheetSnap.full, '
          'child: AppDocsWorkspace(entity: e, api: a))',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Open it at the full snap: two columns do not fit in the resting snap.',
      'Give it both external links — the panel is an excerpt, not the source.',
    ],
    pt: <String>[
      'Abra no snap full: duas colunas não cabem no snap de repouso.',
      'Dê os dois links externos — o painel é um recorte, não a fonte.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not nest it in a vertical scroll; the height has to come from outside.',
    ],
    pt: <String>[
      'Não aninhe num scroll vertical; a altura tem que vir de fora.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Each column has its own header outside the scroll, so the position in the document is never lost. External links expose a semantic label.',
    pt:
        'Cada coluna tem cabeçalho próprio fora do scroll, então a posição no '
        'documento nunca se perde. Os links externos expõem rótulo semântico.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>[
    'app_entity_doc_panel',
    'app_api_docs_panel',
    'app_resizable_split',
    'app_side_sheet',
  ],
);
