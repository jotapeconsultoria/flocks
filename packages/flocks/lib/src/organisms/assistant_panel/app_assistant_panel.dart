import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Altura do cabeçalho do painel.
const double kAppAssistantPanelHeaderHeight = 64.0;

/// Painel lateral do assistente — sempre presente, nunca um overlay.
///
/// ## Por que não é um overlay
///
/// Um assistente que cobre a tela obriga a escolher entre ver o dado e
/// perguntar sobre ele. Aqui ele é uma coluna de altura total ao lado do
/// conteúdo: dá para conversar olhando a tela que motivou a pergunta.
///
/// ## Anatomia
///
/// ```
/// ┌──────────────────┐
/// │ cabeçalho        │  título + status
/// ├──────────────────┤
/// │ alertBanner      │  faixa fixa (contagem de alertas)
/// ├──────────────────┤
/// │                  │
/// │ body             │  conversa
/// │                  │
/// ├──────────────────┤
/// │ composer         │
/// └──────────────────┘
/// ```
///
/// O [alertBanner] é **fixo**: fica visível mesmo quando a conversa rola. É o
/// que sustenta "alertas fáceis de ver a todo tempo" — um cartão de alerta
/// dentro do fluxo sai de vista assim que a conversa anda.
///
/// ## Largura
///
/// O painel preenche o que receber. Quem o coloca no shell decide a largura —
/// e pode torná-la arrastável sem o DS saber de persistência.
final class AppAssistantPanel extends StatelessWidget {
  const AppAssistantPanel({
    required this.body,
    this.title = 'Assistente',
    this.statusLabel,
    this.isOnline = true,
    this.avatar,
    this.alertBanner,
    this.composer,
    this.actions = const <Widget>[],
    this.decoration,
    super.key,
  });

  /// A conversa.
  final Widget body;

  /// Nome do assistente.
  final String title;

  /// Segunda linha do cabeçalho (ex.: "Sempre online").
  final String? statusLabel;

  /// Cor do chip de status: verde quando online, neutro quando não.
  final bool isOnline;

  /// Marca/avatar do assistente, à esquerda do título.
  final Widget? avatar;

  /// Faixa fixa entre cabeçalho e conversa (contagem de alertas).
  final Widget? alertBanner;

  /// Campo de escrita, ancorado embaixo.
  final Widget? composer;

  /// Ações extras no cabeçalho.
  final List<Widget> actions;

  /// Fundo do painel. Por padrão herda a superfície do shell (`surface`), o
  /// que mantém a continuidade com rail e header.
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return DecoratedBox(
      // Sem `decoration` explícita, o painel segue o eixo global de estilo.
      // Raio zero de propósito: é um painel encostado na borda da janela, e o
      // eixo aqui trata só do tratamento da caixa (borda/sombra), não da forma.
      decoration:
          decoration ??
          styleBoxDecoration(
            style: theme.styleTheme.style,
            isDark: theme.brightness == AppBrightness.dark,
            radius: BorderRadius.zero,
            outline: theme.colorTheme.outline,
            surfaceContainer: theme.colorTheme.surfaceContainer,
            ownFill: theme.colorTheme.surface,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            title: title,
            statusLabel: statusLabel,
            isOnline: isOnline,
            avatar: avatar,
            actions: actions,
          ),
          ?alertBanner,
          Expanded(child: body),
          ?composer,
        ],
      ),
    );
  }
}

final class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.statusLabel,
    required this.isOnline,
    required this.avatar,
    required this.actions,
  });

  final String title;
  final String? statusLabel;
  final bool isOnline;
  final Widget? avatar;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return SizedBox(
      height: kAppAssistantPanelHeaderHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s16),
        // Espelhado: identidade encostada na borda EXTERNA do painel (a
        // direita), não na que dá para o conteúdo. O painel é a coluna da
        // direita da tela, então ancorar ali é o que o alinha com o resto do
        // seu próprio eixo em vez de apontar para dentro.
        child: Row(
          children: [
            ...actions,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleMedium.copyWith(
                      color: theme.colorTheme.neutralPrimary.s900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Chip do DS em vez de ponto + texto: o estado ganha uma
                  // forma reconhecível, e a cor deixa de ser o único sinal.
                  if (statusLabel != null && statusLabel!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacings.s2),
                      child: AppBadge(
                        statusLabel!,
                        size: AppBadgeSize.s,
                        color: isOnline
                            ? AppBadgeColor.success
                            : AppBadgeColor.neutral,
                      ),
                    ),
                ],
              ),
            ),
            if (avatar != null) ...[
              const SizedBox(width: AppSpacings.s12),
              avatar!,
            ],
          ],
        ),
      ),
    );
  }
}
