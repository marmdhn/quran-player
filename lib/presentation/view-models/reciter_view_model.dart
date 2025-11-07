import 'package:flutter/material.dart';

import '../../core/di/locator.dart';
import '../../data/models/recreiter_model.dart';
import '../../data/repository/quran_repository.dart';

class ReciterViewModel extends ChangeNotifier {
  final QuranRepository _repo = getIt<QuranRepository>();

  bool isLoading = false;
  List<ReciterModel> reciters = [];
  String? selectedReciter;
  String? selectedReciterIdentifier;

  void setSelectedReciter(String reciter) {
    selectedReciter = reciter;
    notifyListeners();
  }

  void setSelectedReciterIdentifier(String id) {
    selectedReciterIdentifier = id;
    notifyListeners();
  }

  Future<void> fetchReciters() async {
    isLoading = true;
    notifyListeners();

    try {
      reciters = await _repo.getReciterList();
    } catch (e) {
      debugPrint('Error fetch reciters: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
