class MeansOfPaymentEntity {
  final String name;
  final String? id;
  final String icon;
  final List<MeansOfPaymentEntity>? items;

  MeansOfPaymentEntity({
    required this.name,
    required this.id,
    required this.icon,
    this.items,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeansOfPaymentEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

List<MeansOfPaymentEntity> MEANS_OF_PAYEMENT = [
  MeansOfPaymentEntity(
    name: "Cash",
    id: "d8b8d45d-da79-478f-9d5f-693b33d654e6",
    icon: "assets/images/cash_logo.png",
  ),
  MeansOfPaymentEntity(
      name: "TPE",
      id: "5b5a6cc7-dd4f-4b9f-aef1-3cc5ccac30bf",
      icon: "assets/images/carte_bancaire.png"),
  mobile,
  MeansOfPaymentEntity(
      name: "Autre",
      id: "0017bf5f-4530-42dd-9dcd-7bd5067c757a",
      icon: "assets/images/cheque.png"),
];

final mobile = MeansOfPaymentEntity(
  name: "Mobile",
  id: null,
  icon: "assets/images/mobile-ic.png",
  items: [
    MeansOfPaymentEntity(
        name: "OM",
        id: "7be4b57e-02a6-4c4f-b3a0-13597554fb5d",
        icon: "assets/svgs/omoney.svg"),
    MeansOfPaymentEntity(
        name: "MTN M",
        id: "7af1ade3-8079-48ea-90bf-23cc06ea66ca",
        icon: "assets/svgs/momo.svg"),
    MeansOfPaymentEntity(
        name: "Wave",
        id: "6efbbe2d-3066-4a03-b52c-cb28f1990f44",
        icon: "assets/images/wave.png"),
  ],
);
