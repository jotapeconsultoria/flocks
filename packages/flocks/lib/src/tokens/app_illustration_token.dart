/// O contrato de ilustração do Flocks: o que o pacote garante desenhar.
///
/// Hoje é **uma**. `AppIllustrations` tem 12 slugs, mas só esta é usada em
/// runtime dentro de `lib/src` — as outras são de tela de app, e servi-las é
/// escolha de quem monta o app, não do design system.
///
/// Mesma ideia de `AppIconToken`: o token é o contrato que um
/// [AppIllustrationProvider] precisa satisfazer, e o slug é o nome do arquivo
/// sem extensão. Não é URL — quem transforma nome em pixel é o provider.
extension type const AppIllustrationToken(String slug) implements String {
  /// Estado vazio: nada para mostrar aqui.
  static const AppIllustrationToken empty = AppIllustrationToken('empty');

  /// Todos os tokens do contrato, para o teste de arquitetura cobrar.
  static const List<AppIllustrationToken> values = <AppIllustrationToken>[
    empty,
  ];
}
