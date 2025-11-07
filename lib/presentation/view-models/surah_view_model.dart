import 'package:flutter/material.dart';

import '../../core/di/locator.dart';
import '../../data/models/surah_model.dart';
import '../../data/repository/quran_repository.dart';

class SurahViewModel extends ChangeNotifier {
  final QuranRepository _repo = getIt<QuranRepository>();

  bool isLoading = false;
  List<SurahModel> surahList = [];
  int? selectedSurah;

  void setSelectedSurah(int number) {
    selectedSurah = number;
    notifyListeners();
  }

  Future<void> fetchSurahList() async {
    isLoading = true;
    notifyListeners();

    try {
      surahList = await _repo.getSurah();
    } catch (e) {
      debugPrint('Error fetch surah list: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
