import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/di/locator.dart';
import '../../data/models/ayah_model.dart';
import '../../data/repository/quran_repository.dart';

class AudioPlayerViewModel extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  final QuranRepository _repo = getIt<QuranRepository>();

  bool isLoading = false;

  int _currentAyahIndex = 0;
  bool isSurahFinished = false;
  SurahDetailModel? ayahList;

  AudioPlayerViewModel() {
    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        isSurahFinished = true;
        notifyListeners();
      }
    });
  }

  Future<void> fetchSurahAudioList(String reciterId, int selectedSurah) async {
    isLoading = true;
    isSurahFinished = false;
    notifyListeners();

    try {
      ayahList = await _repo.getSurahAudioList(selectedSurah, reciterId);
      if (ayahList != null && ayahList!.ayahs.isNotEmpty) {
        _currentAyahIndex = 0;
        _preparePlaylist();
      }
    } catch (e) {
      debugPrint('Error fetch surah audio list: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _preparePlaylist() async {
    if (ayahList == null || ayahList!.ayahs.isEmpty) return;

    final playlist = ayahList!.ayahs
        .map((ayah) => AudioSource.uri(Uri.parse(ayah.audio)))
        .toList();

    await audioPlayer.setAudioSources(
      playlist,
      initialIndex: _currentAyahIndex,
    );
  }

  void play() => audioPlayer.play();
  void pause() => audioPlayer.pause();
  void next() => audioPlayer.seekToNext();
  void previous() => audioPlayer.seekToPrevious();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
