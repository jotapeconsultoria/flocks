import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'app_icon_provider.dart';
import 'icon_error_placeholder.dart';
// O ramo DEFAULT é o web, e `dart:io` é o que se ESCOLHE — o inverso do que
// estava aqui. `dart.library.html` era o predicado errado: `dart:html` não
// existe no dart2wasm, então todo build `--wasm` caía no default de então
// (`network_icon_loader_io.dart`) e arrastava `dart:io` para um alvo que não o
// tem. Era o que tornava o pacote inteiro "not compatible with runtime wasm" no
// pub.dev, e o que quebraria um app em wasm em runtime.
//
// `dart.library.io` é verdadeiro na VM e falso nos DOIS backends web (dart2js e
// dart2wasm), então cada alvo passa a receber o loader que sempre foi o dele.
import 'network_icon_loader_web.dart'
    if (dart.library.io) 'network_icon_loader_io.dart'
    as loader;

/// Busca o SVG num CDN, com cache em disco no nativo e cache do browser na web.
///
/// É o comportamento que o pacote tinha por padrão, agora com o endereço vindo
/// de fora: a marca declara o seu CDN em vez de o pacote embutir o de alguém.
/// Vale quando o catálogo é grande demais para embutir — os ~880 de [AppIcons]
/// contra os 55 que [AppAssetIconProvider] serve.
///
/// Um [icon] que já seja `http://` ou `https://` passa direto, sem concatenar
/// [baseUrl]. É o que mantém funcionando quem sempre passou URL crua ao
/// `AppIcon`.
final class AppNetworkIconProvider implements AppIconProvider {
  /// Cria o provider de rede apontando para [baseUrl].
  ///
  /// [extension] é o sufixo do arquivo; o default cobre a convenção
  /// `<baseUrl>/<slug>.svg`.
  const AppNetworkIconProvider({
    required this.baseUrl,
    this.extension = '.svg',
  });

  /// Raiz onde os ícones estão hospedados, sem barra no fim.
  final String baseUrl;

  /// Sufixo do arquivo. Vazio para um CDN que serve sem extensão.
  final String extension;

  /// O endereço de [icon] — ele mesmo, se já for absoluto.
  ///
  /// Público porque quem faz precache precisa do endereço sem desenhar nada: o
  /// app aquece o cache no boot a partir de uma lista de slugs, e só o provider
  /// sabe traduzi-los.
  String urlFor(String icon) =>
      icon.startsWith('http://') || icon.startsWith('https://')
      ? icon
      : '$baseUrl/$icon$extension';

  @override
  Widget build(
    BuildContext context,
    String icon, {
    required double size,
    Color? color,
  }) => _NetworkIcon(
    color: color,
    size: size,
    theme: AppTheme.of(context),
    url: urlFor(icon),
  );
}

/// O widget com estado que o provider devolve.
///
/// O estado vive aqui, e não no `AppIcon`, de propósito: o `AppIcon` disparava
/// o download no `initState`, onde o tema ainda não é seguro de ler — e o
/// provider vem justamente do tema. Empurrando o `Future` para dentro do widget
/// que o provider devolve, o `AppIcon` volta a ser quase sem estado e o
/// problema deixa de existir.
class _NetworkIcon extends StatefulWidget {
  const _NetworkIcon({
    required this.color,
    required this.size,
    required this.theme,
    required this.url,
  });

  final Color? color;
  final double size;
  final AppThemeData theme;
  final String url;

  @override
  State<_NetworkIcon> createState() => _NetworkIconState();
}

class _NetworkIconState extends State<_NetworkIcon> {
  late Future<Object?> _source;

  @override
  void initState() {
    super.initState();
    _source = loader.fetchIconSource(widget.url);
  }

  @override
  void didUpdateWidget(_NetworkIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _source = loader.fetchIconSource(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Object?>(
    future: _source,
    builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox.square(dimension: widget.size);
      }
      final Object? data = snapshot.data;
      if (data == null) {
        return iconErrorPlaceholder(widget.theme, widget.size, widget.color);
      }
      return loader.buildIconSvg(
        data,
        color: widget.color,
        size: widget.size,
        theme: widget.theme,
        url: widget.url,
      );
    },
  );
}
