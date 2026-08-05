import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppTimeline`. Registrado em `flocksCatalog`.
const AppComponentMeta appTimelineMeta = AppComponentMeta(
  id: 'app_timeline',
  name: 'AppTimeline',
  category: ComponentCategory.organism,
  status: ComponentStatus.migrated,
  since: 'flocks@1.2.0',
  summary: LocalizedText(
    en: 'Chronological list of events that happened, newest first.',
    pt: 'Lista cronológica de eventos que aconteceram, do mais recente ao mais antigo.',
  ),
  description: LocalizedText(
    en: 'A vertical rail with a marker per event and a content slot beside it. It is a semantic LIST, navigable item by item; the rail is decoration and leaves the accessibility tree.',
    pt:
        'Trilho vertical com um marcador por evento e um slot de conteúdo ao '
        'lado. É uma LISTA semântica, navegável item a item; o trilho é '
        'decoração e sai da árvore de acessibilidade.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'An audit trail or an activity feed.',
      'Any open-ended chronology of things that already happened.',
    ],
    pt: <String>[
      'Trilha de auditoria ou feed de atividade.',
      'Toda cronologia sem fim de coisas que já aconteceram.',
    ],
  ),
  whenNotToUse: LocalizedList(
    en: <String>[
      'Progress through a known process → AppStepper. A stepper has a current step, future steps and the promise of a last one; a trail has none of those, and using one for the other makes the screen promise a sequence that does not exist.',
      'Tabular data with sortable columns → AppDataTable.',
    ],
    pt: <String>[
      'Progresso num processo conhecido → AppStepper. O stepper tem passo atual, passos futuros e a promessa de um último; uma trilha não tem nada disso, e trocar um pelo outro faz a tela prometer uma sequência que não existe.',
      'Dado tabular com colunas ordenáveis → AppDataTable.',
    ],
  ),
  props: <PropMeta>[
    PropMeta(
      name: 'itemBuilder',
      type: 'NullableIndexedWidgetBuilder',
      isRequired: true,
    ),
    PropMeta(name: 'itemCount', type: 'int', isRequired: true),
    PropMeta(name: 'controller', type: 'ScrollController?'),
    PropMeta(name: 'footer', type: 'Widget?'),
    PropMeta(name: 'markerBuilder', type: 'IndexedWidgetBuilder?'),
    PropMeta(name: 'shrinkWrap', type: 'bool', defaultValue: 'false'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Audit feed', pt: 'Feed de auditoria'),
      code:
          'AppTimeline(\n  itemCount: eventos.length,\n  itemBuilder: (BuildContext c, int i) => AuditEventTile(eventos[i]),\n  footer: carregando ? const AppCircularLoading() : null,\n)',
    ),
  ],
  a11y: LocalizedText(
    en: 'A semantic list with explicit child nodes; the rail is excluded from semantics so a screen reader hears events, not lines.',
    pt:
        'Lista semântica com nós filhos explícitos; o trilho sai da semântica '
        'para que o leitor de tela ouça eventos, e não linhas.',
  ),
  crossPlatform: true,
  themeAware: true,
  reducesMotion: true,
);
