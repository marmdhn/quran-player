class AyahModel {
  final int number;
  final String text;
  final String audio;

  AyahModel({required this.number, required this.text, required this.audio});

  factory AyahModel.fromMap(Map<String, dynamic> map) {
    return AyahModel(
      number: map['number'] ?? 0,
      text: map['text'] ?? '',
      audio: map['audio'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'number': number, 'text': text, 'audio': audio};
  }

  @override
  String toString() {
    return 'AyahModel(number: $number, text: $text, audio: $audio)';
  }
}

class SurahDetailModel {
  final String englishName;
  final List<AyahModel> ayahs;

  SurahDetailModel({required this.englishName, required this.ayahs});

  factory SurahDetailModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'];
    final ayahs = (data['ayahs'] as List)
        .map((e) => AyahModel.fromMap(e))
        .toList();

    return SurahDetailModel(
      englishName: data['englishName'] ?? '',
      ayahs: ayahs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'englishName': englishName,
      'ayahs': ayahs.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'SurahDetailModel(englishName: $englishName, ayahs: $ayahs)';
  }
}
