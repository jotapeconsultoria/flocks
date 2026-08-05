import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacings.dart';
import '../../tokens/app_style.dart';
import '../../tokens/app_text_styles.dart';
import '../buttons/buttons.dart';
import 'app_close_side.dart';

/// Altura da barra de topo das superfícies flutuantes (handle + título + "X").
const double kAppSurfaceTopBarHeight = 64.0;

/// Inset do botão de fechar — **igual** no topo e na lateral (equidistante,
/// considerando o raio arredondado do canto).
///
/// Público porque o side sheet precisa dele para calcular o quanto o "X" tem de
/// se afastar para escapar da gutter de arraste.
const double kAppSurfaceTopBarCloseInset = AppSpacings.s16;

/// Tamanho do botão de fechar (chip) = altura de `AppButtonSize.s`.
const double _kCloseButtonSize = 40.0;

/// Reserva horizontal para o botão de fechar, para o título não colidir com ele.
const double _kCloseSlot = 44.0;

/// Reserva do lado do "X" quando o título alinhado ao início **divide o lado**
/// com ele. [_kCloseSlot] deixa 4px entre o chip e o texto — respiro de título
/// centralizado, que raramente chega lá; alinhado ao início o título encosta
/// nele sempre, e 4px lê como colisão.
const double _kCloseSlotAbutting = _kCloseButtonSize + AppSpacings.s12;

/// Alinhamento do título na [AppSurfaceTopBar].
enum AppSurfaceTopBarTitleAlign {
  /// Centralizado, com reserva de [_kCloseSlot] dos **dois** lados — assim o
  /// título não se desloca quando o "X" troca de lado. Padrão das sheets.
  center,

  /// Colado no início da linha, com reserva só do lado onde o "X" está. Padrão
  /// do dialog, onde o título é o cabeçalho de um formulário e não o rótulo de
  /// um painel.
  start,
}

/// Barra de topo compartilhada das superfícies flutuantes do DS — dialog,
/// bottom sheet e side sheet.
///
/// Título opcional + botão de fechar em chip circular no canto, mais a handle
/// (grabber) horizontal opcional do bottom sheet. Altura fixa
/// ([kAppSurfaceTopBarHeight]).
///
/// **Quem decide se a barra existe é a superfície**: o dialog não a monta quando
/// não há título nem "X" (senão sobraria um vão de 64px); as sheets sempre a
/// montam — nelas a barra é também o respiro do topo do card e o extent fixo do
/// header fixado na rolagem.
///
/// Não é exportada no baril do pacote — é peça interna, como
/// `BottomSheetSurface`/`SideSheetSurface`. Superfícies expõem os parâmetros
/// dela achatados na própria API (`title`, `showCloseButton`, `closeSide`…).
@internal
class AppSurfaceTopBar extends StatelessWidget {
  /// Cria uma [AppSurfaceTopBar].
  const AppSurfaceTopBar({
    this.title,
    this.titleWidget,
    this.titleAlign = AppSurfaceTopBarTitleAlign.center,
    this.showCloseButton = true,
    this.closeSide = AppSheetCloseSide.end,
    this.onCloseButton,
    this.showHandle = false,
    this.closeClearance = 0,
    this.transparent = false,
    super.key,
  }) : assert(
         title == null || titleWidget == null,
         'title e titleWidget são exclusivos: o segundo existe para o título '
         'que não cabe numa String',
       );

  /// Título opcional.
  ///
  /// É `String`, e não `Widget`, porque a tipografia do título é da BARRA — o
  /// chamador escolhe o texto, não o estilo. Enquanto era `Widget`, todo mundo
  /// passava um `AppText` cru e a barra tentava impor `titleMedium` por
  /// `DefaultTextStyle`; só que o `AppText` ignora o estilo ambiente (sem
  /// `style` próprio ele fixa `bodyMedium`), então o título saía 14px regular em
  /// todo dialog e toda sheet do app — o estilo era escrito e descartado em
  /// silêncio.
  final String? title;

  /// Escape hatch para o título que NÃO é só texto (ícone ao lado, título
  /// reativo). Aqui a tipografia é de quem passa — a barra não a impõe.
  final Widget? titleWidget;

  /// Alinhamento do título. Default `center` (as sheets).
  final AppSurfaceTopBarTitleAlign titleAlign;

  /// Mostra o botão de fechar (chip circular). Default `true`.
  final bool showCloseButton;

  /// Lado do botão de fechar. Default `end` (direita em LTR).
  final AppSheetCloseSide closeSide;

  /// Ação do botão de fechar. `null` → dá pop na rota.
  final VoidCallback? onCloseButton;

  /// Recuo EXTRA no lado do botão de fechar, para tirá-lo de baixo da gutter de
  /// arraste do side sheet. `0` (default) degenera no inset simétrico.
  final double closeClearance;

  /// Mostra a handle (grabber) **horizontal** centralizada no topo. Só o bottom
  /// sheet usa — a do side sheet é a grabber vertical, desenhada fora da barra.
  final bool showHandle;

  /// Fundo transparente.
  ///
  /// `false` pinta `surfaceContainer` — necessário quando a barra fica **fixada
  /// por cima** do conteúdo que rola (bottom sheet no modo page/arraste), senão
  /// o conteúdo passa por baixo dela.
  ///
  /// `true` sob o eixo glass (o vidro é uma superfície só) e no dialog, onde a
  /// barra não cobre nada que role — e onde pintar por cima apagaria a borda do
  /// `outlined`, que o `DecoratedBox` desenha ATRÁS do filho.
  final bool transparent;

  /// O título já montado, ou `null` quando não há título.
  ///
  /// A barra MONTA o texto, em vez de tentar estilizar um widget que veio
  /// pronto: é a única forma de o estilo não poder ser descartado no caminho.
  Widget? _label(AppThemeData theme, AppColorTheme colors, bool startAligned) {
    if (title case final String t) {
      return AppText(
        t,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: startAligned ? TextAlign.start : TextAlign.center,
        style: theme.textTheme.titleMedium.withColor(colors.onSurface),
      );
    }
    return titleWidget;
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final bool startAligned = titleAlign == AppSurfaceTopBarTitleAlign.start;

    return ColoredBox(
      color: transparent ? colors.transparent : colors.surfaceContainer,
      child: SizedBox(
        height: kAppSurfaceTopBarHeight,
        width: double.infinity,
        // A barra é CROMO, não conteúdo — e nas sheets ela é também a área de
        // arraste (fica dentro do scrollable, como header fixado). Um `AppText`
        // aqui monta um `SelectableRegion`, cujo reconhecedor de arraste ganha a
        // arena do gesto e SELECIONA o texto em vez de arrastar a sheet (com
        // mouse é imediato; no toque quebra o arraste lento). Mesmo remédio do
        // `button_core`: conteúdo passivo não rouba o gesto.
        child: SelectionContainer.disabled(
          child: Stack(
            children: <Widget>[
              // Handle: sempre no MESMO lugar (posição absoluta) — só (in)visível.
              // Mostrar/esconder não desloca título nem botão.
              Positioned(
                top: AppSpacings.s8,
                left: 0,
                right: 0,
                child: Center(
                  child: Opacity(
                    opacity: showHandle ? 1 : 0,
                    child: SizedBox(
                      width: 32,
                      height: 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.onSurface.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Faixa título + botão de fechar, ancorada em `top == inset lateral`
              // (botão equidistante do topo e da lateral, considerando o raio);
              // independe da handle.
              Positioned(
                top: kAppSurfaceTopBarCloseInset,
                height: _kCloseButtonSize,
                left: 0,
                right: 0,
                child: Padding(
                  // Com `closeClearance == 0` isto é EXATAMENTE o
                  // `symmetric(horizontal: kAppSurfaceTopBarCloseInset)` — em LTR
                  // e em RTL. Um caminho só serve às três superfícies.
                  padding: EdgeInsetsDirectional.only(
                    start:
                        kAppSurfaceTopBarCloseInset +
                        (closeSide == AppSheetCloseSide.start
                            ? closeClearance
                            : 0),
                    end:
                        kAppSurfaceTopBarCloseInset +
                        (closeSide == AppSheetCloseSide.end
                            ? closeClearance
                            : 0),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      if (_label(theme, colors, startAligned)
                          case final Widget l)
                        Padding(
                          // Centralizado reserva dos DOIS lados (o título não se
                          // mexe quando o "X" troca de lado); alinhado ao início
                          // reserva só do lado do "X".
                          padding: startAligned
                              ? EdgeInsetsDirectional.only(
                                  // O lado onde o título ENCOSTA no chip pede o
                                  // respiro maior; o outro é só teto de texto
                                  // longo.
                                  start: closeSide == AppSheetCloseSide.start
                                      ? _kCloseSlotAbutting
                                      : 0,
                                  end: closeSide == AppSheetCloseSide.end
                                      ? _kCloseSlot
                                      : 0,
                                )
                              : const EdgeInsets.symmetric(
                                  horizontal: _kCloseSlot,
                                ),
                          // `namesRoute`: quando a barra é o topo de um modal
                          // (dialog/sheet), o título também NOMEIA a rota — é o
                          // que o leitor de tela anuncia ao abrir. Fora de uma
                          // rota é inócuo.
                          // O `Align` estica a faixa e encosta o título no
                          // início; sem ele o `Padding` encolheria em volta do
                          // texto e o `Stack` o centralizaria de novo.
                          //
                          // `namesRoute`: quando a barra é o topo de um modal
                          // (dialog/sheet), o título também NOMEIA a rota — é o
                          // que o leitor anuncia ao abrir. Fora de rota, inócuo.
                          child: AppSemantics.header(
                            startAligned
                                ? Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: l,
                                  )
                                : l,
                            namesRoute: true,
                          ),
                        ),
                      if (showCloseButton)
                        Align(
                          alignment: closeSide == AppSheetCloseSide.end
                              ? AlignmentDirectional.centerEnd
                              : AlignmentDirectional.centerStart,
                          child: AppButton(
                            icon: AppIconToken.close,
                            onPressed:
                                onCloseButton ??
                                () => Navigator.of(context).maybePop(),
                            radiusMode: AppRadiusMode.circular,
                            color: AppButtonColor.neutral,
                            style: AppStyle.filled,
                            size: AppButtonSize.s,
                            semanticsLabel: 'Fechar',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
