import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_player/core/config/constant.dart';
import 'package:quran_player/presentation/shared/widgets/loading_indicator.dart';

import '../../../data/models/surah_model.dart';
import '../../view-models/reciter_view_model.dart';
import '../../view-models/surah_view_model.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final surahVM = context.read<SurahViewModel>();

      surahVM.fetchSurahList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reciterVM = context.watch<ReciterViewModel>();
    final surahVM = context.watch<SurahViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            reciterVM.selectedReciter ?? "Reciter",
            style: TextStyle(fontSize: 16),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Builder(
        builder: (context) {
          if (surahVM.isLoading) {
            return const Center(child: LoadingIndicator());
          }

          if (surahVM.surahList.isEmpty) {
            return const Center(child: Text("Tidak ada data surah."));
          }

          return ListView.separated(
            itemCount: surahVM.surahList.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.grey, thickness: 0.3, height: 1),
            itemBuilder: (context, index) {
              final SurahModel surah = surahVM.surahList[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 15,
                ),
                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/ornaments/img-frame-ayat.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      surah.number.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: AppConstants.kFontSize,
                      ),
                    ),
                  ),

                  title: Text(
                    surah.englishName,
                    style: TextStyle(fontSize: AppConstants.kFontSize),
                  ),

                  trailing: Text(
                    surah.name,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: AppConstants.kFontSize),
                  ),
                  onTap: () {
                    surahVM.setSelectedSurah(surah.number);
                    Navigator.pushNamed(context, '/quranPlayer');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
