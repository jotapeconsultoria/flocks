import '../../meta/app_component_meta.dart';

/// Descritor MCP do `AppTypingIndicator`. Registrado em `flocksCatalog`.
const AppComponentMeta appTypingIndicatorMeta = AppComponentMeta(
  id: 'app_typing_indicator',
  name: 'AppTypingIndicator',
  category: ComponentCategory.molecule,
  status: ComponentStatus.migrated,
  summary: LocalizedText(
    en: 'Three "typing…" dots, motion-aware.',
    pt: 'Três pontinhos "digitando…", motion-aware.',
  ),
  description: LocalizedText(
    en: 'Dots that rise and fall in sequence, for "is typing" (WhatsApp) or "assistant thinking". Under reduce-motion they stay still; the label is always exposed.',
    pt:
        'Pontos que sobem/descem em sequência, para "está digitando" (WhatsApp) '
        'ou "assistente pensando". Sob reduce-motion ficam estáticos; o rótulo é '
        'sempre exposto.',
  ),
  whenToUse: LocalizedList(
    en: <String>[
      'Signalling that the other party or the assistant is composing.',
    ],
    pt: <String>['Sinalizar que o interlocutor/assistente está compondo.'],
  ),
  props: <PropMeta>[
    PropMeta(name: 'color', type: 'Color?'),
    PropMeta(name: 'dotSize', type: 'double', defaultValue: '7'),
    PropMeta(
      name: 'semanticLabel',
      type: 'String',
      defaultValue: "'Digitando'",
    ),
  ],
  examples: <CodeExample>[
    CodeExample(
      title: LocalizedText(en: 'Assistant typing', pt: 'Assistente digitando'),
      code: 'AppTypingIndicator()',
      description: LocalizedText(
        en: 'With reduce-motion on, the dots stop — the live region\'s label keeps announcing.',
        pt: 'Com reduce-motion ligado os pontos param — o rótulo da região viva continua anunciando.',
      ),
    ),
  ],
  a11y: LocalizedText(
    en: 'A labelled live region — the reader does not wait for the animation.',
    pt: 'Região viva rotulada — o leitor não espera a animação.',
  ),
  themeAware: true,
  reducesMotion: true,
  related: <String>['app_assistant_status'],
);
