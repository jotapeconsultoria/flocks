# AppQuestionCard

**Question** card inside the chat flow — the AI asks the user for something and
gets the answer inline. Three kinds, through named constructors. Domain-agnostic.

## Kinds

- **`AppQuestionCard.confirmation`** — a title/subtitle + an optional `detail` +
  confirm/cancel actions. It generalizes the AI's "pending action" card.
- **`AppQuestionCard.singleChoice`** — up to 3 `options` as **radios** + (if
  `allowCustom`) a 4th free-answer option (which reveals an `AppInput`). A button
  submits the choice through `onSingleSelected(String)`.
- **`AppQuestionCard.multipleChoice`** — up to 3 `options` as **checkboxes** + (if
  `allowCustom`) a free answer. A button submits the selection through
  `onMultipleSubmit(List<String>)`.

## Anatomy

- A shell tinted by `role` (info/warning/danger/success): the role at 12% + a
  border at 40%. A title (`titleSmall`) + an optional subtitle.
- Choices: tappable rows (`AppInteraction`) with the design system's
  `AppRadio`/`AppCheckbox`; the submit button uses the role's color and enables
  when the answer is valid.

## Accessibility (Rule 8)

- Design system controls and buttons — labelled and keyboard-activatable.

## Examples

```dart
AppQuestionCard.confirmation(
  title: 'Confirmation required — high risk',
  subtitle: 'create_geofence',
  onConfirm: _confirm, onCancel: _cancel,
)

AppQuestionCard.singleChoice(
  title: 'Which report do you want?',
  options: <String>['Daily summary', 'Idle vehicles', 'Alerts'],
  onSingleSelected: (answer) => cubit.reply(answer),
)

AppQuestionCard.multipleChoice(
  title: 'Which columns should we export?',
  options: <String>['Plate', 'Driver', 'Mileage'],
  onMultipleSubmit: (answers) => cubit.export(answers),
)
```
