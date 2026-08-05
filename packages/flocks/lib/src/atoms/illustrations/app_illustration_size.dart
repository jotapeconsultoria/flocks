/// The size of the illustration.
///
/// Example:
/// ```dart
/// AppIllustrationSize.s.value; // 128.0
/// ```
enum AppIllustrationSize {
  /// The size of the illustration.
  ///
  /// Example:
  /// ```dart
  /// AppIllustrationSize.s.value; // 128.0
  /// ```
  s,

  /// The size of the illustration.
  ///
  /// Example:
  /// ```dart
  /// AppIllustrationSize.m.value; // 192.0
  /// ```
  m,

  /// The size of the illustration.
  ///
  /// Example:
  /// ```dart
  /// AppIllustrationSize.l.value; // 256.0
  /// ```
  l,

  /// The size of the illustration.
  ///
  /// Example:
  /// ```dart
  /// AppIllustrationSize.xl.value; // 384.0
  /// ```
  xl;

  /// The value of the illustration size.
  double get value => switch (this) {
    AppIllustrationSize.s => 128.0,
    AppIllustrationSize.m => 192.0,
    AppIllustrationSize.l => 256.0,
    AppIllustrationSize.xl => 384.0,
  };
}
