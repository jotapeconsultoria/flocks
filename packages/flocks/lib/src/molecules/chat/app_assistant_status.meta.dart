import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppAssistantStatus`. Registrado em `flocksCatalog`.
const AppComponentMeta appAssistantStatusMeta = AppComponentMeta(
  id: 'app_assistant_status',
  name: 'AppAssistantStatus',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  since: 'flocks@1.1.0',
  summary: LocalizedText(
    en: 'Assistant step label, with a smooth transition.',
    pt: 'Rótulo de etapa do assistente, com transição suave.',
  ),
  description: LocalizedText(
    en: 'Shows the current step ("Fetching data"…) and animates the swap (fade + rise) on every label change. Optionally prefixes an AppTypingIndicator. Announces as a status region; honors reduce-motion.',
    pt:
        'Mostra a etapa atual ("Buscando dados"…) e anima o swap (fade + subida) '
        'a cada troca de label. Opcionalmente prefixa um AppTypingIndicator. '
        'Anuncia como região de status; respeita reduce-motion.',
  ),
  whenToUse: LocalizedList(
    en: <String>['"Thinking/working" feedback for an AI reply.'],
    pt: <String>['Feedback "pensando/trabalhando" de uma resposta de IA.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'label', type: 'String', isRequired: true),
    PropMeta(name: 'showIndicator', type: 'bool', defaultValue: 'true'),
    PropMeta(name: 'style', type: 'TextStyle?'),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(
        en: 'Assistant\'s current step',
        pt: 'Passo corrente do assistente',
      ),
      code: 'AppAssistantStatus(label: \'Consultando os veículos…\')',
      description: LocalizedText(
        en: 'A label change is announced; the typing effect honors reduce-motion.',
        pt: 'Troca de rótulo é anunciada; o efeito de digitação respeita reduce-motion.',
      ),
    ),
  ],
  a11y: LocalizedText(
    en: 'Status region (liveRegion) — a change announces the new label.',
    pt: 'Região de status (liveRegion) — muda anuncia o novo rótulo.',
  ),
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_typing_indicator'],
);
