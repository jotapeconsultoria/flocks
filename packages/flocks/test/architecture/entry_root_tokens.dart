/// O que a **raiz de entrada** documentada tem de montar, em toda superfície que
/// a ensina.
///
/// São quatro cópias da mesma árvore, mantidas à mão: o primeiro bloco de código
/// do `README.md` (a página do pub.dev), o `example/lib/main.dart` (a aba Example)
/// e o `<pre><code>` das duas homes do site. O `readme_example_test.dart` cobre as
/// duas primeiras; o `install_docs_test.dart` cobre as duas páginas, junto da copy
/// de instalação que ele já fiscaliza.
///
/// A armadilha que isto fecha é de REFATORAÇÃO, e é silenciosa: o `Overlay` sai
/// de um dos quatro e nada fica vermelho — nem o `dart analyze`, porque a árvore
/// sem ele compila perfeitamente. O que ela produz é crash em tempo de execução,
/// no produto de quem copiou, e num artefato que viaja congelado no tarball.
library;

/// Os tokens que a raiz de entrada tem de conter.
///
/// `Overlay(` porque sete `Overlay.of(context)` de `lib/` inserem no ancestral
/// mais próximo e `Overlay.of` lança quando não acha — e porque todo campo de texto
/// cobra o mesmo ancestral por regra do framework: o `EditableText` monta um
/// `TextSelectionOverlay` ao primeiro toque, e o construtor do `SelectionOverlay`
/// embaixo dele tem `assert(debugCheckHasOverlay(context))` na lista de
/// inicialização (`widgets/text_selection.dart`).
///
/// `Directionality(` porque o próprio `Overlay` resolve por ele as coordenadas
/// direcionais das suas entries: sem ele a raiz documentada não monta, e o
/// primeiro gate a reprovar seria outro, com mensagem que não aponta para cá.
///
/// Substring crua, e não análise de árvore: o alvo são três formatos diferentes
/// (Markdown, Dart e HTML) e o que se cobra é a PRESENÇA da montagem, não a forma
/// dela. Nas páginas do site a comparação é feita sobre o texto extraído do DOM,
/// porque no HTML cru o token vem partido por `<span>` de coloração.
const List<String> kTokensDaRaizDeEntrada = <String>[
  'Overlay(',
  'Directionality(',
];
