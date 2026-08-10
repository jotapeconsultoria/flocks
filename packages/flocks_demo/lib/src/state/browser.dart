/// A única porta da demo para o navegador — e ela é estreita de propósito.
///
/// Duas operações, as duas que não têm como existir em Dart puro: reescrever a
/// query da barra de endereço, e abrir o seletor de arquivo. Ler a URL não entra
/// aqui porque `Uri.base` já resolve nos dois runtimes.
///
/// A condição é `dart.library.io`, e não `dart.library.html`. O `flocks` teve de
/// consertar exatamente isso na 0.1.1: `dart.library.html` é FALSO no dart2wasm,
/// então um build `--wasm` caía calado no ramo errado. O teste de arquitetura do
/// core proíbe a condição antiga, e o desta demo repete a proibição.
///
/// O stub existe para o `flutter test`, que roda na VM: sem ele, a suíte inteira
/// deixaria de compilar por causa de um `dart:js_interop` que ela nunca chama.
library;

export 'browser_web.dart' if (dart.library.io) 'browser_stub.dart';
