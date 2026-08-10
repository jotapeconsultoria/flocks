import 'dart:async';

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

import '../data/demo_data.dart';
import '../surface_radius.dart';

/// Em que estado a lista está.
///
/// Os quatro são alcançáveis pela interface, e não só pelo código. Um design
/// system que documenta "temos estado vazio" e só o mostra num use case isolado
/// não respondeu à pergunta que importa: como o vazio se parece DENTRO da tela,
/// entre um cabeçalho e um rodapé que continuam lá.
enum _ListState { loaded, loading, empty, failed }

/// A tela de escrita: lista, formulário com validação e os quatro estados.
///
/// É a outra metade do que um design system precisa provar. Ler é fácil de
/// fazer bonito; escrever é onde aparecem as bordas de erro, o texto de ajuda, o
/// campo desabilitado, o botão em carregamento e a confirmação — as peças que
/// uma vitrine de componentes mostra separadas e nunca juntas.
class CrudScreen extends StatefulWidget {
  /// Cria a tela.
  const CrudScreen({required this.accounts, super.key});

  /// A carteira que a tela edita, no lugar.
  final List<Account> accounts;

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  _ListState _state = _ListState.loaded;
  String _query = '';
  Account? _editing;
  bool _isNew = false;
  bool _saving = false;
  String? _flash;

  // Erros de validação por campo. Vazio enquanto o visitante não tentou salvar:
  // marcar tudo de vermelho antes da primeira tentativa é hostil.
  Map<String, String> _errors = <String, String>{};

  List<Account> get _filtered {
    final String q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.accounts;
    return widget.accounts
        .where(
          (Account a) =>
              a.name.toLowerCase().contains(q) ||
              a.owner.toLowerCase().contains(q) ||
              a.id.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Account> rows = _state == _ListState.empty
        ? const <Account>[]
        : _filtered;

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacings.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _Toolbar(
                state: _state,
                onStateChanged: (_ListState s) => setState(() => _state = s),
                onNew: _startNew,
                onSearch: (String q) => setState(() => _query = q),
              ),
              const SizedBox(height: AppSpacings.s16),
              if (_flash != null) ...<Widget>[
                AppAlert(
                  title: 'Saved',
                  description: _flash!,
                  color: AppAlertColor.success,
                  icon: AppIconToken.checkCircle,
                ),
                const SizedBox(height: AppSpacings.s16),
              ],
              _Body(
                state: _state,
                rows: rows,
                query: _query,
                onEdit: _startEdit,
                onRetry: () => setState(() => _state = _ListState.loaded),
                onClearFilter: () => setState(() => _query = ''),
              ),
            ],
          ),
        ),
        if (_editing != null)
          Positioned.fill(
            child: _FormSheet(
              account: _editing!,
              isNew: _isNew,
              saving: _saving,
              errors: _errors,
              onCancel: _closeForm,
              onSave: _save,
            ),
          ),
      ],
    );
  }

  void _startNew() => setState(() {
    _isNew = true;
    _errors = <String, String>{};
    _editing = Account(
      id: 'ACC-${1150 + widget.accounts.length}',
      name: '',
      owner: '',
      plan: AccountPlan.starter,
      status: AccountStatus.trial,
      seats: 1,
      mrr: 0,
      renewsOn: DateTime(2026, 12, 31),
    );
  });

  void _startEdit(Account account) => setState(() {
    _isNew = false;
    _errors = <String, String>{};
    // A cópia é o que dá sentido ao botão "Cancel": sem ela, cada tecla já
    // teria alterado a lista por baixo.
    _editing = account.copy();
  });

  void _closeForm() => setState(() {
    _editing = null;
    _saving = false;
    _errors = <String, String>{};
  });

  Future<void> _save() async {
    final Account draft = _editing!;
    final Map<String, String> errors = _validate(draft);
    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      return;
    }
    setState(() {
      _errors = <String, String>{};
      _saving = true;
    });
    // Sem rede: o atraso existe só para o botão em carregamento e o campo
    // desabilitado terem onde aparecer. É um estado da UI, não uma chamada.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      if (_isNew) {
        widget.accounts.insert(0, draft);
      } else {
        final int i = widget.accounts.indexWhere(
          (Account a) => a.id == draft.id,
        );
        if (i >= 0) widget.accounts[i] = draft;
      }
      _flash = '${draft.name} was ${_isNew ? 'created' : 'updated'}.';
      _editing = null;
      _saving = false;
    });
  }

  Map<String, String> _validate(Account draft) {
    final Map<String, String> errors = <String, String>{};
    if (draft.name.trim().isEmpty) {
      errors['name'] = 'An account needs a name.';
    } else if (draft.name.trim().length < 3) {
      errors['name'] = 'At least 3 characters.';
    }
    final String owner = draft.owner.trim();
    if (owner.isEmpty) {
      errors['owner'] = 'An account needs an owner.';
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(owner)) {
      errors['owner'] = 'That does not look like an e-mail.';
    }
    if (draft.seats < 1) errors['seats'] = 'At least one seat.';
    if (draft.status == AccountStatus.active && draft.mrr <= 0) {
      errors['mrr'] = 'An active account bills something.';
    }
    return errors;
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.onNew,
    required this.onSearch,
    required this.onStateChanged,
    required this.state,
  });

  final VoidCallback onNew;
  final ValueChanged<String> onSearch;
  final ValueChanged<_ListState> onStateChanged;
  final _ListState state;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(
                    'Accounts',
                    style: theme.textTheme.headlineSmall.withColor(
                      theme.colorTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacings.s4),
                  AppText(
                    'Create, edit and retire the accounts in the book.',
                    style: theme.textTheme.bodySmall.withColor(
                      theme.colorTheme.neutralPrimary.s700,
                    ),
                  ),
                ],
              ),
            ),
            AppButton(
              label: 'New account',
              icon: AppIconToken.add,
              onPressed: onNew,
            ),
          ],
        ),
        const SizedBox(height: AppSpacings.s16),
        // `Wrap`, e não `Row`: a busca tem largura fixa e o seletor de estado
        // tem quatro segmentos, e numa `Row` os dois juntos estouram a linha
        // assim que o painel de marca come a largura do conteúdo. Quebrar é a
        // resposta certa — encolher a busca até virar um campo inútil, não.
        Wrap(
          spacing: AppSpacings.s16,
          runSpacing: AppSpacings.s12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 320,
              child: AppInput(
                hintText: 'Search by name, owner or id',
                prefixIcon: AppIconToken.search,
                onChanged: onSearch,
              ),
            ),
            AppSegmentedButton<_ListState>(
              segments: const <AppSegment<_ListState>>[
                AppSegment<_ListState>(
                  value: _ListState.loaded,
                  label: 'Loaded',
                ),
                AppSegment<_ListState>(
                  value: _ListState.loading,
                  label: 'Loading',
                ),
                AppSegment<_ListState>(value: _ListState.empty, label: 'Empty'),
                AppSegment<_ListState>(
                  value: _ListState.failed,
                  label: 'Error',
                ),
              ],
              value: state,
              size: AppButtonSize.s,
              onChanged: onStateChanged,
            ),
          ],
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.onClearFilter,
    required this.onEdit,
    required this.onRetry,
    required this.query,
    required this.rows,
    required this.state,
  });

  final VoidCallback onClearFilter;
  final ValueChanged<Account> onEdit;
  final VoidCallback onRetry;
  final String query;
  final List<Account> rows;
  final _ListState state;

  @override
  Widget build(BuildContext context) => switch (state) {
    _ListState.loading => const _LoadingList(),
    _ListState.failed => AppCard(
      radius: demoSurfaceRadius(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacings.s16),
        child: Column(
          children: <Widget>[
            const AppAlert(
              title: 'Could not load accounts',
              description:
                  'The request timed out. Nothing was lost — try again.',
              color: AppAlertColor.danger,
              icon: AppIconToken.errorCircle,
            ),
            const SizedBox(height: AppSpacings.s16),
            AppButton(
              label: 'Try again',
              icon: AppIconToken.refresh,
              style: AppStyle.outlined,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    ),
    _ListState.empty || _ListState.loaded when rows.isEmpty => AppCard(
      radius: demoSurfaceRadius(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacings.s32),
        child: AppListEmpty(
          illustration: AppIllustrationToken.empty,
          text: query.isEmpty
              ? 'No accounts yet. Create the first one.'
              : 'Nothing matches "$query".',
          onClearFilter: query.isEmpty ? null : onClearFilter,
        ),
      ),
    ),
    _ListState.empty || _ListState.loaded => AppListTileGroup(
      children: <Widget>[
        for (final Account account in rows)
          AppListTileAction(
            title: account.name,
            text: '${account.owner} · ${account.plan.label}',
            trailing: const AppIcon(AppIconToken.pencil),
            onPressed: () => onEdit(account),
          ),
      ],
    ),
  };
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) => AppCard(
    radius: demoSurfaceRadius(context),
    child: Column(
      children: <Widget>[
        for (int i = 0; i < 5; i++) ...<Widget>[
          const AppShimmerLoading(height: 44),
          if (i < 4) const SizedBox(height: AppSpacings.s12),
        ],
      ],
    ),
  );
}

class _FormSheet extends StatefulWidget {
  const _FormSheet({
    required this.account,
    required this.errors,
    required this.isNew,
    required this.onCancel,
    required this.onSave,
    required this.saving,
  });

  final Account account;
  final Map<String, String> errors;
  final bool isNew;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool saving;

  @override
  State<_FormSheet> createState() => _FormSheetState();
}

class _FormSheetState extends State<_FormSheet> {
  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final Account a = widget.account;
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: widget.saving ? null : widget.onCancel,
            child: ColoredBox(
              color: theme.colorTheme.neutralBlack.withValues(alpha: 0.32),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        SizedBox(
          width: 420,
          child: AppSideSheet(
            title: widget.isNew ? 'New account' : 'Edit ${a.id}',
            onCloseButton: widget.saving ? null : widget.onCancel,
            footer: Row(
              children: <Widget>[
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    style: AppStyle.outlined,
                    color: AppButtonColor.neutral,
                    enabled: !widget.saving,
                    expandedWidth: true,
                    onPressed: widget.onCancel,
                  ),
                ),
                const SizedBox(width: AppSpacings.s12),
                Expanded(
                  child: AppButton(
                    label: widget.isNew ? 'Create' : 'Save',
                    loading: widget.saving,
                    expandedWidth: true,
                    onPressed: widget.onSave,
                  ),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AppInput(
                    label: 'Account name',
                    initialValue: a.name,
                    enabled: !widget.saving,
                    errorText: widget.errors['name'],
                    hasError: widget.errors.containsKey('name'),
                    onChanged: (String v) => setState(() => a.name = v),
                  ),
                  const SizedBox(height: AppSpacings.s16),
                  AppInput(
                    label: 'Owner e-mail',
                    initialValue: a.owner,
                    enabled: !widget.saving,
                    errorText: widget.errors['owner'],
                    hasError: widget.errors.containsKey('owner'),
                    helperText: 'Who receives the invoices.',
                    onChanged: (String v) => setState(() => a.owner = v),
                  ),
                  const SizedBox(height: AppSpacings.s16),
                  AppDropdown<AccountPlan>(
                    label: 'Plan',
                    enabled: !widget.saving,
                    selectedValue: a.plan,
                    options: <AppDropdownOption<AccountPlan>>[
                      for (final AccountPlan p in AccountPlan.values)
                        AppDropdownOption<AccountPlan>(
                          value: p,
                          label: p.label,
                        ),
                    ],
                    onChanged: (AccountPlan? v) =>
                        setState(() => a.plan = v ?? a.plan),
                  ),
                  const SizedBox(height: AppSpacings.s16),
                  AppDropdown<AccountStatus>(
                    label: 'Status',
                    enabled: !widget.saving,
                    selectedValue: a.status,
                    options: <AppDropdownOption<AccountStatus>>[
                      for (final AccountStatus s in AccountStatus.values)
                        AppDropdownOption<AccountStatus>(
                          value: s,
                          label: s.label,
                        ),
                    ],
                    onChanged: (AccountStatus? v) =>
                        setState(() => a.status = v ?? a.status),
                  ),
                  const SizedBox(height: AppSpacings.s16),
                  AppText(
                    'Seats',
                    style: theme.textTheme.labelMedium.withColor(
                      theme.colorTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacings.s8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppNumberStepper(
                      value: a.seats,
                      max: 999,
                      enabled: !widget.saving,
                      onChanged: (num v) => setState(() => a.seats = v.toInt()),
                    ),
                  ),
                  if (widget.errors.containsKey('seats')) ...<Widget>[
                    const SizedBox(height: AppSpacings.s8),
                    AppText(
                      widget.errors['seats']!,
                      style: theme.textTheme.labelSmall.withColor(
                        theme.colorTheme.danger,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacings.s16),
                  AppInput(
                    label: 'Monthly recurring (USD)',
                    initialValue: a.mrr.toStringAsFixed(0),
                    enabled: !widget.saving,
                    errorText: widget.errors['mrr'],
                    hasError: widget.errors.containsKey('mrr'),
                    onChanged: (String v) =>
                        setState(() => a.mrr = double.tryParse(v) ?? 0),
                  ),
                  const SizedBox(height: AppSpacings.s16),
                  AppDatePickerInput(
                    label: 'Renews on',
                    initialDate: a.renewsOn,
                    enabled: !widget.saving,
                    onDateSelected: (DateTime? v) =>
                        setState(() => a.renewsOn = v ?? a.renewsOn),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
