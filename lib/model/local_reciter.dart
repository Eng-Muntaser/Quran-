class LocalReciters {
  LocalReciters({
    required this.reciters,
  });

  final List<Reciter> reciters;

  factory LocalReciters.fromJson(Map<String, dynamic> json) {
    return LocalReciters(
      reciters: json["reciters"] == null
          ? []
          : List<Reciter>.from(
              json["reciters"]!.map((x) => Reciter.fromJson(x))),
    );
  }
}

class Reciter {
  Reciter({
    required this.id,
    required this.name,
    required this.letter,
    required this.moshaf,
  });

  final int? id;
  final String? name;
  final String? letter;
  final List<Moshaf> moshaf;

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json["id"],
      name: json["name"],
      letter: json["letter"],
      moshaf: json["moshaf"] == null
          ? []
          : List<Moshaf>.from(json["moshaf"]!.map((x) => Moshaf.fromJson(x))),
    );
  }
}

class Moshaf {
  Moshaf({
    required this.id,
    required this.name,
    required this.server,
    required this.surahTotal,
    required this.moshafType,
    required this.surahList,
  });

  final int? id;
  final String? name;
  final String? server;
  final num? surahTotal;
  final num? moshafType;
  final String? surahList;

  factory Moshaf.fromJson(Map<String, dynamic> json) {
    return Moshaf(
      id: json["id"],
      name: json["name"],
      server: json["server"],
      surahTotal: json["surah_total"],
      moshafType: json["moshaf_type"],
      surahList: json["surah_list"],
    );
  }
}
