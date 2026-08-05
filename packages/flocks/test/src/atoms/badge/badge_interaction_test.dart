import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Color onSurface = Color(0xFF000000);

  BadgeInteraction resolve(
    Set<WidgetState> states, {
    AppBadgeEffect effect = AppBadgeEffect.scale,
    bool isDark = false,
    bool motionEnabled = true,
  }) => resolveBadgeInteraction(
    states: states,
    effect: effect,
    onSurface: onSurface,
    isDark: isDark,
    motionEnabled: motionEnabled,
  );

  group('resolveBadgeInteraction · escala', () {
    test('neutral → 1.0, sem overlay, sem sombra', () {
      final v = resolve(<WidgetState>{});
      expect(v.scale, 1.0);
      expect(v.overlay, isNull);
      expect(v.liftShadow, isNull);
    });

    test('effect none → 1.0 mesmo em hover/press', () {
      expect(
        resolve(<WidgetState>{
          WidgetState.pressed,
        }, effect: AppBadgeEffect.none).scale,
        1.0,
      );
      expect(
        resolve(<WidgetState>{
          WidgetState.hovered,
        }, effect: AppBadgeEffect.none).scale,
        1.0,
      );
    });

    test('effect scale → 0.94 no press', () {
      expect(resolve(<WidgetState>{WidgetState.pressed}).scale, 0.94);
      expect(resolve(<WidgetState>{WidgetState.hovered}).scale, 1.0);
    });

    test('effect lift → 1.06 no hover / 1.02 no press', () {
      expect(
        resolve(<WidgetState>{
          WidgetState.hovered,
        }, effect: AppBadgeEffect.lift).scale,
        1.06,
      );
      expect(
        resolve(<WidgetState>{
          WidgetState.pressed,
        }, effect: AppBadgeEffect.lift).scale,
        1.02,
      );
    });

    test('dragged → 1.08 vence qualquer effect', () {
      for (final effect in AppBadgeEffect.values) {
        expect(
          resolve(<WidgetState>{WidgetState.dragged}, effect: effect).scale,
          1.08,
        );
      }
    });

    test('animações off → escala sempre 1.0 (movimento suprimido)', () {
      expect(
        resolve(<WidgetState>{WidgetState.pressed}, motionEnabled: false).scale,
        1.0,
      );
      expect(
        resolve(
          <WidgetState>{WidgetState.hovered},
          effect: AppBadgeEffect.lift,
          motionEnabled: false,
        ).scale,
        1.0,
      );
      expect(
        resolve(<WidgetState>{WidgetState.dragged}, motionEnabled: false).scale,
        1.0,
      );
    });

    test('animações off → overlay e liftShadow (estados) permanecem', () {
      final v = resolve(<WidgetState>{
        WidgetState.dragged,
      }, motionEnabled: false);
      expect(v.scale, 1.0);
      expect(v.overlay, onSurface.withValues(alpha: 0.10));
      expect(v.liftShadow, AppElevation.symmetricShadows(false));
    });
  });

  group('resolveBadgeInteraction · overlay (escada de prioridade única)', () {
    test('pressed → 0.12', () {
      expect(
        resolve(<WidgetState>{WidgetState.pressed}).overlay,
        onSurface.withValues(alpha: 0.12),
      );
    });

    test('dragged (sem press) → 0.10', () {
      expect(
        resolve(<WidgetState>{WidgetState.dragged}).overlay,
        onSurface.withValues(alpha: 0.10),
      );
    });

    test('hovered → 0.08; focused → 0.08', () {
      expect(
        resolve(<WidgetState>{WidgetState.hovered}).overlay,
        onSurface.withValues(alpha: 0.08),
      );
      expect(
        resolve(<WidgetState>{WidgetState.focused}).overlay,
        onSurface.withValues(alpha: 0.08),
      );
    });

    test('hovered + focused → 0.08 (não soma)', () {
      expect(
        resolve(<WidgetState>{
          WidgetState.hovered,
          WidgetState.focused,
        }).overlay,
        onSurface.withValues(alpha: 0.08),
      );
    });

    test('pressed vence dragged no overlay', () {
      expect(
        resolve(<WidgetState>{
          WidgetState.pressed,
          WidgetState.dragged,
        }).overlay,
        onSurface.withValues(alpha: 0.12),
      );
    });

    test('neutral → null', () {
      expect(resolve(<WidgetState>{}).overlay, isNull);
    });
  });

  group('resolveBadgeInteraction · liftShadow', () {
    test('só em dragged, == AppElevation.symmetricShadows(isDark)', () {
      expect(resolve(<WidgetState>{}).liftShadow, isNull);
      expect(resolve(<WidgetState>{WidgetState.hovered}).liftShadow, isNull);
      expect(
        resolve(<WidgetState>{WidgetState.dragged}).liftShadow,
        AppElevation.symmetricShadows(false),
      );
      expect(
        resolve(<WidgetState>{WidgetState.dragged}, isDark: true).liftShadow,
        AppElevation.symmetricShadows(true),
      );
    });
  });
}
