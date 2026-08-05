// GERADO por `dart run tool/generate_icons.dart`. Não edite à mão.
//
// Phosphor web v2.1.2 · core 33fb01d1

import 'package:flutter/widgets.dart';

import '../phosphor_duotone_icon_data.dart';

/// Os 1.512 ícones do Phosphor no peso `duotone`.
///
/// ```dart
/// const PhosphorDuotoneIcon(FlocksPhosphorDuotone.storefront)
/// ```
///
/// **Quase todo campo carrega DOIS codepoints**, não um: o duotone é o único
/// peso montado empilhando dois glifos. Ver [PhosphorDuotoneIconData] — é por
/// isso que o tipo aqui não é `IconData`: com um glifo só, o ícone sai pela
/// metade.
///
/// O par vem LIDO do CSS que o Phosphor publica ao lado da fonte, e não
/// calculado: `codepoint + 1` acerta 1.462 dos 1.512 e erra os outros. Dois
/// ícones têm camada única e saem sem `ground`.
///
/// Os `IconData` são constantes, e precisam ser: o `--tree-shake-icons` só
/// enxerga codepoint escrito como constante, e um calculado em execução sumiria
/// da fonte no build de release.
@staticIconProvider
abstract final class FlocksPhosphorDuotone {
  /// A família declarada no `pubspec` para este peso.
  static const String fontFamily = 'Phosphor-Duotone';

  /// O pacote que embute a fonte.
  static const String fontPackage = 'flocks_phosphor';

  /// `acorn`
  static const PhosphorDuotoneIconData acorn = PhosphorDuotoneIconData(
    figure: IconData(0xeb9b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb9a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `activity` — apelido de `pulse`
  static const PhosphorDuotoneIconData activity = PhosphorDuotoneIconData(
    figure: IconData(0xe001, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe000, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `address-book`
  static const PhosphorDuotoneIconData addressBook = PhosphorDuotoneIconData(
    figure: IconData(0xe6f9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6f8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `address-book-tabs`
  static const PhosphorDuotoneIconData
  addressBookTabs = PhosphorDuotoneIconData(
    figure: IconData(0xee4f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee4e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `air-traffic-control`
  static const PhosphorDuotoneIconData
  airTrafficControl = PhosphorDuotoneIconData(
    figure: IconData(0xecd9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecd8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `airplane`
  static const PhosphorDuotoneIconData airplane = PhosphorDuotoneIconData(
    figure: IconData(0xe003, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe002, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `airplane-in-flight`
  static const PhosphorDuotoneIconData
  airplaneInFlight = PhosphorDuotoneIconData(
    figure: IconData(0xe4ff, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4fe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `airplane-landing`
  static const PhosphorDuotoneIconData
  airplaneLanding = PhosphorDuotoneIconData(
    figure: IconData(0xe503, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe502, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `airplane-takeoff`
  static const PhosphorDuotoneIconData
  airplaneTakeoff = PhosphorDuotoneIconData(
    figure: IconData(0xe505, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe504, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `airplane-taxiing`
  static const PhosphorDuotoneIconData
  airplaneTaxiing = PhosphorDuotoneIconData(
    figure: IconData(0xe501, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe500, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `airplane-tilt`
  static const PhosphorDuotoneIconData airplaneTilt = PhosphorDuotoneIconData(
    figure: IconData(0xe5d7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5d6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `airplay`
  static const PhosphorDuotoneIconData airplay = PhosphorDuotoneIconData(
    figure: IconData(0xe005, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe004, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `alarm`
  static const PhosphorDuotoneIconData alarm = PhosphorDuotoneIconData(
    figure: IconData(0xe007, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe006, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `alien`
  static const PhosphorDuotoneIconData alien = PhosphorDuotoneIconData(
    figure: IconData(0xe8a7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8a6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-bottom`
  static const PhosphorDuotoneIconData alignBottom = PhosphorDuotoneIconData(
    figure: IconData(0xe507, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe506, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-bottom-simple`
  static const PhosphorDuotoneIconData
  alignBottomSimple = PhosphorDuotoneIconData(
    figure: IconData(0xeb0d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb0c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-center-horizontal`
  static const PhosphorDuotoneIconData
  alignCenterHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xe50b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe50a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-center-horizontal-simple`
  static const PhosphorDuotoneIconData
  alignCenterHorizontalSimple = PhosphorDuotoneIconData(
    figure: IconData(0xeb0f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb0e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-center-vertical`
  static const PhosphorDuotoneIconData
  alignCenterVertical = PhosphorDuotoneIconData(
    figure: IconData(0xe50d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe50c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-center-vertical-simple`
  static const PhosphorDuotoneIconData
  alignCenterVerticalSimple = PhosphorDuotoneIconData(
    figure: IconData(0xeb11, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb10, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-left`
  static const PhosphorDuotoneIconData alignLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe50f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe50e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-left-simple`
  static const PhosphorDuotoneIconData
  alignLeftSimple = PhosphorDuotoneIconData(
    figure: IconData(0xeaef, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaee, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-right`
  static const PhosphorDuotoneIconData alignRight = PhosphorDuotoneIconData(
    figure: IconData(0xe511, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe510, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-right-simple`
  static const PhosphorDuotoneIconData
  alignRightSimple = PhosphorDuotoneIconData(
    figure: IconData(0xeb13, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb12, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-top`
  static const PhosphorDuotoneIconData alignTop = PhosphorDuotoneIconData(
    figure: IconData(0xe513, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe512, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `align-top-simple`
  static const PhosphorDuotoneIconData alignTopSimple = PhosphorDuotoneIconData(
    figure: IconData(0xeb15, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb14, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `amazon-logo`
  static const PhosphorDuotoneIconData amazonLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe96d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe96c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ambulance`
  static const PhosphorDuotoneIconData ambulance = PhosphorDuotoneIconData(
    figure: IconData(0xe573, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe572, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `anchor`
  static const PhosphorDuotoneIconData anchor = PhosphorDuotoneIconData(
    figure: IconData(0xe515, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe514, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `anchor-simple`
  static const PhosphorDuotoneIconData anchorSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe5d9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5d8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `android-logo`
  static const PhosphorDuotoneIconData androidLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe009, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe008, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `angle`
  static const PhosphorDuotoneIconData angle = PhosphorDuotoneIconData(
    figure: IconData(0xe7bd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7bc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `angular-logo`
  static const PhosphorDuotoneIconData angularLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeb81, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb80, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `aperture`
  static const PhosphorDuotoneIconData aperture = PhosphorDuotoneIconData(
    figure: IconData(0xe00b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe00a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `app-store-logo`
  static const PhosphorDuotoneIconData appStoreLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe975, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe974, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `app-window`
  static const PhosphorDuotoneIconData appWindow = PhosphorDuotoneIconData(
    figure: IconData(0xe5db, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5da, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `apple-logo`
  static const PhosphorDuotoneIconData appleLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe517, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe516, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `apple-podcasts-logo`
  static const PhosphorDuotoneIconData
  applePodcastsLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeb97, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb96, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `approximate-equals`
  static const PhosphorDuotoneIconData
  approximateEquals = PhosphorDuotoneIconData(
    figure: IconData(0xedab, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedaa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `archive`
  static const PhosphorDuotoneIconData archive = PhosphorDuotoneIconData(
    figure: IconData(0xe00d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe00c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `archive-box` — apelido de `box-arrow-down`
  static const PhosphorDuotoneIconData archiveBox = PhosphorDuotoneIconData(
    figure: IconData(0xe00f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe00e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `archive-tray` — apelido de `tray-arrow-down`
  static const PhosphorDuotoneIconData archiveTray = PhosphorDuotoneIconData(
    figure: IconData(0xe011, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe010, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `armchair`
  static const PhosphorDuotoneIconData armchair = PhosphorDuotoneIconData(
    figure: IconData(0xe013, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe012, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-arc-left`
  static const PhosphorDuotoneIconData arrowArcLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe015, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe014, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-arc-right`
  static const PhosphorDuotoneIconData arrowArcRight = PhosphorDuotoneIconData(
    figure: IconData(0xe017, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe016, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-bend-double-up-left`
  static const PhosphorDuotoneIconData
  arrowBendDoubleUpLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe03b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe03a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-bend-double-up-right`
  static const PhosphorDuotoneIconData
  arrowBendDoubleUpRight = PhosphorDuotoneIconData(
    figure: IconData(0xe03d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe03c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-bend-down-left`
  static const PhosphorDuotoneIconData
  arrowBendDownLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe019, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe018, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-bend-down-right`
  static const PhosphorDuotoneIconData
  arrowBendDownRight = PhosphorDuotoneIconData(
    figure: IconData(0xe01b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe01a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-bend-left-down`
  static const PhosphorDuotoneIconData
  arrowBendLeftDown = PhosphorDuotoneIconData(
    figure: IconData(0xe01d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe01c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-bend-left-up`
  static const PhosphorDuotoneIconData
  arrowBendLeftUp = PhosphorDuotoneIconData(
    figure: IconData(0xe01f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe01e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-bend-right-down`
  static const PhosphorDuotoneIconData
  arrowBendRightDown = PhosphorDuotoneIconData(
    figure: IconData(0xe021, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe020, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-bend-right-up`
  static const PhosphorDuotoneIconData
  arrowBendRightUp = PhosphorDuotoneIconData(
    figure: IconData(0xe023, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe022, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-bend-up-left`
  static const PhosphorDuotoneIconData
  arrowBendUpLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe025, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe024, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-bend-up-right`
  static const PhosphorDuotoneIconData
  arrowBendUpRight = PhosphorDuotoneIconData(
    figure: IconData(0xe027, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe026, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-circle-down`
  static const PhosphorDuotoneIconData
  arrowCircleDown = PhosphorDuotoneIconData(
    figure: IconData(0xe029, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe028, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-circle-down-left`
  static const PhosphorDuotoneIconData
  arrowCircleDownLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe02b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe02a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-circle-down-right`
  static const PhosphorDuotoneIconData
  arrowCircleDownRight = PhosphorDuotoneIconData(
    figure: IconData(0xe02d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe02c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-circle-left`
  static const PhosphorDuotoneIconData
  arrowCircleLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe05b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe05a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-circle-right`
  static const PhosphorDuotoneIconData
  arrowCircleRight = PhosphorDuotoneIconData(
    figure: IconData(0xe02f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe02e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-circle-up`
  static const PhosphorDuotoneIconData arrowCircleUp = PhosphorDuotoneIconData(
    figure: IconData(0xe031, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe030, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-circle-up-left`
  static const PhosphorDuotoneIconData
  arrowCircleUpLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe033, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe032, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-circle-up-right`
  static const PhosphorDuotoneIconData
  arrowCircleUpRight = PhosphorDuotoneIconData(
    figure: IconData(0xe035, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe034, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-clockwise`
  static const PhosphorDuotoneIconData arrowClockwise = PhosphorDuotoneIconData(
    figure: IconData(0xe037, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe036, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-counter-clockwise`
  static const PhosphorDuotoneIconData
  arrowCounterClockwise = PhosphorDuotoneIconData(
    figure: IconData(0xe039, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe038, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-down`
  static const PhosphorDuotoneIconData arrowDown = PhosphorDuotoneIconData(
    figure: IconData(0xe03f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe03e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-down-left`
  static const PhosphorDuotoneIconData arrowDownLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe041, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe040, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-down-right`
  static const PhosphorDuotoneIconData arrowDownRight = PhosphorDuotoneIconData(
    figure: IconData(0xe043, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe042, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-elbow-down-left`
  static const PhosphorDuotoneIconData
  arrowElbowDownLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe045, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe044, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-elbow-down-right`
  static const PhosphorDuotoneIconData
  arrowElbowDownRight = PhosphorDuotoneIconData(
    figure: IconData(0xe047, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe046, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-elbow-left`
  static const PhosphorDuotoneIconData arrowElbowLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe049, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe048, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-elbow-left-down`
  static const PhosphorDuotoneIconData
  arrowElbowLeftDown = PhosphorDuotoneIconData(
    figure: IconData(0xe04b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe04a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-elbow-left-up`
  static const PhosphorDuotoneIconData
  arrowElbowLeftUp = PhosphorDuotoneIconData(
    figure: IconData(0xe04d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe04c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-elbow-right`
  static const PhosphorDuotoneIconData
  arrowElbowRight = PhosphorDuotoneIconData(
    figure: IconData(0xe04f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe04e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-elbow-right-down`
  static const PhosphorDuotoneIconData
  arrowElbowRightDown = PhosphorDuotoneIconData(
    figure: IconData(0xe051, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe050, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-elbow-right-up`
  static const PhosphorDuotoneIconData
  arrowElbowRightUp = PhosphorDuotoneIconData(
    figure: IconData(0xe053, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe052, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-elbow-up-left`
  static const PhosphorDuotoneIconData
  arrowElbowUpLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe055, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe054, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-elbow-up-right`
  static const PhosphorDuotoneIconData
  arrowElbowUpRight = PhosphorDuotoneIconData(
    figure: IconData(0xe057, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe056, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-down`
  static const PhosphorDuotoneIconData arrowFatDown = PhosphorDuotoneIconData(
    figure: IconData(0xe519, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe518, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-left`
  static const PhosphorDuotoneIconData arrowFatLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe51b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe51a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-line-down`
  static const PhosphorDuotoneIconData
  arrowFatLineDown = PhosphorDuotoneIconData(
    figure: IconData(0xe51d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe51c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-line-left`
  static const PhosphorDuotoneIconData
  arrowFatLineLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe51f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe51e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-line-right`
  static const PhosphorDuotoneIconData
  arrowFatLineRight = PhosphorDuotoneIconData(
    figure: IconData(0xe521, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe520, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-line-up`
  static const PhosphorDuotoneIconData arrowFatLineUp = PhosphorDuotoneIconData(
    figure: IconData(0xe523, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe522, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-lines-down`
  static const PhosphorDuotoneIconData
  arrowFatLinesDown = PhosphorDuotoneIconData(
    figure: IconData(0xe525, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe524, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-lines-left`
  static const PhosphorDuotoneIconData
  arrowFatLinesLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe527, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe526, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-lines-right`
  static const PhosphorDuotoneIconData
  arrowFatLinesRight = PhosphorDuotoneIconData(
    figure: IconData(0xe529, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe528, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-lines-up`
  static const PhosphorDuotoneIconData
  arrowFatLinesUp = PhosphorDuotoneIconData(
    figure: IconData(0xe52b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe52a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-right`
  static const PhosphorDuotoneIconData arrowFatRight = PhosphorDuotoneIconData(
    figure: IconData(0xe52d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe52c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-fat-up`
  static const PhosphorDuotoneIconData arrowFatUp = PhosphorDuotoneIconData(
    figure: IconData(0xe52f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe52e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-left`
  static const PhosphorDuotoneIconData arrowLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe059, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe058, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-line-down`
  static const PhosphorDuotoneIconData arrowLineDown = PhosphorDuotoneIconData(
    figure: IconData(0xe05d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe05c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-line-down-left`
  static const PhosphorDuotoneIconData
  arrowLineDownLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe05f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe05e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-line-down-right`
  static const PhosphorDuotoneIconData
  arrowLineDownRight = PhosphorDuotoneIconData(
    figure: IconData(0xe061, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe060, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-line-left`
  static const PhosphorDuotoneIconData arrowLineLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe063, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe062, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-line-right`
  static const PhosphorDuotoneIconData arrowLineRight = PhosphorDuotoneIconData(
    figure: IconData(0xe065, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe064, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-line-up`
  static const PhosphorDuotoneIconData arrowLineUp = PhosphorDuotoneIconData(
    figure: IconData(0xe067, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe066, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-line-up-left`
  static const PhosphorDuotoneIconData
  arrowLineUpLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe069, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe068, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-line-up-right`
  static const PhosphorDuotoneIconData
  arrowLineUpRight = PhosphorDuotoneIconData(
    figure: IconData(0xe06b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe06a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-right`
  static const PhosphorDuotoneIconData arrowRight = PhosphorDuotoneIconData(
    figure: IconData(0xe06d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe06c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-square-down`
  static const PhosphorDuotoneIconData
  arrowSquareDown = PhosphorDuotoneIconData(
    figure: IconData(0xe06f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe06e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-square-down-left`
  static const PhosphorDuotoneIconData
  arrowSquareDownLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe071, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe070, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-square-down-right`
  static const PhosphorDuotoneIconData
  arrowSquareDownRight = PhosphorDuotoneIconData(
    figure: IconData(0xe073, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe072, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-square-in`
  static const PhosphorDuotoneIconData arrowSquareIn = PhosphorDuotoneIconData(
    figure: IconData(0xe5dd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5dc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-square-left`
  static const PhosphorDuotoneIconData
  arrowSquareLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe075, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe074, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-square-out`
  static const PhosphorDuotoneIconData arrowSquareOut = PhosphorDuotoneIconData(
    figure: IconData(0xe5df, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5de, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-square-right`
  static const PhosphorDuotoneIconData
  arrowSquareRight = PhosphorDuotoneIconData(
    figure: IconData(0xe077, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe076, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-square-up`
  static const PhosphorDuotoneIconData arrowSquareUp = PhosphorDuotoneIconData(
    figure: IconData(0xe079, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe078, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-square-up-left`
  static const PhosphorDuotoneIconData
  arrowSquareUpLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe07b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe07a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-square-up-right`
  static const PhosphorDuotoneIconData
  arrowSquareUpRight = PhosphorDuotoneIconData(
    figure: IconData(0xe07d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe07c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-u-down-left`
  static const PhosphorDuotoneIconData arrowUDownLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe07f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe07e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-u-down-right`
  static const PhosphorDuotoneIconData
  arrowUDownRight = PhosphorDuotoneIconData(
    figure: IconData(0xe081, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe080, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-u-left-down`
  static const PhosphorDuotoneIconData arrowULeftDown = PhosphorDuotoneIconData(
    figure: IconData(0xe083, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe082, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-u-left-up`
  static const PhosphorDuotoneIconData arrowULeftUp = PhosphorDuotoneIconData(
    figure: IconData(0xe085, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe084, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-u-right-down`
  static const PhosphorDuotoneIconData
  arrowURightDown = PhosphorDuotoneIconData(
    figure: IconData(0xe087, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe086, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-u-right-up`
  static const PhosphorDuotoneIconData arrowURightUp = PhosphorDuotoneIconData(
    figure: IconData(0xe089, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe088, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-u-up-left`
  static const PhosphorDuotoneIconData arrowUUpLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe08b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe08a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-u-up-right`
  static const PhosphorDuotoneIconData arrowUUpRight = PhosphorDuotoneIconData(
    figure: IconData(0xe08d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe08c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-up`
  static const PhosphorDuotoneIconData arrowUp = PhosphorDuotoneIconData(
    figure: IconData(0xe08f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe08e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-up-left`
  static const PhosphorDuotoneIconData arrowUpLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe091, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe090, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrow-up-right`
  static const PhosphorDuotoneIconData arrowUpRight = PhosphorDuotoneIconData(
    figure: IconData(0xe093, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe092, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-clockwise`
  static const PhosphorDuotoneIconData
  arrowsClockwise = PhosphorDuotoneIconData(
    figure: IconData(0xe095, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe094, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-counter-clockwise`
  static const PhosphorDuotoneIconData
  arrowsCounterClockwise = PhosphorDuotoneIconData(
    figure: IconData(0xe097, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe096, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-down-up`
  static const PhosphorDuotoneIconData arrowsDownUp = PhosphorDuotoneIconData(
    figure: IconData(0xe099, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe098, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-horizontal`
  static const PhosphorDuotoneIconData
  arrowsHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xeb07, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb06, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-in`
  static const PhosphorDuotoneIconData arrowsIn = PhosphorDuotoneIconData(
    figure: IconData(0xe09b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe09a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-in-cardinal`
  static const PhosphorDuotoneIconData
  arrowsInCardinal = PhosphorDuotoneIconData(
    figure: IconData(0xe09d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe09c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-in-line-horizontal`
  static const PhosphorDuotoneIconData
  arrowsInLineHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xe531, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe530, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-in-line-vertical`
  static const PhosphorDuotoneIconData
  arrowsInLineVertical = PhosphorDuotoneIconData(
    figure: IconData(0xe533, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe532, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-in-simple`
  static const PhosphorDuotoneIconData arrowsInSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe09f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe09e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-left-right`
  static const PhosphorDuotoneIconData
  arrowsLeftRight = PhosphorDuotoneIconData(
    figure: IconData(0xe0a1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0a0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-merge`
  static const PhosphorDuotoneIconData arrowsMerge = PhosphorDuotoneIconData(
    figure: IconData(0xed3f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed3e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-out`
  static const PhosphorDuotoneIconData arrowsOut = PhosphorDuotoneIconData(
    figure: IconData(0xe0a3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0a2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-out-cardinal`
  static const PhosphorDuotoneIconData
  arrowsOutCardinal = PhosphorDuotoneIconData(
    figure: IconData(0xe0a5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0a4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-out-line-horizontal`
  static const PhosphorDuotoneIconData
  arrowsOutLineHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xe535, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe534, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-out-line-vertical`
  static const PhosphorDuotoneIconData
  arrowsOutLineVertical = PhosphorDuotoneIconData(
    figure: IconData(0xe537, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe536, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-out-simple`
  static const PhosphorDuotoneIconData
  arrowsOutSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe0a7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0a6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-split`
  static const PhosphorDuotoneIconData arrowsSplit = PhosphorDuotoneIconData(
    figure: IconData(0xed3d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed3c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `arrows-vertical`
  static const PhosphorDuotoneIconData arrowsVertical = PhosphorDuotoneIconData(
    figure: IconData(0xeb05, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb04, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `article`
  static const PhosphorDuotoneIconData article = PhosphorDuotoneIconData(
    figure: IconData(0xe0a9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0a8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `article-medium`
  static const PhosphorDuotoneIconData articleMedium = PhosphorDuotoneIconData(
    figure: IconData(0xe5e1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5e0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `article-ny-times`
  static const PhosphorDuotoneIconData articleNyTimes = PhosphorDuotoneIconData(
    figure: IconData(0xe5e3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5e2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `asclepius`
  static const PhosphorDuotoneIconData asclepius = PhosphorDuotoneIconData(
    figure: IconData(0xee35, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee34, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `asterisk`
  static const PhosphorDuotoneIconData asterisk = PhosphorDuotoneIconData(
    figure: IconData(0xe0ab, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0aa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `asterisk-simple`
  static const PhosphorDuotoneIconData asteriskSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe833, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe832, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `at`
  static const PhosphorDuotoneIconData at = PhosphorDuotoneIconData(
    figure: IconData(0xe0ad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0ac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `atom`
  static const PhosphorDuotoneIconData atom = PhosphorDuotoneIconData(
    figure: IconData(0xe5e5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5e4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `avocado`
  static const PhosphorDuotoneIconData avocado = PhosphorDuotoneIconData(
    figure: IconData(0xee05, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee04, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `axe`
  static const PhosphorDuotoneIconData axe = PhosphorDuotoneIconData(
    figure: IconData(0xe9fd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9fc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `baby`
  static const PhosphorDuotoneIconData baby = PhosphorDuotoneIconData(
    figure: IconData(0xe775, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe774, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `baby-carriage`
  static const PhosphorDuotoneIconData babyCarriage = PhosphorDuotoneIconData(
    figure: IconData(0xe819, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe818, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `backpack`
  static const PhosphorDuotoneIconData backpack = PhosphorDuotoneIconData(
    figure: IconData(0xe923, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe922, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `backspace`
  static const PhosphorDuotoneIconData backspace = PhosphorDuotoneIconData(
    figure: IconData(0xe0af, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0ae, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bag`
  static const PhosphorDuotoneIconData bag = PhosphorDuotoneIconData(
    figure: IconData(0xe0b1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0b0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bag-simple`
  static const PhosphorDuotoneIconData bagSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe5e7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5e6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `balloon`
  static const PhosphorDuotoneIconData balloon = PhosphorDuotoneIconData(
    figure: IconData(0xe76d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe76c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bandaids`
  static const PhosphorDuotoneIconData bandaids = PhosphorDuotoneIconData(
    figure: IconData(0xe0b3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0b2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bank`
  static const PhosphorDuotoneIconData bank = PhosphorDuotoneIconData(
    figure: IconData(0xe0b5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0b4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `barbell`
  static const PhosphorDuotoneIconData barbell = PhosphorDuotoneIconData(
    figure: IconData(0xe0b7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0b6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `barcode`
  static const PhosphorDuotoneIconData barcode = PhosphorDuotoneIconData(
    figure: IconData(0xe0b9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0b8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `barn`
  static const PhosphorDuotoneIconData barn = PhosphorDuotoneIconData(
    figure: IconData(0xec73, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec72, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `barricade`
  static const PhosphorDuotoneIconData barricade = PhosphorDuotoneIconData(
    figure: IconData(0xe949, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe948, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `baseball`
  static const PhosphorDuotoneIconData baseball = PhosphorDuotoneIconData(
    figure: IconData(0xe71b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe71a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `baseball-cap`
  static const PhosphorDuotoneIconData baseballCap = PhosphorDuotoneIconData(
    figure: IconData(0xea29, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea28, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `baseball-helmet`
  static const PhosphorDuotoneIconData baseballHelmet = PhosphorDuotoneIconData(
    figure: IconData(0xee4b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee4a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `basket`
  static const PhosphorDuotoneIconData basket = PhosphorDuotoneIconData(
    figure: IconData(0xe965, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe964, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `basketball`
  static const PhosphorDuotoneIconData basketball = PhosphorDuotoneIconData(
    figure: IconData(0xe725, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe724, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bathtub`
  static const PhosphorDuotoneIconData bathtub = PhosphorDuotoneIconData(
    figure: IconData(0xe81f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe81e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-charging`
  static const PhosphorDuotoneIconData
  batteryCharging = PhosphorDuotoneIconData(
    figure: IconData(0xe0bb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0ba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-charging-vertical`
  static const PhosphorDuotoneIconData
  batteryChargingVertical = PhosphorDuotoneIconData(
    figure: IconData(0xe0bd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0bc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-empty`
  static const PhosphorDuotoneIconData batteryEmpty = PhosphorDuotoneIconData(
    figure: IconData(0xe0bf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0be, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-full`
  static const PhosphorDuotoneIconData batteryFull = PhosphorDuotoneIconData(
    figure: IconData(0xe0c1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0c0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-high`
  static const PhosphorDuotoneIconData batteryHigh = PhosphorDuotoneIconData(
    figure: IconData(0xe0c3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0c2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-low`
  static const PhosphorDuotoneIconData batteryLow = PhosphorDuotoneIconData(
    figure: IconData(0xe0c5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0c4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-medium`
  static const PhosphorDuotoneIconData batteryMedium = PhosphorDuotoneIconData(
    figure: IconData(0xe0c7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0c6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-plus`
  static const PhosphorDuotoneIconData batteryPlus = PhosphorDuotoneIconData(
    figure: IconData(0xe809, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe808, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-plus-vertical`
  static const PhosphorDuotoneIconData
  batteryPlusVertical = PhosphorDuotoneIconData(
    figure: IconData(0xec51, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec50, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-vertical-empty`
  static const PhosphorDuotoneIconData
  batteryVerticalEmpty = PhosphorDuotoneIconData(
    figure: IconData(0xe7c7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7c6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-vertical-full`
  static const PhosphorDuotoneIconData
  batteryVerticalFull = PhosphorDuotoneIconData(
    figure: IconData(0xe7c5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7c4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-vertical-high`
  static const PhosphorDuotoneIconData
  batteryVerticalHigh = PhosphorDuotoneIconData(
    figure: IconData(0xe7c3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7c2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-vertical-low`
  static const PhosphorDuotoneIconData
  batteryVerticalLow = PhosphorDuotoneIconData(
    figure: IconData(0xe7bf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7be, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-vertical-medium`
  static const PhosphorDuotoneIconData
  batteryVerticalMedium = PhosphorDuotoneIconData(
    figure: IconData(0xe7c1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7c0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-warning`
  static const PhosphorDuotoneIconData batteryWarning = PhosphorDuotoneIconData(
    figure: IconData(0xe0c9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0c8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `battery-warning-vertical`
  static const PhosphorDuotoneIconData
  batteryWarningVertical = PhosphorDuotoneIconData(
    figure: IconData(0xe0cb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0ca, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `beach-ball`
  static const PhosphorDuotoneIconData beachBall = PhosphorDuotoneIconData(
    figure: IconData(0xed25, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed24, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `beanie`
  static const PhosphorDuotoneIconData beanie = PhosphorDuotoneIconData(
    figure: IconData(0xea2b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea2a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bed`
  static const PhosphorDuotoneIconData bed = PhosphorDuotoneIconData(
    figure: IconData(0xe0cd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0cc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `beer-bottle`
  static const PhosphorDuotoneIconData beerBottle = PhosphorDuotoneIconData(
    figure: IconData(0xe7b1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7b0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `beer-stein`
  static const PhosphorDuotoneIconData beerStein = PhosphorDuotoneIconData(
    figure: IconData(0xeb63, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb62, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `behance-logo`
  static const PhosphorDuotoneIconData behanceLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe7f5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7f4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bell`
  static const PhosphorDuotoneIconData bell = PhosphorDuotoneIconData(
    figure: IconData(0xe0cf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0ce, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bell-ringing`
  static const PhosphorDuotoneIconData bellRinging = PhosphorDuotoneIconData(
    figure: IconData(0xe5e9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5e8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bell-simple`
  static const PhosphorDuotoneIconData bellSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe0d1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0d0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bell-simple-ringing`
  static const PhosphorDuotoneIconData
  bellSimpleRinging = PhosphorDuotoneIconData(
    figure: IconData(0xe5eb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5ea, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bell-simple-slash`
  static const PhosphorDuotoneIconData
  bellSimpleSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe0d3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0d2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bell-simple-z`
  static const PhosphorDuotoneIconData bellSimpleZ = PhosphorDuotoneIconData(
    figure: IconData(0xe5ed, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5ec, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bell-slash`
  static const PhosphorDuotoneIconData bellSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe0d5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0d4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bell-z`
  static const PhosphorDuotoneIconData bellZ = PhosphorDuotoneIconData(
    figure: IconData(0xe5ef, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5ee, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `belt`
  static const PhosphorDuotoneIconData belt = PhosphorDuotoneIconData(
    figure: IconData(0xea2d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea2c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bezier-curve`
  static const PhosphorDuotoneIconData bezierCurve = PhosphorDuotoneIconData(
    figure: IconData(0xeb01, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb00, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bicycle`
  static const PhosphorDuotoneIconData bicycle = PhosphorDuotoneIconData(
    figure: IconData(0xe0d7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0d6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `binary`
  static const PhosphorDuotoneIconData binary = PhosphorDuotoneIconData(
    figure: IconData(0xee61, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee60, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `binoculars`
  static const PhosphorDuotoneIconData binoculars = PhosphorDuotoneIconData(
    figure: IconData(0xea65, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea64, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `biohazard`
  static const PhosphorDuotoneIconData biohazard = PhosphorDuotoneIconData(
    figure: IconData(0xe9e1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9e0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bird`
  static const PhosphorDuotoneIconData bird = PhosphorDuotoneIconData(
    figure: IconData(0xe72d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe72c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `blueprint`
  static const PhosphorDuotoneIconData blueprint = PhosphorDuotoneIconData(
    figure: IconData(0xeda1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeda0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bluetooth`
  static const PhosphorDuotoneIconData bluetooth = PhosphorDuotoneIconData(
    figure: IconData(0xe0db, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0da, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bluetooth-connected`
  static const PhosphorDuotoneIconData
  bluetoothConnected = PhosphorDuotoneIconData(
    figure: IconData(0xe0dd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0dc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bluetooth-slash`
  static const PhosphorDuotoneIconData bluetoothSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe0df, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0de, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bluetooth-x`
  static const PhosphorDuotoneIconData bluetoothX = PhosphorDuotoneIconData(
    figure: IconData(0xe0e1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0e0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `boat`
  static const PhosphorDuotoneIconData boat = PhosphorDuotoneIconData(
    figure: IconData(0xe787, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe786, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bomb`
  static const PhosphorDuotoneIconData bomb = PhosphorDuotoneIconData(
    figure: IconData(0xee0b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee0a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bone`
  static const PhosphorDuotoneIconData bone = PhosphorDuotoneIconData(
    figure: IconData(0xe7f3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7f2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `book`
  static const PhosphorDuotoneIconData book = PhosphorDuotoneIconData(
    figure: IconData(0xe0e3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0e2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `book-bookmark`
  static const PhosphorDuotoneIconData bookBookmark = PhosphorDuotoneIconData(
    figure: IconData(0xe0e5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0e4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `book-open`
  static const PhosphorDuotoneIconData bookOpen = PhosphorDuotoneIconData(
    figure: IconData(0xe0e7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0e6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `book-open-text`
  static const PhosphorDuotoneIconData bookOpenText = PhosphorDuotoneIconData(
    figure: IconData(0xe8f3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8f2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `book-open-user`
  static const PhosphorDuotoneIconData bookOpenUser = PhosphorDuotoneIconData(
    figure: IconData(0xede1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xede0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bookmark`
  static const PhosphorDuotoneIconData bookmark = PhosphorDuotoneIconData(
    figure: IconData(0xe0e9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0e8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bookmark-simple`
  static const PhosphorDuotoneIconData bookmarkSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe0eb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0ea, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bookmarks`
  static const PhosphorDuotoneIconData bookmarks = PhosphorDuotoneIconData(
    figure: IconData(0xe0ed, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0ec, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bookmarks-simple`
  static const PhosphorDuotoneIconData
  bookmarksSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe5f1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5f0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `books`
  static const PhosphorDuotoneIconData books = PhosphorDuotoneIconData(
    figure: IconData(0xe759, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe758, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `boot`
  static const PhosphorDuotoneIconData boot = PhosphorDuotoneIconData(
    figure: IconData(0xeccb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecca, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `boules`
  static const PhosphorDuotoneIconData boules = PhosphorDuotoneIconData(
    figure: IconData(0xe723, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe722, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bounding-box`
  static const PhosphorDuotoneIconData boundingBox = PhosphorDuotoneIconData(
    figure: IconData(0xe6cf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6ce, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bowl-food`
  static const PhosphorDuotoneIconData bowlFood = PhosphorDuotoneIconData(
    figure: IconData(0xeaa5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaa4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bowl-steam`
  static const PhosphorDuotoneIconData bowlSteam = PhosphorDuotoneIconData(
    figure: IconData(0xe8e5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8e4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bowling-ball`
  static const PhosphorDuotoneIconData bowlingBall = PhosphorDuotoneIconData(
    figure: IconData(0xea35, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea34, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `box-arrow-down`
  static const PhosphorDuotoneIconData boxArrowDown = PhosphorDuotoneIconData(
    figure: IconData(0xe00f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe00e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `box-arrow-up`
  static const PhosphorDuotoneIconData boxArrowUp = PhosphorDuotoneIconData(
    figure: IconData(0xee55, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee54, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `boxing-glove`
  static const PhosphorDuotoneIconData boxingGlove = PhosphorDuotoneIconData(
    figure: IconData(0xea37, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea36, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `brackets-angle`
  static const PhosphorDuotoneIconData bracketsAngle = PhosphorDuotoneIconData(
    figure: IconData(0xe863, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe862, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `brackets-curly`
  static const PhosphorDuotoneIconData bracketsCurly = PhosphorDuotoneIconData(
    figure: IconData(0xe861, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe860, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `brackets-round`
  static const PhosphorDuotoneIconData bracketsRound = PhosphorDuotoneIconData(
    figure: IconData(0xe865, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe864, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `brackets-square`
  static const PhosphorDuotoneIconData bracketsSquare = PhosphorDuotoneIconData(
    figure: IconData(0xe85f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe85e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `brain`
  static const PhosphorDuotoneIconData brain = PhosphorDuotoneIconData(
    figure: IconData(0xe74f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe74e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `brandy`
  static const PhosphorDuotoneIconData brandy = PhosphorDuotoneIconData(
    figure: IconData(0xe6b5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6b4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bread`
  static const PhosphorDuotoneIconData bread = PhosphorDuotoneIconData(
    figure: IconData(0xe81d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe81c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bridge`
  static const PhosphorDuotoneIconData bridge = PhosphorDuotoneIconData(
    figure: IconData(0xea69, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea68, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `briefcase`
  static const PhosphorDuotoneIconData briefcase = PhosphorDuotoneIconData(
    figure: IconData(0xe0ef, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0ee, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `briefcase-metal`
  static const PhosphorDuotoneIconData briefcaseMetal = PhosphorDuotoneIconData(
    figure: IconData(0xe5f3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5f2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `broadcast`
  static const PhosphorDuotoneIconData broadcast = PhosphorDuotoneIconData(
    figure: IconData(0xe0f3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0f2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `broom`
  static const PhosphorDuotoneIconData broom = PhosphorDuotoneIconData(
    figure: IconData(0xec55, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec54, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `browser`
  static const PhosphorDuotoneIconData browser = PhosphorDuotoneIconData(
    figure: IconData(0xe0f5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0f4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `browsers`
  static const PhosphorDuotoneIconData browsers = PhosphorDuotoneIconData(
    figure: IconData(0xe0f7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0f6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bug`
  static const PhosphorDuotoneIconData bug = PhosphorDuotoneIconData(
    figure: IconData(0xe5f5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5f4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bug-beetle`
  static const PhosphorDuotoneIconData bugBeetle = PhosphorDuotoneIconData(
    figure: IconData(0xe5f7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5f6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bug-droid`
  static const PhosphorDuotoneIconData bugDroid = PhosphorDuotoneIconData(
    figure: IconData(0xe5f9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5f8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `building`
  static const PhosphorDuotoneIconData building = PhosphorDuotoneIconData(
    figure: IconData(0xe101, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe100, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `building-apartment`
  static const PhosphorDuotoneIconData
  buildingApartment = PhosphorDuotoneIconData(
    figure: IconData(0xe103, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0fe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `building-office`
  static const PhosphorDuotoneIconData buildingOffice = PhosphorDuotoneIconData(
    figure: IconData(0xe104, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0ff, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `buildings`
  static const PhosphorDuotoneIconData buildings = PhosphorDuotoneIconData(
    figure: IconData(0xe105, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe102, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bulldozer`
  static const PhosphorDuotoneIconData bulldozer = PhosphorDuotoneIconData(
    figure: IconData(0xec6d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec6c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `bus`
  static const PhosphorDuotoneIconData bus = PhosphorDuotoneIconData(
    figure: IconData(0xe107, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe106, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `butterfly`
  static const PhosphorDuotoneIconData butterfly = PhosphorDuotoneIconData(
    figure: IconData(0xea6f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea6e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cable-car`
  static const PhosphorDuotoneIconData cableCar = PhosphorDuotoneIconData(
    figure: IconData(0xe49d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe49c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cactus`
  static const PhosphorDuotoneIconData cactus = PhosphorDuotoneIconData(
    figure: IconData(0xe919, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe918, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caduceus` — apelido de `asclepius`
  static const PhosphorDuotoneIconData caduceus = PhosphorDuotoneIconData(
    figure: IconData(0xee35, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee34, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cake`
  static const PhosphorDuotoneIconData cake = PhosphorDuotoneIconData(
    figure: IconData(0xe781, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe780, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calculator`
  static const PhosphorDuotoneIconData calculator = PhosphorDuotoneIconData(
    figure: IconData(0xe539, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe538, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calendar`
  static const PhosphorDuotoneIconData calendar = PhosphorDuotoneIconData(
    figure: IconData(0xe109, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe108, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calendar-blank`
  static const PhosphorDuotoneIconData calendarBlank = PhosphorDuotoneIconData(
    figure: IconData(0xe10b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe10a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calendar-check`
  static const PhosphorDuotoneIconData calendarCheck = PhosphorDuotoneIconData(
    figure: IconData(0xe713, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe712, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calendar-dot`
  static const PhosphorDuotoneIconData calendarDot = PhosphorDuotoneIconData(
    figure: IconData(0xe7b3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7b2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calendar-dots`
  static const PhosphorDuotoneIconData calendarDots = PhosphorDuotoneIconData(
    figure: IconData(0xe7b5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7b4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calendar-heart`
  static const PhosphorDuotoneIconData calendarHeart = PhosphorDuotoneIconData(
    figure: IconData(0xe8b1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8b0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calendar-minus`
  static const PhosphorDuotoneIconData calendarMinus = PhosphorDuotoneIconData(
    figure: IconData(0xea15, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea14, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calendar-plus`
  static const PhosphorDuotoneIconData calendarPlus = PhosphorDuotoneIconData(
    figure: IconData(0xe715, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe714, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calendar-slash`
  static const PhosphorDuotoneIconData calendarSlash = PhosphorDuotoneIconData(
    figure: IconData(0xea13, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea12, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calendar-star`
  static const PhosphorDuotoneIconData calendarStar = PhosphorDuotoneIconData(
    figure: IconData(0xe8b3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8b2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `calendar-x`
  static const PhosphorDuotoneIconData calendarX = PhosphorDuotoneIconData(
    figure: IconData(0xe10d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe10c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `call-bell`
  static const PhosphorDuotoneIconData callBell = PhosphorDuotoneIconData(
    figure: IconData(0xe7df, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7de, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `camera`
  static const PhosphorDuotoneIconData camera = PhosphorDuotoneIconData(
    figure: IconData(0xe10f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe10e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `camera-plus`
  static const PhosphorDuotoneIconData cameraPlus = PhosphorDuotoneIconData(
    figure: IconData(0xec59, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec58, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `camera-rotate`
  static const PhosphorDuotoneIconData cameraRotate = PhosphorDuotoneIconData(
    figure: IconData(0xe7a5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7a4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `camera-slash`
  static const PhosphorDuotoneIconData cameraSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe111, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe110, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `campfire`
  static const PhosphorDuotoneIconData campfire = PhosphorDuotoneIconData(
    figure: IconData(0xe9d9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9d8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `car`
  static const PhosphorDuotoneIconData car = PhosphorDuotoneIconData(
    figure: IconData(0xe113, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe112, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `car-battery`
  static const PhosphorDuotoneIconData carBattery = PhosphorDuotoneIconData(
    figure: IconData(0xee31, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee30, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `car-profile`
  static const PhosphorDuotoneIconData carProfile = PhosphorDuotoneIconData(
    figure: IconData(0xe8cd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8cc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `car-simple`
  static const PhosphorDuotoneIconData carSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe115, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe114, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cardholder`
  static const PhosphorDuotoneIconData cardholder = PhosphorDuotoneIconData(
    figure: IconData(0xe5fb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5fa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cards`
  static const PhosphorDuotoneIconData cards = PhosphorDuotoneIconData(
    figure: IconData(0xe0f9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe0f8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cards-three`
  static const PhosphorDuotoneIconData cardsThree = PhosphorDuotoneIconData(
    figure: IconData(0xee51, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee50, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-circle-double-down`
  static const PhosphorDuotoneIconData
  caretCircleDoubleDown = PhosphorDuotoneIconData(
    figure: IconData(0xe117, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe116, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-circle-double-left`
  static const PhosphorDuotoneIconData
  caretCircleDoubleLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe119, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe118, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-circle-double-right`
  static const PhosphorDuotoneIconData
  caretCircleDoubleRight = PhosphorDuotoneIconData(
    figure: IconData(0xe11b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe11a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-circle-double-up`
  static const PhosphorDuotoneIconData
  caretCircleDoubleUp = PhosphorDuotoneIconData(
    figure: IconData(0xe11d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe11c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-circle-down`
  static const PhosphorDuotoneIconData
  caretCircleDown = PhosphorDuotoneIconData(
    figure: IconData(0xe11f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe11e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-circle-left`
  static const PhosphorDuotoneIconData
  caretCircleLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe121, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe120, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-circle-right`
  static const PhosphorDuotoneIconData
  caretCircleRight = PhosphorDuotoneIconData(
    figure: IconData(0xe123, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe122, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-circle-up`
  static const PhosphorDuotoneIconData caretCircleUp = PhosphorDuotoneIconData(
    figure: IconData(0xe125, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe124, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-circle-up-down`
  static const PhosphorDuotoneIconData
  caretCircleUpDown = PhosphorDuotoneIconData(
    figure: IconData(0xe13f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe13e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-double-down`
  static const PhosphorDuotoneIconData
  caretDoubleDown = PhosphorDuotoneIconData(
    figure: IconData(0xe127, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe126, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-double-left`
  static const PhosphorDuotoneIconData
  caretDoubleLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe129, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe128, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-double-right`
  static const PhosphorDuotoneIconData
  caretDoubleRight = PhosphorDuotoneIconData(
    figure: IconData(0xe12b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe12a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-double-up`
  static const PhosphorDuotoneIconData caretDoubleUp = PhosphorDuotoneIconData(
    figure: IconData(0xe12d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe12c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-down`
  static const PhosphorDuotoneIconData caretDown = PhosphorDuotoneIconData(
    figure: IconData(0xe137, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe136, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-left`
  static const PhosphorDuotoneIconData caretLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe139, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe138, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-line-down`
  static const PhosphorDuotoneIconData caretLineDown = PhosphorDuotoneIconData(
    figure: IconData(0xe135, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe134, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-line-left`
  static const PhosphorDuotoneIconData caretLineLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe133, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe132, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-line-right`
  static const PhosphorDuotoneIconData caretLineRight = PhosphorDuotoneIconData(
    figure: IconData(0xe131, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe130, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-line-up`
  static const PhosphorDuotoneIconData caretLineUp = PhosphorDuotoneIconData(
    figure: IconData(0xe12f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe12e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-right`
  static const PhosphorDuotoneIconData caretRight = PhosphorDuotoneIconData(
    figure: IconData(0xe13b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe13a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-up`
  static const PhosphorDuotoneIconData caretUp = PhosphorDuotoneIconData(
    figure: IconData(0xe13d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe13c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `caret-up-down`
  static const PhosphorDuotoneIconData caretUpDown = PhosphorDuotoneIconData(
    figure: IconData(0xe141, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe140, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `carrot`
  static const PhosphorDuotoneIconData carrot = PhosphorDuotoneIconData(
    figure: IconData(0xed39, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed38, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cash-register`
  static const PhosphorDuotoneIconData cashRegister = PhosphorDuotoneIconData(
    figure: IconData(0xed81, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed80, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cassette-tape`
  static const PhosphorDuotoneIconData cassetteTape = PhosphorDuotoneIconData(
    figure: IconData(0xed2f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed2e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `castle-turret`
  static const PhosphorDuotoneIconData castleTurret = PhosphorDuotoneIconData(
    figure: IconData(0xe9d1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9d0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cat`
  static const PhosphorDuotoneIconData cat = PhosphorDuotoneIconData(
    figure: IconData(0xe749, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe748, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cell-signal-full`
  static const PhosphorDuotoneIconData cellSignalFull = PhosphorDuotoneIconData(
    figure: IconData(0xe143, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe142, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cell-signal-high`
  static const PhosphorDuotoneIconData cellSignalHigh = PhosphorDuotoneIconData(
    figure: IconData(0xe145, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe144, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cell-signal-low`
  static const PhosphorDuotoneIconData cellSignalLow = PhosphorDuotoneIconData(
    figure: IconData(0xe147, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe146, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cell-signal-medium`
  static const PhosphorDuotoneIconData
  cellSignalMedium = PhosphorDuotoneIconData(
    figure: IconData(0xe149, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe148, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cell-signal-none`
  static const PhosphorDuotoneIconData cellSignalNone = PhosphorDuotoneIconData(
    figure: IconData(0xe14a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cell-signal-slash`
  static const PhosphorDuotoneIconData
  cellSignalSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe14d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe14c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cell-signal-x`
  static const PhosphorDuotoneIconData cellSignalX = PhosphorDuotoneIconData(
    figure: IconData(0xe14f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe14e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cell-tower`
  static const PhosphorDuotoneIconData cellTower = PhosphorDuotoneIconData(
    figure: IconData(0xebab, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebaa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `certificate`
  static const PhosphorDuotoneIconData certificate = PhosphorDuotoneIconData(
    figure: IconData(0xe767, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe766, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chair`
  static const PhosphorDuotoneIconData chair = PhosphorDuotoneIconData(
    figure: IconData(0xe951, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe950, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chalkboard`
  static const PhosphorDuotoneIconData chalkboard = PhosphorDuotoneIconData(
    figure: IconData(0xe5fd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5fc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chalkboard-simple`
  static const PhosphorDuotoneIconData
  chalkboardSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe5ff, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5fe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chalkboard-teacher`
  static const PhosphorDuotoneIconData
  chalkboardTeacher = PhosphorDuotoneIconData(
    figure: IconData(0xe601, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe600, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `champagne`
  static const PhosphorDuotoneIconData champagne = PhosphorDuotoneIconData(
    figure: IconData(0xeacb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaca, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `charging-station`
  static const PhosphorDuotoneIconData
  chargingStation = PhosphorDuotoneIconData(
    figure: IconData(0xe8d1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8d0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chart-bar`
  static const PhosphorDuotoneIconData chartBar = PhosphorDuotoneIconData(
    figure: IconData(0xe151, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe150, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chart-bar-horizontal`
  static const PhosphorDuotoneIconData
  chartBarHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xe153, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe152, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chart-donut`
  static const PhosphorDuotoneIconData chartDonut = PhosphorDuotoneIconData(
    figure: IconData(0xeaa7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaa6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chart-line`
  static const PhosphorDuotoneIconData chartLine = PhosphorDuotoneIconData(
    figure: IconData(0xe155, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe154, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chart-line-down`
  static const PhosphorDuotoneIconData chartLineDown = PhosphorDuotoneIconData(
    figure: IconData(0xe8b7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8b6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chart-line-up`
  static const PhosphorDuotoneIconData chartLineUp = PhosphorDuotoneIconData(
    figure: IconData(0xe157, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe156, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chart-pie`
  static const PhosphorDuotoneIconData chartPie = PhosphorDuotoneIconData(
    figure: IconData(0xe159, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe158, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chart-pie-slice`
  static const PhosphorDuotoneIconData chartPieSlice = PhosphorDuotoneIconData(
    figure: IconData(0xe15b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe15a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chart-polar`
  static const PhosphorDuotoneIconData chartPolar = PhosphorDuotoneIconData(
    figure: IconData(0xeaa9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaa8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chart-scatter`
  static const PhosphorDuotoneIconData chartScatter = PhosphorDuotoneIconData(
    figure: IconData(0xeaad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat`
  static const PhosphorDuotoneIconData chat = PhosphorDuotoneIconData(
    figure: IconData(0xe15d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe15c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-centered`
  static const PhosphorDuotoneIconData chatCentered = PhosphorDuotoneIconData(
    figure: IconData(0xe161, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe160, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-centered-dots`
  static const PhosphorDuotoneIconData
  chatCenteredDots = PhosphorDuotoneIconData(
    figure: IconData(0xe165, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe164, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-centered-slash`
  static const PhosphorDuotoneIconData
  chatCenteredSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe163, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe162, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-centered-text`
  static const PhosphorDuotoneIconData
  chatCenteredText = PhosphorDuotoneIconData(
    figure: IconData(0xe167, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe166, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-circle`
  static const PhosphorDuotoneIconData chatCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe169, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe168, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-circle-dots`
  static const PhosphorDuotoneIconData chatCircleDots = PhosphorDuotoneIconData(
    figure: IconData(0xe16d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe16c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-circle-slash`
  static const PhosphorDuotoneIconData
  chatCircleSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe16b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe16a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-circle-text`
  static const PhosphorDuotoneIconData chatCircleText = PhosphorDuotoneIconData(
    figure: IconData(0xe16f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe16e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-dots`
  static const PhosphorDuotoneIconData chatDots = PhosphorDuotoneIconData(
    figure: IconData(0xe171, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe170, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-slash`
  static const PhosphorDuotoneIconData chatSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe15f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe15e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-teardrop`
  static const PhosphorDuotoneIconData chatTeardrop = PhosphorDuotoneIconData(
    figure: IconData(0xe173, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe172, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-teardrop-dots`
  static const PhosphorDuotoneIconData
  chatTeardropDots = PhosphorDuotoneIconData(
    figure: IconData(0xe177, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe176, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-teardrop-slash`
  static const PhosphorDuotoneIconData
  chatTeardropSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe175, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe174, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-teardrop-text`
  static const PhosphorDuotoneIconData
  chatTeardropText = PhosphorDuotoneIconData(
    figure: IconData(0xe179, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe178, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chat-text`
  static const PhosphorDuotoneIconData chatText = PhosphorDuotoneIconData(
    figure: IconData(0xe17b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe17a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chats`
  static const PhosphorDuotoneIconData chats = PhosphorDuotoneIconData(
    figure: IconData(0xe17d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe17c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chats-circle`
  static const PhosphorDuotoneIconData chatsCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe17f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe17e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chats-teardrop`
  static const PhosphorDuotoneIconData chatsTeardrop = PhosphorDuotoneIconData(
    figure: IconData(0xe181, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe180, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `check`
  static const PhosphorDuotoneIconData check = PhosphorDuotoneIconData(
    figure: IconData(0xe183, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe182, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `check-circle`
  static const PhosphorDuotoneIconData checkCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe185, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe184, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `check-fat`
  static const PhosphorDuotoneIconData checkFat = PhosphorDuotoneIconData(
    figure: IconData(0xeba7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeba6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `check-square`
  static const PhosphorDuotoneIconData checkSquare = PhosphorDuotoneIconData(
    figure: IconData(0xe187, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe186, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `check-square-offset`
  static const PhosphorDuotoneIconData
  checkSquareOffset = PhosphorDuotoneIconData(
    figure: IconData(0xe189, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe188, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `checkerboard`
  static const PhosphorDuotoneIconData checkerboard = PhosphorDuotoneIconData(
    figure: IconData(0xe8c5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8c4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `checks`
  static const PhosphorDuotoneIconData checks = PhosphorDuotoneIconData(
    figure: IconData(0xe53b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe53a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cheers`
  static const PhosphorDuotoneIconData cheers = PhosphorDuotoneIconData(
    figure: IconData(0xea4b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea4a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cheese`
  static const PhosphorDuotoneIconData cheese = PhosphorDuotoneIconData(
    figure: IconData(0xe9ff, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9fe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `chef-hat`
  static const PhosphorDuotoneIconData chefHat = PhosphorDuotoneIconData(
    figure: IconData(0xed8f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed8e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cherries`
  static const PhosphorDuotoneIconData cherries = PhosphorDuotoneIconData(
    figure: IconData(0xe831, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe830, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `church`
  static const PhosphorDuotoneIconData church = PhosphorDuotoneIconData(
    figure: IconData(0xeceb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecea, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cigarette`
  static const PhosphorDuotoneIconData cigarette = PhosphorDuotoneIconData(
    figure: IconData(0xed91, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed90, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cigarette-slash`
  static const PhosphorDuotoneIconData cigaretteSlash = PhosphorDuotoneIconData(
    figure: IconData(0xed93, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed92, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circle`
  static const PhosphorDuotoneIconData circle = PhosphorDuotoneIconData(
    figure: IconData(0xe18b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe18a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circle-dashed`
  static const PhosphorDuotoneIconData circleDashed = PhosphorDuotoneIconData(
    figure: IconData(0xe603, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe602, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circle-half`
  static const PhosphorDuotoneIconData circleHalf = PhosphorDuotoneIconData(
    figure: IconData(0xe18d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe18c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circle-half-tilt`
  static const PhosphorDuotoneIconData circleHalfTilt = PhosphorDuotoneIconData(
    figure: IconData(0xe18f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe18e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circle-notch`
  static const PhosphorDuotoneIconData circleNotch = PhosphorDuotoneIconData(
    figure: IconData(0xeb45, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb44, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circle-wavy` — apelido de `seal`
  static const PhosphorDuotoneIconData circleWavy = PhosphorDuotoneIconData(
    figure: IconData(0xe605, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe604, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circle-wavy-check` — apelido de `seal-check`
  static const PhosphorDuotoneIconData
  circleWavyCheck = PhosphorDuotoneIconData(
    figure: IconData(0xe607, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe606, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circle-wavy-question` — apelido de `seal-question`
  static const PhosphorDuotoneIconData
  circleWavyQuestion = PhosphorDuotoneIconData(
    figure: IconData(0xe609, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe608, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circle-wavy-warning` — apelido de `seal-warning`
  static const PhosphorDuotoneIconData
  circleWavyWarning = PhosphorDuotoneIconData(
    figure: IconData(0xe60d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe60c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circles-four`
  static const PhosphorDuotoneIconData circlesFour = PhosphorDuotoneIconData(
    figure: IconData(0xe191, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe190, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circles-three`
  static const PhosphorDuotoneIconData circlesThree = PhosphorDuotoneIconData(
    figure: IconData(0xe193, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe192, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circles-three-plus`
  static const PhosphorDuotoneIconData
  circlesThreePlus = PhosphorDuotoneIconData(
    figure: IconData(0xe195, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe194, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `circuitry`
  static const PhosphorDuotoneIconData circuitry = PhosphorDuotoneIconData(
    figure: IconData(0xe9c3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9c2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `city`
  static const PhosphorDuotoneIconData city = PhosphorDuotoneIconData(
    figure: IconData(0xea6b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea6a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `clipboard`
  static const PhosphorDuotoneIconData clipboard = PhosphorDuotoneIconData(
    figure: IconData(0xe197, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe196, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `clipboard-text`
  static const PhosphorDuotoneIconData clipboardText = PhosphorDuotoneIconData(
    figure: IconData(0xe199, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe198, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `clock`
  static const PhosphorDuotoneIconData clock = PhosphorDuotoneIconData(
    figure: IconData(0xe19b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe19a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `clock-afternoon`
  static const PhosphorDuotoneIconData clockAfternoon = PhosphorDuotoneIconData(
    figure: IconData(0xe19d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe19c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `clock-clockwise`
  static const PhosphorDuotoneIconData clockClockwise = PhosphorDuotoneIconData(
    figure: IconData(0xe19f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe19e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `clock-countdown`
  static const PhosphorDuotoneIconData clockCountdown = PhosphorDuotoneIconData(
    figure: IconData(0xed2d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed2c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `clock-counter-clockwise`
  static const PhosphorDuotoneIconData
  clockCounterClockwise = PhosphorDuotoneIconData(
    figure: IconData(0xe1a1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1a0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `clock-user`
  static const PhosphorDuotoneIconData clockUser = PhosphorDuotoneIconData(
    figure: IconData(0xeded, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedec, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `closed-captioning`
  static const PhosphorDuotoneIconData
  closedCaptioning = PhosphorDuotoneIconData(
    figure: IconData(0xe1a5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1a4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud`
  static const PhosphorDuotoneIconData cloud = PhosphorDuotoneIconData(
    figure: IconData(0xe1ab, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1aa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-arrow-down`
  static const PhosphorDuotoneIconData cloudArrowDown = PhosphorDuotoneIconData(
    figure: IconData(0xe1ad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1ac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-arrow-up`
  static const PhosphorDuotoneIconData cloudArrowUp = PhosphorDuotoneIconData(
    figure: IconData(0xe1af, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1ae, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-check`
  static const PhosphorDuotoneIconData cloudCheck = PhosphorDuotoneIconData(
    figure: IconData(0xe1b1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1b0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-fog`
  static const PhosphorDuotoneIconData cloudFog = PhosphorDuotoneIconData(
    figure: IconData(0xe53d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe53c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-lightning`
  static const PhosphorDuotoneIconData cloudLightning = PhosphorDuotoneIconData(
    figure: IconData(0xe1b3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1b2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-moon`
  static const PhosphorDuotoneIconData cloudMoon = PhosphorDuotoneIconData(
    figure: IconData(0xe53f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe53e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-rain`
  static const PhosphorDuotoneIconData cloudRain = PhosphorDuotoneIconData(
    figure: IconData(0xe1b5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1b4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-slash`
  static const PhosphorDuotoneIconData cloudSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe1b7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1b6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-snow`
  static const PhosphorDuotoneIconData cloudSnow = PhosphorDuotoneIconData(
    figure: IconData(0xe1b9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1b8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-sun`
  static const PhosphorDuotoneIconData cloudSun = PhosphorDuotoneIconData(
    figure: IconData(0xe541, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe540, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-warning`
  static const PhosphorDuotoneIconData cloudWarning = PhosphorDuotoneIconData(
    figure: IconData(0xea99, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea98, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cloud-x`
  static const PhosphorDuotoneIconData cloudX = PhosphorDuotoneIconData(
    figure: IconData(0xea97, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea96, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `clover`
  static const PhosphorDuotoneIconData clover = PhosphorDuotoneIconData(
    figure: IconData(0xedc9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedc8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `club`
  static const PhosphorDuotoneIconData club = PhosphorDuotoneIconData(
    figure: IconData(0xe1bb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1ba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `coat-hanger`
  static const PhosphorDuotoneIconData coatHanger = PhosphorDuotoneIconData(
    figure: IconData(0xe7ff, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7fe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `coda-logo`
  static const PhosphorDuotoneIconData codaLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe7cf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7ce, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `code`
  static const PhosphorDuotoneIconData code = PhosphorDuotoneIconData(
    figure: IconData(0xe1bd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1bc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `code-block`
  static const PhosphorDuotoneIconData codeBlock = PhosphorDuotoneIconData(
    figure: IconData(0xeaff, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeafe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `code-simple`
  static const PhosphorDuotoneIconData codeSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe1bf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1be, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `codepen-logo`
  static const PhosphorDuotoneIconData codepenLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe979, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe978, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `codesandbox-logo`
  static const PhosphorDuotoneIconData
  codesandboxLogo = PhosphorDuotoneIconData(
    figure: IconData(0xea07, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea06, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `coffee`
  static const PhosphorDuotoneIconData coffee = PhosphorDuotoneIconData(
    figure: IconData(0xe1c3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1c2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `coffee-bean`
  static const PhosphorDuotoneIconData coffeeBean = PhosphorDuotoneIconData(
    figure: IconData(0xe1c1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1c0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `coin`
  static const PhosphorDuotoneIconData coin = PhosphorDuotoneIconData(
    figure: IconData(0xe60f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe60e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `coin-vertical`
  static const PhosphorDuotoneIconData coinVertical = PhosphorDuotoneIconData(
    figure: IconData(0xeb49, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb48, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `coins`
  static const PhosphorDuotoneIconData coins = PhosphorDuotoneIconData(
    figure: IconData(0xe78f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe78e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `columns`
  static const PhosphorDuotoneIconData columns = PhosphorDuotoneIconData(
    figure: IconData(0xe547, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe546, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `columns-plus-left`
  static const PhosphorDuotoneIconData
  columnsPlusLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe545, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe544, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `columns-plus-right`
  static const PhosphorDuotoneIconData
  columnsPlusRight = PhosphorDuotoneIconData(
    figure: IconData(0xe543, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe542, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `command`
  static const PhosphorDuotoneIconData command = PhosphorDuotoneIconData(
    figure: IconData(0xe1c5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1c4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `compass`
  static const PhosphorDuotoneIconData compass = PhosphorDuotoneIconData(
    figure: IconData(0xe1c9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1c8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `compass-rose`
  static const PhosphorDuotoneIconData compassRose = PhosphorDuotoneIconData(
    figure: IconData(0xe1c7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1c6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `compass-tool`
  static const PhosphorDuotoneIconData compassTool = PhosphorDuotoneIconData(
    figure: IconData(0xea0f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea0e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `computer-tower`
  static const PhosphorDuotoneIconData computerTower = PhosphorDuotoneIconData(
    figure: IconData(0xe549, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe548, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `confetti`
  static const PhosphorDuotoneIconData confetti = PhosphorDuotoneIconData(
    figure: IconData(0xe81b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe81a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `contactless-payment`
  static const PhosphorDuotoneIconData
  contactlessPayment = PhosphorDuotoneIconData(
    figure: IconData(0xed43, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed42, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `control`
  static const PhosphorDuotoneIconData control = PhosphorDuotoneIconData(
    figure: IconData(0xeca7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeca6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cookie`
  static const PhosphorDuotoneIconData cookie = PhosphorDuotoneIconData(
    figure: IconData(0xe6cb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6ca, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cooking-pot`
  static const PhosphorDuotoneIconData cookingPot = PhosphorDuotoneIconData(
    figure: IconData(0xe765, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe764, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `copy`
  static const PhosphorDuotoneIconData copy = PhosphorDuotoneIconData(
    figure: IconData(0xe1cb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1ca, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `copy-simple`
  static const PhosphorDuotoneIconData copySimple = PhosphorDuotoneIconData(
    figure: IconData(0xe1cd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1cc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `copyleft`
  static const PhosphorDuotoneIconData copyleft = PhosphorDuotoneIconData(
    figure: IconData(0xe86b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe86a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `copyright`
  static const PhosphorDuotoneIconData copyright = PhosphorDuotoneIconData(
    figure: IconData(0xe54b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe54a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `corners-in`
  static const PhosphorDuotoneIconData cornersIn = PhosphorDuotoneIconData(
    figure: IconData(0xe1cf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1ce, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `corners-out`
  static const PhosphorDuotoneIconData cornersOut = PhosphorDuotoneIconData(
    figure: IconData(0xe1d1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1d0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `couch`
  static const PhosphorDuotoneIconData couch = PhosphorDuotoneIconData(
    figure: IconData(0xe7f7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7f6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `court-basketball`
  static const PhosphorDuotoneIconData
  courtBasketball = PhosphorDuotoneIconData(
    figure: IconData(0xee37, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee36, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cow`
  static const PhosphorDuotoneIconData cow = PhosphorDuotoneIconData(
    figure: IconData(0xeabf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeabe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cowboy-hat`
  static const PhosphorDuotoneIconData cowboyHat = PhosphorDuotoneIconData(
    figure: IconData(0xed13, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed12, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cpu`
  static const PhosphorDuotoneIconData cpu = PhosphorDuotoneIconData(
    figure: IconData(0xe611, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe610, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `crane`
  static const PhosphorDuotoneIconData crane = PhosphorDuotoneIconData(
    figure: IconData(0xed4b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed48, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `crane-tower`
  static const PhosphorDuotoneIconData craneTower = PhosphorDuotoneIconData(
    figure: IconData(0xed4d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed49, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `credit-card`
  static const PhosphorDuotoneIconData creditCard = PhosphorDuotoneIconData(
    figure: IconData(0xe1d3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1d2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cricket`
  static const PhosphorDuotoneIconData cricket = PhosphorDuotoneIconData(
    figure: IconData(0xee13, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee12, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `crop`
  static const PhosphorDuotoneIconData crop = PhosphorDuotoneIconData(
    figure: IconData(0xe1d5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1d4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cross`
  static const PhosphorDuotoneIconData cross = PhosphorDuotoneIconData(
    figure: IconData(0xe8a1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8a0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `crosshair`
  static const PhosphorDuotoneIconData crosshair = PhosphorDuotoneIconData(
    figure: IconData(0xe1d7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1d6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `crosshair-simple`
  static const PhosphorDuotoneIconData
  crosshairSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe1d9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1d8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `crown`
  static const PhosphorDuotoneIconData crown = PhosphorDuotoneIconData(
    figure: IconData(0xe615, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe614, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `crown-cross`
  static const PhosphorDuotoneIconData crownCross = PhosphorDuotoneIconData(
    figure: IconData(0xee5f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee5e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `crown-simple`
  static const PhosphorDuotoneIconData crownSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe617, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe616, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cube`
  static const PhosphorDuotoneIconData cube = PhosphorDuotoneIconData(
    figure: IconData(0xe1db, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1da, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cube-focus`
  static const PhosphorDuotoneIconData cubeFocus = PhosphorDuotoneIconData(
    figure: IconData(0xed0b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed0a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cube-transparent`
  static const PhosphorDuotoneIconData
  cubeTransparent = PhosphorDuotoneIconData(
    figure: IconData(0xec7d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec7c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-btc`
  static const PhosphorDuotoneIconData currencyBtc = PhosphorDuotoneIconData(
    figure: IconData(0xe619, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe618, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-circle-dollar`
  static const PhosphorDuotoneIconData
  currencyCircleDollar = PhosphorDuotoneIconData(
    figure: IconData(0xe54d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe54c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-cny`
  static const PhosphorDuotoneIconData currencyCny = PhosphorDuotoneIconData(
    figure: IconData(0xe54f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe54e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-dollar`
  static const PhosphorDuotoneIconData currencyDollar = PhosphorDuotoneIconData(
    figure: IconData(0xe551, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe550, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-dollar-simple`
  static const PhosphorDuotoneIconData
  currencyDollarSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe553, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe552, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-eth`
  static const PhosphorDuotoneIconData currencyEth = PhosphorDuotoneIconData(
    figure: IconData(0xeadb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeada, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-eur`
  static const PhosphorDuotoneIconData currencyEur = PhosphorDuotoneIconData(
    figure: IconData(0xe555, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe554, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-gbp`
  static const PhosphorDuotoneIconData currencyGbp = PhosphorDuotoneIconData(
    figure: IconData(0xe557, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe556, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-inr`
  static const PhosphorDuotoneIconData currencyInr = PhosphorDuotoneIconData(
    figure: IconData(0xe559, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe558, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-jpy`
  static const PhosphorDuotoneIconData currencyJpy = PhosphorDuotoneIconData(
    figure: IconData(0xe55b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe55a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-krw`
  static const PhosphorDuotoneIconData currencyKrw = PhosphorDuotoneIconData(
    figure: IconData(0xe55d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe55c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-kzt`
  static const PhosphorDuotoneIconData currencyKzt = PhosphorDuotoneIconData(
    figure: IconData(0xec4d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec4c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-ngn`
  static const PhosphorDuotoneIconData currencyNgn = PhosphorDuotoneIconData(
    figure: IconData(0xeb53, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb52, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `currency-rub`
  static const PhosphorDuotoneIconData currencyRub = PhosphorDuotoneIconData(
    figure: IconData(0xe55f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe55e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cursor`
  static const PhosphorDuotoneIconData cursor = PhosphorDuotoneIconData(
    figure: IconData(0xe1dd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1dc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cursor-click`
  static const PhosphorDuotoneIconData cursorClick = PhosphorDuotoneIconData(
    figure: IconData(0xe7c9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7c8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cursor-text`
  static const PhosphorDuotoneIconData cursorText = PhosphorDuotoneIconData(
    figure: IconData(0xe7d9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7d8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `cylinder`
  static const PhosphorDuotoneIconData cylinder = PhosphorDuotoneIconData(
    figure: IconData(0xe8fd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8fc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `database`
  static const PhosphorDuotoneIconData database = PhosphorDuotoneIconData(
    figure: IconData(0xe1df, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1de, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `desk`
  static const PhosphorDuotoneIconData desk = PhosphorDuotoneIconData(
    figure: IconData(0xed17, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed16, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `desktop`
  static const PhosphorDuotoneIconData desktop = PhosphorDuotoneIconData(
    figure: IconData(0xe561, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe560, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `desktop-tower`
  static const PhosphorDuotoneIconData desktopTower = PhosphorDuotoneIconData(
    figure: IconData(0xe563, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe562, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `detective`
  static const PhosphorDuotoneIconData detective = PhosphorDuotoneIconData(
    figure: IconData(0xe83f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe83e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dev-to-logo`
  static const PhosphorDuotoneIconData devToLogo = PhosphorDuotoneIconData(
    figure: IconData(0xed0f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed0e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `device-mobile`
  static const PhosphorDuotoneIconData deviceMobile = PhosphorDuotoneIconData(
    figure: IconData(0xe1e1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1e0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `device-mobile-camera`
  static const PhosphorDuotoneIconData
  deviceMobileCamera = PhosphorDuotoneIconData(
    figure: IconData(0xe1e3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1e2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `device-mobile-slash`
  static const PhosphorDuotoneIconData
  deviceMobileSlash = PhosphorDuotoneIconData(
    figure: IconData(0xee47, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee46, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `device-mobile-speaker`
  static const PhosphorDuotoneIconData
  deviceMobileSpeaker = PhosphorDuotoneIconData(
    figure: IconData(0xe1e5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1e4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `device-rotate`
  static const PhosphorDuotoneIconData deviceRotate = PhosphorDuotoneIconData(
    figure: IconData(0xedf3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedf2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `device-tablet`
  static const PhosphorDuotoneIconData deviceTablet = PhosphorDuotoneIconData(
    figure: IconData(0xe1e7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1e6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `device-tablet-camera`
  static const PhosphorDuotoneIconData
  deviceTabletCamera = PhosphorDuotoneIconData(
    figure: IconData(0xe1e9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1e8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `device-tablet-speaker`
  static const PhosphorDuotoneIconData
  deviceTabletSpeaker = PhosphorDuotoneIconData(
    figure: IconData(0xe1eb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1ea, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `devices`
  static const PhosphorDuotoneIconData devices = PhosphorDuotoneIconData(
    figure: IconData(0xeba5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeba4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `diamond`
  static const PhosphorDuotoneIconData diamond = PhosphorDuotoneIconData(
    figure: IconData(0xe1ed, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1ec, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `diamonds-four`
  static const PhosphorDuotoneIconData diamondsFour = PhosphorDuotoneIconData(
    figure: IconData(0xe8f5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8f4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dice-five`
  static const PhosphorDuotoneIconData diceFive = PhosphorDuotoneIconData(
    figure: IconData(0xe1ef, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1ee, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dice-four`
  static const PhosphorDuotoneIconData diceFour = PhosphorDuotoneIconData(
    figure: IconData(0xe1f1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1f0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dice-one`
  static const PhosphorDuotoneIconData diceOne = PhosphorDuotoneIconData(
    figure: IconData(0xe1f3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1f2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dice-six`
  static const PhosphorDuotoneIconData diceSix = PhosphorDuotoneIconData(
    figure: IconData(0xe1f5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1f4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dice-three`
  static const PhosphorDuotoneIconData diceThree = PhosphorDuotoneIconData(
    figure: IconData(0xe1f7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1f6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dice-two`
  static const PhosphorDuotoneIconData diceTwo = PhosphorDuotoneIconData(
    figure: IconData(0xe1f9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1f8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `disc`
  static const PhosphorDuotoneIconData disc = PhosphorDuotoneIconData(
    figure: IconData(0xe565, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe564, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `disco-ball`
  static const PhosphorDuotoneIconData discoBall = PhosphorDuotoneIconData(
    figure: IconData(0xed99, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed98, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `discord-logo`
  static const PhosphorDuotoneIconData discordLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe61b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe61a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `divide`
  static const PhosphorDuotoneIconData divide = PhosphorDuotoneIconData(
    figure: IconData(0xe1fb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1fa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dna`
  static const PhosphorDuotoneIconData dna = PhosphorDuotoneIconData(
    figure: IconData(0xe925, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe924, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dog`
  static const PhosphorDuotoneIconData dog = PhosphorDuotoneIconData(
    figure: IconData(0xe74b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe74a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `door`
  static const PhosphorDuotoneIconData door = PhosphorDuotoneIconData(
    figure: IconData(0xe61d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe61c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `door-open`
  static const PhosphorDuotoneIconData doorOpen = PhosphorDuotoneIconData(
    figure: IconData(0xe7e7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7e6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dot`
  static const PhosphorDuotoneIconData dot = PhosphorDuotoneIconData(
    figure: IconData(0xecdf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecde, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dot-outline`
  static const PhosphorDuotoneIconData dotOutline = PhosphorDuotoneIconData(
    figure: IconData(0xece1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xece0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dots-nine`
  static const PhosphorDuotoneIconData dotsNine = PhosphorDuotoneIconData(
    figure: IconData(0xe1fd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1fc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dots-six`
  static const PhosphorDuotoneIconData dotsSix = PhosphorDuotoneIconData(
    figure: IconData(0xe795, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe794, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dots-six-vertical`
  static const PhosphorDuotoneIconData
  dotsSixVertical = PhosphorDuotoneIconData(
    figure: IconData(0xeae3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeae2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dots-three`
  static const PhosphorDuotoneIconData dotsThree = PhosphorDuotoneIconData(
    figure: IconData(0xe1ff, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1fe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dots-three-circle`
  static const PhosphorDuotoneIconData
  dotsThreeCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe201, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe200, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dots-three-circle-vertical`
  static const PhosphorDuotoneIconData
  dotsThreeCircleVertical = PhosphorDuotoneIconData(
    figure: IconData(0xe203, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe202, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dots-three-outline`
  static const PhosphorDuotoneIconData
  dotsThreeOutline = PhosphorDuotoneIconData(
    figure: IconData(0xe205, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe204, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dots-three-outline-vertical`
  static const PhosphorDuotoneIconData
  dotsThreeOutlineVertical = PhosphorDuotoneIconData(
    figure: IconData(0xe207, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe206, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dots-three-vertical`
  static const PhosphorDuotoneIconData
  dotsThreeVertical = PhosphorDuotoneIconData(
    figure: IconData(0xe209, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe208, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `download`
  static const PhosphorDuotoneIconData download = PhosphorDuotoneIconData(
    figure: IconData(0xe20b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe20a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `download-simple`
  static const PhosphorDuotoneIconData downloadSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe20d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe20c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dress`
  static const PhosphorDuotoneIconData dress = PhosphorDuotoneIconData(
    figure: IconData(0xea7f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea7e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dresser`
  static const PhosphorDuotoneIconData dresser = PhosphorDuotoneIconData(
    figure: IconData(0xe94f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe94e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dribbble-logo`
  static const PhosphorDuotoneIconData dribbbleLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe20f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe20e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `drone`
  static const PhosphorDuotoneIconData drone = PhosphorDuotoneIconData(
    figure: IconData(0xed75, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed74, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `drop`
  static const PhosphorDuotoneIconData drop = PhosphorDuotoneIconData(
    figure: IconData(0xe211, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe210, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `drop-half`
  static const PhosphorDuotoneIconData dropHalf = PhosphorDuotoneIconData(
    figure: IconData(0xe567, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe566, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `drop-half-bottom`
  static const PhosphorDuotoneIconData dropHalfBottom = PhosphorDuotoneIconData(
    figure: IconData(0xeb41, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb40, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `drop-simple`
  static const PhosphorDuotoneIconData dropSimple = PhosphorDuotoneIconData(
    figure: IconData(0xee33, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee32, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `drop-slash`
  static const PhosphorDuotoneIconData dropSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe955, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe954, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `dropbox-logo`
  static const PhosphorDuotoneIconData dropboxLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe7d1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7d0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ear`
  static const PhosphorDuotoneIconData ear = PhosphorDuotoneIconData(
    figure: IconData(0xe70d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe70c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ear-slash`
  static const PhosphorDuotoneIconData earSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe70f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe70e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `egg`
  static const PhosphorDuotoneIconData egg = PhosphorDuotoneIconData(
    figure: IconData(0xe813, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe812, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `egg-crack`
  static const PhosphorDuotoneIconData eggCrack = PhosphorDuotoneIconData(
    figure: IconData(0xeb65, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb64, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `eject`
  static const PhosphorDuotoneIconData eject = PhosphorDuotoneIconData(
    figure: IconData(0xe213, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe212, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `eject-simple`
  static const PhosphorDuotoneIconData ejectSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe6af, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6ae, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `elevator`
  static const PhosphorDuotoneIconData elevator = PhosphorDuotoneIconData(
    figure: IconData(0xecc1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecc0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `empty`
  static const PhosphorDuotoneIconData empty = PhosphorDuotoneIconData(
    figure: IconData(0xedbd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedbc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `engine`
  static const PhosphorDuotoneIconData engine = PhosphorDuotoneIconData(
    figure: IconData(0xea81, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea80, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `envelope`
  static const PhosphorDuotoneIconData envelope = PhosphorDuotoneIconData(
    figure: IconData(0xe215, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe214, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `envelope-open`
  static const PhosphorDuotoneIconData envelopeOpen = PhosphorDuotoneIconData(
    figure: IconData(0xe217, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe216, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `envelope-simple`
  static const PhosphorDuotoneIconData envelopeSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe219, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe218, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `envelope-simple-open`
  static const PhosphorDuotoneIconData
  envelopeSimpleOpen = PhosphorDuotoneIconData(
    figure: IconData(0xe21b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe21a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `equalizer`
  static const PhosphorDuotoneIconData equalizer = PhosphorDuotoneIconData(
    figure: IconData(0xebbd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebbc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `equals`
  static const PhosphorDuotoneIconData equals = PhosphorDuotoneIconData(
    figure: IconData(0xe21d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe21c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `eraser`
  static const PhosphorDuotoneIconData eraser = PhosphorDuotoneIconData(
    figure: IconData(0xe21f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe21e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `escalator-down`
  static const PhosphorDuotoneIconData escalatorDown = PhosphorDuotoneIconData(
    figure: IconData(0xecbb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `escalator-up`
  static const PhosphorDuotoneIconData escalatorUp = PhosphorDuotoneIconData(
    figure: IconData(0xecbd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecbc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `exam`
  static const PhosphorDuotoneIconData exam = PhosphorDuotoneIconData(
    figure: IconData(0xe743, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe742, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `exclamation-mark`
  static const PhosphorDuotoneIconData
  exclamationMark = PhosphorDuotoneIconData(
    figure: IconData(0xee45, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee44, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `exclude`
  static const PhosphorDuotoneIconData exclude = PhosphorDuotoneIconData(
    figure: IconData(0xe883, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe882, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `exclude-square`
  static const PhosphorDuotoneIconData excludeSquare = PhosphorDuotoneIconData(
    figure: IconData(0xe881, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe880, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `export`
  static const PhosphorDuotoneIconData export = PhosphorDuotoneIconData(
    figure: IconData(0xeaf1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaf0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `eye`
  static const PhosphorDuotoneIconData eye = PhosphorDuotoneIconData(
    figure: IconData(0xe221, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe220, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `eye-closed`
  static const PhosphorDuotoneIconData eyeClosed = PhosphorDuotoneIconData(
    figure: IconData(0xe223, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe222, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `eye-slash`
  static const PhosphorDuotoneIconData eyeSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe225, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe224, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `eyedropper`
  static const PhosphorDuotoneIconData eyedropper = PhosphorDuotoneIconData(
    figure: IconData(0xe569, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe568, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `eyedropper-sample`
  static const PhosphorDuotoneIconData
  eyedropperSample = PhosphorDuotoneIconData(
    figure: IconData(0xeac5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeac4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `eyeglasses`
  static const PhosphorDuotoneIconData eyeglasses = PhosphorDuotoneIconData(
    figure: IconData(0xe7bb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7ba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `eyes`
  static const PhosphorDuotoneIconData eyes = PhosphorDuotoneIconData(
    figure: IconData(0xee5d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee5c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `face-mask`
  static const PhosphorDuotoneIconData faceMask = PhosphorDuotoneIconData(
    figure: IconData(0xe56b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe56a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `facebook-logo`
  static const PhosphorDuotoneIconData facebookLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe227, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe226, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `factory`
  static const PhosphorDuotoneIconData factory = PhosphorDuotoneIconData(
    figure: IconData(0xe761, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe760, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `faders`
  static const PhosphorDuotoneIconData faders = PhosphorDuotoneIconData(
    figure: IconData(0xe229, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe228, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `faders-horizontal`
  static const PhosphorDuotoneIconData
  fadersHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xe22b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe22a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fallout-shelter`
  static const PhosphorDuotoneIconData falloutShelter = PhosphorDuotoneIconData(
    figure: IconData(0xe9df, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9de, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fan`
  static const PhosphorDuotoneIconData fan = PhosphorDuotoneIconData(
    figure: IconData(0xe9f3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9f2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `farm`
  static const PhosphorDuotoneIconData farm = PhosphorDuotoneIconData(
    figure: IconData(0xec71, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec70, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fast-forward`
  static const PhosphorDuotoneIconData fastForward = PhosphorDuotoneIconData(
    figure: IconData(0xe6a7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6a6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fast-forward-circle`
  static const PhosphorDuotoneIconData
  fastForwardCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe22d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe22c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `feather`
  static const PhosphorDuotoneIconData feather = PhosphorDuotoneIconData(
    figure: IconData(0xe9c1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9c0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fediverse-logo`
  static const PhosphorDuotoneIconData fediverseLogo = PhosphorDuotoneIconData(
    figure: IconData(0xed67, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed66, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `figma-logo`
  static const PhosphorDuotoneIconData figmaLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe22f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe22e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file`
  static const PhosphorDuotoneIconData file = PhosphorDuotoneIconData(
    figure: IconData(0xe231, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe230, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-archive`
  static const PhosphorDuotoneIconData fileArchive = PhosphorDuotoneIconData(
    figure: IconData(0xeb2b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb2a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-arrow-down`
  static const PhosphorDuotoneIconData fileArrowDown = PhosphorDuotoneIconData(
    figure: IconData(0xe233, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe232, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-arrow-up`
  static const PhosphorDuotoneIconData fileArrowUp = PhosphorDuotoneIconData(
    figure: IconData(0xe61f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe61e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-audio`
  static const PhosphorDuotoneIconData fileAudio = PhosphorDuotoneIconData(
    figure: IconData(0xea21, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea20, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-c`
  static const PhosphorDuotoneIconData fileC = PhosphorDuotoneIconData(
    figure: IconData(0xeb36, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb32, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-c-sharp`
  static const PhosphorDuotoneIconData fileCSharp = PhosphorDuotoneIconData(
    figure: IconData(0xeb31, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb30, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-cloud`
  static const PhosphorDuotoneIconData fileCloud = PhosphorDuotoneIconData(
    figure: IconData(0xe95f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe95e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-code`
  static const PhosphorDuotoneIconData fileCode = PhosphorDuotoneIconData(
    figure: IconData(0xe915, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe914, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-cpp`
  static const PhosphorDuotoneIconData fileCpp = PhosphorDuotoneIconData(
    figure: IconData(0xeb2f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb2e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-css`
  static const PhosphorDuotoneIconData fileCss = PhosphorDuotoneIconData(
    figure: IconData(0xeb37, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb34, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-csv`
  static const PhosphorDuotoneIconData fileCsv = PhosphorDuotoneIconData(
    figure: IconData(0xeb1d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb1c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-dashed`
  static const PhosphorDuotoneIconData fileDashed = PhosphorDuotoneIconData(
    figure: IconData(0xe705, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe704, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-doc`
  static const PhosphorDuotoneIconData fileDoc = PhosphorDuotoneIconData(
    figure: IconData(0xeb1f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb1e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-dotted` — apelido de `file-dashed`
  static const PhosphorDuotoneIconData fileDotted = PhosphorDuotoneIconData(
    figure: IconData(0xe705, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe704, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-html`
  static const PhosphorDuotoneIconData fileHtml = PhosphorDuotoneIconData(
    figure: IconData(0xeb39, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb38, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-image`
  static const PhosphorDuotoneIconData fileImage = PhosphorDuotoneIconData(
    figure: IconData(0xea25, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea24, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-ini`
  static const PhosphorDuotoneIconData fileIni = PhosphorDuotoneIconData(
    figure: IconData(0xeb3b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb33, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-jpg`
  static const PhosphorDuotoneIconData fileJpg = PhosphorDuotoneIconData(
    figure: IconData(0xeb1b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb1a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-js`
  static const PhosphorDuotoneIconData fileJs = PhosphorDuotoneIconData(
    figure: IconData(0xeb25, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb24, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-jsx`
  static const PhosphorDuotoneIconData fileJsx = PhosphorDuotoneIconData(
    figure: IconData(0xeb3d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb3a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-lock`
  static const PhosphorDuotoneIconData fileLock = PhosphorDuotoneIconData(
    figure: IconData(0xe95d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe95c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-magnifying-glass`
  static const PhosphorDuotoneIconData
  fileMagnifyingGlass = PhosphorDuotoneIconData(
    figure: IconData(0xe239, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe238, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-md`
  static const PhosphorDuotoneIconData fileMd = PhosphorDuotoneIconData(
    figure: IconData(0xed51, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed50, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-minus`
  static const PhosphorDuotoneIconData fileMinus = PhosphorDuotoneIconData(
    figure: IconData(0xe235, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe234, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-pdf`
  static const PhosphorDuotoneIconData filePdf = PhosphorDuotoneIconData(
    figure: IconData(0xe703, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe702, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-plus`
  static const PhosphorDuotoneIconData filePlus = PhosphorDuotoneIconData(
    figure: IconData(0xe237, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe236, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-png`
  static const PhosphorDuotoneIconData filePng = PhosphorDuotoneIconData(
    figure: IconData(0xeb19, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb18, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-ppt`
  static const PhosphorDuotoneIconData filePpt = PhosphorDuotoneIconData(
    figure: IconData(0xeb21, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb20, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-py`
  static const PhosphorDuotoneIconData filePy = PhosphorDuotoneIconData(
    figure: IconData(0xeb2d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb2c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-rs`
  static const PhosphorDuotoneIconData fileRs = PhosphorDuotoneIconData(
    figure: IconData(0xeb29, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb28, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-search` — apelido de `file-magnifying-glass`
  static const PhosphorDuotoneIconData fileSearch = PhosphorDuotoneIconData(
    figure: IconData(0xe239, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe238, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-sql`
  static const PhosphorDuotoneIconData fileSql = PhosphorDuotoneIconData(
    figure: IconData(0xed4f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed4e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-svg`
  static const PhosphorDuotoneIconData fileSvg = PhosphorDuotoneIconData(
    figure: IconData(0xed09, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed08, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-text`
  static const PhosphorDuotoneIconData fileText = PhosphorDuotoneIconData(
    figure: IconData(0xe23b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe23a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-ts`
  static const PhosphorDuotoneIconData fileTs = PhosphorDuotoneIconData(
    figure: IconData(0xeb27, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb26, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-tsx`
  static const PhosphorDuotoneIconData fileTsx = PhosphorDuotoneIconData(
    figure: IconData(0xeb3f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb3c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-txt`
  static const PhosphorDuotoneIconData fileTxt = PhosphorDuotoneIconData(
    figure: IconData(0xeb43, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb35, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-video`
  static const PhosphorDuotoneIconData fileVideo = PhosphorDuotoneIconData(
    figure: IconData(0xea23, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea22, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-vue`
  static const PhosphorDuotoneIconData fileVue = PhosphorDuotoneIconData(
    figure: IconData(0xeb47, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb3e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-x`
  static const PhosphorDuotoneIconData fileX = PhosphorDuotoneIconData(
    figure: IconData(0xe23d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe23c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-xls`
  static const PhosphorDuotoneIconData fileXls = PhosphorDuotoneIconData(
    figure: IconData(0xeb23, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb22, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `file-zip`
  static const PhosphorDuotoneIconData fileZip = PhosphorDuotoneIconData(
    figure: IconData(0xe959, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe958, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `files`
  static const PhosphorDuotoneIconData files = PhosphorDuotoneIconData(
    figure: IconData(0xe711, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe710, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `film-reel`
  static const PhosphorDuotoneIconData filmReel = PhosphorDuotoneIconData(
    figure: IconData(0xe8c1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8c0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `film-script`
  static const PhosphorDuotoneIconData filmScript = PhosphorDuotoneIconData(
    figure: IconData(0xeb51, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb50, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `film-slate`
  static const PhosphorDuotoneIconData filmSlate = PhosphorDuotoneIconData(
    figure: IconData(0xe8c3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8c2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `film-strip`
  static const PhosphorDuotoneIconData filmStrip = PhosphorDuotoneIconData(
    figure: IconData(0xe793, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe792, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fingerprint`
  static const PhosphorDuotoneIconData fingerprint = PhosphorDuotoneIconData(
    figure: IconData(0xe23f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe23e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fingerprint-simple`
  static const PhosphorDuotoneIconData
  fingerprintSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe241, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe240, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `finn-the-human`
  static const PhosphorDuotoneIconData finnTheHuman = PhosphorDuotoneIconData(
    figure: IconData(0xe56d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe56c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fire`
  static const PhosphorDuotoneIconData fire = PhosphorDuotoneIconData(
    figure: IconData(0xe243, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe242, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fire-extinguisher`
  static const PhosphorDuotoneIconData
  fireExtinguisher = PhosphorDuotoneIconData(
    figure: IconData(0xe9e9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9e8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fire-simple`
  static const PhosphorDuotoneIconData fireSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe621, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe620, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fire-truck`
  static const PhosphorDuotoneIconData fireTruck = PhosphorDuotoneIconData(
    figure: IconData(0xe575, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe574, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `first-aid`
  static const PhosphorDuotoneIconData firstAid = PhosphorDuotoneIconData(
    figure: IconData(0xe56f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe56e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `first-aid-kit`
  static const PhosphorDuotoneIconData firstAidKit = PhosphorDuotoneIconData(
    figure: IconData(0xe571, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe570, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fish`
  static const PhosphorDuotoneIconData fish = PhosphorDuotoneIconData(
    figure: IconData(0xe729, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe728, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fish-simple`
  static const PhosphorDuotoneIconData fishSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe72b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe72a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flag`
  static const PhosphorDuotoneIconData flag = PhosphorDuotoneIconData(
    figure: IconData(0xe245, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe244, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flag-banner`
  static const PhosphorDuotoneIconData flagBanner = PhosphorDuotoneIconData(
    figure: IconData(0xe623, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe622, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flag-banner-fold`
  static const PhosphorDuotoneIconData flagBannerFold = PhosphorDuotoneIconData(
    figure: IconData(0xecf3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecf2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flag-checkered`
  static const PhosphorDuotoneIconData flagCheckered = PhosphorDuotoneIconData(
    figure: IconData(0xea39, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea38, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flag-pennant`
  static const PhosphorDuotoneIconData flagPennant = PhosphorDuotoneIconData(
    figure: IconData(0xecf1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecf0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flame`
  static const PhosphorDuotoneIconData flame = PhosphorDuotoneIconData(
    figure: IconData(0xe625, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe624, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flashlight`
  static const PhosphorDuotoneIconData flashlight = PhosphorDuotoneIconData(
    figure: IconData(0xe247, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe246, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flask`
  static const PhosphorDuotoneIconData flask = PhosphorDuotoneIconData(
    figure: IconData(0xe79f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe79e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flip-horizontal`
  static const PhosphorDuotoneIconData flipHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xed6b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed6a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flip-vertical`
  static const PhosphorDuotoneIconData flipVertical = PhosphorDuotoneIconData(
    figure: IconData(0xed6d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed6c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `floppy-disk`
  static const PhosphorDuotoneIconData floppyDisk = PhosphorDuotoneIconData(
    figure: IconData(0xe249, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe248, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `floppy-disk-back`
  static const PhosphorDuotoneIconData floppyDiskBack = PhosphorDuotoneIconData(
    figure: IconData(0xeaf5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaf4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flow-arrow`
  static const PhosphorDuotoneIconData flowArrow = PhosphorDuotoneIconData(
    figure: IconData(0xe6ed, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6ec, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flower`
  static const PhosphorDuotoneIconData flower = PhosphorDuotoneIconData(
    figure: IconData(0xe75f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe75e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flower-lotus`
  static const PhosphorDuotoneIconData flowerLotus = PhosphorDuotoneIconData(
    figure: IconData(0xe6cd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6cc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flower-tulip`
  static const PhosphorDuotoneIconData flowerTulip = PhosphorDuotoneIconData(
    figure: IconData(0xeacd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeacc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `flying-saucer`
  static const PhosphorDuotoneIconData flyingSaucer = PhosphorDuotoneIconData(
    figure: IconData(0xeb4b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb4a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder`
  static const PhosphorDuotoneIconData folder = PhosphorDuotoneIconData(
    figure: IconData(0xe24b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe24a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-dashed`
  static const PhosphorDuotoneIconData folderDashed = PhosphorDuotoneIconData(
    figure: IconData(0xe8f9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8f8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-dotted` — apelido de `folder-dashed`
  static const PhosphorDuotoneIconData folderDotted = PhosphorDuotoneIconData(
    figure: IconData(0xe8f9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8f8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-lock`
  static const PhosphorDuotoneIconData folderLock = PhosphorDuotoneIconData(
    figure: IconData(0xea3d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea3c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-minus`
  static const PhosphorDuotoneIconData folderMinus = PhosphorDuotoneIconData(
    figure: IconData(0xe255, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe254, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-notch` — apelido de `folder`
  static const PhosphorDuotoneIconData folderNotch = PhosphorDuotoneIconData(
    figure: IconData(0xe24b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe24a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-notch-minus` — apelido de `folder-minus`
  static const PhosphorDuotoneIconData
  folderNotchMinus = PhosphorDuotoneIconData(
    figure: IconData(0xe255, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe254, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-notch-open` — apelido de `folder-open`
  static const PhosphorDuotoneIconData
  folderNotchOpen = PhosphorDuotoneIconData(
    figure: IconData(0xe257, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe256, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-notch-plus` — apelido de `folder-plus`
  static const PhosphorDuotoneIconData
  folderNotchPlus = PhosphorDuotoneIconData(
    figure: IconData(0xe259, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe258, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-open`
  static const PhosphorDuotoneIconData folderOpen = PhosphorDuotoneIconData(
    figure: IconData(0xe257, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe256, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-plus`
  static const PhosphorDuotoneIconData folderPlus = PhosphorDuotoneIconData(
    figure: IconData(0xe259, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe258, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-simple`
  static const PhosphorDuotoneIconData folderSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe25b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe25a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-simple-dashed`
  static const PhosphorDuotoneIconData
  folderSimpleDashed = PhosphorDuotoneIconData(
    figure: IconData(0xec2b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec2a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-simple-dotted` — apelido de `folder-simple-dashed`
  static const PhosphorDuotoneIconData
  folderSimpleDotted = PhosphorDuotoneIconData(
    figure: IconData(0xec2b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec2a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-simple-lock`
  static const PhosphorDuotoneIconData
  folderSimpleLock = PhosphorDuotoneIconData(
    figure: IconData(0xeb5f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb5e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-simple-minus`
  static const PhosphorDuotoneIconData
  folderSimpleMinus = PhosphorDuotoneIconData(
    figure: IconData(0xe25d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe25c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-simple-plus`
  static const PhosphorDuotoneIconData
  folderSimplePlus = PhosphorDuotoneIconData(
    figure: IconData(0xe25f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe25e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-simple-star`
  static const PhosphorDuotoneIconData
  folderSimpleStar = PhosphorDuotoneIconData(
    figure: IconData(0xec2f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec2e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-simple-user`
  static const PhosphorDuotoneIconData
  folderSimpleUser = PhosphorDuotoneIconData(
    figure: IconData(0xeb61, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb60, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-star`
  static const PhosphorDuotoneIconData folderStar = PhosphorDuotoneIconData(
    figure: IconData(0xea87, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea86, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folder-user`
  static const PhosphorDuotoneIconData folderUser = PhosphorDuotoneIconData(
    figure: IconData(0xeb4c, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb46, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `folders`
  static const PhosphorDuotoneIconData folders = PhosphorDuotoneIconData(
    figure: IconData(0xe261, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe260, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `football`
  static const PhosphorDuotoneIconData football = PhosphorDuotoneIconData(
    figure: IconData(0xe719, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe718, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `football-helmet`
  static const PhosphorDuotoneIconData footballHelmet = PhosphorDuotoneIconData(
    figure: IconData(0xee4d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee4c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `footprints`
  static const PhosphorDuotoneIconData footprints = PhosphorDuotoneIconData(
    figure: IconData(0xea89, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea88, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `fork-knife`
  static const PhosphorDuotoneIconData forkKnife = PhosphorDuotoneIconData(
    figure: IconData(0xe263, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe262, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `four-k`
  static const PhosphorDuotoneIconData fourK = PhosphorDuotoneIconData(
    figure: IconData(0xea5d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea5c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `frame-corners`
  static const PhosphorDuotoneIconData frameCorners = PhosphorDuotoneIconData(
    figure: IconData(0xe627, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe626, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `framer-logo`
  static const PhosphorDuotoneIconData framerLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe265, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe264, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `function`
  static const PhosphorDuotoneIconData function = PhosphorDuotoneIconData(
    figure: IconData(0xebe5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebe4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `funnel`
  static const PhosphorDuotoneIconData funnel = PhosphorDuotoneIconData(
    figure: IconData(0xe267, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe266, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `funnel-simple`
  static const PhosphorDuotoneIconData funnelSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe269, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe268, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `funnel-simple-x`
  static const PhosphorDuotoneIconData funnelSimpleX = PhosphorDuotoneIconData(
    figure: IconData(0xe26b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe26a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `funnel-x`
  static const PhosphorDuotoneIconData funnelX = PhosphorDuotoneIconData(
    figure: IconData(0xe26d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe26c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `game-controller`
  static const PhosphorDuotoneIconData gameController = PhosphorDuotoneIconData(
    figure: IconData(0xe26f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe26e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `garage`
  static const PhosphorDuotoneIconData garage = PhosphorDuotoneIconData(
    figure: IconData(0xecd7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecd6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gas-can`
  static const PhosphorDuotoneIconData gasCan = PhosphorDuotoneIconData(
    figure: IconData(0xe8cf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8ce, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gas-pump`
  static const PhosphorDuotoneIconData gasPump = PhosphorDuotoneIconData(
    figure: IconData(0xe769, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe768, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gauge`
  static const PhosphorDuotoneIconData gauge = PhosphorDuotoneIconData(
    figure: IconData(0xe629, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe628, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gavel`
  static const PhosphorDuotoneIconData gavel = PhosphorDuotoneIconData(
    figure: IconData(0xea33, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea32, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gear`
  static const PhosphorDuotoneIconData gear = PhosphorDuotoneIconData(
    figure: IconData(0xe271, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe270, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gear-fine`
  static const PhosphorDuotoneIconData gearFine = PhosphorDuotoneIconData(
    figure: IconData(0xe87d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe87c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gear-six`
  static const PhosphorDuotoneIconData gearSix = PhosphorDuotoneIconData(
    figure: IconData(0xe273, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe272, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gender-female`
  static const PhosphorDuotoneIconData genderFemale = PhosphorDuotoneIconData(
    figure: IconData(0xe6e1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6e0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gender-intersex`
  static const PhosphorDuotoneIconData genderIntersex = PhosphorDuotoneIconData(
    figure: IconData(0xe6e7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6e6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gender-male`
  static const PhosphorDuotoneIconData genderMale = PhosphorDuotoneIconData(
    figure: IconData(0xe6e3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6e2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gender-neuter`
  static const PhosphorDuotoneIconData genderNeuter = PhosphorDuotoneIconData(
    figure: IconData(0xe6eb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6ea, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gender-nonbinary`
  static const PhosphorDuotoneIconData
  genderNonbinary = PhosphorDuotoneIconData(
    figure: IconData(0xe6e5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6e4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gender-transgender`
  static const PhosphorDuotoneIconData
  genderTransgender = PhosphorDuotoneIconData(
    figure: IconData(0xe6e9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6e8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ghost`
  static const PhosphorDuotoneIconData ghost = PhosphorDuotoneIconData(
    figure: IconData(0xe62b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe62a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gif`
  static const PhosphorDuotoneIconData gif = PhosphorDuotoneIconData(
    figure: IconData(0xe275, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe274, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gift`
  static const PhosphorDuotoneIconData gift = PhosphorDuotoneIconData(
    figure: IconData(0xe277, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe276, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `git-branch`
  static const PhosphorDuotoneIconData gitBranch = PhosphorDuotoneIconData(
    figure: IconData(0xe279, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe278, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `git-commit`
  static const PhosphorDuotoneIconData gitCommit = PhosphorDuotoneIconData(
    figure: IconData(0xe27b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe27a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `git-diff`
  static const PhosphorDuotoneIconData gitDiff = PhosphorDuotoneIconData(
    figure: IconData(0xe27d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe27c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `git-fork`
  static const PhosphorDuotoneIconData gitFork = PhosphorDuotoneIconData(
    figure: IconData(0xe27f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe27e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `git-merge`
  static const PhosphorDuotoneIconData gitMerge = PhosphorDuotoneIconData(
    figure: IconData(0xe281, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe280, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `git-pull-request`
  static const PhosphorDuotoneIconData gitPullRequest = PhosphorDuotoneIconData(
    figure: IconData(0xe283, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe282, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `github-logo`
  static const PhosphorDuotoneIconData githubLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe577, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe576, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gitlab-logo`
  static const PhosphorDuotoneIconData gitlabLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe695, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe694, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gitlab-logo-simple`
  static const PhosphorDuotoneIconData
  gitlabLogoSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe697, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe696, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `globe`
  static const PhosphorDuotoneIconData globe = PhosphorDuotoneIconData(
    figure: IconData(0xe289, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe288, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `globe-hemisphere-east`
  static const PhosphorDuotoneIconData
  globeHemisphereEast = PhosphorDuotoneIconData(
    figure: IconData(0xe28b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe28a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `globe-hemisphere-west`
  static const PhosphorDuotoneIconData
  globeHemisphereWest = PhosphorDuotoneIconData(
    figure: IconData(0xe28d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe28c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `globe-simple`
  static const PhosphorDuotoneIconData globeSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe28f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe28e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `globe-simple-x`
  static const PhosphorDuotoneIconData globeSimpleX = PhosphorDuotoneIconData(
    figure: IconData(0xe285, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe284, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `globe-stand`
  static const PhosphorDuotoneIconData globeStand = PhosphorDuotoneIconData(
    figure: IconData(0xe291, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe290, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `globe-x`
  static const PhosphorDuotoneIconData globeX = PhosphorDuotoneIconData(
    figure: IconData(0xe287, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe286, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `goggles`
  static const PhosphorDuotoneIconData goggles = PhosphorDuotoneIconData(
    figure: IconData(0xecb5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecb4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `golf`
  static const PhosphorDuotoneIconData golf = PhosphorDuotoneIconData(
    figure: IconData(0xea3f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea3e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `goodreads-logo`
  static const PhosphorDuotoneIconData goodreadsLogo = PhosphorDuotoneIconData(
    figure: IconData(0xed11, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed10, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `google-cardboard-logo`
  static const PhosphorDuotoneIconData
  googleCardboardLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe7b7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7b6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `google-chrome-logo`
  static const PhosphorDuotoneIconData
  googleChromeLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe977, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe976, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `google-drive-logo`
  static const PhosphorDuotoneIconData
  googleDriveLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe8f7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8f6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `google-logo`
  static const PhosphorDuotoneIconData googleLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe293, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe292, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `google-photos-logo`
  static const PhosphorDuotoneIconData
  googlePhotosLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeb93, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb92, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `google-play-logo`
  static const PhosphorDuotoneIconData googlePlayLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe295, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe294, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `google-podcasts-logo`
  static const PhosphorDuotoneIconData
  googlePodcastsLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeb95, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb94, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gps`
  static const PhosphorDuotoneIconData gps = PhosphorDuotoneIconData(
    figure: IconData(0xedd9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedd8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gps-fix`
  static const PhosphorDuotoneIconData gpsFix = PhosphorDuotoneIconData(
    figure: IconData(0xedd7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedd6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gps-slash`
  static const PhosphorDuotoneIconData gpsSlash = PhosphorDuotoneIconData(
    figure: IconData(0xedd5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedd4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `gradient`
  static const PhosphorDuotoneIconData gradient = PhosphorDuotoneIconData(
    figure: IconData(0xeb4d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb42, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `graduation-cap`
  static const PhosphorDuotoneIconData graduationCap = PhosphorDuotoneIconData(
    figure: IconData(0xe62d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe62c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `grains`
  static const PhosphorDuotoneIconData grains = PhosphorDuotoneIconData(
    figure: IconData(0xec69, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec68, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `grains-slash`
  static const PhosphorDuotoneIconData grainsSlash = PhosphorDuotoneIconData(
    figure: IconData(0xec6b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec6a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `graph`
  static const PhosphorDuotoneIconData graph = PhosphorDuotoneIconData(
    figure: IconData(0xeb59, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb58, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `graphics-card`
  static const PhosphorDuotoneIconData graphicsCard = PhosphorDuotoneIconData(
    figure: IconData(0xe613, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe612, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `greater-than`
  static const PhosphorDuotoneIconData greaterThan = PhosphorDuotoneIconData(
    figure: IconData(0xedc5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedc4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `greater-than-or-equal`
  static const PhosphorDuotoneIconData
  greaterThanOrEqual = PhosphorDuotoneIconData(
    figure: IconData(0xeda3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeda2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `grid-four`
  static const PhosphorDuotoneIconData gridFour = PhosphorDuotoneIconData(
    figure: IconData(0xe297, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe296, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `grid-nine`
  static const PhosphorDuotoneIconData gridNine = PhosphorDuotoneIconData(
    figure: IconData(0xec8d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec8c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `guitar`
  static const PhosphorDuotoneIconData guitar = PhosphorDuotoneIconData(
    figure: IconData(0xea8b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea8a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hair-dryer`
  static const PhosphorDuotoneIconData hairDryer = PhosphorDuotoneIconData(
    figure: IconData(0xea67, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea66, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hamburger`
  static const PhosphorDuotoneIconData hamburger = PhosphorDuotoneIconData(
    figure: IconData(0xe791, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe790, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hammer`
  static const PhosphorDuotoneIconData hammer = PhosphorDuotoneIconData(
    figure: IconData(0xe80f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe80e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand`
  static const PhosphorDuotoneIconData hand = PhosphorDuotoneIconData(
    figure: IconData(0xe299, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe298, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-arrow-down`
  static const PhosphorDuotoneIconData handArrowDown = PhosphorDuotoneIconData(
    figure: IconData(0xea4f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea4e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-arrow-up`
  static const PhosphorDuotoneIconData handArrowUp = PhosphorDuotoneIconData(
    figure: IconData(0xee5b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee5a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-coins`
  static const PhosphorDuotoneIconData handCoins = PhosphorDuotoneIconData(
    figure: IconData(0xea8d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea8c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-deposit`
  static const PhosphorDuotoneIconData handDeposit = PhosphorDuotoneIconData(
    figure: IconData(0xee83, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee82, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-eye`
  static const PhosphorDuotoneIconData handEye = PhosphorDuotoneIconData(
    figure: IconData(0xea4d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea4c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-fist`
  static const PhosphorDuotoneIconData handFist = PhosphorDuotoneIconData(
    figure: IconData(0xe57b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe57a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-grabbing`
  static const PhosphorDuotoneIconData handGrabbing = PhosphorDuotoneIconData(
    figure: IconData(0xe57d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe57c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-heart`
  static const PhosphorDuotoneIconData handHeart = PhosphorDuotoneIconData(
    figure: IconData(0xe811, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe810, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-palm`
  static const PhosphorDuotoneIconData handPalm = PhosphorDuotoneIconData(
    figure: IconData(0xe57f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe57e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-peace`
  static const PhosphorDuotoneIconData handPeace = PhosphorDuotoneIconData(
    figure: IconData(0xe7cd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7cc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-pointing`
  static const PhosphorDuotoneIconData handPointing = PhosphorDuotoneIconData(
    figure: IconData(0xe29b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe29a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-soap`
  static const PhosphorDuotoneIconData handSoap = PhosphorDuotoneIconData(
    figure: IconData(0xe631, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe630, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-swipe-left`
  static const PhosphorDuotoneIconData handSwipeLeft = PhosphorDuotoneIconData(
    figure: IconData(0xec95, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec94, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-swipe-right`
  static const PhosphorDuotoneIconData handSwipeRight = PhosphorDuotoneIconData(
    figure: IconData(0xec93, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec92, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-tap`
  static const PhosphorDuotoneIconData handTap = PhosphorDuotoneIconData(
    figure: IconData(0xec91, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec90, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-waving`
  static const PhosphorDuotoneIconData handWaving = PhosphorDuotoneIconData(
    figure: IconData(0xe581, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe580, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hand-withdraw`
  static const PhosphorDuotoneIconData handWithdraw = PhosphorDuotoneIconData(
    figure: IconData(0xee81, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee80, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `handbag`
  static const PhosphorDuotoneIconData handbag = PhosphorDuotoneIconData(
    figure: IconData(0xe29d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe29c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `handbag-simple`
  static const PhosphorDuotoneIconData handbagSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe62f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe62e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hands-clapping`
  static const PhosphorDuotoneIconData handsClapping = PhosphorDuotoneIconData(
    figure: IconData(0xe6a1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6a0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hands-praying`
  static const PhosphorDuotoneIconData handsPraying = PhosphorDuotoneIconData(
    figure: IconData(0xecc9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecc8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `handshake`
  static const PhosphorDuotoneIconData handshake = PhosphorDuotoneIconData(
    figure: IconData(0xe583, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe582, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hard-drive`
  static const PhosphorDuotoneIconData hardDrive = PhosphorDuotoneIconData(
    figure: IconData(0xe29f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe29e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hard-drives`
  static const PhosphorDuotoneIconData hardDrives = PhosphorDuotoneIconData(
    figure: IconData(0xe2a1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2a0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hard-hat`
  static const PhosphorDuotoneIconData hardHat = PhosphorDuotoneIconData(
    figure: IconData(0xed47, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed46, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hash`
  static const PhosphorDuotoneIconData hash = PhosphorDuotoneIconData(
    figure: IconData(0xe2a3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2a2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hash-straight`
  static const PhosphorDuotoneIconData hashStraight = PhosphorDuotoneIconData(
    figure: IconData(0xe2a5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2a4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `head-circuit`
  static const PhosphorDuotoneIconData headCircuit = PhosphorDuotoneIconData(
    figure: IconData(0xe7d5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7d4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `headlights`
  static const PhosphorDuotoneIconData headlights = PhosphorDuotoneIconData(
    figure: IconData(0xe6ff, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6fe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `headphones`
  static const PhosphorDuotoneIconData headphones = PhosphorDuotoneIconData(
    figure: IconData(0xe2a7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2a6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `headset`
  static const PhosphorDuotoneIconData headset = PhosphorDuotoneIconData(
    figure: IconData(0xe585, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe584, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `heart`
  static const PhosphorDuotoneIconData heart = PhosphorDuotoneIconData(
    figure: IconData(0xe2a9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2a8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `heart-break`
  static const PhosphorDuotoneIconData heartBreak = PhosphorDuotoneIconData(
    figure: IconData(0xebe9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebe8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `heart-half`
  static const PhosphorDuotoneIconData heartHalf = PhosphorDuotoneIconData(
    figure: IconData(0xec49, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec48, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `heart-straight`
  static const PhosphorDuotoneIconData heartStraight = PhosphorDuotoneIconData(
    figure: IconData(0xe2ab, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2aa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `heart-straight-break`
  static const PhosphorDuotoneIconData
  heartStraightBreak = PhosphorDuotoneIconData(
    figure: IconData(0xeb99, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb98, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `heartbeat`
  static const PhosphorDuotoneIconData heartbeat = PhosphorDuotoneIconData(
    figure: IconData(0xe2ad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2ac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hexagon`
  static const PhosphorDuotoneIconData hexagon = PhosphorDuotoneIconData(
    figure: IconData(0xe2af, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2ae, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `high-definition`
  static const PhosphorDuotoneIconData highDefinition = PhosphorDuotoneIconData(
    figure: IconData(0xea8f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea8e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `high-heel`
  static const PhosphorDuotoneIconData highHeel = PhosphorDuotoneIconData(
    figure: IconData(0xe8e9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8e8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `highlighter`
  static const PhosphorDuotoneIconData highlighter = PhosphorDuotoneIconData(
    figure: IconData(0xec77, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec76, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `highlighter-circle`
  static const PhosphorDuotoneIconData
  highlighterCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe633, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe632, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hockey`
  static const PhosphorDuotoneIconData hockey = PhosphorDuotoneIconData(
    figure: IconData(0xec87, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec86, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hoodie`
  static const PhosphorDuotoneIconData hoodie = PhosphorDuotoneIconData(
    figure: IconData(0xecd1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecd0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `horse`
  static const PhosphorDuotoneIconData horse = PhosphorDuotoneIconData(
    figure: IconData(0xe2b1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2b0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hospital`
  static const PhosphorDuotoneIconData hospital = PhosphorDuotoneIconData(
    figure: IconData(0xe845, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe844, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hourglass`
  static const PhosphorDuotoneIconData hourglass = PhosphorDuotoneIconData(
    figure: IconData(0xe2b3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2b2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hourglass-high`
  static const PhosphorDuotoneIconData hourglassHigh = PhosphorDuotoneIconData(
    figure: IconData(0xe2b5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2b4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hourglass-low`
  static const PhosphorDuotoneIconData hourglassLow = PhosphorDuotoneIconData(
    figure: IconData(0xe2b7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2b6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hourglass-medium`
  static const PhosphorDuotoneIconData
  hourglassMedium = PhosphorDuotoneIconData(
    figure: IconData(0xe2b9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2b8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hourglass-simple`
  static const PhosphorDuotoneIconData
  hourglassSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe2bb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2ba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hourglass-simple-high`
  static const PhosphorDuotoneIconData
  hourglassSimpleHigh = PhosphorDuotoneIconData(
    figure: IconData(0xe2bd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2bc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hourglass-simple-low`
  static const PhosphorDuotoneIconData
  hourglassSimpleLow = PhosphorDuotoneIconData(
    figure: IconData(0xe2bf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2be, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hourglass-simple-medium`
  static const PhosphorDuotoneIconData
  hourglassSimpleMedium = PhosphorDuotoneIconData(
    figure: IconData(0xe2c1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2c0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `house`
  static const PhosphorDuotoneIconData house = PhosphorDuotoneIconData(
    figure: IconData(0xe2c3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2c2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `house-line`
  static const PhosphorDuotoneIconData houseLine = PhosphorDuotoneIconData(
    figure: IconData(0xe2c5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2c4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `house-simple`
  static const PhosphorDuotoneIconData houseSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe2c7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2c6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `hurricane`
  static const PhosphorDuotoneIconData hurricane = PhosphorDuotoneIconData(
    figure: IconData(0xe88f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe88e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ice-cream`
  static const PhosphorDuotoneIconData iceCream = PhosphorDuotoneIconData(
    figure: IconData(0xe805, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe804, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `identification-badge`
  static const PhosphorDuotoneIconData
  identificationBadge = PhosphorDuotoneIconData(
    figure: IconData(0xe6f7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6f6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `identification-card`
  static const PhosphorDuotoneIconData
  identificationCard = PhosphorDuotoneIconData(
    figure: IconData(0xe2c9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2c8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `image`
  static const PhosphorDuotoneIconData image = PhosphorDuotoneIconData(
    figure: IconData(0xe2cb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2ca, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `image-broken`
  static const PhosphorDuotoneIconData imageBroken = PhosphorDuotoneIconData(
    figure: IconData(0xe7a9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7a8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `image-square`
  static const PhosphorDuotoneIconData imageSquare = PhosphorDuotoneIconData(
    figure: IconData(0xe2cd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2cc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `images`
  static const PhosphorDuotoneIconData images = PhosphorDuotoneIconData(
    figure: IconData(0xe837, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe836, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `images-square`
  static const PhosphorDuotoneIconData imagesSquare = PhosphorDuotoneIconData(
    figure: IconData(0xe835, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe834, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `infinity`
  static const PhosphorDuotoneIconData infinity = PhosphorDuotoneIconData(
    figure: IconData(0xe635, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe634, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `info`
  static const PhosphorDuotoneIconData info = PhosphorDuotoneIconData(
    figure: IconData(0xe2cf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2ce, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `instagram-logo`
  static const PhosphorDuotoneIconData instagramLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe2d1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2d0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `intersect`
  static const PhosphorDuotoneIconData intersect = PhosphorDuotoneIconData(
    figure: IconData(0xe2d3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2d2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `intersect-square`
  static const PhosphorDuotoneIconData
  intersectSquare = PhosphorDuotoneIconData(
    figure: IconData(0xe87b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe87a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `intersect-three`
  static const PhosphorDuotoneIconData intersectThree = PhosphorDuotoneIconData(
    figure: IconData(0xecc5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecc4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `intersection`
  static const PhosphorDuotoneIconData intersection = PhosphorDuotoneIconData(
    figure: IconData(0xedbb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `invoice`
  static const PhosphorDuotoneIconData invoice = PhosphorDuotoneIconData(
    figure: IconData(0xee43, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee42, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `island`
  static const PhosphorDuotoneIconData island = PhosphorDuotoneIconData(
    figure: IconData(0xee07, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee06, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `jar`
  static const PhosphorDuotoneIconData jar = PhosphorDuotoneIconData(
    figure: IconData(0xe7e3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7e0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `jar-label`
  static const PhosphorDuotoneIconData jarLabel = PhosphorDuotoneIconData(
    figure: IconData(0xe7e5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7e1, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `jeep`
  static const PhosphorDuotoneIconData jeep = PhosphorDuotoneIconData(
    figure: IconData(0xe2d5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2d4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `joystick`
  static const PhosphorDuotoneIconData joystick = PhosphorDuotoneIconData(
    figure: IconData(0xea5f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea5e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `kanban`
  static const PhosphorDuotoneIconData kanban = PhosphorDuotoneIconData(
    figure: IconData(0xeb55, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb54, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `key`
  static const PhosphorDuotoneIconData key = PhosphorDuotoneIconData(
    figure: IconData(0xe2d7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2d6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `key-return`
  static const PhosphorDuotoneIconData keyReturn = PhosphorDuotoneIconData(
    figure: IconData(0xe783, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe782, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `keyboard`
  static const PhosphorDuotoneIconData keyboard = PhosphorDuotoneIconData(
    figure: IconData(0xe2d9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2d8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `keyhole`
  static const PhosphorDuotoneIconData keyhole = PhosphorDuotoneIconData(
    figure: IconData(0xea79, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea78, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `knife`
  static const PhosphorDuotoneIconData knife = PhosphorDuotoneIconData(
    figure: IconData(0xe637, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe636, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ladder`
  static const PhosphorDuotoneIconData ladder = PhosphorDuotoneIconData(
    figure: IconData(0xe9e5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9e4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ladder-simple`
  static const PhosphorDuotoneIconData ladderSimple = PhosphorDuotoneIconData(
    figure: IconData(0xec27, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec26, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lamp`
  static const PhosphorDuotoneIconData lamp = PhosphorDuotoneIconData(
    figure: IconData(0xe639, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe638, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lamp-pendant`
  static const PhosphorDuotoneIconData lampPendant = PhosphorDuotoneIconData(
    figure: IconData(0xee2f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee2e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `laptop`
  static const PhosphorDuotoneIconData laptop = PhosphorDuotoneIconData(
    figure: IconData(0xe587, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe586, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lasso`
  static const PhosphorDuotoneIconData lasso = PhosphorDuotoneIconData(
    figure: IconData(0xedc7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedc6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lastfm-logo`
  static const PhosphorDuotoneIconData lastfmLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe843, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe842, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `layout`
  static const PhosphorDuotoneIconData layout = PhosphorDuotoneIconData(
    figure: IconData(0xe6d7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6d6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `leaf`
  static const PhosphorDuotoneIconData leaf = PhosphorDuotoneIconData(
    figure: IconData(0xe2db, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2da, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lectern`
  static const PhosphorDuotoneIconData lectern = PhosphorDuotoneIconData(
    figure: IconData(0xe95b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe95a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lego`
  static const PhosphorDuotoneIconData lego = PhosphorDuotoneIconData(
    figure: IconData(0xe8c8, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8c6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lego-smiley`
  static const PhosphorDuotoneIconData legoSmiley = PhosphorDuotoneIconData(
    figure: IconData(0xe8c9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8c7, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lemniscate` — apelido de `infinity`
  static const PhosphorDuotoneIconData lemniscate = PhosphorDuotoneIconData(
    figure: IconData(0xe635, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe634, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `less-than`
  static const PhosphorDuotoneIconData lessThan = PhosphorDuotoneIconData(
    figure: IconData(0xedad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `less-than-or-equal`
  static const PhosphorDuotoneIconData
  lessThanOrEqual = PhosphorDuotoneIconData(
    figure: IconData(0xeda5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeda4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `letter-circle-h`
  static const PhosphorDuotoneIconData letterCircleH = PhosphorDuotoneIconData(
    figure: IconData(0xebf9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebf8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `letter-circle-p`
  static const PhosphorDuotoneIconData letterCircleP = PhosphorDuotoneIconData(
    figure: IconData(0xec09, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec08, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `letter-circle-v`
  static const PhosphorDuotoneIconData letterCircleV = PhosphorDuotoneIconData(
    figure: IconData(0xec15, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec14, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lifebuoy`
  static const PhosphorDuotoneIconData lifebuoy = PhosphorDuotoneIconData(
    figure: IconData(0xe63b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe63a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lightbulb`
  static const PhosphorDuotoneIconData lightbulb = PhosphorDuotoneIconData(
    figure: IconData(0xe2dd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2dc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lightbulb-filament`
  static const PhosphorDuotoneIconData
  lightbulbFilament = PhosphorDuotoneIconData(
    figure: IconData(0xe63d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe63c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lighthouse`
  static const PhosphorDuotoneIconData lighthouse = PhosphorDuotoneIconData(
    figure: IconData(0xe9f7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9f6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lightning`
  static const PhosphorDuotoneIconData lightning = PhosphorDuotoneIconData(
    figure: IconData(0xe2df, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2de, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lightning-a`
  static const PhosphorDuotoneIconData lightningA = PhosphorDuotoneIconData(
    figure: IconData(0xea85, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea84, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lightning-slash`
  static const PhosphorDuotoneIconData lightningSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe2e1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2e0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `line-segment`
  static const PhosphorDuotoneIconData lineSegment = PhosphorDuotoneIconData(
    figure: IconData(0xe6d3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6d2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `line-segments`
  static const PhosphorDuotoneIconData lineSegments = PhosphorDuotoneIconData(
    figure: IconData(0xe6d5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6d4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `line-vertical`
  static const PhosphorDuotoneIconData lineVertical = PhosphorDuotoneIconData(
    figure: IconData(0xed71, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed70, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `link`
  static const PhosphorDuotoneIconData link = PhosphorDuotoneIconData(
    figure: IconData(0xe2e3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2e2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `link-break`
  static const PhosphorDuotoneIconData linkBreak = PhosphorDuotoneIconData(
    figure: IconData(0xe2e5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2e4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `link-simple`
  static const PhosphorDuotoneIconData linkSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe2e7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2e6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `link-simple-break`
  static const PhosphorDuotoneIconData
  linkSimpleBreak = PhosphorDuotoneIconData(
    figure: IconData(0xe2e9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2e8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `link-simple-horizontal`
  static const PhosphorDuotoneIconData
  linkSimpleHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xe2eb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2ea, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `link-simple-horizontal-break`
  static const PhosphorDuotoneIconData
  linkSimpleHorizontalBreak = PhosphorDuotoneIconData(
    figure: IconData(0xe2ed, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2ec, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `linkedin-logo`
  static const PhosphorDuotoneIconData linkedinLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe2ef, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2ee, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `linktree-logo`
  static const PhosphorDuotoneIconData linktreeLogo = PhosphorDuotoneIconData(
    figure: IconData(0xedef, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedee, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `linux-logo`
  static const PhosphorDuotoneIconData linuxLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeb03, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb02, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `list`
  static const PhosphorDuotoneIconData list = PhosphorDuotoneIconData(
    figure: IconData(0xe2f1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2f0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `list-bullets`
  static const PhosphorDuotoneIconData listBullets = PhosphorDuotoneIconData(
    figure: IconData(0xe2f3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2f2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `list-checks`
  static const PhosphorDuotoneIconData listChecks = PhosphorDuotoneIconData(
    figure: IconData(0xeadd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeadc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `list-dashes`
  static const PhosphorDuotoneIconData listDashes = PhosphorDuotoneIconData(
    figure: IconData(0xe2f5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2f4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `list-heart`
  static const PhosphorDuotoneIconData listHeart = PhosphorDuotoneIconData(
    figure: IconData(0xebdf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebde, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `list-magnifying-glass`
  static const PhosphorDuotoneIconData
  listMagnifyingGlass = PhosphorDuotoneIconData(
    figure: IconData(0xebe1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebe0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `list-numbers`
  static const PhosphorDuotoneIconData listNumbers = PhosphorDuotoneIconData(
    figure: IconData(0xe2f7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2f6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `list-plus`
  static const PhosphorDuotoneIconData listPlus = PhosphorDuotoneIconData(
    figure: IconData(0xe2f9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2f8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `list-star`
  static const PhosphorDuotoneIconData listStar = PhosphorDuotoneIconData(
    figure: IconData(0xebdd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebdc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lock`
  static const PhosphorDuotoneIconData lock = PhosphorDuotoneIconData(
    figure: IconData(0xe2fb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2fa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lock-key`
  static const PhosphorDuotoneIconData lockKey = PhosphorDuotoneIconData(
    figure: IconData(0xe2ff, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe2fe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lock-key-open`
  static const PhosphorDuotoneIconData lockKeyOpen = PhosphorDuotoneIconData(
    figure: IconData(0xe301, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe300, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lock-laminated`
  static const PhosphorDuotoneIconData lockLaminated = PhosphorDuotoneIconData(
    figure: IconData(0xe303, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe302, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lock-laminated-open`
  static const PhosphorDuotoneIconData
  lockLaminatedOpen = PhosphorDuotoneIconData(
    figure: IconData(0xe305, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe304, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lock-open`
  static const PhosphorDuotoneIconData lockOpen = PhosphorDuotoneIconData(
    figure: IconData(0xe307, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe306, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lock-simple`
  static const PhosphorDuotoneIconData lockSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe309, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe308, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lock-simple-open`
  static const PhosphorDuotoneIconData lockSimpleOpen = PhosphorDuotoneIconData(
    figure: IconData(0xe30b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe30a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `lockers`
  static const PhosphorDuotoneIconData lockers = PhosphorDuotoneIconData(
    figure: IconData(0xecb9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecb8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `log`
  static const PhosphorDuotoneIconData log = PhosphorDuotoneIconData(
    figure: IconData(0xed83, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed82, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `magic-wand`
  static const PhosphorDuotoneIconData magicWand = PhosphorDuotoneIconData(
    figure: IconData(0xe6b7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6b6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `magnet`
  static const PhosphorDuotoneIconData magnet = PhosphorDuotoneIconData(
    figure: IconData(0xe681, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe680, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `magnet-straight`
  static const PhosphorDuotoneIconData magnetStraight = PhosphorDuotoneIconData(
    figure: IconData(0xe683, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe682, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `magnifying-glass`
  static const PhosphorDuotoneIconData
  magnifyingGlass = PhosphorDuotoneIconData(
    figure: IconData(0xe30d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe30c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `magnifying-glass-minus`
  static const PhosphorDuotoneIconData
  magnifyingGlassMinus = PhosphorDuotoneIconData(
    figure: IconData(0xe30f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe30e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `magnifying-glass-plus`
  static const PhosphorDuotoneIconData
  magnifyingGlassPlus = PhosphorDuotoneIconData(
    figure: IconData(0xe311, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe310, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mailbox`
  static const PhosphorDuotoneIconData mailbox = PhosphorDuotoneIconData(
    figure: IconData(0xec1f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec1e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `map-pin`
  static const PhosphorDuotoneIconData mapPin = PhosphorDuotoneIconData(
    figure: IconData(0xe317, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe316, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `map-pin-area`
  static const PhosphorDuotoneIconData mapPinArea = PhosphorDuotoneIconData(
    figure: IconData(0xee3b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee3a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `map-pin-line`
  static const PhosphorDuotoneIconData mapPinLine = PhosphorDuotoneIconData(
    figure: IconData(0xe319, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe318, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `map-pin-plus`
  static const PhosphorDuotoneIconData mapPinPlus = PhosphorDuotoneIconData(
    figure: IconData(0xe315, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe314, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `map-pin-simple`
  static const PhosphorDuotoneIconData mapPinSimple = PhosphorDuotoneIconData(
    figure: IconData(0xee3f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee3e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `map-pin-simple-area`
  static const PhosphorDuotoneIconData
  mapPinSimpleArea = PhosphorDuotoneIconData(
    figure: IconData(0xee3d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee3c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `map-pin-simple-line`
  static const PhosphorDuotoneIconData
  mapPinSimpleLine = PhosphorDuotoneIconData(
    figure: IconData(0xee39, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee38, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `map-trifold`
  static const PhosphorDuotoneIconData mapTrifold = PhosphorDuotoneIconData(
    figure: IconData(0xe31b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe31a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `markdown-logo`
  static const PhosphorDuotoneIconData markdownLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe509, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe508, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `marker-circle`
  static const PhosphorDuotoneIconData markerCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe641, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe640, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `martini`
  static const PhosphorDuotoneIconData martini = PhosphorDuotoneIconData(
    figure: IconData(0xe31d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe31c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mask-happy`
  static const PhosphorDuotoneIconData maskHappy = PhosphorDuotoneIconData(
    figure: IconData(0xe9f5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9f4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mask-sad`
  static const PhosphorDuotoneIconData maskSad = PhosphorDuotoneIconData(
    figure: IconData(0xeb9f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb9e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mastodon-logo`
  static const PhosphorDuotoneIconData mastodonLogo = PhosphorDuotoneIconData(
    figure: IconData(0xed69, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed68, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `math-operations`
  static const PhosphorDuotoneIconData mathOperations = PhosphorDuotoneIconData(
    figure: IconData(0xe31f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe31e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `matrix-logo`
  static const PhosphorDuotoneIconData matrixLogo = PhosphorDuotoneIconData(
    figure: IconData(0xed65, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed64, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `medal`
  static const PhosphorDuotoneIconData medal = PhosphorDuotoneIconData(
    figure: IconData(0xe321, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe320, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `medal-military`
  static const PhosphorDuotoneIconData medalMilitary = PhosphorDuotoneIconData(
    figure: IconData(0xecfd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecfc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `medium-logo`
  static const PhosphorDuotoneIconData mediumLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe323, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe322, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `megaphone`
  static const PhosphorDuotoneIconData megaphone = PhosphorDuotoneIconData(
    figure: IconData(0xe325, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe324, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `megaphone-simple`
  static const PhosphorDuotoneIconData
  megaphoneSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe643, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe642, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `member-of`
  static const PhosphorDuotoneIconData memberOf = PhosphorDuotoneIconData(
    figure: IconData(0xedc3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedc2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `memory`
  static const PhosphorDuotoneIconData memory = PhosphorDuotoneIconData(
    figure: IconData(0xe9c5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9c4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `messenger-logo`
  static const PhosphorDuotoneIconData messengerLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe6d9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6d8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `meta-logo`
  static const PhosphorDuotoneIconData metaLogo = PhosphorDuotoneIconData(
    figure: IconData(0xed03, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed02, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `meteor`
  static const PhosphorDuotoneIconData meteor = PhosphorDuotoneIconData(
    figure: IconData(0xe9bb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9ba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `metronome`
  static const PhosphorDuotoneIconData metronome = PhosphorDuotoneIconData(
    figure: IconData(0xec8f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec8e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `microphone`
  static const PhosphorDuotoneIconData microphone = PhosphorDuotoneIconData(
    figure: IconData(0xe327, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe326, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `microphone-slash`
  static const PhosphorDuotoneIconData
  microphoneSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe329, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe328, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `microphone-stage`
  static const PhosphorDuotoneIconData
  microphoneStage = PhosphorDuotoneIconData(
    figure: IconData(0xe75d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe75c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `microscope`
  static const PhosphorDuotoneIconData microscope = PhosphorDuotoneIconData(
    figure: IconData(0xec7b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec7a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `microsoft-excel-logo`
  static const PhosphorDuotoneIconData
  microsoftExcelLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeb6d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb6c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `microsoft-outlook-logo`
  static const PhosphorDuotoneIconData
  microsoftOutlookLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeb71, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb70, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `microsoft-powerpoint-logo`
  static const PhosphorDuotoneIconData
  microsoftPowerpointLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeacf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeace, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `microsoft-teams-logo`
  static const PhosphorDuotoneIconData
  microsoftTeamsLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeb67, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb66, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `microsoft-word-logo`
  static const PhosphorDuotoneIconData
  microsoftWordLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeb6b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb6a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `minus`
  static const PhosphorDuotoneIconData minus = PhosphorDuotoneIconData(
    figure: IconData(0xe32b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe32a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `minus-circle`
  static const PhosphorDuotoneIconData minusCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe32d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe32c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `minus-square`
  static const PhosphorDuotoneIconData minusSquare = PhosphorDuotoneIconData(
    figure: IconData(0xed53, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed4c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `money`
  static const PhosphorDuotoneIconData money = PhosphorDuotoneIconData(
    figure: IconData(0xe589, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe588, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `money-wavy`
  static const PhosphorDuotoneIconData moneyWavy = PhosphorDuotoneIconData(
    figure: IconData(0xee69, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee68, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `monitor`
  static const PhosphorDuotoneIconData monitor = PhosphorDuotoneIconData(
    figure: IconData(0xe32f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe32e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `monitor-arrow-up`
  static const PhosphorDuotoneIconData monitorArrowUp = PhosphorDuotoneIconData(
    figure: IconData(0xe58b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe58a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `monitor-play`
  static const PhosphorDuotoneIconData monitorPlay = PhosphorDuotoneIconData(
    figure: IconData(0xe58d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe58c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `moon`
  static const PhosphorDuotoneIconData moon = PhosphorDuotoneIconData(
    figure: IconData(0xe331, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe330, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `moon-stars`
  static const PhosphorDuotoneIconData moonStars = PhosphorDuotoneIconData(
    figure: IconData(0xe58f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe58e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `moped`
  static const PhosphorDuotoneIconData moped = PhosphorDuotoneIconData(
    figure: IconData(0xe825, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe824, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `moped-front`
  static const PhosphorDuotoneIconData mopedFront = PhosphorDuotoneIconData(
    figure: IconData(0xe823, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe822, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mosque`
  static const PhosphorDuotoneIconData mosque = PhosphorDuotoneIconData(
    figure: IconData(0xecef, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecee, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `motorcycle`
  static const PhosphorDuotoneIconData motorcycle = PhosphorDuotoneIconData(
    figure: IconData(0xe80b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe80a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mountains`
  static const PhosphorDuotoneIconData mountains = PhosphorDuotoneIconData(
    figure: IconData(0xe7af, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7ae, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mouse`
  static const PhosphorDuotoneIconData mouse = PhosphorDuotoneIconData(
    figure: IconData(0xe33b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe33a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mouse-left-click`
  static const PhosphorDuotoneIconData mouseLeftClick = PhosphorDuotoneIconData(
    figure: IconData(0xe335, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe334, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mouse-middle-click`
  static const PhosphorDuotoneIconData
  mouseMiddleClick = PhosphorDuotoneIconData(
    figure: IconData(0xe339, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe338, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mouse-right-click`
  static const PhosphorDuotoneIconData
  mouseRightClick = PhosphorDuotoneIconData(
    figure: IconData(0xe337, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe336, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mouse-scroll`
  static const PhosphorDuotoneIconData mouseScroll = PhosphorDuotoneIconData(
    figure: IconData(0xe333, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe332, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `mouse-simple`
  static const PhosphorDuotoneIconData mouseSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe645, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe644, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `music-note`
  static const PhosphorDuotoneIconData musicNote = PhosphorDuotoneIconData(
    figure: IconData(0xe33d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe33c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `music-note-simple`
  static const PhosphorDuotoneIconData
  musicNoteSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe33f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe33e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `music-notes`
  static const PhosphorDuotoneIconData musicNotes = PhosphorDuotoneIconData(
    figure: IconData(0xe341, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe340, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `music-notes-minus`
  static const PhosphorDuotoneIconData
  musicNotesMinus = PhosphorDuotoneIconData(
    figure: IconData(0xee0d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee0c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `music-notes-plus`
  static const PhosphorDuotoneIconData musicNotesPlus = PhosphorDuotoneIconData(
    figure: IconData(0xeb7d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb7c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `music-notes-simple`
  static const PhosphorDuotoneIconData
  musicNotesSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe343, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe342, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `navigation-arrow`
  static const PhosphorDuotoneIconData
  navigationArrow = PhosphorDuotoneIconData(
    figure: IconData(0xeadf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeade, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `needle`
  static const PhosphorDuotoneIconData needle = PhosphorDuotoneIconData(
    figure: IconData(0xe82f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe82e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `network`
  static const PhosphorDuotoneIconData network = PhosphorDuotoneIconData(
    figure: IconData(0xeddf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedde, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `network-slash`
  static const PhosphorDuotoneIconData networkSlash = PhosphorDuotoneIconData(
    figure: IconData(0xeddd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeddc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `network-x`
  static const PhosphorDuotoneIconData networkX = PhosphorDuotoneIconData(
    figure: IconData(0xeddb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedda, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `newspaper`
  static const PhosphorDuotoneIconData newspaper = PhosphorDuotoneIconData(
    figure: IconData(0xe345, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe344, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `newspaper-clipping`
  static const PhosphorDuotoneIconData
  newspaperClipping = PhosphorDuotoneIconData(
    figure: IconData(0xe347, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe346, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `not-equals`
  static const PhosphorDuotoneIconData notEquals = PhosphorDuotoneIconData(
    figure: IconData(0xeda7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeda6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `not-member-of`
  static const PhosphorDuotoneIconData notMemberOf = PhosphorDuotoneIconData(
    figure: IconData(0xedaf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedae, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `not-subset-of`
  static const PhosphorDuotoneIconData notSubsetOf = PhosphorDuotoneIconData(
    figure: IconData(0xedb1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedb0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `not-superset-of`
  static const PhosphorDuotoneIconData notSupersetOf = PhosphorDuotoneIconData(
    figure: IconData(0xedb3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedb2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `notches`
  static const PhosphorDuotoneIconData notches = PhosphorDuotoneIconData(
    figure: IconData(0xed3b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed3a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `note`
  static const PhosphorDuotoneIconData note = PhosphorDuotoneIconData(
    figure: IconData(0xe349, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe348, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `note-blank`
  static const PhosphorDuotoneIconData noteBlank = PhosphorDuotoneIconData(
    figure: IconData(0xe34b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe34a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `note-pencil`
  static const PhosphorDuotoneIconData notePencil = PhosphorDuotoneIconData(
    figure: IconData(0xe34d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe34c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `notebook`
  static const PhosphorDuotoneIconData notebook = PhosphorDuotoneIconData(
    figure: IconData(0xe34f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe34e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `notepad`
  static const PhosphorDuotoneIconData notepad = PhosphorDuotoneIconData(
    figure: IconData(0xe63f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe63e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `notification`
  static const PhosphorDuotoneIconData notification = PhosphorDuotoneIconData(
    figure: IconData(0xe6fb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6fa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `notion-logo`
  static const PhosphorDuotoneIconData notionLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe9a1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9a0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `nuclear-plant`
  static const PhosphorDuotoneIconData nuclearPlant = PhosphorDuotoneIconData(
    figure: IconData(0xed7d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed7c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-circle-eight`
  static const PhosphorDuotoneIconData
  numberCircleEight = PhosphorDuotoneIconData(
    figure: IconData(0xe353, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe352, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-circle-five`
  static const PhosphorDuotoneIconData
  numberCircleFive = PhosphorDuotoneIconData(
    figure: IconData(0xe359, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe358, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-circle-four`
  static const PhosphorDuotoneIconData
  numberCircleFour = PhosphorDuotoneIconData(
    figure: IconData(0xe35f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe35e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-circle-nine`
  static const PhosphorDuotoneIconData
  numberCircleNine = PhosphorDuotoneIconData(
    figure: IconData(0xe365, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe364, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-circle-one`
  static const PhosphorDuotoneIconData
  numberCircleOne = PhosphorDuotoneIconData(
    figure: IconData(0xe36b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe36a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-circle-seven`
  static const PhosphorDuotoneIconData
  numberCircleSeven = PhosphorDuotoneIconData(
    figure: IconData(0xe371, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe370, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-circle-six`
  static const PhosphorDuotoneIconData
  numberCircleSix = PhosphorDuotoneIconData(
    figure: IconData(0xe377, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe376, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-circle-three`
  static const PhosphorDuotoneIconData
  numberCircleThree = PhosphorDuotoneIconData(
    figure: IconData(0xe37d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe37c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-circle-two`
  static const PhosphorDuotoneIconData
  numberCircleTwo = PhosphorDuotoneIconData(
    figure: IconData(0xe383, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe382, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-circle-zero`
  static const PhosphorDuotoneIconData
  numberCircleZero = PhosphorDuotoneIconData(
    figure: IconData(0xe389, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe388, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-eight`
  static const PhosphorDuotoneIconData numberEight = PhosphorDuotoneIconData(
    figure: IconData(0xe351, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe350, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-five`
  static const PhosphorDuotoneIconData numberFive = PhosphorDuotoneIconData(
    figure: IconData(0xe357, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe356, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-four`
  static const PhosphorDuotoneIconData numberFour = PhosphorDuotoneIconData(
    figure: IconData(0xe35d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe35c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-nine`
  static const PhosphorDuotoneIconData numberNine = PhosphorDuotoneIconData(
    figure: IconData(0xe363, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe362, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-one`
  static const PhosphorDuotoneIconData numberOne = PhosphorDuotoneIconData(
    figure: IconData(0xe369, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe368, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-seven`
  static const PhosphorDuotoneIconData numberSeven = PhosphorDuotoneIconData(
    figure: IconData(0xe36f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe36e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-six`
  static const PhosphorDuotoneIconData numberSix = PhosphorDuotoneIconData(
    figure: IconData(0xe375, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe374, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-square-eight`
  static const PhosphorDuotoneIconData
  numberSquareEight = PhosphorDuotoneIconData(
    figure: IconData(0xe355, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe354, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-square-five`
  static const PhosphorDuotoneIconData
  numberSquareFive = PhosphorDuotoneIconData(
    figure: IconData(0xe35b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe35a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-square-four`
  static const PhosphorDuotoneIconData
  numberSquareFour = PhosphorDuotoneIconData(
    figure: IconData(0xe361, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe360, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-square-nine`
  static const PhosphorDuotoneIconData
  numberSquareNine = PhosphorDuotoneIconData(
    figure: IconData(0xe367, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe366, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-square-one`
  static const PhosphorDuotoneIconData
  numberSquareOne = PhosphorDuotoneIconData(
    figure: IconData(0xe36d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe36c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-square-seven`
  static const PhosphorDuotoneIconData
  numberSquareSeven = PhosphorDuotoneIconData(
    figure: IconData(0xe373, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe372, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-square-six`
  static const PhosphorDuotoneIconData
  numberSquareSix = PhosphorDuotoneIconData(
    figure: IconData(0xe379, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe378, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-square-three`
  static const PhosphorDuotoneIconData
  numberSquareThree = PhosphorDuotoneIconData(
    figure: IconData(0xe37f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe37e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-square-two`
  static const PhosphorDuotoneIconData
  numberSquareTwo = PhosphorDuotoneIconData(
    figure: IconData(0xe385, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe384, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-square-zero`
  static const PhosphorDuotoneIconData
  numberSquareZero = PhosphorDuotoneIconData(
    figure: IconData(0xe38b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe38a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-three`
  static const PhosphorDuotoneIconData numberThree = PhosphorDuotoneIconData(
    figure: IconData(0xe37b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe37a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-two`
  static const PhosphorDuotoneIconData numberTwo = PhosphorDuotoneIconData(
    figure: IconData(0xe381, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe380, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `number-zero`
  static const PhosphorDuotoneIconData numberZero = PhosphorDuotoneIconData(
    figure: IconData(0xe387, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe386, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `numpad`
  static const PhosphorDuotoneIconData numpad = PhosphorDuotoneIconData(
    figure: IconData(0xe3c9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3c8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `nut`
  static const PhosphorDuotoneIconData nut = PhosphorDuotoneIconData(
    figure: IconData(0xe38d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe38c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ny-times-logo`
  static const PhosphorDuotoneIconData nyTimesLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe647, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe646, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `octagon`
  static const PhosphorDuotoneIconData octagon = PhosphorDuotoneIconData(
    figure: IconData(0xe38f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe38e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `office-chair`
  static const PhosphorDuotoneIconData officeChair = PhosphorDuotoneIconData(
    figure: IconData(0xea47, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea46, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `onigiri`
  static const PhosphorDuotoneIconData onigiri = PhosphorDuotoneIconData(
    figure: IconData(0xee2d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee2c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `open-ai-logo`
  static const PhosphorDuotoneIconData openAiLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe7d3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7d2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `option`
  static const PhosphorDuotoneIconData option = PhosphorDuotoneIconData(
    figure: IconData(0xe8a9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8a8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `orange`
  static const PhosphorDuotoneIconData orange = PhosphorDuotoneIconData(
    figure: IconData(0xee41, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee40, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `orange-slice`
  static const PhosphorDuotoneIconData orangeSlice = PhosphorDuotoneIconData(
    figure: IconData(0xed37, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed36, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `oven`
  static const PhosphorDuotoneIconData oven = PhosphorDuotoneIconData(
    figure: IconData(0xed8d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed8c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `package`
  static const PhosphorDuotoneIconData package = PhosphorDuotoneIconData(
    figure: IconData(0xe391, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe390, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paint-brush`
  static const PhosphorDuotoneIconData paintBrush = PhosphorDuotoneIconData(
    figure: IconData(0xe6f1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6f0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paint-brush-broad`
  static const PhosphorDuotoneIconData
  paintBrushBroad = PhosphorDuotoneIconData(
    figure: IconData(0xe591, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe590, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paint-brush-household`
  static const PhosphorDuotoneIconData
  paintBrushHousehold = PhosphorDuotoneIconData(
    figure: IconData(0xe6f3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6f2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paint-bucket`
  static const PhosphorDuotoneIconData paintBucket = PhosphorDuotoneIconData(
    figure: IconData(0xe393, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe392, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paint-roller`
  static const PhosphorDuotoneIconData paintRoller = PhosphorDuotoneIconData(
    figure: IconData(0xe6f5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6f4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `palette`
  static const PhosphorDuotoneIconData palette = PhosphorDuotoneIconData(
    figure: IconData(0xe6c9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6c8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `panorama`
  static const PhosphorDuotoneIconData panorama = PhosphorDuotoneIconData(
    figure: IconData(0xeaa3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaa2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pants`
  static const PhosphorDuotoneIconData pants = PhosphorDuotoneIconData(
    figure: IconData(0xec89, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec88, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paper-plane`
  static const PhosphorDuotoneIconData paperPlane = PhosphorDuotoneIconData(
    figure: IconData(0xe395, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe394, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paper-plane-right`
  static const PhosphorDuotoneIconData
  paperPlaneRight = PhosphorDuotoneIconData(
    figure: IconData(0xe397, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe396, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paper-plane-tilt`
  static const PhosphorDuotoneIconData paperPlaneTilt = PhosphorDuotoneIconData(
    figure: IconData(0xe399, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe398, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paperclip`
  static const PhosphorDuotoneIconData paperclip = PhosphorDuotoneIconData(
    figure: IconData(0xe39b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe39a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paperclip-horizontal`
  static const PhosphorDuotoneIconData
  paperclipHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xe593, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe592, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `parachute`
  static const PhosphorDuotoneIconData parachute = PhosphorDuotoneIconData(
    figure: IconData(0xea7d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea7c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paragraph`
  static const PhosphorDuotoneIconData paragraph = PhosphorDuotoneIconData(
    figure: IconData(0xe961, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe960, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `parallelogram`
  static const PhosphorDuotoneIconData parallelogram = PhosphorDuotoneIconData(
    figure: IconData(0xecc7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecc6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `park`
  static const PhosphorDuotoneIconData park = PhosphorDuotoneIconData(
    figure: IconData(0xecb3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecb2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `password`
  static const PhosphorDuotoneIconData password = PhosphorDuotoneIconData(
    figure: IconData(0xe753, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe752, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `path`
  static const PhosphorDuotoneIconData path = PhosphorDuotoneIconData(
    figure: IconData(0xe39d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe39c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `patreon-logo`
  static const PhosphorDuotoneIconData patreonLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe98b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe98a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pause`
  static const PhosphorDuotoneIconData pause = PhosphorDuotoneIconData(
    figure: IconData(0xe39f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe39e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pause-circle`
  static const PhosphorDuotoneIconData pauseCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe3a1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3a0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paw-print`
  static const PhosphorDuotoneIconData pawPrint = PhosphorDuotoneIconData(
    figure: IconData(0xe649, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe648, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `paypal-logo`
  static const PhosphorDuotoneIconData paypalLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe98d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe98c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `peace`
  static const PhosphorDuotoneIconData peace = PhosphorDuotoneIconData(
    figure: IconData(0xe3a3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3a2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pen`
  static const PhosphorDuotoneIconData pen = PhosphorDuotoneIconData(
    figure: IconData(0xe3ab, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3aa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pen-nib`
  static const PhosphorDuotoneIconData penNib = PhosphorDuotoneIconData(
    figure: IconData(0xe3ad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3ac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pen-nib-straight`
  static const PhosphorDuotoneIconData penNibStraight = PhosphorDuotoneIconData(
    figure: IconData(0xe64b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe64a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pencil`
  static const PhosphorDuotoneIconData pencil = PhosphorDuotoneIconData(
    figure: IconData(0xe3af, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3ae, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pencil-circle`
  static const PhosphorDuotoneIconData pencilCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe3b1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3b0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pencil-line`
  static const PhosphorDuotoneIconData pencilLine = PhosphorDuotoneIconData(
    figure: IconData(0xe3b3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3b2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pencil-ruler`
  static const PhosphorDuotoneIconData pencilRuler = PhosphorDuotoneIconData(
    figure: IconData(0xe907, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe906, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pencil-simple`
  static const PhosphorDuotoneIconData pencilSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe3b5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3b4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pencil-simple-line`
  static const PhosphorDuotoneIconData
  pencilSimpleLine = PhosphorDuotoneIconData(
    figure: IconData(0xebc7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebc6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pencil-simple-slash`
  static const PhosphorDuotoneIconData
  pencilSimpleSlash = PhosphorDuotoneIconData(
    figure: IconData(0xecf7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecf6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pencil-slash`
  static const PhosphorDuotoneIconData pencilSlash = PhosphorDuotoneIconData(
    figure: IconData(0xecf9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecf8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pentagon`
  static const PhosphorDuotoneIconData pentagon = PhosphorDuotoneIconData(
    figure: IconData(0xec7f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec7e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pentagram`
  static const PhosphorDuotoneIconData pentagram = PhosphorDuotoneIconData(
    figure: IconData(0xec5d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec5c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pepper`
  static const PhosphorDuotoneIconData pepper = PhosphorDuotoneIconData(
    figure: IconData(0xe94b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe94a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `percent`
  static const PhosphorDuotoneIconData percent = PhosphorDuotoneIconData(
    figure: IconData(0xe3b7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3b6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person`
  static const PhosphorDuotoneIconData person = PhosphorDuotoneIconData(
    figure: IconData(0xe3a9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3a8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-arms-spread`
  static const PhosphorDuotoneIconData
  personArmsSpread = PhosphorDuotoneIconData(
    figure: IconData(0xecff, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecfe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-simple`
  static const PhosphorDuotoneIconData personSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe72f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe72e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-simple-bike`
  static const PhosphorDuotoneIconData
  personSimpleBike = PhosphorDuotoneIconData(
    figure: IconData(0xe735, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe734, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-simple-circle`
  static const PhosphorDuotoneIconData
  personSimpleCircle = PhosphorDuotoneIconData(
    figure: IconData(0xee59, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee58, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-simple-hike`
  static const PhosphorDuotoneIconData
  personSimpleHike = PhosphorDuotoneIconData(
    figure: IconData(0xed55, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed54, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-simple-run`
  static const PhosphorDuotoneIconData
  personSimpleRun = PhosphorDuotoneIconData(
    figure: IconData(0xe731, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe730, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-simple-ski`
  static const PhosphorDuotoneIconData
  personSimpleSki = PhosphorDuotoneIconData(
    figure: IconData(0xe71d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe71c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-simple-snowboard`
  static const PhosphorDuotoneIconData
  personSimpleSnowboard = PhosphorDuotoneIconData(
    figure: IconData(0xe71f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe71e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-simple-swim`
  static const PhosphorDuotoneIconData
  personSimpleSwim = PhosphorDuotoneIconData(
    figure: IconData(0xe737, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe736, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-simple-tai-chi`
  static const PhosphorDuotoneIconData
  personSimpleTaiChi = PhosphorDuotoneIconData(
    figure: IconData(0xed5d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed5c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-simple-throw`
  static const PhosphorDuotoneIconData
  personSimpleThrow = PhosphorDuotoneIconData(
    figure: IconData(0xe733, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe732, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `person-simple-walk`
  static const PhosphorDuotoneIconData
  personSimpleWalk = PhosphorDuotoneIconData(
    figure: IconData(0xe73b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe73a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `perspective`
  static const PhosphorDuotoneIconData perspective = PhosphorDuotoneIconData(
    figure: IconData(0xebe7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebe6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phone`
  static const PhosphorDuotoneIconData phone = PhosphorDuotoneIconData(
    figure: IconData(0xe3b9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3b8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phone-call`
  static const PhosphorDuotoneIconData phoneCall = PhosphorDuotoneIconData(
    figure: IconData(0xe3bb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3ba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phone-disconnect`
  static const PhosphorDuotoneIconData
  phoneDisconnect = PhosphorDuotoneIconData(
    figure: IconData(0xe3bd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3bc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phone-incoming`
  static const PhosphorDuotoneIconData phoneIncoming = PhosphorDuotoneIconData(
    figure: IconData(0xe3bf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3be, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phone-list`
  static const PhosphorDuotoneIconData phoneList = PhosphorDuotoneIconData(
    figure: IconData(0xe3cd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3cc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phone-outgoing`
  static const PhosphorDuotoneIconData phoneOutgoing = PhosphorDuotoneIconData(
    figure: IconData(0xe3c1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3c0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phone-pause`
  static const PhosphorDuotoneIconData phonePause = PhosphorDuotoneIconData(
    figure: IconData(0xe3cb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3ca, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phone-plus`
  static const PhosphorDuotoneIconData phonePlus = PhosphorDuotoneIconData(
    figure: IconData(0xec57, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec56, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phone-slash`
  static const PhosphorDuotoneIconData phoneSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe3c3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3c2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phone-transfer`
  static const PhosphorDuotoneIconData phoneTransfer = PhosphorDuotoneIconData(
    figure: IconData(0xe3c7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3c6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phone-x`
  static const PhosphorDuotoneIconData phoneX = PhosphorDuotoneIconData(
    figure: IconData(0xe3c5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3c4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `phosphor-logo`
  static const PhosphorDuotoneIconData phosphorLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe3cf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3ce, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pi`
  static const PhosphorDuotoneIconData pi = PhosphorDuotoneIconData(
    figure: IconData(0xec81, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec80, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `piano-keys`
  static const PhosphorDuotoneIconData pianoKeys = PhosphorDuotoneIconData(
    figure: IconData(0xe9c9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9c8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `picnic-table`
  static const PhosphorDuotoneIconData picnicTable = PhosphorDuotoneIconData(
    figure: IconData(0xee27, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee26, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `picture-in-picture`
  static const PhosphorDuotoneIconData
  pictureInPicture = PhosphorDuotoneIconData(
    figure: IconData(0xe64d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe64c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `piggy-bank`
  static const PhosphorDuotoneIconData piggyBank = PhosphorDuotoneIconData(
    figure: IconData(0xea05, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea04, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pill`
  static const PhosphorDuotoneIconData pill = PhosphorDuotoneIconData(
    figure: IconData(0xe701, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe700, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ping-pong`
  static const PhosphorDuotoneIconData pingPong = PhosphorDuotoneIconData(
    figure: IconData(0xea43, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea42, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pint-glass`
  static const PhosphorDuotoneIconData pintGlass = PhosphorDuotoneIconData(
    figure: IconData(0xedd1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedd0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pinterest-logo`
  static const PhosphorDuotoneIconData pinterestLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe64f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe64e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pinwheel`
  static const PhosphorDuotoneIconData pinwheel = PhosphorDuotoneIconData(
    figure: IconData(0xeb9d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb9c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pipe`
  static const PhosphorDuotoneIconData pipe = PhosphorDuotoneIconData(
    figure: IconData(0xed87, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed86, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pipe-wrench`
  static const PhosphorDuotoneIconData pipeWrench = PhosphorDuotoneIconData(
    figure: IconData(0xed89, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed88, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pix-logo`
  static const PhosphorDuotoneIconData pixLogo = PhosphorDuotoneIconData(
    figure: IconData(0xecc3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecc2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pizza`
  static const PhosphorDuotoneIconData pizza = PhosphorDuotoneIconData(
    figure: IconData(0xe797, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe796, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `placeholder`
  static const PhosphorDuotoneIconData placeholder = PhosphorDuotoneIconData(
    figure: IconData(0xe651, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe650, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `planet`
  static const PhosphorDuotoneIconData planet = PhosphorDuotoneIconData(
    figure: IconData(0xe653, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe652, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `plant`
  static const PhosphorDuotoneIconData plant = PhosphorDuotoneIconData(
    figure: IconData(0xebaf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebae, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `play`
  static const PhosphorDuotoneIconData play = PhosphorDuotoneIconData(
    figure: IconData(0xe3d1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3d0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `play-circle`
  static const PhosphorDuotoneIconData playCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe3d3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3d2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `play-pause`
  static const PhosphorDuotoneIconData playPause = PhosphorDuotoneIconData(
    figure: IconData(0xe8bf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8be, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `playlist`
  static const PhosphorDuotoneIconData playlist = PhosphorDuotoneIconData(
    figure: IconData(0xe6ab, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6aa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `plug`
  static const PhosphorDuotoneIconData plug = PhosphorDuotoneIconData(
    figure: IconData(0xe947, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe946, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `plug-charging`
  static const PhosphorDuotoneIconData plugCharging = PhosphorDuotoneIconData(
    figure: IconData(0xeb5d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb5c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `plugs`
  static const PhosphorDuotoneIconData plugs = PhosphorDuotoneIconData(
    figure: IconData(0xeb57, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb56, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `plugs-connected`
  static const PhosphorDuotoneIconData plugsConnected = PhosphorDuotoneIconData(
    figure: IconData(0xeb5b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb5a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `plus`
  static const PhosphorDuotoneIconData plus = PhosphorDuotoneIconData(
    figure: IconData(0xe3d5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3d4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `plus-circle`
  static const PhosphorDuotoneIconData plusCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe3d7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3d6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `plus-minus`
  static const PhosphorDuotoneIconData plusMinus = PhosphorDuotoneIconData(
    figure: IconData(0xe3d9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3d8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `plus-square`
  static const PhosphorDuotoneIconData plusSquare = PhosphorDuotoneIconData(
    figure: IconData(0xed56, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed4a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `poker-chip`
  static const PhosphorDuotoneIconData pokerChip = PhosphorDuotoneIconData(
    figure: IconData(0xe595, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe594, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `police-car`
  static const PhosphorDuotoneIconData policeCar = PhosphorDuotoneIconData(
    figure: IconData(0xec4b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec4a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `polygon`
  static const PhosphorDuotoneIconData polygon = PhosphorDuotoneIconData(
    figure: IconData(0xe6d1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6d0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `popcorn`
  static const PhosphorDuotoneIconData popcorn = PhosphorDuotoneIconData(
    figure: IconData(0xeb4f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb4e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `popsicle`
  static const PhosphorDuotoneIconData popsicle = PhosphorDuotoneIconData(
    figure: IconData(0xebbf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebbe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `potted-plant`
  static const PhosphorDuotoneIconData pottedPlant = PhosphorDuotoneIconData(
    figure: IconData(0xec23, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec22, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `power`
  static const PhosphorDuotoneIconData power = PhosphorDuotoneIconData(
    figure: IconData(0xe3db, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3da, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `prescription`
  static const PhosphorDuotoneIconData prescription = PhosphorDuotoneIconData(
    figure: IconData(0xe7a3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7a2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `presentation`
  static const PhosphorDuotoneIconData presentation = PhosphorDuotoneIconData(
    figure: IconData(0xe655, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe654, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `presentation-chart`
  static const PhosphorDuotoneIconData
  presentationChart = PhosphorDuotoneIconData(
    figure: IconData(0xe657, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe656, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `printer`
  static const PhosphorDuotoneIconData printer = PhosphorDuotoneIconData(
    figure: IconData(0xe3dd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3dc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `prohibit`
  static const PhosphorDuotoneIconData prohibit = PhosphorDuotoneIconData(
    figure: IconData(0xe3df, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3de, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `prohibit-inset`
  static const PhosphorDuotoneIconData prohibitInset = PhosphorDuotoneIconData(
    figure: IconData(0xe3e1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3e0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `projector-screen`
  static const PhosphorDuotoneIconData
  projectorScreen = PhosphorDuotoneIconData(
    figure: IconData(0xe659, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe658, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `projector-screen-chart`
  static const PhosphorDuotoneIconData
  projectorScreenChart = PhosphorDuotoneIconData(
    figure: IconData(0xe65b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe65a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `pulse`
  static const PhosphorDuotoneIconData pulse = PhosphorDuotoneIconData(
    figure: IconData(0xe001, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe000, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `push-pin`
  static const PhosphorDuotoneIconData pushPin = PhosphorDuotoneIconData(
    figure: IconData(0xe3e3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3e2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `push-pin-simple`
  static const PhosphorDuotoneIconData pushPinSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe65d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe65c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `push-pin-simple-slash`
  static const PhosphorDuotoneIconData
  pushPinSimpleSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe65f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe65e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `push-pin-slash`
  static const PhosphorDuotoneIconData pushPinSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe3e5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3e4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `puzzle-piece`
  static const PhosphorDuotoneIconData puzzlePiece = PhosphorDuotoneIconData(
    figure: IconData(0xe597, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe596, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `qr-code`
  static const PhosphorDuotoneIconData qrCode = PhosphorDuotoneIconData(
    figure: IconData(0xe3e7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3e6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `question`
  static const PhosphorDuotoneIconData question = PhosphorDuotoneIconData(
    figure: IconData(0xe3eb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3e8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `question-mark`
  static const PhosphorDuotoneIconData questionMark = PhosphorDuotoneIconData(
    figure: IconData(0xe3ed, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3e9, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `queue`
  static const PhosphorDuotoneIconData queue = PhosphorDuotoneIconData(
    figure: IconData(0xe6ad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6ac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `quotes`
  static const PhosphorDuotoneIconData quotes = PhosphorDuotoneIconData(
    figure: IconData(0xe661, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe660, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rabbit`
  static const PhosphorDuotoneIconData rabbit = PhosphorDuotoneIconData(
    figure: IconData(0xeac3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeac2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `racquet`
  static const PhosphorDuotoneIconData racquet = PhosphorDuotoneIconData(
    figure: IconData(0xee03, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee02, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `radical`
  static const PhosphorDuotoneIconData radical = PhosphorDuotoneIconData(
    figure: IconData(0xe3ef, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3ea, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `radio`
  static const PhosphorDuotoneIconData radio = PhosphorDuotoneIconData(
    figure: IconData(0xe77f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe77e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `radio-button`
  static const PhosphorDuotoneIconData radioButton = PhosphorDuotoneIconData(
    figure: IconData(0xeb09, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb08, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `radioactive`
  static const PhosphorDuotoneIconData radioactive = PhosphorDuotoneIconData(
    figure: IconData(0xe9dd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9dc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rainbow`
  static const PhosphorDuotoneIconData rainbow = PhosphorDuotoneIconData(
    figure: IconData(0xe599, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe598, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rainbow-cloud`
  static const PhosphorDuotoneIconData rainbowCloud = PhosphorDuotoneIconData(
    figure: IconData(0xe59b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe59a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ranking`
  static const PhosphorDuotoneIconData ranking = PhosphorDuotoneIconData(
    figure: IconData(0xed63, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed62, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `read-cv-logo`
  static const PhosphorDuotoneIconData readCvLogo = PhosphorDuotoneIconData(
    figure: IconData(0xed0d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed0c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `receipt`
  static const PhosphorDuotoneIconData receipt = PhosphorDuotoneIconData(
    figure: IconData(0xe3f1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3ec, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `receipt-x`
  static const PhosphorDuotoneIconData receiptX = PhosphorDuotoneIconData(
    figure: IconData(0xed41, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed40, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `record`
  static const PhosphorDuotoneIconData record = PhosphorDuotoneIconData(
    figure: IconData(0xe3f3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3ee, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rectangle`
  static const PhosphorDuotoneIconData rectangle = PhosphorDuotoneIconData(
    figure: IconData(0xe3f5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3f0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rectangle-dashed`
  static const PhosphorDuotoneIconData
  rectangleDashed = PhosphorDuotoneIconData(
    figure: IconData(0xe3f7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3f2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `recycle`
  static const PhosphorDuotoneIconData recycle = PhosphorDuotoneIconData(
    figure: IconData(0xe75b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe75a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `reddit-logo`
  static const PhosphorDuotoneIconData redditLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe59d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe59c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `repeat`
  static const PhosphorDuotoneIconData repeat = PhosphorDuotoneIconData(
    figure: IconData(0xe3f9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3f6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `repeat-once`
  static const PhosphorDuotoneIconData repeatOnce = PhosphorDuotoneIconData(
    figure: IconData(0xe3fb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3f8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `replit-logo`
  static const PhosphorDuotoneIconData replitLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeb8b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb8a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `resize`
  static const PhosphorDuotoneIconData resize = PhosphorDuotoneIconData(
    figure: IconData(0xed6f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed6e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rewind`
  static const PhosphorDuotoneIconData rewind = PhosphorDuotoneIconData(
    figure: IconData(0xe6a9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6a8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rewind-circle`
  static const PhosphorDuotoneIconData rewindCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe3fd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3fa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `road-horizon`
  static const PhosphorDuotoneIconData roadHorizon = PhosphorDuotoneIconData(
    figure: IconData(0xe839, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe838, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `robot`
  static const PhosphorDuotoneIconData robot = PhosphorDuotoneIconData(
    figure: IconData(0xe763, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe762, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rocket`
  static const PhosphorDuotoneIconData rocket = PhosphorDuotoneIconData(
    figure: IconData(0xe3ff, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3fc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rocket-launch`
  static const PhosphorDuotoneIconData rocketLaunch = PhosphorDuotoneIconData(
    figure: IconData(0xe401, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3fe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rows`
  static const PhosphorDuotoneIconData rows = PhosphorDuotoneIconData(
    figure: IconData(0xe5a3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5a2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rows-plus-bottom`
  static const PhosphorDuotoneIconData rowsPlusBottom = PhosphorDuotoneIconData(
    figure: IconData(0xe59f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe59e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rows-plus-top`
  static const PhosphorDuotoneIconData rowsPlusTop = PhosphorDuotoneIconData(
    figure: IconData(0xe5a1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5a0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rss`
  static const PhosphorDuotoneIconData rss = PhosphorDuotoneIconData(
    figure: IconData(0xe403, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe400, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rss-simple`
  static const PhosphorDuotoneIconData rssSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe405, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe402, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `rug`
  static const PhosphorDuotoneIconData rug = PhosphorDuotoneIconData(
    figure: IconData(0xea1b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea1a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ruler`
  static const PhosphorDuotoneIconData ruler = PhosphorDuotoneIconData(
    figure: IconData(0xe6b9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6b8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sailboat`
  static const PhosphorDuotoneIconData sailboat = PhosphorDuotoneIconData(
    figure: IconData(0xe78b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe78a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `scales`
  static const PhosphorDuotoneIconData scales = PhosphorDuotoneIconData(
    figure: IconData(0xe751, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe750, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `scan`
  static const PhosphorDuotoneIconData scan = PhosphorDuotoneIconData(
    figure: IconData(0xebb7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebb6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `scan-smiley`
  static const PhosphorDuotoneIconData scanSmiley = PhosphorDuotoneIconData(
    figure: IconData(0xebb5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebb4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `scissors`
  static const PhosphorDuotoneIconData scissors = PhosphorDuotoneIconData(
    figure: IconData(0xeae1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeae0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `scooter`
  static const PhosphorDuotoneIconData scooter = PhosphorDuotoneIconData(
    figure: IconData(0xe821, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe820, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `screencast`
  static const PhosphorDuotoneIconData screencast = PhosphorDuotoneIconData(
    figure: IconData(0xe407, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe404, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `screwdriver`
  static const PhosphorDuotoneIconData screwdriver = PhosphorDuotoneIconData(
    figure: IconData(0xe86f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe86e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `scribble`
  static const PhosphorDuotoneIconData scribble = PhosphorDuotoneIconData(
    figure: IconData(0xe807, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe806, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `scribble-loop`
  static const PhosphorDuotoneIconData scribbleLoop = PhosphorDuotoneIconData(
    figure: IconData(0xe663, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe662, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `scroll`
  static const PhosphorDuotoneIconData scroll = PhosphorDuotoneIconData(
    figure: IconData(0xeb7b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb7a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `seal`
  static const PhosphorDuotoneIconData seal = PhosphorDuotoneIconData(
    figure: IconData(0xe605, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe604, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `seal-check`
  static const PhosphorDuotoneIconData sealCheck = PhosphorDuotoneIconData(
    figure: IconData(0xe607, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe606, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `seal-percent`
  static const PhosphorDuotoneIconData sealPercent = PhosphorDuotoneIconData(
    figure: IconData(0xe60b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe60a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `seal-question`
  static const PhosphorDuotoneIconData sealQuestion = PhosphorDuotoneIconData(
    figure: IconData(0xe609, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe608, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `seal-warning`
  static const PhosphorDuotoneIconData sealWarning = PhosphorDuotoneIconData(
    figure: IconData(0xe60d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe60c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `seat`
  static const PhosphorDuotoneIconData seat = PhosphorDuotoneIconData(
    figure: IconData(0xeb8f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb8e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `seatbelt`
  static const PhosphorDuotoneIconData seatbelt = PhosphorDuotoneIconData(
    figure: IconData(0xedff, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedfe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `security-camera`
  static const PhosphorDuotoneIconData securityCamera = PhosphorDuotoneIconData(
    figure: IconData(0xeca5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeca4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `selection`
  static const PhosphorDuotoneIconData selection = PhosphorDuotoneIconData(
    figure: IconData(0xe69b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe69a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `selection-all`
  static const PhosphorDuotoneIconData selectionAll = PhosphorDuotoneIconData(
    figure: IconData(0xe747, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe746, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `selection-background`
  static const PhosphorDuotoneIconData
  selectionBackground = PhosphorDuotoneIconData(
    figure: IconData(0xeaf9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaf8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `selection-foreground`
  static const PhosphorDuotoneIconData
  selectionForeground = PhosphorDuotoneIconData(
    figure: IconData(0xeaf7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaf6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `selection-inverse`
  static const PhosphorDuotoneIconData
  selectionInverse = PhosphorDuotoneIconData(
    figure: IconData(0xe745, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe744, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `selection-plus`
  static const PhosphorDuotoneIconData selectionPlus = PhosphorDuotoneIconData(
    figure: IconData(0xe69d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe69c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `selection-slash`
  static const PhosphorDuotoneIconData selectionSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe69f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe69e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shapes`
  static const PhosphorDuotoneIconData shapes = PhosphorDuotoneIconData(
    figure: IconData(0xec5f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec5e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `share`
  static const PhosphorDuotoneIconData share = PhosphorDuotoneIconData(
    figure: IconData(0xe409, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe406, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `share-fat`
  static const PhosphorDuotoneIconData shareFat = PhosphorDuotoneIconData(
    figure: IconData(0xed57, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed52, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `share-network`
  static const PhosphorDuotoneIconData shareNetwork = PhosphorDuotoneIconData(
    figure: IconData(0xe40b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe408, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shield`
  static const PhosphorDuotoneIconData shield = PhosphorDuotoneIconData(
    figure: IconData(0xe40d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe40a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shield-check`
  static const PhosphorDuotoneIconData shieldCheck = PhosphorDuotoneIconData(
    figure: IconData(0xe40f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe40c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shield-checkered`
  static const PhosphorDuotoneIconData
  shieldCheckered = PhosphorDuotoneIconData(
    figure: IconData(0xe709, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe708, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shield-chevron`
  static const PhosphorDuotoneIconData shieldChevron = PhosphorDuotoneIconData(
    figure: IconData(0xe411, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe40e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shield-plus`
  static const PhosphorDuotoneIconData shieldPlus = PhosphorDuotoneIconData(
    figure: IconData(0xe707, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe706, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shield-slash`
  static const PhosphorDuotoneIconData shieldSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe413, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe410, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shield-star`
  static const PhosphorDuotoneIconData shieldStar = PhosphorDuotoneIconData(
    figure: IconData(0xec35, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec34, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shield-warning`
  static const PhosphorDuotoneIconData shieldWarning = PhosphorDuotoneIconData(
    figure: IconData(0xe414, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe412, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shipping-container`
  static const PhosphorDuotoneIconData
  shippingContainer = PhosphorDuotoneIconData(
    figure: IconData(0xe78d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe78c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shirt-folded`
  static const PhosphorDuotoneIconData shirtFolded = PhosphorDuotoneIconData(
    figure: IconData(0xea93, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea92, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shooting-star`
  static const PhosphorDuotoneIconData shootingStar = PhosphorDuotoneIconData(
    figure: IconData(0xecfb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecfa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shopping-bag`
  static const PhosphorDuotoneIconData shoppingBag = PhosphorDuotoneIconData(
    figure: IconData(0xe417, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe416, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shopping-bag-open`
  static const PhosphorDuotoneIconData
  shoppingBagOpen = PhosphorDuotoneIconData(
    figure: IconData(0xe419, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe418, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shopping-cart`
  static const PhosphorDuotoneIconData shoppingCart = PhosphorDuotoneIconData(
    figure: IconData(0xe41f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe41e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shopping-cart-simple`
  static const PhosphorDuotoneIconData
  shoppingCartSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe421, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe420, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shovel`
  static const PhosphorDuotoneIconData shovel = PhosphorDuotoneIconData(
    figure: IconData(0xe9e7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9e6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shower`
  static const PhosphorDuotoneIconData shower = PhosphorDuotoneIconData(
    figure: IconData(0xe777, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe776, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shrimp`
  static const PhosphorDuotoneIconData shrimp = PhosphorDuotoneIconData(
    figure: IconData(0xeab5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeab4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shuffle`
  static const PhosphorDuotoneIconData shuffle = PhosphorDuotoneIconData(
    figure: IconData(0xe423, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe422, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shuffle-angular`
  static const PhosphorDuotoneIconData shuffleAngular = PhosphorDuotoneIconData(
    figure: IconData(0xe425, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe424, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `shuffle-simple`
  static const PhosphorDuotoneIconData shuffleSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe427, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe426, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sidebar`
  static const PhosphorDuotoneIconData sidebar = PhosphorDuotoneIconData(
    figure: IconData(0xeab7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeab6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sidebar-simple`
  static const PhosphorDuotoneIconData sidebarSimple = PhosphorDuotoneIconData(
    figure: IconData(0xec25, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec24, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sigma`
  static const PhosphorDuotoneIconData sigma = PhosphorDuotoneIconData(
    figure: IconData(0xeab9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeab8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sign-in`
  static const PhosphorDuotoneIconData signIn = PhosphorDuotoneIconData(
    figure: IconData(0xe429, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe428, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sign-out`
  static const PhosphorDuotoneIconData signOut = PhosphorDuotoneIconData(
    figure: IconData(0xe42b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe42a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `signature`
  static const PhosphorDuotoneIconData signature = PhosphorDuotoneIconData(
    figure: IconData(0xebad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `signpost`
  static const PhosphorDuotoneIconData signpost = PhosphorDuotoneIconData(
    figure: IconData(0xe89d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe89c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sim-card`
  static const PhosphorDuotoneIconData simCard = PhosphorDuotoneIconData(
    figure: IconData(0xe665, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe664, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `siren`
  static const PhosphorDuotoneIconData siren = PhosphorDuotoneIconData(
    figure: IconData(0xe9b9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9b8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sketch-logo`
  static const PhosphorDuotoneIconData sketchLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe42d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe42c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `skip-back`
  static const PhosphorDuotoneIconData skipBack = PhosphorDuotoneIconData(
    figure: IconData(0xe5a5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5a4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `skip-back-circle`
  static const PhosphorDuotoneIconData skipBackCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe42f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe42e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `skip-forward`
  static const PhosphorDuotoneIconData skipForward = PhosphorDuotoneIconData(
    figure: IconData(0xe5a7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5a6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `skip-forward-circle`
  static const PhosphorDuotoneIconData
  skipForwardCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe431, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe430, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `skull`
  static const PhosphorDuotoneIconData skull = PhosphorDuotoneIconData(
    figure: IconData(0xe917, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe916, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `skype-logo`
  static const PhosphorDuotoneIconData skypeLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe8dd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8dc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `slack-logo`
  static const PhosphorDuotoneIconData slackLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe5a9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5a8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sliders`
  static const PhosphorDuotoneIconData sliders = PhosphorDuotoneIconData(
    figure: IconData(0xe433, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe432, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sliders-horizontal`
  static const PhosphorDuotoneIconData
  slidersHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xe435, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe434, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `slideshow`
  static const PhosphorDuotoneIconData slideshow = PhosphorDuotoneIconData(
    figure: IconData(0xed33, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed32, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `smiley`
  static const PhosphorDuotoneIconData smiley = PhosphorDuotoneIconData(
    figure: IconData(0xe437, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe436, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `smiley-angry`
  static const PhosphorDuotoneIconData smileyAngry = PhosphorDuotoneIconData(
    figure: IconData(0xec63, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec62, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `smiley-blank`
  static const PhosphorDuotoneIconData smileyBlank = PhosphorDuotoneIconData(
    figure: IconData(0xe439, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe438, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `smiley-meh`
  static const PhosphorDuotoneIconData smileyMeh = PhosphorDuotoneIconData(
    figure: IconData(0xe43b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe43a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `smiley-melting`
  static const PhosphorDuotoneIconData smileyMelting = PhosphorDuotoneIconData(
    figure: IconData(0xee57, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee56, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `smiley-nervous`
  static const PhosphorDuotoneIconData smileyNervous = PhosphorDuotoneIconData(
    figure: IconData(0xe43d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe43c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `smiley-sad`
  static const PhosphorDuotoneIconData smileySad = PhosphorDuotoneIconData(
    figure: IconData(0xe43f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe43e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `smiley-sticker`
  static const PhosphorDuotoneIconData smileySticker = PhosphorDuotoneIconData(
    figure: IconData(0xe441, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe440, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `smiley-wink`
  static const PhosphorDuotoneIconData smileyWink = PhosphorDuotoneIconData(
    figure: IconData(0xe667, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe666, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `smiley-x-eyes`
  static const PhosphorDuotoneIconData smileyXEyes = PhosphorDuotoneIconData(
    figure: IconData(0xe443, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe442, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `snapchat-logo`
  static const PhosphorDuotoneIconData snapchatLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe669, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe668, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sneaker`
  static const PhosphorDuotoneIconData sneaker = PhosphorDuotoneIconData(
    figure: IconData(0xe80d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe80c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sneaker-move`
  static const PhosphorDuotoneIconData sneakerMove = PhosphorDuotoneIconData(
    figure: IconData(0xed61, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed60, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `snowflake`
  static const PhosphorDuotoneIconData snowflake = PhosphorDuotoneIconData(
    figure: IconData(0xe5ab, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5aa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `soccer-ball`
  static const PhosphorDuotoneIconData soccerBall = PhosphorDuotoneIconData(
    figure: IconData(0xe717, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe716, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sock`
  static const PhosphorDuotoneIconData sock = PhosphorDuotoneIconData(
    figure: IconData(0xeccf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecce, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `solar-panel`
  static const PhosphorDuotoneIconData solarPanel = PhosphorDuotoneIconData(
    figure: IconData(0xed7e, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed7a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `solar-roof`
  static const PhosphorDuotoneIconData solarRoof = PhosphorDuotoneIconData(
    figure: IconData(0xed7f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed7b, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sort-ascending`
  static const PhosphorDuotoneIconData sortAscending = PhosphorDuotoneIconData(
    figure: IconData(0xe445, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe444, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sort-descending`
  static const PhosphorDuotoneIconData sortDescending = PhosphorDuotoneIconData(
    figure: IconData(0xe447, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe446, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `soundcloud-logo`
  static const PhosphorDuotoneIconData soundcloudLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe8df, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8de, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `spade`
  static const PhosphorDuotoneIconData spade = PhosphorDuotoneIconData(
    figure: IconData(0xe449, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe448, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sparkle`
  static const PhosphorDuotoneIconData sparkle = PhosphorDuotoneIconData(
    figure: IconData(0xe6a3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6a2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speaker-hifi`
  static const PhosphorDuotoneIconData speakerHifi = PhosphorDuotoneIconData(
    figure: IconData(0xea09, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea08, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speaker-high`
  static const PhosphorDuotoneIconData speakerHigh = PhosphorDuotoneIconData(
    figure: IconData(0xe44b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe44a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speaker-low`
  static const PhosphorDuotoneIconData speakerLow = PhosphorDuotoneIconData(
    figure: IconData(0xe44d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe44c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speaker-none`
  static const PhosphorDuotoneIconData speakerNone = PhosphorDuotoneIconData(
    figure: IconData(0xe44f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe44e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speaker-simple-high`
  static const PhosphorDuotoneIconData
  speakerSimpleHigh = PhosphorDuotoneIconData(
    figure: IconData(0xe451, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe450, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speaker-simple-low`
  static const PhosphorDuotoneIconData
  speakerSimpleLow = PhosphorDuotoneIconData(
    figure: IconData(0xe453, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe452, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speaker-simple-none`
  static const PhosphorDuotoneIconData
  speakerSimpleNone = PhosphorDuotoneIconData(
    figure: IconData(0xe455, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe454, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speaker-simple-slash`
  static const PhosphorDuotoneIconData
  speakerSimpleSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe457, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe456, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speaker-simple-x`
  static const PhosphorDuotoneIconData speakerSimpleX = PhosphorDuotoneIconData(
    figure: IconData(0xe459, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe458, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speaker-slash`
  static const PhosphorDuotoneIconData speakerSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe45b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe45a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speaker-x`
  static const PhosphorDuotoneIconData speakerX = PhosphorDuotoneIconData(
    figure: IconData(0xe45d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe45c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `speedometer`
  static const PhosphorDuotoneIconData speedometer = PhosphorDuotoneIconData(
    figure: IconData(0xee75, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee74, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sphere`
  static const PhosphorDuotoneIconData sphere = PhosphorDuotoneIconData(
    figure: IconData(0xee67, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee66, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `spinner`
  static const PhosphorDuotoneIconData spinner = PhosphorDuotoneIconData(
    figure: IconData(0xe66b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe66a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `spinner-ball`
  static const PhosphorDuotoneIconData spinnerBall = PhosphorDuotoneIconData(
    figure: IconData(0xee29, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee28, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `spinner-gap`
  static const PhosphorDuotoneIconData spinnerGap = PhosphorDuotoneIconData(
    figure: IconData(0xe66d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe66c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `spiral`
  static const PhosphorDuotoneIconData spiral = PhosphorDuotoneIconData(
    figure: IconData(0xe9fb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9fa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `split-horizontal`
  static const PhosphorDuotoneIconData
  splitHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xe873, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe872, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `split-vertical`
  static const PhosphorDuotoneIconData splitVertical = PhosphorDuotoneIconData(
    figure: IconData(0xe877, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe876, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `spotify-logo`
  static const PhosphorDuotoneIconData spotifyLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe66f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe66e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `spray-bottle`
  static const PhosphorDuotoneIconData sprayBottle = PhosphorDuotoneIconData(
    figure: IconData(0xe7e8, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7e4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `square`
  static const PhosphorDuotoneIconData square = PhosphorDuotoneIconData(
    figure: IconData(0xe45f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe45e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `square-half`
  static const PhosphorDuotoneIconData squareHalf = PhosphorDuotoneIconData(
    figure: IconData(0xe463, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe462, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `square-half-bottom`
  static const PhosphorDuotoneIconData
  squareHalfBottom = PhosphorDuotoneIconData(
    figure: IconData(0xeb17, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb16, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `square-logo`
  static const PhosphorDuotoneIconData squareLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe691, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe690, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `square-split-horizontal`
  static const PhosphorDuotoneIconData
  squareSplitHorizontal = PhosphorDuotoneIconData(
    figure: IconData(0xe871, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe870, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `square-split-vertical`
  static const PhosphorDuotoneIconData
  squareSplitVertical = PhosphorDuotoneIconData(
    figure: IconData(0xe875, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe874, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `squares-four`
  static const PhosphorDuotoneIconData squaresFour = PhosphorDuotoneIconData(
    figure: IconData(0xe465, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe464, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stack`
  static const PhosphorDuotoneIconData stack = PhosphorDuotoneIconData(
    figure: IconData(0xe467, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe466, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stack-minus`
  static const PhosphorDuotoneIconData stackMinus = PhosphorDuotoneIconData(
    figure: IconData(0xedf5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedf4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stack-overflow-logo`
  static const PhosphorDuotoneIconData
  stackOverflowLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeb79, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb78, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stack-plus`
  static const PhosphorDuotoneIconData stackPlus = PhosphorDuotoneIconData(
    figure: IconData(0xedf7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedf6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stack-simple`
  static const PhosphorDuotoneIconData stackSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe469, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe468, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stairs`
  static const PhosphorDuotoneIconData stairs = PhosphorDuotoneIconData(
    figure: IconData(0xe8ed, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8ec, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stamp`
  static const PhosphorDuotoneIconData stamp = PhosphorDuotoneIconData(
    figure: IconData(0xea49, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea48, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `standard-definition`
  static const PhosphorDuotoneIconData
  standardDefinition = PhosphorDuotoneIconData(
    figure: IconData(0xea91, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea90, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `star`
  static const PhosphorDuotoneIconData star = PhosphorDuotoneIconData(
    figure: IconData(0xe46b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe46a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `star-and-crescent`
  static const PhosphorDuotoneIconData
  starAndCrescent = PhosphorDuotoneIconData(
    figure: IconData(0xecf5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecf4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `star-four`
  static const PhosphorDuotoneIconData starFour = PhosphorDuotoneIconData(
    figure: IconData(0xe6a5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6a4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `star-half`
  static const PhosphorDuotoneIconData starHalf = PhosphorDuotoneIconData(
    figure: IconData(0xe70b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe70a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `star-of-david`
  static const PhosphorDuotoneIconData starOfDavid = PhosphorDuotoneIconData(
    figure: IconData(0xe89f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe89e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `steam-logo`
  static const PhosphorDuotoneIconData steamLogo = PhosphorDuotoneIconData(
    figure: IconData(0xead5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xead4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `steering-wheel`
  static const PhosphorDuotoneIconData steeringWheel = PhosphorDuotoneIconData(
    figure: IconData(0xe9ad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9ac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `steps`
  static const PhosphorDuotoneIconData steps = PhosphorDuotoneIconData(
    figure: IconData(0xecbf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecbe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stethoscope`
  static const PhosphorDuotoneIconData stethoscope = PhosphorDuotoneIconData(
    figure: IconData(0xe7eb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7ea, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sticker`
  static const PhosphorDuotoneIconData sticker = PhosphorDuotoneIconData(
    figure: IconData(0xe5ad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5ac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stool`
  static const PhosphorDuotoneIconData stool = PhosphorDuotoneIconData(
    figure: IconData(0xea45, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea44, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stop`
  static const PhosphorDuotoneIconData stop = PhosphorDuotoneIconData(
    figure: IconData(0xe46d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe46c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stop-circle`
  static const PhosphorDuotoneIconData stopCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe46f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe46e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `storefront`
  static const PhosphorDuotoneIconData storefront = PhosphorDuotoneIconData(
    figure: IconData(0xe471, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe470, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `strategy`
  static const PhosphorDuotoneIconData strategy = PhosphorDuotoneIconData(
    figure: IconData(0xea3b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea3a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `stripe-logo`
  static const PhosphorDuotoneIconData stripeLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe699, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe698, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `student`
  static const PhosphorDuotoneIconData student = PhosphorDuotoneIconData(
    figure: IconData(0xe73f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe73e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `subset-of`
  static const PhosphorDuotoneIconData subsetOf = PhosphorDuotoneIconData(
    figure: IconData(0xedc1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedc0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `subset-proper-of`
  static const PhosphorDuotoneIconData subsetProperOf = PhosphorDuotoneIconData(
    figure: IconData(0xedb7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedb6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `subtitles`
  static const PhosphorDuotoneIconData subtitles = PhosphorDuotoneIconData(
    figure: IconData(0xe1a9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1a8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `subtitles-slash`
  static const PhosphorDuotoneIconData subtitlesSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe1a7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe1a6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `subtract`
  static const PhosphorDuotoneIconData subtract = PhosphorDuotoneIconData(
    figure: IconData(0xebd7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebd6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `subtract-square`
  static const PhosphorDuotoneIconData subtractSquare = PhosphorDuotoneIconData(
    figure: IconData(0xebd5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xebd4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `subway`
  static const PhosphorDuotoneIconData subway = PhosphorDuotoneIconData(
    figure: IconData(0xe499, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe498, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `suitcase`
  static const PhosphorDuotoneIconData suitcase = PhosphorDuotoneIconData(
    figure: IconData(0xe5af, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5ae, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `suitcase-rolling`
  static const PhosphorDuotoneIconData
  suitcaseRolling = PhosphorDuotoneIconData(
    figure: IconData(0xe9b1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9b0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `suitcase-simple`
  static const PhosphorDuotoneIconData suitcaseSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe5b1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5b0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sun`
  static const PhosphorDuotoneIconData sun = PhosphorDuotoneIconData(
    figure: IconData(0xe473, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe472, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sun-dim`
  static const PhosphorDuotoneIconData sunDim = PhosphorDuotoneIconData(
    figure: IconData(0xe475, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe474, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sun-horizon`
  static const PhosphorDuotoneIconData sunHorizon = PhosphorDuotoneIconData(
    figure: IconData(0xe5b7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5b6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sunglasses`
  static const PhosphorDuotoneIconData sunglasses = PhosphorDuotoneIconData(
    figure: IconData(0xe817, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe816, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `superset-of`
  static const PhosphorDuotoneIconData supersetOf = PhosphorDuotoneIconData(
    figure: IconData(0xedb9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedb8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `superset-proper-of`
  static const PhosphorDuotoneIconData
  supersetProperOf = PhosphorDuotoneIconData(
    figure: IconData(0xedb5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedb4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `swap`
  static const PhosphorDuotoneIconData swap = PhosphorDuotoneIconData(
    figure: IconData(0xe83d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe83c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `swatches`
  static const PhosphorDuotoneIconData swatches = PhosphorDuotoneIconData(
    figure: IconData(0xe5b9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5b8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `swimming-pool`
  static const PhosphorDuotoneIconData swimmingPool = PhosphorDuotoneIconData(
    figure: IconData(0xecb7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecb6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `sword`
  static const PhosphorDuotoneIconData sword = PhosphorDuotoneIconData(
    figure: IconData(0xe5bb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5ba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `synagogue`
  static const PhosphorDuotoneIconData synagogue = PhosphorDuotoneIconData(
    figure: IconData(0xeced, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecec, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `syringe`
  static const PhosphorDuotoneIconData syringe = PhosphorDuotoneIconData(
    figure: IconData(0xe969, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe968, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `t-shirt`
  static const PhosphorDuotoneIconData tShirt = PhosphorDuotoneIconData(
    figure: IconData(0xe671, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe670, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `table`
  static const PhosphorDuotoneIconData table = PhosphorDuotoneIconData(
    figure: IconData(0xe477, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe476, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tabs`
  static const PhosphorDuotoneIconData tabs = PhosphorDuotoneIconData(
    figure: IconData(0xe779, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe778, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tag`
  static const PhosphorDuotoneIconData tag = PhosphorDuotoneIconData(
    figure: IconData(0xe479, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe478, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tag-chevron`
  static const PhosphorDuotoneIconData tagChevron = PhosphorDuotoneIconData(
    figure: IconData(0xe673, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe672, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tag-simple`
  static const PhosphorDuotoneIconData tagSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe47b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe47a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `target`
  static const PhosphorDuotoneIconData target = PhosphorDuotoneIconData(
    figure: IconData(0xe47d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe47c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `taxi`
  static const PhosphorDuotoneIconData taxi = PhosphorDuotoneIconData(
    figure: IconData(0xe903, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe902, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tea-bag`
  static const PhosphorDuotoneIconData teaBag = PhosphorDuotoneIconData(
    figure: IconData(0xe8e7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8e6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `telegram-logo`
  static const PhosphorDuotoneIconData telegramLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe5bd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5bc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `television`
  static const PhosphorDuotoneIconData television = PhosphorDuotoneIconData(
    figure: IconData(0xe755, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe754, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `television-simple`
  static const PhosphorDuotoneIconData
  televisionSimple = PhosphorDuotoneIconData(
    figure: IconData(0xeae7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeae6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tennis-ball`
  static const PhosphorDuotoneIconData tennisBall = PhosphorDuotoneIconData(
    figure: IconData(0xe721, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe720, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tent`
  static const PhosphorDuotoneIconData tent = PhosphorDuotoneIconData(
    figure: IconData(0xe8bb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8ba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `terminal`
  static const PhosphorDuotoneIconData terminal = PhosphorDuotoneIconData(
    figure: IconData(0xe47f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe47e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `terminal-window`
  static const PhosphorDuotoneIconData terminalWindow = PhosphorDuotoneIconData(
    figure: IconData(0xeae9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeae8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `test-tube`
  static const PhosphorDuotoneIconData testTube = PhosphorDuotoneIconData(
    figure: IconData(0xe7a1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7a0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-a-underline`
  static const PhosphorDuotoneIconData textAUnderline = PhosphorDuotoneIconData(
    figure: IconData(0xed35, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed34, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-aa`
  static const PhosphorDuotoneIconData textAa = PhosphorDuotoneIconData(
    figure: IconData(0xe6ef, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6ee, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-align-center`
  static const PhosphorDuotoneIconData
  textAlignCenter = PhosphorDuotoneIconData(
    figure: IconData(0xe481, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe480, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-align-justify`
  static const PhosphorDuotoneIconData
  textAlignJustify = PhosphorDuotoneIconData(
    figure: IconData(0xe483, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe482, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-align-left`
  static const PhosphorDuotoneIconData textAlignLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe485, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe484, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-align-right`
  static const PhosphorDuotoneIconData textAlignRight = PhosphorDuotoneIconData(
    figure: IconData(0xe487, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe486, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-b`
  static const PhosphorDuotoneIconData textB = PhosphorDuotoneIconData(
    figure: IconData(0xe5bf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5be, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-bolder` — apelido de `text-b`
  static const PhosphorDuotoneIconData textBolder = PhosphorDuotoneIconData(
    figure: IconData(0xe5bf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5be, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-columns`
  static const PhosphorDuotoneIconData textColumns = PhosphorDuotoneIconData(
    figure: IconData(0xec97, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec96, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-h`
  static const PhosphorDuotoneIconData textH = PhosphorDuotoneIconData(
    figure: IconData(0xe6bb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6ba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-h-five`
  static const PhosphorDuotoneIconData textHFive = PhosphorDuotoneIconData(
    figure: IconData(0xe6c5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6c4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-h-four`
  static const PhosphorDuotoneIconData textHFour = PhosphorDuotoneIconData(
    figure: IconData(0xe6c3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6c2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-h-one`
  static const PhosphorDuotoneIconData textHOne = PhosphorDuotoneIconData(
    figure: IconData(0xe6bd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6bc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-h-six`
  static const PhosphorDuotoneIconData textHSix = PhosphorDuotoneIconData(
    figure: IconData(0xe6c7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6c6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-h-three`
  static const PhosphorDuotoneIconData textHThree = PhosphorDuotoneIconData(
    figure: IconData(0xe6c1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6c0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-h-two`
  static const PhosphorDuotoneIconData textHTwo = PhosphorDuotoneIconData(
    figure: IconData(0xe6bf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6be, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-indent`
  static const PhosphorDuotoneIconData textIndent = PhosphorDuotoneIconData(
    figure: IconData(0xea1f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea1e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-italic`
  static const PhosphorDuotoneIconData textItalic = PhosphorDuotoneIconData(
    figure: IconData(0xe5c1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5c0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-outdent`
  static const PhosphorDuotoneIconData textOutdent = PhosphorDuotoneIconData(
    figure: IconData(0xea1d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea1c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-strikethrough`
  static const PhosphorDuotoneIconData
  textStrikethrough = PhosphorDuotoneIconData(
    figure: IconData(0xe5c3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5c2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-subscript`
  static const PhosphorDuotoneIconData textSubscript = PhosphorDuotoneIconData(
    figure: IconData(0xec99, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec98, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-superscript`
  static const PhosphorDuotoneIconData
  textSuperscript = PhosphorDuotoneIconData(
    figure: IconData(0xec9b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec9a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-t`
  static const PhosphorDuotoneIconData textT = PhosphorDuotoneIconData(
    figure: IconData(0xe48b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe48a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-t-slash`
  static const PhosphorDuotoneIconData textTSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe489, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe488, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `text-underline`
  static const PhosphorDuotoneIconData textUnderline = PhosphorDuotoneIconData(
    figure: IconData(0xe5c5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5c4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `textbox`
  static const PhosphorDuotoneIconData textbox = PhosphorDuotoneIconData(
    figure: IconData(0xeb0b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeb0a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `thermometer`
  static const PhosphorDuotoneIconData thermometer = PhosphorDuotoneIconData(
    figure: IconData(0xe5c7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5c6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `thermometer-cold`
  static const PhosphorDuotoneIconData
  thermometerCold = PhosphorDuotoneIconData(
    figure: IconData(0xe5c9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5c8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `thermometer-hot`
  static const PhosphorDuotoneIconData thermometerHot = PhosphorDuotoneIconData(
    figure: IconData(0xe5cb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5ca, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `thermometer-simple`
  static const PhosphorDuotoneIconData
  thermometerSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe5cd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5cc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `threads-logo`
  static const PhosphorDuotoneIconData threadsLogo = PhosphorDuotoneIconData(
    figure: IconData(0xed9f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed9e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `three-d`
  static const PhosphorDuotoneIconData threeD = PhosphorDuotoneIconData(
    figure: IconData(0xea5b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea5a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `thumbs-down`
  static const PhosphorDuotoneIconData thumbsDown = PhosphorDuotoneIconData(
    figure: IconData(0xe48d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe48c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `thumbs-up`
  static const PhosphorDuotoneIconData thumbsUp = PhosphorDuotoneIconData(
    figure: IconData(0xe48f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe48e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `ticket`
  static const PhosphorDuotoneIconData ticket = PhosphorDuotoneIconData(
    figure: IconData(0xe491, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe490, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tidal-logo`
  static const PhosphorDuotoneIconData tidalLogo = PhosphorDuotoneIconData(
    figure: IconData(0xed1d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed1c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tiktok-logo`
  static const PhosphorDuotoneIconData tiktokLogo = PhosphorDuotoneIconData(
    figure: IconData(0xeaf3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaf2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tilde`
  static const PhosphorDuotoneIconData tilde = PhosphorDuotoneIconData(
    figure: IconData(0xeda9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeda8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `timer`
  static const PhosphorDuotoneIconData timer = PhosphorDuotoneIconData(
    figure: IconData(0xe493, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe492, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tip-jar`
  static const PhosphorDuotoneIconData tipJar = PhosphorDuotoneIconData(
    figure: IconData(0xe7e9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7e2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tipi`
  static const PhosphorDuotoneIconData tipi = PhosphorDuotoneIconData(
    figure: IconData(0xed31, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed30, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tire`
  static const PhosphorDuotoneIconData tire = PhosphorDuotoneIconData(
    figure: IconData(0xedd3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedd2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `toggle-left`
  static const PhosphorDuotoneIconData toggleLeft = PhosphorDuotoneIconData(
    figure: IconData(0xe675, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe674, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `toggle-right`
  static const PhosphorDuotoneIconData toggleRight = PhosphorDuotoneIconData(
    figure: IconData(0xe677, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe676, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `toilet`
  static const PhosphorDuotoneIconData toilet = PhosphorDuotoneIconData(
    figure: IconData(0xe79b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe79a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `toilet-paper`
  static const PhosphorDuotoneIconData toiletPaper = PhosphorDuotoneIconData(
    figure: IconData(0xe79d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe79c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `toolbox`
  static const PhosphorDuotoneIconData toolbox = PhosphorDuotoneIconData(
    figure: IconData(0xeca1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeca0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tooth`
  static const PhosphorDuotoneIconData tooth = PhosphorDuotoneIconData(
    figure: IconData(0xe9cd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9cc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tornado`
  static const PhosphorDuotoneIconData tornado = PhosphorDuotoneIconData(
    figure: IconData(0xe88d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe88c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tote`
  static const PhosphorDuotoneIconData tote = PhosphorDuotoneIconData(
    figure: IconData(0xe495, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe494, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tote-simple`
  static const PhosphorDuotoneIconData toteSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe679, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe678, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `towel`
  static const PhosphorDuotoneIconData towel = PhosphorDuotoneIconData(
    figure: IconData(0xede7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xede6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tractor`
  static const PhosphorDuotoneIconData tractor = PhosphorDuotoneIconData(
    figure: IconData(0xec6f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec6e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `trademark`
  static const PhosphorDuotoneIconData trademark = PhosphorDuotoneIconData(
    figure: IconData(0xe9f1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9f0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `trademark-registered`
  static const PhosphorDuotoneIconData
  trademarkRegistered = PhosphorDuotoneIconData(
    figure: IconData(0xe415, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe3f4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `traffic-cone`
  static const PhosphorDuotoneIconData trafficCone = PhosphorDuotoneIconData(
    figure: IconData(0xe9a9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9a8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `traffic-sign`
  static const PhosphorDuotoneIconData trafficSign = PhosphorDuotoneIconData(
    figure: IconData(0xe67b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe67a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `traffic-signal`
  static const PhosphorDuotoneIconData trafficSignal = PhosphorDuotoneIconData(
    figure: IconData(0xe9ab, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9aa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `train`
  static const PhosphorDuotoneIconData train = PhosphorDuotoneIconData(
    figure: IconData(0xe497, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe496, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `train-regional`
  static const PhosphorDuotoneIconData trainRegional = PhosphorDuotoneIconData(
    figure: IconData(0xe49f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe49e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `train-simple`
  static const PhosphorDuotoneIconData trainSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe4a1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4a0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tram`
  static const PhosphorDuotoneIconData tram = PhosphorDuotoneIconData(
    figure: IconData(0xe9ed, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9ec, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `translate`
  static const PhosphorDuotoneIconData translate = PhosphorDuotoneIconData(
    figure: IconData(0xe4a3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4a2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `trash`
  static const PhosphorDuotoneIconData trash = PhosphorDuotoneIconData(
    figure: IconData(0xe4a7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4a6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `trash-simple`
  static const PhosphorDuotoneIconData trashSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe4a9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4a8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tray`
  static const PhosphorDuotoneIconData tray = PhosphorDuotoneIconData(
    figure: IconData(0xe4ab, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4aa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tray-arrow-down`
  static const PhosphorDuotoneIconData trayArrowDown = PhosphorDuotoneIconData(
    figure: IconData(0xe011, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe010, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tray-arrow-up`
  static const PhosphorDuotoneIconData trayArrowUp = PhosphorDuotoneIconData(
    figure: IconData(0xee53, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee52, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `treasure-chest`
  static const PhosphorDuotoneIconData treasureChest = PhosphorDuotoneIconData(
    figure: IconData(0xede3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xede2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tree`
  static const PhosphorDuotoneIconData tree = PhosphorDuotoneIconData(
    figure: IconData(0xe6db, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6da, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tree-evergreen`
  static const PhosphorDuotoneIconData treeEvergreen = PhosphorDuotoneIconData(
    figure: IconData(0xe6dd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6dc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tree-palm`
  static const PhosphorDuotoneIconData treePalm = PhosphorDuotoneIconData(
    figure: IconData(0xe91b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe91a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tree-structure`
  static const PhosphorDuotoneIconData treeStructure = PhosphorDuotoneIconData(
    figure: IconData(0xe67d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe67c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tree-view`
  static const PhosphorDuotoneIconData treeView = PhosphorDuotoneIconData(
    figure: IconData(0xee49, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee48, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `trend-down`
  static const PhosphorDuotoneIconData trendDown = PhosphorDuotoneIconData(
    figure: IconData(0xe4ad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4ac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `trend-up`
  static const PhosphorDuotoneIconData trendUp = PhosphorDuotoneIconData(
    figure: IconData(0xe4af, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4ae, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `triangle`
  static const PhosphorDuotoneIconData triangle = PhosphorDuotoneIconData(
    figure: IconData(0xe4b1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4b0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `triangle-dashed`
  static const PhosphorDuotoneIconData triangleDashed = PhosphorDuotoneIconData(
    figure: IconData(0xe4b3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4b2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `trolley`
  static const PhosphorDuotoneIconData trolley = PhosphorDuotoneIconData(
    figure: IconData(0xe5b3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5b2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `trolley-suitcase`
  static const PhosphorDuotoneIconData
  trolleySuitcase = PhosphorDuotoneIconData(
    figure: IconData(0xe5b5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5b4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `trophy`
  static const PhosphorDuotoneIconData trophy = PhosphorDuotoneIconData(
    figure: IconData(0xe67f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe67e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `truck`
  static const PhosphorDuotoneIconData truck = PhosphorDuotoneIconData(
    figure: IconData(0xe4b5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4b4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `truck-trailer`
  static const PhosphorDuotoneIconData truckTrailer = PhosphorDuotoneIconData(
    figure: IconData(0xe4b7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4b6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `tumblr-logo`
  static const PhosphorDuotoneIconData tumblrLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe8d5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8d4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `twitch-logo`
  static const PhosphorDuotoneIconData twitchLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe5cf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5ce, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `twitter-logo`
  static const PhosphorDuotoneIconData twitterLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe4bb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4ba, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `umbrella`
  static const PhosphorDuotoneIconData umbrella = PhosphorDuotoneIconData(
    figure: IconData(0xe685, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe684, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `umbrella-simple`
  static const PhosphorDuotoneIconData umbrellaSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe687, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe686, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `union`
  static const PhosphorDuotoneIconData union = PhosphorDuotoneIconData(
    figure: IconData(0xedbf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedbe, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `unite`
  static const PhosphorDuotoneIconData unite = PhosphorDuotoneIconData(
    figure: IconData(0xe87f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe87e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `unite-square`
  static const PhosphorDuotoneIconData uniteSquare = PhosphorDuotoneIconData(
    figure: IconData(0xe879, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe878, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `upload`
  static const PhosphorDuotoneIconData upload = PhosphorDuotoneIconData(
    figure: IconData(0xe4bf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4be, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `upload-simple`
  static const PhosphorDuotoneIconData uploadSimple = PhosphorDuotoneIconData(
    figure: IconData(0xe4c1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4c0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `usb`
  static const PhosphorDuotoneIconData usb = PhosphorDuotoneIconData(
    figure: IconData(0xe957, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe956, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user`
  static const PhosphorDuotoneIconData user = PhosphorDuotoneIconData(
    figure: IconData(0xe4c3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4c2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-check`
  static const PhosphorDuotoneIconData userCheck = PhosphorDuotoneIconData(
    figure: IconData(0xeafb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeafa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-circle`
  static const PhosphorDuotoneIconData userCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe4c5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4c4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-circle-check`
  static const PhosphorDuotoneIconData
  userCircleCheck = PhosphorDuotoneIconData(
    figure: IconData(0xec39, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec38, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-circle-dashed`
  static const PhosphorDuotoneIconData
  userCircleDashed = PhosphorDuotoneIconData(
    figure: IconData(0xec37, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xec36, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-circle-gear`
  static const PhosphorDuotoneIconData userCircleGear = PhosphorDuotoneIconData(
    figure: IconData(0xe4c7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4c6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-circle-minus`
  static const PhosphorDuotoneIconData
  userCircleMinus = PhosphorDuotoneIconData(
    figure: IconData(0xe4c9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4c8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-circle-plus`
  static const PhosphorDuotoneIconData userCirclePlus = PhosphorDuotoneIconData(
    figure: IconData(0xe4cb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4ca, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-focus`
  static const PhosphorDuotoneIconData userFocus = PhosphorDuotoneIconData(
    figure: IconData(0xe6fd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6fc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-gear`
  static const PhosphorDuotoneIconData userGear = PhosphorDuotoneIconData(
    figure: IconData(0xe4cd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4cc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-list`
  static const PhosphorDuotoneIconData userList = PhosphorDuotoneIconData(
    figure: IconData(0xe73d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe73c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-minus`
  static const PhosphorDuotoneIconData userMinus = PhosphorDuotoneIconData(
    figure: IconData(0xe4cf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4ce, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-plus`
  static const PhosphorDuotoneIconData userPlus = PhosphorDuotoneIconData(
    figure: IconData(0xe4d1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4d0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-rectangle`
  static const PhosphorDuotoneIconData userRectangle = PhosphorDuotoneIconData(
    figure: IconData(0xe4d3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4d2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-sound`
  static const PhosphorDuotoneIconData userSound = PhosphorDuotoneIconData(
    figure: IconData(0xeca9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeca8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-square`
  static const PhosphorDuotoneIconData userSquare = PhosphorDuotoneIconData(
    figure: IconData(0xe4d5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4d4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `user-switch`
  static const PhosphorDuotoneIconData userSwitch = PhosphorDuotoneIconData(
    figure: IconData(0xe757, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe756, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `users`
  static const PhosphorDuotoneIconData users = PhosphorDuotoneIconData(
    figure: IconData(0xe4d7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4d6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `users-four`
  static const PhosphorDuotoneIconData usersFour = PhosphorDuotoneIconData(
    figure: IconData(0xe68d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe68c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `users-three`
  static const PhosphorDuotoneIconData usersThree = PhosphorDuotoneIconData(
    figure: IconData(0xe68f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe68e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `van`
  static const PhosphorDuotoneIconData van = PhosphorDuotoneIconData(
    figure: IconData(0xe827, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe826, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `vault`
  static const PhosphorDuotoneIconData vault = PhosphorDuotoneIconData(
    figure: IconData(0xe76f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe76e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `vector-three`
  static const PhosphorDuotoneIconData vectorThree = PhosphorDuotoneIconData(
    figure: IconData(0xee63, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee62, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `vector-two`
  static const PhosphorDuotoneIconData vectorTwo = PhosphorDuotoneIconData(
    figure: IconData(0xee65, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee64, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `vibrate`
  static const PhosphorDuotoneIconData vibrate = PhosphorDuotoneIconData(
    figure: IconData(0xe4d9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4d8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `video`
  static const PhosphorDuotoneIconData video = PhosphorDuotoneIconData(
    figure: IconData(0xe741, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe740, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `video-camera`
  static const PhosphorDuotoneIconData videoCamera = PhosphorDuotoneIconData(
    figure: IconData(0xe4db, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4da, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `video-camera-slash`
  static const PhosphorDuotoneIconData
  videoCameraSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe4dd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4dc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `video-conference`
  static const PhosphorDuotoneIconData
  videoConference = PhosphorDuotoneIconData(
    figure: IconData(0xedcf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xedce, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `vignette`
  static const PhosphorDuotoneIconData vignette = PhosphorDuotoneIconData(
    figure: IconData(0xeba3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeba2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `vinyl-record`
  static const PhosphorDuotoneIconData vinylRecord = PhosphorDuotoneIconData(
    figure: IconData(0xecad, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecac, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `virtual-reality`
  static const PhosphorDuotoneIconData virtualReality = PhosphorDuotoneIconData(
    figure: IconData(0xe7b9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7b8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `virus`
  static const PhosphorDuotoneIconData virus = PhosphorDuotoneIconData(
    figure: IconData(0xe7d7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7d6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `visor`
  static const PhosphorDuotoneIconData visor = PhosphorDuotoneIconData(
    figure: IconData(0xee2b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xee2a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `voicemail`
  static const PhosphorDuotoneIconData voicemail = PhosphorDuotoneIconData(
    figure: IconData(0xe4df, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4de, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `volleyball`
  static const PhosphorDuotoneIconData volleyball = PhosphorDuotoneIconData(
    figure: IconData(0xe727, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe726, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wall`
  static const PhosphorDuotoneIconData wall = PhosphorDuotoneIconData(
    figure: IconData(0xe689, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe688, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wallet`
  static const PhosphorDuotoneIconData wallet = PhosphorDuotoneIconData(
    figure: IconData(0xe68b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe68a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `warehouse`
  static const PhosphorDuotoneIconData warehouse = PhosphorDuotoneIconData(
    figure: IconData(0xecd5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecd4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `warning`
  static const PhosphorDuotoneIconData warning = PhosphorDuotoneIconData(
    figure: IconData(0xe4e1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4e0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `warning-circle`
  static const PhosphorDuotoneIconData warningCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe4e3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4e2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `warning-diamond`
  static const PhosphorDuotoneIconData warningDiamond = PhosphorDuotoneIconData(
    figure: IconData(0xe7fd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe7fc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `warning-octagon`
  static const PhosphorDuotoneIconData warningOctagon = PhosphorDuotoneIconData(
    figure: IconData(0xe4e5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4e4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `washing-machine`
  static const PhosphorDuotoneIconData washingMachine = PhosphorDuotoneIconData(
    figure: IconData(0xede9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xede8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `watch`
  static const PhosphorDuotoneIconData watch = PhosphorDuotoneIconData(
    figure: IconData(0xe4e7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4e6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wave-sawtooth`
  static const PhosphorDuotoneIconData waveSawtooth = PhosphorDuotoneIconData(
    figure: IconData(0xea9d, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea9c, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wave-sine`
  static const PhosphorDuotoneIconData waveSine = PhosphorDuotoneIconData(
    figure: IconData(0xea9b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea9a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wave-square`
  static const PhosphorDuotoneIconData waveSquare = PhosphorDuotoneIconData(
    figure: IconData(0xea9f, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xea9e, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wave-triangle`
  static const PhosphorDuotoneIconData waveTriangle = PhosphorDuotoneIconData(
    figure: IconData(0xeaa1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xeaa0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `waveform`
  static const PhosphorDuotoneIconData waveform = PhosphorDuotoneIconData(
    figure: IconData(0xe803, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe802, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `waveform-slash`
  static const PhosphorDuotoneIconData waveformSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe801, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe800, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `waves`
  static const PhosphorDuotoneIconData waves = PhosphorDuotoneIconData(
    figure: IconData(0xe6df, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6de, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `webcam`
  static const PhosphorDuotoneIconData webcam = PhosphorDuotoneIconData(
    figure: IconData(0xe9b3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9b2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `webcam-slash`
  static const PhosphorDuotoneIconData webcamSlash = PhosphorDuotoneIconData(
    figure: IconData(0xecdd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecdc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `webhooks-logo`
  static const PhosphorDuotoneIconData webhooksLogo = PhosphorDuotoneIconData(
    figure: IconData(0xecaf, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xecae, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wechat-logo`
  static const PhosphorDuotoneIconData wechatLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe8d3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe8d2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `whatsapp-logo`
  static const PhosphorDuotoneIconData whatsappLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe5d1, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5d0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wheelchair`
  static const PhosphorDuotoneIconData wheelchair = PhosphorDuotoneIconData(
    figure: IconData(0xe4e9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4e8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wheelchair-motion`
  static const PhosphorDuotoneIconData
  wheelchairMotion = PhosphorDuotoneIconData(
    figure: IconData(0xe89b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe89a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wifi-high`
  static const PhosphorDuotoneIconData wifiHigh = PhosphorDuotoneIconData(
    figure: IconData(0xe4eb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4ea, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wifi-low`
  static const PhosphorDuotoneIconData wifiLow = PhosphorDuotoneIconData(
    figure: IconData(0xe4ed, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4ec, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wifi-medium`
  static const PhosphorDuotoneIconData wifiMedium = PhosphorDuotoneIconData(
    figure: IconData(0xe4ef, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4ee, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wifi-none`
  static const PhosphorDuotoneIconData wifiNone = PhosphorDuotoneIconData(
    figure: IconData(0xe4f0, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wifi-slash`
  static const PhosphorDuotoneIconData wifiSlash = PhosphorDuotoneIconData(
    figure: IconData(0xe4f3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4f2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wifi-x`
  static const PhosphorDuotoneIconData wifiX = PhosphorDuotoneIconData(
    figure: IconData(0xe4f5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4f4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wind`
  static const PhosphorDuotoneIconData wind = PhosphorDuotoneIconData(
    figure: IconData(0xe5d3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5d2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `windmill`
  static const PhosphorDuotoneIconData windmill = PhosphorDuotoneIconData(
    figure: IconData(0xe9f9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe9f8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `windows-logo`
  static const PhosphorDuotoneIconData windowsLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe693, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe692, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wine`
  static const PhosphorDuotoneIconData wine = PhosphorDuotoneIconData(
    figure: IconData(0xe6b3, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe6b2, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `wrench`
  static const PhosphorDuotoneIconData wrench = PhosphorDuotoneIconData(
    figure: IconData(0xe5d5, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe5d4, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `x`
  static const PhosphorDuotoneIconData x = PhosphorDuotoneIconData(
    figure: IconData(0xe4f7, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4f6, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `x-circle`
  static const PhosphorDuotoneIconData xCircle = PhosphorDuotoneIconData(
    figure: IconData(0xe4f9, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4f8, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `x-logo`
  static const PhosphorDuotoneIconData xLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe4bd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4bc, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `x-square`
  static const PhosphorDuotoneIconData xSquare = PhosphorDuotoneIconData(
    figure: IconData(0xe4fb, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4fa, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `yarn`
  static const PhosphorDuotoneIconData yarn = PhosphorDuotoneIconData(
    figure: IconData(0xed9b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xed9a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `yin-yang`
  static const PhosphorDuotoneIconData yinYang = PhosphorDuotoneIconData(
    figure: IconData(0xe92b, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe92a, fontFamily: fontFamily, fontPackage: fontPackage),
  );

  /// `youtube-logo`
  static const PhosphorDuotoneIconData youtubeLogo = PhosphorDuotoneIconData(
    figure: IconData(0xe4fd, fontFamily: fontFamily, fontPackage: fontPackage),
    ground: IconData(0xe4fc, fontFamily: fontFamily, fontPackage: fontPackage),
  );
}
