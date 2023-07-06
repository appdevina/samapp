part of 'models.dart';

class PlanVisitModel extends Equatable {
  final int? id;
  final DateTime? tanggalVisit;
  final OutletModel? outlet;
  final NooModel? nooOutlet;

  PlanVisitModel({
    this.id,
    this.tanggalVisit,
    this.outlet,
    this.nooOutlet,
  });

  PlanVisitModel copyWith({
    int? id,
    DateTime? tanggalVisit,
    UserModel? user,
    OutletModel? outlet,
    NooModel? nooModel,
  }) {
    return PlanVisitModel(
      id: id ?? this.id,
      tanggalVisit: tanggalVisit ?? this.tanggalVisit,
      outlet: outlet ?? this.outlet,
      nooOutlet: nooOutlet ?? this.nooOutlet,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tanggalVisit,
        outlet,
        nooOutlet,
      ];

  factory PlanVisitModel.fromJson(Map<String, dynamic> json) => PlanVisitModel(
        id: json["id"],
        tanggalVisit:
            DateTime.fromMillisecondsSinceEpoch(json['tanggal_visit']),
        outlet: json["outlet"] != null
            ? OutletModel.fromJson(json["outlet"])
            : null,
        nooOutlet: json["nooOutlet"] != null
            ? NooModel.fromJson(json["nooOutlet"])
            : null,
      );
}
