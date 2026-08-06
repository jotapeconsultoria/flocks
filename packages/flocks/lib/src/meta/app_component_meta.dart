/// A piece of catalog prose in every language the catalog publishes.
///
/// The catalog is read by three consumers with different audiences: the site
/// (flocks.live, which serves a route per component in both languages), a
/// future MCP server, and the package's own documentation. Making the language
/// a *type* rather than a convention is what keeps a component from shipping
/// half-translated: the constructor cannot be satisfied with one language, so
/// there is no state in which a field exists in PT and is simply missing in EN.
///
/// Translation happens at the string level, not at the field level — an English
/// sentence may be rewritten with a different rhythm and a different argument
/// than its Portuguese counterpart, as long as both say the same thing.
final class LocalizedText {
  /// Creates a [LocalizedText].
  const LocalizedText({required this.en, required this.pt});

  /// English text.
  final String en;

  /// Brazilian Portuguese text.
  final String pt;

  /// Serializes to the format consumed by the site and the MCP server.
  Map<String, Object?> toJson() => <String, Object?>{'en': en, 'pt': pt};
}

/// A bulleted catalog list in every language the catalog publishes.
///
/// Deliberately a pair of lists rather than a list of [LocalizedText]: bullets
/// are an editorial cut, not a translation unit. Three Portuguese bullets may
/// be two in English when one distinction does not exist for that reader, and
/// a per-bullet pairing would force the English list to keep the Portuguese
/// list's shape. What the lists owe each other is coverage, not cardinality —
/// so the gate checks that neither side is empty while the other is filled.
final class LocalizedList {
  /// Creates a [LocalizedList].
  const LocalizedList({required this.en, required this.pt});

  /// Creates the empty list, used as the default for optional fields.
  const LocalizedList.empty() : en = const <String>[], pt = const <String>[];

  /// English bullets.
  final List<String> en;

  /// Brazilian Portuguese bullets.
  final List<String> pt;

  /// Whether both languages are empty.
  bool get isEmpty => en.isEmpty && pt.isEmpty;

  /// Whether either language carries a bullet.
  bool get isNotEmpty => !isEmpty;

  /// Serializes to the format consumed by the site and the MCP server.
  Map<String, Object?> toJson() => <String, Object?>{'en': en, 'pt': pt};
}

/// Atomic category of a component.
enum ComponentCategory {
  /// Atom (e.g. AppText, AppIcon).
  atom,

  /// Molecule (e.g. AppButton, AppDropdown).
  molecule,

  /// Organism (e.g. AppInput, AppScaffold).
  organism,
}

/// Migration state of a component into Flocks.
enum ComponentStatus {
  /// Still in `tracked_shared_pkg` (not migrated).
  legacy,

  /// Migration under way.
  inProgress,

  /// Migrated (meets the 10 rules).
  migrated,
}

/// Metadata for a public prop of a component.
class PropMeta {
  /// Creates a [PropMeta].
  const PropMeta({
    required this.name,
    required this.type,
    this.isRequired = false,
    this.defaultValue,
    this.description,
    this.enumValues = const <String>[],
  });

  /// Prop name.
  final String name;

  /// Dart type of the prop (e.g. `AppButtonColor`, `String?`).
  final String type;

  /// Whether it is required.
  final bool isRequired;

  /// Default value (as text), if any.
  final String? defaultValue;

  /// Short description.
  final LocalizedText? description;

  /// Possible values, if it is an enum/union.
  final List<String> enumValues;

  /// Serializes to the format consumed by the MCP server.
  Map<String, Object?> toJson() => <String, Object?>{
    'name': name,
    'type': type,
    'required': isRequired,
    if (defaultValue != null) 'default': defaultValue,
    if (description != null) 'description': description!.toJson(),
    if (enumValues.isNotEmpty) 'enumValues': enumValues,
  };
}

/// A usage code sample for a component.
class CodeExample {
  /// Creates a [CodeExample].
  const CodeExample({
    required this.title,
    required this.code,
    this.description,
  });

  /// Example title.
  final LocalizedText title;

  /// Code snippet.
  ///
  /// Not localized: it is Dart, and the identifiers in it are the package's
  /// public API. String literals inside a sample stay in the language the
  /// sample was written in — translating `label: 'Save'` would produce code
  /// that no longer matches what the reader sees in the widgetbook.
  final String code;

  /// Optional description.
  final LocalizedText? description;

  /// Serializes to the format consumed by the MCP server.
  Map<String, Object?> toJson() => <String, Object?>{
    'title': title.toJson(),
    'code': code,
    if (description != null) 'description': description!.toJson(),
  };
}

/// Type-safe descriptor of a Flocks component.
///
/// It is the source of truth for the metadata an MCP server serves to AI tools
/// (what a component is, when and how to use it) and for the per-component
/// routes the site generates. Preferred over hand-written JSON because it is
/// refactor-safe and derivable from the component's own enums and knobs. Every
/// migrated component must declare its `props` — that is what the MCP serves —
/// and `tool/component_conformance.dart` fails the build when one does not
/// (Rule 6).
class AppComponentMeta {
  /// Creates an [AppComponentMeta].
  const AppComponentMeta({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.summary,
    this.since,
    this.description,
    this.whenToUse = const LocalizedList.empty(),
    this.whenNotToUse = const LocalizedList.empty(),
    this.props = const <PropMeta>[],
    this.variants = const <String>[],
    this.states = const <String>[],
    this.examples = const <CodeExample>[],
    this.dos = const LocalizedList.empty(),
    this.donts = const LocalizedList.empty(),
    this.a11y,
    this.crossPlatform = false,
    this.themeAware = false,
    this.reducesMotion = false,
    this.related = const <String>[],
  });

  /// Identifier (snake_case, e.g. `app_button`).
  final String id;

  /// Public class name (e.g. `AppButton`).
  final String name;

  /// Atomic category.
  final ComponentCategory category;

  /// Migration state.
  final ComponentStatus status;

  /// One-line summary.
  final LocalizedText summary;

  /// Version it was migrated in (e.g. `flocks@0.3.0`).
  final String? since;

  /// Long description.
  final LocalizedText? description;

  /// When to use it.
  final LocalizedList whenToUse;

  /// When NOT to use it (with alternatives).
  final LocalizedList whenNotToUse;

  /// Public props.
  final List<PropMeta> props;

  /// Variants (e.g. `color`, `size`, `icon-only`).
  ///
  /// Not localized: like [states], these name API surface — the value of an
  /// enum, a shape, a size step. English is the vocabulary of the API itself,
  /// and inventing a Portuguese word for `outlined` would name something that
  /// does not exist in the code.
  final List<String> variants;

  /// Supported interaction states.
  ///
  /// Not localized, for the reason given on [variants]: `hovered`, `pressed`
  /// and `focused` are the vocabulary the framework and the widgetbook already
  /// use, not prose about the component.
  final List<String> states;

  /// Usage examples.
  final List<CodeExample> examples;

  /// Good practice (do).
  final LocalizedList dos;

  /// Antipatterns (don't).
  final LocalizedList donts;

  /// Accessibility notes (Gate 8).
  final LocalizedText? a11y;

  /// Meets the cross-platform gate (selection/focus) — Gate 7.
  final bool crossPlatform;

  /// Reads 100% from the theme and adapts to light/dark + brand — Gate 9.
  final bool themeAware;

  /// Honors reduce-motion — Gate 10.
  final bool reducesMotion;

  /// Related components (ids).
  final List<String> related;

  /// Serializes to the JSON consumed by the MCP server and the site.
  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'name': name,
    'category': category.name,
    'status': status.name,
    if (since != null) 'since': since,
    'summary': summary.toJson(),
    if (description != null) 'description': description!.toJson(),
    if (whenToUse.isNotEmpty) 'whenToUse': whenToUse.toJson(),
    if (whenNotToUse.isNotEmpty) 'whenNotToUse': whenNotToUse.toJson(),
    if (props.isNotEmpty)
      'props': props.map((PropMeta p) => p.toJson()).toList(),
    if (variants.isNotEmpty) 'variants': variants,
    if (states.isNotEmpty) 'states': states,
    if (examples.isNotEmpty)
      'examples': examples.map((CodeExample e) => e.toJson()).toList(),
    if (dos.isNotEmpty) 'do': dos.toJson(),
    if (donts.isNotEmpty) 'dont': donts.toJson(),
    if (a11y != null) 'a11y': a11y!.toJson(),
    'crossPlatform': crossPlatform,
    'themeAware': themeAware,
    'reducesMotion': reducesMotion,
    if (related.isNotEmpty) 'related': related,
  };
}
