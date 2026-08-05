import 'package:flutter/widgets.dart';

import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// A widget that overlays a loading indicator on top of a child widget.
///
/// The [overlay] is the widget to overlay on top of the [child].
/// The [child] is the widget to overlay the [overlay] on top of.
/// The [isLoading] is the flag to show the [overlay].
///
/// Example:
/// ```dart
/// AppOverlayLoading(
///   overlay: const AppCircularLoading(),
///   child: const Text('Hello'),
///   isLoading: true,
/// );
/// ```
final class AppOverlayLoading extends StatelessWidget {
  const AppOverlayLoading({
    required this.overlay,
    required this.child,
    required this.isLoading,
    super.key,
  });

  /// The overlay widget.
  final Widget overlay;

  /// The child widget.
  final Widget child;

  /// Whether to show the overlay.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    // O scrim faz cross-fade ao entrar/sair; fora do loading não intercepta
    // ponteiro. Respeita reduce-motion via AppCrossFade.
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !isLoading,
            child: AppCrossFade(
              child: isLoading
                  ? DecoratedBox(
                      key: const ValueKey('overlay'),
                      decoration: BoxDecoration(
                        color: theme.colorTheme.onSurface.barrier(),
                      ),
                      child: overlay,
                    )
                  : const SizedBox.shrink(key: ValueKey('none')),
            ),
          ),
        ),
      ],
    );
  }
}
