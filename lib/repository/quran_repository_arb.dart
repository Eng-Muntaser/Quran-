import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quraan/model/quran_model.dart';

const suraDataAr = "assets/sura_name_ar.json";
const suraDataEng = "assets/sura_name_eng.json";
const suraDataFr = "assets/sura_name_fr.json"; // Added French language support

class AudioQuranRepository {
  Future<List<Datum>> getAudioQuran(String languageCode) async {
    String dataFilePath;

    // Determine the file path based on the language code
    if (languageCode == 'ar') {
      dataFilePath = suraDataAr;
    } else if (languageCode == 'fr') {
      // French language support
      dataFilePath = suraDataFr;
    } else {
      dataFilePath = suraDataEng;
    }

    var response = await rootBundle.loadString(dataFilePath);
    final List result = jsonDecode(response)["suwar"];
    print(result);
    return result.map((e) => Datum.fromJson(e)).toList();
  }
}
