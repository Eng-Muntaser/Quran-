import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quraan/model/reciters_model.dart';

class LocalRecitersRepository {
  Future<List<Reciter>> getLocalReciters(String language) async {
    String localRecitersData;

    // Determine the file path based on the language
    if (language == 'ar') {
      localRecitersData = "assets/local_reciters_arab.json";
    } else if (language == 'fr') {
      localRecitersData = "assets/local_reciters_fr.json";
    } else {
      localRecitersData = "assets/local_reciters_eng.json";
    }

    try {
      var response = await rootBundle.loadString(localRecitersData);

      final List result = jsonDecode(response)["reciters"];
      return result.map((e) => Reciter.fromJson(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
