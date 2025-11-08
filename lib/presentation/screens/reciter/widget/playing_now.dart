import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/constant.dart';
import '../../../../data/static/reciter_images.dart';
import '../../../shared/widgets/reciter_avatar.dart';
import '../../../view-models/audio_player_view_model.dart';
import '../../../view-models/reciter_view_model.dart';

class PlayingNow extends StatefulWidget {
  const PlayingNow({super.key});

  @override
  State<PlayingNow> createState() => _PlayingNowState();
}

class _PlayingNowState extends State<PlayingNow> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playerVM = context.read<AudioPlayerViewModel>();

      playerVM.audioPlayer.playingStream.listen((isPlaying) {
        if (isPlaying && mounted) {
          setState(() => _isVisible = true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerVM = context.watch<AudioPlayerViewModel>();
    final reciterVM = context.watch<ReciterViewModel>();

    if (!_isVisible) return const SizedBox.shrink();

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
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.dark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ReciterAvatar(
                    imagePath:
                        reciterImages[reciterVM.selectedReciterIdentifier],
                    size: 48,
                    borderRadius: 8,
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
            Positioned(
              top: -16,
              right: -16,
              child: IconButton(
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
                icon: const Icon(Icons.close, color: Colors.white, size: 18),
                onPressed: () => setState(() => _isVisible = false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
