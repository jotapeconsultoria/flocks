import 'dart:typed_data';

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

import 'data/demo_data.dart';
import 'panel/brand_panel.dart';
import 'screens/crud_screen.dart';
import 'screens/dashboard_screen.dart';
import 'state/brand_from_config.dart';
import 'state/browser.dart';
import 'state/demo_config.dart';
import 'state/demo_logo.dart';

/// Largura do painel de marca. O `AppShell` não opina sobre isso de propósito —
/// a largura do aside é de quem o passa.
const double kPanelWidth = 360;

/// Abaixo disto o `AppShell` não é o layout certo, e a demo diz isso em vez de
/// se espremer.
///
/// O shell é declaradamente de desktop (`crossPlatform: false` no catálogo):
/// rail, conteúdo em cartão e painel lateral de altura total. Somando esse cromo
/// ao que a tabela do dashboard precisa para o próprio rodapé de paginação, o
/// piso cai aqui.
///
/// Espremer o layout abaixo disso não deixaria a demo utilizável — deixaria a
/// vitrine do design system exibindo uma faixa de overflow, que é o pior lugar
/// possível para uma. Uma versão móvel é outro layout (`AppScaffold`, navegação
/// no rodapé, painel em bottom sheet), e não uma questão de ajustar números.
const double kMinShellWidth = 1220;

/// A demo inteira.
///
/// Não existe `MaterialApp` aqui, e isso não é purismo: o `flocks` não depende
/// de Material, então um app que o consome também não precisa. O que sustenta a
/// árvore é `AppTheme` — um `InheritedWidget` com o tema derivado da marca — e
/// `Directionality`, que é o mínimo que `widgets.dart` exige.
class DemoApp extends StatefulWidget {
  /// Cria a demo.
  ///
  /// [initialUri] existe para o teste poder entrar direto num estado sem
  /// depender da barra de endereço; em produção o padrão é `Uri.base`, que o
  /// Flutter Web resolve para a URL da aba.
  const DemoApp({this.initialUri, super.key});

  /// A URL de onde a configuração inicial é lida.
  final Uri? initialUri;

  @override
  State<DemoApp> createState() => DemoAppState();
}

/// O estado da demo.
///
/// Público — e não `_DemoAppState` — para que `test/no_network_test.dart`
/// alcance o único caminho que ele não consegue percorrer pela interface: o
/// upload do logo passa pelo seletor de arquivo do navegador, que na VM devolve
/// `null`. Sem esta porta, o gate mais importante da demo teria de rodar sem
/// logo nenhum carregado, provando o que não interessa.
class DemoAppState extends State<DemoApp> {
  late DemoConfig _config = DemoConfig.fromUri(widget.initialUri ?? Uri.base);
  late final List<Account> _accounts = seedAccounts();

  // O logo mora AQUI, no estado da tela, e em lugar nenhum mais: não há
  // singleton, não há cache, não há storage. Fechar a aba é o que o descarta.
  DemoLogo? _logo;
  String? _logoError;
  bool _pickingLogo = false;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = themeFromConfig(_config);

    return AppTheme(
      data: theme,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DefaultTextStyle(
          style: theme.textTheme.bodyMedium.withColor(
            theme.colorTheme.onSurface,
          ),
          child: ColoredBox(
            color: theme.colorTheme.surface,
            // O `Overlay` é obrigatório, e a ausência dele era um defeito.
            //
            // O Flocks não monta `Overlay` em lugar nenhum — de propósito: quem
            // hospeda decide onde a camada flutuante vive. Os componentes que
            // precisam dela fazem `Overlay.of(context).insert(...)`, e a demo,
            // por não ter `MaterialApp`, não tinha quem a fornecesse. O efeito
            // era silencioso e visível em produção: tocar "Container style",
            // "Corner shape" ou "Typeface" no painel — dois dos três eixos que a
            // demo existe para o visitante mexer — não abria nada. Nem erro na
            // tela, nem no console: o `Overlay.of` não achava ancestral e o
            // gesto morria ali. O mesmo valia para os dropdowns de Plan e Status
            // do formulário, para o seletor de data e para a seleção de texto
            // dos campos.
            //
            // Uma entrada só, com o shell dentro: é o mínimo que `widgets.dart`
            // pede, e mantém a promessa de que não há Material aqui. O
            // `LayoutBuilder` fica DENTRO da entrada para continuar medindo o
            // viewport inteiro.
            //
            // O gate é `test/overlay_dependent_test.dart`, que abre cada um
            // desses controles e falha se algum voltar a morrer calado.
            child: Overlay(
              initialEntries: <OverlayEntry>[
                OverlayEntry(
                  builder: (BuildContext context) => LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) =>
                            constraints.maxWidth < kMinShellWidth
                            ? const _TooNarrow()
                            : _shell(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shell() => AppShell(
    // O rail nasce COLAPSADO, e a razão é aritmética: um rail
    // expandido de 232 px mais o painel de marca de 360 somam 592 px
    // de cromo, e num laptop de 1280 isso deixa a tabela do dashboard
    // sem largura para o próprio rodapé de paginação. A demo tem dois
    // destinos — o rótulo ao lado do ícone não paga 160 px. Quem
    // quiser vê-lo expandido tem o toggle flutuante que o próprio
    // componente traz.
    rail: SizedBox(
      width: 72,
      child: AppNavigationRail(
        initiallyCollapsed: true,
        getCurrentRoute: (BuildContext _) => _config.screen.name,
        items: <AppNavigationRailItemData>[
          AppNavigationRailItemData(
            icon: AppIconToken.dashboard,
            route: DemoScreen.dashboard.name,
            title: 'Dashboard',
            onPressed: (BuildContext _, String _) =>
                _update(_config.copyWith(screen: DemoScreen.dashboard)),
          ),
          AppNavigationRailItemData(
            icon: AppIconToken.group,
            route: DemoScreen.crud.name,
            title: 'Accounts',
            onPressed: (BuildContext _, String _) =>
                _update(_config.copyWith(screen: DemoScreen.crud)),
          ),
        ],
      ),
    ),
    header: _Header(logo: _logo, config: _config),
    aside: SizedBox(
      width: kPanelWidth,
      child: BrandPanel(
        config: _config,
        logo: _logo,
        logoError: _logoError,
        pickingLogo: _pickingLogo,
        shareUrl: shareUrl,
        onChanged: _update,
        onPickLogo: _pickLogo,
        onRemoveLogo: () => setState(() {
          _logo = null;
          _logoError = null;
        }),
      ),
    ),
    content: switch (_config.screen) {
      DemoScreen.dashboard => DashboardScreen(accounts: _accounts),
      DemoScreen.crud => CrudScreen(accounts: _accounts),
    },
  );

  /// Injeta um logo como se o visitante o tivesse escolhido.
  ///
  /// Entra pelo MESMO caminho da interface — bytes crus, formato farejado da
  /// assinatura —, então o que o teste exercita depois é o código de produção,
  /// e não um atalho que só existe no teste.
  @visibleForTesting
  void setLogoForTest(Uint8List bytes) => setState(() {
    final DemoLogoFormat? format = DemoLogo.sniffFormat(bytes);
    _logo = format == null ? null : DemoLogo(bytes: bytes, format: format);
  });

  /// Aplica uma mudança de configuração, como o painel faria.
  @visibleForTesting
  void updateForTest(DemoConfig Function(DemoConfig) change) =>
      _update(change(_config));

  /// Se há um logo carregado agora.
  @visibleForTesting
  bool get hasLogo => _logo != null;

  /// O link compartilhável — montado do estado, que não alcança o logo.
  String get shareUrl {
    final Uri base = widget.initialUri ?? Uri.base;
    return _config
        .toUri(
          base: base.replace(query: '', fragment: ''),
        )
        .toString();
  }

  /// Aplica uma configuração nova e reescreve a barra de endereço.
  ///
  /// A URL acompanha cada mexida, e é isso que faz "compartilhar" ser copiar a
  /// barra de endereço em vez de apertar um botão que gera um link.
  void _update(DemoConfig config) {
    setState(() => _config = config);
    replaceQuery(
      config.toUri(base: Uri(path: '')).toString().replaceFirst('?', ''),
    );
  }

  Future<void> _pickLogo() async {
    setState(() {
      _pickingLogo = true;
      _logoError = null;
    });
    final Uint8List? bytes = await pickImageBytes();
    if (!mounted) return;
    if (bytes == null) {
      setState(() => _pickingLogo = false);
      return;
    }
    final DemoLogoFormat? format = DemoLogo.sniffFormat(bytes);
    setState(() {
      _pickingLogo = false;
      if (format == null) {
        _logoError = 'That file is not a PNG, JPEG, WebP, GIF or SVG.';
        return;
      }
      _logo = DemoLogo(bytes: bytes, format: format);
    });
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.config, required this.logo});

  final DemoConfig config;
  final DemoLogo? logo;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s24,
        vertical: AppSpacings.s16,
      ),
      child: Row(
        children: <Widget>[
          // O logo do visitante vive aqui, desenhado dos bytes. O rail não
          // serve: os slots de logo dele são `String?` (um slug de asset), e
          // não há slug para uma imagem que nunca teve endereço.
          if (logo != null) ...<Widget>[
            logo!.build(height: 28, semanticLabel: 'Your logo'),
            const SizedBox(width: AppSpacings.s12),
            const SizedBox(height: 24, child: AppDivider.vertical()),
            const SizedBox(width: AppSpacings.s12),
          ],
          Expanded(
            child: AppText(
              switch (config.screen) {
                DemoScreen.dashboard => 'Overview',
                DemoScreen.crud => 'Accounts',
              },
              style: theme.textTheme.titleMedium.withColor(
                theme.colorTheme.onSurface,
              ),
            ),
          ),
          const AppBadge(
            'Flocks demo',
            color: AppBadgeColor.primary,
            size: AppBadgeSize.s,
          ),
        ],
      ),
    );
  }
}

/// O que a demo mostra quando a janela é estreita demais para o shell.
///
/// Uma mensagem curta, e não um layout espremido: ver a vitrine de um design
/// system com uma faixa de overflow atravessada custa mais do que não vê-la.
class _TooNarrow extends StatelessWidget {
  const _TooNarrow();

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.s32),
        child: SizedBox(
          width: 420,
          child: AppCard(
            // O único lugar da demo que NÃO segue o eixo de forma do visitante,
            // e de propósito: em `circular` o cartão vira uma pílula de raio
            // enorme e come as pontas do próprio texto. Este cartão não é parte
            // da demonstração — é a mensagem que explica por que ela não está
            // aparecendo, e precisa ser legível em qualquer configuração.
            radiusMode: AppRadiusMode.redondo,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppText(
                  'This demo needs a wider window',
                  style: theme.textTheme.titleMedium.withColor(
                    theme.colorTheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacings.s8),
                AppText(
                  'It shows a desktop workspace — a navigation rail, a content '
                  'card and a full-height brand panel, side by side. Open it on '
                  'a wider screen, or widen this window, to try it.',
                  style: theme.textTheme.bodySmall.withColor(
                    theme.colorTheme.neutralPrimary.s700,
                  ),
                ),
                const SizedBox(height: AppSpacings.s16),
                AppText(
                  'Flocks itself works on any size — this particular layout is '
                  'the one that does not.',
                  style: theme.textTheme.labelSmall.withColor(
                    theme.colorTheme.neutralPrimary.s600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
