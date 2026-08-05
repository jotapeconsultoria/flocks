import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/app_spacings.dart';
import 'app_api_docs_panel.dart';
import 'app_api_endpoint_tile.dart';
import 'app_api_flow.dart';
import 'app_api_method_badge.dart';
import 'app_api_models.dart';
import 'app_api_param_table.dart';
import 'app_api_path.dart';
import 'app_api_schema_tree.dart';
import 'app_docs_workspace.dart';
import 'app_entity_doc_panel.dart';
import 'app_entity_models.dart';

// Previews nativos (Regra 5) — recorte real da API da Tracked: o CRUD de
// dispositivos e a associação com chip, que é o caso que motivou o grupo.

const AppApiEndpoint _listDevices = AppApiEndpoint(
  method: AppApiMethod.get,
  path: '/devices',
  summary: 'Listar devices',
  tags: <String>['Devices'],
  params: <AppApiParam>[
    AppApiParam(
      name: 'filter',
      location: AppApiParamLocation.query,
      type: 'string',
      description: 'Filtro textual',
    ),
    AppApiParam(
      name: 'page',
      location: AppApiParamLocation.query,
      type: 'integer',
      description: 'Número da página',
      defaultValue: '1',
    ),
  ],
  responses: <AppApiResponse>[
    AppApiResponse(status: 200, description: 'Lista de devices'),
    AppApiResponse(status: 401, description: 'Não autorizado'),
  ],
);

const AppApiEndpoint _createAssociation = AppApiEndpoint(
  method: AppApiMethod.post,
  path: '/associations/device-sim-card',
  summary: 'Associar um chip a um device',
  tags: <String>['Associations'],
  requestFields: <AppApiField>[
    AppApiField(name: 'device_id', type: 'string(uuid)', isRequired: true),
    AppApiField(name: 'sim_card_id', type: 'string(uuid)', isRequired: true),
  ],
  requestExampleJson: '{\n  "device_id": "…",\n  "sim_card_id": "…"\n}',
  responses: <AppApiResponse>[
    AppApiResponse(status: 201, description: 'Associação criada'),
    AppApiResponse(status: 409, description: 'Chip já associado'),
  ],
);

const AppApiFlowData _flow = AppApiFlowData(
  title: 'Colocar um dispositivo em operação',
  description: 'A ordem importa: sem chip ativo o device não transmite.',
  steps: <AppApiFlowStep>[
    AppApiFlowStep(
      title: 'Cadastrar o dispositivo',
      method: AppApiMethod.post,
      path: '/devices',
    ),
    AppApiFlowStep(
      title: 'Associar o chip',
      method: AppApiMethod.post,
      path: '/associations/device-sim-card',
      note: 'O chip precisa estar ACTIVE na operadora.',
    ),
    AppApiFlowStep(
      title: 'Associar o veículo',
      method: AppApiMethod.post,
      path: '/associations/vehicle-device',
    ),
  ],
);

const AppApiDoc _doc = AppApiDoc(
  title: 'Dispositivos',
  subtitle: 'Cadastro de rastreadores e suas associações.',
  baseUrl: 'https://tracked.jotapetecnologia.api.br',
  groups: <AppApiGroup>[
    AppApiGroup(
      title: 'CRUD de dispositivos',
      endpoints: <AppApiEndpoint>[_listDevices],
    ),
    AppApiGroup(
      title: 'Associação de chip',
      endpoints: <AppApiEndpoint>[_createAssociation],
    ),
  ],
  flows: <AppApiFlowData>[_flow],
);

Widget _frame(AppThemeData data, Widget child) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surface,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: SingleChildScrollView(child: child),
    ),
  ),
);

@Preview(name: 'AppApiEndpointTile • claro')
Widget appApiEndpointTileLightPreview() => _frame(
  AppThemeData.light,
  const AppApiEndpointTile(
    endpoint: _createAssociation,
    initiallyExpanded: true,
  ),
);

@Preview(name: 'AppApiEndpointTile • escuro')
Widget appApiEndpointTileDarkPreview() => _frame(
  AppThemeData.dark,
  const AppApiEndpointTile(
    endpoint: _createAssociation,
    initiallyExpanded: true,
  ),
);

@Preview(name: 'AppApiFlow • claro')
Widget appApiFlowLightPreview() =>
    _frame(AppThemeData.light, const AppApiFlow(flow: _flow));

@Preview(name: 'AppApiFlow • escuro')
Widget appApiFlowDarkPreview() =>
    _frame(AppThemeData.dark, const AppApiFlow(flow: _flow));

@Preview(name: 'AppApiDocsPanel • claro')
Widget appApiDocsPanelLightPreview() =>
    _frame(AppThemeData.light, const AppApiDocsPanel(doc: _doc));

@Preview(name: 'AppApiDocsPanel • escuro')
Widget appApiDocsPanelDarkPreview() =>
    _frame(AppThemeData.dark, const AppApiDocsPanel(doc: _doc));

// As peças que o painel compõe, vistas isoladas — é onde se vê a largura fixa
// do badge (que alinha os paths de uma lista) e o recuo da árvore de schema.

const List<AppApiField> _deviceSchema = <AppApiField>[
  AppApiField(name: 'id', type: 'string(uuid)', isRequired: true),
  AppApiField(name: 'imei', type: 'string', isRequired: true),
  AppApiField(
    name: 'sim_card',
    type: 'object',
    description: 'Chip associado, quando houver.',
    children: <AppApiField>[
      AppApiField(name: 'iccid', type: 'string', isRequired: true),
      AppApiField(name: 'carrier', type: 'string'),
    ],
  ),
];

const AppEntityDoc _deviceEntity = AppEntityDoc(
  title: 'Dispositivo',
  subtitle: 'O rastreador físico instalado no veículo.',
  overview:
      'Identificado pelo **IMEI**. Só transmite com um chip `ACTIVE` '
      'associado.',
  relations: <AppEntityRelation>[
    AppEntityRelation(
      target: 'Veículo',
      kind: AppEntityRelationKind.manyToOne,
      description: 'Um veículo tem um dispositivo de rastreio por vez.',
    ),
    AppEntityRelation(
      target: 'Chip',
      kind: AppEntityRelationKind.oneToOne,
      via: 'associations/device-sim-card',
    ),
  ],
  integrations: <AppEntityIntegration>[
    AppEntityIntegration(
      name: 'Queclink @Track',
      direction: AppEntityIntegrationDirection.bidirectional,
      description: 'Telemetria de entrada e comandos de saída.',
    ),
  ],
  sections: <AppEntityDocSection>[
    AppEntityDocSection(
      title: 'Ciclo de vida',
      body: 'Cadastrado → chip associado → veículo associado → transmitindo.',
    ),
  ],
);

Widget _pieces() => const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  spacing: AppSpacings.s24,
  children: <Widget>[
    Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacings.s8,
      children: <Widget>[
        AppApiMethodBadge(AppApiMethod.get),
        AppApiPath('/devices/{id}/associations'),
      ],
    ),
    AppApiParamTable(<AppApiParam>[
      AppApiParam(
        name: 'id',
        location: AppApiParamLocation.path,
        type: 'string(uuid)',
        isRequired: true,
      ),
      AppApiParam(
        name: 'page',
        location: AppApiParamLocation.query,
        type: 'integer',
        defaultValue: '1',
      ),
    ]),
    AppApiSchemaTree(_deviceSchema),
  ],
);

@Preview(name: 'Peças (badge/path/params/schema) • claro')
Widget appApiPiecesLightPreview() => _frame(AppThemeData.light, _pieces());

@Preview(name: 'Peças (badge/path/params/schema) • escuro')
Widget appApiPiecesDarkPreview() => _frame(AppThemeData.dark, _pieces());

@Preview(name: 'AppEntityDocPanel • claro')
Widget appEntityDocPanelLightPreview() =>
    _frame(AppThemeData.light, const AppEntityDocPanel(doc: _deviceEntity));

@Preview(name: 'AppEntityDocPanel • escuro')
Widget appEntityDocPanelDarkPreview() =>
    _frame(AppThemeData.dark, const AppEntityDocPanel(doc: _deviceEntity));

// O workspace divide a tela, então precisa de caixa — sem altura o split não
// tem o que repartir.
Widget _workspace(AppThemeData data) => AppTheme(
  data: data,
  child: ColoredBox(
    color: data.colorTheme.surface,
    child: const SizedBox(
      width: 900,
      height: 560,
      child: AppDocsWorkspace(entity: _deviceEntity, api: _doc),
    ),
  ),
);

@Preview(name: 'AppDocsWorkspace • claro')
Widget appDocsWorkspaceLightPreview() => _workspace(AppThemeData.light);

@Preview(name: 'AppDocsWorkspace • escuro')
Widget appDocsWorkspaceDarkPreview() => _workspace(AppThemeData.dark);
