/// O catálogo de ilustrações da JotaPe — 12 slugs.
///
/// São **nomes**, não endereços. Antes cada constante interpolava a URL de um
/// CDN privado, servindo assets de um set licenciado; hoje quem transforma nome
/// em pixel é o [AppIllustrationProvider] do tema.
///
/// **Este catálogo não é o contrato.** O contrato é [AppIllustrationToken] — o
/// que o design system usa em runtime, e que o provider padrão serve de dentro
/// do pacote. As outras só desenham sob um provider que as conheça.
sealed class AppIllustrations {
  static const allIllustrations = [
    delete,
    empty,
    errorConnection,
    errorUnexpected,
    errorValidation,
    logout,
    notificationSent,
    support,
    supportTeam,
    trackingHistory,
    trackingRealTime,
    update,
  ];

  // D
  static const delete = 'delete';

  // E
  static const empty = 'empty';
  static const errorConnection = 'error-connection';
  static const errorUnexpected = 'error-unexpected';
  static const errorValidation = 'error-validation';

  // L
  static const logout = 'logout';

  // N
  static const notificationSent = 'notification-sent';

  // S
  static const support = 'support';
  static const supportTeam = 'support-team';

  // T
  static const trackingHistory = 'tracking-history';
  static const trackingRealTime = 'tracking-real-time';

  // U
  static const update = 'update';
}
