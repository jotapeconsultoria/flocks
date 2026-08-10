import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../tokens/app_radius.dart';
import 'app_themes.dart';

/// Fração do lado menor usada pelo modo [AppRadiusMode.redondo]. `0.25` = 25%.
/// Mantém o arredondamento proporcional entre componentes de tamanhos
/// diferentes (um controle pequeno e um grande guardam a mesma "cara").
const double kRedondoFraction = 0.25;

/// Teto (px) do arredondamento [AppRadiusMode.redondo] — evita que caixas
/// grandes/content-sized fiquem exageradamente redondas. É o raio "padrão" no
/// qual botões, cards, superfícies e demais containers pousam. Tunável.
const double kRedondoCap = 12.0;

/// Valor grande usado por [AppRadiusMode.circular] quando o tamanho não é
/// conhecido: o Flutter satura o raio em metade do lado menor da caixa.
const double _circularSentinel = 9999.0;

/// Raios dedicados dos containers de **list-tiles** (linha avulsa, card de grupo
/// e envelope do expansion). O `circular` puro satura em metade do lado menor e
/// vira um oval gigante cujos cantos cortam o conteúdo (avatar, ícone leading,
/// chevron, texto); aqui ele pousa num raio pronunciado mas seguro. `redondo`/
/// `padrao` usam um raio próprio do tile (maior que o `kRedondoCap` global de
/// 12, mas discreto). Escala menor que as superfícies grandes. Tunáveis.
const double kTileRedondoRadius = 16.0;

/// Raio do tile no modo [AppRadiusMode.circular]. Ver [kTileRedondoRadius].
const double kTileCircularRadius = 32.0;

/// Raios dedicados das **superfícies grandes** (bottom sheet, side sheet,
/// dialog). Como no tile, o `circular` NÃO satura em oval: pousa num raio bem
/// pronunciado. `redondo`/`padrao` usam um raio próprio, maior que o do tile
/// (superfície maior comporta cantos maiores). Tunáveis.
const double kSurfaceRedondoRadius = 24.0;

/// Raio das superfícies grandes no modo [AppRadiusMode.circular]. Ver
/// [kSurfaceRedondoRadius].
const double kSurfaceCircularRadius = 48.0;

/// Resolve o [BorderRadius] de um componente a partir do eixo de forma
/// ([AppRadiusMode]) — função **pura**, testável sem render (padrão dos
/// resolvers do DS, ex.: `resolveStyleDecoration`).
///
/// - [mode]: o modo efetivo — geralmente `radiusMode ?? theme.radiusTheme.mode`
///   (override local vence o global).
/// - [componentDefault]: o modo natural do componente, usado quando [mode] é
///   [AppRadiusMode.padrao] (ex.: checkbox → [AppRadiusMode.redondo], radio →
///   [AppRadiusMode.circular]). **Nunca** passe [AppRadiusMode.padrao] aqui.
/// - [size]: tamanho renderizado do componente, quando conhecido. `null` para
///   componentes content-sized: `circular` vira pílula (via saturação do
///   Flutter) e `redondo` usa o teto [kRedondoCap].
BorderRadius appResolveRadius({
  required AppRadiusMode mode,
  required AppRadiusMode componentDefault,
  Size? size,
}) {
  final AppRadiusMode effective = mode == AppRadiusMode.padrao
      ? componentDefault
      : mode;
  final double? shortest = size?.shortestSide;
  final double r = switch (effective) {
    AppRadiusMode.reto => 0.0,
    AppRadiusMode.circular =>
      shortest != null ? shortest / 2 : _circularSentinel,
    AppRadiusMode.redondo =>
      shortest != null
          ? math.min(shortest * kRedondoFraction, kRedondoCap)
          : kRedondoCap,
    // Inalcançável (componentDefault nunca é padrao); fallback seguro = redondo.
    AppRadiusMode.padrao => kRedondoCap,
  };
  return BorderRadius.circular(r);
}

/// Açúcar de [appResolveRadius] sobre o eixo global ([AppRadiusTheme]).
extension AppRadiusThemeResolve on AppRadiusTheme {
  /// Resolve o [BorderRadius] deste eixo para um componente.
  ///
  /// - [componentDefault]: o modo natural do componente (usado quando o modo
  ///   ativo é [AppRadiusMode.padrao]). Default [AppRadiusMode.redondo] — a
  ///   maioria dos containers.
  /// - [size]: tamanho conhecido do componente (`null` = content-sized:
  ///   `circular`→pílula, `redondo`→teto [kRedondoCap]).
  /// - [override]: modo local (parâmetro `radiusMode:` do componente) que vence
  ///   o [mode] global.
  BorderRadius resolve({
    AppRadiusMode componentDefault = AppRadiusMode.redondo,
    Size? size,
    AppRadiusMode? override,
  }) => appResolveRadius(
    mode: override ?? mode,
    componentDefault: componentDefault,
    size: size,
  );

  /// Como [resolve], mas devolve o raio como `double` (para call sites que
  /// precisam de um número — aritmética, `Radius.circular`, etc.).
  double resolveRadius({
    AppRadiusMode componentDefault = AppRadiusMode.redondo,
    Size? size,
    AppRadiusMode? override,
  }) => resolve(
    componentDefault: componentDefault,
    size: size,
    override: override,
  ).topLeft.x;

  /// Modo de raio para contêineres de **dropdowns e pickers** (trigger, campo e
  /// painel flutuante): `circular` e `padrão` viram `redondo` — evita a
  /// pílula/círculo gigante que corta o conteúdo (o painel de opções ou o
  /// calendário). Só `reto` continua reto; `redondo` continua redondo. Passe o
  /// [override] local (`radiusMode:`) para clampá-lo também.
  AppRadiusMode containedMode([AppRadiusMode? override]) {
    final AppRadiusMode m = override ?? mode;
    return m == AppRadiusMode.reto ? AppRadiusMode.reto : AppRadiusMode.redondo;
  }

  /// Resolve o [BorderRadius] dos containers de **list-tiles** (linha avulsa,
  /// card de grupo, envelope do expansion). Diferente do [resolve] genérico,
  /// `circular` NÃO satura em metade do lado menor (o que viraria um oval
  /// gigante que corta o conteúdo perto dos cantos): pousa em
  /// [kTileCircularRadius] — pronunciado, mas seguro. `reto` = 0;
  /// `redondo`/`padrao` = [kTileRedondoRadius]. Passe o [override] local
  /// (`radiusMode:`) para vencer o global.
  BorderRadius tileRadius([AppRadiusMode? override]) {
    final AppRadiusMode m = override ?? mode;
    final double r = switch (m) {
      AppRadiusMode.reto => 0.0,
      AppRadiusMode.circular => kTileCircularRadius,
      AppRadiusMode.redondo || AppRadiusMode.padrao => kTileRedondoRadius,
    };
    return BorderRadius.circular(r);
  }

  /// Resolve o [BorderRadius] de um **container de superfície de tamanho livre**
  /// — o `AppCard` e quem o compõe. Fica ENTRE o [resolve] genérico e o
  /// [surfaceCornerRadius]:
  ///
  /// - `reto`/`redondo`/`padrao`: idêntico ao [resolve]. Um card pode ser
  ///   pequeno (um resumo de duas linhas) e não deve herdar o canto de um
  ///   bottom sheet.
  /// - `circular`: NÃO satura em metade do lado menor — pousa em
  ///   [kSurfaceCircularRadius]. É o modo em que um card alto (um gráfico de
  ///   400px) vira uma elipse cujo canto come o próprio título.
  ///
  /// Passe o [override] local (`radiusMode:`) para vencer o global.
  BorderRadius contentSurfaceRadius([AppRadiusMode? override]) {
    final AppRadiusMode m = override ?? mode;
    return m == AppRadiusMode.circular
        ? BorderRadius.circular(kSurfaceCircularRadius)
        : resolve(override: m);
  }

  /// Raio (px) das **superfícies grandes** (bottom sheet, side sheet, dialog).
  /// Mesma filosofia do [tileRadius] numa escala maior: `circular` não satura em
  /// oval — pousa em [kSurfaceCircularRadius]. `reto` = 0; `redondo`/`padrao` =
  /// [kSurfaceRedondoRadius]. Devolve `double` porque as superfícies compõem
  /// raios parciais/direcionais (cantos que achatam por progresso). Passe o
  /// [override] local (`radiusMode:`) para vencer o global.
  double surfaceCornerRadius([AppRadiusMode? override]) {
    final AppRadiusMode m = override ?? mode;
    return switch (m) {
      AppRadiusMode.reto => 0.0,
      AppRadiusMode.circular => kSurfaceCircularRadius,
      AppRadiusMode.redondo || AppRadiusMode.padrao => kSurfaceRedondoRadius,
    };
  }
}
