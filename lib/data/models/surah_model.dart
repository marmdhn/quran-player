class SurahModel {
  final int number;
  final String name;
  final String englishName;
  final int numberOfAyahs;

  SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.numberOfAyahs,
  });

  factory SurahModel.fromMap(Map<String, dynamic> map) {
    return SurahModel(
      number: map['number'] ?? 0,
      name: map['name'] ?? '',
      englishName: map['englishName'] ?? '',
      numberOfAyahs: map['numberOfAyahs'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'numberOfAyahs': numberOfAyahs,
    };
  }
}
