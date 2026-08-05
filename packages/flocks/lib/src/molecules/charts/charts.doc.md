# Cartesian and indicator charts

Grouped doc for `AppChartShell`, `AppLineChart`, `AppAreaChart`, `AppBarChart`,
`AppBubbleChart` and `AppGaugeChart`. The radial ones (`AppPieChart`,
`AppDonutChart`) have docs of their own.

## How to choose

| The reader's question | Component |
|---|---|
| How did this evolve over time? | `AppLineChart` |
| How much accumulated, and how did it evolve? | `AppAreaChart` |
| Which one is bigger than which? | `AppBarChart` |
| What are the orders of magnitude? | `AppBubbleChart` |
| Where does this indicator sit on the scale? | `AppGaugeChart` |

`AppBarChart` is the default choice whenever the question is comparison: values
over a common baseline are what the eye compares precisely. Area and angle
(bubble, gauge, pie) are notoriously hard to compare — use them to convey orders
of magnitude, not to decide between close values.

## Anatomy

- **`AppChartShell`** is the frame: title, subtitle, summary, legend and the
  loading and empty states around the plot area. It is a content card — it
  follows the global style (`AppStyle`) and shape (`theme.radiusTheme`) axes,
  like `AppCard`.
- The charts themselves paint only the plot. None of them draws its own frame:
  whoever wants a title and a legend wraps it in an `AppChartShell`.
- The series' colors come from the **theme's categorical palette**
  (`chartCategorical`) when not given.

## Interaction

- Hover/tap emits `onSelectionChanged` and shows the point's tooltip.
- The legend's items are **controls**: they toggle the series, are reachable with
  Tab and activated with Enter/Space (`FlocksInteraction`), with a focus ring.

## Accessibility (Rule 8)

- Every chart exposes a semantic label that aggregates the series' reading —
  whoever cannot see the plot gets the summary, not a blank screen.
- The legend item is announced as a toggle, with its state (active/inactive) and
  the series' label.
- The data-viz palette is decorative: the information never depends on color
  alone, because the label accompanies every series in the legend and in the
  tooltip.

## Theme (Rule 9)

The frame uses `surfaceContainer`, not `neutralWhite` — that is the "white" role
and it is pure white in **both brightnesses**, which painted a white card in the
dark theme. The bar's corner and the legend's chip also come from the shape
axis: with the brand set to `reto`, bars and chips get square corners.

## Example

```dart
AppChartShell(
  title: 'Consumption by month',
  legendItems: <AppChartLegendItem>[
    AppChartLegendItem(label: 'Fleet A', color: colors.chartCategorical.first),
  ],
  child: AppBarChart(
    labels: <String>['Jan', 'Feb', 'Mar'],
    series: <AppBarChartSeries>[
      AppBarChartSeries(id: 'a', label: 'Fleet A', values: <double>[10, 14, 12]),
    ],
  ),
)
```
