class CloudModel {
  CloudModel({
    required this.recitations,
  });

  final List<Recitation> recitations;

  factory CloudModel.fromJson(Map<String, dynamic> json) {
    return CloudModel(
      recitations: json["recitations"] == null
          ? []
          : List<Recitation>.from(
              json["recitations"]!.map((x) => Recitation.fromJson(x))),
    );
  }
}

class Recitation {
  Recitation({
    required this.id,
    required this.reciterName,
    required this.style,
    required this.translatedName,
  });

  final int? id;
  final String? reciterName;
  final String? style;
  final TranslatedName? translatedName;

  factory Recitation.fromJson(Map<String, dynamic> json) {
    return Recitation(
      id: json["id"],
      reciterName: json["reciter_name"],
      style: json["style"],
      translatedName: json["translated_name"] == null
          ? null
          : TranslatedName.fromJson(json["translated_name"]),
    );
  }
}

class TranslatedName {
  TranslatedName({
    required this.name,
    required this.languageName,
  });

  final String? name;
  final String? languageName;

  factory TranslatedName.fromJson(Map<String, dynamic> json) {
    return TranslatedName(
      name: json["name"],
      languageName: json["language_name"],
    );
  }
}
