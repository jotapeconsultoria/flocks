import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/widgets.dart';

import '../foundation/icons/app_icon_provider.dart';
import '../foundation/illustrations/app_illustration_provider.dart';
import 'app_themes.dart';

/// Fornece o [AppTheme] resolvido para a árvore, reagindo ao [mode] escolhido
/// pelo usuário e ao brilho do sistema operacional (quando [AppThemeMode.system]).
///
/// Use no topo do app, acima do `WidgetsApp`. O [builder] recebe o
/// [AppThemeData] resolvido para configurar propriedades que precisam da cor
/// antes do tema estar disponível via context (ex.: `WidgetsApp.color`).
///
/// ```dart
/// AppThemeScope(
///   mode: themeController, // ValueListenable<AppThemeMode>
///   builder: (context, themeData) => WidgetsApp.router(
///     color: themeData.colorTheme.surface,
///     routerConfig: router,
///   ),
/// )
/// ```
class AppThemeScope extends StatefulWidget {
  const AppThemeScope({
    required this.mode,
    required this.builder,
    this.animations,
    this.iconProvider,
    this.illustrationProvider,
    super.key,
  });

  /// Modo de tema observável (claro/escuro/sistema).
  final ValueListenable<AppThemeMode> mode;

  /// Preferência global de micro-interações.
  final ValueListenable<bool>? animations;

  /// De onde os ícones vêm. `null` mantém o padrão do pacote (os 55 do
  /// contrato, embutidos, sem rede).
  ///
  /// É a costura por onde o APP escolhe o set — o `flocks` não pode declará-lo
  /// pela marca, porque um set grande mora em pacote irmão
  /// (`flocks_phosphor`, um adaptador de Material) e o core não depende deles.
  ///
  /// ```dart
  /// AppThemeScope(
  ///   iconProvider: const PhosphorIconProvider(weight: PhosphorWeight.bold),
  ///   builder: ...,
  /// )
  /// ```
  final AppIconProvider? iconProvider;

  /// De onde as ilustrações vêm. `null` mantém o padrão do pacote (o contrato,
  /// embutido, sem rede). Mesma costura do [iconProvider], pelo mesmo motivo.
  final AppIllustrationProvider? illustrationProvider;

  /// Constrói o filho com o [AppThemeData] resolvido para o brilho atual.
  final Widget Function(BuildContext context, AppThemeData themeData) builder;

  @override
  State<AppThemeScope> createState() => _AppThemeScopeState();
}

class _AppThemeScopeState extends State<AppThemeScope>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.mode.addListener(_onModeChanged);
    widget.animations?.addListener(_onModeChanged);
  }

  @override
  void didUpdateWidget(AppThemeScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) {
      oldWidget.mode.removeListener(_onModeChanged);
      widget.mode.addListener(_onModeChanged);
    }
    if (oldWidget.animations != widget.animations) {
      oldWidget.animations?.removeListener(_onModeChanged);
      widget.animations?.addListener(_onModeChanged);
    }
  }

  @override
  void dispose() {
    widget.mode.removeListener(_onModeChanged);
    widget.animations?.removeListener(_onModeChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onModeChanged() => setState(() {});

  @override
  void didChangePlatformBrightness() {
    // Só altera o resultado quando o modo segue o sistema; rebuild é barato.
    if (widget.mode.value == AppThemeMode.system) setState(() {});
  }

  AppBrightness get _systemBrightness =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark
      ? AppBrightness.dark
      : AppBrightness.light;

  AppThemeData _resolveThemeData() {
    final brightness = switch (widget.mode.value) {
      AppThemeMode.light => AppBrightness.light,
      AppThemeMode.dark => AppBrightness.dark,
      AppThemeMode.system => _systemBrightness,
    };
    final AppThemeData themeData = brightness == AppBrightness.dark
        ? AppThemeData.dark
        : AppThemeData.light;
    final bool? animations = widget.animations?.value;
    final AppIconProvider? iconProvider = widget.iconProvider;
    final AppIllustrationProvider? illustrationProvider =
        widget.illustrationProvider;
    return themeData.copyWith(
      animationTheme: animations == null
          ? null
          : AppAnimationTheme(enabled: animations),
      iconTheme: iconProvider == null
          ? null
          : AppIconTheme(provider: iconProvider),
      illustrationTheme: illustrationProvider == null
          ? null
          : AppIllustrationTheme(provider: illustrationProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = _resolveThemeData();
    return AppTheme(
      data: themeData,
      child: Builder(builder: (context) => widget.builder(context, themeData)),
    );
  }
}
