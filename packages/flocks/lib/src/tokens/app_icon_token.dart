/// O contrato de ícone do Flocks: os nomes que o pacote garante existir.
///
/// Todo componente de `lib/src` desenha ícone a partir daqui — são 55 nomes,
/// contra os ~880 do catálogo [AppIcons]. A diferença importa: os 55 são o que
/// um [AppIconProvider] precisa saber servir para o design system funcionar
/// inteiro; o resto é conveniência para quem escreve o app.
///
/// **É um `extension type` sobre `String`, e isso é deliberado.** Em tempo de
/// execução um token É o seu slug, sem custo nenhum, e `implements String` faz
/// com que ele seja aceito em qualquer parâmetro `String` que já exista — os 33
/// campos `String? icon` dos componentes e os call sites dos apps continuam
/// compilando sem uma linha de mudança. O ganho é de leitura e de contrato:
/// [values] é a lista que o teste de arquitetura cobra do provider padrão.
///
/// O slug é o nome do arquivo sem extensão (`chevron-down` →
/// `assets/icons/chevron-down.svg`). Não é URL: quem transforma slug em pixel é
/// o provider, e trocá-lo troca o set inteiro.
extension type const AppIconToken(String slug) implements String {
  /// `add.svg`
  static const AppIconToken add = AppIconToken('add');

  /// `alert.svg`
  static const AppIconToken alert = AppIconToken('alert');

  /// `api-cloud.svg`
  static const AppIconToken apiCloud = AppIconToken('api-cloud');

  /// `arrow-up.svg`
  static const AppIconToken arrowUp = AppIconToken('arrow-up');

  /// `attachment.svg`
  static const AppIconToken attachment = AppIconToken('attachment');

  /// `audio.svg`
  static const AppIconToken audio = AppIconToken('audio');

  /// `calendar.svg`
  static const AppIconToken calendar = AppIconToken('calendar');

  /// `cancel.svg`
  static const AppIconToken cancel = AppIconToken('cancel');

  /// `car.svg`
  static const AppIconToken car = AppIconToken('car');

  /// `chat.svg`
  static const AppIconToken chat = AppIconToken('chat');

  /// `check.svg`
  static const AppIconToken check = AppIconToken('check');

  /// `check-circle.svg`
  static const AppIconToken checkCircle = AppIconToken('check-circle');

  /// `chevron-down.svg`
  static const AppIconToken chevronDown = AppIconToken('chevron-down');

  /// `chevron-left.svg`
  static const AppIconToken chevronLeft = AppIconToken('chevron-left');

  /// `chevron-right.svg`
  static const AppIconToken chevronRight = AppIconToken('chevron-right');

  /// `chevron-up.svg`
  static const AppIconToken chevronUp = AppIconToken('chevron-up');

  /// `clock.svg`
  static const AppIconToken clock = AppIconToken('clock');

  /// `close.svg`
  static const AppIconToken close = AppIconToken('close');

  /// `copy.svg`
  static const AppIconToken copy = AppIconToken('copy');

  /// `csv.svg`
  static const AppIconToken csv = AppIconToken('csv');

  /// `dashboard.svg`
  static const AppIconToken dashboard = AppIconToken('dashboard');

  /// `drag-arrow.svg`
  static const AppIconToken dragArrow = AppIconToken('drag-arrow');

  /// `error-circle.svg`
  static const AppIconToken errorCircle = AppIconToken('error-circle');

  /// `external-link.svg`
  static const AppIconToken externalLink = AppIconToken('external-link');

  /// `file-doc.svg`
  static const AppIconToken fileDoc = AppIconToken('file-doc');

  /// `file-pdf.svg`
  static const AppIconToken filePdf = AppIconToken('file-pdf');

  /// `file-ppt.svg`
  static const AppIconToken filePpt = AppIconToken('file-ppt');

  /// `file-text.svg`
  static const AppIconToken fileText = AppIconToken('file-text');

  /// `file-txt.svg`
  static const AppIconToken fileTxt = AppIconToken('file-txt');

  /// `file-xls.svg`
  static const AppIconToken fileXls = AppIconToken('file-xls');

  /// `filter.svg`
  static const AppIconToken filter = AppIconToken('filter');

  /// `group.svg`
  static const AppIconToken group = AppIconToken('group');

  /// `hyperlink.svg`
  static const AppIconToken hyperlink = AppIconToken('hyperlink');

  /// `image-landscape.svg`
  static const AppIconToken imageLandscape = AppIconToken('image-landscape');

  /// `info.svg`
  static const AppIconToken info = AppIconToken('info');

  /// `info-circle.svg`
  static const AppIconToken infoCircle = AppIconToken('info-circle');

  /// `mail.svg`
  static const AppIconToken mail = AppIconToken('mail');

  /// `map.svg`
  static const AppIconToken map = AppIconToken('map');

  /// `microphone.svg`
  static const AppIconToken microphone = AppIconToken('microphone');

  /// `pdf.svg`
  static const AppIconToken pdf = AppIconToken('pdf');

  /// `pencil.svg`
  static const AppIconToken pencil = AppIconToken('pencil');

  /// `plus.svg`
  static const AppIconToken plus = AppIconToken('plus');

  /// `refresh.svg`
  static const AppIconToken refresh = AppIconToken('refresh');

  /// `remove.svg`
  static const AppIconToken remove = AppIconToken('remove');

  /// `search.svg`
  static const AppIconToken search = AppIconToken('search');

  /// `settings.svg`
  static const AppIconToken settings = AppIconToken('settings');

  /// `stop.svg`
  static const AppIconToken stop = AppIconToken('stop');

  /// `support.svg`
  static const AppIconToken support = AppIconToken('support');

  /// `swap-arrow.svg`
  static const AppIconToken swapArrow = AppIconToken('swap-arrow');

  /// `sync.svg`
  static const AppIconToken sync = AppIconToken('sync');

  /// `thumbs-down.svg`
  static const AppIconToken thumbsDown = AppIconToken('thumbs-down');

  /// `thumbs-up.svg`
  static const AppIconToken thumbsUp = AppIconToken('thumbs-up');

  /// `user.svg`
  static const AppIconToken user = AppIconToken('user');

  /// `video-play.svg`
  static const AppIconToken videoPlay = AppIconToken('video-play');

  /// `zip-file.svg`
  static const AppIconToken zipFile = AppIconToken('zip-file');

  /// Todos os tokens do contrato. É contra esta lista que
  /// `test/architecture/icon_axis_test.dart` cobra o provider padrão.
  static const List<AppIconToken> values = <AppIconToken>[
    add,
    alert,
    apiCloud,
    arrowUp,
    attachment,
    audio,
    calendar,
    cancel,
    car,
    chat,
    check,
    checkCircle,
    chevronDown,
    chevronLeft,
    chevronRight,
    chevronUp,
    clock,
    close,
    copy,
    csv,
    dashboard,
    dragArrow,
    errorCircle,
    externalLink,
    fileDoc,
    filePdf,
    filePpt,
    fileText,
    fileTxt,
    fileXls,
    filter,
    group,
    hyperlink,
    imageLandscape,
    info,
    infoCircle,
    mail,
    map,
    microphone,
    pdf,
    pencil,
    plus,
    refresh,
    remove,
    search,
    settings,
    stop,
    support,
    swapArrow,
    sync,
    thumbsDown,
    thumbsUp,
    user,
    videoPlay,
    zipFile,
  ];
}
