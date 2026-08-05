// O catálogo é bilíngue, e "bilíngue" tem de ser uma propriedade verificada.
//
// O tipo já garante metade: `LocalizedText` exige `en` e `pt`, então nenhum
// componente entra no catálogo sem os dois campos. O que o tipo NÃO pega é o
// atalho — preencher `en` com o texto português e seguir. O resultado passa em
// tudo, gera as 129 rotas em inglês do site e publica português nelas.
//
// A checagem por acento é a mesma heurística que o gate do Widgetbook usa
// (`tool/widgetbook_conventions.dart`), pela mesma razão: é barata e pega o
// caso real. Aqui ela ganha um segundo eixo — texto longo IDÊNTICO nos dois
// idiomas —, porque a frase que escapou da tradução costuma escapar inteira, e
// nem todo português tem acento ("desabilitado" passou por dois filtros meus
// antes deste teste existir).
//
// `states` e `variants` não são bilíngues — nomeiam superfície de API, e o
// vocabulário dessa camada é inglês em todo o pacote, do Widgetbook ao nome da
// prop. Eles são cobrados por ALLOW-LIST, não por heurística: a heurística
// falhou no canário (`repouso` não tem acento), e token de estado é curto e
// sem acento por natureza. Ver `catalog_vocabulary.dart`.
import 'package:flocks/meta.dart';
import 'package:flutter_test/flutter_test.dart';

import 'catalog_vocabulary.dart';

/// Caracteres que só existem em português.
final RegExp _accented = RegExp('[ãáâàéêíóôõúçÃÁÂÉÊÍÓÔÕÚÇ]');

/// Palavras funcionais de português que não são palavras de inglês.
///
/// Curta de propósito: cada entrada aqui é um falso positivo em potencial num
/// texto técnico em inglês, e um gate que grita à toa é um gate que se aprende
/// a ignorar.
final RegExp _ptWords = RegExp(
  r'\b(nao|uma|para|quando|pelo|pela|dos|das|isso|esse|essa|com o|com a)\b',
  caseSensitive: false,
);

/// Acima deste tamanho, `en` idêntico a `pt` é tradução esquecida, não
/// coincidência: "Chat", "Query" e "0..1" são iguais nos dois idiomas de
/// verdade, uma frase inteira não é.
const int _identicalTextLimit = 40;

/// Todo texto localizado do catálogo, com um caminho que nomeia a origem.
List<({String path, LocalizedText text})> _texts() {
  final List<({String path, LocalizedText text})> out =
      <({String path, LocalizedText text})>[];
  for (final AppComponentMeta m in flocksCatalog) {
    void add(String field, LocalizedText? t) {
      if (t != null) out.add((path: '${m.id}.$field', text: t));
    }

    add('summary', m.summary);
    add('description', m.description);
    add('a11y', m.a11y);
    for (final PropMeta p in m.props) {
      add('props[${p.name}].description', p.description);
    }
    for (int i = 0; i < m.examples.length; i++) {
      add('examples[$i].title', m.examples[i].title);
      add('examples[$i].description', m.examples[i].description);
    }
  }
  return out;
}

/// Toda lista localizada do catálogo.
List<({String path, LocalizedList list})> _lists() =>
    <({String path, LocalizedList list})>[
      for (final AppComponentMeta m
          in flocksCatalog) ...<({String path, LocalizedList list})>[
        (path: '${m.id}.whenToUse', list: m.whenToUse),
        (path: '${m.id}.whenNotToUse', list: m.whenNotToUse),
        (path: '${m.id}.dos', list: m.dos),
        (path: '${m.id}.donts', list: m.donts),
      ],
    ];

void main() {
  group('o lado inglês do catálogo é inglês', () {
    test('nenhum campo `en` carrega marca de português', () {
      final List<String> offenders = <String>[
        for (final ({String path, LocalizedText text}) t in _texts())
          if (_accented.hasMatch(t.text.en) || _ptWords.hasMatch(t.text.en))
            '${t.path}: "${t.text.en}"',
        for (final ({String path, LocalizedList list}) l in _lists())
          for (final String bullet in l.list.en)
            if (_accented.hasMatch(bullet) || _ptWords.hasMatch(bullet))
              '${l.path}: "$bullet"',
      ];
      expect(
        offenders,
        isEmpty,
        reason:
            'Estes campos `en` ficaram em português. O site publica o lado '
            '`en` nas rotas /en/ — o que sobrar aqui vira português no ar:\n'
            '${offenders.join('\n')}',
      );
    });

    test('nenhum texto longo ficou idêntico nos dois idiomas', () {
      final List<String> offenders = <String>[
        for (final ({String path, LocalizedText text}) t in _texts())
          if (t.text.en.length > _identicalTextLimit && t.text.en == t.text.pt)
            '${t.path}: "${t.text.en}"',
      ];
      expect(
        offenders,
        isEmpty,
        reason:
            'Texto longo igual nos dois idiomas é tradução que não aconteceu '
            '(português sem acento passa pela outra checagem):\n'
            '${offenders.join('\n')}',
      );
    });
  });

  group('os dois idiomas cobrem o mesmo terreno', () {
    test('nenhum campo de texto está vazio', () {
      final List<String> offenders = <String>[
        for (final ({String path, LocalizedText text}) t in _texts())
          if (t.text.en.trim().isEmpty || t.text.pt.trim().isEmpty) t.path,
      ];
      expect(offenders, isEmpty, reason: 'Campos vazios: $offenders');
    });

    test('nenhuma lista existe num idioma e falta no outro', () {
      // O recorte pode diferir — três marcadores em PT podem virar dois em EN
      // quando uma distinção não existe para aquele leitor. O que não pode é um
      // lado sumir: é exatamente o caso que quebra o `hreflang` recíproco do
      // site (INV-009), que falha o build quando uma rota existe num idioma e
      // não no outro.
      final List<String> offenders = <String>[
        for (final ({String path, LocalizedList list}) l in _lists())
          if (l.list.en.isEmpty != l.list.pt.isEmpty)
            '${l.path} (en: ${l.list.en.length}, pt: ${l.list.pt.length})',
      ];
      expect(
        offenders,
        isEmpty,
        reason:
            'Lista presente num idioma e ausente no outro:\n'
            '${offenders.join('\n')}',
      );
    });
  });

  group('o vocabulário de API é inglês', () {
    test('todo `states`/`variants` está no vocabulário declarado', () {
      final List<String> offenders = <String>[
        for (final AppComponentMeta m in flocksCatalog) ...<String>[
          for (final String s in m.states)
            if (!kComponentStates.contains(s)) '${m.id}.states: "$s"',
          for (final String v in m.variants)
            if (!kComponentVariants.contains(v)) '${m.id}.variants: "$v"',
        ],
      ];
      expect(
        offenders,
        isEmpty,
        reason:
            'Valor fora do vocabulário. Estes campos nomeiam superfície de API '
            'e saem como estão nas rotas PT e EN do site — escreva o valor em '
            'inglês e declare-o em `catalog_vocabulary.dart`:\n'
            '${offenders.join('\n')}',
      );
    });

    test('o vocabulário declarado não acumula valor morto', () {
      // Uma allow-list que só cresce deixa de ser revisável. Se um estado saiu
      // do catálogo, ele sai daqui no mesmo commit.
      final Set<String> used = <String>{
        for (final AppComponentMeta m in flocksCatalog) ...m.states,
      };
      final Set<String> usedVariants = <String>{
        for (final AppComponentMeta m in flocksCatalog) ...m.variants,
      };
      expect(
        kComponentStates.difference(used),
        isEmpty,
        reason: 'Estados declarados que nenhum componente usa.',
      );
      expect(
        kComponentVariants.difference(usedVariants),
        isEmpty,
        reason: 'Variações declaradas que nenhum componente usa.',
      );
    });
  });
}
