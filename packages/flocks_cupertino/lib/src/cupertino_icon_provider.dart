import 'package:flocks/flocks.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';

/// Os ícones do `cupertino_icons` como [AppIconProvider] do Flocks.
///
/// ```dart
/// AppThemeScope(
///   iconProvider: const CupertinoIconProvider(),
///   builder: (context, theme) => MyApp(theme: theme),
/// )
/// ```
///
/// ## O que este pacote serve, e o que ele NÃO serve
///
/// Os glifos vêm da fonte `CupertinoIcons.ttf`, que o pacote
/// [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) publica **sob
/// licença MIT**. São desenhos próprios, no vocabulário visual do iOS.
///
/// **Não são os SF Symbols da Apple.** Os SF Symbols são licenciados pela
/// Apple e não podem ser redistribuídos num pacote; este adaptador não os
/// embute, não os baixa e não depende deles. A distinção não é preciosismo de
/// prosa: é a diferença entre um pacote publicável e um que não pode existir.
///
/// Os `IconData` referenciados aqui moram em `package:flutter/cupertino.dart`
/// — o framework carrega as constantes, o pacote `cupertino_icons` carrega a
/// fonte a que elas apontam. Por isso a dependência está no `pubspec`: sem
/// ela, as constantes resolvem para uma família que não está no bundle.
///
/// Cobre os 55 [AppIconToken] — o contrato — e o teste cobra que continue
/// cobrindo. Um nome fora dele cai no [fallback], porque os nomes do
/// `CupertinoIcons` são identificadores Dart, não strings: não há como resolver
/// slug arbitrário.
final class CupertinoIconProvider implements AppIconProvider {
  /// Cria o provider. [fallback] é o glifo de um nome fora do contrato.
  const CupertinoIconProvider({this.fallback = CupertinoIcons.question_circle});

  /// Desenhado quando o nome não está no contrato.
  ///
  /// Um interrogação é deliberado: some menos que um espaço em branco, e um
  /// ícone que não resolveu é bug de integração, não estado de repouso.
  final IconData fallback;

  /// O glifo de [icon], ou `null` se estiver fora do contrato.
  IconData? resolve(String icon) => kFlocksToCupertino[icon];

  @override
  Widget build(
    BuildContext context,
    String icon, {
    required double size,
    Color? color,
  }) {
    final IconData glyph = resolve(icon) ?? fallback;
    // O glifo é pintado direto, e não pelo widget `Icon`: ele lê `IconTheme`,
    // que traria um default fora do nosso controle — aqui a cor e o tamanho
    // são os que o Flocks resolveu, e mais nada. É a mesma mecânica do
    // `flocks_material`.
    return SizedBox.square(
      dimension: size,
      child: Center(
        child: Text(
          String.fromCharCode(glyph.codePoint),
          style: TextStyle(
            color: color,
            fontFamily: glyph.fontFamily,
            fontSize: size,
            height: 1,
            package: glyph.fontPackage,
          ),
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}

/// A tradução dos 55 [AppIconToken] para glifos do `cupertino_icons`.
///
/// Escrita à mão porque não há como derivá-la: os nomes do `CupertinoIcons` são
/// identificadores Dart, não strings, e o mapeamento é semântico. É pequena de
/// propósito — é o contrato, não um catálogo.
///
/// Repetições são esperadas e não são descuido: o set do iOS não distingue um
/// PDF de um documento rico, nem um CSV de uma planilha, então `pdf` e
/// `file-pdf` chegam ao mesmo desenho, como `csv` e `file-xls`. Inventar
/// diferença onde o set não tem produziria ícone errado, não ícone específico.
const Map<String, IconData> kFlocksToCupertino = <String, IconData>{
  'add': CupertinoIcons.add,
  'alert': CupertinoIcons.exclamationmark_triangle,
  'api-cloud': CupertinoIcons.cloud,
  'arrow-up': CupertinoIcons.arrow_up,
  'attachment': CupertinoIcons.paperclip,
  'audio': CupertinoIcons.music_note,
  'calendar': CupertinoIcons.calendar,
  'cancel': CupertinoIcons.xmark_circle,
  'car': CupertinoIcons.car_detailed,
  'chat': CupertinoIcons.chat_bubble,
  'check': CupertinoIcons.check_mark,
  'check-circle': CupertinoIcons.check_mark_circled,
  'chevron-down': CupertinoIcons.chevron_down,
  'chevron-left': CupertinoIcons.chevron_left,
  'chevron-right': CupertinoIcons.chevron_right,
  'chevron-up': CupertinoIcons.chevron_up,
  'clock': CupertinoIcons.clock,
  'close': CupertinoIcons.xmark,
  'copy': CupertinoIcons.doc_on_doc,
  'csv': CupertinoIcons.table,
  'dashboard': CupertinoIcons.square_grid_2x2,
  'drag-arrow': CupertinoIcons.arrow_up_left_arrow_down_right,
  'error-circle': CupertinoIcons.exclamationmark_circle,
  'external-link': CupertinoIcons.arrow_up_right_square,
  'file-doc': CupertinoIcons.doc_text,
  'file-pdf': CupertinoIcons.doc_richtext,
  'file-ppt': CupertinoIcons.doc_chart,
  'file-text': CupertinoIcons.doc_text,
  'file-txt': CupertinoIcons.doc_plaintext,
  'file-xls': CupertinoIcons.table,
  'filter': CupertinoIcons.line_horizontal_3_decrease,
  'group': CupertinoIcons.person_2,
  'hyperlink': CupertinoIcons.link,
  'image-landscape': CupertinoIcons.photo,
  'info': CupertinoIcons.info,
  'info-circle': CupertinoIcons.info_circle,
  'mail': CupertinoIcons.mail,
  'map': CupertinoIcons.map,
  'microphone': CupertinoIcons.mic,
  'pdf': CupertinoIcons.doc_richtext,
  'pencil': CupertinoIcons.pencil,
  'plus': CupertinoIcons.add,
  'refresh': CupertinoIcons.refresh,
  'remove': CupertinoIcons.minus,
  'search': CupertinoIcons.search,
  'settings': CupertinoIcons.settings,
  'stop': CupertinoIcons.stop,
  'support': CupertinoIcons.headphones,
  'swap-arrow': CupertinoIcons.arrow_right_arrow_left,
  'sync': CupertinoIcons.arrow_2_circlepath,
  'thumbs-down': CupertinoIcons.hand_thumbsdown,
  'thumbs-up': CupertinoIcons.hand_thumbsup,
  'user': CupertinoIcons.person,
  'video-play': CupertinoIcons.play_rectangle,
  'zip-file': CupertinoIcons.archivebox,
};
