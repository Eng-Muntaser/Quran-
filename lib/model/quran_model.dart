class QuranModel {
  QuranModel({
    required this.data,
  });

  final List<Datum> data;

  factory QuranModel.fromJson(Map<String, dynamic> json) {
    return QuranModel(
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.id,
    required this.audio,
    required this.name,
    required this.startPage,
    required this.endPage,
    required this.makkia,
    required this.type,
  });

  final int? id;
  final String? audio;
  final String? name;
  final num? startPage;
  final num? endPage;
  final num? makkia;
  final num? type;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      audio: json["audio"],
      name: json["name"],
      startPage: json["start_page"],
      endPage: json["end_page"],
      makkia: json["makkia"],
      type: json["type"],
    );
  }
}
