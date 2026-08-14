import 'package:flocks/flocks.dart';
import 'package:flocks/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {TextScaler textScaler = TextScaler.noScaling}) =>
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(textScaler: textScaler),
        child: AppTheme(
          data: AppThemeData.light,
          child: Center(child: child),
        ),
      ),
    );

void main() {
  group('fallbackIcon', () {
    testWidgets('default continua o glifo de user', (tester) async {
      await tester.pumpWidget(_host(const AppAvatar()));
      final AppIcon icon = tester.widget<AppIcon>(find.byType(AppIcon));
      expect(icon.icon, AppIconToken.user);
    });

    testWidgets('slug custom aparece nos DOIS construtores', (tester) async {
      await tester.pumpWidget(
        _host(const AppAvatar(fallbackIcon: AppIconToken.attachment)),
      );
      expect(
        tester.widget<AppIcon>(find.byType(AppIcon)).icon,
        AppIconToken.attachment,
      );

      await tester.pumpWidget(
        _host(
          const AppAvatar.custom(
            diameter: 64,
            fallbackIcon: AppIconToken.attachment,
          ),
        ),
      );
      expect(
        tester.widget<AppIcon>(find.byType(AppIcon)).icon,
        AppIconToken.attachment,
      );
    });

    testWidgets('o texto de fallback vence o ícone', (tester) async {
      await tester.pumpWidget(
        _host(
          const AppAvatar(fallback: 'JP', fallbackIcon: AppIconToken.clock),
        ),
      );
      expect(find.byType(AppIcon), findsNothing);
      expect(find.text('JP'), findsOneWidget);
    });
  });

  group('AppAvatar', () {
    testWidgets('sem imagem e com fallback → mostra o texto', (tester) async {
      await tester.pumpWidget(
        _host(const AppAvatar(size: AppAvatarSize.l, fallback: 'JP')),
      );
      expect(find.text('JP'), findsOneWidget);
    });

    testWidgets('sem imagem e sem fallback → mostra o ícone de usuário', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const AppAvatar(size: AppAvatarSize.l)));
      expect(find.byType(AppIcon), findsOneWidget);
      expect(find.byType(AppText), findsNothing);
    });

    testWidgets('semanticLabel expõe imagem rotulada', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          const AppAvatar(
            size: AppAvatarSize.l,
            fallback: 'JP',
            semanticLabel: 'João',
          ),
        ),
      );
      expect(find.bySemanticsLabel('João'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('sem semanticLabel → usa o texto do fallback como rótulo', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(const AppAvatar(size: AppAvatarSize.l, fallback: 'JP')),
      );
      expect(find.bySemanticsLabel('JP'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('sem label e sem fallback → rótulo default "Avatar"', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_host(const AppAvatar(size: AppAvatarSize.l)));
      expect(find.bySemanticsLabel('Avatar'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('semanticLabel tem prioridade sobre o fallback', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          const AppAvatar(
            size: AppAvatarSize.l,
            fallback: 'JP',
            semanticLabel: 'João',
          ),
        ),
      );
      expect(find.bySemanticsLabel('João'), findsOneWidget);
      expect(find.bySemanticsLabel('JP'), findsNothing);
      handle.dispose();
    });

    testWidgets('clicável: tocar no texto do fallback dispara o onTap', (
      tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        _host(
          AppAvatar(size: AppAvatarSize.l, fallback: 'JP', onTap: () => taps++),
        ),
      );
      await tester.tap(find.text('JP'));
      expect(taps, 1);
    });
  });

  group('AppAvatar · sizing', () {
    testWidgets('size nomeado deriva o diâmetro (baseDiameter em escala 1.0)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppAvatar(size: AppAvatarSize.m, fallback: 'JP')),
      );
      expect(tester.getSize(find.byType(AppAvatar)).width, 48);
    });

    testWidgets('a casca cresce com o text-scale (padding fixo)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppAvatar(size: AppAvatarSize.m, fallback: 'JP'),
          textScaler: const TextScaler.linear(2.0),
        ),
      );
      // scaler.scale(24) + 2*12 = 48 + 24 = 72
      expect(tester.getSize(find.byType(AppAvatar)).width, 72);
    });

    testWidgets('.custom mantém a caixa fixa mesmo sob text-scale', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AppAvatar.custom(diameter: 120, fallback: 'JP'),
          textScaler: const TextScaler.linear(2.0),
        ),
      );
      expect(tester.getSize(find.byType(AppAvatar)).width, 120);
    });

    testWidgets('.custom com fallback longo usa FittedBox (sem overflow)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const AppAvatar.custom(diameter: 24, fallback: 'WWWW')),
      );
      expect(find.byType(FittedBox), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'outlined: a borda não insere o conteúdo (Container sem borda + overlay)',
      (tester) async {
        await tester.pumpWidget(
          _host(
            const AppAvatar(
              size: AppAvatarSize.m,
              fallback: 'JP',
              style: AppStyle.outlined,
            ),
          ),
        );
        // O tamanho do componente não muda com a borda.
        expect(tester.getSize(find.byType(AppAvatar)).width, 48);
        // A casca (Container) NÃO tem borda → não insere (não encolhe o texto);
        // a borda é desenhada por cima (DecoratedBox foreground).
        final container = tester.widget<Container>(find.byType(Container));
        expect((container.decoration! as BoxDecoration).border, isNull);
        final hasForegroundBorder = tester
            .widgetList<DecoratedBox>(find.byType(DecoratedBox))
            .any(
              (d) =>
                  d.position == DecorationPosition.foreground &&
                  (d.decoration as BoxDecoration).border != null,
            );
        expect(hasForegroundBorder, isTrue);
      },
    );
  });

  group('AppAvatar · estados (statesController)', () {
    testWidgets('neutral clicável → sem overlay e sem sombra', (tester) async {
      final controller = FlocksStatesController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          AppAvatar(
            size: AppAvatarSize.l,
            fallback: 'JP',
            onTap: () {},
            statesController: controller,
          ),
        ),
      );
      expect(find.byType(ColoredBox), findsNothing);
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect((container.decoration! as BoxDecoration).boxShadow, isNull);
    });

    testWidgets('pressed → overlay presente', (tester) async {
      final controller = FlocksStatesController(<WidgetState>{
        WidgetState.pressed,
      });
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          AppAvatar(
            size: AppAvatarSize.l,
            fallback: 'JP',
            onTap: () {},
            statesController: controller,
          ),
        ),
      );
      expect(find.byType(ColoredBox), findsWidgets);
    });

    testWidgets('dragged → sombra de lift + escala 1.08', (tester) async {
      final controller = FlocksStatesController(<WidgetState>{
        WidgetState.dragged,
      });
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          AppAvatar(
            size: AppAvatarSize.l,
            fallback: 'JP',
            onTap: () {},
            statesController: controller,
          ),
        ),
      );
      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect((container.decoration! as BoxDecoration).boxShadow, isNotNull);
      final scaled = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(scaled.scale, 1.08);
    });

    testWidgets(
      'reduce-motion: mantém a sombra de lift (estado), sem a escala (movimento)',
      (tester) async {
        final controller = FlocksStatesController(<WidgetState>{
          WidgetState.dragged,
        });
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: AppTheme(
                data: AppThemeData.light,
                child: Center(
                  child: AppAvatar(
                    size: AppAvatarSize.l,
                    fallback: 'JP',
                    onTap: () {},
                    statesController: controller,
                  ),
                ),
              ),
            ),
          ),
        );
        // A sombra (estado) permanece; a escala (movimento) é suprimida.
        final container = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        expect((container.decoration! as BoxDecoration).boxShadow, isNotNull);
        final scaled = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
        expect(scaled.scale, 1.0);
      },
    );
  });

  test('avatar no catálogo como migrado', () {
    expect(
      flocksCatalog.any(
        (m) => m.id == 'app_avatar' && m.status == ComponentStatus.migrated,
      ),
      isTrue,
    );
  });
}
