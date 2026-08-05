import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../atoms/badge/app_badge.dart';

/// Verbo HTTP de um endpoint documentado.
///
/// Cada verbo carrega o papel de cor semântico com que aparece na lista: o
/// leitor identifica leitura (`GET`), criação (`POST`), alteração
/// (`PUT`/`PATCH`) e remoção (`DELETE`) pela cor, antes de ler o path.
enum AppApiMethod {
  /// Leitura.
  get,

  /// Criação.
  post,

  /// Substituição integral.
  put,

  /// Alteração parcial.
  patch,

  /// Remoção.
  delete,

  /// Cabeçalhos apenas.
  head,

  /// Verbos suportados pelo recurso.
  options;

  /// Rótulo exibido — o verbo em caixa alta (`GET`, `POST`…).
  String get label => name.toUpperCase();

  /// Papel de cor semântico do verbo.
  AppBadgeColor get badgeColor => switch (this) {
    AppApiMethod.get => AppBadgeColor.info,
    AppApiMethod.post => AppBadgeColor.success,
    AppApiMethod.put || AppApiMethod.patch => AppBadgeColor.warning,
    AppApiMethod.delete => AppBadgeColor.danger,
    AppApiMethod.head || AppApiMethod.options => AppBadgeColor.neutral,
  };

  /// Se o verbo altera estado no servidor — o painel destaca esses endpoints.
  bool get isMutation => switch (this) {
    AppApiMethod.get || AppApiMethod.head || AppApiMethod.options => false,
    _ => true,
  };

  /// Converte um verbo textual (`'get'`, `'POST'`) no enum. `null` quando o
  /// verbo não é conhecido — o chamador decide se descarta ou registra.
  static AppApiMethod? tryParse(String value) {
    final String v = value.trim().toLowerCase();
    for (final AppApiMethod m in AppApiMethod.values) {
      if (m.name == v) return m;
    }
    return null;
  }
}

/// Onde um parâmetro viaja na requisição.
enum AppApiParamLocation {
  /// Segmento do path (`/devices/{id}`).
  path,

  /// Query string (`?page=1`).
  query,

  /// Cabeçalho HTTP.
  header,

  /// Corpo da requisição.
  body,

  /// Campo de formulário (`multipart`/`urlencoded`).
  formData;

  /// Rótulo curto exibido na tabela de parâmetros.
  String get label => switch (this) {
    AppApiParamLocation.path => 'path',
    AppApiParamLocation.query => 'query',
    AppApiParamLocation.header => 'header',
    AppApiParamLocation.body => 'body',
    AppApiParamLocation.formData => 'form',
  };

  /// Converte a chave `in:` do OpenAPI no enum. `null` quando desconhecida.
  static AppApiParamLocation? tryParse(String value) {
    return switch (value.trim().toLowerCase()) {
      'path' => AppApiParamLocation.path,
      'query' => AppApiParamLocation.query,
      'header' => AppApiParamLocation.header,
      'body' => AppApiParamLocation.body,
      'formdata' || 'form' || 'formData' => AppApiParamLocation.formData,
      _ => null,
    };
  }
}

/// Um parâmetro de requisição (path, query, header ou corpo).
@immutable
final class AppApiParam extends Equatable {
  /// Cria um [AppApiParam].
  const AppApiParam({
    required this.name,
    required this.location,
    required this.type,
    this.isRequired = false,
    this.description,
    this.enumValues = const <String>[],
    this.defaultValue,
  });

  /// Nome do parâmetro, como a API espera.
  final String name;

  /// Onde ele viaja.
  final AppApiParamLocation location;

  /// Tipo declarado (`string`, `integer`, `boolean`, `array[string]`…).
  final String type;

  /// Se é obrigatório.
  final bool isRequired;

  /// Descrição vinda da especificação.
  final String? description;

  /// Valores aceitos, quando o parâmetro é enumerado.
  final List<String> enumValues;

  /// Valor default declarado, se houver.
  final String? defaultValue;

  @override
  List<Object?> get props => <Object?>[
    name,
    location,
    type,
    isRequired,
    description,
    enumValues,
    defaultValue,
  ];
}

/// Um campo de schema (de request ou de response), possivelmente aninhado.
///
/// A árvore é montada pelo chamador a partir da especificação; o componente só
/// desenha. Cabe a quem monta impor teto de profundidade e cortar ciclos — os
/// schemas de uma API real se auto-referenciam.
@immutable
final class AppApiField extends Equatable {
  /// Cria um [AppApiField].
  const AppApiField({
    required this.name,
    required this.type,
    this.isRequired = false,
    this.description,
    this.children = const <AppApiField>[],
  });

  /// Nome do campo.
  final String name;

  /// Tipo declarado.
  final String type;

  /// Se é obrigatório.
  final bool isRequired;

  /// Descrição vinda da especificação.
  final String? description;

  /// Campos aninhados (objeto ou item de array).
  final List<AppApiField> children;

  /// Se o campo tem subcampos a mostrar.
  bool get hasChildren => children.isNotEmpty;

  @override
  List<Object?> get props => <Object?>[
    name,
    type,
    isRequired,
    description,
    children,
  ];
}

/// Uma resposta possível de um endpoint.
@immutable
final class AppApiResponse extends Equatable {
  /// Cria um [AppApiResponse].
  const AppApiResponse({
    required this.status,
    this.description,
    this.fields = const <AppApiField>[],
    this.exampleJson,
  });

  /// Código de status HTTP.
  final int status;

  /// Descrição vinda da especificação.
  final String? description;

  /// Schema do corpo, achatado em árvore.
  final List<AppApiField> fields;

  /// Exemplo de corpo, já formatado.
  final String? exampleJson;

  /// Se é uma resposta de sucesso (2xx).
  bool get isSuccess => status >= 200 && status < 300;

  /// Papel de cor do chip de status: 2xx sucesso, 4xx aviso, 5xx erro.
  AppBadgeColor get badgeColor {
    if (isSuccess) return AppBadgeColor.success;
    if (status >= 500) return AppBadgeColor.danger;
    if (status >= 400) return AppBadgeColor.warning;
    return AppBadgeColor.neutral;
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    description,
    fields,
    exampleJson,
  ];
}

/// Um endpoint documentado.
@immutable
final class AppApiEndpoint extends Equatable {
  /// Cria um [AppApiEndpoint].
  const AppApiEndpoint({
    required this.method,
    required this.path,
    this.summary,
    this.description,
    this.tags = const <String>[],
    this.requiresAuth = true,
    this.params = const <AppApiParam>[],
    this.requestFields = const <AppApiField>[],
    this.requestExampleJson,
    this.responses = const <AppApiResponse>[],
    this.curl,
    this.notes,
  });

  /// Verbo HTTP.
  final AppApiMethod method;

  /// Path com os placeholders da especificação (`/devices/{id}`).
  final String path;

  /// Resumo de uma linha.
  final String? summary;

  /// Descrição longa, quando a especificação traz.
  final String? description;

  /// Tags da especificação (`Devices`, `Associations`…).
  final List<String> tags;

  /// Se exige token de autenticação.
  final bool requiresAuth;

  /// Parâmetros de path/query/header/form.
  final List<AppApiParam> params;

  /// Schema do corpo da requisição.
  final List<AppApiField> requestFields;

  /// Exemplo de corpo da requisição, já formatado.
  final String? requestExampleJson;

  /// Respostas possíveis, na ordem em que devem aparecer.
  final List<AppApiResponse> responses;

  /// Comando `curl` pronto para colar. Nunca deve conter credencial real.
  final String? curl;

  /// Observação da própria aplicação (regra de negócio, pegadinha conhecida).
  final String? notes;

  /// Chave estável do endpoint — `MÉTODO path`. O Swagger da Tracked não emite
  /// `operationId`, então o par verbo+path é o identificador disponível.
  String get id => '${method.label} $path';

  /// Parâmetros filtrados por onde viajam.
  List<AppApiParam> paramsIn(AppApiParamLocation location) =>
      params.where((AppApiParam p) => p.location == location).toList();

  @override
  List<Object?> get props => <Object?>[
    method,
    path,
    summary,
    description,
    tags,
    requiresAuth,
    params,
    requestFields,
    requestExampleJson,
    responses,
    curl,
    notes,
  ];
}

/// Um bloco temático de endpoints dentro do contexto de uma tela — "CRUD de
/// dispositivos", "Associação de chip".
@immutable
final class AppApiGroup extends Equatable {
  /// Cria um [AppApiGroup].
  const AppApiGroup({
    required this.title,
    required this.endpoints,
    this.description,
  });

  /// Título do bloco.
  final String title;

  /// Endpoints do bloco, na ordem de leitura.
  final List<AppApiEndpoint> endpoints;

  /// Linha de contexto opcional.
  final String? description;

  @override
  List<Object?> get props => <Object?>[title, endpoints, description];
}

/// Um passo de um fluxo — a chamada que a etapa exige, com o porquê.
@immutable
final class AppApiFlowStep extends Equatable {
  /// Cria um [AppApiFlowStep].
  const AppApiFlowStep({
    required this.title,
    this.description,
    this.method,
    this.path,
    this.note,
  });

  /// O que a etapa faz, em uma linha.
  final String title;

  /// Detalhe da etapa.
  final String? description;

  /// Verbo da chamada. `null` quando o passo não é uma chamada (ex.: "aguarde
  /// a primeira posição").
  final AppApiMethod? method;

  /// Path da chamada, casando com o [AppApiEndpoint.path] correspondente.
  final String? path;

  /// Ressalva da etapa (pré-condição, efeito colateral).
  final String? note;

  /// Se o passo aponta para um endpoint navegável.
  bool get hasCall => method != null && path != null;

  /// Chave do endpoint apontado, ou `null` quando o passo não é uma chamada.
  String? get endpointId => hasCall ? '${method!.label} $path' : null;

  @override
  List<Object?> get props => <Object?>[title, description, method, path, note];
}

/// Um fluxo de negócio: a ordem em que os endpoints se encaixam para completar
/// uma tarefa ("cadastrar dispositivo → associar chip → associar veículo").
@immutable
final class AppApiFlowData extends Equatable {
  /// Cria um [AppApiFlowData].
  const AppApiFlowData({
    required this.title,
    required this.steps,
    this.description,
  });

  /// Nome do fluxo.
  final String title;

  /// Passos, na ordem de execução.
  final List<AppApiFlowStep> steps;

  /// Contexto do fluxo.
  final String? description;

  @override
  List<Object?> get props => <Object?>[title, steps, description];
}

/// A documentação da API no contexto de **uma tela**.
@immutable
final class AppApiDoc extends Equatable {
  /// Cria um [AppApiDoc].
  const AppApiDoc({
    required this.title,
    this.subtitle,
    this.baseUrl,
    this.groups = const <AppApiGroup>[],
    this.flows = const <AppApiFlowData>[],
  });

  /// Nome do contexto — normalmente o título da tela.
  final String title;

  /// Linha de contexto.
  final String? subtitle;

  /// Base da API a que os paths se somam.
  final String? baseUrl;

  /// Blocos temáticos de endpoints.
  final List<AppApiGroup> groups;

  /// Fluxos de negócio da tela.
  final List<AppApiFlowData> flows;

  /// Todos os endpoints, achatados na ordem dos grupos.
  List<AppApiEndpoint> get allEndpoints => <AppApiEndpoint>[
    for (final AppApiGroup g in groups) ...g.endpoints,
  ];

  /// Se não há nada a mostrar.
  bool get isEmpty => groups.isEmpty && flows.isEmpty;

  @override
  List<Object?> get props => <Object?>[title, subtitle, baseUrl, groups, flows];
}
