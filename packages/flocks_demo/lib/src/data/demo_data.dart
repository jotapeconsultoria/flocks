import 'package:flocks/flocks.dart';

/// Onde uma conta está no ciclo de vida.
enum AccountStatus {
  active('Active', AppBadgeColor.success),
  trial('Trial', AppBadgeColor.info),
  pastDue('Past due', AppBadgeColor.warning),
  churned('Churned', AppBadgeColor.danger);

  const AccountStatus(this.label, this.badge);

  /// O rótulo na tela.
  final String label;

  /// O papel semântico — e não uma cor. É por isso que o status continua
  /// legível depois que o visitante troca a semente da marca: `success` é um
  /// papel que o tema resolve, não um verde escrito à mão.
  final AppBadgeColor badge;
}

/// Os planos que a demo vende.
enum AccountPlan {
  starter('Starter'),
  growth('Growth'),
  scale('Scale');

  const AccountPlan(this.label);

  /// O rótulo na tela.
  final String label;
}

/// Uma conta — a entidade que a demo lê no dashboard e escreve no CRUD.
class Account {
  /// Cria uma conta.
  Account({
    required this.id,
    required this.name,
    required this.owner,
    required this.plan,
    required this.status,
    required this.seats,
    required this.mrr,
    required this.renewsOn,
  });

  /// Identificador estável — a chave da lista e do formulário.
  final String id;

  /// Nome da conta.
  String name;

  /// E-mail de quem responde por ela.
  String owner;

  /// Plano contratado.
  AccountPlan plan;

  /// Situação no ciclo de vida.
  AccountStatus status;

  /// Assentos contratados.
  int seats;

  /// Receita recorrente mensal, em dólares.
  double mrr;

  /// Quando a assinatura renova.
  DateTime renewsOn;

  /// Cópia independente — o formulário edita a cópia e só grava no salvar,
  /// que é o que faz o botão "Cancel" significar alguma coisa.
  Account copy() => Account(
    id: id,
    name: name,
    owner: owner,
    plan: plan,
    status: status,
    seats: seats,
    mrr: mrr,
    renewsOn: renewsOn,
  );
}

/// A carteira inicial da demo.
///
/// Dados sintéticos e determinísticos: nenhuma chamada de rede, nenhum
/// `Random` sem semente. Uma demo que sorteia números conta uma história
/// diferente a cada recarga, e um link compartilhado deixa de mostrar ao
/// destinatário o que o remetente viu.
List<Account> seedAccounts() => <Account>[
  Account(
    id: 'ACC-1042',
    name: 'Northwind Logistics',
    owner: 'ana@northwind.example',
    plan: AccountPlan.scale,
    status: AccountStatus.active,
    seats: 240,
    mrr: 8400,
    renewsOn: DateTime(2026, 9, 14),
  ),
  Account(
    id: 'ACC-1043',
    name: 'Vertex Analytics',
    owner: 'bruno@vertex.example',
    plan: AccountPlan.growth,
    status: AccountStatus.active,
    seats: 86,
    mrr: 3120,
    renewsOn: DateTime(2026, 8, 30),
  ),
  Account(
    id: 'ACC-1051',
    name: 'Harbor Health',
    owner: 'carla@harbor.example',
    plan: AccountPlan.growth,
    status: AccountStatus.pastDue,
    seats: 54,
    mrr: 1980,
    renewsOn: DateTime(2026, 8, 19),
  ),
  Account(
    id: 'ACC-1067',
    name: 'Atlas Manufacturing',
    owner: 'diego@atlas.example',
    plan: AccountPlan.scale,
    status: AccountStatus.active,
    seats: 410,
    mrr: 12750,
    renewsOn: DateTime(2026, 11, 2),
  ),
  Account(
    id: 'ACC-1074',
    name: 'Bright Retail',
    owner: 'elena@bright.example',
    plan: AccountPlan.starter,
    status: AccountStatus.trial,
    seats: 12,
    mrr: 0,
    renewsOn: DateTime(2026, 8, 24),
  ),
  Account(
    id: 'ACC-1080',
    name: 'Corvus Media',
    owner: 'felipe@corvus.example',
    plan: AccountPlan.starter,
    status: AccountStatus.churned,
    seats: 8,
    mrr: 0,
    renewsOn: DateTime(2026, 7, 31),
  ),
  Account(
    id: 'ACC-1092',
    name: 'Lumen Energy',
    owner: 'gabi@lumen.example',
    plan: AccountPlan.growth,
    status: AccountStatus.active,
    seats: 132,
    mrr: 4600,
    renewsOn: DateTime(2026, 10, 8),
  ),
  Account(
    id: 'ACC-1103',
    name: 'Kestrel Legal',
    owner: 'hugo@kestrel.example',
    plan: AccountPlan.starter,
    status: AccountStatus.trial,
    seats: 6,
    mrr: 0,
    renewsOn: DateTime(2026, 8, 27),
  ),
  Account(
    id: 'ACC-1118',
    name: 'Sable Foods',
    owner: 'iris@sable.example',
    plan: AccountPlan.growth,
    status: AccountStatus.active,
    seats: 74,
    mrr: 2640,
    renewsOn: DateTime(2026, 12, 1),
  ),
  Account(
    id: 'ACC-1125',
    name: 'Orbit Robotics',
    owner: 'joao@orbit.example',
    plan: AccountPlan.scale,
    status: AccountStatus.active,
    seats: 305,
    mrr: 9900,
    renewsOn: DateTime(2026, 9, 21),
  ),
  Account(
    id: 'ACC-1131',
    name: 'Perch Education',
    owner: 'kim@perch.example',
    plan: AccountPlan.starter,
    status: AccountStatus.pastDue,
    seats: 21,
    mrr: 620,
    renewsOn: DateTime(2026, 8, 16),
  ),
  Account(
    id: 'ACC-1140',
    name: 'Quarry Construction',
    owner: 'lea@quarry.example',
    plan: AccountPlan.growth,
    status: AccountStatus.active,
    seats: 98,
    mrr: 3480,
    renewsOn: DateTime(2026, 10, 27),
  ),
];

/// Receita recorrente dos últimos 12 meses, em milhares.
const List<double> kRevenueByMonth = <double>[
  28.4,
  30.1,
  31.7,
  33.9,
  35.2,
  34.8,
  37.6,
  40.3,
  42.1,
  44.8,
  46.2,
  49.5,
];

/// Novos contratos por mês, no mesmo período de [kRevenueByMonth].
const List<double> kNewAccountsByMonth = <double>[
  6,
  8,
  5,
  9,
  11,
  7,
  12,
  14,
  10,
  15,
  13,
  17,
];

/// Rótulos dos 12 meses.
const List<String> kMonthLabels = <String>[
  'Sep',
  'Oct',
  'Nov',
  'Dec',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
];
