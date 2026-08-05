import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/badge/app_badge.dart';

/// Cardinalidade de uma relação entre entidades.
enum AppEntityRelationKind {
  /// Um para um.
  oneToOne,

  /// Um para muitos — esta entidade é o lado "um".
  oneToMany,

  /// Muitos para um — esta entidade é o lado "muitos".
  manyToOne,

  /// Muitos para muitos (normalmente por uma tabela de associação).
  manyToMany;

  /// Rótulo curto exibido na pílula (`1 → N`).
  String get label => switch (this) {
    AppEntityRelationKind.oneToOne => '1 → 1',
    AppEntityRelationKind.oneToMany => '1 → N',
    AppEntityRelationKind.manyToOne => 'N → 1',
    AppEntityRelationKind.manyToMany => 'N → N',
  };
}

/// Sentido em que uma integração externa troca dados com a entidade.
enum AppEntityIntegrationDirection {
  /// O sistema externo **envia** dados para a Tracked.
  inbound,

  /// A Tracked **envia** dados para o sistema externo.
  outbound,

  /// Os dois sentidos.
  bidirectional;

  /// Rótulo curto exibido na pílula.
  String get label => switch (this) {
    AppEntityIntegrationDirection.inbound => 'recebe',
    AppEntityIntegrationDirection.outbound => 'envia',
    AppEntityIntegrationDirection.bidirectional => 'recebe e envia',
  };

  /// Papel de cor da pílula.
  AppBadgeColor get badgeColor => switch (this) {
    AppEntityIntegrationDirection.inbound => AppBadgeColor.info,
    AppEntityIntegrationDirection.outbound => AppBadgeColor.success,
    AppEntityIntegrationDirection.bidirectional => AppBadgeColor.primary,
  };
}

/// Uma relação da entidade documentada com outra entidade do domínio.
@immutable
final class AppEntityRelation extends Equatable {
  /// Cria um [AppEntityRelation].
  const AppEntityRelation({
    required this.target,
    required this.kind,
    this.description,
    this.via,
  });

  /// Nome da entidade relacionada, como o usuário a conhece ("Veículo").
  final String target;

  /// Cardinalidade.
  final AppEntityRelationKind kind;

  /// O que a relação significa no negócio — não o que ela é no banco.
  final String? description;

  /// Path do endpoint que cria/desfaz a relação, quando existe um.
  final String? via;

  @override
  List<Object?> get props => <Object?>[target, kind, description, via];
}

/// Uma integração externa que troca dados com a entidade.
@immutable
final class AppEntityIntegration extends Equatable {
  /// Cria um [AppEntityIntegration].
  const AppEntityIntegration({
    required this.name,
    required this.direction,
    this.description,
  });

  /// Nome do sistema/protocolo externo ("Queclink @Track", "Allcom").
  final String name;

  /// Sentido da troca.
  final AppEntityIntegrationDirection direction;

  /// O que ela faz com esta entidade, em uma ou duas linhas.
  final String? description;

  @override
  List<Object?> get props => <Object?>[name, direction, description];
}

/// Um bloco de texto livre da documentação da entidade.
///
/// O corpo é **Markdown** (renderizado pelo `AppMarkdown`): ciclo de vida,
/// regras de negócio e pegadinhas não cabem numa estrutura fixa, e forçá-las
/// numa produziria campos vazios na maioria das entidades.
@immutable
final class AppEntityDocSection extends Equatable {
  /// Cria um [AppEntityDocSection].
  const AppEntityDocSection({required this.title, required this.body});

  /// Título do bloco.
  final String title;

  /// Corpo em Markdown.
  final String body;

  @override
  List<Object?> get props => <Object?>[title, body];
}

/// A documentação **conceitual** de uma entidade do domínio.
///
/// É a metade que a referência de API não cobre: o que a entidade é, como ela
/// se encaixa nas outras e quem troca dados com ela. Anda ao lado de um
/// `AppApiDoc` no [AppDocsWorkspace] — um explica o conceito, o outro a
/// chamada.
@immutable
final class AppEntityDoc extends Equatable {
  /// Cria um [AppEntityDoc].
  const AppEntityDoc({
    required this.title,
    this.subtitle,
    this.overview,
    this.relations = const <AppEntityRelation>[],
    this.integrations = const <AppEntityIntegration>[],
    this.sections = const <AppEntityDocSection>[],
  });

  /// Nome da entidade ("Dispositivo").
  final String title;

  /// Uma linha de contexto.
  final String? subtitle;

  /// Abertura em Markdown — o que a entidade é.
  final String? overview;

  /// Relações com outras entidades.
  final List<AppEntityRelation> relations;

  /// Integrações externas que tocam a entidade.
  final List<AppEntityIntegration> integrations;

  /// Blocos livres (ciclo de vida, regras, pegadinhas).
  final List<AppEntityDocSection> sections;

  /// Se não há nada a mostrar.
  bool get isEmpty =>
      overview == null &&
      relations.isEmpty &&
      integrations.isEmpty &&
      sections.isEmpty;

  @override
  List<Object?> get props => <Object?>[
    title,
    subtitle,
    overview,
    relations,
    integrations,
    sections,
  ];
}
