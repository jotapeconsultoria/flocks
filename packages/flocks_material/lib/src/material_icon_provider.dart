import 'package:flocks/flocks.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

/// Os ícones do Material Design como [AppIconProvider] do Flocks.
///
/// **Este pacote existe para provar uma regra, não só para servir ícones.** O
/// `flocks` não importa `material.dart` — há teste de arquitetura que barra, e
/// é isso que sustenta a tese de "zero Material". Um adaptador de Material
/// dentro do core derrubaria a tese para todo mundo; aqui fora, quem quiser
/// Material paga por ele, e quem não quiser continua sem.
///
/// É também a implementação de referência do eixo: um `flocks_fontawesome`, um
/// provider do set da sua empresa ou um adaptador de qualquer biblioteca de
/// `IconData` têm exatamente esta forma — uma tabela e um `build`.
///
/// ```dart
/// AppThemeScope(
///   iconProvider: const MaterialIconProvider(),
///   builder: (context, theme) => MyApp(theme: theme),
/// )
/// ```
///
/// Cobre os 55 [AppIconToken] — o contrato. Um nome fora dele cai no
/// [fallback], porque o Material não tem como resolver slug arbitrário: os
/// nomes dele são identificadores Dart, não strings.
final class MaterialIconProvider implements AppIconProvider {
  /// Cria o provider. [fallback] é o glifo de um nome fora do contrato.
  const MaterialIconProvider({this.fallback = Icons.help_outline});

  /// Desenhado quando o nome não está no contrato.
  ///
  /// Um interrogação é deliberado: some menos que um espaço em branco, e um
  /// ícone que não resolveu é bug de integração, não estado de repouso.
  final IconData fallback;

  /// O glifo de [icon], ou `null` se estiver fora do contrato.
  IconData? resolve(String icon) => kFlocksToMaterial[icon];

  @override
  Widget build(
    BuildContext context,
    String icon, {
    required double size,
    Color? color,
  }) {
    final IconData glyph = resolve(icon) ?? fallback;
    // `Icon` é do Material; aqui dentro isso é permitido e é o ponto. Mas ele
    // lê `IconTheme`, que traria um default fora do nosso controle — por isso o
    // glifo é pintado direto, com a cor e o tamanho que o Flocks resolveu.
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

/// A tradução dos 55 [AppIconToken] para glifos do Material.
///
/// Escrita à mão porque não há como derivá-la: os nomes do Material são
/// identificadores Dart, não strings, e o mapeamento é semântico. É pequena de
/// propósito — é o contrato, não um catálogo.
const Map<String, IconData> kFlocksToMaterial = <String, IconData>{
  'add': Icons.add,
  'alert': Icons.warning_amber_outlined,
  'api-cloud': Icons.cloud_outlined,
  'arrow-up': Icons.arrow_upward,
  'attachment': Icons.attach_file,
  'audio': Icons.audio_file_outlined,
  'calendar': Icons.calendar_today_outlined,
  'cancel': Icons.cancel_outlined,
  'car': Icons.directions_car_outlined,
  'chat': Icons.chat_bubble_outline,
  'check': Icons.check,
  'check-circle': Icons.check_circle_outline,
  'chevron-down': Icons.keyboard_arrow_down,
  'chevron-left': Icons.keyboard_arrow_left,
  'chevron-right': Icons.keyboard_arrow_right,
  'chevron-up': Icons.keyboard_arrow_up,
  'clock': Icons.access_time,
  'close': Icons.close,
  'copy': Icons.copy_outlined,
  'csv': Icons.grid_on_outlined,
  'dashboard': Icons.dashboard_outlined,
  'drag-arrow': Icons.open_with,
  'error-circle': Icons.error_outline,
  'external-link': Icons.open_in_new,
  'file-doc': Icons.description_outlined,
  'file-pdf': Icons.picture_as_pdf_outlined,
  'file-ppt': Icons.slideshow_outlined,
  'file-text': Icons.article_outlined,
  'file-txt': Icons.text_snippet_outlined,
  'file-xls': Icons.table_chart_outlined,
  'filter': Icons.filter_list,
  'group': Icons.groups_outlined,
  'hyperlink': Icons.link,
  'image-landscape': Icons.image_outlined,
  'info': Icons.info_outline,
  'info-circle': Icons.info_outline,
  'mail': Icons.mail_outline,
  'map': Icons.map_outlined,
  'microphone': Icons.mic_none_outlined,
  'pdf': Icons.picture_as_pdf_outlined,
  'pencil': Icons.edit_outlined,
  'plus': Icons.add,
  'refresh': Icons.refresh,
  'remove': Icons.remove,
  'search': Icons.search,
  'settings': Icons.settings_outlined,
  'stop': Icons.stop_circle_outlined,
  'support': Icons.headset_mic_outlined,
  'swap-arrow': Icons.swap_horiz,
  'sync': Icons.sync,
  'thumbs-down': Icons.thumb_down_outlined,
  'thumbs-up': Icons.thumb_up_outlined,
  'user': Icons.person_outline,
  'video-play': Icons.video_file_outlined,
  'zip-file': Icons.folder_zip_outlined,
};
