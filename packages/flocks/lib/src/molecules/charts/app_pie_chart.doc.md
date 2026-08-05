# AppPieChart

**Pie** chart: slices proportional to the values in `segments`.

## When to use

- Showing the composition of a whole (proportions, few categories ≤ ~6).

## When NOT to use

- Comparing categories precisely → `AppBarChart`.
- With a hole in the middle → `AppDonutChart`.

## Anatomy

- Slices colored from the **theme's categorical palette** (`chartCategorical`)
  when not given in `AppPieChartSegment.color`.
- **Hover/tap** highlights the slice and shows a tooltip (`surfaceContainer` +
  an `outline` border), emitting `onSelectionChanged`.

## Accessibility (Rule 8)

- The semantic label aggregates each segment's label and value. The categorical
  palette is **decorative** (the distinction comes from the legend and the label,
  not from color alone) — exempt from the contrast gate against the surface.

## Example

```dart
AppPieChart(segments: <AppPieChartSegment>[
  AppPieChartSegment(label: 'A', value: 30),
  AppPieChartSegment(label: 'B', value: 70),
])
```
