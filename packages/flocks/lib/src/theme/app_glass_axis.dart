import 'package:flutter/widgets.dart';

import 'app_themes.dart';

/// Ponto único de resolução do **eixo glass** (espelha [AppTransparency], que é
/// o gate de acessibilidade).
///
/// Os dois eixos são ortogonais e sempre aplicados em **AND**:
/// - [appResolveGlassOn] responde *"o vidro foi pedido?"* — override por instância
///   (`glass`) ou, quando `null`, o global da marca (`theme.glassTheme.enabled`);
/// - `AppTransparency.enabled` responde *"o vidro pode ser renderizado?"* — o
///   gate a11y (reduzir transparência / alto contraste).
///
/// O AND acontece dentro do `AppGlassSurface`, então quem chama esta função
/// normalmente não precisa consultar o gate a11y à mão.
///
/// O nome carrega o prefixo `app` porque o mixin `AppOverlayBar` expõe um
/// `resolveGlassOn(context)` de um argumento só — sem o prefixo, a chamada de
/// dentro do mixin resolveria para o próprio método e não compilaria.
///
/// ## Quem entra no eixo glass
///
/// Uma superfície participa do eixo se as **três** cláusulas valem:
///
/// 1. **Destacada** — pintada fora do fluxo de layout do pai (um `OverlayEntry`,
///    uma rota, ou um irmão em `Stack`/`Positioned` que não reserva espaço).
/// 2. **Contêiner** — hospeda conteúdo composto pelo chamador. O filho é um
///    `Widget`, não uma `String` fixa. Lê como *superfície*, não como *marca*.
/// 3. **Permanência legível** — fica até o usuário dispensar (ou por tempo
///    suficiente), para o blur assentar sem piscar.
///
/// Exemplos de exclusão por cláusula: `AppCard` e `AppAlert` inline falham (1),
/// pois ocupam espaço no fluxo; `AppTooltip` e `ChartTooltip` falham (2), pois
/// são rótulos fixos — e o tooltip de gráfico desfocaria justamente o dado que
/// descreve; `AppBottomSheetPage` falha (1), é uma página edge-to-edge.
///
/// A prova disso é mecânica: `test/architecture/glass_axis_test.dart` faz o
/// censo de todo overlay em `lib/src` e exige que ele esteja classificado.
bool appResolveGlassOn(BuildContext context, bool? glass) =>
    glass ?? AppTheme.of(context).glassTheme.enabled;
