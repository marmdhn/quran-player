import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_player/core/config/constant.dart';
import 'package:quran_player/presentation/shared/widgets/loading_indicator.dart';

import '../../../core/config/colors.dart';
import '../../../data/static/reciter_images.dart';
import '../../view-models/audio_player_view_model.dart';
import '../../view-models/reciter_view_model.dart';

class ReciterScreen extends StatefulWidget {
  const ReciterScreen({super.key});

  @override
  State<ReciterScreen> createState() => _ReciterScreenState();
}

class _ReciterScreenState extends State<ReciterScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final reciterVM = context.read<ReciterViewModel>();
      if (reciterVM.reciters.isEmpty) {
        reciterVM.fetchReciters();
      }

      for (var imgPath in reciterImages.values) {
        precacheImage(AssetImage(imgPath), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reciterVM = context.watch<ReciterViewModel>();
    final playerVM = context.watch<AudioPlayerViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alquran Player',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Builder(
          builder: (context) {
            if (reciterVM.isLoading) {
              return const Center(child: LoadingIndicator());
            }

            if (reciterVM.reciters.isEmpty) {
              return const Center(child: Text('Tidak ada data reciter.'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (playerVM.ayahList != null &&
                    reciterVM.selectedReciter != null &&
                    !playerVM.isSurahFinished)
                  PlayingNowWidget(),

                Expanded(
                  child: ListView.separated(
                    itemCount: reciterVM.reciters.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                      thickness: 0.3,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final reciter = reciterVM.reciters[index];
                      final imagePath = reciterImages[reciter.identifier];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imagePath != null
                                ? Image.asset(
                                    imagePath,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.grey.shade800,
                                    child: const Icon(
                                      Icons.person,
                                      color: AppColors.white,
                                    ),
                                  ),
                          ),
                          title: Text(
                            reciter.englishName,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: kDefaultFontSize,
                            ),
                          ),
                          onTap: () {
                            reciterVM.setSelectedReciter(reciter.englishName);
                            reciterVM.setSelectedReciterIdentifier(
                              reciter.identifier,
                            );
                            Navigator.pushNamed(context, '/surahList');
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PlayingNowWidget extends StatelessWidget {
  const PlayingNowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playerVM = context.watch<AudioPlayerViewModel>();
    final reciterVM = context.watch<ReciterViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sedang diputar",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: AppConstants.kFontSize,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
          decoration: BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    reciterImages[reciterVM.selectedReciterIdentifier] != null
                    ? Image.asset(
                        reciterImages[reciterVM.selectedReciterIdentifier]!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 48,
                        height: 48,
                        color: Colors.grey.shade700,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playerVM.ayahList!.englishName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: AppConstants.kFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${reciterVM.selectedReciter}',
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<bool>(
                stream: playerVM.audioPlayer.playingStream,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data ?? false;
                  return IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: AppColors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        playerVM.pause();
                      } else {
                        playerVM.play();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
