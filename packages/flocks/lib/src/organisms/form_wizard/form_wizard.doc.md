# AppFormWizard

**Multi-step** form with a progress indicator. `AppFormWizardStep` describes each
step (title, subtitle/icon, content builder, validator).

## When to use

- A registration or flow split into steps with visible progress and an order.

## When NOT to use

- Parallel tabs with no order or progress → `AppTabView`.

## Anatomy

- **Indicator**: at the side on desktop, on top on mobile (through `AppDevice`);
  it marks the **active/completed/pending** step by color (from the theme).
- **Panel**: the current step's content (`step.builder`), loaded on demand.
- **Transition** between steps: motion tokens, honoring reduce-motion.

## Accessibility

The indicator's colors (active/completed/pending) pass WCAG AA in light and dark.
The panel enters the reading focus order.

## Example

```dart
AppFormWizard(
  currentStep: step,
  onStepTapped: cubit.goTo,
  steps: <AppFormWizardStep>[
    AppFormWizardStep(title: 'Details', builder: (_) => detailsForm),
    AppFormWizardStep(title: 'Review', builder: (_) => review),
  ],
);
```
