import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view-models/quran_player_view_model.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final List<Map<String, dynamic>> surahList = [
    {"number": 1, "englishName": "Al-Fatihah", "name": "الفاتحة"},
    {"number": 2, "englishName": "Al-Baqarah", "name": "البقرة"},
    {"number": 3, "englishName": "Ali 'Imran", "name": "آل عمران"},
    {"number": 4, "englishName": "An-Nisa'", "name": "النساء"},
    {"number": 5, "englishName": "Al-Ma'idah", "name": "المائدة"},
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuranPlayerViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text(viewModel.selectedReciter ?? "Reciter")),
      body: ListView.builder(
        itemCount: surahList.length,
        itemBuilder: (context, index) {
          final surah = surahList[index];
          return ListTile(
            leading: Text(
              "${surah['number']}".padLeft(2, '0'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            title: Text(surah['englishName']),
            subtitle: Text(
              surah['name'],
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 18),
            ),
          );
        },
      ),
    );
  }
}
