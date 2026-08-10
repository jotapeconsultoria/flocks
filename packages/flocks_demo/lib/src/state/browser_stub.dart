import 'dart:typed_data';

/// Fora do navegador não há barra de endereço para reescrever.
///
/// Silencioso de propósito: quem chama é a tela, a cada troca de eixo, e um
/// `UnsupportedError` transformaria toda a suíte de widget test numa cascata de
/// exceções por uma operação que não faz falta nenhuma na VM.
void replaceQuery(String query) {}

/// Fora do navegador não há seletor de arquivo.
///
/// Devolve `null`, que é o mesmo que a versão web devolve quando o visitante
/// fecha o diálogo sem escolher nada — então a tela já sabe lidar com isso e não
/// existe um caminho de código exclusivo do teste.
Future<Uint8List?> pickImageBytes() async => null;
