import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Gerado por `dart run build_runner build`. Expõe `final directories`.
import 'main.directories.g.dart';

void main() => runApp(const FlocksWidgetbook());

/// Catálogo Widgetbook do design system Flocks.
///
/// O shell do catálogo usa [Widgetbook.material] (é tooling); os COMPONENTES do
/// design system continuam sem Material (garantido pelo teste de arquitetura).
/// Os addons alternam tema (claro/escuro × brand), radius global, escala de
/// texto e inspetor de semântica. O `ThemeAddon` também pinta o fundo do canvas
/// com o `surface` do tema — assim o frame acompanha claro/escuro.
@widgetbook.App()
class FlocksWidgetbook extends StatelessWidget {
  const FlocksWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        // 1º = mais externo (Nested). O AppTheme daqui é ancestral do RadiusAddon.
        ThemeAddon<AppThemeData>(
          themes: _themes(),
          themeBuilder: (context, theme, child) => AppTheme(
            data: theme,
            child: DefaultTextStyle(
              style: theme.textTheme.bodyMedium.withColor(
                theme.colorTheme.onSurface,
              ),
              child: ColoredBox(color: theme.colorTheme.surface, child: child),
            ),
          ),
        ),
        // Lê o AppTheme acima e sobrescreve o radius global.
        RadiusAddon(),
        // Lê o AppTheme acima e sobrescreve o estilo de container global.
        StyleAddon(),
        // Liga/desliga o eixo glass global (allow-list de overlays/barras/FAB).
        GlassAddon(),
        // Global de micro-interações (liga/desliga). Default: ligado.
        MotionAddon(),
        TextScaleAddon(min: 1.0, max: 2.0),
        // ignore: experimental_member_use
        SemanticsAddon(),
        InspectorAddon(),
      ],
    );
  }

  /// Pré-computa os 4 temas (marca × brilho). `AppThemeData.light/.dark` leem
  /// `AppBrand.current`, então trocamos a marca antes de capturar cada tema.
  static List<WidgetbookTheme<AppThemeData>> _themes() {
    AppBrand.setBrand(jotapeBrand);
    final jotapeLight = AppThemeData.light;
    final jotapeDark = AppThemeData.dark;
    AppBrand.setBrand(zxtrackBrand);
    final zxtrackLight = AppThemeData.light;
    final zxtrackDark = AppThemeData.dark;
    AppBrand.setBrand(jotapeBrand);
    return <WidgetbookTheme<AppThemeData>>[
      WidgetbookTheme(name: 'Jotape · Claro', data: jotapeLight),
      WidgetbookTheme(name: 'Jotape · Escuro', data: jotapeDark),
      WidgetbookTheme(name: 'ZX · Claro', data: zxtrackLight),
      WidgetbookTheme(name: 'ZX · Escuro', data: zxtrackDark),
    ];
  }
}

/// Addon global de radius: aplica um modo de forma ([AppRadiusMode]) a TODOS os
/// componentes, sobrescrevendo o `radiusTheme.mode` do tema ativo.
///
/// - **Reto**: cantos retos (0).
/// - **Circular**: círculo/pílula (metade do lado menor).
/// - **Redondo**: arredondamento proporcional ao tamanho (o "padrão" uniforme).
/// - **Padrão**: cada componente segue o seu próprio default (radio circular,
///   checkbox redondo…).
class RadiusAddon extends WidgetbookAddon<AppRadiusMode> {
  RadiusAddon() : super(name: 'Radius');

  static const List<(String, AppRadiusMode)> _presets = [
    ('Reto', AppRadiusMode.reto),
    ('Circular', AppRadiusMode.circular),
    ('Redondo', AppRadiusMode.redondo),
    ('Padrão', AppRadiusMode.padrao),
  ];

  @override
  List<Field> get fields => [
    ObjectDropdownField<AppRadiusMode>(
      name: 'preset',
      values: [for (final p in _presets) p.$2],
      initialValue: AppRadiusMode.padrao,
      labelBuilder: (value) => _presets
          .firstWhere((p) => p.$2 == value, orElse: () => ('Custom', value))
          .$1,
    ),
  ];

  @override
  AppRadiusMode valueFromQueryGroup(Map<String, String> group) {
    return valueOf<AppRadiusMode>('preset', group) ?? AppRadiusMode.padrao;
  }

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    AppRadiusMode setting,
  ) {
    return Builder(
      builder: (context) {
        final base = AppTheme.of(context);
        return AppTheme(
          data: base.copyWith(radiusTheme: AppRadiusTheme(mode: setting)),
          child: child,
        );
      },
    );
  }
}

/// Addon global de **estilo de container**: aplica um preset de
/// [AppStyle] (borda/fundo/sombra) a TODOS os componentes, sobrescrevendo o
/// `styleTheme` do tema ativo. Espelha o [RadiusAddon]. Default: `Filled`.
class StyleAddon extends WidgetbookAddon<AppStyleTheme> {
  StyleAddon() : super(name: 'Style');

  static const List<(String, AppStyleTheme)> _presets = [
    ('Filled', AppStyleTheme(style: AppStyle.filled)),
    ('Outlined', AppStyleTheme(style: AppStyle.outlined)),
    ('Elevated', AppStyleTheme(style: AppStyle.elevated)),
  ];

  @override
  List<Field> get fields => [
    ObjectDropdownField<AppStyleTheme>(
      name: 'preset',
      values: [for (final p in _presets) p.$2],
      initialValue: AppStyleTheme.standard,
      labelBuilder: (value) => _presets
          .firstWhere((p) => p.$2 == value, orElse: () => ('Custom', value))
          .$1,
    ),
  ];

  @override
  AppStyleTheme valueFromQueryGroup(Map<String, String> group) {
    return valueOf<AppStyleTheme>('preset', group) ?? AppStyleTheme.standard;
  }

  @override
  Widget buildUseCase(
    BuildContext context,
    Widget child,
    AppStyleTheme setting,
  ) {
    return Builder(
      builder: (context) {
        final base = AppTheme.of(context);
        return AppTheme(
          data: base.copyWith(styleTheme: setting),
          child: child,
        );
      },
    );
  }
}

/// Addon global do **eixo glass**: liga/desliga o "liquid glass" do design
/// system (o `AppGlassTheme` do tema). Espelha o [MotionAddon]. Default:
/// **desligado** (opt-in). Ligado ⇒ a allow-list de superfícies flutuantes
/// (overlays, barras, FAB, Menu/Popover) vira vidro; o resto ignora.
class GlassAddon extends WidgetbookAddon<bool> {
  GlassAddon() : super(name: 'Glass');

  static const List<(String, bool)> _presets = [
    ('Glass: Desligado', false),
    ('Glass: Ligado', true),
  ];

  @override
  List<Field> get fields => [
    ObjectDropdownField<bool>(
      name: 'enabled',
      values: [for (final p in _presets) p.$2],
      initialValue: false,
      labelBuilder: (value) => _presets
          .firstWhere((p) => p.$2 == value, orElse: () => ('Custom', value))
          .$1,
    ),
  ];

  @override
  bool valueFromQueryGroup(Map<String, String> group) =>
      valueOf<bool>('enabled', group) ?? false;

  @override
  Widget buildUseCase(BuildContext context, Widget child, bool setting) {
    return Builder(
      builder: (context) {
        final base = AppTheme.of(context);
        return AppTheme(
          data: base.copyWith(glassTheme: AppGlassTheme(enabled: setting)),
          child: child,
        );
      },
    );
  }
}

/// Addon global de **micro-interações**: liga/desliga as animações do design
/// system (o `AppAnimationTheme` do tema). Espelha o [RadiusAddon]. Default:
/// ligado. Desligado ⇒ tudo instantâneo (o reduce-motion do SO também vence,
/// independente daqui).
class MotionAddon extends WidgetbookAddon<bool> {
  MotionAddon() : super(name: 'Motion');

  static const List<(String, bool)> _presets = [
    ('Animações: Ligadas', true),
    ('Animações: Desligadas', false),
  ];

  @override
  List<Field> get fields => [
    ObjectDropdownField<bool>(
      name: 'enabled',
      values: [for (final p in _presets) p.$2],
      initialValue: true,
      labelBuilder: (value) => _presets
          .firstWhere((p) => p.$2 == value, orElse: () => ('Custom', value))
          .$1,
    ),
  ];

  @override
  bool valueFromQueryGroup(Map<String, String> group) =>
      valueOf<bool>('enabled', group) ?? true;

  @override
  Widget buildUseCase(BuildContext context, Widget child, bool setting) {
    return Builder(
      builder: (context) {
        final base = AppTheme.of(context);
        return AppTheme(
          data: base.copyWith(
            animationTheme: AppAnimationTheme(enabled: setting),
          ),
          child: child,
        );
      },
    );
  }
}
