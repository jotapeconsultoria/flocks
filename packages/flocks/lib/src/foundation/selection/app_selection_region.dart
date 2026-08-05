import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import 'app_text_selection_controls.dart';

/// Enables text selection for an app subtree without depending on Material.
final class AppSelectionRegion extends StatelessWidget {
  const AppSelectionRegion({required this.child, super.key});

  /// The subtree where text selection should be available.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<SelectionRegistrarScope>();
    if (scope != null && scope.registrar == null) {
      return child;
    }

    if (Overlay.maybeOf(context) == null) {
      return child;
    }

    final theme = AppTheme.of(context);
    final selectionControls = appTextSelectionControls;

    return DefaultSelectionStyle(
      selectionColor: theme.colorTheme.primary.s300.withValues(alpha: 0.34),
      mouseCursor: SystemMouseCursors.text,
      child: SelectableRegion(
        selectionControls: selectionControls,
        child: child,
      ),
    );
  }
}
