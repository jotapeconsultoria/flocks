/// The size of the icon.
///
/// Example:
/// ```dart
/// AppIconSize.s.value; // 16.0
/// ```
enum AppIconSize {
  /// The size of the icon.
  ///
  /// Example:
  /// ```dart
  /// AppIconSize.s.value; // 16.0
  /// ```
  s,

  /// The size of the icon.
  ///
  /// Example:
  /// ```dart
  /// AppIconSize.m.value; // 24.0
  /// ```
  m,

  /// The size of the icon.
  ///
  /// Example:
  /// ```dart
  /// AppIconSize.l.value; // 32.0
  /// ```
  l,

  /// The size of the icon.
  ///
  /// Example:
  /// ```dart
  /// AppIconSize.xl.value; // 64.0
  /// ```
  xl;

  /// The value of the icon size.
  double get value => switch (this) {
    AppIconSize.s => 16.0,
    AppIconSize.m => 24.0,
    AppIconSize.l => 32.0,
    AppIconSize.xl => 64.0,
  };
}
