@Tags(<String>['golden'])
library;

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// O fallback do AppAvatar é neutro por design (não usa o acento de marca), logo
// a variação relevante é só {claro,escuro}. Golden cobre o fallback-texto em três
// tamanhos; o fallback-ícone e a imagem de rede não entram aqui (bateriam na rede
// via AppIcon/cache_manager) — ficam cobertos pelos widget tests.
void main() {
  for (final bool dark in <bool>[false, true]) {
    final String label = dark ? 'dark' : 'light';

    testWidgets('Avatar fallback golden · $label', (tester) async {
      final AppThemeData data = AppThemeData.forBrand(jotapeBrand, dark: dark);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: AppTheme(
              data: data,
              child: Container(
                key: const Key('golden'),
                color: data.colorTheme.surface,
                padding: const EdgeInsets.all(24),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 16,
                  children: [
                    AppAvatar(size: AppAvatarSize.s, fallback: 'JP'),
                    AppAvatar(size: AppAvatarSize.m, fallback: 'AB'),
                    AppAvatar(size: AppAvatarSize.l, fallback: 'CD'),
                    AppAvatar(size: AppAvatarSize.xl, fallback: 'EF'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byKey(const Key('golden')),
        matchesGoldenFile('goldens/avatar_$label.png'),
      );
    });
  }
}
