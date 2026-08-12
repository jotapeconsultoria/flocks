// O README e o `pubspec.yaml` não podem se contradizer sobre como instalar.
//
// O README instruía `flocks: ^1.0.0` — sintaxe de dependência hospedada —
// enquanto o pubspec tinha `publish_to: none`. As duas não podem ser verdade, e
// a copy de /instalar do site sai desse mesmo texto: a contradição não fica no
// repositório, ela é publicada.
//
// O destino está decidido (pub.dev, ver `doc/EXTRACAO.md`), mas o pacote ainda
// não foi publicado. Enquanto `publish_to: none` estiver lá, o README tem de
// dizer isso na cara — e no dia em que a linha sair, este teste cobra que o
// aviso saia junto. É o mesmo princípio do gate de contagem: o número (ou a
// instrução) não pode envelhecer em silêncio.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
// O parser de HTML do próprio `flocks` (dependência DIRETA, usada pelos
// organisms de conteúdo). Os gates de estrutura do site abaixo julgam o DOM,
// e não o texto: é o DOM que o buscador vê. `xml` e `path` também estão no
// lock, mas só como transitivas — importá-las seria dependência não declarada,
// que some no dia em que outra árvore mudar. Daí o sitemap sair por regex.
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import 'entry_root_tokens.dart';

/// A marca que o README precisa carregar enquanto o pacote não está publicado.
/// Curta de propósito: é a âncora do gate, não a frase inteira.
///
/// Em inglês desde que o README passou a ser inglês — o pacote é internacional
/// a partir da publicação. A âncora acompanha a prosa: um marcador em português
/// num README inglês passaria a nunca casar, e o gate ficaria verde por
/// vacuidade em vez de por acerto.
const String kUnpublishedMarker = 'not yet published';

/// O bloco de dependência hospedada que o README instrui.
const String kHostedDependency = 'flocks: ^0.1.0';

void main() {
  final String pubspec = File('pubspec.yaml').readAsStringSync();
  final String readme = File('README.md').readAsStringSync();

  /// `publish_to: none` presente = o pacote não vai para o pub.dev ainda.
  final bool blocked = RegExp(
    r'^publish_to:\s*none\s*$',
    multiLine: true,
  ).hasMatch(pubspec);

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

  test('enquanto não publicado, o README avisa', () {
    if (!blocked) {
      return;
    }
    expect(
      readme,
      contains(kUnpublishedMarker),
      reason:
          'O pubspec tem `publish_to: none`, então `$kHostedDependency` ainda '
          'não resolve para ninguém. O README precisa dizer isso onde instrui '
          'a instalação — senão publica uma instrução que não funciona.',
    );
  });

  test('depois de publicado, o aviso sai', () {
    if (blocked) {
      return;
    }
    expect(
      readme,
      isNot(contains(kUnpublishedMarker)),
      reason:
          'O `publish_to: none` saiu do pubspec, então o pacote foi publicado '
          '— o aviso de "ainda não publicado" virou mentira. Tire-o do README.',
    );
  });

  // A copy de /instalar do site sai deste mesmo texto — então o site entra no
  // mesmo gate. As páginas vivem na raiz do repo (`site/`), fora do tarball:
  // um checkout vindo do pub.dev não as tem, e o guard de existência abaixo é
  // o que mantém a suíte verde lá sem afrouxar o gate aqui no repo.
  //
  // O marcador é por página porque a prosa é por idioma: a âncora inglesa
  // numa página portuguesa nunca casaria e o gate ficaria verde por vacuidade
  // — o mesmo motivo de o `kUnpublishedMarker` ter virado inglês com o README.
  const Map<String, String> kSitePages = <String, String>{
    '../../site/index.html': kUnpublishedMarker,
    '../../site/pt/index.html': 'não publicado no pub.dev',
  };

  for (final MapEntry<String, String> page in kSitePages.entries) {
    test('site: ${page.key} acompanha o estado de publicação', () {
      final File file = File(page.key);
      if (!file.existsSync()) {
        return;
      }
      final String html = file.readAsStringSync();
      expect(
        html,
        contains(kHostedDependency),
        reason:
            'A landing instrui a instalação e a copy sai do README — se a '
            'dependência hospedada mudou, mude as duas juntas.',
      );
      if (blocked) {
        expect(
          html,
          contains(page.value),
          reason:
              'O pubspec tem `publish_to: none`, então a instrução hospedada '
              'da landing não resolve para ninguém. A página precisa do aviso '
              '— senão o site publica uma instrução que não funciona.',
        );
      } else {
        expect(
          html,
          isNot(contains(page.value)),
          reason:
              'O pacote foi publicado — o aviso de "ainda não publicado" da '
              'landing virou mentira. Tire-o da página no mesmo commit.',
        );
      }
    });

    test('site: ${page.key} monta a raiz de entrada', () {
      // A outra metade deste gate está no `readme_example_test.dart`, sobre o
      // README e o `example/`. A copy de instalação acima e a raiz aqui são a
      // mesma classe de problema: texto mantido à mão em superfícies que ninguém
      // obriga a andarem juntas. A diferença é que uma instrução de instalação
      // errada não resolve, e uma raiz sem `Overlay` resolve, compila, e só
      // quebra no gesto do visitante.
      final File file = File(page.key);
      if (!file.existsSync()) {
        return;
      }
      final String? codigo = _blocoDeCodigoComRunApp(file.readAsStringSync());
      expect(
        codigo,
        isNotNull,
        reason:
            'Nenhum bloco de código com `runApp` em ${page.key}. Guarda contra '
            'vacuidade: sem ela, mudar a marcação do bloco faria as asserções '
            'de baixo passarem por falta de entrada.',
      );
      for (final String token in kTokensDaRaizDeEntrada) {
        expect(
          codigo,
          contains(token),
          reason:
              'O bloco de código de ${page.key} parou de montar `$token`. A '
              'landing é deploy contínuo: no ar, ela passa a contradizer o '
              'README, que documenta a exigência. O critério inteiro está em '
              '`entry_root_tokens.dart`.',
        );
      }
    });
  }

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
  // faz os adaptadores resolverem `flocks` localmente enquanto o pacote não
  // está no pub.dev; tirá-la quebra o `pub get` da raiz. Publicar não depende
  // dela em nada, então não há acoplamento a cobrar.

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
String? _blocoDeCodigoComRunApp(String html) {
  for (final dom.Element code
      in html_parser.parse(html).getElementsByTagName('code')) {
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
