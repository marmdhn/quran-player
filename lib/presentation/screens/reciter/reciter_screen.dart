import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/recreiter.dart';
import '../../view-models/quran_player_view_model.dart';

class ReciterScreen extends StatefulWidget {
  const ReciterScreen({super.key});

  @override
  State<ReciterScreen> createState() => _ReciterScreenState();
}

class _ReciterScreenState extends State<ReciterScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<QuranPlayerViewModel>(
        context,
        listen: false,
      ).fetchReciters(),
    );
  }

  final Map<String, String> reciterImages = {
    'ar.abdurrahmaansudais': 'assets/images/reciters/img-figure-1.png',
  };

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuranPlayerViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alquran Player',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
            onPressed: () async {
              await viewModel.fetchReciters();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data reciter berhasil diperbarui'),
                ),
              );
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.reciters.isEmpty) {
            return const Center(child: Text('Tidak ada data reciter.'));
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.fetchReciters(),
            child: ListView.separated(
              itemCount: viewModel.reciters.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Colors.grey, thickness: 0.3, height: 1),
              itemBuilder: (context, index) {
                final ReciterModel reciter = viewModel.reciters[index];
                final imagePath = reciterImages[reciter.identifier];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
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
                                color: Colors.white,
                              ),
                            ),
                    ),
                    title: Text(
                      reciter.englishName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      viewModel.setSelectedReciter(reciter.englishName);
                      Navigator.pushNamed(context, '/surahList');
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
