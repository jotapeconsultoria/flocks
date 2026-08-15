// O README e o `pubspec.yaml` não podem se contradizer sobre como instalar.
//
// O README instruía `flocks: ^1.0.0` — sintaxe de dependência hospedada —
// enquanto o pubspec tinha `publish_to: none`. As duas não podem ser verdade, e
// a copy de /instalar do site sai desse mesmo texto: a contradição não fica no
// repositório, ela é publicada.
//
// O DESTINO CHEGOU. O pacote está no pub.dev e o `publish_to: none` saiu do
// pubspec na estreia. Até aqui este arquivo ramificava naquela linha: enquanto
// ela estivesse lá, exigia do README o aviso de "ainda não publicado"; no dia
// em que saísse, exigia que o aviso saísse junto. O XOR foi embora, e o porquê
// está no banner de PUBLICAÇÃO logo abaixo — em uma frase: `publish_to:` é
// intenção declarada, nunca estado remoto, e ele mentiu durante toda a janela
// entre preparar o release e publicar.
//
// O que este arquivo cobra hoje, em três frentes, cada uma com o seu banner:
//
//  1. PUBLICAÇÃO — o README do pacote e as duas landings instruem a via
//     hospedada e não carregam aviso de não-publicado.
//  2. SITE, A ESTRUTURA — sitemap, página de erro, paridade de nav bilíngue e a
//     raiz de entrada das landings, tudo derivado dos arquivos.
//  3. OS NÚMEROS PUBLICADOS — cada contagem que o site e o README da raiz
//     afirmam sai de um artefato versionado, e não de medição à mão.
//
// Nenhum número de versão escrito aqui, nem em comentário: número em comentário
// apodrece e nenhum gate o alcança — o argumento inteiro está no
// `test/release/release_versioning_test.dart`.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
// O parser de HTML do próprio `flocks` (dependência DIRETA, usada pelos
// organisms de conteúdo). Os gates de estrutura do site abaixo julgam o DOM,
// e não o texto: é o DOM que o buscador vê. `xml` e `path` também estão no
// lock, mas só como transitivas — importá-las seria dependência não declarada,
// que some no dia em que outra árvore mudar. Daí o sitemap sair por regex.
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import '../../tool/count_use_cases.dart';
import '../../tool/serialize_meta.dart';
import 'entry_root_tokens.dart';

/// A marca de "ainda não publicado" que o README NÃO pode carregar.
/// Curta de propósito: é a âncora do gate, não a frase inteira.
///
/// Em inglês desde que o README passou a ser inglês — o pacote é internacional
/// a partir da publicação. A âncora acompanha a prosa: um marcador em português
/// num README inglês nunca casaria, e o gate ficaria verde por vacuidade em vez
/// de por acerto.
const String kUnpublishedMarker = 'not yet published';

/// O bloco de dependência hospedada que o README instrui.
const String kHostedDependency = 'flocks: ^0.1.0';

void main() {
  final String pubspec = File('pubspec.yaml').readAsStringSync();
  final String readme = File('README.md').readAsStringSync();

  // ==========================================================================
  // PUBLICAÇÃO — E POR QUE NÃO HÁ MAIS XOR
  //
  // O gate derivava um `blocked` de `publish_to: none` no pubspec e ramificava
  // nele. Três razões para as asserções abaixo serem incondicionais, na ordem
  // de força — as mesmas que a PR #31 firmou no
  // `packages/flocks_material/test/install_docs_test.dart`, de onde vem o
  // formato do segundo caso:
  //
  //  1. O LADO QUE SOBREVIVERIA ESTARIA ERRADO. Este pacote já publicou, e
  //     publicação é irreversível: se alguém puser `publish_to: none` aqui
  //     amanhã, o pacote CONTINUA no pub.dev, e o ramo vivo do XOR passaria a
  //     cobrar do README a frase "ainda não publicado" — um gate armado para um
  //     dia exigir mentira.
  //  2. A ASSERÇÃO INCONDICIONAL É A MAIS FORTE, não a mais frouxa: vale em
  //     qualquer estado do pubspec, enquanto o XOR só vale no estado que a flag
  //     descreve. A informação da flag não se perde — em vez de ramificar nela,
  //     o segundo caso a PROÍBE.
  //  3. `publish_to:` NUNCA FOI A PERGUNTA. É intenção declarada; "esta versão
  //     está no pub.dev" é estado remoto, e os dois divergiram durante toda a
  //     janela entre preparar o release e publicá-lo. A pergunta de estado
  //     remoto exige rede, e rede num `flutter test` reprovaria clone offline e
  //     o checkout do tarball. Ela já tem dono, e é do outro lado: os jobs
  //     `snippet (hosted)` e `changelog (pub.dev)` do `ci.yml` consultam a API
  //     do pub.dev e PULAM DECLARANDO com `::notice::` enquanto a versão não
  //     existe lá — inclusive nos dois sentidos, reprovando publicável que
  //     responde 404 e cláusula de estreia que responde 200. Este arquivo fica
  //     com a metade offline: o invariante interno de que a doc instrui a via
  //     que o destino escolhido produz.
  // ==========================================================================

  test('o README instrui a dependência que o destino escolhido produz', () {
    expect(
      readme,
      contains(kHostedDependency),
      reason:
          'O destino decidido é o pub.dev (doc/EXTRACAO.md). Se isso mudou, '
          'mude a instrução do README e este teste juntos — a copy de '
          '/instalar do site sai daqui.',
    );
  });

  test('o pubspec não contradiz a instrução do README', () {
    // O formato é o do `flocks_material`: em vez de ramificar na flag, proibi-la.
    expect(
      RegExp(r'^publish_to:\s*none\s*$', multiLine: true).hasMatch(pubspec),
      isFalse,
      reason:
          'O pubspec ganhou `publish_to: none`, então a partir da próxima '
          'versão `$kHostedDependency` para de acompanhar o que existe no '
          'pub.dev — o README, e a copy de /instalar que sai dele, instruiriam '
          'uma via que o destino escolhido não produz mais. Se o pacote deve '
          'mesmo sair da linha pública, é a instrução do README que muda '
          'primeiro, e este teste com ela.',
    );
  });

  test('o README não avisa que o pacote não está publicado', () {
    // A negativa sozinha passa sobre arquivo vazio, e é por isso que ela não
    // fica sozinha: é o `contains($kHostedDependency)` do primeiro caso, sobre
    // esta mesma string, que prova que há README para ler.
    expect(
      readme,
      isNot(contains(kUnpublishedMarker)),
      reason:
          'O pacote está publicado e o README diz que não — o aviso é mentira, '
          'e sai renderizado na página do pub.dev ao lado da instrução que '
          'funciona. Tire-o.',
    );
  });

  // Havia aqui um quarto caso, exigindo que `resolution: workspace` e
  // `publish_to: none` andassem sempre juntos. Ele saiu na extração, e a
  // premissa dele — "um checkout avulso vindo do pub.dev não resolve com
  // `resolution: workspace`" — não sobreviveu à medição. O que o `pub` faz de
  // fato, verificado em 2026-08-05:
  //
  // | cenário                                        | resultado |
  // |------------------------------------------------|-----------|
  // | `dart pub publish --dry-run` com a linha        | passa, sem aviso |
  // | consumidor depende do pacote (path ou hosted)   | resolve — o campo é IGNORADO em dependência |
  // | `pub get` DENTRO do pacote, sem workspace acima | falha |
  // | membro de `workspace:` SEM a linha              | falha |
  //
  // Ou seja: a linha só quebra `pub get` rodado dentro do pacote quando não há
  // raiz de workspace acima dele — e aqui há, no repo do Flocks. Ela é o que
  // mantém os membros resolvendo pela árvore; tirá-la quebra o `pub get` da
  // raiz, que é o que a última linha da tabela mede. Publicar não depende dela
  // em nada, então não há acoplamento a cobrar.

  // ==========================================================================
  // SITE — A ESTRUTURA, E NÃO A COPY
  //
  // Tudo acima fiscaliza TEXTO do site (a dependência instruída, o aviso de
  // publicação). Daqui para baixo nenhum gate olha copy: olha forma. São
  // invariantes que sobrevivem a um redesign inteiro — "quem tem arquivo tem
  // URL", "o par de idiomas navega igual", "a página de erro não é indexável".
  //
  // Por que agora: `site/index.html` promete, em inglês, que "every promise
  // below is enforced by a test that runs on every commit". Sobre a própria
  // estrutura do site isso era falso. O `sitemap.xml` era mantido à mão sem
  // gate nenhum, `404.html` não aparecia em teste algum, e a nav das duas
  // homes não era comparada por nada.
  //
  // O QUE ESTES GATES NÃO SÃO: eles não são a resposta ao incidente de
  // 2026-08-10, em que `flocks.live/` serviu ~3h30 uma home sem o link
  // `/demo/`. Aquilo não foi divergência no repo — `git log -S'href="/demo/"'`
  // sobre as duas homes devolve UM commit, o `31c22ad`, que pôs o link nas
  // quatro páginas de uma vez. A fonte estava certa e o que falhou foi a
  // entrega: Storage Zone geo-replicada servindo o objeto anterior com
  // `cdn-cache: MISS` (o mecanismo está no `ROADMAP.md`, linha do Site). Essa
  // classe é do job `site`, que hoje compara byte a byte o que o edge devolve
  // com o que subiu; nenhum teste desta suíte a alcança, porque nenhum teste
  // desta suíte faz HTTP.
  //
  // O que justifica o gate de paridade é mais simples e não precisa de
  // incidente: a nav bilíngue é mantida À MÃO em dois arquivos que ninguém
  // obriga a andarem juntos. Nada no repo comparava um com o outro, então
  // acrescentar um item de menu num idioma e esquecer o outro passava verde —
  // e continuaria passando até alguém abrir as duas páginas lado a lado. É
  // exatamente o mesmo motivo do gate de contagem: o que se mantém à mão em
  // dois lugares diverge, e diverge em silêncio.
  //
  // TUDO É DERIVADO DOS ARQUIVOS. Nenhuma lista de páginas, nenhuma lista de
  // URLs, nem o domínio, estão escritos aqui — o modo de falha que estes gates
  // fecham é exatamente o de uma lista que ninguém atualiza, e uma lista dentro
  // do teste seria a mesma doença com jaleco.
  // ==========================================================================

  /// A raiz do monorepo, achada SUBINDO de `Directory.current`.
  ///
  /// Subir, e não fixar `../../`, por duas razões. A primeira é sobreviver a
  /// mover o pacote de profundidade. A segunda é a que importa: os gates de
  /// site acima usam `if (!file.existsSync()) return`, que não distingue "não
  /// estou no repo" (checkout vindo do tarball do pub.dev, onde `site/` não
  /// existe) de "escrevi o caminho relativo errado". Um `..` a mais passa
  /// VERDE e MUDO. Um gate novo que herdasse esse guard nasceria enfeite.
  final Directory? raizDoRepo = _acharRaizDeWorkspace();
  final Directory? raizDoGit = _acharRaizDeGit();

  /// A razão do skip, ou `null` quando os gates têm de morder de verdade.
  ///
  /// Decidida UMA vez, e materializada em `skip:` — que o runner IMPRIME — em
  /// vez de `return`, que sai verde e calado. Vacuidade que se vê não é
  /// vacuidade. Se esta linha mentir, ela mente para todos os gates de uma vez,
  /// e é precisamente por isso que existe o canário logo abaixo.
  final String? foraDoRepo = raizDoRepo == null
      ? 'sem raiz de workspace acima do cwd — checkout do tarball do pub.dev, '
            'onde `site/` não existe'
      : null;

  test('a âncora de repo não apodreceu (canário dos gates de site)', () {
    // Numa direção só, de propósito: se há checkout git acima, a raiz de
    // workspace TEM de ter sido achada, e no mesmo lugar. A inversa não vale —
    // um zip do GitHub não tem `.git` e continua sendo um checkout legítimo.
    //
    // O que esta asserção impede é o cenário mudo: o pacote muda de
    // profundidade, `_acharRaizDeWorkspace` devolve `null`, e a suíte inteira
    // de site passa a pular sem que ninguém repare. Este é o único teste do
    // bloco que roda sempre.
    if (raizDoGit == null) {
      return;
    }
    expect(
      raizDoRepo?.path,
      raizDoGit.path,
      reason:
          'Há um checkout git em ${raizDoGit.path}, mas a raiz de workspace '
          'não foi achada ali (achei: ${raizDoRepo?.path}). Os gates de site '
          'estariam pulando em silêncio. Conserte `_acharRaizDeWorkspace` — '
          'não o skip.',
    );
  });

  group('site', () {
    test('o inventário de site/ não é vazio', () {
      // O primeiro gate é contra o próprio conjunto vazio. Os que vêm depois
      // iteram sobre páginas e sobre `<loc>`: com zero de cada, todos passam
      // por vacuidade. `isNotEmpty` não é número mágico — é o oposto de um.
      final _Site site = _Site.de(raizDoRepo!);
      expect(
        site.dir.existsSync(),
        isTrue,
        reason: 'Estou no repo (há raiz de workspace) e `site/` não existe.',
      );
      expect(site.paginas, isNotEmpty, reason: 'Nenhum .html sob site/.');
      expect(
        site.indices,
        isNotEmpty,
        reason: 'Nenhum index.html sob site/ — nada teria URL própria.',
      );
      expect(site.locs, isNotEmpty, reason: 'sitemap.xml sem nenhum <loc>.');
    }, skip: foraDoRepo);

    // A copy de /instalar das landings sai do README do pacote, então as duas
    // páginas entram no mesmo gate de publicação. Os dois casos abaixo VIVIAM
    // ACIMA, fora deste grupo, entrando por caminho FIXO `../../site/…` com
    // `if (!file.existsSync()) return`. Medido antes da mudança, numa cópia do
    // pacote um nível mais fundo e com as DUAS landings sabotadas: a suíte
    // reportava "All tests passed!", 14 testes, zero skips. É o modo de falha
    // que o comentário de `raizDoRepo` nomeia — "um `..` a mais passa VERDE e
    // MUDO" — e o remédio já estava escrito oito linhas abaixo dele, esperando
    // que estes dois casos o usassem: a página sai do inventário derivado, e a
    // ausência do repo vira `skip:`, que o runner imprime.
    //
    // O marcador é por página porque a prosa é por idioma: a âncora inglesa numa
    // página portuguesa nunca casaria e o gate ficaria verde por vacuidade — o
    // mesmo motivo de o `kUnpublishedMarker` ter virado inglês com o README. A
    // pasta do idioma secundário sai da constante que os pares de idioma
    // auto-validam, e não de um `'pt'` escrito aqui.
    const Map<String, String> kLandings = <String, String>{
      'index.html': kUnpublishedMarker,
      '$kPastaDoIdiomaSecundario/index.html': 'não publicado no pub.dev',
    };

    for (final MapEntry<String, String> landing in kLandings.entries) {
      test('site: ${landing.key} acompanha o estado de publicação', () {
        final _PaginaDoSite pagina = _landing(raizDoRepo!, landing.key);
        // Sobre a prosa derivada do DOM, e não sobre o HTML cru: o bloco de
        // instalação pode ganhar coloração por token a qualquer momento, e aí
        // `flocks: ^0.1.0` deixa de existir literal na fonte sem deixar de
        // existir na página. É o mesmo argumento que o docstring de
        // `_blocoDeCodigoComRunApp` faz para os tokens da raiz de entrada.
        final String prosa = _prosaDe(pagina);
        expect(
          prosa,
          contains(kHostedDependency),
          reason:
              'A landing instrui a instalação e a copy sai do README — se a '
              'dependência hospedada mudou, mude as duas juntas.',
        );
        // A positiva acima é o que sustenta esta negativa: sem ela, uma página
        // que virasse um 404 passaria aqui por não conter nada.
        expect(
          prosa,
          isNot(contains(landing.value)),
          reason:
              'O pacote está publicado e site/${landing.key} diz que não — o '
              'aviso virou mentira, e o site é deploy contínuo. Tire-o da '
              'página no mesmo commit.',
        );
      }, skip: foraDoRepo);

      test('site: ${landing.key} monta a raiz de entrada', () {
        // A outra metade deste gate está no `readme_example_test.dart`, sobre o
        // README e o `example/`. A copy de instalação acima e a raiz aqui são a
        // mesma classe de problema: texto mantido à mão em superfícies que ninguém
        // obriga a andarem juntas. A diferença é que uma instrução de instalação
        // errada não resolve, e uma raiz sem `Overlay` resolve, compila, e só
        // quebra no gesto do visitante.
        final _PaginaDoSite pagina = _landing(raizDoRepo!, landing.key);
        final String? codigo = _blocoDeCodigoComRunApp(pagina.documento);
        expect(
          codigo,
          isNotNull,
          reason:
              'Nenhum bloco de código com `runApp` em site/${landing.key}. '
              'Guarda contra vacuidade: sem ela, mudar a marcação do bloco '
              'faria as asserções de baixo passarem por falta de entrada.',
        );
        for (final String token in kTokensDaRaizDeEntrada) {
          expect(
            codigo,
            contains(token),
            reason:
                'O bloco de código de site/${landing.key} parou de montar '
                '`$token`. A landing é deploy contínuo: no ar, ela passa a '
                'contradizer o README, que documenta a exigência. O critério '
                'inteiro está em `entry_root_tokens.dart`.',
          );
        }
      }, skip: foraDoRepo);
    }

    test(
      'uma página tem <loc> se e somente se é índice e é indexável',
      () {
        // A regra estrutural, inteira, numa linha: um HTML de `site/` tem URL
        // própria se e somente se (a) se chama `index.html` — a convenção de
        // índice de diretório, a mesma que o job `site` do CI já aplica à mão na
        // lista dele — e (b) não carrega `noindex`.
        //
        // O `noindex` entra na regra, e não num gate à parte, para não criar um
        // vermelho pelo motivo errado: no dia em que moverem a página de erro
        // para `site/404/index.html` (layout comum), a versão ingênua EXIGIRIA
        // `<loc>` para uma página deliberadamente não-indexável. De quebra, o
        // `noindex` do 404 vira load-bearing: é ele que autoriza a ausência.
        //
        // A direção reversa é o que pega o caso oposto — o `<loc>` que ficou
        // para trás quando a página saiu ou mudou de nome. Ela não pode ser
        // "todo `<loc>` tem arquivo": `/demo/` é um `<loc>` legítimo SEM
        // arquivo em `site/` (é o build Flutter que o CI sobe sob o prefixo
        // `demo/` da mesma Storage Zone), e cobri-la assim exigiria escrever
        // `/demo/` aqui dentro — a lista à mão que este bloco existe para não
        // criar. A versão que se sustenta é mais estreita e não nomeia
        // ninguém: um `<loc>` cuja PASTA existe em `site/` tem de encontrar um
        // índice ali. `/demo/` não tem pasta em `site/`, então segue de fora
        // sozinho, sem exceção escrita.
        //
        // Medido: sem esta terceira asserção, renomear `pt/mcp/index.html`
        // para `pagina.html` passava VERDE nas duas primeiras — o arquivo some
        // do universo iterado e ninguém cobra o `<loc>` que sobrou.
        final _Site site = _Site.de(raizDoRepo!);
        final Set<String> comLoc = site.caminhosDeLoc;
        final List<String> faltando = <String>[];
        final List<String> sobrando = <String>[];
        for (final _PaginaDoSite pagina in site.paginas) {
          final bool deveriaEstar = pagina.ehIndice && !pagina.noindex;
          final bool esta = comLoc.contains(
            _caminhoCanonico(pagina.caminhoDeUrl),
          );
          if (deveriaEstar && !esta) {
            faltando.add('${pagina.rel} → ${pagina.caminhoDeUrl}');
          }
          if (!deveriaEstar && esta) {
            sobrando.add('${pagina.rel} → ${pagina.caminhoDeUrl}');
          }
        }
        expect(
          faltando,
          isEmpty,
          reason:
              'Páginas com URL própria e sem <loc> no sitemap.xml: $faltando. O '
              'sitemap é mantido à mão — acrescente o <url> no mesmo commit que '
              'cria a página, ou marque a página com `noindex` se ela não deve '
              'ser indexada.',
        );
        expect(
          sobrando,
          isEmpty,
          reason:
              'Arquivos sem URL própria (ou com `noindex`) que mesmo assim têm '
              '<loc> no sitemap.xml: $sobrando. Um sitemap que anuncia página '
              'não-indexável é pedido de rastreio para o que não se quer visto.',
        );

        final List<String> orfaos = <String>[
          for (final String caminho in comLoc)
            if (site.temPasta(caminho) && !site.temIndicePara(caminho)) caminho,
        ];
        expect(
          orfaos,
          isEmpty,
          reason:
              '<loc> apontando para pasta que existe em site/ e não tem '
              'index.html: $orfaos. A página saiu ou mudou de nome e o <url> '
              'ficou para trás — o sitemap manda o buscador a um 404.',
        );
      },
      skip: foraDoRepo,
    );

    test('os <loc> têm uma origem só, sem duplicata e sem query', () {
      final _Site site = _Site.de(raizDoRepo!);
      final List<String> origens = site.origens.toList()..sort();
      expect(
        origens,
        hasLength(1),
        reason:
            'Os <loc> do sitemap.xml apontam para mais de uma origem: '
            '$origens. O domínio NÃO está escrito neste teste de propósito — '
            'ele sai do próprio sitemap, e o que se cobra é coerência interna, '
            'para que trocar de domínio não exija editar um teste.',
      );

      final List<String> caminhos = site.locs
          .map((String loc) => _caminhoCanonico(Uri.parse(loc).path))
          .toList(growable: false);
      final List<String> duplicados = <String>[
        for (final String caminho in caminhos.toSet())
          if (caminhos.where((String outro) => outro == caminho).length > 1)
            caminho,
      ];
      expect(
        duplicados,
        isEmpty,
        reason:
            'Caminhos repetidos entre os <loc>: $duplicados. A comparação é '
            'feita sem a barra final, então `/mcp` e `/mcp/` no mesmo sitemap '
            'contam como a duplicata que de fato são para o buscador.',
      );

      final List<String> sujos = <String>[
        for (final String loc in site.locs)
          if (Uri.parse(loc).hasQuery || Uri.parse(loc).fragment.isNotEmpty)
            loc,
      ];
      expect(
        sujos,
        isEmpty,
        reason:
            '<loc> com query ou fragment: $sujos. O sitemap declara páginas, '
            'não variantes de rastreamento — e a comparação com os arquivos '
            'nunca casaria com eles.',
      );
    }, skip: foraDoRepo);

    test('cada par de idioma navega igual', () {
      // Duas navs escritas à mão, uma por idioma, que nada obrigava a andarem
      // juntas. Os pares saem da ÁRVORE (`site/pt/**/index.html` casado com
      // `site/<resto>/index.html`), e não de uma lista aqui: hoje isso produz
      // sozinho os dois pares que existem, e produz o terceiro no dia em que
      // criarem `/instalar/`.
      //
      // A comparação é por chave normalizada, não por HTML: texto e
      // `aria-label` mudam de idioma por definição (`Components`/`Componentes`,
      // `Main`/`Principal`), e um gate que os comparasse nasceria vermelho.
      final _Site site = _Site.de(raizDoRepo!);
      final List<_ParDeIdioma> pares = site.paresDeIdioma;
      expect(
        pares,
        isNotEmpty,
        reason:
            'Nenhum par derivado de site/$kPastaDoIdiomaSecundario/**/'
            'index.html. A pasta do segundo idioma mudou de nome? Sem par, '
            'este gate não cobraria nada — esta linha existe para que a '
            'mudança apareça em vermelho, e não em silêncio.',
      );
      for (final _ParDeIdioma par in pares) {
        final List<List<String>> primario = par.primario.chavesDeNav;
        final List<List<String>> secundario = par.secundario.chavesDeNav;
        expect(
          primario,
          isNotEmpty,
          reason:
              '${par.primario.rel} não tem nenhum <nav>. Se a navegação virou '
              'outra tag, este gate parou de cobrar — ajuste-o junto.',
        );
        expect(
          secundario,
          hasLength(primario.length),
          reason:
              'Quantidade de <nav> diferente entre os idiomas: '
              '${par.primario.rel} tem ${primario.length}, '
              '${par.secundario.rel} tem ${secundario.length}.',
        );
        for (int i = 0; i < primario.length; i++) {
          expect(
            primario[i],
            isNotEmpty,
            reason: 'O <nav> #$i de ${par.primario.rel} está sem âncoras.',
          );
          expect(
            secundario[i],
            primario[i],
            reason:
                'O <nav> #$i diverge entre os idiomas.\n'
                '  ${par.primario.rel}: ${primario[i]}\n'
                '  ${par.secundario.rel}: ${secundario[i]}\n'
                'As duas navs são escritas à mão, uma por arquivo: mexeu numa, '
                'mexa na outra no mesmo commit.',
          );
        }
      }
    }, skip: foraDoRepo);

    test(
      'o lang-switch de cada página aponta para o gêmeo, que existe',
      () {
        // Não-simétrico DE PROPÓSITO. O gate acima compara um idioma contra o
        // outro e, por construção, deixa passar o caso em que os DOIS estão
        // errados do mesmo jeito — a /mcp inglesa mandando para a home
        // portuguesa e a portuguesa mandando para a home inglesa é simetria
        // perfeita e navegação quebrada. Este compara cada página contra a
        // ÁRVORE.
        //
        // O `hasLength(1)` não é preciosismo: se a classe for renomeada, o gate
        // de paridade continua passando (as chaves perdem o token dos dois lados
        // e seguem simétricas) e este ficaria sem âncora para conferir. Exigir
        // exatamente uma faz a renomeação virar vermelho apontando para a
        // constante.
        final _Site site = _Site.de(raizDoRepo!);
        final List<_ParDeIdioma> pares = site.paresDeIdioma;
        expect(pares, isNotEmpty, reason: 'Nenhum par de idioma derivado.');
        for (final _ParDeIdioma par in pares) {
          for (final _PaginaDoSite pagina in par.ambas) {
            final List<dom.Element> troca = pagina.langSwitches;
            expect(
              troca,
              hasLength(1),
              reason:
                  '${pagina.rel} tem ${troca.length} âncora(s) com a classe '
                  '`$kClasseDoLangSwitch`, e o gate de paridade depende de haver '
                  'exatamente uma. Se a classe mudou de nome, mude '
                  '`kClasseDoLangSwitch` no mesmo commit.',
            );
            final _PaginaDoSite gemeo = par.gemeoDe(pagina);
            expect(
              _caminhoCanonico(troca.single.attributes['href'] ?? '«sem href»'),
              _caminhoCanonico(gemeo.caminhoDeUrl),
              reason:
                  'O lang-switch de ${pagina.rel} aponta para '
                  '${troca.single.attributes['href']}, e o gêmeo dela é '
                  '${gemeo.rel} (${gemeo.caminhoDeUrl}). Trocar de idioma tem de '
                  'manter a pessoa na mesma página, não jogá-la na home.',
            );
          }
        }
      },
      skip: foraDoRepo,
    );

    test('a página de erro existe e não é indexável', () {
      // Ela é o único HTML de `site/` que o host serve sem URL própria, e a
      // única superfície do site que aparece em resposta a um caminho que não
      // existe. Sem `noindex`, o buscador indexa a página de erro para cada
      // caminho quebrado que encontrar.
      //
      // Pelo DOM, e não por regex: `<meta content="noindex" name="robots">` é
      // HTML perfeitamente legal, e uma regex ancorada na ordem `name=…
      // content=…` passaria verde por não achar o que está lá.
      final _Site site = _Site.de(raizDoRepo!);
      final _PaginaDoSite? erro = site.porCaminho(kArquivoDePaginaDeErro);
      expect(
        erro,
        isNotNull,
        reason:
            'site/$kArquivoDePaginaDeErro não existe. É o error document que a '
            'zone serve — sem ele, um caminho quebrado devolve a página padrão '
            'do host.',
      );
      expect(
        erro!.noindex,
        isTrue,
        reason:
            'site/$kArquivoDePaginaDeErro perdeu o <meta name="robots" '
            'content="noindex">. É esse meta que a mantém fora do índice — e é '
            'ele, também, que a autoriza a ficar fora do sitemap.',
      );
    }, skip: foraDoRepo);

    // ========================================================================
    // OS NÚMEROS PUBLICADOS
    //
    // `site/index.html` promete, em inglês, que "every promise below is
    // enforced by a test that runs on every commit". Sobre a estrutura, os
    // gates acima tornaram isso verdade. Sobre os NÚMEROS continuava falso: a
    // contagem de componentes, a de exemplos, a de suítes e a de ícones eram
    // string escrita à mão, e o modo de falha não é hipotético — as duas homes
    // disseram "21 suítes" enquanto eram 23, até a PR #22 medir.
    //
    // Cada número passa a sair do artefato que o produz. O gate não escreve
    // nenhum deles: escreve o caminho do artefato e a âncora de prosa, que é o
    // mínimo indispensável, e as duas se auto-validam (artefato que sai de lugar
    // reprova na leitura; âncora que apodrece reprova no `isNotEmpty` abaixo).
    //
    // O UNIVERSO É `site.paginas`, não as duas homes. Medido: a contagem de
    // componentes aparece 15 vezes em `site/` — inclusive em `site/mcp/`,
    // `site/pt/mcp/` e `site/assets/og.html` —, e um gate limitado às landings
    // deixaria seis delas envelhecendo em silêncio.
    //
    // FORA DO GATE, DE PROPÓSITO, e registrado aqui para que o próximo leitor
    // não "conserte": o "1.500+ testes" do bloco de stats é piso declarado, não
    // contagem (o `+` diz isso, e nenhum artefato do repo serializa o total); o
    // "2 idiomas" é derivável da árvore, via `paresDeIdioma`, mas afirma o que a
    // própria estrutura já cobra em cinco gates acima.
    // ========================================================================

    test(
      'site: todo número publicado bate com o artefato que o gera',
      () {
        final _Site site = _Site.de(raizDoRepo!);
        for (final _NumeroPublicado numero in _numerosDoPacote()) {
          for (final _PaginaDoSite pagina in site.paginas) {
            final String prosa = _prosaDe(pagina);
            for (final String ancora in numero.ancoras) {
              for (final int citado in _numerosAntesDe(prosa, ancora)) {
                expect(
                  citado,
                  numero.valor,
                  reason:
                      'site/${pagina.rel} publica "$citado $ancora" e '
                      '${numero.fonte} diz ${numero.valor}. ${numero.conserto}',
                );
              }
            }
          }
        }
      },
      skip: foraDoRepo,
    );

    test('site: cada número publicado aparece nos dois idiomas', () {
      // A guarda anti-vacuidade do gate acima, que compara ocorrência por
      // ocorrência e por isso passaria liso se não houvesse ocorrência nenhuma.
      //
      // Por ÂNCORA, e não por número: "components" nunca casa numa página
      // portuguesa, então exigir só que o número apareça em algum lugar de
      // `site/` deixaria a home portuguesa perder o dela sob a cobertura da
      // inglesa. E sobre o CORPUS, não por página: `404.html` e
      // `assets/og.html` não citam contagem nenhuma, e cobrar delas seria
      // vermelho pelo motivo errado.
      final _Site site = _Site.de(raizDoRepo!);
      final List<String> prosas = site.paginas.map(_prosaDe).toList();
      for (final _NumeroPublicado numero in _numerosDoPacote()) {
        for (final String ancora in numero.ancoras) {
          expect(
            prosas.expand((String p) => _numerosAntesDe(p, ancora)),
            isNotEmpty,
            reason:
                'Nenhuma página de `site/` cita um número antes de "$ancora". '
                'Ou a prosa que publicava ${numero.fonte} saiu do ar, ou a '
                'âncora deste gate apodreceu — e enquanto ela não casa nada, o '
                'gate de cima não cobra nada.',
          );
        }
      }
    }, skip: foraDoRepo);

    test(
      'site: a contagem de ícones bate com o catálogo do provedor',
      () {
        // Sozinha, e com um skip próprio, porque é o único número cujo artefato
        // vive em OUTRO pacote: quem publica "1.512 ícones" é o
        // `flocks_phosphor`, e derivar de qualquer outro lugar seria medir uma
        // coisa e afirmar outra. Pacote vizinho que sai de lugar não é defeito
        // deste pacote — daí `skip:` com razão impressa, e não vermelho.
        final Directory raiz = raizDoRepo!;
        final _NumeroPublicado icones = _numeroDeIcones(raiz);
        final List<String> prosas = _Site.de(
          raiz,
        ).paginas.map(_prosaDe).toList();
        for (final String ancora in icones.ancoras) {
          final List<int> citados = prosas
              .expand((String p) => _numerosAntesDe(p, ancora))
              .toList();
          expect(
            citados,
            isNotEmpty,
            reason:
                'Nenhuma página de `site/` cita um número antes de "$ancora". A '
                'cauda "× 6" faz parte da âncora de propósito: ela é o que amarra '
                'o número ao provedor de seis pesos. Se o card de provedores foi '
                'reescrito, a âncora tem de ser reescrita com ele — não apagada.',
          );
          for (final int citado in citados) {
            expect(
              citado,
              icones.valor,
              reason:
                  'O site publica "$citado $ancora" e ${icones.fonte} tem '
                  '${icones.valor}. ${icones.conserto}',
            );
          }
        }
      },
      skip: foraDoRepo ?? _semCatalogoDeIcones(raizDoRepo!),
    );
  });

  // ==========================================================================
  // O README DA RAIZ
  //
  // Nenhum teste do repo lia este arquivo: `grep -rn "'README.md'"
  // packages/*/test/` só acha o README do próprio pacote, e nada abria o da
  // raiz. Foi por ali que entrou "Six of the seven packages are published"
  // quando eram quatro — a PR #31 registrou a medição. A frase é verdadeira
  // hoje, e ficou falsa por três dias sem nada acusar. É a porta de entrada do
  // repo no GitHub.
  //
  // O QUE ESTE GATE PROVA, E O QUE NÃO PROVA. Ele deriva dos pubspecs, então
  // prova que o README conta certo os pacotes que este repo PRETENDE publicar.
  // Não prova que eles ESTÃO no pub.dev: `publish_to:` é intenção declarada,
  // nunca estado remoto, e o defeito histórico era justamente divergência entre
  // as duas — nenhuma leitura de arquivo deste repo o alcançaria.
  //
  // O que salva o gate de ser enfeite é ser METADE DE UM PAR. O job
  // `changelog (pub.dev)` do `ci.yml` fecha o outro lado, nos dois sentidos:
  // reprova pacote publicável que responde 404 sem declarar a estreia pendente,
  // e reprova pubspec que declara nunca ter publicado enquanto o pub.dev
  // responde 200. Com os dois em pé, intenção e estado só podem divergir dentro
  // da janela de publicação — a mesma que aquele job anota com `::notice::`.
  //
  // Skip pela mesma razão dos gates de site: o README da raiz não viaja no
  // tarball deste pacote.
  // ==========================================================================

  group('README da raiz', () {
    test('a tabela nomeia exatamente os pacotes do workspace', () {
      final Directory raiz = raizDoRepo!;
      final Map<String, bool> pacotes = _pacotesDeDiretorio(raiz);
      final String readme = File('${raiz.path}/README.md').readAsStringSync();

      expect(
        pacotes,
        isNotEmpty,
        reason:
            'Nenhum `packages/*/pubspec.yaml` — a derivação perdeu o alvo, e '
            'sem ela as duas asserções abaixo não cobram nada.',
      );

      // Nos dois sentidos: pacote novo que entra sem linha, e linha que sobrou
      // depois de o pacote sair ou mudar de nome.
      final List<String> citados = _pacotesCitadosNaTabela(readme);
      expect(
        citados,
        pacotes.keys.toList()..sort(),
        reason:
            'A tabela do README da raiz e os diretórios de `packages/` '
            'divergiram. É a primeira coisa que quem chega ao repo lê.',
      );

      // E o link de pub.dev existe SE E SOMENTE SE o pubspec não abre mão de
      // publicar. Foi o outro lado do mesmo defeito de 2026-08-10: a tabela
      // dava link para dois pacotes que respondiam 404, e quem clicava caía
      // neles.
      for (final MapEntry<String, bool> pacote in pacotes.entries) {
        expect(
          readme.contains('](https://pub.dev/packages/${pacote.key})'),
          pacote.value,
          reason: pacote.value
              ? 'A linha de `${pacote.key}` não dá link de pub.dev, e o pubspec '
                    'dele não tem `publish_to: none` — o pacote vai para lá.'
              : 'A linha de `${pacote.key}` dá link de pub.dev, e o pubspec '
                    'dele tem `publish_to: none` — o link cai em 404. Se o '
                    'pacote passou a ser publicado, é a linha do pubspec que '
                    'sai primeiro.',
        );
      }
    }, skip: foraDoRepo);

    test('a frase de contagem bate com os pubspecs', () {
      final Directory raiz = raizDoRepo!;
      final Map<String, bool> pacotes = _pacotesDeDiretorio(raiz);
      final String readme = File('${raiz.path}/README.md').readAsStringSync();
      final int publicaveis = pacotes.values.where((bool vai) => vai).length;

      // A frase INTEIRA como âncora, e não a palavra-numeral solta: a própria
      // tabela contém "six weights" na linha do provedor de ícones, e uma busca
      // por numeral avulso casaria ali. `isNotNull` é o que impede este gate de
      // virar vácuo no dia em que a abertura for reescrita.
      final RegExpMatch? frase = RegExp(
        r'(\w+) of the (\w+) packages are published',
        caseSensitive: false,
      ).firstMatch(readme);
      expect(
        frase,
        isNotNull,
        reason:
            'A frase de contagem de pacotes saiu da abertura do README da raiz '
            '(ou mudou de forma). Se a contagem deixou de ser afirmada, este '
            'gate sai junto; enquanto ela estiver lá, é aqui que ela é cobrada.',
      );

      expect(
        <String>[frase!.group(1)!.toLowerCase(), frase.group(2)!.toLowerCase()],
        <String>[_emPalavras(publicaveis), _emPalavras(pacotes.length)],
        reason:
            'O README da raiz afirma "${frase.group(0)}", e `packages/` tem '
            '${pacotes.length} pacote(s), $publicaveis deles sem '
            '`publish_to: none`.',
      );
    }, skip: foraDoRepo);
  });
}

// ===========================================================================
// Os gates de estrutura do site, por dentro.
//
// As três constantes abaixo são o total de conhecimento hardcoded deste bloco.
// Não há lista de páginas, nem de URLs, nem o domínio: página sai de
// `listSync`, URL sai do `sitemap.xml`, domínio sai dos próprios `<loc>`. Cada
// uma das três se auto-valida — se envelhecer, algum gate fica VERMELHO
// apontando para ela, em vez de passar a não cobrar nada.
// ===========================================================================

/// A pasta do idioma secundário, sob `site/`. Único lugar deste arquivo que
/// sabe que o segundo idioma é o português.
///
/// Se auto-valida pelo `isNotEmpty` da lista de pares: um nome de pasta que
/// não casa com nada produz zero pares, e zero pares é vermelho.
const String kPastaDoIdiomaSecundario = 'pt';

/// A classe da âncora que troca de idioma. Ela é o único item de nav cujo
/// destino muda de lado entre as duas páginas — as outras âncoras casam por
/// href normalizado, essa não casaria nunca.
///
/// Se auto-valida pelo `hasLength(1)` do gate do lang-switch: renomear a
/// classe sem mudar esta linha é vermelho.
const String kClasseDoLangSwitch = 'lang-switch';

/// O error document da zone. Não tem URL própria e, por isso, é o HTML de
/// `site/` que fica fora do sitemap — autorizado a ficar pelo `noindex`.
const String kArquivoDePaginaDeErro = '404.html';

/// O texto do bloco de código da página que traz o `runApp` — a raiz de entrada.
///
/// Pelo DOM, e não por `contains` no HTML cru, por necessidade e não por gosto: o
/// bloco é colorido com um `<span>` por token, então `Overlay(` NUNCA aparece
/// literal na fonte — o que está lá é `Overlay</span>(`. O `.text` do parser
/// também desfaz as entidades, devolvendo `<OverlayEntry>` onde o arquivo tem
/// `&lt;OverlayEntry&gt;`.
///
/// Escolhe pelo `runApp` em vez de pelo primeiro `<code>` porque as páginas usam
/// `<code>` inline na prosa (`flutter run`, `AppButton(...)`), e o primeiro deles
/// aparece antes do bloco.
///
/// Recebe o documento já parseado, e não o HTML cru: quem chama tem a página do
/// inventário de `site/` em mãos, e re-parsear seria um segundo parse do mesmo
/// arquivo — além de deixar implícito o que este docstring diz explicitamente,
/// que aqui só o DOM responde.
String? _blocoDeCodigoComRunApp(dom.Document documento) {
  for (final dom.Element code in documento.getElementsByTagName('code')) {
    if (code.text.contains('runApp')) {
      return code.text;
    }
  }
  return null;
}

/// Uma página HTML de `site/`, já parseada.
class _PaginaDoSite {
  _PaginaDoSite(this.rel, this.documento);

  /// O caminho relativo a `site/`, com `/` sempre — `pt/mcp/index.html`.
  final String rel;
  final dom.Document documento;

  /// A convenção de índice de diretório, que é a que o host aplica: um
  /// `index.html` é servido pelo caminho da pasta que o contém.
  bool get ehIndice => rel == 'index.html' || rel.endsWith('/index.html');

  /// O caminho de URL pelo qual o host serve este arquivo.
  /// `pt/mcp/index.html` → `/pt/mcp/`; `index.html` → `/`; `404.html` →
  /// `/404.html`.
  String get caminhoDeUrl => ehIndice
      ? '/${rel.substring(0, rel.length - 'index.html'.length)}'
      : '/$rel';

  /// Pelos atributos, e não pelo texto do HTML: ordem, aspas e caixa deixam de
  /// ser problema quando quem responde é o DOM.
  bool get noindex => documento
      .getElementsByTagName('meta')
      .where(
        (dom.Element meta) =>
            meta.attributes['name']?.trim().toLowerCase() == 'robots',
      )
      .any(
        (dom.Element meta) => (meta.attributes['content'] ?? '')
            .toLowerCase()
            .contains('noindex'),
      );

  List<dom.Element> get langSwitches => documento
      .getElementsByTagName('a')
      .where((dom.Element a) => a.classes.contains(kClasseDoLangSwitch))
      .toList(growable: false);

  /// As chaves de cada `<nav>` da página, em ordem de documento — uma lista
  /// por nav. `getElementsByTagName` pega descendentes, então isto sobrevive
  /// ao dia em que as âncoras nuas de hoje virarem `<ul><li>`.
  List<List<String>> get chavesDeNav => documento
      .getElementsByTagName('nav')
      .map(
        (dom.Element nav) => nav
            .getElementsByTagName('a')
            .map(_chaveDeAncora)
            .toList(growable: false),
      )
      .toList(growable: false);
}

/// Uma página e a sua tradução. `primario` é a de fora de
/// `site/$kPastaDoIdiomaSecundario/`.
class _ParDeIdioma {
  _ParDeIdioma(this.primario, this.secundario);

  final _PaginaDoSite primario;
  final _PaginaDoSite secundario;

  List<_PaginaDoSite> get ambas => <_PaginaDoSite>[primario, secundario];

  _PaginaDoSite gemeoDe(_PaginaDoSite pagina) =>
      identical(pagina, primario) ? secundario : primario;
}

/// O inventário de `site/`, montado do FILESYSTEM e do `sitemap.xml`.
class _Site {
  _Site._(this.dir, this.paginas, this.locs);

  factory _Site.de(Directory raizDoRepo) {
    final Directory dir = Directory('${raizDoRepo.path}/site');
    final List<_PaginaDoSite> paginas = <_PaginaDoSite>[];
    if (dir.existsSync()) {
      // Ordenado: a ordem do filesystem não é estável entre máquinas, e nomes
      // de offender instáveis atrapalham o diff de um relatório de CI.
      final List<File> arquivos =
          dir
              .listSync(recursive: true)
              .whereType<File>()
              .where((File f) => f.path.toLowerCase().endsWith('.html'))
              .toList()
            ..sort((File a, File b) => a.path.compareTo(b.path));
      for (final File arquivo in arquivos) {
        final String rel = arquivo.path
            .substring(dir.path.length + 1)
            .replaceAll(r'\', '/');
        paginas.add(
          _PaginaDoSite(rel, html_parser.parse(arquivo.readAsStringSync())),
        );
      }
    }
    final File sitemap = File('${dir.path}/sitemap.xml');
    final List<String> locs = sitemap.existsSync()
        ? _locsDe(sitemap.readAsStringSync())
        : const <String>[];
    return _Site._(dir, paginas, locs);
  }

  final Directory dir;
  final List<_PaginaDoSite> paginas;
  final List<String> locs;

  Iterable<_PaginaDoSite> get indices =>
      paginas.where((_PaginaDoSite p) => p.ehIndice);

  _PaginaDoSite? porCaminho(String rel) => paginas
      .cast<_PaginaDoSite?>()
      .firstWhere((_PaginaDoSite? p) => p!.rel == rel, orElse: () => null);

  /// A pasta que um caminho de URL nomeia dentro de `site/` existe? É o que
  /// separa um `<loc>` órfão (a página saiu, a pasta ficou) de um `<loc>`
  /// legítimo servido por outro job do CI sob o mesmo prefixo da zone — sem
  /// que nenhum dos dois precise ser nomeado aqui.
  bool temPasta(String caminhoCanonico) =>
      (caminhoCanonico == '/' ? dir : Directory('${dir.path}$caminhoCanonico'))
          .existsSync();

  bool temIndicePara(String caminhoCanonico) => indices.any(
    (_PaginaDoSite p) => _caminhoCanonico(p.caminhoDeUrl) == caminhoCanonico,
  );

  Set<String> get caminhosDeLoc =>
      locs.map((String loc) => _caminhoCanonico(Uri.parse(loc).path)).toSet();

  /// A origem de cada `<loc>`. Um `<loc>` relativo (que não deveria existir)
  /// vira um marcador próprio em vez de exceção, para que o gate reprove com
  /// mensagem legível em lugar de estourar.
  Set<String> get origens => locs.map((String loc) {
    final Uri uri = Uri.parse(loc);
    return uri.hasScheme && uri.hasAuthority
        ? '${uri.scheme}://${uri.authority}'
        : '«$loc não é URL absoluta»';
  }).toSet();

  /// Os pares de idioma, derivados da árvore: para cada
  /// `site/$kPastaDoIdiomaSecundario/**/index.html`, o gêmeo é
  /// `site/<resto>/index.html`. Um índice traduzido sem gêmeo não vira par —
  /// ele cai no gate do sitemap, que é onde a ausência dele aparece.
  List<_ParDeIdioma> get paresDeIdioma {
    const String prefixo = '$kPastaDoIdiomaSecundario/';
    final List<_ParDeIdioma> pares = <_ParDeIdioma>[];
    for (final _PaginaDoSite secundaria in indices) {
      if (!secundaria.rel.startsWith(prefixo)) {
        continue;
      }
      final _PaginaDoSite? primaria = porCaminho(
        secundaria.rel.substring(prefixo.length),
      );
      if (primaria != null) {
        pares.add(_ParDeIdioma(primaria, secundaria));
      }
    }
    return pares;
  }
}

/// Sobe de `Directory.current` até o `pubspec.yaml` que declara `workspace:` —
/// a raiz do monorepo. Os membros trazem `resolution: workspace`, que é outra
/// linha e não casa aqui.
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

/// A chave de comparação de uma âncora de nav.
///
/// NÃO olha o texto nem o `aria-label`: os dois mudam de idioma por definição
/// (`Components`/`Componentes`, `Main`/`Principal`, `Footer`/`Rodapé`), e um
/// gate que os comparasse seria vermelho no dia em que nasceu. Olha o destino,
/// com o prefixo de idioma removido.
///
/// O lang-switch mantém o destino AO LADO do token, em vez de virar só um
/// token: colapsá-lo apagaria a informação, e dois lang-switch errados de
/// forma simétrica passariam como paridade perfeita.
String _chaveDeAncora(dom.Element ancora) {
  final String href = _semPrefixoDeIdioma(
    ancora.attributes['href'] ?? '«sem href»',
  );
  return ancora.classes.contains(kClasseDoLangSwitch)
      ? '«lang-switch»→$href'
      : href;
}

String _semPrefixoDeIdioma(String href) {
  const String prefixo = '/$kPastaDoIdiomaSecundario/';
  if (href.startsWith(prefixo)) {
    return '/${href.substring(prefixo.length)}';
  }
  return href == '/$kPastaDoIdiomaSecundario' ? '/' : href;
}

/// Tira a barra final (menos da raiz) para que `/mcp` e `/mcp/` sejam a mesma
/// coisa na comparação — e, por consequência, sejam flagrados como a duplicata
/// que de fato são se aparecerem os dois no mesmo sitemap.
String _caminhoCanonico(String caminho) {
  if (caminho.isEmpty) {
    return '/';
  }
  return caminho.length > 1 && caminho.endsWith('/')
      ? caminho.substring(0, caminho.length - 1)
      : caminho;
}

/// Os `<loc>` do sitemap.
///
/// Regex, e não o parser de HTML importado ali em cima: sitemap é XML, e o
/// parser de HTML trataria `<xhtml:link …/>` como elemento desconhecido
/// não-vazio, aninhando o resto do documento dentro dele. O `package:xml`
/// existe no lock, mas só como transitiva — importá-lo seria dependência não
/// declarada, que some no dia em que outra árvore mudar.
///
/// Os comentários caem ANTES. A armadilha não é o comentário que o bloco
/// `/demo/` já carrega — é o dia em que alguém comentar um `<url>` inteiro e o
/// `<loc>` morto for colhido como vivo. Non-greedy é seguro porque XML proíbe
/// `--` dentro de comentário.
List<String> _locsDe(String xml) {
  final String limpo = xml.replaceAll(RegExp(r'<!--.*?-->', dotAll: true), '');
  return RegExp(r'<loc\s*>(.*?)</loc\s*>', dotAll: true)
      .allMatches(limpo)
      .map((RegExpMatch m) => _textoDeXml(m.group(1)!))
      .toList(growable: false);
}

/// Tira CDATA, espaço em volta (`<loc>\n  https://…\n</loc>` é legal) e
/// decodifica o `&amp;` que uma URL com query carrega por obrigação do XML.
String _textoDeXml(String cru) => cru
    .replaceAll('<![CDATA[', '')
    .replaceAll(']]>', '')
    .trim()
    .replaceAll('&amp;', '&');

// ===========================================================================
// Os gates de número, por dentro.
//
// Mesma doutrina do bloco acima: o que está hardcoded aqui é o CAMINHO de cada
// artefato e a ÂNCORA de prosa de cada número — nunca o número. As duas se
// auto-validam: artefato que sai de lugar reprova na leitura, âncora que
// apodrece reprova no `isNotEmpty` do gate dos dois idiomas.
// ===========================================================================

/// A pasta das suítes de arquitetura, relativa à raiz do pacote.
const String kPastaDeSuitesDeArquitetura = 'test/architecture';

/// O catálogo vendorizado do provedor de ícones, a partir da raiz do repo.
///
/// Cruza a fronteira de pacote de propósito: quem publica a contagem de ícones
/// é o `flocks_phosphor`, e derivá-la de qualquer outro lugar seria medir uma
/// coisa e afirmar outra. Não dá para importar — o `flocks_phosphor` não está
/// nas dependências deste pacote, nem em `dev_dependencies` —, então é leitura
/// de arquivo, e a ausência dele vira `skip:` e não vermelho.
const String kArtefatoDeIcones =
    'packages/flocks_phosphor/vendor/phosphor_icons.json';

/// Os numerais que a abertura do README da raiz escreve em palavras.
const List<String> kNumeraisEmPalavras = <String>[
  'zero',
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
  'ten',
  'eleven',
  'twelve',
];

/// Um número que a prosa publicada afirma, com o artefato que o produz.
class _NumeroPublicado {
  _NumeroPublicado({
    required this.valor,
    required this.fonte,
    required this.conserto,
    required this.ancoras,
  });

  final int valor;

  /// O caminho do artefato de onde [valor] saiu — vai na mensagem de falha, para
  /// que ela diga onde medir em vez de só qual número esperava.
  final String fonte;

  /// O que fazer quando os dois divergem.
  final String conserto;

  /// O que segue o número na prosa, um por idioma.
  final List<String> ancoras;
}

/// Os números cujo artefato vive neste pacote.
///
/// Derivados DENTRO do teste que os usa, e não no corpo de `main()`: o corpo
/// roda na coleção, e uma leitura que estoura lá derruba o arquivo inteiro em
/// vez de reprovar um caso.
List<_NumeroPublicado> _numerosDoPacote() => <_NumeroPublicado>[
  _NumeroPublicado(
    valor: (jsonDecode(_lido(File(kCatalogPath))) as List<Object?>).length,
    fonte: kCatalogPath,
    conserto:
        'O JSON é a fonte, e o `catalog_freshness_test` já o mantém em dia com '
        'o código — então é a prosa da página que está velha.',
    ancoras: const <String>['components', 'componentes'],
  ),
  _NumeroPublicado(
    valor:
        (jsonDecode(_lido(File(kUseCaseCountPath)))
                as Map<String, Object?>)['useCases']!
            as int,
    fonte: kUseCaseCountPath,
    conserto:
        'O artefato é a fonte, e o `use_case_count_test` já o mantém em dia com '
        'as anotações `@widgetbook.UseCase` — então é a prosa da página que '
        'está velha. Se o artefato é que ficou atrás, rode `$kCountCommand`.',
    ancoras: const <String>['live examples', 'exemplos vivos'],
  ),
  _NumeroPublicado(
    valor: _suitesDeArquitetura(),
    fonte: kPastaDeSuitesDeArquitetura,
    conserto:
        'A contagem é o próprio diretório: acrescentar ou tirar uma suíte muda '
        'o número, e as duas homes têm de acompanhar no mesmo commit. O '
        '`catalog_freshness_test` cobra o mesmo número no README do pacote.',
    ancoras: const <String>['architecture suites', 'suítes de arquitetura'],
  ),
];

/// A contagem de ícones, do catálogo vendorizado do provedor.
_NumeroPublicado _numeroDeIcones(Directory raizDoRepo) => _NumeroPublicado(
  valor:
      ((jsonDecode(_lido(File('${raizDoRepo.path}/$kArtefatoDeIcones')))
                  as Map<String, Object?>)['icons']!
              as List<Object?>)
          .length,
  fonte: kArtefatoDeIcones,
  conserto:
      'O catálogo vendorizado é a fonte — ele vem fixado numa tag do upstream. '
      'Se ele cresceu, é a prosa das páginas que tem de acompanhar.',
  // A cauda "× 6" é parte da âncora, e não número solto à espera de apodrecer:
  // é ela que amarra a contagem ao provedor de seis pesos, em vez de a qualquer
  // provedor que um dia cite a própria. Auto-valida-se pelo `isNotEmpty`, do
  // mesmo modo que `kClasseDoLangSwitch` e `kPastaDoIdiomaSecundario`.
  ancoras: const <String>['icons × 6 weights', 'ícones × 6 pesos'],
);

/// A razão do skip do gate de ícones, ou `null` quando ele tem de morder.
String? _semCatalogoDeIcones(Directory raizDoRepo) =>
    File('${raizDoRepo.path}/$kArtefatoDeIcones').existsSync()
    ? null
    : 'o `flocks_phosphor` não está ao lado deste pacote — '
          '$kArtefatoDeIcones não existe';

/// A contagem de suítes de arquitetura.
///
/// As cinco operações são as do `catalog_freshness_test.dart`, que cobra este
/// mesmo número no README do pacote. Cópia deliberada, e não descuido: lá a
/// contagem é expressão inline dentro do closure de um `test()`, não função
/// importável, e extrair um helper comum exigiria editar aquele arquivo — fora
/// desta raia, e registrado como follow-up. Relativa ao cwd (a raiz do pacote,
/// que é onde o `flutter test` roda) e não a `raizDoRepo`, justamente para ser a
/// MESMA derivação de lá: duas derivações da mesma coisa é a próxima deriva.
int _suitesDeArquitetura() {
  final Directory dir = Directory(kPastaDeSuitesDeArquitetura);
  expect(
    dir.existsSync(),
    isTrue,
    reason:
        '$kPastaDeSuitesDeArquitetura não existe a partir do cwd '
        '(${Directory.current.path}). O `flutter test` roda na raiz do pacote; '
        'se isso mudou, é esta derivação que muda.',
  );
  return dir
      .listSync()
      .whereType<File>()
      .where((File f) => f.path.endsWith('_test.dart'))
      .length;
}

/// O conteúdo de [arquivo], reprovando com frase legível quando ele não existe.
String _lido(File arquivo) {
  expect(
    arquivo.existsSync(),
    isTrue,
    reason:
        '${arquivo.path} não existe: o gate perdeu o artefato de onde deriva o '
        'número, e um número sem artefato é o que estes gates existem para '
        'impedir.',
  );
  return arquivo.readAsStringSync();
}

/// A landing de `site/[rel]`, do inventário derivado — nunca de caminho fixo.
///
/// Reprova em vez de devolver `null`: dentro do repo, que é o que o `skip:` de
/// quem chama garante, a página TEM de existir. "Não achei a página" é
/// exatamente o vermelho que o `if (!file.existsSync()) return` engolia.
_PaginaDoSite _landing(Directory raizDoRepo, String rel) {
  final _Site site = _Site.de(raizDoRepo);
  final _PaginaDoSite? pagina = site.porCaminho(rel);
  expect(
    pagina,
    isNotNull,
    reason:
        'site/$rel não está no inventário de ${site.dir.path}. O que há lá: '
        '${site.paginas.map((_PaginaDoSite p) => p.rel).join(', ')}. A landing '
        'saiu de lugar, ou a âncora deste gate apodreceu.',
  );
  return pagina!;
}

/// A prosa de uma página, para procurar número: o texto do corpo, o do `<title>`
/// e TODO valor de atributo de TODO elemento, um pedaço por linha.
///
/// Os atributos entram porque parte dos números vive em `content=` de `<meta>` —
/// e entram por VARREDURA, não por lista: fixar "os dois metas de descrição"
/// seria a lista de páginas com jaleco que o banner de estrutura condena, e o
/// número seguinte a nascer num `aria-label` escaparia calado.
///
/// Unidos por `\n` para que nenhum casamento atravesse a fronteira entre dois
/// pedaços, e com o espaço em branco colapsado dentro de cada um porque a prosa
/// das páginas quebra linha no meio das frases — em `site/mcp/index.html` o
/// número e o substantivo caem em linhas diferentes.
String _prosaDe(_PaginaDoSite pagina) {
  final List<String> pedacos = <String>[pagina.documento.body?.text ?? ''];
  for (final dom.Element titulo in pagina.documento.getElementsByTagName(
    'title',
  )) {
    pedacos.add(titulo.text);
  }
  final dom.Element? raiz = pagina.documento.documentElement;
  if (raiz != null) {
    _coletarAtributos(raiz, pedacos);
  }
  return pedacos
      .map((String p) => p.replaceAll(RegExp(r'\s+'), ' ').trim())
      .join('\n');
}

void _coletarAtributos(dom.Element elemento, List<String> saida) {
  saida.addAll(elemento.attributes.values);
  for (final dom.Element filho in elemento.children) {
    _coletarAtributos(filho, saida);
  }
}

/// Os números que antecedem [ancora] em [prosa] — `131 components` → 131.
///
/// Devolve TODAS as ocorrências: o mesmo número aparece cinco vezes na home
/// inglesa, e uma delas envelhecer sozinha é justo o caso a pegar.
///
/// Vem do `_numbersBefore` do `catalog_freshness_test.dart`, COM UMA CORREÇÃO.
/// Lá o padrão é `(\d+)\s+`, que sobre "1.512 ícones" casa **512**: o `\d+`
/// começa depois do separador de milhar. Aqui a classe é `(?<!\d)(\d[\d.,]*)`,
/// e o separador cai antes do `int.parse` — o que de quebra torna a comparação
/// agnóstica de locale, já que a home inglesa escreve `1,512` e a portuguesa
/// `1.512`. Unificar os dois helpers exigiria mexer fora desta raia; está
/// registrado como follow-up, e o conserto do separador vai com ele.
List<int> _numerosAntesDe(String prosa, String ancora) =>
    RegExp(r'(?<!\d)(\d[\d.,]*)\s+' + RegExp.escape(ancora))
        .allMatches(prosa)
        .map(
          (RegExpMatch m) =>
              int.parse(m.group(1)!.replaceAll(RegExp('[.,]'), '')),
        )
        .toList();

/// Os pacotes de `packages/`, e se cada um vai ao pub.dev.
///
/// Pelo glob dos diretórios — o mesmo conjunto que o job `changelog (pub.dev)`
/// do `ci.yml` percorre —, e não pelo `workspace:` da raiz, que o
/// `test/release/release_versioning_test.dart` usa: a tabela do README enumera
/// DIRETÓRIOS de pacote, e os `example/` que também são membros do workspace não
/// têm linha lá nem deveriam ter. O padrão de leitura (`^name:` e
/// `^publish_to:` por regex, sem parser de YAML) é o daquele arquivo.
Map<String, bool> _pacotesDeDiretorio(Directory raizDoRepo) {
  final Directory dir = Directory('${raizDoRepo.path}/packages');
  final List<Directory> subpastas = dir.existsSync()
      ? (dir.listSync().whereType<Directory>().toList()
          ..sort((Directory a, Directory b) => a.path.compareTo(b.path)))
      : <Directory>[];
  final Map<String, bool> pacotes = <String, bool>{};
  for (final Directory subpasta in subpastas) {
    final File pubspec = File('${subpasta.path}/pubspec.yaml');
    if (!pubspec.existsSync()) {
      continue;
    }
    final String texto = pubspec.readAsStringSync();
    final RegExpMatch? nome = RegExp(
      r'^name:\s*(\S+)\s*$',
      multiLine: true,
    ).firstMatch(texto);
    expect(
      nome,
      isNotNull,
      reason:
          '${pubspec.path} não tem uma linha `name:` legível. Sem ela o pacote '
          'desapareceria da derivação em silêncio.',
    );
    pacotes[nome!.group(1)!] = !RegExp(
      r'^publish_to:\s*none\s*$',
      multiLine: true,
    ).hasMatch(texto);
  }
  return pacotes;
}

/// Os pacotes que a tabela do README da raiz nomeia, ordenados.
///
/// A âncora é o link de diretório — ``[`nome`](packages/nome)`` —, e o rótulo é
/// cobrado contra o destino: uma linha que anuncia um pacote e aponta para o
/// diretório de outro passa despercebida numa leitura rápida e é exatamente o
/// que apodrece quando um pacote é renomeado.
List<String> _pacotesCitadosNaTabela(String readme) {
  final List<String> nomes = <String>[];
  for (final RegExpMatch linha in RegExp(
    r'\[`([a-z0-9_]+)`\]\(packages/([a-z0-9_]+)\)',
  ).allMatches(readme)) {
    expect(
      linha.group(2),
      linha.group(1),
      reason:
          'A tabela do README da raiz rotula `${linha.group(1)}` e aponta para '
          '`packages/${linha.group(2)}`.',
    );
    nomes.add(linha.group(1)!);
  }
  return nomes..sort();
}

/// O numeral de [numero] em palavras, como a abertura do README o escreve.
String _emPalavras(int numero) {
  expect(
    numero,
    lessThan(kNumeraisEmPalavras.length),
    reason:
        'A tabela de numerais deste gate para em '
        '${kNumeraisEmPalavras.length - 1} e a contagem é $numero. Estenda a '
        'tabela — ela existe porque a abertura do README escreve a contagem em '
        'palavras, e palavra apodrece igual a dígito.',
  );
  return kNumeraisEmPalavras[numero];
}
