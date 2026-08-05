/// Metadados de componentes do Flocks (para documentação e futuro MCP server).
///
/// Separado do barrel principal (`flocks.dart`) por ser uma preocupação de
/// build/documentação, não de runtime da UI. Cada `*.meta.dart` de componente
/// importa daqui. Ver Regra 6 em `docs/FLOCKS_MIGRATION_PLAN.md`.
library;

export 'src/meta/app_component_meta.dart';
export 'src/meta/flocks_catalog.dart';
