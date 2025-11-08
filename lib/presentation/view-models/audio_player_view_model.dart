import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_player/presentation/view-models/surah_view_model.dart';

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

  Future<void> nextSurah(
    String reciterId,
    int currentSurah,
    SurahViewModel surahVM,
  ) async {
    final next = surahVM.getNextSurah(currentSurah);
    if (next != null) {
      await fetchSurahAudioList(reciterId, next.number);
      surahVM.setSelectedSurah(next.number);
    } else {
      debugPrint('Sudah surah terakhir');
    }
  }

  Future<void> previousSurah(
    String reciterId,
    int currentSurah,
    SurahViewModel surahVM,
  ) async {
    final prev = surahVM.getPreviousSurah(currentSurah);
    if (prev != null) {
      await fetchSurahAudioList(reciterId, prev.number);
      surahVM.setSelectedSurah(prev.number);
    } else {
      debugPrint('Sudah surah pertama');
    }
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
