import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_player/presentation/screens/reciter/widget/playing_now.dart';
import 'package:quran_player/presentation/shared/widgets/loading_indicator.dart';

import '../../../core/config/colors.dart';
import '../../../data/static/reciter_images.dart';
import '../../shared/widgets/reciter_avatar.dart';
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
                  PlayingNow(),

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
                          leading: ReciterAvatar(imagePath: imagePath),
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
