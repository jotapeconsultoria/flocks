import 'package:flutter/widgets.dart';

/// Estilo de contexto de um [AppButtonsFooter] — define o arredondamento.
enum AppButtonsFooterStyle {
  /// Rodapé de card (cantos de baixo arredondados).
  card,

  /// Rodapé de diálogo (cantos de baixo arredondados).
  dialog,

  /// Rodapé de página (sem arredondamento).
  page,

  /// Rodapé de bottom sheet (cantos de baixo arredondados).
  sheet;

  /// Raio dos cantos inferiores dado o [radius] global (modo redondo).
  /// `page` não arredonda.
  BorderRadius bottomRadius(double radius) => switch (this) {
    AppButtonsFooterStyle.page => BorderRadius.zero,
    _ => BorderRadius.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    ),
  };
}
