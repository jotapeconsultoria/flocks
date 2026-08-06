/// Metadados de componentes do Flocks (para documentação e futuro MCP server).
///
/// Separado do barrel principal (`flocks.dart`) por ser uma preocupação de
/// build/documentação, não de runtime da UI. Cada `*.meta.dart` de componente
/// importa daqui. Todo componente migrado precisa declarar seus `props` — é o
/// que o MCP serve —, e `tool/component_conformance.dart` reprova quem não o
/// fizer (Regra 6).
library;

export 'src/meta/app_component_meta.dart';
export 'src/meta/flocks_catalog.dart';
