// Lockstep e CHANGELOG são promessa escrita em prosa — e prosa não reprova PR.
//
// Nenhum `.dart` deste repo lia CHANGELOG e nenhum job do CI citava a palavra.
// O único guardião era o aviso do `dart pub publish`: ele reclama se a versão
// nova não aparece no arquivo, e só. Não confere data, não confere ordem, e não
// roda em PR. Do outro lado, o único gate de `version:` morava no job
// `mcpb-release`, que acorda em TAG — isto é, depois de o erro já estar na main.
//
// O buraco cobrou em 24 horas. O `flocks_mcp` ficou em 0.1.1 enquanto os outros
// três foram para a 0.1.2, e quem pegou foi auditoria manual (PR #18). E cinco
// seções de CHANGELOG datavam versões não publicadas, três delas datando a
// 0.1.0 em 2026-08-05 quando ela saiu no dia 10 (PR #19). São dois defeitos de
// release que nenhum teste podia ver porque nenhum teste olhava.
//
// Este gate olha, offline, em todo PR. A pergunta que precisa de rede — "a data
// da seção é a data em que o pub.dev recebeu a versão?" — não está aqui de
// propósito: ela é job de CI (`changelog (pub.dev)` no ci.yml), pela mesma
// razão que o `snippet (hosted)` é job e não teste. Uma suíte que fala com a
// rede reprova por API fora do ar, que é outra coisa que defeito no repo.
//
// A regra de lockstep NÃO é lista literal de pacotes: ela é lida da prosa dos
// pubspecs. Quem declara lockstep fica na versão do core; quem declara que a
// linha pública dele começa ATRÁS do core, porque estreou depois, fica na
// versão que a própria frase diz. A isenção tem prazo, e o prazo é cobrado por
// dois gates que se somam: a prosa cita a versão do core, e a citação é
// conferida contra a versão de verdade; e a estreia tem de ser datada no dia do
// release do core que ela cita. No primeiro bump do core os dois reprovam, e a
// única saída é entrar no número — o lockstep estrito passa a valer sozinho. É
// o mesmo princípio dos outros gates deste repo: o número não pode envelhecer
// em silêncio.
//
// POR QUE `test/release/`, E NÃO `test/architecture/`. O lugar óbvio seria lá:
// é onde moram os gates que julgam o repositório em vez do widget, e é de lá
// que veio o helper de raiz de workspace. Mas o README conta os arquivos
// daquele diretório para sustentar uma frase específica — "N suites in
// `test/architecture/` that sweep the code", a prova de que o zero-Material não
// é intenção — e a contagem tem gate (`catalog_freshness_test`). O N vai sem
// número aqui de propósito: escrito, ele envelhece a cada suíte nova, e nenhum
// gate alcança número dentro de comentário. Este já envelheceu duas vezes — na
// #29 e no merge da mono — antes de alguém notar. Este arquivo
// não varre `lib/src`; ele varre pubspec e CHANGELOG. Entrar naquela conta
// inflaria a prova com um gate que não prova aquilo, e ainda arrastaria o
// README e as duas homes do site para acertar o número. O diretório novo diz o
// que o arquivo é, e roda no mesmo `flutter test` do job `checks` — que varre
// `test/` inteiro.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// O pacote que os outros seguem. Referência do lockstep, e não participante.
const String kNomeDoCore = 'flocks';

/// A promessa que põe um pacote sob lockstep. Curta de propósito: é a âncora
/// do gate, não a frase inteira — o pubspec de cada um continua a explicar o
/// porquê com as palavras dele.
const String kMarcaDeLockstep = 'Em lockstep com o core';

/// A cláusula que isenta quem estreou atrás do core, e a versão da estreia.
///
/// A versão sai da CAPTURA, não de um literal aqui: `flocks_cupertino` e
/// `flocks_lucide` estão em 0.1.0 de propósito, e é o pubspec deles que diz
/// isso. Uma lista de exceções neste arquivo seria a mesma promessa em prosa
/// que este gate existe para substituir, só que mais longe do pubspec.
///
/// Ela é PREFIXO da redação que os dois carregavam antes de estrear — "…começa
/// em 0.1.0 porque ele nunca foi publicado" —, e isso é de propósito: um pacote
/// que de fato nunca publicou escreve a frase inteira, continua isento aqui, e
/// o ramo de 404 do job `changelog (pub.dev)` segue achando a fatia "nunca foi
/// publicado" que ele grepa (`ci.yml`). O que saiu da regex foi só o pedaço que
/// a estreia tornou falso: os dois estão no pub.dev desde 2026-08-12, e o outro
/// ramo daquele job reprova pacote publicado que ainda declare o contrário.
final RegExp kClausulaDeEstreia = RegExp(
  r'A linha pública deste pacote começa em (\d+\.\d+\.\d+)',
);

/// A frase que cita a versão do core de dentro de outro pubspec.
///
/// Ela é exatamente o tipo de número que apodrece calado — foi escrita quando o
/// core estava numa versão e nada a obriga a acompanhar a seguinte. Sob gate,
/// deixa de ser risco e passa a ser fato conferido.
final RegExp kCitacaoDoCore = RegExp(r'o `flocks` já está em (\d+\.\d+\.\d+)');

/// Um cabeçalho de seção do CHANGELOG, no formato que os seis arquivos usam.
///
/// Estrito de propósito. `## [0.1.2] - 11/08/2026` não casa e o gate diz o que
/// leu, em vez de aceitar uma data que ninguém consegue ordenar. Pré-lançamento
/// (`0.2.0-dev.1`) também não casa: esta linha de versão nunca teve um, e um
/// gate que fingisse conhecê-lo ordenaria errado. Se a linha ganhar um, ensine
/// este arquivo — não afrouxe o formato.
final RegExp kCabecalhoDeSecao = RegExp(
  r'^\[(\d+\.\d+\.\d+)\](?: - (\d{4}-\d{2}-\d{2}))?$',
);

/// O balde do ciclo em curso: `## [Unreleased]`, sem data.
///
/// A recusa original a este cabeçalho partia de "os seis arquivos bumpam
/// pubspec e CHANGELOG no mesmo commit" — verdade no dia do corte, mas o
/// ciclo 0.2.0 acumula PRs de feature ANTES do corte, e cada um precisa de
/// uma linha de CHANGELOG que ainda não tem versão para chamar de sua.
/// A convenção mudou aqui, à vista: entre cortes existe NO MÁXIMO UM
/// `[Unreleased]`, sempre no topo; o PR de release o carimba em
/// `[X.Y.Z] - AAAA-MM-DD` junto com o bump do pubspec. Ele fica fora de
/// `secoes` de propósito — os gates de versão, data e ordem seguem medindo só
/// a linha publicada.
final RegExp kCabecalhoUnreleased = RegExp(r'^\[Unreleased\]$');

void main() {
  final Directory? raizDoRepo = _acharRaizDeWorkspace();
  final Directory? raizDoGit = _acharRaizDeGit();

  /// A razão do skip, ou `null` quando os gates têm de morder de verdade.
  ///
  /// Materializada em `skip:`, que o runner IMPRIME, e não em `return`, que sai
  /// verde e calado — o mesmo idioma do `install_docs_test`, e pela mesma
  /// razão: vacuidade que se vê não é vacuidade.
  final String? foraDoRepo = raizDoRepo == null
      ? 'sem raiz de workspace acima do cwd — checkout do tarball do pub.dev, '
            'onde os outros pacotes não existem'
      : null;

  test('a âncora de repo não apodreceu (canário deste arquivo)', () {
    // Numa direção só, como o canário gêmeo do `install_docs_test`: se há
    // checkout git acima, a raiz de workspace TEM de ter sido achada, e no
    // mesmo lugar. O zip do GitHub não tem `.git` e continua sendo checkout
    // legítimo, então a inversa não vale.
    if (raizDoGit == null) {
      return;
    }
    expect(
      raizDoRepo?.path,
      raizDoGit.path,
      reason:
          'Há um checkout git em ${raizDoGit.path}, mas a raiz de workspace '
          'não foi achada ali (achei: ${raizDoRepo?.path}). Este arquivo '
          'inteiro estaria pulando em silêncio. Conserte '
          '`_acharRaizDeWorkspace` — não o skip.',
    );
  });

  final List<_Pacote> publicaveis = raizDoRepo == null
      ? const <_Pacote>[]
      : _varrerPublicaveis(raizDoRepo);

  group('release', () {
    test('o inventário de pacotes publicáveis não é vazio', () {
      // O primeiro gate é contra o conjunto vazio: todos os que vêm abaixo
      // iteram sobre esta lista, e com zero elementos passariam por
      // vacuidade. Se um dia o `workspace:` mudar de forma, é aqui que
      // aparece — e não em seis testes verdes que não olharam nada.
      expect(
        publicaveis.map((_Pacote p) => p.nome),
        contains(kNomeDoCore),
        reason:
            'Varri o `workspace:` da raiz e não achei o `$kNomeDoCore` entre '
            'os membros sem `publish_to: none`. Ou o core mudou de lugar, ou '
            '`_varrerPublicaveis` parou de entender o pubspec da raiz.',
      );
      expect(
        publicaveis.length,
        greaterThan(1),
        reason:
            'Só um pacote publicável no workspace. Nada para pôr em '
            'lockstep, e este arquivo inteiro viraria enfeite.',
      );
    });

    group('lockstep', () {
      test('todo pacote publicável declara a política de versão', () {
        // Sem isto, um adaptador novo entra calado e escapa do gate: não
        // declara lockstep, logo não é cobrado por ele. A obrigação aqui não
        // é "esteja em lockstep" — é "diga no seu pubspec o que você é".
        for (final _Pacote p in publicaveis) {
          if (p.nome == kNomeDoCore) {
            continue;
          }
          expect(
            p.prosa,
            contains(kMarcaDeLockstep),
            reason:
                'O `${p.nome}` é publicável e não diz "$kMarcaDeLockstep" '
                'em lugar nenhum do pubspec. Ou ele acompanha o core, e a '
                'frase entra; ou ele tem linha própria, e aí a exceção se '
                'escreve aqui, com o motivo — de propósito trabalhosa.',
          );
        }
      });

      test('quem declara lockstep está na versão do core', () {
        // A asserção que teria pego o PR #18: o `flocks_mcp` em 0.1.1
        // enquanto os outros três estavam em 0.1.2.
        final String versaoDoCore = _core(publicaveis).versao;
        for (final _Pacote p in publicaveis.where(
          (_Pacote p) => p.emLockstepEstrito,
        )) {
          expect(
            p.versao,
            versaoDoCore,
            reason:
                'O `${p.nome}` está em ${p.versao} e o core, em '
                '$versaoDoCore. O pubspec dele promete lockstep, e o número '
                'é a promessa. Se ele não devia mais acompanhar, é a prosa '
                'do pubspec que muda primeiro.',
          );
        }
      });

      test(
        'quem estreou atrás do core está na versão que a prosa dele diz',
        () {
          // `flocks_cupertino` e `flocks_lucide`, que estrearam em 0.1.0 no
          // release que levou o core a 0.1.2. A versão vem da frase, não de uma
          // lista aqui — e a frase tem prazo: os dois gates abaixo o cobram.
          final Iterable<_Pacote> estreantes = publicaveis.where(
            (_Pacote p) => p.estreiaEm != null,
          );
          for (final _Pacote p in estreantes) {
            expect(
              p.versao,
              p.estreiaEm,
              reason:
                  'O pubspec do `${p.nome}` diz que a linha pública dele '
                  'começa em ${p.estreiaEm}, e o `version:` diz ${p.versao}. '
                  'Os dois saem do mesmo arquivo e não podem discordar.',
            );
          }
        },
      );

      test('quem estreou atrás do core teve um release só', () {
        // O contrapeso da isenção. Uma linha pública que começa atrás do core
        // e um histórico de três releases não cabem no mesmo arquivo: o pacote
        // que lançou de novo sem alcançar o número do core não acompanha
        // ninguém, tem linha própria — e aí a cláusula é que está errada.
        for (final _Pacote p in publicaveis.where(
          (_Pacote p) => p.estreiaEm != null,
        )) {
          expect(
            p.secoes.map((_Secao s) => s.versao),
            hasLength(1),
            reason:
                'O `${p.nome}` diz que a linha pública dele começa em '
                '${p.estreiaEm}, atrás do core, e o CHANGELOG dele tem '
                '${p.secoes.length} seções. Se ele lançou de novo, tire a '
                'cláusula do pubspec — o lockstep estrito passa a valer e '
                'este gate cobra a versão do core.',
          );
        }
      });

      test('a prosa que cita a versão do core não envelheceu', () {
        final String versaoDoCore = _core(publicaveis).versao;
        for (final _Pacote p in publicaveis) {
          final RegExpMatch? citacao = kCitacaoDoCore.firstMatch(p.prosa);
          if (citacao == null) {
            continue;
          }
          expect(
            citacao.group(1),
            versaoDoCore,
            reason:
                'O pubspec do `${p.nome}` diz que o `$kNomeDoCore` já está '
                'em ${citacao.group(1)}, e ele está em $versaoDoCore. É o '
                'tipo de número que apodrece calado; agora não mais.',
          );
        }
      });

      test('quem estreou atrás do core estreou junto do release que cita', () {
        // A OUTRA METADE do prazo da isenção, e a razão de ela não ser um gate
        // só. O de cima cobra que a prosa cite a versão ATUAL do core; sozinho,
        // ele se satisfaz com um refresco do número citado, e a isenção
        // sobreviveria a qualquer bump com o pacote parado atrás. Aqui a
        // estreia tem de ser datada no dia da seção de topo do core — que é,
        // pelo gate de cima, exatamente o release que a prosa cita. Quando o
        // core lançar de novo, a data do topo dele muda, esta igualdade quebra,
        // e a saída é entrar no número do core.
        final _Secao topoDoCore = _core(publicaveis).secoes.first;
        for (final _Pacote p in publicaveis.where(
          (_Pacote p) => p.estreiaEm != null,
        )) {
          // As seções DATADAS, e não todas: seção sem data é marco interno
          // anterior à primeira publicação, e o gate de topo já cobra que a do
          // topo tenha data.
          expect(
            p.secoesPublicas,
            isNotEmpty,
            reason:
                'O `${p.nome}` declara estreia atrás do core e não tem nenhuma '
                'seção datada de CHANGELOG. Sem data não há como conferir que '
                'ele saiu junto do release do core que a prosa dele cita.',
          );
          expect(
            p.secoesPublicas.first.data,
            topoDoCore.data,
            reason:
                'A estreia do `${p.nome}` é datada '
                '${p.secoesPublicas.first.data} e a ${topoDoCore.versao} do '
                '`$kNomeDoCore`, ${topoDoCore.data}. A cláusula do pubspec '
                'dele isenta do lockstep quem estreou junto do release do '
                'core; se o core lançou depois disso, a isenção venceu — o '
                '`version:` dele passa a ser o do core, e a cláusula sai.',
          );
        }
      });
    });

    group('CHANGELOG', () {
      test('todo pacote publicável tem CHANGELOG com seção', () {
        for (final _Pacote p in publicaveis) {
          expect(
            p.changelog.existsSync(),
            isTrue,
            reason:
                'O `${p.nome}` é publicável e não tem CHANGELOG.md. O '
                'pub.dev conta 10 pontos por ele, e quem atualiza a '
                'dependência não tem outro lugar para olhar.',
          );
          expect(
            p.secoes,
            isNotEmpty,
            reason:
                'O CHANGELOG do `${p.nome}` não tem nenhuma seção '
                '`## [X.Y.Z]`. Os gates abaixo iteram sobre elas e passariam '
                'por vacuidade.',
          );
        }
      });

      test('todo cabeçalho `##` é uma seção de versão bem formada', () {
        // Duas formas, e só duas: `[X.Y.Z]( - data)` ou o balde único
        // `[Unreleased]` do ciclo em curso (ver kCabecalhoUnreleased — a
        // disciplina dele é o gate seguinte).
        for (final _Pacote p in publicaveis) {
          for (final _Cabecalho c in p.cabecalhos) {
            expect(
              kCabecalhoDeSecao.hasMatch(c.texto) ||
                  kCabecalhoUnreleased.hasMatch(c.texto),
              isTrue,
              reason:
                  '${p.nome}/CHANGELOG.md:${c.linha} — li `## ${c.texto}`. '
                  'O formato é `## [X.Y.Z] - AAAA-MM-DD` (data opcional '
                  'apenas nos marcos internos anteriores à primeira '
                  'publicação) ou o `## [Unreleased]` único do ciclo em '
                  'curso.',
            );
          }
        }
      });

      test('[Unreleased] é no máximo um, e mora no topo', () {
        // Sem esta disciplina o balde viraria porta de fuga: dois baldes, ou
        // um balde abaixo de uma versão datada, e a leitura "de cima é o mais
        // recente" quebra sem nenhum gate reclamar.
        for (final _Pacote p in publicaveis) {
          final List<_Cabecalho> baldes = p.cabecalhos
              .where((_Cabecalho c) => kCabecalhoUnreleased.hasMatch(c.texto))
              .toList();
          expect(
            baldes.length,
            lessThanOrEqualTo(1),
            reason:
                '${p.nome}/CHANGELOG.md tem ${baldes.length} seções '
                '`[Unreleased]`. O ciclo em curso é um só — funda os baldes.',
          );
          if (baldes.isNotEmpty) {
            expect(
              p.cabecalhos.first.texto,
              baldes.first.texto,
              reason:
                  '${p.nome}/CHANGELOG.md:${baldes.first.linha} — o '
                  '`[Unreleased]` está abaixo de uma seção de versão. Quem '
                  'lê o arquivo lê de cima; o ciclo em curso mora no topo.',
            );
          }
        }
      });

      test('a seção do topo é a versão do pubspec, e tem data', () {
        for (final _Pacote p in publicaveis) {
          final _Secao topo = p.secoes.first;
          expect(
            topo.versao,
            p.versao,
            reason:
                'O pubspec do `${p.nome}` diz ${p.versao} e o topo do '
                'CHANGELOG dele diz ${topo.versao}. O `dart pub publish` só '
                'reclama disso na hora do publish, quando o erro já '
                'atravessou o merge.',
          );
          expect(
            topo.data,
            isNotNull,
            reason:
                'A seção ${topo.versao} do `${p.nome}` está sem data. Só os '
                'marcos internos ABAIXO da primeira publicação podem estar, '
                'e o topo nunca é um deles.',
          );
        }
      });

      test('as seções descem em ordem, e as datas não sobem', () {
        for (final _Pacote p in publicaveis) {
          final List<_Secao> publicas = p.secoesPublicas;
          for (int i = 1; i < publicas.length; i++) {
            final _Secao acima = publicas[i - 1];
            final _Secao abaixo = publicas[i];
            expect(
              _comparar(acima.versao, abaixo.versao),
              greaterThan(0),
              reason:
                  '${p.nome}/CHANGELOG.md:${abaixo.linha} — ${abaixo.versao} '
                  'aparece abaixo de ${acima.versao} e não é menor que ela. '
                  'Quem lê o arquivo lê de cima, e a ordem é o que diz o que '
                  'é recente.',
            );
            expect(
              abaixo.data!.compareTo(acima.data!),
              lessThanOrEqualTo(0),
              reason:
                  '${p.nome}/CHANGELOG.md:${abaixo.linha} — ${abaixo.versao} '
                  'é datada ${abaixo.data} e a ${acima.versao}, acima dela, '
                  'é datada ${acima.data}. Uma versão mais nova não pode ter '
                  'saído antes da mais velha.',
            );
          }
        }
      });

      test('abaixo do primeiro marco sem data não há seção datada', () {
        // O rodapé sem data é história interna pré-publicação — o
        // `## [1.0.0]` do core, que o próprio arquivo explica ("Nothing
        // below `[0.1.0]` was ever published"). A varredura de ordem para
        // ali de propósito, e sem esta asserção apagar uma data viraria a
        // porta de fuga: bastaria isso para tirar uma seção do gate.
        for (final _Pacote p in publicaveis) {
          final int corte = p.secoes.indexWhere((_Secao s) => s.data == null);
          if (corte < 0) {
            continue;
          }
          for (final _Secao s in p.secoes.skip(corte + 1)) {
            expect(
              s.data,
              isNull,
              reason:
                  '${p.nome}/CHANGELOG.md:${s.linha} — a seção ${s.versao} '
                  'tem data e está abaixo de um marco interno sem data. Ou '
                  'ela sobe para a linha pública, ou a data sai: do jeito '
                  'que está, ela escapa do gate de ordem.',
            );
          }
        }
      });

      test('toda data é um dia de calendário que já aconteceu', () {
        // A comparação é com HOJE EM UTC, sem folga. Quem escreve neste repo
        // está em UTC−3, então uma data local nunca fica à frente da UTC —
        // não há fuso a compensar, e uma folga de um dia só serviria para
        // deixar passar a data errada de amanhã.
        final DateTime hoje = DateTime.now().toUtc();
        final String limite = _iso(hoje);
        for (final _Pacote p in publicaveis) {
          for (final _Secao s in p.secoes) {
            if (s.data == null) {
              continue;
            }
            expect(
              _iso(DateTime.parse(s.data!)),
              s.data,
              reason:
                  '${p.nome}/CHANGELOG.md:${s.linha} — `${s.data}` tem a '
                  'forma de uma data ISO e não é um dia que existe.',
            );
            expect(
              s.data!.compareTo(limite),
              lessThanOrEqualTo(0),
              reason:
                  '${p.nome}/CHANGELOG.md:${s.linha} — a seção ${s.versao} é '
                  'datada ${s.data} e hoje é $limite (UTC). Data no futuro é '
                  'a assinatura do release preparado e não publicado: foi '
                  'assim que cinco seções datavam versões que ninguém tinha '
                  'visto (PR #19).',
            );
          }
        }
      });

      test('a mesma versão carrega a mesma data em todo o lockstep', () {
        // A forma exata do PR #19, pega offline: três pacotes datavam a
        // 0.1.0 em 2026-08-05 e um datava em 2026-08-10. Sem rede, o que
        // denuncia é a discordância entre eles — quem sobe em lockstep sobe
        // no mesmo dia, por definição.
        //
        // Os estreantes ficam FORA deste grupo de propósito: a 0.1.0 do
        // `flocks_cupertino` é a estreia dele, não a 0.1.0 do core. Mesmo
        // número, releases diferentes, datas legitimamente diferentes —
        // 2026-08-12 contra 2026-08-10. É por isso que a isenção não pode ser
        // "está na versão do core": ela é a razão deste grupo ter um `where`.
        final Map<String, Map<String, String>> porVersao =
            <String, Map<String, String>>{};
        for (final _Pacote p in publicaveis.where(
          (_Pacote p) => p.nome == kNomeDoCore || p.emLockstepEstrito,
        )) {
          for (final _Secao s in p.secoesPublicas) {
            porVersao.putIfAbsent(s.versao, () => <String, String>{})[p.nome] =
                s.data!;
          }
        }
        for (final MapEntry<String, Map<String, String>> e
            in porVersao.entries) {
          final Set<String> datas = e.value.values.toSet();
          expect(
            datas,
            hasLength(1),
            reason:
                'A ${e.key} é datada de mais de um jeito no lockstep: '
                '${e.value}. Eles sobem juntos ao pub.dev; a data é a mesma '
                'ou uma delas está errada.',
          );
        }
      });
    });
  }, skip: foraDoRepo);
}

/// Um membro publicável do workspace, com o que este gate precisa saber dele.
class _Pacote {
  _Pacote({
    required this.nome,
    required this.versao,
    required this.prosa,
    required this.changelog,
    required this.cabecalhos,
  });

  /// O `name:` do pubspec.
  final String nome;

  /// O `version:` do pubspec.
  final String versao;

  /// Todo comentário do pubspec, sem os `#` e reduzido a uma linha só.
  ///
  /// Numa linha porque as frases-âncora atravessam a quebra de linha do
  /// pubspec: "…começa em\n# 0.1.0 porque…". Casar contra o texto normalizado
  /// faz o gate sobreviver a reformatar o comentário, que é mudança de forma e
  /// não de promessa.
  final String prosa;

  final File changelog;

  /// Todo cabeçalho `## …` do CHANGELOG, bem formado ou não.
  final List<_Cabecalho> cabecalhos;

  /// Só os cabeçalhos que são seção de versão de verdade.
  late final List<_Secao> secoes = cabecalhos
      .map((_Cabecalho c) {
        final RegExpMatch? m = kCabecalhoDeSecao.firstMatch(c.texto);
        return m == null
            ? null
            : _Secao(versao: m.group(1)!, data: m.group(2), linha: c.linha);
      })
      .whereType<_Secao>()
      .toList();

  /// A linha pública: do topo até o primeiro marco interno sem data.
  late final List<_Secao> secoesPublicas = secoes
      .takeWhile((_Secao s) => s.data != null)
      .toList();

  /// A versão em que a linha pública deste pacote começa, quando ele diz que
  /// nunca publicou. `null` para todos os outros.
  late final String? estreiaEm = kClausulaDeEstreia.firstMatch(prosa)?.group(1);

  /// Promete lockstep e já estreou — logo, deve a versão do core.
  late final bool emLockstepEstrito =
      prosa.contains(kMarcaDeLockstep) && estreiaEm == null;
}

/// Um `## …` do CHANGELOG: o texto depois do `## ` e a linha em que ele mora.
class _Cabecalho {
  _Cabecalho(this.texto, this.linha);

  final String texto;
  final int linha;
}

class _Secao {
  _Secao({required this.versao, required this.data, required this.linha});

  final String versao;

  /// `null` nos marcos internos anteriores à primeira publicação.
  final String? data;

  final int linha;
}

_Pacote _core(List<_Pacote> pacotes) =>
    pacotes.firstWhere((_Pacote p) => p.nome == kNomeDoCore);

/// Compara `X.Y.Z` numericamente. Positivo quando `a` é maior.
int _comparar(String a, String b) {
  final List<int> na = a.split('.').map(int.parse).toList();
  final List<int> nb = b.split('.').map(int.parse).toList();
  for (int i = 0; i < 3; i++) {
    if (na[i] != nb[i]) {
      return na[i] - nb[i];
    }
  }
  return 0;
}

String _iso(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Os membros de `workspace:` que vão ao pub.dev — sem `publish_to: none`.
///
/// A lista sai do pubspec da raiz, e não de um literal aqui, porque é ela que
/// o `pub` obedece: um pacote novo entra no gate no mesmo commit em que entra
/// no workspace. Leitura por regex, sem parser de YAML, como o resto do repo
/// faz com pubspec (`generate_mcpb_manifest.dart`, `install_docs_test.dart`).
List<_Pacote> _varrerPublicaveis(Directory raiz) {
  final String raizPubspec = File(
    '${raiz.path}/pubspec.yaml',
  ).readAsStringSync();
  final List<_Pacote> pacotes = <_Pacote>[];
  for (final String membro in _membrosDeWorkspace(raizPubspec)) {
    final File pubspec = File('${raiz.path}/$membro/pubspec.yaml');
    if (!pubspec.existsSync()) {
      continue;
    }
    final String texto = pubspec.readAsStringSync();
    if (RegExp(r'^publish_to:\s*none\s*$', multiLine: true).hasMatch(texto)) {
      continue;
    }
    final String? nome = RegExp(
      r'^name:\s*(\S+)\s*$',
      multiLine: true,
    ).firstMatch(texto)?.group(1);
    final String? versao = RegExp(
      r'^version:\s*(\S+)\s*$',
      multiLine: true,
    ).firstMatch(texto)?.group(1);
    if (nome == null || versao == null) {
      continue;
    }
    final File changelog = File('${raiz.path}/$membro/CHANGELOG.md');
    pacotes.add(
      _Pacote(
        nome: nome,
        versao: versao,
        prosa: _prosaDoPubspec(texto),
        changelog: changelog,
        cabecalhos: changelog.existsSync()
            ? _cabecalhos(changelog.readAsStringSync())
            : const <_Cabecalho>[],
      ),
    );
  }
  return pacotes;
}

/// Os caminhos listados sob `workspace:` na raiz.
///
/// A fatia para no primeiro campo de topo seguinte para não varrer listas de
/// outros blocos, se um dia houver.
List<String> _membrosDeWorkspace(String raizPubspec) {
  final int inicio = raizPubspec.indexOf(
    RegExp(r'^workspace:\s*$', multiLine: true),
  );
  if (inicio < 0) {
    return const <String>[];
  }
  final List<String> membros = <String>[];
  for (final String linha
      in raizPubspec.substring(inicio).split('\n').skip(1)) {
    if (RegExp(r'^\S').hasMatch(linha)) {
      break;
    }
    final RegExpMatch? item = RegExp(r'^\s+-\s+(\S+)\s*$').firstMatch(linha);
    if (item != null) {
      membros.add(item.group(1)!);
    }
  }
  return membros;
}

String _prosaDoPubspec(String pubspec) {
  final StringBuffer prosa = StringBuffer();
  for (final String linha in pubspec.split('\n')) {
    final String limpa = linha.trimLeft();
    if (limpa.startsWith('#')) {
      prosa.write('${limpa.substring(1).trim()} ');
    }
  }
  return prosa.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}

List<_Cabecalho> _cabecalhos(String changelog) {
  final List<String> linhas = changelog.split('\n');
  final List<_Cabecalho> achados = <_Cabecalho>[];
  for (int i = 0; i < linhas.length; i++) {
    if (linhas[i].startsWith('## ')) {
      achados.add(_Cabecalho(linhas[i].substring(3).trim(), i + 1));
    }
  }
  return achados;
}

/// Sobe de `Directory.current` até o `pubspec.yaml` que declara `workspace:` —
/// a raiz do monorepo. Os membros trazem `resolution: workspace`, que é outra
/// linha e não casa aqui.
///
/// Cópia do helper homônimo de `install_docs_test.dart` (privado ao arquivo
/// dele), pela mesma razão que cada adaptador carrega a sua cópia da asserção
/// de contrato: não há lugar comum entre suítes onde isto caiba sem virar
/// dependência de teste em teste.
Directory? _acharRaizDeWorkspace() => _subindo((Directory dir) {
  final File pubspec = File('${dir.path}/pubspec.yaml');
  return pubspec.existsSync() &&
      RegExp(
        r'^workspace:\s*$',
        multiLine: true,
      ).hasMatch(pubspec.readAsStringSync());
});

/// `.git` é DIRETÓRIO num clone e ARQUIVO numa worktree ou num submódulo —
/// daí `typeSync`, e não `Directory.existsSync`. Este repo é trabalhado em
/// worktrees paralelas, então o caso do arquivo é o comum, não a exceção.
Directory? _acharRaizDeGit() => _subindo(
  (Directory dir) =>
      FileSystemEntity.typeSync('${dir.path}/.git') !=
      FileSystemEntityType.notFound,
);

Directory? _subindo(bool Function(Directory) casa) {
  Directory dir = Directory.current.absolute;
  for (int i = 0; i < 8; i++) {
    if (casa(dir)) {
      return dir;
    }
    final Directory pai = dir.parent;
    if (pai.path == dir.path) {
      return null;
    }
    dir = pai;
  }
  return null;
}
