import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// ---------------------------------------------------------------------------
// api_docs — per-screen API documentation. A real slice of the Tracked API
// (device CRUD + SIM/vehicle association) so the components are judged against
// the payload shape they actually have to render.
// ---------------------------------------------------------------------------

const AppApiEndpoint _listDevices = AppApiEndpoint(
  method: AppApiMethod.get,
  path: '/devices',
  summary: 'List devices',
  tags: <String>['Devices'],
  params: <AppApiParam>[
    AppApiParam(
      name: 'filter',
      location: AppApiParamLocation.query,
      type: 'string',
      description: 'Free-text filter',
    ),
    AppApiParam(
      name: 'page',
      location: AppApiParamLocation.query,
      type: 'integer',
      description: 'Page number',
      defaultValue: '1',
    ),
    AppApiParam(
      name: 'available',
      location: AppApiParamLocation.query,
      type: 'boolean',
      description: 'Only devices with no active vehicle association',
    ),
  ],
  responses: <AppApiResponse>[
    AppApiResponse(status: 200, description: 'Device list'),
    AppApiResponse(status: 401, description: 'Unauthorized'),
    AppApiResponse(status: 500, description: 'Internal error'),
  ],
  curl:
      "curl -X GET 'https://api.tracked.local/devices?page=1' \\\n"
      "  -H 'Authorization: Bearer <your_token>'",
);

const AppApiEndpoint _createDevice = AppApiEndpoint(
  method: AppApiMethod.post,
  path: '/devices',
  summary: 'Create a device',
  tags: <String>['Devices'],
  requestFields: <AppApiField>[
    AppApiField(name: 'imei', type: 'string', isRequired: true),
    AppApiField(
      name: 'device_model_id',
      type: 'string(uuid)',
      isRequired: true,
    ),
    AppApiField(name: 'active', type: 'boolean'),
  ],
  requestExampleJson:
      '{\n  "imei": "860123456789012",\n  "device_model_id": "…",\n'
      '  "active": true\n}',
  responses: <AppApiResponse>[
    AppApiResponse(status: 201, description: 'Device created'),
    AppApiResponse(status: 409, description: 'IMEI already registered'),
  ],
);

const AppApiEndpoint _deleteDevice = AppApiEndpoint(
  method: AppApiMethod.delete,
  path: '/devices/{id}',
  summary: 'Delete a device',
  tags: <String>['Devices'],
  params: <AppApiParam>[
    AppApiParam(
      name: 'id',
      location: AppApiParamLocation.path,
      type: 'string(uuid)',
      isRequired: true,
    ),
  ],
  responses: <AppApiResponse>[
    AppApiResponse(status: 204, description: 'Deleted'),
    AppApiResponse(status: 409, description: 'Device still associated'),
  ],
);

const AppApiEndpoint _associateSim = AppApiEndpoint(
  method: AppApiMethod.post,
  path: '/associations/device-sim-card',
  summary: 'Attach a SIM card to a device',
  tags: <String>['Associations'],
  requestFields: <AppApiField>[
    AppApiField(name: 'device_id', type: 'string(uuid)', isRequired: true),
    AppApiField(name: 'sim_card_id', type: 'string(uuid)', isRequired: true),
  ],
  requestExampleJson: '{\n  "device_id": "…",\n  "sim_card_id": "…"\n}',
  responses: <AppApiResponse>[
    AppApiResponse(status: 201, description: 'Association created'),
    AppApiResponse(status: 409, description: 'SIM already attached'),
  ],
);

const AppApiEndpoint _associateVehicle = AppApiEndpoint(
  method: AppApiMethod.post,
  path: '/associations/vehicle-device',
  summary: 'Attach a device to a vehicle',
  tags: <String>['Associations'],
  responses: <AppApiResponse>[
    AppApiResponse(status: 201, description: 'Association created'),
  ],
);

const List<AppApiField> _pagedResponse = <AppApiField>[
  AppApiField(
    name: 'data',
    type: 'object',
    isRequired: true,
    children: <AppApiField>[
      AppApiField(
        name: 'items',
        type: 'array[Device]',
        children: <AppApiField>[
          AppApiField(name: 'id', type: 'string(uuid)', isRequired: true),
          AppApiField(name: 'imei', type: 'string', isRequired: true),
          AppApiField(
            name: 'sim_card',
            type: 'SimCard',
            children: <AppApiField>[
              AppApiField(name: 'iccid', type: 'string'),
              AppApiField(name: 'carrier', type: 'string'),
            ],
          ),
        ],
      ),
      AppApiField(name: 'total', type: 'integer'),
      AppApiField(name: 'page', type: 'integer'),
    ],
  ),
];

const AppApiFlowData _flow = AppApiFlowData(
  title: 'Put a device into operation',
  description: 'Order matters: with no active SIM the device never transmits.',
  steps: <AppApiFlowStep>[
    AppApiFlowStep(
      title: 'Register the device',
      description: 'The IMEI has to match the model the tracker reports.',
      method: AppApiMethod.post,
      path: '/devices',
    ),
    AppApiFlowStep(
      title: 'Attach the SIM card',
      method: AppApiMethod.post,
      path: '/associations/device-sim-card',
      note: 'The SIM must be ACTIVE at the carrier.',
    ),
    AppApiFlowStep(
      title: 'Attach the vehicle',
      method: AppApiMethod.post,
      path: '/associations/vehicle-device',
    ),
    AppApiFlowStep(
      title: 'Wait for the first position',
      description: 'No call — the gateway ingests it asynchronously.',
    ),
  ],
);

const AppApiDoc _doc = AppApiDoc(
  title: 'Devices',
  subtitle: 'Tracker registry and its SIM/vehicle associations.',
  baseUrl: 'https://api.tracked.local',
  groups: <AppApiGroup>[
    AppApiGroup(
      title: 'Device CRUD',
      description: 'Everything the list screen reads and writes.',
      endpoints: <AppApiEndpoint>[_listDevices, _createDevice, _deleteDevice],
    ),
    AppApiGroup(
      title: 'SIM association',
      endpoints: <AppApiEndpoint>[_associateSim],
    ),
    AppApiGroup(
      title: 'Vehicle association',
      endpoints: <AppApiEndpoint>[_associateVehicle],
    ),
  ],
  flows: <AppApiFlowData>[_flow],
);

// --- AppApiMethodBadge -----------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppApiMethodBadge)
Widget apiMethodBadgePlayground(BuildContext context) {
  final AppApiMethod method = context.knobs.object.dropdown<AppApiMethod>(
    label: 'method',
    options: AppApiMethod.values,
    initialOption: AppApiMethod.post,
    labelBuilder: (AppApiMethod m) => m.label,
  );
  final AppBadgeSize size = context.knobs.object.dropdown<AppBadgeSize>(
    label: 'size',
    options: AppBadgeSize.values,
    initialOption: AppBadgeSize.s,
    labelBuilder: (AppBadgeSize s) => s.name,
  );
  final bool reserveColumn = context.knobs.boolean(
    label: 'width (reserve column)',
    initialValue: true,
  );

  return wbUseCase(
    context,
    name: 'AppApiMethodBadge',
    description:
        'The HTTP verb as a pill. Turn the column reserve off to see the '
        'natural width.',
    child: AppApiMethodBadge(
      method,
      size: size,
      width: reserveColumn ? kAppApiMethodBadgeWidth : null,
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppApiMethodBadge)
Widget apiMethodBadgeStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppApiMethodBadge',
  description:
      'Every verb at once — the colour is the information, so read it as a set.',
  child: const Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s8,
    runSpacing: AppSpacings.s8,
    children: <Widget>[
      AppApiMethodBadge(AppApiMethod.get, width: null),
      AppApiMethodBadge(AppApiMethod.post, width: null),
      AppApiMethodBadge(AppApiMethod.put, width: null),
      AppApiMethodBadge(AppApiMethod.patch, width: null),
      AppApiMethodBadge(AppApiMethod.delete, width: null),
      AppApiMethodBadge(AppApiMethod.head, width: null),
      AppApiMethodBadge(AppApiMethod.options, width: null),
    ],
  ),
);

// --- AppApiPath ------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppApiPath)
Widget apiPathPlayground(BuildContext context) {
  final String path = context.knobs.string(
    label: 'path',
    initialValue: '/devices/{id}/commands/template/{tid}',
  );
  final String prefix = context.knobs.string(label: 'prefix', initialValue: '');
  final int maxLines = context.knobs.int.slider(
    label: 'maxLines',
    initialValue: 1,
    min: 1,
    max: 3,
    divisions: 2,
  );

  return wbUseCase(
    context,
    name: 'AppApiPath',
    description: 'Placeholders in {braces} get the primary accent.',
    child: AppApiPath(
      path,
      prefix: prefix.isEmpty ? null : prefix,
      maxLines: maxLines,
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppApiPath)
Widget apiPathStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppApiPath',
  description:
      'Plain path, single placeholder, several placeholders, prefixed.',
  child: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      AppApiPath('/devices'),
      SizedBox(height: AppSpacings.s8),
      AppApiPath('/devices/{id}'),
      SizedBox(height: AppSpacings.s8),
      AppApiPath('/devices/{id}/commands/template/{tid}'),
      SizedBox(height: AppSpacings.s8),
      AppApiPath('/devices/{id}', prefix: 'https://api.tracked.local'),
    ],
  ),
);

// --- AppApiParamTable ------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppApiParamTable)
Widget apiParamTablePlayground(BuildContext context) {
  final bool showLocation = context.knobs.boolean(
    label: 'showLocation',
    initialValue: true,
  );
  final bool empty = context.knobs.boolean(
    label: 'empty list',
    initialValue: false,
  );

  return wbUseCase(
    context,
    name: 'AppApiParamTable',
    description:
        'Request parameters over AppSimpleDataTable. An empty list renders '
        'nothing, so the call site can include it unconditionally.',
    maxWidth: 720,
    panelPadding: AppSpacings.s24,
    child: AppApiParamTable(
      empty ? const <AppApiParam>[] : _listDevices.params,
      showLocation: showLocation,
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppApiParamTable)
Widget apiParamTableStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppApiParamTable',
  description:
      'Required vs optional, enum values and defaults, and the empty case.',
  maxWidth: 720,
  panelPadding: AppSpacings.s24,
  child: const AppApiParamTable(<AppApiParam>[
    AppApiParam(
      name: 'id',
      location: AppApiParamLocation.path,
      type: 'string(uuid)',
      isRequired: true,
      description: 'Device identifier',
    ),
    AppApiParam(
      name: 'sort_order',
      location: AppApiParamLocation.query,
      type: 'string',
      description: 'Sort direction',
      enumValues: <String>['asc', 'desc'],
      defaultValue: 'asc',
    ),
    AppApiParam(
      name: 'X-Request-Id',
      location: AppApiParamLocation.header,
      type: 'string',
    ),
  ]),
);

// --- AppApiSchemaTree ------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppApiSchemaTree)
Widget apiSchemaTreePlayground(BuildContext context) {
  final int depth = context.knobs.int.slider(
    label: 'initiallyExpandedDepth',
    initialValue: 1,
    min: 0,
    max: 3,
    divisions: 3,
  );

  return wbUseCase(
    context,
    name: 'AppApiSchemaTree',
    description:
        'A real paged response, three levels deep. Drop the depth to 0 to see '
        'why deep nodes start closed.',
    maxWidth: 720,
    panelPadding: AppSpacings.s24,
    child: AppApiSchemaTree(_pagedResponse, initiallyExpandedDepth: depth),
  );
}

@widgetbook.UseCase(name: 'States', type: AppApiSchemaTree)
Widget apiSchemaTreeStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppApiSchemaTree',
  description: 'Flat schema, nested schema and the empty case, side by side.',
  maxWidth: 720,
  panelPadding: AppSpacings.s24,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      wbState(
        context,
        name: 'Flat',
        width: 640,
        child: const AppApiSchemaTree(<AppApiField>[
          AppApiField(name: 'imei', type: 'string', isRequired: true),
          AppApiField(name: 'active', type: 'boolean'),
        ]),
      ),
      const SizedBox(height: AppSpacings.s24),
      wbState(
        context,
        name: 'Nested',
        width: 640,
        child: const AppApiSchemaTree(_pagedResponse),
      ),
      const SizedBox(height: AppSpacings.s24),
      wbState(
        context,
        name: 'Empty (renders nothing)',
        width: 640,
        child: const AppApiSchemaTree(<AppApiField>[]),
      ),
    ],
  ),
);

// --- AppApiEndpointTile ----------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppApiEndpointTile)
Widget apiEndpointTilePlayground(BuildContext context) {
  const List<(String, AppApiEndpoint)> options = <(String, AppApiEndpoint)>[
    ('GET /devices', _listDevices),
    ('POST /devices', _createDevice),
    ('DELETE /devices/{id}', _deleteDevice),
    ('POST /associations/device-sim-card', _associateSim),
  ];
  final (String, AppApiEndpoint) picked = context.knobs.object
      .dropdown<(String, AppApiEndpoint)>(
        label: 'endpoint',
        options: options,
        initialOption: options.first,
        labelBuilder: ((String, AppApiEndpoint) e) => e.$1,
      );
  final bool initiallyExpanded = context.knobs.boolean(
    label: 'initiallyExpanded',
    initialValue: true,
  );
  final bool showCopyPath = context.knobs.boolean(
    label: 'showCopyPath',
    initialValue: true,
  );
  final String baseUrl = context.knobs.string(
    label: 'baseUrl',
    initialValue: '',
  );

  return wbUseCase(
    context,
    name: 'AppApiEndpointTile',
    description: 'One endpoint, collapsed or open. Read-only by construction.',
    maxWidth: 760,
    panelPadding: AppSpacings.s24,
    child: AppApiEndpointTile(
      // The key forces a rebuild from scratch when the endpoint knob changes;
      // without it the tile would keep the previous open/closed state.
      key: ValueKey<String>(picked.$2.id),
      endpoint: picked.$2,
      baseUrl: baseUrl.isEmpty ? null : baseUrl,
      initiallyExpanded: initiallyExpanded,
      showCopyPath: showCopyPath,
      style: wbStyleKnob(context),
      radiusMode: wbRadiusModeKnob(context),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppApiEndpointTile)
Widget apiEndpointTileStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppApiEndpointTile',
  description:
      'Collapsed and expanded, plus a mutation with a request body. Hover and '
      'Tab react live on the canvas.',
  maxWidth: 760,
  panelPadding: AppSpacings.s24,
  child: const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      AppApiEndpointTile(endpoint: _listDevices),
      SizedBox(height: AppSpacings.s8),
      AppApiEndpointTile(endpoint: _deleteDevice),
      SizedBox(height: AppSpacings.s8),
      AppApiEndpointTile(endpoint: _associateSim, initiallyExpanded: true),
    ],
  ),
);

// --- AppApiFlow ------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppApiFlow)
Widget apiFlowPlayground(BuildContext context) {
  final bool navigable = context.knobs.boolean(
    label: 'onStepTap',
    initialValue: true,
  );

  return wbUseCase(
    context,
    name: 'AppApiFlow',
    description:
        'The order of the calls, as a numbered timeline. Steps without a call '
        '(the last one) render narrative only.',
    maxWidth: 720,
    panelPadding: AppSpacings.s24,
    child: AppApiFlow(
      flow: _flow,
      onStepTap: navigable ? (AppApiFlowStep _) {} : null,
      style: wbStyleKnob(context),
      radiusMode: wbRadiusModeKnob(context),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppApiFlow)
Widget apiFlowStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppApiFlow',
  description: 'A single step, and the full flow with a narrative-only tail.',
  maxWidth: 720,
  panelPadding: AppSpacings.s24,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      wbState(
        context,
        name: 'Single step',
        width: 640,
        child: const AppApiFlow(
          flow: AppApiFlowData(
            title: 'Export the list',
            steps: <AppApiFlowStep>[
              AppApiFlowStep(
                title: 'Request the CSV',
                method: AppApiMethod.get,
                path: '/devices/export',
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: AppSpacings.s24),
      wbState(
        context,
        name: 'Full flow',
        width: 640,
        child: const AppApiFlow(flow: _flow),
      ),
    ],
  ),
);

// --- AppApiDocsPanel -------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppApiDocsPanel)
Widget apiDocsPanelPlayground(BuildContext context) {
  final bool showSearch = context.knobs.boolean(
    label: 'showSearch',
    initialValue: true,
  );
  final bool external = context.knobs.boolean(
    label: 'onOpenExternal',
    initialValue: true,
  );
  final String searchHint = context.knobs.string(
    label: 'searchHint',
    initialValue: 'Filter by verb, path or description',
  );
  final String emptyText = context.knobs.string(
    label: 'emptyText',
    initialValue: 'No endpoint matches the filter.',
  );

  return wbUseCase(
    context,
    name: 'AppApiDocsPanel',
    description:
        'The whole sheet body. Tapping a flow step opens and scrolls to that '
        "endpoint's card.",
    maxWidth: 820,
    panelPadding: AppSpacings.s24,
    child: SizedBox(
      height: 620,
      // The panel does not scroll on its own — inside a sheet the surface owns
      // the scrolling. On the canvas we supply it.
      child: SingleChildScrollView(
        child: AppApiDocsPanel(
          doc: _doc,
          showSearch: showSearch,
          searchHint: searchHint,
          emptyText: emptyText,
          onOpenExternal: external ? () {} : null,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppApiDocsPanel)
Widget apiDocsPanelStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppApiDocsPanel',
  description:
      'Full document, and a document with no flow (groups only) — the two '
      'shapes a screen context can have.',
  maxWidth: 820,
  panelPadding: AppSpacings.s24,
  child: SizedBox(
    height: 620,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          wbState(
            context,
            name: 'With flow',
            width: 740,
            child: const AppApiDocsPanel(doc: _doc, showSearch: false),
          ),
          const SizedBox(height: AppSpacings.s24),
          wbState(
            context,
            name: 'Groups only',
            width: 740,
            child: AppApiDocsPanel(
              doc: AppApiDoc(
                title: _doc.title,
                subtitle: _doc.subtitle,
                baseUrl: _doc.baseUrl,
                groups: _doc.groups,
              ),
              showSearch: false,
            ),
          ),
        ],
      ),
    ),
  ),
);

// --- AppEntityDocPanel / AppDocsWorkspace ----------------------------------

const AppEntityDoc _entity = AppEntityDoc(
  title: 'Device',
  subtitle: 'The physical tracker installed in the vehicle.',
  overview: '''
A **device** is the hardware that transmits position and telemetry. It is
identified by its **IMEI** — the only thing the gateway knows before resolving
everything else.

On its own it does nothing. It goes live only once it has a **SIM card** (how it
transmits) and a **vehicle** (what the position refers to).
''',
  relations: <AppEntityRelation>[
    AppEntityRelation(
      target: 'Device model',
      kind: AppEntityRelationKind.manyToOne,
      description: 'Decides the protocol, the event catalog and the commands.',
    ),
    AppEntityRelation(
      target: 'SIM card',
      kind: AppEntityRelationKind.oneToOne,
      description: 'One active SIM at a time — no SIM, no transmission.',
      via: '/associations/device-sim-card',
    ),
    AppEntityRelation(
      target: 'Vehicle',
      kind: AppEntityRelationKind.manyToOne,
      description: 'A vehicle may carry more than one device.',
      via: '/associations/vehicle-device',
    ),
    AppEntityRelation(
      target: 'Telemetry event',
      kind: AppEntityRelationKind.oneToMany,
      description: 'Every decoded packet becomes an event.',
    ),
  ],
  integrations: <AppEntityIntegration>[
    AppEntityIntegration(
      name: 'Queclink gateway (@Track)',
      direction: AppEntityIntegrationDirection.bidirectional,
      description: 'Receives GV-family packets and carries commands back.',
    ),
    AppEntityIntegration(
      name: 'Jmak gateway',
      direction: AppEntityIntegrationDirection.inbound,
      description: 'JSON telemetry. Commands are not supported.',
    ),
    AppEntityIntegration(
      name: 'Allcom',
      direction: AppEntityIntegrationDirection.inbound,
      description: 'Syncs carrier SIMs and auto-links them by IMEI prefix.',
    ),
  ],
  sections: <AppEntityDocSection>[
    AppEntityDocSection(
      title: 'Lifecycle',
      body: '''
1. **Registered** — exists, no SIM, no vehicle. Silent.
2. **Connected** — has an active SIM. Events arrive without a vehicle.
3. **Live** — has SIM and vehicle. The only state the tracking screen shows.
''',
    ),
  ],
);

@widgetbook.UseCase(name: 'Playground', type: AppEntityDocPanel)
Widget entityDocPanelPlayground(BuildContext context) {
  final bool showHeader = context.knobs.boolean(
    label: 'showHeader',
    initialValue: true,
  );
  final String relationsTitle = context.knobs.string(
    label: 'relationsTitle',
    initialValue: 'Relations',
  );
  final String integrationsTitle = context.knobs.string(
    label: 'integrationsTitle',
    initialValue: 'Integrations',
  );

  return wbUseCase(
    context,
    name: 'AppEntityDocPanel',
    description:
        'The concept half: what the entity is, who it relates to and who '
        'exchanges data with it. Prose is Markdown; relations and integrations '
        'are cards, because those are what the eye scans.',
    maxWidth: 720,
    panelPadding: AppSpacings.s24,
    child: SizedBox(
      height: 620,
      // The panel does not scroll on its own — the host supplies it.
      child: SingleChildScrollView(
        child: AppEntityDocPanel(
          doc: _entity,
          showHeader: showHeader,
          relationsTitle: relationsTitle,
          integrationsTitle: integrationsTitle,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppEntityDocPanel)
Widget entityDocPanelStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppEntityDocPanel',
  description:
      'Full entity vs. a bare one (overview only) — the two extremes a real '
      'catalog produces.',
  maxWidth: 720,
  panelPadding: AppSpacings.s24,
  child: SizedBox(
    height: 620,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          wbState(
            context,
            name: 'Full',
            width: 640,
            child: const AppEntityDocPanel(doc: _entity),
          ),
          const SizedBox(height: AppSpacings.s24),
          wbState(
            context,
            name: 'Overview only',
            width: 640,
            child: const AppEntityDocPanel(
              doc: AppEntityDoc(
                title: 'Driving band',
                subtitle: 'A speed/RPM range used to score driving.',
                overview: 'Bands are **per model** and fully dynamic.',
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

@widgetbook.UseCase(name: 'Playground', type: AppDocsWorkspace)
Widget docsWorkspacePlayground(BuildContext context) {
  final bool withEntity = context.knobs.boolean(
    label: 'entity',
    initialValue: true,
  );
  final bool externalLinks = context.knobs.boolean(
    label: 'external links',
    initialValue: true,
  );
  final double firstFraction = context.knobs.double.slider(
    label: 'initialFirstFraction',
    initialValue: kAppDocsWorkspaceFirstFraction,
    min: 0.25,
    max: 0.7,
  );

  return wbUseCase(
    context,
    name: 'AppDocsWorkspace',
    description:
        'Concept on the left, API on the right, with a draggable divider and a '
        'scroll per column. Narrow the canvas below 900px to see it stack.',
    maxWidth: 1180,
    panelPadding: AppSpacings.s16,
    child: SizedBox(
      // The workspace needs a BOUNDED height — that is what an AppSideSheet
      // body gives it in the real app.
      height: 680,
      child: AppDocsWorkspace(
        entity: withEntity ? _entity : null,
        api: _doc,
        entityTitle: 'Documentation',
        apiTitle: 'API',
        initialFirstFraction: firstFraction,
        entityLinkLabel: 'Full documentation',
        apiLinkLabel: 'API reference',
        onOpenEntityDocs: externalLinks ? () {} : null,
        onOpenApiDocs: externalLinks ? () {} : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppDocsWorkspace)
Widget docsWorkspaceStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppDocsWorkspace',
  description:
      'Two columns (wide) and API-only (no entity) — the two shapes a screen '
      'context can have. The stacked shape appears by narrowing the canvas.',
  maxWidth: 1180,
  panelPadding: AppSpacings.s16,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      wbState(
        context,
        name: 'Concept + API',
        width: 1100,
        child: SizedBox(
          height: 420,
          child: AppDocsWorkspace(
            entity: _entity,
            api: _doc,
            entityTitle: 'Documentation',
            apiTitle: 'API',
            entityLinkLabel: 'Full documentation',
            apiLinkLabel: 'API reference',
            onOpenEntityDocs: () {},
            onOpenApiDocs: () {},
          ),
        ),
      ),
      const SizedBox(height: AppSpacings.s24),
      wbState(
        context,
        name: 'API only',
        width: 1100,
        child: SizedBox(
          height: 320,
          child: AppDocsWorkspace(
            entity: null,
            api: _doc,
            apiTitle: 'API',
            apiLinkLabel: 'API reference',
            onOpenApiDocs: () {},
          ),
        ),
      ),
    ],
  ),
);
