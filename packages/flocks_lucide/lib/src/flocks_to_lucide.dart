/// A tradução de um slug do Flocks para o nome no Lucide.
///
/// Os dois vocabulários não coincidem: o Flocks chama `close` o que o Lucide
/// chama `x`, e `error-circle` o que ele chama `circle-alert`. Sem esta tabela,
/// o contrato de `AppIconToken` não desenharia — que é justamente o que este
/// pacote precisa entregar.
///
/// Só as divergências entram. Slug ausente daqui é usado como está, e é isso
/// que dá acesso aos ícones do Lucide pelo nome original: quem quiser
/// `air-vent` escreve `air-vent`, sem precisar de token. 23 dos 55 tokens já
/// têm o mesmo nome nos dois lados, e por isso não aparecem aqui.
///
/// Repetições são esperadas: o Lucide não desenha um PDF diferente de um
/// documento, nem uma planilha diferente de um CSV, então `pdf`, `file-pdf`,
/// `file-doc` e `file-text` chegam ao mesmo glifo, como `csv` e `file-xls`.
/// Inventar diferença onde o set não tem produziria ícone errado, não ícone
/// específico.
const Map<String, String> kFlocksToLucide = <String, String>{
  'add': 'plus',
  'alert': 'triangle-alert',
  'api-cloud': 'cloud',
  'attachment': 'paperclip',
  'audio': 'file-audio',
  'cancel': 'circle-x',
  'chat': 'message-circle',
  'check-circle': 'circle-check',
  'close': 'x',
  'csv': 'file-spreadsheet',
  'dashboard': 'layout-dashboard',
  'drag-arrow': 'move',
  'error-circle': 'circle-alert',
  'file-doc': 'file-text',
  'file-pdf': 'file-text',
  'file-ppt': 'presentation',
  'file-txt': 'file-type',
  'file-xls': 'file-spreadsheet',
  'filter': 'funnel',
  'group': 'users',
  'hyperlink': 'link',
  'image-landscape': 'file-image',
  'info-circle': 'info',
  'microphone': 'mic',
  'pdf': 'file-text',
  'refresh': 'refresh-cw',
  'remove': 'minus',
  'stop': 'circle-stop',
  'support': 'headset',
  'swap-arrow': 'arrow-left-right',
  'sync': 'refresh-cw',
  'video-play': 'file-video',
  'zip-file': 'file-archive',
};
