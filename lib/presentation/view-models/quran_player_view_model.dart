import 'package:flutter/material.dart';

import '../../core/di/locator.dart';
import '../../data/models/recreiter.dart';
import '../../data/repository/quran_repository.dart';

class QuranPlayerViewModel extends ChangeNotifier {
  final QuranRepository _repo = getIt<QuranRepository>();
  bool isLoading = false;
  List<ReciterModel> reciters = [];

  String? selectedReciter;

  void setSelectedReciter(String reciter) {
    selectedReciter = reciter;
    notifyListeners();
  }

  Future<void> fetchReciters() async {
    isLoading = true;
    notifyListeners();

    try {
      reciters = await _repo.getReciterList();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
