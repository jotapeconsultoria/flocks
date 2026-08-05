/// O catálogo de ícones da JotaPe — ~880 slugs.
///
/// São **nomes**, não endereços. Antes cada constante interpolava a URL de um
/// CDN privado, o que prendia todo adotante do pacote à disponibilidade e à
/// licença de terceiros; hoje quem transforma nome em pixel é o
/// [AppIconProvider] do tema.
///
/// **Este catálogo não é o contrato.** O contrato é [AppIconToken]: os 55 nomes
/// que os componentes do próprio design system usam, e que o provider padrão
/// ([AppAssetIconProvider]) serve de dentro do pacote. Os slugs daqui que não
/// estão lá só desenham sob um provider que os conheça — na prática, o
/// [AppNetworkIconProvider] apontado para o CDN da JotaPe.
sealed class AppIcons {
  /// Subconjunto pré-carregado no startup (os ícones em uso na aplicação).
  /// Mantido enxuto para não baixar centenas de SVGs no boot. Ícones fora desta
  /// lista são resolvidos sob demanda.
  ///
  /// São slugs: quem precisa de URL (o precache do app, que fala com o CDN)
  /// resolve pelo provider de rede em vigor.
  static const precacheIcons = [
    account,
    accounts,
    add,
    ai,
    alert,
    apiCloud,
    automation,
    batteryCharging,
    batteryVoltage,
    bell,
    bellNotification,
    brand,
    calendar,
    car,
    check,
    checkCircle,
    chevronDown,
    chevronLeft,
    chevronRight,
    chevronUp,
    client,
    clock,
    collapse,
    communication,
    copy,
    csv,
    dashboard,
    databaseHealthy,
    databaseHistory,
    databaseUnhealthy,
    databaseWarning,
    dragArrow,
    driverRanking,
    driver,
    errorCircle,
    event,
    expand,
    externalLink,
    fileDownload,
    fileUpload,
    filterCircle,
    gas,
    generalDashboard,
    generalReport,
    geoArea,
    graduationHat,
    group,
    hexagon,
    importAssign,
    info,
    infoCircle,
    inventory,
    key,
    liveFeed,
    livePosition,
    lock,
    logout,
    map,
    mapPin,
    maximize,
    mediaVideo,
    minimize,
    models,
    module,
    monitoring,
    monitoringEvents,
    organizations,
    pause,
    play,
    pdf,
    policy,
    remove,
    report,
    reportAlert,
    reportArrow,
    reportFinance,
    reportSync,
    rpm,
    ruler,
    search,
    settings,
    settingsColumns,
    simCard,
    sliderHorizontal,
    speed,
    speedometer,
    stop,
    support,
    swapArrow,
    systemHealthy,
    systemUnhealthy,
    systemWarning,
    thumbsDown,
    thumbsUp,
    tracker,
    trackerCommand,
    trackerCommandSms,
    travel,
    user,
    videoCamera,
    videoMonitoringEvents,
    volume,
    windowManagement,
    xls,
  ];

  /// Catálogo completo (881 ícones). Usado pelo Widgetbook e testes.
  static const allIcons = [
    account,
    accountingBill,
    accounts,
    add,
    addSquare,
    ai,
    aiEmailGeneratorSpark,
    aiFileSpark,
    aiFolderSpark,
    aiLandscapeImageSpark,
    aiMapGeneratingSpark,
    aiPromptSpark,
    airplaneModePhone,
    airplanePlaneMode,
    aiTaggingSpark,
    aiUpscaleSpark,
    aiVideoCameraSpark,
    aiVideoSpark,
    alert,
    analyticsBars,
    analyticsGraphBar,
    analyticsPie,
    android,
    apiCloud,
    appBrowser,
    appleLogo,
    applePay,
    appMobile,
    appStoreLogo,
    appWindow,
    appWindowCheck,
    appWindowClock,
    appWindowRemove,
    archive,
    arrangeLetter,
    arrangeLetterDescending,
    arrangeNumber,
    arrangeNumberDescending,
    arrowButtonDown,
    arrowButtonLeft,
    arrowButtonRight,
    arrowButtonUp,
    arrowCircleDown,
    arrowCircleLeft,
    arrowCircleRight,
    arrowCircleUp,
    arrowDown,
    arrowDown1,
    arrowLeft,
    arrowLeft1,
    arrowRectangleDown,
    arrowRectangleLeft,
    arrowRectangleRight,
    arrowRectangleUp,
    arrowRight,
    arrowRight1,
    arrowUp,
    arrowUp1,
    attachClippingAdd,
    attachClippingRemove,
    attachment,
    audio,
    audioAdd,
    audioCash,
    audioCheck,
    audioClock,
    audioDisable,
    audioDownload,
    audioEdit,
    audioInformation,
    audioLock,
    audioMp3,
    audioQuestion,
    audioRefresh,
    audioRemove,
    audioSearch,
    audioSettings,
    audioShare,
    audioStar,
    audioSubtract,
    audioUpload,
    audioWarning,
    authentication,
    automation,
    avatarAthlete,
    awardBadgeStar,
    awardMedal,
    awardTrophyStar,
    backward10,
    backward15,
    backward30,
    backward45,
    backward5,
    backward60,
    badgeSign,
    batteryAlmostFull,
    batteryCharging,
    batteryEmpty,
    batteryLow,
    batteryMedium,
    batteryNone,
    batteryVoltage,
    bell,
    bellCheck,
    bellCogSetting,
    bellDisable,
    bellNotification,
    bellOff,
    bicycle,
    bin,
    bluetooth,
    boat,
    boatYacht,
    bookCloseBookmark,
    bookmark,
    bookmarkCancelDelete,
    brand,
    building,
    buildingCloudy,
    buildingsModern,
    businessContractApprove,
    businessDealHandshake,
    busSchool,
    cable,
    cableTie,
    calendar,
    calendarAdd,
    calendarCash,
    calendarCheck,
    calendarClock,
    calendarDisable,
    calendarFavorite,
    calendarSearch,
    calendarSetting,
    calendarWarning,
    callOperator,
    cancel,
    car,
    carAutopilot,
    carBattery,
    carCarplay,
    carConnected,
    carHatchback,
    carplayConnectRectangle,
    cctv,
    cdPartition,
    cellular3g,
    cellular4g,
    cellular5g,
    certifiedDiploma,
    certifiedRibbon,
    chat,
    chatAdd,
    chatCheck,
    chatDisable,
    chatDownload,
    chatEdit,
    chatForward,
    chatForwardAll,
    chatLock,
    chatRemove,
    chatSearch,
    chatSettings,
    chatShare,
    chatStar,
    chatSubtract,
    chatText,
    chatTyping,
    chatUpload,
    chatWarningTriangle,
    check,
    check2,
    checkBadge,
    checkCircle,
    chevronDown,
    chevronLeft,
    chevronRight,
    chevronUp,
    chip,
    chipCore,
    chipIot,
    circlePadFinger,
    client,
    clock,
    close,
    closeEyes,
    cog,
    collapse,
    communication,
    compass,
    compassDirection,
    computerAiSpark,
    computerBug,
    computerRam,
    contactUsFaq,
    conversationChat,
    conversationChatText,
    copy,
    copyFiles,
    creditCard,
    creditCardCheck,
    creditCardRemove,
    cruiseControl,
    csv,
    cursorHand,
    cursorSelectCircle,
    cursorSelectFrame,
    cursorSelectFrame1,
    dashboard,
    dashboardGear,
    dashboardSpeed,
    dashboardSteering,
    dashcam,
    database,
    databaseCheck,
    databaseClock,
    databaseHealthy,
    databaseHistory,
    databaseRemove,
    databaseUnhealthy,
    databaseWarning,
    dataTransferDiagonal,
    dataTransferSquareDiagonal,
    discountSquare,
    discussion,
    downloadBottom,
    downloadSquare,
    dragArrow,
    drawerDownload,
    drawerUpload,
    driver,
    driverId,
    driverRanking,
    duplicateFile,
    earth,
    earthLocate,
    earthSearch,
    emailAdd,
    emailCheck,
    emailClock,
    emailDisable,
    emailDownload,
    emailEdit,
    emailLock,
    emailRemove,
    emailReply,
    emailSearch,
    emailSend,
    emailSendingCircle,
    emailSettings,
    emailShare,
    emailStar,
    emailSubtract,
    emailUpload,
    emailWarning,
    engineTemperature,
    envelope,
    envelopeLetter,
    errorCircle,
    event,
    expand,
    externalLink,
    facebookLogo,
    factoryBuilding,
    fileDoc,
    fileDownload,
    filePdf,
    filePpt,
    fileStack,
    fileText,
    fileTextAdd,
    fileTextCash,
    fileTextCheck,
    fileTextClock,
    fileTextDisable,
    fileTextDownload,
    fileTextEdit,
    fileTextGraph,
    fileTextInfo,
    fileTextLock,
    fileTextQuestion,
    fileTextRefresh,
    fileTextRemove,
    fileTextSearch,
    fileTextSettings,
    fileTextShare,
    fileTextStar,
    fileTextSubtract,
    fileTextUpload,
    fileTextWarning,
    fileTxt,
    fileUpload,
    fileWarning,
    fileXls,
    filter,
    filterCircle,
    filterOff,
    filterSortLinesAscending,
    filterSortLinesDescending,
    flag,
    flagFinish,
    flagPlain2,
    flagPlain3,
    flash,
    flashDrive,
    flashOff,
    floppyDisk,
    flutterLogo,
    folderAdd,
    folderCash,
    folderCheck,
    folderClock,
    folderDisable,
    folderDownload,
    folderEdit,
    folderEmpty,
    folderImage,
    folderLock,
    folderMedia,
    folderMedia1,
    folderMusic,
    folderMusic1,
    folderQuestion,
    folderRemove,
    folderSearch,
    folderSettings,
    folderShare,
    folderStar,
    folderSubtract,
    folderText,
    folderUpload,
    folderWarning,
    follower1,
    follower2,
    following1,
    following2,
    forward10,
    forward15,
    forward30,
    forward45,
    forward5,
    forward60,
    freeShipping,
    fuelEmpty,
    fuelLevel,
    galleryCamera,
    galleryPicture,
    galleryVideo,
    gas,
    gauge,
    gaugeAlt,
    generalDashboard,
    generalReport,
    geoArea,
    giftBox,
    giftSquareWithBow,
    githubLogo,
    golangLogo,
    googleCastLogo,
    googlePay,
    gpsCompass,
    gpsPhone,
    graduationHat,
    graphStats,
    graphStatsSquare,
    group,
    handDrag,
    handPointerDown,
    handPointerLeft,
    handPointerRight,
    headphones,
    headphonesSupport,
    hexagon,
    hierarchy,
    house,
    hyperlink,
    idCard,
    imageAdd,
    imageCheck,
    imageClock,
    imageDisable,
    imageDollar,
    imageDownload,
    imageEdit,
    imageGif,
    imageInfo,
    imageJpg,
    imageLandscape,
    imageLock,
    imagePng,
    imageQuestion,
    imageRefresh,
    imageRemove,
    imageSearch,
    imageSettings,
    imageShare,
    imageStar,
    imageSubtract,
    imageSvg,
    imageUpload,
    imageWarning,
    importAssign,
    info,
    infoCircle,
    instagramLogo,
    inventory,
    junkMail,
    key,
    keyboardAlt,
    keyboardCommand,
    keyboardReturn,
    keyboardShift,
    layers,
    layoutDashboard,
    layoutDashboard1,
    layoutLeft,
    layoutModule1,
    layoutModule2,
    layoutRight,
    legalScaleDocument,
    lightBulbShine,
    linkBroken,
    linkedinLogo,
    linuxLogo,
    liveFeed,
    livePosition,
    location,
    locationFixed,
    locationOff,
    lock,
    lockUnlock,
    login1,
    login3,
    loginKey,
    loginKeys,
    logout,
    logout2,
    map,
    mapDirection,
    mapMarker,
    mapMarks,
    mapPin,
    maps,
    mapSearch,
    mastercardLogo,
    maximize,
    mediaVideo,
    meetingCamera,
    meetingCameraSquare,
    megaphone,
    menu,
    menuHorizontal,
    menuVertical,
    microphone,
    microphoneOff,
    microsoftLogo,
    minimize,
    mobileAiSpark,
    mobilePhone,
    mobilePhoneHorizontal,
    models,
    modernTvWide,
    module,
    modulePuzzle,
    moduleThree,
    moneyWallet,
    monitoring,
    monitoringEvents,
    musicSound,
    muteChat,
    network,
    networkPin,
    networkSearch,
    nftProfilePicture,
    nut,
    nutRound,
    nuts,
    nutsRound,
    officeBuilding,
    officeBuildingDouble,
    officeBuildingTall,
    officeDrawer,
    officeFolder,
    organizations,
    parkingBrake,
    paste,
    pause,
    pdf,
    pencil,
    pencilWrite,
    performanceDecrease,
    performanceIncrease,
    phone,
    phoneAt,
    phoneCamera,
    phoneCash,
    phoneCheck,
    phoneClock,
    phoneCreditCard,
    phoneDataTransfer,
    phoneDisable,
    phoneDownload,
    phoneEdit,
    phoneEmail,
    phoneFlash,
    phoneFlashLight,
    phoneImage,
    phoneInformation,
    phoneLocation,
    phoneLock,
    phoneMusic,
    phoneNavigationPin,
    phonePlay,
    phonePowerSwitch,
    phoneQuestion,
    phoneRefresh,
    phoneRing,
    phoneSearch,
    phoneSettings,
    phoneShare,
    phoneShield,
    phoneStar,
    phoneText,
    phoneType,
    phoneUpload,
    phoneVibrate,
    phoneWarning,
    phoneWifi,
    pieLineGraph,
    pin,
    pinAdd,
    pinBolt,
    pinCall,
    pinCamera,
    pinCheck,
    pinDirectionArrow,
    pinGear,
    pinInformation,
    pinMarker,
    pinMinus,
    pinMovieReel,
    pinNote,
    pinOffMap,
    pinParking,
    pinPhotography,
    pinPowerButton,
    pinQuestion,
    pinRemove,
    pinSearch,
    pinStar,
    pinUnlock,
    pinWarning,
    play,
    playStoreLogo,
    pliers,
    policy,
    power,
    printText,
    qrCode,
    qrScan,
    rankingFirst,
    readEmailAt,
    readEmailLetter,
    readEmailTarget,
    receiptSlip,
    receiptSlip1,
    remove,
    removeBadge,
    removeSquare,
    removeSquare1,
    report,
    reportAlert,
    reportArrow,
    reportFinance,
    reportSync,
    rewardClapsHand1,
    rewardClapsHand3,
    road,
    roadAlt,
    rotate,
    rpm,
    ruler,
    satellite,
    satelliteSignal,
    scissors,
    scooter,
    screwdriver,
    scrollHorizontal,
    scrollVertical,
    sdCard,
    search,
    searchSquare,
    sendEmail,
    sendEmail1,
    sendEmail2,
    server,
    serverCheck,
    serverClock,
    serverRemove,
    settings,
    settingsColumns,
    share,
    shareExternalLink,
    shipment,
    shipmentBox,
    shipmentCheck,
    shipmentClock,
    shipmentDownload,
    shipmentNext,
    shipmentPrevious,
    shipmentRemove,
    shipmentSearch,
    shipmentSubtract,
    shipmentUpload,
    shipmentWarning,
    shop,
    shoppingBag,
    shoppingBasket,
    shoppingCart,
    signal,
    signalFull,
    signalLow,
    signalMedium,
    signalNone,
    signBadgeCircle,
    simCard,
    slackLogo,
    sliderHorizontal,
    sliderVertical,
    smartTvAndPhone,
    smartTvConnectionWifi,
    speed,
    speedometer,
    star,
    star1,
    starAdd,
    starCheck,
    starRemove,
    stars2,
    stars3,
    stars4,
    stars5,
    starSquare,
    starSubtract,
    starThree,
    starWinner,
    stop,
    stopwatch,
    studyBook,
    subtractSquare,
    support,
    surveillanceCamera,
    surveillanceCameraPhone,
    surveillanceTarget,
    swapArrow,
    switchAccount1,
    switchAccount3,
    sync,
    syncClock,
    synchronizeRefreshArrow,
    syncSquare,
    systemHealthy,
    systemUnhealthy,
    systemWarning,
    tagsAdd,
    tagsCheck,
    tagsDouble,
    tagsFavoriteStar,
    tagsMinus,
    tagsRemove,
    tagsSearch,
    tagsSettings,
    target,
    taskListAdd,
    taskListCheck,
    taskListDelete,
    taskListPlain,
    technologyRobotHead,
    telegramLogo,
    temperatureCold,
    temperatureHigh,
    temperatureLow,
    temperatureMedium,
    temperatureWarning,
    thumbsDown,
    thumbsUp,
    tiktokLogo,
    timeDaily,
    timer,
    timeReverse,
    tools,
    toolsAlt,
    tracker,
    trackerCommand,
    trackerCommandSms,
    train,
    trainCargo,
    travel,
    travelPaperPlane,
    treeChartOrganize,
    trendsHotFlame,
    tripDistance,
    tripRoad,
    truck,
    truckMixer,
    tvFlatScreen,
    uploadBottom,
    uploadSquare,
    user,
    userActions,
    userAdd,
    userAddress,
    userAlarm,
    userBlock,
    userCart,
    userChat,
    userCheck1,
    userCheck2,
    userCoding,
    userCreditCard,
    userDownload,
    userEdit,
    userFlag,
    userFlash,
    userFlight,
    userFocus,
    userGraduate,
    userHeart,
    userHome,
    userImage,
    userInformation,
    userKey,
    userLaptop,
    userLocation,
    userLock,
    userMail,
    userMobile,
    userMoney,
    userMonitor,
    userMusic,
    userNetwork,
    userPlayer,
    userProfileStacking,
    userQuestion,
    userRefresh,
    userRemove,
    users,
    usersAdd,
    usersAddress,
    usersAlarm,
    usersBlock,
    usersCart,
    usersChat,
    usersCheck1,
    usersCheck2,
    usersCoding,
    usersConnection,
    usersCreditCard,
    usersDownload,
    usersEdit,
    userSetting,
    usersFamily,
    usersFlag,
    usersFlash,
    usersFlight,
    usersGraduate,
    usersGroup,
    userShare1,
    userShare2,
    usersHeart,
    userShield,
    usersHome,
    usersImage,
    usersInformation,
    usersKey,
    usersLaptop,
    usersLocation,
    usersLock,
    usersMail,
    usersMobile,
    usersMoney,
    usersMonitor,
    usersMusic,
    usersNetwork,
    usersPlayer,
    usersQuestion,
    usersRefresh,
    usersRemove,
    usersSetting,
    usersShare1,
    usersShare2,
    usersShield,
    usersStar,
    usersSubtract,
    usersSync,
    userStar,
    usersText,
    usersTime,
    usersTwo,
    userSubtract,
    usersUpDown,
    usersUpload,
    usersVideo,
    usersView,
    usersWarning,
    usersWifi,
    userSync,
    userText,
    userTime,
    userUpDown,
    userUpload,
    userVideo,
    userView,
    userWarning,
    userWifi,
    videoAdd,
    videoCamera,
    videoCheck,
    videoClock,
    videoDisable,
    videoDollar,
    videoDownload,
    videoEdit,
    videoInformation,
    videoLock,
    videoMonitoringEvents,
    videoMov,
    videoMp4,
    videoPlay,
    videoPlayer,
    videoPlayerCloud,
    videoQuestion,
    videoRefresh,
    videoRemove,
    videoSearch,
    videoSettings,
    videoShare,
    videoStar,
    videoSubtract,
    videoUpload,
    videoWarning,
    view,
    viewOff,
    vipCrownQueen,
    visaLogo,
    voiceId,
    volume,
    volumeCheck,
    volumeDown,
    volumeDown2,
    volumeFull,
    volumeLow,
    volumeMedium,
    volumeMute,
    volumeRemove,
    volumeSettings,
    volumeUp,
    volumeUp2,
    volumeWarning,
    warehouseCartPackage,
    warehouseStorage,
    webcam,
    whatsappLogo,
    wifi,
    wifiOff,
    wifiSignalFull,
    wifiSignalLow,
    windowManagement,
    worker,
    workflowBranch,
    workflowScrum,
    wrench,
    wrenchAlt,
    wrenchDouble,
    xLogoTwitterLogo,
    xls,
    youtubeClipLogo,
    zipFile,
    zipFile2,
    zoomIn,
    zoomOut,
  ];

  // A
  static const account = 'account';
  static const accounts = 'accounts';
  static const add = 'add';
  static const ai = 'ai';
  static const alert = 'alert';
  static const automation = 'automation';

  // B
  static const batteryCharging = 'battery-charging';
  static const batteryVoltage = 'battery-voltage';
  static const bell = 'bell';
  static const bellNotification = 'bell-notification';
  static const brand = 'brand';

  // C
  static const calendar = 'calendar';
  static const car = 'car';
  static const check = 'check';
  static const checkCircle = 'check-circle';
  static const chevronDown = 'chevron-down';
  static const chevronLeft = 'chevron-left';
  static const chevronRight = 'chevron-right';
  static const chevronUp = 'chevron-up';
  static const client = 'client';
  static const clock = 'clock';
  static const collapse = 'collapse';
  static const communication = 'communication';
  static const copy = 'copy';
  static const csv = 'csv';

  // D
  static const dashboard = 'dashboard';
  static const databaseHealthy = 'database-healthy';
  static const databaseHistory = 'database-history';
  static const databaseUnhealthy = 'database-unhealthy';
  static const databaseWarning = 'database-warning';
  static const dragArrow = 'drag-arrow';
  static const driverRanking = 'driver-ranking';
  static const driver = 'driver';

  // E
  static const errorCircle = 'error-circle';
  static const event = 'event';
  static const expand = 'expand';
  static const externalLink = 'external-link';

  // F
  static const fileDownload = 'file-download';
  static const fileUpload = 'file-upload';
  static const filterCircle = 'filter-circle';

  // G
  static const gas = 'gas';
  static const generalDashboard = 'general-dashboard';
  static const generalReport = 'general-report';
  static const geoArea = 'geo-area';
  static const group = 'group';

  // H
  static const hexagon = 'hexagon';

  // I
  static const info = 'info';
  static const infoCircle = 'info-circle';
  static const inventory = 'inventory';
  static const importAssign = 'import-assign';

  // K
  static const key = 'key';

  // L
  static const livePosition = 'live-position';
  static const liveFeed = 'live-feed';
  static const lock = 'lock';
  static const logout = 'logout';

  // M
  static const map = 'map';
  static const mapPin = 'map-pin';
  static const maximize = 'maximize';
  static const mediaVideo = 'media-video';
  static const minimize = 'minimize';
  static const models = 'models';
  static const module = 'module';
  static const monitoring = 'monitoring';
  static const monitoringEvents = 'monitoring-events';

  // O
  static const organizations = 'organizations';

  // P
  static const pause = 'pause';
  static const play = 'play';
  static const pdf = 'pdf';
  static const policy = 'policy';

  // R
  static const remove = 'remove';
  static const report = 'report';
  static const reportAlert = 'report-alert';
  static const reportArrow = 'report-arrow';
  static const reportFinance = 'report-finance';
  static const reportSync = 'report-sync';
  static const rpm = 'rpm';
  static const ruler = 'ruler';

  // S
  static const search = 'search';
  static const settings = 'settings';
  static const settingsColumns = 'settings-columns';
  static const simCard = 'sim-card';
  static const speed = 'speed';
  static const speedometer = 'speedometer';
  static const stop = 'stop';
  static const support = 'support';
  static const swapArrow = 'swap-arrow';
  static const systemHealthy = 'system-healthy';
  static const systemUnhealthy = 'system-unhealthy';
  static const systemWarning = 'system-warning';

  // T
  static const thumbsDown = 'thumbs-down';
  static const thumbsUp = 'thumbs-up';
  static const tracker = 'tracker';
  static const trackerCommand = 'tracker-command';
  static const trackerCommandSms = 'tracker-command-sms';
  static const travel = 'travel';

  // U
  static const user = 'user';

  // V
  static const videoCamera = 'video-camera';
  static const videoMonitoringEvents = 'video-monitoring-events';
  static const volume = 'volume';

  // W
  static const windowManagement = 'window-management';

  // X
  static const xls = 'xls';

  // ─────────────────────────────────────────────────────────────────────────
  // Streamline Ultimate (importados) — 780 ícones
  // ─────────────────────────────────────────────────────────────────────────
  // A
  static const accountingBill = 'accounting-bill';
  static const addSquare = 'add-square';
  static const aiEmailGeneratorSpark = 'ai-email-generator-spark';
  static const aiFileSpark = 'ai-file-spark';
  static const aiFolderSpark = 'ai-folder-spark';
  static const aiLandscapeImageSpark = 'ai-landscape-image-spark';
  static const aiMapGeneratingSpark = 'ai-map-generating-spark';
  static const aiPromptSpark = 'ai-prompt-spark';
  static const aiTaggingSpark = 'ai-tagging-spark';
  static const aiUpscaleSpark = 'ai-upscale-spark';
  static const aiVideoCameraSpark = 'ai-video-camera-spark';
  static const aiVideoSpark = 'ai-video-spark';
  static const airplaneModePhone = 'airplane-mode-phone';
  static const airplanePlaneMode = 'airplane-plane-mode';
  static const analyticsBars = 'analytics-bars';
  static const analyticsGraphBar = 'analytics-graph-bar';
  static const analyticsPie = 'analytics-pie';
  static const android = 'android';
  static const apiCloud = 'api-cloud';
  static const appBrowser = 'app-browser';
  static const appMobile = 'app-mobile';
  static const appStoreLogo = 'app-store-logo';
  static const appWindow = 'app-window';
  static const appWindowCheck = 'app-window-check';
  static const appWindowClock = 'app-window-clock';
  static const appWindowRemove = 'app-window-remove';
  static const appleLogo = 'apple-logo';
  static const applePay = 'apple-pay';
  static const archive = 'archive';
  static const arrangeLetter = 'arrange-letter';
  static const arrangeLetterDescending = 'arrange-letter-descending';
  static const arrangeNumber = 'arrange-number';
  static const arrangeNumberDescending = 'arrange-number-descending';
  static const arrowButtonDown = 'arrow-button-down';
  static const arrowButtonLeft = 'arrow-button-left';
  static const arrowButtonRight = 'arrow-button-right';
  static const arrowButtonUp = 'arrow-button-up';
  static const arrowCircleDown = 'arrow-circle-down';
  static const arrowCircleLeft = 'arrow-circle-left';
  static const arrowCircleRight = 'arrow-circle-right';
  static const arrowCircleUp = 'arrow-circle-up';
  static const arrowDown = 'arrow-down';
  static const arrowDown1 = 'arrow-down-1';
  static const arrowLeft = 'arrow-left';
  static const arrowLeft1 = 'arrow-left-1';
  static const arrowRectangleDown = 'arrow-rectangle-down';
  static const arrowRectangleLeft = 'arrow-rectangle-left';
  static const arrowRectangleRight = 'arrow-rectangle-right';
  static const arrowRectangleUp = 'arrow-rectangle-up';
  static const arrowRight = 'arrow-right';
  static const arrowRight1 = 'arrow-right-1';
  static const arrowUp = 'arrow-up';
  static const arrowUp1 = 'arrow-up-1';
  static const attachClippingAdd = 'attach-clipping-add';
  static const attachClippingRemove = 'attach-clipping-remove';
  static const attachment = 'attachment';
  static const audio = 'audio';
  static const audioAdd = 'audio-add';
  static const audioCash = 'audio-cash';
  static const audioCheck = 'audio-check';
  static const audioClock = 'audio-clock';
  static const audioDisable = 'audio-disable';
  static const audioDownload = 'audio-download';
  static const audioEdit = 'audio-edit';
  static const audioInformation = 'audio-information';
  static const audioLock = 'audio-lock';
  static const audioMp3 = 'audio-mp3';
  static const audioQuestion = 'audio-question';
  static const audioRefresh = 'audio-refresh';
  static const audioRemove = 'audio-remove';
  static const audioSearch = 'audio-search';
  static const audioSettings = 'audio-settings';
  static const audioShare = 'audio-share';
  static const audioStar = 'audio-star';
  static const audioSubtract = 'audio-subtract';
  static const audioUpload = 'audio-upload';
  static const audioWarning = 'audio-warning';
  static const authentication = 'authentication';
  static const avatarAthlete = 'avatar-athlete';
  static const awardBadgeStar = 'award-badge-star';
  static const awardMedal = 'award-medal';
  static const awardTrophyStar = 'award-trophy-star';

  // B
  static const backward10 = 'backward-10';
  static const backward15 = 'backward-15';
  static const backward30 = 'backward-30';
  static const backward45 = 'backward-45';
  static const backward5 = 'backward-5';
  static const backward60 = 'backward-60';
  static const badgeSign = 'badge-sign';
  static const batteryAlmostFull = 'battery-almost-full';
  static const batteryEmpty = 'battery-empty';
  static const batteryLow = 'battery-low';
  static const batteryMedium = 'battery-medium';
  static const batteryNone = 'battery-none';
  static const bellCheck = 'bell-check';
  static const bellCogSetting = 'bell-cog-setting';
  static const bellDisable = 'bell-disable';
  static const bellOff = 'bell-off';
  static const bicycle = 'bicycle';
  static const bin = 'bin';
  static const bluetooth = 'bluetooth';
  static const boat = 'boat';
  static const boatYacht = 'boat-yacht';
  static const bookCloseBookmark = 'book-close-bookmark';
  static const bookmark = 'bookmark';
  static const bookmarkCancelDelete = 'bookmark-cancel-delete';
  static const building = 'building';
  static const buildingCloudy = 'building-cloudy';
  static const buildingsModern = 'buildings-modern';
  static const busSchool = 'bus-school';
  static const businessContractApprove = 'business-contract-approve';
  static const businessDealHandshake = 'business-deal-handshake';

  // C
  static const cable = 'cable';
  static const cableTie = 'cable-tie';
  static const calendarAdd = 'calendar-add';
  static const calendarCash = 'calendar-cash';
  static const calendarCheck = 'calendar-check';
  static const calendarClock = 'calendar-clock';
  static const calendarDisable = 'calendar-disable';
  static const calendarFavorite = 'calendar-favorite';
  static const calendarSearch = 'calendar-search';
  static const calendarSetting = 'calendar-setting';
  static const calendarWarning = 'calendar-warning';
  static const callOperator = 'call-operator';
  static const cancel = 'cancel';
  static const carAutopilot = 'car-autopilot';
  static const carBattery = 'car-battery';
  static const carCarplay = 'car-carplay';
  static const carConnected = 'car-connected';
  static const carHatchback = 'car-hatchback';
  static const carplayConnectRectangle = 'carplay-connect-rectangle';
  static const cctv = 'cctv';
  static const cdPartition = 'cd-partition';
  static const cellular3g = 'cellular-3g';
  static const cellular4g = 'cellular-4g';
  static const cellular5g = 'cellular-5g';
  static const certifiedDiploma = 'certified-diploma';
  static const certifiedRibbon = 'certified-ribbon';
  static const chat = 'chat';
  static const chatAdd = 'chat-add';
  static const chatCheck = 'chat-check';
  static const chatDisable = 'chat-disable';
  static const chatDownload = 'chat-download';
  static const chatEdit = 'chat-edit';
  static const chatForward = 'chat-forward';
  static const chatForwardAll = 'chat-forward-all';
  static const chatLock = 'chat-lock';
  static const chatRemove = 'chat-remove';
  static const chatSearch = 'chat-search';
  static const chatSettings = 'chat-settings';
  static const chatShare = 'chat-share';
  static const chatStar = 'chat-star';
  static const chatSubtract = 'chat-subtract';
  static const chatText = 'chat-text';
  static const chatTyping = 'chat-typing';
  static const chatUpload = 'chat-upload';
  static const chatWarningTriangle = 'chat-warning-triangle';
  static const check2 = 'check-2';
  static const checkBadge = 'check-badge';
  static const chip = 'chip';
  static const chipCore = 'chip-core';
  static const chipIot = 'chip-iot';
  static const circlePadFinger = 'circle-pad-finger';
  static const close = 'close';
  static const closeEyes = 'close-eyes';
  static const cog = 'cog';
  static const compass = 'compass';
  static const compassDirection = 'compass-direction';
  static const computerAiSpark = 'computer-ai-spark';
  static const computerBug = 'computer-bug';
  static const computerRam = 'computer-ram';
  static const contactUsFaq = 'contact-us-faq';
  static const conversationChat = 'conversation-chat';
  static const conversationChatText = 'conversation-chat-text';
  static const copyFiles = 'copy-files';
  static const creditCard = 'credit-card';
  static const creditCardCheck = 'credit-card-check';
  static const creditCardRemove = 'credit-card-remove';
  static const cruiseControl = 'cruise-control';
  static const cursorHand = 'cursor-hand';
  static const cursorSelectCircle = 'cursor-select-circle';
  static const cursorSelectFrame = 'cursor-select-frame';
  static const cursorSelectFrame1 = 'cursor-select-frame-1';

  // D
  static const dashboardGear = 'dashboard-gear';
  static const dashboardSpeed = 'dashboard-speed';
  static const dashboardSteering = 'dashboard-steering';
  static const dashcam = 'dashcam';
  static const dataTransferDiagonal = 'data-transfer-diagonal';
  static const dataTransferSquareDiagonal = 'data-transfer-square-diagonal';
  static const database = 'database';
  static const databaseCheck = 'database-check';
  static const databaseClock = 'database-clock';
  static const databaseRemove = 'database-remove';
  static const discountSquare = 'discount-square';
  static const discussion = 'discussion';
  static const downloadBottom = 'download-bottom';
  static const downloadSquare = 'download-square';
  static const drawerDownload = 'drawer-download';
  static const drawerUpload = 'drawer-upload';
  static const driverId = 'driver-id';
  static const duplicateFile = 'duplicate-file';

  // E
  static const earth = 'earth';
  static const earthLocate = 'earth-locate';
  static const earthSearch = 'earth-search';
  static const emailAdd = 'email-add';
  static const emailCheck = 'email-check';
  static const emailClock = 'email-clock';
  static const emailDisable = 'email-disable';
  static const emailDownload = 'email-download';
  static const emailEdit = 'email-edit';
  static const emailLock = 'email-lock';
  static const emailRemove = 'email-remove';
  static const emailReply = 'email-reply';
  static const emailSearch = 'email-search';
  static const emailSend = 'email-send';
  static const emailSendingCircle = 'email-sending-circle';
  static const emailSettings = 'email-settings';
  static const emailShare = 'email-share';
  static const emailStar = 'email-star';
  static const emailSubtract = 'email-subtract';
  static const emailUpload = 'email-upload';
  static const emailWarning = 'email-warning';
  static const engineTemperature = 'engine-temperature';
  static const envelope = 'envelope';
  static const envelopeLetter = 'envelope-letter';

  // F
  static const facebookLogo = 'facebook-logo';
  static const factoryBuilding = 'factory-building';
  static const fileDoc = 'file-doc';
  static const filePdf = 'file-pdf';
  static const filePpt = 'file-ppt';
  static const fileStack = 'file-stack';
  static const fileText = 'file-text';
  static const fileTextAdd = 'file-text-add';
  static const fileTextCash = 'file-text-cash';
  static const fileTextCheck = 'file-text-check';
  static const fileTextClock = 'file-text-clock';
  static const fileTextDisable = 'file-text-disable';
  static const fileTextDownload = 'file-text-download';
  static const fileTextEdit = 'file-text-edit';
  static const fileTextGraph = 'file-text-graph';
  static const fileTextInfo = 'file-text-info';
  static const fileTextLock = 'file-text-lock';
  static const fileTextQuestion = 'file-text-question';
  static const fileTextRefresh = 'file-text-refresh';
  static const fileTextRemove = 'file-text-remove';
  static const fileTextSearch = 'file-text-search';
  static const fileTextSettings = 'file-text-settings';
  static const fileTextShare = 'file-text-share';
  static const fileTextStar = 'file-text-star';
  static const fileTextSubtract = 'file-text-subtract';
  static const fileTextUpload = 'file-text-upload';
  static const fileTextWarning = 'file-text-warning';
  static const fileTxt = 'file-txt';
  static const fileWarning = 'file-warning';
  static const fileXls = 'file-xls';
  static const filter = 'filter';
  static const filterOff = 'filter-off';
  static const filterSortLinesAscending = 'filter-sort-lines-ascending';
  static const filterSortLinesDescending = 'filter-sort-lines-descending';
  static const flag = 'flag';
  static const flagFinish = 'flag-finish';
  static const flagPlain2 = 'flag-plain-2';
  static const flagPlain3 = 'flag-plain-3';
  static const flash = 'flash';
  static const flashDrive = 'flash-drive';
  static const flashOff = 'flash-off';
  static const floppyDisk = 'floppy-disk';
  static const flutterLogo = 'flutter-logo';
  static const folderAdd = 'folder-add';
  static const folderCash = 'folder-cash';
  static const folderCheck = 'folder-check';
  static const folderClock = 'folder-clock';
  static const folderDisable = 'folder-disable';
  static const folderDownload = 'folder-download';
  static const folderEdit = 'folder-edit';
  static const folderEmpty = 'folder-empty';
  static const folderImage = 'folder-image';
  static const folderLock = 'folder-lock';
  static const folderMedia = 'folder-media';
  static const folderMedia1 = 'folder-media-1';
  static const folderMusic = 'folder-music';
  static const folderMusic1 = 'folder-music-1';
  static const folderQuestion = 'folder-question';
  static const folderRemove = 'folder-remove';
  static const folderSearch = 'folder-search';
  static const folderSettings = 'folder-settings';
  static const folderShare = 'folder-share';
  static const folderStar = 'folder-star';
  static const folderSubtract = 'folder-subtract';
  static const folderText = 'folder-text';
  static const folderUpload = 'folder-upload';
  static const folderWarning = 'folder-warning';
  static const follower1 = 'follower-1';
  static const follower2 = 'follower-2';
  static const following1 = 'following-1';
  static const following2 = 'following-2';
  static const forward10 = 'forward-10';
  static const forward15 = 'forward-15';
  static const forward30 = 'forward-30';
  static const forward45 = 'forward-45';
  static const forward5 = 'forward-5';
  static const forward60 = 'forward-60';
  static const freeShipping = 'free-shipping';
  static const fuelEmpty = 'fuel-empty';
  static const fuelLevel = 'fuel-level';

  // G
  static const galleryCamera = 'gallery-camera';
  static const galleryPicture = 'gallery-picture';
  static const galleryVideo = 'gallery-video';
  static const gauge = 'gauge';
  static const gaugeAlt = 'gauge-alt';
  static const giftBox = 'gift-box';
  static const giftSquareWithBow = 'gift-square-with-bow';
  static const githubLogo = 'github-logo';
  static const golangLogo = 'golang-logo';
  static const googleCastLogo = 'google-cast-logo';
  static const googlePay = 'google-pay';
  static const gpsCompass = 'gps-compass';
  static const gpsPhone = 'gps-phone';
  static const graduationHat = 'graduation-hat';
  static const graphStats = 'graph-stats';
  static const graphStatsSquare = 'graph-stats-square';

  // H
  static const handDrag = 'hand-drag';
  static const handPointerDown = 'hand-pointer-down';
  static const handPointerLeft = 'hand-pointer-left';
  static const handPointerRight = 'hand-pointer-right';
  static const headphones = 'headphones';
  static const headphonesSupport = 'headphones-support';
  static const hierarchy = 'hierarchy';
  static const house = 'house';
  static const hyperlink = 'hyperlink';

  // I
  static const idCard = 'id-card';
  static const imageAdd = 'image-add';
  static const imageCheck = 'image-check';
  static const imageClock = 'image-clock';
  static const imageDisable = 'image-disable';
  static const imageDollar = 'image-dollar';
  static const imageDownload = 'image-download';
  static const imageEdit = 'image-edit';
  static const imageGif = 'image-gif';
  static const imageInfo = 'image-info';
  static const imageJpg = 'image-jpg';
  static const imageLandscape = 'image-landscape';
  static const imageLock = 'image-lock';
  static const imagePng = 'image-png';
  static const imageQuestion = 'image-question';
  static const imageRefresh = 'image-refresh';
  static const imageRemove = 'image-remove';
  static const imageSearch = 'image-search';
  static const imageSettings = 'image-settings';
  static const imageShare = 'image-share';
  static const imageStar = 'image-star';
  static const imageSubtract = 'image-subtract';
  static const imageSvg = 'image-svg';
  static const imageUpload = 'image-upload';
  static const imageWarning = 'image-warning';
  static const instagramLogo = 'instagram-logo';

  // J
  static const junkMail = 'junk-mail';

  // K
  static const keyboardAlt = 'keyboard-alt';
  static const keyboardCommand = 'keyboard-command';
  static const keyboardReturn = 'keyboard-return';
  static const keyboardShift = 'keyboard-shift';

  // L
  static const layers = 'layers';
  static const layoutDashboard = 'layout-dashboard';
  static const layoutDashboard1 = 'layout-dashboard-1';
  static const layoutLeft = 'layout-left';
  static const layoutModule1 = 'layout-module-1';
  static const layoutModule2 = 'layout-module-2';
  static const layoutRight = 'layout-right';
  static const legalScaleDocument = 'legal-scale-document';
  static const lightBulbShine = 'light-bulb-shine';
  static const linkBroken = 'link-broken';
  static const linkedinLogo = 'linkedin-logo';
  static const linuxLogo = 'linux-logo';
  static const location = 'location';
  static const locationFixed = 'location-fixed';
  static const locationOff = 'location-off';
  static const lockUnlock = 'lock-unlock';
  static const login1 = 'login-1';
  static const login3 = 'login-3';
  static const loginKey = 'login-key';
  static const loginKeys = 'login-keys';
  static const logout2 = 'logout-2';

  // M
  static const mapDirection = 'map-direction';
  static const mapMarker = 'map-marker';
  static const mapMarks = 'map-marks';
  static const mapSearch = 'map-search';
  static const maps = 'maps';
  static const mastercardLogo = 'mastercard-logo';
  static const meetingCamera = 'meeting-camera';
  static const meetingCameraSquare = 'meeting-camera-square';
  static const megaphone = 'megaphone';
  static const menu = 'menu';
  static const menuHorizontal = 'menu-horizontal';
  static const menuVertical = 'menu-vertical';
  static const microphone = 'microphone';
  static const microphoneOff = 'microphone-off';
  static const microsoftLogo = 'microsoft-logo';
  static const mobileAiSpark = 'mobile-ai-spark';
  static const mobilePhone = 'mobile-phone';
  static const mobilePhoneHorizontal = 'mobile-phone-horizontal';
  static const modernTvWide = 'modern-tv-wide';
  static const modulePuzzle = 'module-puzzle';
  static const moduleThree = 'module-three';
  static const moneyWallet = 'money-wallet';
  static const musicSound = 'music-sound';
  static const muteChat = 'mute-chat';

  // N
  static const network = 'network';
  static const networkPin = 'network-pin';
  static const networkSearch = 'network-search';
  static const nftProfilePicture = 'nft-profile-picture';
  static const nut = 'nut';
  static const nutRound = 'nut-round';
  static const nuts = 'nuts';
  static const nutsRound = 'nuts-round';

  // O
  static const officeBuilding = 'office-building';
  static const officeBuildingDouble = 'office-building-double';
  static const officeBuildingTall = 'office-building-tall';
  static const officeDrawer = 'office-drawer';
  static const officeFolder = 'office-folder';

  // P
  static const parkingBrake = 'parking-brake';
  static const paste = 'paste';
  static const pencil = 'pencil';
  static const pencilWrite = 'pencil-write';
  static const performanceDecrease = 'performance-decrease';
  static const performanceIncrease = 'performance-increase';
  static const phone = 'phone';
  static const phoneAt = 'phone-at';
  static const phoneCamera = 'phone-camera';
  static const phoneCash = 'phone-cash';
  static const phoneCheck = 'phone-check';
  static const phoneClock = 'phone-clock';
  static const phoneCreditCard = 'phone-credit-card';
  static const phoneDataTransfer = 'phone-data-transfer';
  static const phoneDisable = 'phone-disable';
  static const phoneDownload = 'phone-download';
  static const phoneEdit = 'phone-edit';
  static const phoneEmail = 'phone-email';
  static const phoneFlash = 'phone-flash';
  static const phoneFlashLight = 'phone-flash-light';
  static const phoneImage = 'phone-image';
  static const phoneInformation = 'phone-information';
  static const phoneLocation = 'phone-location';
  static const phoneLock = 'phone-lock';
  static const phoneMusic = 'phone-music';
  static const phoneNavigationPin = 'phone-navigation-pin';
  static const phonePlay = 'phone-play';
  static const phonePowerSwitch = 'phone-power-switch';
  static const phoneQuestion = 'phone-question';
  static const phoneRefresh = 'phone-refresh';
  static const phoneRing = 'phone-ring';
  static const phoneSearch = 'phone-search';
  static const phoneSettings = 'phone-settings';
  static const phoneShare = 'phone-share';
  static const phoneShield = 'phone-shield';
  static const phoneStar = 'phone-star';
  static const phoneText = 'phone-text';
  static const phoneType = 'phone-type';
  static const phoneUpload = 'phone-upload';
  static const phoneVibrate = 'phone-vibrate';
  static const phoneWarning = 'phone-warning';
  static const phoneWifi = 'phone-wifi';
  static const pieLineGraph = 'pie-line-graph';
  static const pin = 'pin';
  static const pinAdd = 'pin-add';
  static const pinBolt = 'pin-bolt';
  static const pinCall = 'pin-call';
  static const pinCamera = 'pin-camera';
  static const pinCheck = 'pin-check';
  static const pinDirectionArrow = 'pin-direction-arrow';
  static const pinGear = 'pin-gear';
  static const pinInformation = 'pin-information';
  static const pinMarker = 'pin-marker';
  static const pinMinus = 'pin-minus';
  static const pinMovieReel = 'pin-movie-reel';
  static const pinNote = 'pin-note';
  static const pinOffMap = 'pin-off-map';
  static const pinParking = 'pin-parking';
  static const pinPhotography = 'pin-photography';
  static const pinPowerButton = 'pin-power-button';
  static const pinQuestion = 'pin-question';
  static const pinRemove = 'pin-remove';
  static const pinSearch = 'pin-search';
  static const pinStar = 'pin-star';
  static const pinUnlock = 'pin-unlock';
  static const pinWarning = 'pin-warning';
  static const playStoreLogo = 'play-store-logo';
  static const pliers = 'pliers';
  static const power = 'power';
  static const printText = 'print-text';

  // Q
  static const qrCode = 'qr-code';
  static const qrScan = 'qr-scan';

  // R
  static const rankingFirst = 'ranking-first';
  static const readEmailAt = 'read-email-at';
  static const readEmailLetter = 'read-email-letter';
  static const readEmailTarget = 'read-email-target';
  static const receiptSlip = 'receipt-slip';
  static const receiptSlip1 = 'receipt-slip-1';
  static const removeBadge = 'remove-badge';
  static const removeSquare = 'remove-square';
  static const removeSquare1 = 'remove-square-1';
  static const rewardClapsHand1 = 'reward-claps-hand-1';
  static const rewardClapsHand3 = 'reward-claps-hand-3';
  static const road = 'road';
  static const roadAlt = 'road-alt';
  static const rotate = 'rotate';

  // S
  static const satellite = 'satellite';
  static const satelliteSignal = 'satellite-signal';
  static const scissors = 'scissors';
  static const scooter = 'scooter';
  static const screwdriver = 'screwdriver';
  static const scrollHorizontal = 'scroll-horizontal';
  static const scrollVertical = 'scroll-vertical';
  static const sdCard = 'sd-card';
  static const searchSquare = 'search-square';
  static const sendEmail = 'send-email';
  static const sendEmail1 = 'send-email-1';
  static const sendEmail2 = 'send-email-2';
  static const server = 'server';
  static const serverCheck = 'server-check';
  static const serverClock = 'server-clock';
  static const serverRemove = 'server-remove';
  static const share = 'share';
  static const shareExternalLink = 'share-external-link';
  static const shipment = 'shipment';
  static const shipmentBox = 'shipment-box';
  static const shipmentCheck = 'shipment-check';
  static const shipmentClock = 'shipment-clock';
  static const shipmentDownload = 'shipment-download';
  static const shipmentNext = 'shipment-next';
  static const shipmentPrevious = 'shipment-previous';
  static const shipmentRemove = 'shipment-remove';
  static const shipmentSearch = 'shipment-search';
  static const shipmentSubtract = 'shipment-subtract';
  static const shipmentUpload = 'shipment-upload';
  static const shipmentWarning = 'shipment-warning';
  static const shop = 'shop';
  static const shoppingBag = 'shopping-bag';
  static const shoppingBasket = 'shopping-basket';
  static const shoppingCart = 'shopping-cart';
  static const signBadgeCircle = 'sign-badge-circle';
  static const signal = 'signal';
  static const signalFull = 'signal-full';
  static const signalLow = 'signal-low';
  static const signalMedium = 'signal-medium';
  static const signalNone = 'signal-none';
  static const slackLogo = 'slack-logo';
  static const sliderHorizontal = 'slider-horizontal';
  static const sliderVertical = 'slider-vertical';
  static const smartTvAndPhone = 'smart-tv-and-phone';
  static const smartTvConnectionWifi = 'smart-tv-connection-wifi';
  static const star = 'star';
  static const star1 = 'star-1';
  static const starAdd = 'star-add';
  static const starCheck = 'star-check';
  static const starRemove = 'star-remove';
  static const starSquare = 'star-square';
  static const starSubtract = 'star-subtract';
  static const starThree = 'star-three';
  static const starWinner = 'star-winner';
  static const stars2 = 'stars-2';
  static const stars3 = 'stars-3';
  static const stars4 = 'stars-4';
  static const stars5 = 'stars-5';
  static const stopwatch = 'stopwatch';
  static const studyBook = 'study-book';
  static const subtractSquare = 'subtract-square';
  static const surveillanceCamera = 'surveillance-camera';
  static const surveillanceCameraPhone = 'surveillance-camera-phone';
  static const surveillanceTarget = 'surveillance-target';
  static const switchAccount1 = 'switch-account-1';
  static const switchAccount3 = 'switch-account-3';
  static const sync = 'sync';
  static const syncClock = 'sync-clock';
  static const syncSquare = 'sync-square';
  static const synchronizeRefreshArrow = 'synchronize-refresh-arrow';

  // T
  static const tagsAdd = 'tags-add';
  static const tagsCheck = 'tags-check';
  static const tagsDouble = 'tags-double';
  static const tagsFavoriteStar = 'tags-favorite-star';
  static const tagsMinus = 'tags-minus';
  static const tagsRemove = 'tags-remove';
  static const tagsSearch = 'tags-search';
  static const tagsSettings = 'tags-settings';
  static const target = 'target';
  static const taskListAdd = 'task-list-add';
  static const taskListCheck = 'task-list-check';
  static const taskListDelete = 'task-list-delete';
  static const taskListPlain = 'task-list-plain';
  static const technologyRobotHead = 'technology-robot-head';
  static const telegramLogo = 'telegram-logo';
  static const temperatureCold = 'temperature-cold';
  static const temperatureHigh = 'temperature-high';
  static const temperatureLow = 'temperature-low';
  static const temperatureMedium = 'temperature-medium';
  static const temperatureWarning = 'temperature-warning';
  static const tiktokLogo = 'tiktok-logo';
  static const timeDaily = 'time-daily';
  static const timeReverse = 'time-reverse';
  static const timer = 'timer';
  static const tools = 'tools';
  static const toolsAlt = 'tools-alt';
  static const train = 'train';
  static const trainCargo = 'train-cargo';
  static const travelPaperPlane = 'travel-paper-plane';
  static const treeChartOrganize = 'tree-chart-organize';
  static const trendsHotFlame = 'trends-hot-flame';
  static const tripDistance = 'trip-distance';
  static const tripRoad = 'trip-road';
  static const truck = 'truck';
  static const truckMixer = 'truck-mixer';
  static const tvFlatScreen = 'tv-flat-screen';

  // U
  static const uploadBottom = 'upload-bottom';
  static const uploadSquare = 'upload-square';
  static const userActions = 'user-actions';
  static const userAdd = 'user-add';
  static const userAddress = 'user-address';
  static const userAlarm = 'user-alarm';
  static const userBlock = 'user-block';
  static const userCart = 'user-cart';
  static const userChat = 'user-chat';
  static const userCheck1 = 'user-check-1';
  static const userCheck2 = 'user-check-2';
  static const userCoding = 'user-coding';
  static const userCreditCard = 'user-credit-card';
  static const userDownload = 'user-download';
  static const userEdit = 'user-edit';
  static const userFlag = 'user-flag';
  static const userFlash = 'user-flash';
  static const userFlight = 'user-flight';
  static const userFocus = 'user-focus';
  static const userGraduate = 'user-graduate';
  static const userHeart = 'user-heart';
  static const userHome = 'user-home';
  static const userImage = 'user-image';
  static const userInformation = 'user-information';
  static const userKey = 'user-key';
  static const userLaptop = 'user-laptop';
  static const userLocation = 'user-location';
  static const userLock = 'user-lock';
  static const userMail = 'user-mail';
  static const userMobile = 'user-mobile';
  static const userMoney = 'user-money';
  static const userMonitor = 'user-monitor';
  static const userMusic = 'user-music';
  static const userNetwork = 'user-network';
  static const userPlayer = 'user-player';
  static const userProfileStacking = 'user-profile-stacking';
  static const userQuestion = 'user-question';
  static const userRefresh = 'user-refresh';
  static const userRemove = 'user-remove';
  static const userSetting = 'user-setting';
  static const userShare1 = 'user-share-1';
  static const userShare2 = 'user-share-2';
  static const userShield = 'user-shield';
  static const userStar = 'user-star';
  static const userSubtract = 'user-subtract';
  static const userSync = 'user-sync';
  static const userText = 'user-text';
  static const userTime = 'user-time';
  static const userUpDown = 'user-up-down';
  static const userUpload = 'user-upload';
  static const userVideo = 'user-video';
  static const userView = 'user-view';
  static const userWarning = 'user-warning';
  static const userWifi = 'user-wifi';
  static const users = 'users';
  static const usersAdd = 'users-add';
  static const usersAddress = 'users-address';
  static const usersAlarm = 'users-alarm';
  static const usersBlock = 'users-block';
  static const usersCart = 'users-cart';
  static const usersChat = 'users-chat';
  static const usersCheck1 = 'users-check-1';
  static const usersCheck2 = 'users-check-2';
  static const usersCoding = 'users-coding';
  static const usersConnection = 'users-connection';
  static const usersCreditCard = 'users-credit-card';
  static const usersDownload = 'users-download';
  static const usersEdit = 'users-edit';
  static const usersFamily = 'users-family';
  static const usersFlag = 'users-flag';
  static const usersFlash = 'users-flash';
  static const usersFlight = 'users-flight';
  static const usersGraduate = 'users-graduate';
  static const usersGroup = 'users-group';
  static const usersHeart = 'users-heart';
  static const usersHome = 'users-home';
  static const usersImage = 'users-image';
  static const usersInformation = 'users-information';
  static const usersKey = 'users-key';
  static const usersLaptop = 'users-laptop';
  static const usersLocation = 'users-location';
  static const usersLock = 'users-lock';
  static const usersMail = 'users-mail';
  static const usersMobile = 'users-mobile';
  static const usersMoney = 'users-money';
  static const usersMonitor = 'users-monitor';
  static const usersMusic = 'users-music';
  static const usersNetwork = 'users-network';
  static const usersPlayer = 'users-player';
  static const usersQuestion = 'users-question';
  static const usersRefresh = 'users-refresh';
  static const usersRemove = 'users-remove';
  static const usersSetting = 'users-setting';
  static const usersShare1 = 'users-share-1';
  static const usersShare2 = 'users-share-2';
  static const usersShield = 'users-shield';
  static const usersStar = 'users-star';
  static const usersSubtract = 'users-subtract';
  static const usersSync = 'users-sync';
  static const usersText = 'users-text';
  static const usersTime = 'users-time';
  static const usersTwo = 'users-two';
  static const usersUpDown = 'users-up-down';
  static const usersUpload = 'users-upload';
  static const usersVideo = 'users-video';
  static const usersView = 'users-view';
  static const usersWarning = 'users-warning';
  static const usersWifi = 'users-wifi';

  // V
  static const videoAdd = 'video-add';
  static const videoCheck = 'video-check';
  static const videoClock = 'video-clock';
  static const videoDisable = 'video-disable';
  static const videoDollar = 'video-dollar';
  static const videoDownload = 'video-download';
  static const videoEdit = 'video-edit';
  static const videoInformation = 'video-information';
  static const videoLock = 'video-lock';
  static const videoMov = 'video-mov';
  static const videoMp4 = 'video-mp4';
  static const videoPlay = 'video-play';
  static const videoPlayer = 'video-player';
  static const videoPlayerCloud = 'video-player-cloud';
  static const videoQuestion = 'video-question';
  static const videoRefresh = 'video-refresh';
  static const videoRemove = 'video-remove';
  static const videoSearch = 'video-search';
  static const videoSettings = 'video-settings';
  static const videoShare = 'video-share';
  static const videoStar = 'video-star';
  static const videoSubtract = 'video-subtract';
  static const videoUpload = 'video-upload';
  static const videoWarning = 'video-warning';
  static const view = 'view';
  static const viewOff = 'view-off';
  static const vipCrownQueen = 'vip-crown-queen';
  static const visaLogo = 'visa-logo';
  static const voiceId = 'voice-id';
  static const volumeCheck = 'volume-check';
  static const volumeDown = 'volume-down';
  static const volumeDown2 = 'volume-down-2';
  static const volumeFull = 'volume-full';
  static const volumeLow = 'volume-low';
  static const volumeMedium = 'volume-medium';
  static const volumeMute = 'volume-mute';
  static const volumeRemove = 'volume-remove';
  static const volumeSettings = 'volume-settings';
  static const volumeUp = 'volume-up';
  static const volumeUp2 = 'volume-up-2';
  static const volumeWarning = 'volume-warning';

  // W
  static const warehouseCartPackage = 'warehouse-cart-package';
  static const warehouseStorage = 'warehouse-storage';
  static const webcam = 'webcam';
  static const whatsappLogo = 'whatsapp-logo';
  static const wifi = 'wifi';
  static const wifiOff = 'wifi-off';
  static const wifiSignalFull = 'wifi-signal-full';
  static const wifiSignalLow = 'wifi-signal-low';
  static const worker = 'worker';
  static const workflowBranch = 'workflow-branch';
  static const workflowScrum = 'workflow-scrum';
  static const wrench = 'wrench';
  static const wrenchAlt = 'wrench-alt';
  static const wrenchDouble = 'wrench-double';

  // X
  static const xLogoTwitterLogo = 'x-logo-twitter-logo';

  // Y
  static const youtubeClipLogo = 'youtube-clip-logo';

  // Z
  static const zipFile = 'zip-file';
  static const zipFile2 = 'zip-file-2';
  static const zoomIn = 'zoom-in';
  static const zoomOut = 'zoom-out';
}
