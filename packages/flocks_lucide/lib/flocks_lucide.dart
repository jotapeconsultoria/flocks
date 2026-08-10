/// Os ícones do [Lucide](https://lucide.dev) como `AppIconProvider` do Flocks
/// — em fonte, e tree-shakeable.
///
/// O `LucideIconProvider` serve os 55 `AppIconToken` do contrato. Os outros
/// chegam por [FlocksLucide], escritos como constante, que é o que preserva o
/// tree-shaking — ver a doc do provider.
library;

export 'src/flocks_to_lucide.dart';
export 'src/generated/flocks_lucide_icons.dart';
export 'src/generated/lucide_contract.dart';
export 'src/lucide_icon.dart';
export 'src/lucide_icon_provider.dart';
