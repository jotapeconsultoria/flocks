// As duas invariantes do contrato de estado.
//
// 1. Parâmetro inválido cai no padrão, EM SILÊNCIO. Um link de demo é copiado,
//    truncado por aplicativo de mensagem, editado à mão e colado torto — e a
//    demo que responde a isso com uma tela de erro é uma demo que o visitante
//    nunca chega a ver.
// 2. Nenhum parâmetro carrega o logo.
import 'package:flocks/flocks.dart';
import 'package:flocks_demo/src/state/demo_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

DemoConfig parse(String query) =>
    DemoConfig.fromUri(Uri.parse('https://flocks.live/demo/?$query'));

void main() {
  group('o padrão', () {
    test('uma URL sem query nenhuma é a configuração padrão', () {
      expect(
        DemoConfig.fromUri(Uri.parse('https://flocks.live/demo/')),
        const DemoConfig(),
      );
    });

    test('e os padrões são os do contrato', () {
      const DemoConfig c = DemoConfig();
      expect(c.seedHex, '4F46E5');
      expect(c.style, AppStyle.filled);
      expect(c.radius, AppRadiusMode.padrao);
      expect(c.font, DemoFont.poppins);
      expect(c.dark, isFalse);
      expect(c.screen, DemoScreen.dashboard);
    });
  });

  group('invariante 1: lixo cai no padrão, sem lançar', () {
    // Cada linha é um parâmetro corrompido de um jeito plausível. Nenhuma pode
    // levantar, e todas têm de devolver o padrão DAQUELE campo.
    const Map<String, String> garbage = <String, String>{
      'seed=zzz': 'hex que não é hex',
      'seed=': 'vazio',
      'seed=12345': 'curto demais',
      'seed=1234567890': 'longo demais',
      'seed=%23%23%23': 'só símbolos',
      'style=material': 'um valor de outro design system',
      'style=FILLED': 'caixa errada',
      'radius=-1': 'número onde vai nome',
      'radius=rounded': 'o nome em inglês, e o enum é em português',
      'font=Comic%20Sans': 'fonte fora do catálogo fechado',
      'font=poppins': 'o nome do enum, e o contrato pede o da família',
      'dark=maybe': 'booleano que não é 0 nem 1',
      'dark=true': 'a outra grafia de booleano',
      'screen=../../etc/passwd': 'travessia de caminho',
      'screen=': 'vazio',
    };

    garbage.forEach((String query, String why) {
      test('$query ($why)', () {
        late DemoConfig config;
        expect(() => config = parse(query), returnsNormally);
        // O campo corrompido caiu no padrão, e o resto continua padrão também.
        expect(config, const DemoConfig(), reason: 'devia ter caído no padrão');
      });
    });

    test('uma query inteira de lixo ainda dá uma tela em pé', () {
      expect(
        parse('seed=&style=&radius=&font=&dark=&screen=&bogus=1&=2'),
        const DemoConfig(),
      );
    });

    test('um parâmetro bom sobrevive ao lixo do lado', () {
      // Cada campo é lido isoladamente: um `style` corrompido não contamina o
      // `seed` que veio bom. É o que faz um link meio quebrado continuar
      // valendo pela parte que sobreviveu.
      final DemoConfig config = parse('seed=16A34A&style=bogus&screen=crud');
      expect(config.seedHex, '16A34A');
      expect(config.style, AppStyle.filled);
      expect(config.screen, DemoScreen.crud);
    });

    test('parâmetro desconhecido é ignorado', () {
      expect(parse('utm_source=twitter&fbclid=abc'), const DemoConfig());
    });
  });

  group('os valores válidos, todos eles', () {
    for (final AppStyle style in AppStyle.values) {
      test('style=${style.name}', () {
        expect(parse('style=${style.name}').style, style);
      });
    }
    for (final AppRadiusMode radius in AppRadiusMode.values) {
      test('radius=${radius.name}', () {
        expect(parse('radius=${radius.name}').radius, radius);
      });
    }
    for (final DemoFont font in DemoFont.values) {
      test('font=${font.family}', () {
        expect(parse('font=${font.family}').font, font);
      });
    }
    for (final DemoScreen screen in DemoScreen.values) {
      test('screen=${screen.name}', () {
        expect(parse('screen=${screen.name}').screen, screen);
      });
    }
    test('dark=1', () => expect(parse('dark=1').dark, isTrue));
    test('dark=0', () => expect(parse('dark=0').dark, isFalse));

    test('o hex aceita # e 8 dígitos, e sai sempre opaco', () {
      expect(parse('seed=%2316A34A').seedHex, '16A34A');
      expect(parse('seed=FF16A34A').seedHex, '16A34A');
      expect(parse('seed=0016A34A').seed.a, 1.0);
    });
  });

  group('ida e volta', () {
    test('toUri e fromUri se fecham em cima de qualquer configuração', () {
      const List<DemoConfig> configs = <DemoConfig>[
        DemoConfig(),
        DemoConfig(
          seed: Color(0xFF16A34A),
          style: AppStyle.outlined,
          radius: AppRadiusMode.circular,
          font: DemoFont.spaceGrotesk,
          dark: true,
          screen: DemoScreen.crud,
        ),
        DemoConfig(seed: Color(0xFF000000), radius: AppRadiusMode.reto),
      ];
      for (final DemoConfig config in configs) {
        expect(DemoConfig.fromUri(config.toUri()), config);
      }
    });

    test('a URL emite os seis campos, mesmo os que estão no padrão', () {
      // Um link precisa ser imune ao dia em que o padrão da demo mudar: o que o
      // visitante viu tem de continuar sendo o que o destinatário vê.
      expect(const DemoConfig().toQueryParameters().keys.toSet(), <String>{
        'seed',
        'style',
        'radius',
        'font',
        'dark',
        'screen',
      });
    });
  });

  group('invariante 2: nada aqui alcança o logo', () {
    test(
      'a configuração não tem campo de imagem, e a URL não tem como levar',
      () {
        const DemoConfig config = DemoConfig(seed: Color(0xFF16A34A));
        final String url = config.toUri().toString();
        expect(url, isNot(contains('logo')));
        expect(url, isNot(contains('data:')));
        expect(url, isNot(contains('blob:')));
        // Seis chaves, e nenhuma delas é o logo. Não é uma promessa: `toUri` não
        // recebe o objeto do logo, então não há o que vazar.
        expect(config.toQueryParameters().length, 6);
      },
    );
  });
}
