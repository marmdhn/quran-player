import 'package:quran_player/core/services/api_instance.dart';

import '../models/recreiter.dart';

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
}
