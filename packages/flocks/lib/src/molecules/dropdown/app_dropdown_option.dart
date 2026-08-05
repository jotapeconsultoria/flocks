/// Opção genérica de um dropdown ([AppDropdown], [AppMultiSelect] e variantes
/// com busca).
final class AppDropdownOption<T> {
  /// Cria uma [AppDropdownOption].
  const AppDropdownOption({
    required this.label,
    required this.value,
    this.section,
  });

  /// Rótulo exibido na lista e no trigger quando selecionado.
  final String label;

  /// Valor associado à opção.
  final T value;

  /// Rótulo de seção opcional. Quando informado, o [AppSearchableDropdown]
  /// insere um cabeçalho não-selecionável antes do primeiro item de cada seção
  /// (ex.: um bloco "Recomendados" no topo). Opções com [section] `null` seguem
  /// sem cabeçalho — comportamento default, retrocompatível. As demais variantes
  /// de dropdown ignoram este campo.
  final String? section;
}
