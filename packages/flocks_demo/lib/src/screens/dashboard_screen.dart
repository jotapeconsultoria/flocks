import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';

import '../data/demo_data.dart';

/// A janela de tempo que os gráficos mostram.
enum _Range {
  quarter('90 days', 3),
  half('6 months', 6),
  year('12 months', 12);

  const _Range(this.label, this.months);

  final String label;
  final int months;
}

/// A tela de leitura densa: KPIs, tendência, distribuição e uma tabela.
///
/// É metade do que um design system precisa provar. Uma vitrine mostra um botão
/// bonito isolado; o que ela não mostra é se doze números, dois gráficos e uma
/// tabela paginada ainda se leem quando estão todos na mesma tela — e é aí que
/// hierarquia tipográfica, contraste e densidade ou funcionam ou não.
///
/// Nenhum widget aqui recebe cor, raio ou sombra por parâmetro. Tudo que muda
/// quando o visitante mexe no painel de marca muda porque os componentes leem o
/// tema sozinhos.
class DashboardScreen extends StatefulWidget {
  /// Cria a tela.
  const DashboardScreen({required this.accounts, super.key});

  /// A carteira que alimenta os números.
  final List<Account> accounts;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  _Range _range = _Range.year;
  final Set<AccountStatus> _hidden = <AccountStatus>{};
  int _page = 1;
  int _perPage = 6;

  List<Account> get _visible => widget.accounts
      .where((Account a) => !_hidden.contains(a.status))
      .toList();

  double get _mrr => _visible.fold(0, (double sum, Account a) => sum + a.mrr);

  int get _seats => _visible.fold(0, (int sum, Account a) => sum + a.seats);

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final List<Account> visible = _visible;
    final int totalPages = (visible.length / _perPage).ceil().clamp(1, 999);
    final int page = _page.clamp(1, totalPages);
    final List<Account> pageRows = visible
        .skip((page - 1) * _perPage)
        .take(_perPage)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacings.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _Header(range: _range, onRangeChanged: _setRange),
          const SizedBox(height: AppSpacings.s24),
          _KpiRow(mrr: _mrr, seats: _seats, accounts: visible),
          const SizedBox(height: AppSpacings.s24),
          _Charts(range: _range, accounts: visible),
          const SizedBox(height: AppSpacings.s24),
          _StatusFilters(hidden: _hidden, onToggle: _toggleStatus),
          const SizedBox(height: AppSpacings.s12),
          if (visible.isEmpty)
            AppCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacings.s32),
                child: AppListEmpty(
                  illustration: AppIllustrationToken.empty,
                  text: 'Every status is filtered out.',
                  onClearFilter: () => setState(_hidden.clear),
                ),
              ),
            )
          else
            // Altura fixa, e não `Expanded`: a `AppDataTable` distribui as
            // próprias linhas com flex, então ela precisa de uma altura
            // LIMITADA — e aqui ela está dentro de um scroll vertical, que dá
            // altura infinita. É o único lugar da tela com um número de layout
            // escrito à mão, e ele acomoda o cabeçalho, uma página de linhas e
            // a paginação.
            SizedBox(
              height: 460,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // Cinco colunas não cabem no que sobra da largura quando o
                  // painel de marca está aberto num laptop de 1280. Largar as
                  // duas menos decisivas é o que uma tabela de verdade faz;
                  // rolar na horizontal dentro de um cartão esconde dado que o
                  // visitante não sabe que existe.
                  final bool dense = constraints.maxWidth < 720;
                  return AppDataTable(
                    columnLabels: <String>[
                      'Account',
                      if (!dense) 'Plan',
                      'Status',
                      if (!dense) 'Seats',
                      'MRR',
                    ],
                    rows: pageRows
                        .map((Account a) => _row(a, dense: dense))
                        .toList(),
                    page: page,
                    perPage: _perPage,
                    total: visible.length,
                    totalPages: totalPages,
                    onPageChange: (int next) => setState(() => _page = next),
                    onPerPageChange: (int next) => setState(() {
                      _perPage = next;
                      _page = 1;
                    }),
                  );
                },
              ),
            ),
          const SizedBox(height: AppSpacings.s16),
          AppText(
            'Synthetic data, generated in the browser. Nothing here is fetched.',
            style: theme.textTheme.labelSmall.withColor(
              theme.colorTheme.neutralPrimary.s600,
            ),
          ),
        ],
      ),
    );
  }

  void _setRange(_Range range) => setState(() => _range = range);

  void _toggleStatus(AccountStatus status) => setState(() {
    if (!_hidden.remove(status)) _hidden.add(status);
    _page = 1;
  });

  List<Widget> _row(Account account, {required bool dense}) => <Widget>[
    _AccountCell(account: account),
    if (!dense) AppText(account.plan.label),
    AppBadge(account.status.label, color: account.status.badge),
    if (!dense) AppText('${account.seats}'),
    AppText(account.mrr == 0 ? '—' : '\$${account.mrr.toStringAsFixed(0)}'),
  ];
}

class _Header extends StatelessWidget {
  const _Header({required this.range, required this.onRangeChanged});

  final _Range range;
  final ValueChanged<_Range> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    // `Wrap`, e não `Row`: o painel de marca come 360 px da largura, e num
    // laptop de 1280 o que sobra para o conteúdo não acomoda o título e um
    // seletor de três períodos na mesma linha. Quebrar é a resposta; espremer o
    // título até ele truncar, não.
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      runSpacing: AppSpacings.s16,
      spacing: AppSpacings.s16,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppText(
              'Revenue',
              style: theme.textTheme.headlineSmall.withColor(
                theme.colorTheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacings.s4),
            AppText(
              'Recurring revenue, seats and renewals across the book.',
              style: theme.textTheme.bodySmall.withColor(
                theme.colorTheme.neutralPrimary.s700,
              ),
            ),
          ],
        ),
        AppSegmentedButton<_Range>(
          segments: _Range.values
              .map((_Range r) => AppSegment<_Range>(value: r, label: r.label))
              .toList(),
          value: range,
          onChanged: onRangeChanged,
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({
    required this.accounts,
    required this.mrr,
    required this.seats,
  });

  final List<Account> accounts;
  final double mrr;
  final int seats;

  @override
  Widget build(BuildContext context) {
    final int active = accounts
        .where((Account a) => a.status == AccountStatus.active)
        .length;
    final int atRisk = accounts
        .where((Account a) => a.status == AccountStatus.pastDue)
        .length;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth > 900 ? 4 : 2;
        const double gap = AppSpacings.s16;
        // O `clamp` não é paranoia: o `AppShell` mede o conteúdo com largura
        // zero em uma das passadas (a animação de colapso do rail passa por
        // lá), e `(0 - 16) / 2` dá -8 — que o `SizedBox` rejeita com
        // "BoxConstraints has a negative minimum width", derrubando o layout
        // inteiro da tela em cascata.
        final double width =
            ((constraints.maxWidth - gap * (columns - 1)) / columns).clamp(
              0.0,
              double.infinity,
            );
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            SizedBox(
              width: width,
              child: _Kpi(
                label: 'Monthly recurring',
                value: '\$${(mrr / 1000).toStringAsFixed(1)}k',
                delta: '+12.4%',
                good: true,
              ),
            ),
            SizedBox(
              width: width,
              child: _Kpi(
                label: 'Active accounts',
                value: '$active',
                delta: '+3',
                good: true,
              ),
            ),
            SizedBox(
              width: width,
              child: _Kpi(
                label: 'Seats in use',
                value: '$seats',
                delta: '+186',
                good: true,
              ),
            ),
            SizedBox(
              width: width,
              child: _Kpi(
                label: 'Past due',
                value: '$atRisk',
                delta: '+1',
                good: false,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.delta,
    required this.good,
    required this.label,
    required this.value,
  });

  final String delta;
  final bool good;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium.withColor(
              theme.colorTheme.neutralPrimary.s700,
            ),
          ),
          const SizedBox(height: AppSpacings.s8),
          AppText(
            value,
            maxLines: 1,
            style: theme.textTheme.headlineMedium.withColor(
              theme.colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacings.s8),
          AppBadge(
            delta,
            color: good ? AppBadgeColor.success : AppBadgeColor.warning,
            size: AppBadgeSize.s,
          ),
        ],
      ),
    );
  }
}

class _Charts extends StatelessWidget {
  const _Charts({required this.accounts, required this.range});

  final List<Account> accounts;
  final _Range range;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    final int take = range.months;
    final List<double> revenue = kRevenueByMonth.sublist(
      kRevenueByMonth.length - take,
    );
    final List<double> signups = kNewAccountsByMonth.sublist(
      kNewAccountsByMonth.length - take,
    );
    final List<String> labels = kMonthLabels.sublist(
      kMonthLabels.length - take,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth > 900;
        final Widget trend = AppCard(
          child: AppChartShell(
            title: 'Recurring revenue',
            subtitle: 'In thousands of dollars',
            legendItems: <AppChartLegendItem>[
              AppChartLegendItem(
                color: theme.colorTheme.primary,
                label: 'MRR',
                valueLabel: '\$${revenue.last.toStringAsFixed(1)}k',
              ),
            ],
            child: AppLineChart(
              series: <AppCartesianChartSeries>[
                AppCartesianChartSeries(
                  id: 'mrr',
                  label: 'MRR',
                  points: <AppCartesianChartPoint>[
                    for (int i = 0; i < revenue.length; i++)
                      AppCartesianChartPoint(
                        x: i.toDouble(),
                        y: revenue[i],
                        label: labels[i],
                      ),
                  ],
                ),
              ],
              valueFormatter: (double v) => '\$${v.toStringAsFixed(0)}k',
            ),
          ),
        );

        final Widget mix = AppCard(
          child: AppChartShell(
            title: 'Plan mix',
            subtitle: 'Accounts per plan',
            child: AppDonutChart(
              segments: <AppPieChartSegment>[
                for (final AccountPlan plan in AccountPlan.values)
                  AppPieChartSegment(
                    label: plan.label,
                    value: accounts
                        .where((Account a) => a.plan == plan)
                        .length
                        .toDouble(),
                  ),
              ],
            ),
          ),
        );

        final Widget signupsChart = AppCard(
          child: AppChartShell(
            title: 'New accounts',
            subtitle: 'Signed per month',
            child: AppBarChart(
              labels: labels,
              series: <AppBarChartSeries>[
                AppBarChartSeries(id: 'signups', label: 'New', values: signups),
              ],
            ),
          ),
        );

        if (!wide) {
          return Column(
            children: <Widget>[
              trend,
              const SizedBox(height: AppSpacings.s16),
              signupsChart,
              const SizedBox(height: AppSpacings.s16),
              mix,
            ],
          );
        }
        return Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 2, child: trend),
                const SizedBox(width: AppSpacings.s16),
                Expanded(child: mix),
              ],
            ),
            const SizedBox(height: AppSpacings.s16),
            signupsChart,
          ],
        );
      },
    );
  }
}

class _StatusFilters extends StatelessWidget {
  const _StatusFilters({required this.hidden, required this.onToggle});

  final Set<AccountStatus> hidden;
  final ValueChanged<AccountStatus> onToggle;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return Row(
      children: <Widget>[
        AppText(
          'Accounts',
          style: theme.textTheme.titleMedium.withColor(
            theme.colorTheme.onSurface,
          ),
        ),
        const SizedBox(width: AppSpacings.s16),
        Expanded(
          child: Wrap(
            spacing: AppSpacings.s8,
            runSpacing: AppSpacings.s8,
            children: <Widget>[
              for (final AccountStatus status in AccountStatus.values)
                if (!hidden.contains(status))
                  AppFilterChip(
                    field: 'Status',
                    value: status.label,
                    onRemove: () => onToggle(status),
                  )
                else
                  AppButton(
                    label: status.label,
                    size: AppButtonSize.s,
                    style: AppStyle.outlined,
                    color: AppButtonColor.neutral,
                    icon: AppIconToken.plus,
                    onPressed: () => onToggle(status),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountCell extends StatelessWidget {
  const _AccountCell({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppText(
          account.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium.withColor(
            theme.colorTheme.onSurface,
          ),
        ),
        AppText(
          account.id,
          maxLines: 1,
          style: theme.textTheme.labelSmall.withColor(
            theme.colorTheme.neutralPrimary.s600,
          ),
        ),
      ],
    );
  }
}
