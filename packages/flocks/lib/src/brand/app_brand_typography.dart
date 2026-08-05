import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../tokens/app_font_families.dart';

/// A tipografia da marca — a família de display e a de corpo.
///
/// Fecha a última lacuna do white-label: até aqui a marca controlava cor,
/// radius, movimento, estilo de container e glass, mas a família tipográfica
/// era fixa no pacote. "A marca inteira a partir de uma configuração" só é
/// verdade com isto.
///
/// Segue o molde dos outros eixos: `const` com defaults, [standard], `copyWith`
/// e `props`. Campo ausente cai no padrão do pacote — nenhuma marca existente
/// precisa declarar nada.
///
/// **A divisão:** [displayFamily] vale para `display*` e `headline*` (a voz da
/// marca); [bodyFamily] para `title*`, `body*` e `label*` (a interface). É a
/// separação usual entre fonte de título e fonte de texto.
///
/// **Sobre o `package`:** uma família empacotada com o Flutter é endereçada
/// como `packages/<pacote>/<família>`. Os dois campos de pacote existem porque
/// uma marca pode usar a Space Grotesk (que vem no `flocks`) na display e uma
/// fonte própria, declarada no `pubspec.yaml` do APP, no corpo — e a do app não
/// tem pacote. Nesse caso passe `bodyFontPackage: null`.
///
/// ```dart
/// // Space Grotesk (do flocks) na display, Poppins no corpo:
/// const AppBrandTypography(displayFamily: AppFontFamilies.spaceGrotesk)
///
/// // Fonte própria do app nos dois papéis:
/// const AppBrandTypography(
///   bodyFamily: 'Inter',
///   bodyFontPackage: null,
///   displayFamily: 'Inter',
///   displayFontPackage: null,
/// )
/// ```
///
/// Para trocar UM estilo isolado em vez da família inteira, o caminho é
/// `AppThemeData.copyWith(textTheme: theme.textTheme.copyWith(...))`.
@immutable
final class AppBrandTypography extends Equatable {
  /// Cria a tipografia da marca. Todo campo ausente cai no padrão do pacote.
  const AppBrandTypography({
    this.bodyFamily,
    this.bodyFontPackage = _packagedFonts,
    this.displayFamily,
    this.displayFontPackage = _packagedFonts,
  });

  /// O pacote que empacota [AppFontFamilies] — o default dos dois papéis.
  static const String _packagedFonts = 'flocks';

  /// Padrão do design system: Poppins nos dois papéis.
  static const AppBrandTypography standard = AppBrandTypography();

  /// Família de `title*`, `body*` e `label*`. Ausente → [AppFontFamilies.poppins].
  final String? bodyFamily;

  /// Pacote de [bodyFamily]. `null` para fonte declarada no próprio app.
  final String? bodyFontPackage;

  /// Família de `display*` e `headline*`. Ausente → cai em [bodyFamily].
  final String? displayFamily;

  /// Pacote de [displayFamily]. `null` para fonte declarada no próprio app.
  final String? displayFontPackage;

  /// A família de corpo efetiva. Ausente → [AppFontFamilies.poppins].
  String get effectiveBodyFamily => bodyFamily ?? AppFontFamilies.poppins;

  /// O pacote da família de corpo efetiva.
  ///
  /// Quando a marca não informou família, o padrão é a Poppins **do flocks** —
  /// então o pacote também tem de ser o do flocks, e não o que estiver em
  /// [bodyFontPackage]. Sem isso, uma marca que zera o pacote para usar fonte
  /// própria só no display quebraria o corpo junto.
  String? get effectiveBodyPackage =>
      bodyFamily == null ? _packagedFonts : bodyFontPackage;

  /// A família de display efetiva. Ausente → segue o corpo.
  String get effectiveDisplayFamily => displayFamily ?? effectiveBodyFamily;

  /// O pacote da família de display efetiva. Ausente, segue o do corpo — para
  /// que herdar a família não venha com um pacote de outra.
  String? get effectiveDisplayPackage =>
      displayFamily == null ? effectiveBodyPackage : displayFontPackage;

  /// Cópia com os campos informados sobrescritos.
  ///
  /// Os `bool` de limpeza existem porque `null` já significa "não informado":
  /// sem eles não haveria como voltar um pacote para `null` (fonte do app).
  AppBrandTypography copyWith({
    String? bodyFamily,
    String? bodyFontPackage,
    bool clearBodyFontPackage = false,
    bool clearDisplayFontPackage = false,
    String? displayFamily,
    String? displayFontPackage,
  }) => AppBrandTypography(
    bodyFamily: bodyFamily ?? this.bodyFamily,
    bodyFontPackage: clearBodyFontPackage
        ? null
        : (bodyFontPackage ?? this.bodyFontPackage),
    displayFamily: displayFamily ?? this.displayFamily,
    displayFontPackage: clearDisplayFontPackage
        ? null
        : (displayFontPackage ?? this.displayFontPackage),
  );

  @override
  List<Object?> get props => [
    bodyFamily,
    bodyFontPackage,
    displayFamily,
    displayFontPackage,
  ];
}
