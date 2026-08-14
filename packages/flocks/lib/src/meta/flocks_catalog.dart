import '../atoms/avatars/app_avatar.meta.dart';
import '../atoms/badge/app_badge.meta.dart';
import '../atoms/checkbox/app_checkbox.meta.dart';
import '../atoms/divider/app_divider.meta.dart';
import '../atoms/icons/app_icon.meta.dart';
import '../atoms/illustrations/app_illustration.meta.dart';
import '../atoms/images/app_image.meta.dart';
import '../atoms/loadings/loadings.meta.dart';
import '../atoms/radio/app_radio.meta.dart';
import '../atoms/shortcut/app_shortcut_hint.meta.dart';
import '../atoms/steppers/app_dots_indicator.meta.dart';
import '../atoms/steppers/app_stepper.meta.dart';
import '../atoms/surface/app_scroll_edge_fade.meta.dart';
import '../atoms/surface/app_side_inset.meta.dart';
import '../atoms/surface/app_surface.meta.dart';
import '../atoms/swatch/app_swatch.meta.dart';
import '../atoms/switch/app_switch.meta.dart';
import '../atoms/texts/app_rich_text.meta.dart';
import '../atoms/texts/app_text.meta.dart';
import '../molecules/action_items/action_items.meta.dart';
import '../molecules/alert/app_alert.meta.dart';
import '../molecules/breadcrumb/app_breadcrumb.meta.dart';
import '../molecules/buttons/app_button.meta.dart';
import '../molecules/buttons/app_floating_button.meta.dart';
import '../molecules/buttons/app_segmented_button.meta.dart';
import '../molecules/buttons/app_split_button.meta.dart';
import '../molecules/card/app_card.meta.dart';
import '../molecules/charts/app_area_chart.meta.dart';
import '../molecules/charts/app_bar_chart.meta.dart';
import '../molecules/charts/app_bubble_chart.meta.dart';
import '../molecules/charts/app_chart_shell.meta.dart';
import '../molecules/charts/app_donut_chart.meta.dart';
import '../molecules/charts/app_gauge_chart.meta.dart';
import '../molecules/charts/app_line_chart.meta.dart';
import '../molecules/charts/app_pie_chart.meta.dart';
import '../molecules/chat/app_assistant_status.meta.dart';
import '../molecules/chat/app_chat_action_bar.meta.dart';
import '../molecules/chat/app_chat_attachment_card.meta.dart';
import '../molecules/chat/app_chat_attachment_chip.meta.dart';
import '../molecules/chat/app_chat_bubble.meta.dart';
import '../molecules/chat/app_chat_composer.meta.dart';
import '../molecules/chat/app_chat_day_divider.meta.dart';
import '../molecules/chat/app_chat_message_list.meta.dart';
import '../molecules/chat/app_message_meta.meta.dart';
import '../molecules/chat/app_question_card.meta.dart';
import '../molecules/chat/app_quoted_message.meta.dart';
import '../molecules/chat/app_suggestion_chip.meta.dart';
import '../molecules/filter_chip/app_filter_chip.meta.dart';
import '../organisms/timeline/app_timeline.meta.dart';
import '../molecules/chat/app_typing_indicator.meta.dart';
import '../molecules/color_picker/color_picker.meta.dart';
import '../molecules/copy/app_copy_button.meta.dart';
import '../molecules/date_picker/date_picker.meta.dart';
import '../molecules/dropdown/app_dropdown.meta.dart';
import '../molecules/dropdown/app_multi_select.meta.dart';
import '../molecules/dropdown/app_searchable_dropdown.meta.dart';
import '../molecules/dropdown/app_searchable_multi_select.meta.dart';
import '../molecules/expansion_tile/app_expansion_tile.meta.dart';
import '../molecules/footers/app_buttons_footer.meta.dart';
import '../molecules/footers/app_chat_footer.meta.dart';
import '../molecules/footers/app_navigation_footer.meta.dart';
import '../molecules/footers/app_search_footer.meta.dart';
import '../molecules/footers/app_simple_footer.meta.dart';
import '../molecules/headers/app_primary_header.meta.dart';
import '../molecules/headers/app_simple_header.meta.dart';
import '../molecules/input/app_input.meta.dart';
import '../molecules/input/picker_inputs.meta.dart';
import '../molecules/interactive/app_hover_highlight.meta.dart';
import '../molecules/interactive/app_interaction.meta.dart';
import '../molecules/list_empty/app_list_empty.meta.dart';
import '../molecules/list_tile/app_list_tile.meta.dart';
import '../molecules/list_tile/app_list_tile_action.meta.dart';
import '../molecules/list_tile/app_list_tile_checkbox.meta.dart';
import '../molecules/list_tile/app_list_tile_draggable_checkbox.meta.dart';
import '../molecules/list_tile/app_list_tile_group.meta.dart';
import '../molecules/list_tile/app_list_tile_radio.meta.dart';
import '../molecules/list_tile/app_tile_info.meta.dart';
import '../molecules/menu/app_menu.meta.dart';
import '../molecules/number_stepper/app_number_stepper.meta.dart';
import '../molecules/overlay_alert/overlay_alert.meta.dart';
import '../molecules/overlay_card/overlay_card.meta.dart';
import '../molecules/pagination/app_pagination.meta.dart';
import '../molecules/pickers/app_picker_anchor.meta.dart';
import '../molecules/popover/app_popover.meta.dart';
import '../molecules/rating/app_rating.meta.dart';
import '../molecules/slider/app_slider.meta.dart';
import '../molecules/snackbar/snackbar.meta.dart';
import '../molecules/time_picker/time_picker.meta.dart';
import '../molecules/tooltip/app_tooltip.meta.dart';
import '../organisms/api_docs/api_docs.meta.dart';
import '../organisms/assistant_panel/assistant_panel.meta.dart';
import '../organisms/bottom_sheets/bottom_sheets.meta.dart';
import '../organisms/content/content.meta.dart';
import '../organisms/data_table/data_table.meta.dart';
import '../organisms/dialogs/dialogs.meta.dart';
import '../organisms/form_wizard/form_wizard.meta.dart';
import '../organisms/navigation_rail/navigation_rail.meta.dart';
import '../organisms/omni_search/omni_search.meta.dart';
import '../organisms/resizable_panel/resizable_panel.meta.dart';
import '../organisms/resizable_split/resizable_split.meta.dart';
import '../organisms/scaffolds/scaffolds.meta.dart';
import '../organisms/shell/shell.meta.dart';
import '../organisms/side_sheets/side_sheets.meta.dart';
import '../organisms/tab_view/tab_view.meta.dart';
import '../organisms/workspace_tabs/workspace_tabs.meta.dart';
import 'app_component_meta.dart';

/// Catálogo de componentes do Flocks — fonte para o serializador de metadados
/// (`tool/serialize_meta.dart`) e o validador (`tool/validate_components.dart`).
///
/// Cada componente migrado registra aqui o seu `*.meta.dart`.
const List<AppComponentMeta> flocksCatalog = <AppComponentMeta>[
  appTextMeta,
  appRichTextMeta,
  appIconMeta,
  appAvatarMeta,
  appIllustrationMeta,
  appRadioMeta,
  appCheckboxMeta,
  appSwitchMeta,
  appDotsIndicatorMeta,
  appStepperMeta,
  appCircularLoadingMeta,
  appLinearLoadingMeta,
  appBorderProgressMeta,
  appOverlayLoadingMeta,
  appShimmerLoadingMeta,
  appDividerMeta,
  appBadgeMeta,
  appTooltipMeta,
  appInteractionMeta,
  appHoverHighlightMeta,
  appCopyButtonMeta,
  appBreadcrumbMeta,
  appButtonMeta,
  appFloatingButtonMeta,
  appDropdownMeta,
  appInputMeta,
  appDatePickerInputMeta,
  appTimePickerInputMeta,
  appDateTimePickerInputMeta,
  appDatePickerMeta,
  appDateRangePickerMeta,
  appTimePickerMeta,
  appColorPickerInputMeta,
  appColorPickerPanelMeta,
  appMultiSelectMeta,
  appSearchableDropdownMeta,
  appSearchableMultiSelectMeta,
  appPieChartMeta,
  appDonutChartMeta,
  appLineChartMeta,
  appAreaChartMeta,
  appBarChartMeta,
  appBubbleChartMeta,
  appGaugeChartMeta,
  appChartShellMeta,
  appExpansionTileMeta,
  appSimpleHeaderMeta,
  appPrimaryHeaderMeta,
  appButtonsFooterMeta,
  appSimpleFooterMeta,
  appNavigationFooterMeta,
  appSearchFooterMeta,
  appChatFooterMeta,
  appListEmptyMeta,
  appTileInfoMeta,
  appListTileMeta,
  appListTileActionMeta,
  appListTileCheckboxMeta,
  appListTileDraggableCheckboxMeta,
  appListTileRadioMeta,
  appListTileGroupMeta,
  appAlertMeta,
  appMenuMeta,
  appNumberStepperMeta,
  appCardMeta,
  appPaginationMeta,
  appPickerAnchorMeta,
  appPopoverMeta,
  appRatingMeta,
  appSliderMeta,
  appSegmentedButtonMeta,
  appSplitButtonMeta,
  appSnackbarMeta,
  appSurfaceMeta,
  appScrollEdgeFadeMeta,
  appScrollEdgeFadeOwnerMeta,
  appSideInsetMeta,
  appShortcutHintMeta,
  appImageMeta,
  appSwatchMeta,
  // Chat (LLM + WhatsApp).
  appChatBubbleMeta,
  appMessageMetaMeta,
  appChatComposerMeta,
  appChatAttachmentChipMeta,
  appChatAttachmentCardMeta,
  appTypingIndicatorMeta,
  appAssistantStatusMeta,
  appChatActionBarMeta,
  appFilterChipMeta,
  appTimelineMeta,
  appSuggestionChipMeta,
  appChatDayDividerMeta,
  appQuestionCardMeta,
  appQuotedMessageMeta,
  appChatMessageListMeta,
  // Organisms.
  appMarkdownMeta,
  appHtmlMeta,
  appCodeBlockMeta,
  appDataTableMeta,
  appSimpleDataTableMeta,
  appNavigationRailMeta,
  appNavigationRailItemMeta,
  appNavigationRailProfileMeta,
  appNavigationRailFilterMeta,
  appFormWizardMeta,
  appTabViewMeta,
  appResizablePanelMeta,
  appResizableSplitMeta,
  appWorkspaceTabsMeta,
  appOverlayAlertMeta,
  appOverlayCardMeta,
  appActionItemMeta,
  appDialogMeta,
  appDialogContentMeta,
  appShellMeta,
  appOmniSearchMeta,
  appAssistantPanelMeta,
  appScaffoldMeta,
  appAuthSplitLayoutMeta,
  appBottomSheetMeta,
  appBottomSheetPageMeta,
  appBottomSheetContentMeta,
  appSideSheetMeta,
  appSideSheetPageMeta,
  // Documentação de API por contexto de tela.
  appApiMethodBadgeMeta,
  appApiPathMeta,
  appApiParamTableMeta,
  appApiSchemaTreeMeta,
  appApiEndpointTileMeta,
  appApiFlowMeta,
  appApiDocsPanelMeta,
  appEntityDocPanelMeta,
  appDocsWorkspaceMeta,
];
