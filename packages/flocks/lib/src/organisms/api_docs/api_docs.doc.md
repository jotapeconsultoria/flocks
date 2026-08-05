# Per-context documentation — `api_docs`

Nine components that draw **one screen's** documentation, in two halves: the
**concept** (what the entity is, what it relates to, who exchanges data with it)
and the **API** (the endpoints that screen consumes, grouped by subject, with the
business flow that ties down the order of use).

> The folder's name is left over from when the group only had the API half.
> Renaming it to `docs/` is the pending cleanup — the component names are already
> right.

## Why it exists

A complete API reference (Swagger UI) answers "what does each endpoint do". It
does not answer the two questions someone *inside* a screen actually has:
**which** of those 213 endpoints have to do with this screen, and **in what
order** to call them to complete a task. This group exists to answer those two —
the rest remains Swagger's job.

## Division of responsibility

The group is **purely presentational**. It makes no network calls, knows no
router, holds no token. The models (`app_api_models.dart`) are the contract: the
application loads the specification however it likes (fetching `doc.json`, an
asset, codegen), converts it to an `AppApiDoc` and hands it over ready. Loading
and error states belong to the host.

That is what keeps the group testable with no HTTP mock and reusable by any app
in the monorepo.

## Models

```
AppApiDoc
├── groups: List<AppApiGroup>        // "Device CRUD", "SIM association"
│   └── endpoints: List<AppApiEndpoint>
│       ├── params: List<AppApiParam>          // path/query/header/body/form
│       ├── requestFields: List<AppApiField>   // a recursive tree
│       └── responses: List<AppApiResponse>
└── flows: List<AppApiFlowData>
    └── steps: List<AppApiFlowStep>            // pointing at an endpoint by METHOD+path
```

`AppApiEndpoint.id` is `'METHOD path'` — Tracked's Swagger **does not emit an
`operationId`**, so the verb+path pair is the only stable identifier available.
`AppApiFlowStep.endpointId` produces the same key, and that is how the panel
links a step to a card.

Cutting cycles and imposing a depth ceiling on the `AppApiField` tree is the
responsibility of **whoever assembles it** — a real API's `definitions`
self-reference, and a naive recursion never terminates.

## Components

| Component | Role |
| --- | --- |
| `AppDocsWorkspace` | The two columns: concept on the left, API on the right |
| `AppEntityDocPanel` | Concept: overview, relationships and integrations |
| `AppApiMethodBadge` | The verb pill, colored per method, at a fixed column width |
| `AppApiPath` | The path in mono with `{placeholders}` highlighted |
| `AppApiParamTable` | Parameters, on top of `AppSimpleDataTable` |
| `AppApiSchemaTree` | The field tree, with nodes openable by depth |
| `AppApiEndpointTile` | An endpoint's collapsible card |
| `AppApiFlow` | The flow's numbered timeline, with navigable steps |
| `AppApiDocsPanel` | The whole panel (header + search + flows + groups) |

## The two halves

`AppEntityDoc` (concept) and `AppApiDoc` (endpoints) are **separate models** and
arrive by different routes: the second is derived from a specification at
runtime, the first is domain knowledge written by hand. Merging them into one
model would make the generated part and the written part share a lifecycle — and
that is exactly what does not happen.

`AppDocsWorkspace` is what puts them side by side. It accepts `entity: null`, and
then the API takes the whole width — the state of every screen whose domain
documentation has not been written yet.

## Decisions that are not obvious

- **`AppApiEndpointTile` does not wrap `AppExpansionTile`.** That component only
  accepts a `String` title, and here the header is composed (a pill + the path in
  mono + a summary + copy). The tile uses the **same primitives**
  (`FlocksInteraction` + `AppExpand` + `AppAnimatedRotation`), so it inherits
  hover/focus/motion without inheriting the limitation.
- **The verb pill's width is fixed** (`kAppApiMethodBadgeWidth`). Without that
  the paths start at differing abscissas and the list turns into a staircase —
  the eye loses the vertical scan, which is the main mode of use.
- **The schema tree's chevron takes up space even on leaves.** Otherwise the
  names would dance horizontally between nodes and leaves.
- **The timeline's connector uses `IntrinsicHeight`.** The rail has to grow with
  the step's *real* height; without that, steps of differing heights leave gaps in
  the line.
- **The panel does not scroll.** `AppBottomSheet`/`AppSideSheet`'s contract is
  that the surface owns the scrolling (the child goes into a
  `SliverToBoxAdapter`). An internal scroll would create two nested scrollables.
  Outside a sheet, wrap it.
- **The workspace needs a bounded height.** The columns scroll on their own, so
  it cannot sit inside a vertical scroll. In the app that comes from the
  `AppSideSheet`'s body, which is an `Expanded`.
- **It opens at the `full` snap.** Two reading columns do not fit the side
  sheet's resting snap; opening narrow would force a drag before anything could
  be read.
- **Each column has a header outside the scroll.** With the column scrolled, the
  reader has to keep knowing which half they are in and how to get out to the
  complete reference.
- **Below 900px the columns stack** into a single scroll — two squeezed columns
  produce lines of five words.
- **Only the first success and the first error show an example.** A real API's
  error responses share the same envelope; repeating six near-identical blocks
  pushes the page down without teaching anything.
- **Tapping a step clears the search before revealing the endpoint.** With a
  filter active the target card may be outside the tree — there would be nothing
  to expand and nowhere to scroll.

## Security

The sample `curl` is assembled by whoever produces the `AppApiDoc` and must
**never** contain a real credential: use a placeholder (`Bearer <your_token>`).
The group is read-only by construction — there is no "Try it out", and no
component here fires a request.

## Examples

```dart
// The whole screen: a side sheet at the widest snap, two columns inside
showAppSideSheet<void>(
  context: context,
  draggable: true,
  initialSnap: AppSideSheetSnap.full,
  title: const AppText('Documentation · Devices'),
  child: AppDocsWorkspace(
    entity: entityDoc,
    api: apiDoc,
    onOpenEntityDocs: () => launcher.launch(docsUrl),
    onOpenApiDocs: () => launcher.launch(swaggerUrl),
  ),
);

// Only the API half, inside any scroll
AppApiDocsPanel(doc: apiDoc);

// A standalone endpoint, inside another page
AppApiEndpointTile(endpoint: endpoint, baseUrl: apiDoc.baseUrl);
```
