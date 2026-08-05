import 'package:flutter/widgets.dart';

import '../../organisms/scaffolds/app_scaffold.dart';
import '../../theme/theme.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../texts/texts.dart';

/// Cena compartilhada dos `@Preview` de **barras** (headers/footers).
///
/// Existe porque uma barra renderizada sobre o vazio não mostra nada do que ela
/// faz: no eixo glass o efeito é inteiramente sobre o que está **atrás**, e sem
/// fundo (ou sobre um fundo liso) o previewer da IDE mostra uma faixa cinza
/// idêntica em todos os estilos. A cena dá conteúdo colorido e de alta
/// frequência para o vidro desfocar, mais uma **safe-area falsa** — que é o que
/// faz o platô do gradiente e o `outerSafeAreaInset` aparecerem.
///
/// É a versão enxuta da cena do Widgetbook (`wbBarScene`): previews são
/// miniaturas na IDE, não bancada de teste — quem arrasta o conteúdo sob a
/// barra é o catálogo.
///
/// Uso nos `.preview.dart`:
///
/// ```dart
/// Widget _sample(AppThemeData data) => AppTheme(
///   data: data,
///   child: barPreviewScene(header: const AppSimpleHeader(child: AppText('Título'))),
/// );
/// ```
///
/// A cena nasce **rolada** ([scrollOffset]) de propósito: em repouso a reserva
/// das barras deixa a faixa sob elas vazia, e barra glass sobre o vazio fica
/// idêntica em todos os estilos. Deslocada, há conteúdo sob a barra — o único
/// estado em que o vidro mostra alguma coisa.
Widget barPreviewScene({
  Widget? header,
  Widget? footer,
  double height = 320,
  double scrollOffset = 90,
}) => _BarPreviewScene(
  header: header,
  footer: footer,
  height: height,
  scrollOffset: scrollOffset,
);

/// Paleta saturada de demonstração: o vidro re-satura o que desfoca, então
/// conteúdo lavado não consegue evidenciar o efeito.
const List<Color> _kPreviewColors = <Color>[
  Color(0xFF6D28D9),
  Color(0xFF2563EB),
  Color(0xFF06B6D4),
  Color(0xFFDB2777),
];

class _BarPreviewScene extends StatelessWidget {
  const _BarPreviewScene({
    required this.header,
    required this.footer,
    required this.height,
    required this.scrollOffset,
  });

  final Widget? header;
  final Widget? footer;
  final double height;
  final double scrollOffset;

  @override
  Widget build(BuildContext context) {
    const EdgeInsets insets = EdgeInsets.only(top: 44, bottom: 34);
    return SizedBox(
      width: 380,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(padding: insets, viewPadding: insets),
          child: AppScaffold(
            contentUnderBars: true,
            header: header,
            footer: footer,
            child: _PreviewFeed(scrollOffset: scrollOffset),
          ),
        ),
      ),
    );
  }
}

class _PreviewFeed extends StatefulWidget {
  const _PreviewFeed({required this.scrollOffset});

  final double scrollOffset;

  @override
  State<_PreviewFeed> createState() => _PreviewFeedState();
}

class _PreviewFeedState extends State<_PreviewFeed> {
  late final ScrollController _controller = ScrollController(
    initialScrollOffset: widget.scrollOffset,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return ListView(
      controller: _controller,
      // Soma a reserva das barras sobrepostas (publicada pelo AppScaffold em
      // MediaQuery.padding) ao padding próprio: com `padding` explícito o
      // ListView NÃO a consome sozinho, e o 1º item nasceria sob a barra.
      padding:
          const EdgeInsets.all(AppSpacings.s16) + MediaQuery.paddingOf(context),
      children: <Widget>[
        AppText('Conteúdo', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacings.s8),
        for (int i = 0; i < 4; i++) ...<Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: theme.radiusTheme.resolve(),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  _kPreviewColors[i % _kPreviewColors.length],
                  _kPreviewColors[(i + 2) % _kPreviewColors.length],
                ],
              ),
            ),
            child: const SizedBox(height: 72, width: double.infinity),
          ),
          const SizedBox(height: AppSpacings.s12),
        ],
      ],
    );
  }
}
