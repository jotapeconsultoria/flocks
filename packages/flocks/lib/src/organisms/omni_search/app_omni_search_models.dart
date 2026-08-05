import 'package:flutter/foundation.dart';

/// Um resultado da busca global.
@immutable
final class AppOmniSearchItem {
  const AppOmniSearchItem({
    required this.id,
    required this.title,
    required this.onSelected,
    this.subtitle,
    this.icon,
    this.trailing,
  });

  /// Identidade estável — usada como chave e para comparar seleção.
  final String id;

  /// Linha principal. É nela que o trecho digitado é realçado (ex.: a placa).
  final String title;

  /// Contexto: modelo, cliente, dispositivo…
  final String? subtitle;

  /// Constante de `AppIcons`.
  final String? icon;

  /// Texto discreto à direita (ex.: a operadora de um chip).
  final String? trailing;

  /// O que fazer ao escolher.
  final VoidCallback onSelected;
}

/// Um bloco de resultados do mesmo tipo (ex.: "VEÍCULOS").
///
/// Agrupar por entidade é o que faz uma lista misturada de placa, IMEI e ICCID
/// continuar legível: o rótulo diz o que aquele bloco é.
@immutable
final class AppOmniSearchGroup {
  const AppOmniSearchGroup({required this.label, required this.items});

  /// Rótulo do bloco.
  final String label;

  final List<AppOmniSearchItem> items;

  bool get isEmpty => items.isEmpty;
}

/// O que a busca devolveu para um termo.
///
/// [error] e "vazio" são estados distintos de propósito: "não achei nada" e
/// "não consegui buscar" pedem reações diferentes do usuário.
@immutable
final class AppOmniSearchResult {
  const AppOmniSearchResult({this.groups = const [], this.error});

  const AppOmniSearchResult.failed(String this.error) : groups = const [];

  final List<AppOmniSearchGroup> groups;

  /// Mensagem de falha. `null` quando a busca completou.
  final String? error;

  bool get hasError => error != null;

  /// Grupos com pelo menos um item.
  List<AppOmniSearchGroup> get nonEmptyGroups =>
      groups.where((group) => group.items.isNotEmpty).toList();

  bool get isEmpty => nonEmptyGroups.isEmpty;
}
