import 'package:flutter/widgets.dart';

import '../../foundation/a11y/app_semantics.dart';
import '../../theme/theme.dart';
import '../../tokens/app_strokes.dart';

/// A thin rule that separates content — the Flocks divider.
///
/// Draws a hairline line whose color comes from the theme (`divider` by
/// default — a subtle `onSurface` tint that adapts to light/dark and brand,
/// lighter than the `outline` control-border token). Non-interactive and
/// decorative, so it is excluded from the semantics tree (Regra 8).
///
/// A horizontal divider fills the width of its (bounded-width) parent; a
/// vertical divider fills the height of its (bounded-height) parent. Use
/// [AppDivider.vertical] between items in a `Row`.
///
/// ```dart
/// Column(
///   children: <Widget>[
///     AppText('Above'),
///     AppDivider(indent: 8, endIndent: 8),
///     AppText('Below'),
///   ],
/// )
/// ```
final class AppDivider extends StatelessWidget {
  /// A horizontal divider (fills the parent width).
  const AppDivider({
    this.thickness = AppStrokes.s,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
    this.radius,
    super.key,
  }) : axis = Axis.horizontal;

  /// A vertical divider (fills the parent height). Use between items in a `Row`.
  const AppDivider.vertical({
    this.thickness = AppStrokes.s,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
    this.radius,
    super.key,
  }) : axis = Axis.vertical;

  /// The orientation of the rule.
  final Axis axis;

  /// The line's thickness. Defaults to [AppStrokes.s] (1.0).
  final double thickness;

  /// Empty space before the line, along its main axis (left / top).
  final double indent;

  /// Empty space after the line, along its main axis (right / bottom).
  final double endIndent;

  /// Overrides the line color. Defaults to the theme `divider`.
  final Color? color;

  /// Corner radius of the rule's ends. Defaults to the global radius axis
  /// (redondo mode, auto-clamped to the thickness, so it reads as rounded caps
  /// that follow the global radius on thicker rules).
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final Color lineColor = color ?? theme.colorTheme.divider;
    final double rad = radius ?? theme.radiusTheme.resolveRadius();
    final bool horizontal = axis == Axis.horizontal;

    final Widget line = Container(
      height: horizontal ? thickness : null,
      width: horizontal ? null : thickness,
      margin: horizontal
          ? EdgeInsets.only(left: indent, right: endIndent)
          : EdgeInsets.only(top: indent, bottom: endIndent),
      decoration: BoxDecoration(
        color: lineColor,
        borderRadius: BorderRadius.circular(rad),
      ),
    );

    // Fill the cross-dimension of a bounded parent (Column width / Row height),
    // mirroring the ergonomics of a full-bleed rule.
    return AppSemantics.decorative(
      ConstrainedBox(
        constraints: horizontal
            ? const BoxConstraints(minWidth: double.infinity)
            : const BoxConstraints(minHeight: double.infinity),
        child: line,
      ),
    );
  }
}
