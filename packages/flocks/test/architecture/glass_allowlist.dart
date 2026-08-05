/// Classificação de **toda superfície flutuante** do Flocks contra o eixo glass.
///
/// O critério de pertencimento (três cláusulas) está no dartdoc de
/// `appResolveGlassOn`, em `lib/src/theme/app_glass_axis.dart`. Estas duas listas
/// são a aplicação dele, e o `glass_axis_test.dart` as usa para o censo:
/// **todo overlay em `lib/src` precisa aparecer numa das duas**. Um componente
/// novo quebra o CI até ser classificado — foi a ausência disso que deixou
/// dropdowns e pickers opacos por meses sem ninguém notar.
library;

/// Superfícies que **devem** participar do eixo glass.
///
/// Chave: path relativo a `lib/src`. Valor: o widget que representa (usado nas
/// mensagens de falha e para casar com o contrato de render).
const Map<String, String> kGlassSurfaces = <String, String>{
  'molecules/card/app_overlay_panel.dart': 'AppOverlayPanel',
  'molecules/menu/app_menu.dart': 'AppMenu',
  'molecules/popover/app_popover.dart': 'AppPopover',
  'molecules/overlay_card/app_overlay_card.dart': 'AppOverlayCard',
  'molecules/pickers/app_picker_anchor.dart': 'AppPickerAnchor',
  'molecules/dropdown/dropdown_internals.dart': 'DropdownPanel',
  'organisms/dialogs/app_dialog.dart': 'AppDialog',
  'organisms/bottom_sheets/bottom_sheet_surface.dart': 'BottomSheetSurface',
  'organisms/side_sheets/side_sheet_surface.dart': 'SideSheetSurface',
  'atoms/bars/app_bar_surface.dart': 'AppBarSurface',
};

/// Arquivos que **montam** um overlay mas não pintam superfície nenhuma — a
/// decoração fica com quem eles hospedam. Não têm eixo glass próprio: herdam o
/// de quem desenha. Valor: para onde delegam.
///
/// A distinção importa porque o censo procura "quem cria overlay", e criar não é
/// o mesmo que pintar. Um arquivo aqui não precisa referenciar o eixo.
const Map<String, String> kGlassDelegated = <String, String>{
  'molecules/card/anchored_overlay.dart':
      'motor de ancoragem puro (LayerLink + TapRegion + foco); o painel vem do '
      'builder do chamador',
  'molecules/dropdown/app_dropdown.dart': 'DropdownPanel',
  'molecules/dropdown/app_multi_select.dart': 'DropdownPanel',
  'molecules/dropdown/app_searchable_dropdown.dart': 'DropdownPanel',
  'molecules/dropdown/app_searchable_multi_select.dart': 'DropdownPanel',
  'molecules/alert/show_app_overlay.dart':
      'host animado transparente; a superfície é o child (AppSnackbar / '
      'AppOverlayAlert)',
  'molecules/snackbar/show_app_snackbar.dart': 'showAppOverlay + AppSnackbar',
  'organisms/bottom_sheets/bottom_sheet_route.dart': 'BottomSheetSurface',
  'organisms/side_sheets/side_sheet_route.dart': 'SideSheetSurface',
};

/// Superfícies flutuantes **deliberadamente fora** do eixo, com a cláusula que
/// as exclui. Entrar aqui é uma decisão de design registrada, não um TODO.
const Map<String, String> kGlassExempt = <String, String>{
  'molecules/tooltip/app_tooltip.dart':
      'cláusula 2: é uma marca presa ao alvo (mensagem fixa, IgnorePointer), '
      'não um contêiner; o fill escuro é escolhido para garantir contraste num '
      'rótulo transitório. Também falha a cláusula 3 ao sair o hover.',
  'molecules/charts/chart_tooltip.dart':
      'cláusula 2: além de ser rótulo fixo, o que está atrás dele É o dado que '
      'ele descreve — desfocar o referente para decorar a leitura é o avesso do '
      'objetivo.',
  'atoms/loadings/app_overlay_loading.dart':
      'cláusula 2: é uma barreira ("não interativo agora"), não uma superfície '
      'de conteúdo. Um scrim desfocado é uma feature legítima, mas com token '
      'próprio (full-bleed, sem raio/rim/sheen) — não o AppGlassSurface.',
  'organisms/bottom_sheets/app_bottom_sheet_page.dart':
      'cláusula 1: é uma página edge-to-edge que cobre a tela, não um painel '
      'flutuante — não há o que desfocar atrás.',
  'molecules/snackbar/app_snackbar.dart':
      'fora do escopo da rodada atual. Passa nas três cláusulas, mas carrega um '
      'tint semântico (role@10%) que o AppGlassSurface ainda não sabe compor; '
      'migrar sem isso apagaria o significado do AppSnackbarType.',
  'molecules/overlay_alert/app_overlay_alert.dart':
      'fora do escopo da rodada atual — mesmo motivo do AppSnackbar (tint '
      'semântico por tipo).',
  'molecules/alert/app_alert.dart':
      'cláusula 1: banner inline, ocupa espaço no fluxo do conteúdo. Mesma '
      'cláusula que exclui o AppCard.',
};
