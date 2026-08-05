import 'package:flocks/flocks.dart';

/// Recorte real do Swagger da Tracked (`GET /devices`,
/// `POST /associations/device-sim-card`, `POST /associations/vehicle-device`)
/// usado pelos testes e pelos goldens do grupo `api_docs`.
///
/// Vale ser fiel ao payload real: um schema inventado esconde exatamente os
/// casos que quebram (aninhamento de paginação, campo opcional sem descrição).
const AppApiEndpoint kListDevices = AppApiEndpoint(
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
    AppApiResponse(status: 500, description: 'Erro interno'),
  ],
  curl:
      "curl -X GET 'https://api.local/devices' \\\n"
      "  -H 'Authorization: Bearer <seu_token>'",
);

const AppApiEndpoint kCreateSimAssociation = AppApiEndpoint(
  method: AppApiMethod.post,
  path: '/associations/device-sim-card',
  summary: 'Associar um chip a um device',
  tags: <String>['Associations'],
  params: <AppApiParam>[
    AppApiParam(
      name: 'request',
      location: AppApiParamLocation.body,
      type: 'object',
      isRequired: true,
      description: 'Dados da associação',
    ),
  ],
  requestFields: <AppApiField>[
    AppApiField(name: 'device_id', type: 'string(uuid)', isRequired: true),
    AppApiField(name: 'sim_card_id', type: 'string(uuid)', isRequired: true),
  ],
  requestExampleJson:
      '{\n  "device_id": "string",\n  "sim_card_id": "string"\n}',
  responses: <AppApiResponse>[
    AppApiResponse(status: 201, description: 'Associação criada'),
    AppApiResponse(status: 409, description: 'Chip já associado'),
  ],
);

const AppApiEndpoint kCreateVehicleAssociation = AppApiEndpoint(
  method: AppApiMethod.post,
  path: '/associations/vehicle-device',
  summary: 'Associar um device a um veículo',
  tags: <String>['Associations'],
  responses: <AppApiResponse>[
    AppApiResponse(status: 201, description: 'Associação criada'),
  ],
);

/// Árvore com dois níveis — exercita o teto de profundidade do
/// [AppApiSchemaTree].
const List<AppApiField> kNestedFields = <AppApiField>[
  AppApiField(
    name: 'data',
    type: 'object',
    isRequired: true,
    children: <AppApiField>[
      AppApiField(
        name: 'items',
        type: 'array[Device]',
        children: <AppApiField>[
          AppApiField(name: 'imei', type: 'string', isRequired: true),
          AppApiField(name: 'active', type: 'boolean'),
        ],
      ),
      AppApiField(name: 'total', type: 'integer'),
    ],
  ),
];

const AppApiFlowData kDeviceFlow = AppApiFlowData(
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

const AppApiDoc kDevicesDoc = AppApiDoc(
  title: 'Dispositivos',
  subtitle: 'Cadastro de rastreadores e suas associações com chip e veículo.',
  baseUrl: 'https://api.local',
  groups: <AppApiGroup>[
    AppApiGroup(
      title: 'CRUD de dispositivos',
      endpoints: <AppApiEndpoint>[kListDevices],
    ),
    AppApiGroup(
      title: 'Associação de chip',
      endpoints: <AppApiEndpoint>[kCreateSimAssociation],
    ),
    AppApiGroup(
      title: 'Associação de veículo',
      endpoints: <AppApiEndpoint>[kCreateVehicleAssociation],
    ),
  ],
  flows: <AppApiFlowData>[kDeviceFlow],
);

/// MOCK de entidade usado pelos testes e goldens do painel de conceito.
const AppEntityDoc kDeviceEntity = AppEntityDoc(
  title: 'Dispositivo',
  subtitle: 'O rastreador físico instalado no veículo.',
  overview: 'Um **dispositivo** é o hardware que transmite posição.',
  relations: <AppEntityRelation>[
    AppEntityRelation(
      target: 'Chip (SIM card)',
      kind: AppEntityRelationKind.oneToOne,
      description: 'Um chip ativo por vez.',
      via: '/associations/device-sim-card',
    ),
    AppEntityRelation(
      target: 'Veículo',
      kind: AppEntityRelationKind.manyToOne,
      description: 'Um veículo pode ter mais de um dispositivo.',
      via: '/associations/vehicle-device',
    ),
  ],
  integrations: <AppEntityIntegration>[
    AppEntityIntegration(
      name: 'Gateway Queclink',
      direction: AppEntityIntegrationDirection.bidirectional,
      description: 'Recebe pacotes e envia comandos.',
    ),
    AppEntityIntegration(
      name: 'Allcom',
      direction: AppEntityIntegrationDirection.inbound,
      description: 'Sincroniza os chips da operadora.',
    ),
  ],
  sections: <AppEntityDocSection>[
    AppEntityDocSection(
      title: 'Ciclo de vida',
      body: '1. Cadastrado\n2. Conectado\n3. Em operação',
    ),
  ],
);
