import 'package:flutter/widgets.dart';

import '../../atoms/badge/app_badge.dart';
import '../../atoms/icons/icons.dart';
import '../../atoms/texts/texts.dart';
import '../../foundation/a11y/app_semantics.dart';
import '../../foundation/flocks_interaction.dart';
import '../../motion/motion.dart';
import '../../theme/theme.dart';
import '../../tokens/app_colors.dart';
import '../../tokens/app_icon_token.dart';
import '../../tokens/app_spacings.dart';
import '../content/app_content_style.dart';
import 'app_api_models.dart';

/// Recuo por nível de aninhamento.
const double kAppApiSchemaIndent = AppSpacings.s16;

/// Árvore de campos de um schema (corpo de requisição ou de resposta).
///
/// Cada linha é `nome · tipo · obrigatório · descrição`; campos com subcampos
/// viram um nó abrível ([AppExpand]), fechado por padrão a partir de
/// [initiallyExpandedDepth]. Manter os níveis fundos fechados é o que impede um
/// schema real (que aninha paginação, entidade e relacionamentos) de virar uma
/// parede de texto.
///
/// Renderiza vazio quando [fields] é vazio.
final class AppApiSchemaTree extends StatelessWidget {
  /// Cria um [AppApiSchemaTree].
  const AppApiSchemaTree(
    this.fields, {
    this.initiallyExpandedDepth = 1,
    super.key,
  });

  /// Campos do nível raiz.
  final List<AppApiField> fields;

  /// Até que profundidade (0-based) os nós nascem abertos. Default 1 — a raiz
  /// abre, o resto o leitor abre se quiser.
  final int initiallyExpandedDepth;

  @override
  Widget build(BuildContext context) {
    if (fields.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final AppApiField f in fields)
          _SchemaNode(
            field: f,
            depth: 0,
            initiallyExpandedDepth: initiallyExpandedDepth,
          ),
      ],
    );
  }
}

class _SchemaNode extends StatefulWidget {
  const _SchemaNode({
    required this.field,
    required this.depth,
    required this.initiallyExpandedDepth,
  });

  final AppApiField field;
  final int depth;
  final int initiallyExpandedDepth;

  @override
  State<_SchemaNode> createState() => _SchemaNodeState();
}

class _SchemaNodeState extends State<_SchemaNode> {
  late bool _expanded =
      widget.field.hasChildren && widget.depth < widget.initiallyExpandedDepth;

  void _toggle() {
    if (!widget.field.hasChildren) return;
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final AppApiField f = widget.field;
    final TextStyle mono = AppContentStyle.resolve(context).code;
    final TextStyle muted = theme.textTheme.bodySmall.copyWith(
      color: colors.neutralPrimary.s600,
    );

    final Widget row = Padding(
      padding: EdgeInsetsDirectional.only(
        start: widget.depth * kAppApiSchemaIndent,
        top: AppSpacings.s4,
        bottom: AppSpacings.s4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // O chevron ocupa a mesma caixa mesmo quando o campo é folha: sem
          // isso os nomes dançariam horizontalmente entre nós e folhas.
          SizedBox(
            width: AppSpacings.s16,
            child: f.hasChildren
                ? AppAnimatedRotation(
                    turns: _expanded ? 0.25 : 0.0,
                    child: AppIcon(
                      AppIconToken.chevronRight,
                      size: AppIconSize.s,
                      color: colors.onSurface,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacings.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Wrap(
                  spacing: AppSpacings.s8,
                  runSpacing: AppSpacings.s4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    AppText(
                      f.name,
                      style: mono.copyWith(color: colors.onSurface),
                    ),
                    AppText(f.type, style: mono.copyWith(color: muted.color)),
                    if (f.isRequired)
                      const AppBadge(
                        'obrigatório',
                        color: AppBadgeColor.danger,
                        size: AppBadgeSize.s,
                      ),
                  ],
                ),
                if (f.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacings.s2),
                    child: AppText(f.description!, style: muted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    final Widget header = f.hasChildren
        ? AppSemantics.button(
            label: f.name,
            enabled: true,
            onTap: _toggle,
            child: FlocksInteraction(
              onPressed: _toggle,
              selected: _expanded,
              builder: (BuildContext context, Set<WidgetState> states) {
                final bool hovered = states.contains(WidgetState.hovered);
                final bool pressed = states.contains(WidgetState.pressed);
                return ColoredBox(
                  color: pressed
                      ? colors.onSurface.withValues(alpha: 0.12)
                      : hovered
                      ? colors.onSurface.withValues(alpha: 0.08)
                      : colors.transparent,
                  child: SelectionContainer.disabled(child: row),
                );
              },
            ),
          )
        : row;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        header,
        AppExpand(
          child: _expanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (final AppApiField child in f.children)
                      _SchemaNode(
                        field: child,
                        depth: widget.depth + 1,
                        initiallyExpandedDepth: widget.initiallyExpandedDepth,
                      ),
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
