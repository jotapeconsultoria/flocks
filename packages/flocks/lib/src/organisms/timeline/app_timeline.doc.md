# AppTimeline

A chronological list of events that happened, newest first: a vertical rail with
a marker per event and a content slot beside it.

## Why not `AppStepper`

The stepper indicates *progress* through a process with a known beginning, middle
and end — it has a current step, future steps, and the promise that you reach the
last one. An event trail has none of that: it does not end, there is no "current"
item, and what came before does not enable what came after. Using one for the
other makes the screen promise a sequence that does not exist.

## Anatomy

- `itemBuilder` builds only the *content*; the rail and the marker belong to the
  component.
- `markerBuilder` overrides the default dot. A denied event may want a different
  marker — and colour must never be the only difference.
- `footer` lives *inside* the scroll, next to the last item. Outside it, a "load
  more" would be visible the whole time and get clicked before reaching the end.
- `controller` is what lets the host preserve scroll position when a detail sheet
  closes.

## Accessibility (Rule 8)

- A semantic list with explicit child nodes, navigable item by item.
- The rail is wrapped in `ExcludeSemantics`: a screen reader must hear the
  events, not the line connecting them.

## Example

```dart
AppTimeline(
  itemCount: events.length,
  itemBuilder: (BuildContext context, int i) => AuditEventTile(events[i]),
  footer: loading ? const AppCircularLoading() : null,
)
```
