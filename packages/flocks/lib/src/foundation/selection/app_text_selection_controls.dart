import 'package:flutter/cupertino.dart'
    show cupertinoDesktopTextSelectionControls, cupertinoTextSelectionControls;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/widgets.dart' show TextSelectionControls;

/// **Único ponto** do Flocks que toca Cupertino.
///
/// As alças e o menu de copiar/colar da seleção de texto não existem na camada
/// `widgets`: `EditableText.selectionControls` e `SelectableRegion` precisam de
/// uma implementação concreta, e as únicas prontas vêm de `material.dart` ou de
/// `cupertino.dart`. Escolhemos as Cupertino porque são as neutras (as de
/// Material arrastariam `ThemeData` junto).
///
/// Este arquivo existe para que essa dependência fique em **um** lugar, e não
/// espalhada: o mesmo bloco estava copiado em quatro arquivos
/// (`AppSelectionRegion`, `AppInput`, os dois do color picker) e a allow-list do
/// teste de arquitetura cobria só um deles — os outros três passaram a violar a
/// regra em silêncio conforme foram migrados.
///
/// Note que o **tipo** [TextSelectionControls] mora em `widgets.dart`; só as
/// duas instâncias vêm de Cupertino. Substituí-las por controles próprios é a
/// saída definitiva (Gate 7) e passa a ser a troca de um arquivo só — mas exige
/// cuidado: um `TextSelectionControls` caseiro **precisa** do mixin
/// `TextSelectionHandleControls`, senão o `contextMenuBuilder` é ignorado em
/// silêncio e o menu de copiar/colar desaparece.
TextSelectionControls get appTextSelectionControls =>
    switch (defaultTargetPlatform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux => cupertinoDesktopTextSelectionControls,
      _ => cupertinoTextSelectionControls,
    };
