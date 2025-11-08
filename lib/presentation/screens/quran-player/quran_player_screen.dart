import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:quran_player/core/utils/size_config.dart';

import '../../../core/config/colors.dart';
import '../../../data/static/reciter_images.dart';
import '../../shared/widgets/reciter_avatar.dart';
import '../../view-models/audio_player_view_model.dart';
import '../../view-models/reciter_view_model.dart';
import '../../view-models/surah_view_model.dart';

class QuranPlayerScreen extends StatefulWidget {
  const QuranPlayerScreen({super.key});

  @override
  State<QuranPlayerScreen> createState() => _QuranPlayerScreenState();
}

class _QuranPlayerScreenState extends State<QuranPlayerScreen> {
  StreamSubscription<ProcessingState>? _processingStateSub;
  bool _isHandlingNextSurah = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final reciterVM = context.read<ReciterViewModel>();
      final playerVM = context.read<AudioPlayerViewModel>();
      final surahVM = context.read<SurahViewModel>();

      if (reciterVM.selectedReciterIdentifier != null) {
        playerVM.fetchSurahAudioList(
          reciterVM.selectedReciterIdentifier!,
          surahVM.selectedSurah!,
        );
      } else {
        debugPrint('Reciter belum dipilih');
      }

      _processingStateSub = playerVM.audioPlayer.processingStateStream.listen((
        state,
      ) async {
        if (state == ProcessingState.completed && !_isHandlingNextSurah) {
          _isHandlingNextSurah = true;

          final nextSurah = surahVM.getNextSurah(surahVM.selectedSurah!);
          if (nextSurah != null) {
            debugPrint('Lanjut ke surah berikutnya: ${nextSurah.englishName}');
            await playerVM.fetchSurahAudioList(
              reciterVM.selectedReciterIdentifier!,
              nextSurah.number,
            );
            surahVM.setSelectedSurah(nextSurah.number);
          } else {
            debugPrint('Sudah surah terakhir.');
          }

          _isHandlingNextSurah = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final reciterVM = context.watch<ReciterViewModel>();
    final playerVM = context.watch<AudioPlayerViewModel>();

    final imagePath = reciterImages[reciterVM.selectedReciterIdentifier];

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -SizeConfig.height(0.4),
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/ornaments/img-gradient-bg.png',
                width: SizeConfig.screenWidth,
                height: SizeConfig.height(1.2),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ReciterAvatar(
                    imagePath: imagePath,
                    size: SizeConfig.height(0.4),
                    borderRadius: 20,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playerVM.isLoading
                                ? 'Loading...'
                                : playerVM.ayahList?.englishName ?? 'Surah',
                            style: const TextStyle(
                              fontSize: 28,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reciterVM.selectedReciter ?? 'Reciter',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.playlist_play_outlined,
                          color: AppColors.white,
                          size: 36,
                        ),
                        tooltip: 'PlayList',
                        onPressed: () {
                          Navigator.pushNamed(context, '/surahList');
                        },
                      ),
                    ],
                  ),

                  const Spacer(),

                  StreamBuilder<Duration?>(
                    stream: playerVM.audioPlayer.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration>(
                        stream: playerVM.audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;

                          String formatDuration(Duration d) {
                            final minutes = d.inMinutes
                                .remainder(60)
                                .toString()
                                .padLeft(2, '0');
                            final seconds = d.inSeconds
                                .remainder(60)
                                .toString()
                                .padLeft(2, '0');
                            return '$minutes:$seconds';
                          }

                          return Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: SliderComponentShape.noThumb,
                                  activeTrackColor: AppColors.white,
                                  inactiveTrackColor: Colors.grey.shade700,
                                  trackHeight: 4,
                                ),
                                child: Slider(
                                  min: 0,
                                  max: duration.inMilliseconds.toDouble(),
                                  value: position.inMilliseconds
                                      .clamp(0, duration.inMilliseconds)
                                      .toDouble(),
                                  onChanged: (value) {
                                    playerVM.audioPlayer.seek(
                                      Duration(milliseconds: value.toInt()),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatDuration(position),
                                      style: const TextStyle(
                                        color: AppColors.white,
                                      ),
                                    ),
                                    Text(
                                      formatDuration(duration),
                                      style: const TextStyle(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 36,
                        color: AppColors.white,
                        icon: const Icon(Icons.skip_previous_rounded),
                        onPressed: () {
                          final reciterVM = context.read<ReciterViewModel>();
                          final playerVM = context.read<AudioPlayerViewModel>();
                          final surahVM = context.read<SurahViewModel>();

                          playerVM.previousSurah(
                            reciterVM.selectedReciterIdentifier!,
                            surahVM.selectedSurah!,
                            surahVM,
                          );
                        },
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.dark,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 80,
                        height: 80,
                        child: IconButton(
                          iconSize: 40,
                          color: AppColors.white,
                          icon: Icon(
                            playerVM.audioPlayer.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          onPressed: () {
                            if (playerVM.audioPlayer.playing) {
                              playerVM.pause();
                            } else {
                              playerVM.play();
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        iconSize: 36,
                        color: AppColors.white,
                        icon: const Icon(Icons.skip_next_rounded),
                        onPressed: () {
                          final reciterVM = context.read<ReciterViewModel>();
                          final playerVM = context.read<AudioPlayerViewModel>();
                          final surahVM = context.read<SurahViewModel>();

                          playerVM.nextSurah(
                            reciterVM.selectedReciterIdentifier!,
                            surahVM.selectedSurah!,
                            surahVM,
                          );
                        },
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
