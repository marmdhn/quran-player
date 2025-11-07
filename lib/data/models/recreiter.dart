class ReciterModel {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;

  ReciterModel({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
  });

  factory ReciterModel.fromMap(Map<String, dynamic> map) {
    return ReciterModel(
      identifier: map['identifier'] ?? '',
      language: map['language'] ?? '',
      name: map['name'] ?? '',
      englishName: map['englishName'] ?? '',
      format: map['format'] ?? '',
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier,
      'language': language,
      'name': name,
      'englishName': englishName,
      'format': format,
      'type': type,
    };
  }
}
