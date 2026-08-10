import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Os tipos que o seletor de arquivo oferece.
///
/// A lista casa com o que [DemoLogo.sniffFormat] sabe desenhar. Ela é uma
/// conveniência do diálogo, não uma validação: o navegador deixa o visitante
/// escolher "todos os arquivos" de qualquer jeito, e quem decide de verdade é a
/// assinatura dos bytes.
const String _kAccept =
    'image/png,image/jpeg,image/webp,image/gif,image/svg+xml';

/// Reescreve a query da barra de endereço sem recarregar nem empilhar histórico.
///
/// `replaceState`, e não `pushState`: cada arraste no seletor de cor mudaria a
/// URL, e empilhar isso encheria o histórico de estados intermediários que o
/// botão "voltar" teria de percorrer um a um.
void replaceQuery(String query) {
  final String path = web.window.location.pathname;
  web.window.history.replaceState(
    null,
    '',
    query.isEmpty ? path : '$path?$query',
  );
}

/// Abre o seletor de arquivo e devolve os BYTES do que o visitante escolheu.
///
/// Devolve os bytes, e nunca um endereço: não há `createObjectURL` aqui, nem
/// nada que produza um. É o ponto exato onde a demo poderia ter virado um app
/// que "só" cria uma URL local — e é por não existir esse `createObjectURL` que
/// o gate de rede da suíte pode exigir ZERO requisições, em vez de ter de
/// classificar quais são inofensivas.
///
/// O nome do arquivo é lido? Não. Ele nem é tocado: o formato sai da assinatura
/// dos bytes, então o nome não chega ao estado da demo nem por acidente — que é
/// o que o evento de analytics `demo logo uploaded` promete não registrar.
///
/// `null` quando o visitante fecha o diálogo sem escolher, quando a leitura
/// falha, ou quando o navegador não dispara nem `change` nem `cancel`.
Future<Uint8List?> pickImageBytes() {
  final Completer<Uint8List?> done = Completer<Uint8List?>();
  final web.HTMLInputElement input =
      web.document.createElement('input') as web.HTMLInputElement
        ..type = 'file'
        ..accept = _kAccept;

  void finish(Uint8List? bytes) {
    if (!done.isCompleted) done.complete(bytes);
  }

  input.onchange = (web.Event _) {
    final web.FileList? files = input.files;
    if (files == null || files.length == 0) return finish(null);
    final web.File file = files.item(0)!;
    final web.FileReader reader = web.FileReader();
    reader.onload = (web.Event _) {
      final JSAny? result = reader.result;
      if (result == null) return finish(null);
      finish((result as JSArrayBuffer).toDart.asUint8List());
    }.toJS;
    reader.onerror = ((web.Event _) => finish(null)).toJS;
    reader.readAsArrayBuffer(file);
  }.toJS;

  // Fechar o diálogo não dispara `change`. Sem isto o Future ficaria pendente
  // para sempre e o botão de enviar logo ficaria travado no estado "abrindo".
  input.addEventListener('cancel', ((web.Event _) => finish(null)).toJS);

  input.click();
  return done.future;
}
