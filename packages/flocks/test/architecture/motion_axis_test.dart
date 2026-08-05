import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Durações literais que **não** são animação, e por isso não passam por
/// `AppMotion.resolve` nem viram token de `AppDurations`.
///
/// A chave é `path:linha-do-literal` não — é só o path; um arquivo entra aqui
/// inteiro. Toda entrada carrega o motivo: se o motivo deixar de valer, a
/// duração vira token.
const Map<String, String> kNonAnimationDurations = <String, String>{
  // Tempo de EXIBIÇÃO (quanto o conteúdo fica na tela), não de transição.
  // Encurtar isso é decisão de UX de leitura, não de motion; e reduce-motion
  // não deve fazer um aviso sumir instantaneamente.
  'molecules/tooltip/app_tooltip.dart': 'janela do tooltip por long-press',
  'molecules/copy/app_copy_button.dart': 'quanto o "copiado!" fica visível',
  'molecules/snackbar/show_app_snackbar.dart':
      'default público de `duration` (tempo em tela)',
  'molecules/alert/show_app_overlay.dart':
      'default público de `duration` (tempo em tela)',

  // Velocidade de DIGITAÇÃO exposta na API pública: o chamador calibra o ritmo
  // do typewriter por caractere. Não é uma transição do design system.
  'molecules/chat/app_assistant_status.dart':
      'default público de `charDuration`',

  // Temporizadores de INTENÇÃO (debounce/grace). Medem paciência do usuário,
  // não movimento na tela — colapsá-los com reduce-motion quebraria a UX.
  'molecules/popover/app_popover.dart': 'grace period do hover antes de fechar',
  'organisms/omni_search/app_omni_search.dart': 'debounce da busca',

  // Piso técnico: `animateTo`/snap do scroll exigem duração > 0. O arquivo já
  // consulta `AppMotion.enabled` e só cai neste valor quando é para NÃO animar.
  'organisms/bottom_sheets/bottom_sheet_engine.dart':
      'piso de 1ms exigido pelo animateTo no caminho de reduce-motion',
};

/// Arquivos que animam mas **não** decidem sobre reduce-motion: delegam a um
/// helper nomeado. O valor é o arquivo do helper — que o teste cobra que
/// termine em `AppMotion.`, para a corrente de delegação não apodrecer.
///
/// Espelha `kGlassDelegated` do eixo glass ("monta o overlay, mas quem pinta é
/// outro").
const Map<String, String> kMotionDelegates = <String, String>{
  // As três células (dia/mês/ano) de cada picker chamam `dateCellAnimation`,
  // que é onde mora a decisão. Repetir `AppMotion.resolve` em 6 sites seria
  // seis chances de esquecer um.
  'molecules/date_picker/app_date_picker.dart':
      'molecules/date_picker/date_picker_core.dart',
  'molecules/date_picker/app_date_range_picker.dart':
      'molecules/date_picker/date_picker_core.dart',
};

void main() {
  final List<File> dartFiles = Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((FileSystemEntity f) => f.path.endsWith('.dart'))
      // `tokens/` é onde os literais moram por definição; `motion/` é a camada
      // que IMPLEMENTA o eixo (é ela quem chama `Curves.` e `Duration()` cru).
      .where(
        (FileSystemEntity f) =>
            !f.path.contains('lib/src/tokens/') &&
            !f.path.contains('lib/src/motion/'),
      )
      // Artefatos do componente carregam exemplos em string que casariam com
      // as marcas abaixo. Só código de runtime conta.
      .where(
        (FileSystemEntity f) =>
            !f.path.endsWith('.meta.dart') && !f.path.endsWith('.preview.dart'),
      )
      .toList();

  String rel(File f) {
    final String p = f.path.replaceAll(r'\', '/');
    final int i = p.indexOf('lib/src/');
    return i == -1 ? p : p.substring(i + 'lib/src/'.length);
  }

  /// Código do arquivo sem as linhas de comentário — dartdoc cita `Curves.` e
  /// `Duration(...)` em exemplo, e exemplo não roda.
  String codeOf(File f) => f
      .readAsLinesSync()
      .where((String l) {
        final String t = l.trimLeft();
        return !t.startsWith('///') &&
            !t.startsWith('//') &&
            !t.startsWith('*');
      })
      .join('\n');

  // `\b` nas duas pontas: sem a borda da ESQUERDA, `Curves.` casa dentro de
  // `AppCurves.` e `AnimatedRotation` dentro de `AppAnimatedRotation` — o que
  // inflava a contagem de dívida de 7 para 72 e escondia o tamanho real.
  final RegExp rawCurves = RegExp(r'\bCurves\.');
  final RegExp durationLiteral = RegExp(
    r'\bDuration\((milliseconds|seconds|microseconds):',
  );

  /// Primitivos de animação CRUS do Flutter — os que recebem uma `Duration` e
  /// a obedecem sem perguntar nada a ninguém.
  final RegExp rawAnimationPrimitive = RegExp(
    r'\b(Animated(Container|Opacity|Positioned|Align|Padding'
    r'|DefaultTextStyle|Switcher|Size|Rotation|Scale|Slide|Builder)'
    r'|AnimationController|TweenAnimationBuilder|CurvedAnimation)\(',
  );

  /// Animação IMPERATIVA: quem dispara movimento fora do build.
  final RegExp imperativeAnimation = RegExp(
    r'(Scrollable\.ensureVisible\(|\.animateTo\(|\.animateToPage\(|\.repeat\()',
  );

  test('nenhum componente usa Curves.* cru (usa os tokens de AppCurves)', () {
    final List<String> offenders = <String>[
      for (final File f in dartFiles)
        if (rawCurves.hasMatch(codeOf(f))) rel(f),
    ];
    expect(
      offenders,
      isEmpty,
      reason:
          'Curva de animação é token: use AppCurves.standard/emphasized/'
          'decelerate/accelerate/emphasizedOvershoot (ou AppCurves.linear '
          'quando a forma vem de Intervals encadeados). Offenders: $offenders',
    );
  });

  test('todo literal de Duration fora de tokens/ está classificado', () {
    final List<String> unclassified = <String>[
      for (final File f in dartFiles)
        if (!kNonAnimationDurations.containsKey(rel(f)) &&
            durationLiteral.hasMatch(codeOf(f)))
          rel(f),
    ];
    expect(
      unclassified,
      isEmpty,
      reason:
          'Duração de ANIMAÇÃO é token de AppDurations. Se este literal não é '
          'animação (tempo em tela, debounce, default de API pública), '
          'adicione a kNonAnimationDurations com o motivo: $unclassified',
    );
  });

  test('kNonAnimationDurations não tem entrada obsoleta', () {
    final Set<String> onDisk = dartFiles.map(rel).toSet();
    final List<String> stale = <String>[
      for (final String p in kNonAnimationDurations.keys)
        if (!onDisk.contains(p) ||
            !durationLiteral.hasMatch(
              File('lib/src/$p').existsSync() ? codeOf(File('lib/src/$p')) : '',
            ))
          p,
    ];
    expect(
      stale,
      isEmpty,
      reason:
          'Entrada da lista que não corresponde mais a um literal em disco '
          '(arquivo renomeado, ou a duração já virou token). Remova: $stale',
    );
  });

  // O assert que impede a recaída — e o que pegou o bug real desta rodada:
  // `dateCellAnimation` reimplementava METADE do AppMotion (só o liga/desliga
  // do design system) e ignorava as duas fontes de reduce-motion do SO. O
  // calendário animava com "Reduzir movimento" ligado.
  test('todo arquivo que anima consulta AppMotion', () {
    final List<String> offenders = <String>[];
    for (final File f in dartFiles) {
      final String code = codeOf(f);
      final bool animates =
          rawAnimationPrimitive.hasMatch(code) ||
          imperativeAnimation.hasMatch(code);
      if (!animates) continue;
      if (kMotionDelegates.containsKey(rel(f))) continue;
      if (!code.contains('AppMotion.')) offenders.add(rel(f));
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'Quem monta animação crua decide sozinho sobre reduce-motion. Passe '
          'a duração por AppMotion.resolve(context, token) — ou troque o '
          'primitivo por um widget de lib/src/motion/, que já faz isso. '
          'Offenders: $offenders',
    );
  });

  test('a delegação de motion termina em AppMotion', () {
    final List<String> broken = <String>[];
    kMotionDelegates.forEach((String path, String helper) {
      final File helperFile = File('lib/src/$helper');
      if (!helperFile.existsSync() ||
          !codeOf(helperFile).contains('AppMotion.')) {
        broken.add('$path → $helper');
      }
    });
    expect(
      broken,
      isEmpty,
      reason:
          'O helper para o qual estes arquivos delegam não consulta mais '
          'AppMotion — a delegação virou um buraco silencioso: $broken',
    );
  });
}
