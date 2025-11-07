import 'package:quran_player/core/services/api_instance.dart';

import '../models/ayah_model.dart';
import '../models/recreiter_model.dart';
import '../models/surah_model.dart';

class QuranRepository {
  Future<List<ReciterModel>> getReciterList() async {
    try {
      final response = await apiAlQuran.get('edition?format=audio');

      final data = response['data'] as List;

      return data.map((e) => ReciterModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Error fetching reciters: $e');
    }
  }

  Future<List<SurahModel>> getSurah() async {
    try {
      final response = await apiAlQuran.get('surah');

      final data = response['data'] as List;

      return data.map((e) => SurahModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Error fetching reciters: $e');
    }
  }

  Future<SurahDetailModel> getSurahAudioList(
    int surahId,
    String reciterIdentifier,
  ) async {
    try {
      final response = await apiAlQuran.get(
        'surah/$surahId/$reciterIdentifier',
      );

      return SurahDetailModel.fromMap(response);
    } catch (e) {
      throw Exception('Error fetching surah audio list: $e');
    }
  }
}
