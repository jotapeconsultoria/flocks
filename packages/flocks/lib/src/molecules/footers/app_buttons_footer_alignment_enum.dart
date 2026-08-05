import 'package:flutter/widgets.dart';

/// Alinhamento dos botões num [AppButtonsFooter].
enum AppButtonsFooterAlignment {
  /// Ao início.
  start,

  /// Ao centro.
  center,

  /// Ao fim.
  end;

  /// Alinhamento no eixo principal (linha horizontal).
  MainAxisAlignment get mainAxisAlignment => switch (this) {
    AppButtonsFooterAlignment.start => MainAxisAlignment.start,
    AppButtonsFooterAlignment.center => MainAxisAlignment.center,
    AppButtonsFooterAlignment.end => MainAxisAlignment.end,
  };

  /// Alinhamento cruzado (coluna vertical).
  CrossAxisAlignment get crossAxisAlignment => switch (this) {
    AppButtonsFooterAlignment.start => CrossAxisAlignment.start,
    AppButtonsFooterAlignment.center => CrossAxisAlignment.center,
    AppButtonsFooterAlignment.end => CrossAxisAlignment.end,
  };
}
