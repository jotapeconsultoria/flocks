import 'package:flutter/widgets.dart';

import '../../atoms/icons/icons.dart';
import '../../atoms/surface/surface.dart';
import '../../atoms/texts/texts.dart';
import '../../theme/theme.dart';
import '../../tokens/tokens.dart';
import '../interactive/interactive.dart';

/// Chip de **filtro aplicado**, com afordância de REMOVER.
///
/// É o irmão do `AppSuggestionChip` e resolve a outra metade do problema: o de
/// sugestão convida a aplicar, este mostra o que já está aplicado e oferece
/// tirar. Sem a segunda, um filtro aplicado vira estado invisível — a lista
/// aparece curta e ninguém lembra por quê.
///
/// O rótulo é `campo: valor`, e os dois vêm separados de propósito: o campo
/// entra em peso menor, para que a leitura rápida caia sobre o VALOR, que é o
/// que distingue um chip do outro numa fila deles.
///
/// ```dart
/// Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
///   AppFilterChip(field: 'Tipo', value: 'client.created', onRemove: _clearType),
///   AppFilterChip(field: 'Resultado', value: 'Negado', onRemove: _clearResult),
/// ])
/// ```
final class AppFilterChip extends StatelessWidget {
  /// Cria um [AppFilterChip].
  const AppFilterChip({
    required this.value,
    this.field,
    this.onRemove,
    this.onTap,
    this.style,
    this.radiusMode,
    this.radius,
    super.key,
  });

  /// Nome do campo filtrado. Opcional: um filtro autoexplicativo dispensa.
  final String? field;

  /// Valor aplicado. É o que a leitura rápida precisa encontrar.
  final String value;

  /// Remove o filtro. `null` esconde o "×" — o chip vira só informação.
  final VoidCallback? onRemove;

  /// Toque no corpo do chip (abrir o seletor daquele filtro, em geral).
  final VoidCallback? onTap;

  /// Estilo de container. Default [AppStyle.filled].
  ///
  /// Filled e não outlined: filtro aplicado é ESTADO, e estado se lê pelo
  /// preenchimento. O chip de sugestão é ação, e ação se lê pela borda.
  final AppStyle? style;

  /// Override local do modo de forma. Vence o global.
  final AppRadiusMode? radiusMode;

  /// Override cru do raio (px). Vence [radiusMode] e o global.
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final AppColorTheme colors = theme.colorTheme;
    final BorderRadius br = radius != null
        ? BorderRadius.circular(radius!)
        : theme.radiusTheme.resolve(override: radiusMode);
    final String label = field == null ? value : '$field: $value';

    return AppSurface(
      variant: AppSurfaceVariant.flat,
      style: style ?? AppStyle.filled,
      radius: br,
      padding: const EdgeInsets.only(
        left: AppSpacings.s12,
        right: AppSpacings.s4,
        top: AppSpacings.s4,
        bottom: AppSpacings.s4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: AppInteraction(
              onTap: onTap,
              semanticLabel: label,
              radius: br,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacings.s4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (field != null) ...<Widget>[
                      AppText(
                        '$field: ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        // O campo entra ATENUADO para que a leitura rápida
                        // caia sobre o valor. O tema não tem um
                        // `onSurfaceVariant`; o secundário do package é o
                        // `onSurface` com alfa, que é como o `divider` também
                        // se define.
                        style: theme.textTheme.bodySmall.withColor(
                          colors.onSurface.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                    Flexible(
                      child: AppText(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall.withColor(
                          colors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (onRemove != null) ...<Widget>[
            const SizedBox(width: AppSpacings.s4),
            // O "×" é alvo de toque PRÓPRIO, e não um ícone dentro do toque do
            // chip: remover e editar são ações diferentes, e um alvo só faria
            // uma delas acontecer por engano toda vez.
            AppInteraction(
              onTap: onRemove,
              semanticLabel: 'Remover filtro $label',
              radius: BorderRadius.circular(999),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.s4),
                child: AppIcon(
                  AppIconToken.close,
                  color: colors.onSurface.withValues(alpha: 0.72),
                  size: AppIconSize.s,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
