/// A class that contains the spacings used in the App.
///
/// Named by value in a single pattern (`s<px>`) so the scale reads in order and
/// intermediate steps (12/24/48) slot in naturally.
sealed class AppSpacings {
  /// The spacing value for infinity.
  static const double infinity = double.infinity;

  /// No spacing. (0.0)
  static const double s0 = 0.0;

  /// 1.0 spacing.
  static const double s1 = 1.0;

  /// 2.0 spacing.
  static const double s2 = 2.0;

  /// 4.0 spacing.
  static const double s4 = 4.0;

  /// 8.0 spacing.
  static const double s8 = 8.0;

  /// 12.0 spacing.
  static const double s12 = 12.0;

  /// 16.0 spacing.
  static const double s16 = 16.0;

  /// 24.0 spacing.
  static const double s24 = 24.0;

  /// 32.0 spacing.
  static const double s32 = 32.0;

  /// 48.0 spacing.
  static const double s48 = 48.0;

  /// 64.0 spacing.
  static const double s64 = 64.0;

  /// 128.0 spacing.
  static const double s128 = 128.0;

  /// 192.0 spacing.
  static const double s192 = 192.0;
}
