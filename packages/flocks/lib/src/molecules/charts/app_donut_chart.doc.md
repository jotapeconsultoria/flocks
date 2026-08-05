# AppDonutChart

**Donut** chart: like the pie, with a hole in the middle (`innerRadiusFactor`
0.58).

## When to use

- The composition of a whole, leaving the center free (for a total, say).

## When NOT to use

- Comparing categories precisely → `AppBarChart`.

## Anatomy

- Arcs colored from the **theme's categorical palette** (`chartCategorical`);
  hover/tap shows a tooltip and emits `onSelectionChanged`.

## Accessibility (Rule 8)

- The semantic label aggregates the values; the data-viz palette is decorative.

## Example

```dart
AppDonutChart(segments: <AppPieChartSegment>[
  AppPieChartSegment(label: 'A', value: 30),
  AppPieChartSegment(label: 'B', value: 70),
])
```
