import '../../meta/app_component_meta.dart';

/// Descritor MCP do [AppMarkdown]. Registrado em `flocksCatalog`.
const AppComponentMeta appMarkdownMeta = AppComponentMeta(
  id: 'app_markdown',
  name: 'AppMarkdown',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Renders Markdown (GFM) with the theme\'s tokens, without Material.',
    pt: 'Renderiza Markdown (GFM) com os tokens do tema, sem Material.',
  ),
  description: LocalizedText(
    en: 'It reads package:markdown\'s AST and draws with Text.rich over widgets.dart — no Material and no flutter_html. Headings come from the type scale, tables from AppSimpleDataTable and images from AppImage. The whole document sits in a single AppSelectionRegion, so selection crosses blocks. Embedded raw HTML is rendered as literal text, never interpreted.',
    pt:
        'Lê a AST do package:markdown e desenha com Text.rich sobre widgets.dart '
        '— sem Material e sem flutter_html. Headings saem da escala tipográfica, '
        'tabelas do AppSimpleDataTable e imagens do AppImage. O documento inteiro '
        'fica numa única AppSelectionRegion, então a seleção atravessa blocos. '
        'HTML cru embutido é renderizado como texto literal, nunca interpretado.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'AI assistant replies (prose, code, tables) in the chat.',
      'Any rich content the application already produces as Markdown.',
    ],
    pt: <String>[
      'Respostas do assistente de IA (prosa, código, tabelas) no chat.',
      'Qualquer conteúdo rico que a aplicação já produza em Markdown.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Content that arrives as HTML from the backend → AppHtml.',
      'Single-style text → AppText; a few inline fragments → AppRichText.',
    ],
    pt: <String>[
      'Conteúdo que chega em HTML do backend → AppHtml.',
      'Texto de um único estilo → AppText; poucos trechos inline → AppRichText.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'data', type: 'String', isRequired: true),
    PropMeta(name: 'style', type: 'TextStyle?'),
    PropMeta(name: 'textColor', type: 'Color?'),
    PropMeta(name: 'styleSheet', type: 'AppContentStyle?'),
    PropMeta(name: 'onTapLink', type: 'void Function(String)?'),
    PropMeta(name: 'selectable', type: 'bool'),
  ],
  states: <String>['default', 'empty', 'streaming'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Assistant message',
        pt: 'Mensagem do assistente',
      ),
      code:
          'AppMarkdown(data: message.text, '
          'textColor: theme.colorTheme.onSurface)',
    ),
    CodeExample(
      title: LocalizedText(
        en: 'Link routed by the application',
        pt: 'Link roteado pela aplicação',
      ),
      code:
          'AppMarkdown(data: doc, onTapLink: (String href) => context.go(href))',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Leave the horizontal scroll to the call site when there is a wide table or code block — the component does not scroll on its own.',
      'Pass onTapLink to route internally; without it the link opens in the external browser.',
    ],
    pt: <String>[
      'Deixe o scroll horizontal no call site quando houver tabela ou código '
          'largo — o componente não rola sozinho.',
      'Passe onTapLink para rotear internamente; sem ele o link abre no '
          'navegador externo.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not convert Markdown to HTML before rendering: the component reads the AST directly, and the detour through HTML loses structure.',
    ],
    pt: <String>[
      'Não converta Markdown para HTML antes de renderizar: o componente lê a '
          'AST direto, e o desvio por HTML perde estrutura.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Text is selectable through AppSelectionRegion; images use the alt as their semantic label. Links are tappable but not yet Tab-focusable (Gate 7 debt). Colors come from the theme and pass AA in light and dark.',
    pt:
        'Texto selecionável via AppSelectionRegion; imagens usam o alt como '
        'rótulo semântico. Links são tocáveis mas ainda não focáveis por Tab '
        '(pendência Gate 7). Cores saem do tema e passam AA em claro/escuro.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_html', 'app_rich_text', 'app_simple_data_table'],
);

/// Descritor MCP do [AppHtml]. Registrado em `flocksCatalog`.
const AppComponentMeta appHtmlMeta = AppComponentMeta(
  id: 'app_html',
  name: 'AppHtml',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Renders a safe subset of HTML with the theme\'s tokens.',
    pt: 'Renderiza um subconjunto seguro de HTML com os tokens do tema.',
  ),
  description: LocalizedText(
    en: 'It parses with package:html (pure Dart) and shares AppMarkdown\'s renderer, so the same document looks identical through either path. It is not a browser: it covers a deliberate subset of tags and does not interpret CSS. It treats the input as untrusted — it drops script/style/iframe/form along with their subtrees, validates the href/src scheme (javascript: and data: are blocked) and degrades an unknown tag to its own children, preserving the text.',
    pt:
        'Parseia com o package:html (Dart puro) e compartilha o renderer do '
        'AppMarkdown, de modo que o mesmo documento fica visualmente idêntico nos '
        'dois caminhos. Não é um navegador: cobre um subconjunto deliberado de '
        'tags e não interpreta CSS. Trata a entrada como não confiável — descarta '
        'script/style/iframe/form com a subárvore, valida o esquema de href/src '
        '(javascript: e data: são bloqueados) e degrada tag desconhecida para os '
        'próprios filhos, preservando o texto.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Terms of use, privacy policies and legal notices coming from the backend.',
    ],
    pt: <String>[
      'Termos de uso, política de privacidade e avisos legais vindos do backend.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Content the application already produces as Markdown → AppMarkdown.',
      'Arbitrary web pages with their own CSS and layout — use a WebView.',
    ],
    pt: <String>[
      'Conteúdo que a aplicação já produz em Markdown → AppMarkdown.',
      'Páginas web arbitrárias com CSS e layout próprios — use um WebView.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'data', type: 'String', isRequired: true),
    PropMeta(name: 'style', type: 'TextStyle?'),
    PropMeta(name: 'textColor', type: 'Color?'),
    PropMeta(name: 'styleSheet', type: 'AppContentStyle?'),
    PropMeta(name: 'onTapLink', type: 'void Function(String)?'),
    PropMeta(name: 'selectable', type: 'bool'),
  ],
  states: <String>['default', 'empty'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Legal document', pt: 'Documento legal'),
      code: 'AppHtml(data: state.privacyPolicy)',
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'It accepts a full document or a fragment — no need to normalize first.',
      'Wrap it in a scroll: legal documents are long.',
    ],
    pt: <String>[
      'Aceita documento completo ou fragmento — não precisa normalizar antes.',
      'Envolva num scroll: documentos legais são longos.',
    ],
  ),
  donts: LocalizedList(
    en: <String>[
      'Do not expect CSS fidelity: only the semantic structure is interpreted.',
    ],
    pt: <String>[
      'Não espere fidelidade de CSS: só a estrutura semântica é interpretada.',
    ],
  ),
  a11y: LocalizedText(
    en: 'Same contract as AppMarkdown: native selection, image alt as the label, tappable links (Tab focus pending).',
    pt:
        'Mesmo contrato do AppMarkdown: seleção nativa, alt de imagem como '
        'rótulo, links tocáveis (foco por Tab pendente).',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_markdown', 'app_simple_data_table'],
);

/// Descritor MCP do [AppCodeBlock]. Registrado em `flocksCatalog`.
const AppComponentMeta appCodeBlockMeta = AppComponentMeta(
  id: 'app_code_block',
  name: 'AppCodeBlock',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Monospaced code block with a language label and a copy control.',
    pt: 'Bloco de código monoespaçado com rótulo de linguagem e copiar.',
  ),
  description: LocalizedText(
    en: 'It shares the AppContentStyle leaf with AppMarkdown/AppHtml — same mono family, same background, same padding and same radius — so a standalone payload looks identical to the same snippet inside a document. By default it scrolls horizontally instead of wrapping, which preserves the indentation of JSON and of shell commands. Copy writes to the clipboard and swaps the icon for a temporary check.',
    pt:
        'Divide a folha AppContentStyle com AppMarkdown/AppHtml — mesma família '
        'mono, mesmo fundo, mesmo padding e mesmo raio —, então um payload avulso '
        'fica idêntico ao mesmo trecho dentro de um documento. Por padrão rola na '
        'horizontal em vez de quebrar linha, o que preserva a indentação de JSON e '
        'de comandos de shell. Copiar escreve na área de transferência e troca o '
        'ícone por um check temporário.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'A request/response payload, a cURL command, a configuration snippet.',
      'Any text that has to be copied whole, without reflowing.',
    ],
    pt: <String>[
      'Payload de request/response, comando cURL, trecho de configuração.',
      'Qualquer texto que precise ser copiado inteiro, sem reflow.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'A whole document mixing prose and code → AppMarkdown.',
      'A short identifier in the middle of a sentence → AppRichText\'s inline code.',
    ],
    pt: <String>[
      'Documento inteiro com prosa + código → AppMarkdown.',
      'Um identificador curto no meio de uma frase → código inline do AppRichText.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(name: 'code', type: 'String', isRequired: true),
    PropMeta(name: 'language', type: 'String?'),
    PropMeta(name: 'showCopy', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'wrap', type: 'bool', defaultValue: 'false'),
    PropMeta(name: 'selectable', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'copyTooltip', type: 'String', defaultValue: "'Copiar'"),
    PropMeta(name: 'copiedTooltip', type: 'String', defaultValue: "'Copiado'"),
    PropMeta(name: 'onCopy', type: 'VoidCallback?'),
    PropMeta(name: 'style', type: 'AppStyle?'),
    PropMeta(name: 'radiusMode', type: 'AppRadiusMode?'),
  ],
  states: <String>['default', 'copied'],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'JSON payload', pt: 'Payload JSON'),
      code: "AppCodeBlock(code: requestJson, language: 'json')",
    ),
    CodeExample(
      title: LocalizedText(
        en: 'A command, wrapping',
        pt: 'Comando, quebrando linha',
      ),
      code: "AppCodeBlock(code: curl, language: 'bash', wrap: true)",
    ),
  ],
  dos: LocalizedList(
    en: <String>[
      'Label the language — it is what tells the reader what they are about to paste.',
      'Leave wrap: false for JSON; the indentation is part of the information.',
    ],
    pt: <String>[
      'Rotule a linguagem — é o que diz ao leitor o que ele vai colar.',
      'Deixe wrap: false para JSON; a indentação é parte da informação.',
    ],
  ),
  donts: LocalizedList(
    en: <String>['Do not put prose here; mono penalizes running text.'],
    pt: <String>['Não coloque prosa aqui; o mono penaliza a leitura corrida.'],
  ),
  a11y: LocalizedText(
    en: 'The copy button is an AppInteraction with a tooltip and a semantic label that follows the state (Copy/Copied), activatable by keyboard. The code is selectable by default; the header is excluded from the selection so it does not pollute text copied by hand.',
    pt:
        'O botão de copiar é um AppInteraction com tooltip e rótulo semântico que '
        'acompanha o estado (Copiar/Copiado), ativável por teclado. O código fica '
        'selecionável por padrão; o cabeçalho é excluído da seleção para não '
        'poluir o texto copiado à mão.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_markdown', 'app_html', 'app_api_endpoint_tile'],
);
